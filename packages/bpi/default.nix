{
  writeShellApplication,
  bubblewrap,
  pi-coding-agent,
}:
writeShellApplication {
  name = "bpi";
  runtimeInputs = [bubblewrap pi-coding-agent];
  text = ''
    # Use bubblewrap to run /bin/sh reusing the host OS binaries (/usr), but with
    # separate /tmp, /home, /var, /run, and /etc. For /etc we just inherit the
    # host's resolv.conf, and set up "stub" passwd/group files.  Not sharing
    # /home for example is intentional.  If you wanted to, you could design
    # a bwrap-using program that shared individual parts of /home, perhaps
    # public content.
    #
    # Another way to build on this example is to remove --share-net to disable
    # networking.

    function help() {
      echo "Launch Pi in a preconfigured bubblewrap sandbox"
      echo ""
      echo "Usage: bpi [OPTIONS] [-- PI_OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -h, --help                 Show this help text and quit"
      echo "  -e, --empty                Do not rw mount current folder, start Pi in empty ~"
      echo "  -p, --project <DIRECTORY>  Change to DIRECTORY (default .)"
      echo "      --ro <PATH>            Mount PATH read only in the sandbox"
      echo "      --rw <PATH>            Mount PATH for writing in the sandbox"
      echo "      --git-rw               Mount .git for writing in main directory (default ro)"
      echo "      --podman               Expose the host's rootless podman socket in the sandbox"
      echo ""
      echo "Pi options:"
      echo "  All arguments after the first -- will be passed to Pi"
    }

    function cli_error() {
      echo "Unknown argument $1"  1>&2
      echo "Run bpi -h for help" 1>&2
    }

    printf -v CLI_INVOCATION '%q ' "$0" "$@"
    CLI_INVOCATION="''${CLI_INVOCATION% }"   # trim trailing space

    EMPTY=0
    PROJECT="$PWD"
    GIT_RW=0
    PODMAN=0
    declare -a RO_MOUNTS=() RO_MOUNTS_TRY=() RW_MOUNTS=() PI_ARGS=()

    while [ $# -gt 0 ]; do
      case "$1" in
        -h|--help)        help; exit 0 ;;
        -e|--empty)       EMPTY=1; shift ;;
        -p|--project)     PROJECT="$2"; shift 2 ;;
        --ro)             RO_MOUNTS+=("$2"); shift 2 ;;
        --rw)             RW_MOUNTS+=("$2"); shift 2 ;;
        --git-rw)         GIT_RW=1; shift ;;
        --podman)         PODMAN=1; shift ;;
        --)               shift; PI_ARGS+=("$@"); break ;;
        *)                cli_error "$1"; exit 255;;
      esac
    done

    SANDBOX_NOTE="You are running inside a bubblewrap sandbox. The sandbox is maintained by the user and it's restrictive on purpose. "
    SANDBOX_NOTE+="If you need more permissive environment to finish a given task, flag that to the user and ask for the permissions you need. "
    SANDBOX_NOTE+="If you run into permission issues and need to know how exactly the sandbox works, look at the bpi script. "
    SANDBOX_NOTE+="The following few lines specify the current state of your sandbox:"$'\n'
    SANDBOX_NOTE+=" Sandbox was started with the following invocation: $CLI_INVOCATION"$'\n'
    SANDBOX_NOTE+=" Network access is allowed for your sandbox."$'\n'
    [ "$EMPTY" -eq 1 ] && SANDBOX_NOTE+=" Started with --empty: no project directory is mounted read-write, \$HOME is otherwise empty."$'\n'
    [ "$PODMAN" -eq 1 ] && SANDBOX_NOTE+=" The host's rootless podman socket is available (CONTAINER_HOST/DOCKER_HOST set). Prefer using podman to docker."$'\n'

    if [ "''${#RO_MOUNTS[@]}" -gt 0 ] || [ "''${#RW_MOUNTS[@]}" -gt 0 ]; then
      SANDBOX_NOTE+=" User gave you some extra mounts. These are usually documentation and other projects relevant"
      SANDBOX_NOTE+=" to your current tasks: feel free to explore them whenever needed."$'\n'
    fi

    [ "''${#RO_MOUNTS[@]}" -gt 0 ] && SANDBOX_NOTE+=" Extra read-only mounts: ''${RO_MOUNTS[*]}."$'\n'
    [ "''${#RW_MOUNTS[@]}" -gt 0 ] && SANDBOX_NOTE+=" Extra read-write mounts: ''${RW_MOUNTS[*]}."$'\n'

    PROJECT="$(realpath -e "$PROJECT")"
    if [ "$EMPTY" -eq 1 ]; then
      PROJECT="$HOME"
    fi

    RO_MAIN=0
    for d in "''${RO_MOUNTS[@]}"; do
      [ "$(realpath "$d")" = "$(realpath "$PROJECT")" ] && RO_MAIN=1;
    done

    if [ "$RO_MAIN" -eq 1 ]; then
      SANDBOX_NOTE+=" Your project/current directory is mounted read-only. The user"
      SANDBOX_NOTE+=" probably doesn't want you to do any changes unless explicitly stated."$'\n'
    fi

    if [ "$EMPTY" -ne 1 ] && [ "$RO_MAIN" -ne 1 ]; then
      RW_MOUNTS+=( "$PROJECT" )
      if [ "$GIT_RW" -ne 1 ]; then
        RO_MOUNTS_TRY+=( "$PROJECT/.git" )
        SANDBOX_NOTE+=" .git is mounted read-only (if present); the user most likely doesn't want you to do git changes."$'\n'
      fi
    fi

    declare -a ARGS=()

    for d in "''${RW_MOUNTS[@]}";     do ARGS+=( --bind        "$(realpath -e "$d")" "$(realpath -e "$d")" ); done
    for d in "''${RO_MOUNTS[@]}";     do ARGS+=( --ro-bind     "$(realpath -e "$d")" "$(realpath -e "$d")" ); done
    for d in "''${RO_MOUNTS_TRY[@]}"; do ARGS+=( --ro-bind-try "$(realpath    "$d")" "$(realpath    "$d")" ); done

    if [ "$PODMAN" -eq 1 ]; then
      PODMAN_SOCK="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
      ARGS+=(
        --ro-bind "$PODMAN_SOCK" /run/podman.sock
        --perms 0700 --dir "/run/user/$(id -u)"
        --setenv XDG_RUNTIME_DIR "/run/user/$(id -u)"
        --setenv CONTAINER_HOST "unix:///run/podman.sock"
        --setenv DOCKER_HOST     "unix:///run/podman.sock"
      )
    fi

    ARGS+=( --chdir "$PROJECT" )
    PI_ARGS=( --append-system-prompt "$SANDBOX_NOTE" "''${PI_ARGS[@]}" )

    # Fun way of adding comments in the middle of a multi-line command:
    # https://stackoverflow.com/a/1456019

    (exec bwrap \
          "''${ARGS[@]}" \
          --dir /tmp \
          --dir /var \
          --perms 1777 --dir /tmp \
          --symlink ../tmp var/tmp \
          --symlink usr/lib /lib \
          --symlink usr/lib64 /lib64 \
          --symlink usr/bin /bin \
          --proc /proc \
          --dev /dev \
          --ro-bind /etc/resolv.conf /etc/resolv.conf \
          --ro-bind /usr /usr \
          --ro-bind /sbin /sbin \
          --ro-bind /nix/store /nix/store \
          --ro-bind /run/current-system/sw /run/current-system/sw \
          --ro-bind /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt \
          --ro-bind "$HOME/.gitconfig" "$HOME/.gitconfig" \
          --bind "$HOME/.pi/agent" "$HOME/.pi/agent" \
          --unshare-all \
          --share-net \
          --unshare-user \
          --disable-userns \
          --assert-userns-disabled \
          --die-with-parent \
          --hostname pi-sandbox \
          --file 11 /etc/passwd \
          --file 12 /etc/group \
          pi "''${PI_ARGS[@]}") \
      11< <(getent passwd "$(id -u)" 65534) \
      12< <(getent group  "$(id -g)" 65534)
  '';

  meta = {
    description = "Launch Pi in a preconfigured bubblewrap sandbox";
    mainProgram = "bpi";
  };
}
