{
  pkgs,
  firmware,
}:
pkgs.writeShellApplication {
  name = "zmk-uf2-automount-flash";

  text = ''
    if [[ ! -v 1 ]]; then
      echo "Expect a path as the firmware destination"
      exit
    fi
    mount_path="$1"

    function yes_or_no {
      while true; do
        read -rp "$* [y/n]: " yn
        case $yn in
          [Yy]*) return 0  ;;  
          [Nn]*) echo "Aborted" ; return  1 ;;
        esac
      done
    }

    echo "Wating for path $mount_path"
    while true; do
      [[ -d "$mount_path" ]] && break
      echo .
      sleep 1
    done
    yes_or_no "Path found, continue?" || exit
    cp ${firmware}/zmk.uf2 "$mount_path"
  '';
}
