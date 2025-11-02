#!/bin/bash

if [[ $EUID -eq 0 ]]; then
    clear
    echo "This script MUST NOT be run as root."
    echo "Exiting..."
    sleep 3 && exit 1
fi

path=$(pwd)
user=$(whoami)

clear
echo ""
echo ""
echo "██╗  ██╗ █████╗ ██╗   ██╗███╗   ██╗████████╗    ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗ "
echo "██║  ██║██╔══██╗██║   ██║████╗  ██║╚══██╔══╝    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝ "
echo "███████║███████║██║   ██║██╔██╗ ██║   ██║       ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗ "
echo "██╔══██║██╔══██║██║   ██║██║╚██╗██║   ██║       ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║ "
echo "██║  ██║██║  ██║╚██████╔╝██║ ╚████║   ██║       ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║ "
echo "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝       ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝ "
echo "                              https://github.com/scarsandtears"
echo ""

if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si
    cd -
fi

if grep -q "^ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i 's/^ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf
else
    echo "ParallelDownloads = 10" | sudo tee -a /etc/pacman.conf > /dev/null
fi

sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//g' /etc/pacman.conf

if ! grep -q "^Color" /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a Color' /etc/pacman.conf
fi

if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi

sudo pacman -Sy &> /dev/null

programs=(
    cava devour exa tty-clock-git picom-simpleanims-next-git cmatrix-git pipes.sh npm xdotool xautolock betterlockscreen 
    yad libnotify wal-telegram-git python-pywalfox xsettingsd themix-gui-git pacman-contrib ripgrep fd luarocks v4l2loopback-dkms
    themix-theme-oomox-git archdroid-icon-theme tesseract-data-eng tesseract-data-por slop arandr polkit-gnome clipmenu zsh
    cmus mpd mpc ncmpcpp playerctl dbus simple-mtpfs dunst emacs feh ffmpeg ffmpegthumbnailer firefox flameshot pcmanfm gvfs
    fzf git gnu-free-fonts go gd btop mullvad-vpn-bin imagemagick mpv neofetch neovim noto-fonts noto-fonts-cjk noto-fonts-emoji
    numlockx obs-studio openssh perl pulsemixer udiskie keepassxc python-pip python-pywal qalculate-gtk android-tools
    xdg-user-dirs qutebrowser ranger syncthing sxiv telegram-desktop tree ttf-jetbrains-mono-nerd ttf-font-awesome qbittorrent
    gpick ueberzugpp redshift p7zip unzip epub-thumbnailer-git python-pdftotext poppler xorg-xinput vim webkit2gtk xclip yt-dlp
    zathura zathura-pdf-mupdf zip xorg-server xorg-xinit libx11 libxinerama libxft base base-devel qt5ct qt6ct libreoffice-fresh
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber xorg-xwininfo
)

total=${#programs[@]}
count=0
bar_length=30
spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

draw_progress_bar() {
    local progress=$1
    local total=$2
    local percent=$(( 100 * progress / total ))
    local filled=$(( bar_length * percent / 100 ))
    local empty=$(( bar_length - filled ))

    bar=$(printf "%0.s█" $(seq 1 $filled))
    bar+=$(printf "%0.s▒" $(seq 1 $empty))

    printf "[%s] %d/%d" "$bar" "$progress" "$total"
}

echo "Installing programs..."
for program in "${programs[@]}"; do
    count=$((count + 1))

    if ! yay -Q "$program" &> /dev/null; then
        (
            i=0
            while true; do
                printf "\r\033[K"
                draw_progress_bar "$count" "$total"
                frame="${spinner_frames[i]}"
                printf " Installing: %-25s %s" "$program" "$frame"
                sleep 0.1
                ((i=(i+1)%${#spinner_frames[@]}))
            done
        ) &
        spinner_pid=$!

        yay -S "$program" --noconfirm &> /dev/null

        kill $spinner_pid &>/dev/null
        wait $spinner_pid 2>/dev/null
        printf "\r\033[K"
        draw_progress_bar "$count" "$total"
        printf " Installed: %-25s" "$program"
    else
        printf "\r\033[K"
        draw_progress_bar "$count" "$total"
        printf " Already installed: %-25s" "$program"
    fi
done

sleep 1 && clear

if [ -d "/sys/class/power_supply" ] && [ "$(ls -A /sys/class/power_supply)" ]; then
    notebook_programs=(acpi acpilight)
    total=${#notebook_programs[@]}
    count=0
    bar_length=30
    spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    draw_progress_bar() {
        local progress=$1
        local total=$2
        local percent=$(( 100 * progress / total ))
        local filled=$(( bar_length * percent / 100 ))
        local empty=$(( bar_length - filled ))
        bar=$(printf "%0.s█" $(seq 1 $filled))
        bar+=$(printf "%0.s▒" $(seq 1 $empty))
        printf "[%s] %d/%d" "$bar" "$progress" "$total"
    }

    for program in "${notebook_programs[@]}"; do
        count=$((count + 1))
        status="Already installed"

        if ! yay -Q "$program" &>/dev/null; then
            status="Installing"
            (
                i=0
                while true; do
                    printf "\r\033[K"
                    draw_progress_bar "$count" "$total"
                    frame="${spinner_frames[i]}"
                    printf " %-25s %s" "$status: $program" "$frame"
                    sleep 0.1
                    ((i=(i+1)%${#spinner_frames[@]}))
                done
            ) &
            spinner_pid=$!
            yay -S "$program" --noconfirm &>/dev/null
            kill $spinner_pid &>/dev/null
            wait $spinner_pid 2>/dev/null
        fi

        printf "\r\033[K"
        draw_progress_bar "$count" "$total"
        printf " %-25s" "$status: $program"
    done

    echo ""
fi

    sudo chown "$USER" /sys/class/backlight/intel_backlight/brightness &>/dev/null
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo tee /etc/X11/xorg.conf.d/90-touchpad.conf >/dev/null <<'EOF'
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
EndSection
EOF

sleep 1 && clear

if rfkill list bluetooth &>/dev/null; then
    bluetooth_packages=(bluez bluez-utils blueman)
    total=${#bluetooth_packages[@]}
    count=0
    bar_length=40
    spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    draw_progress_bar() {
        local progress=$1
        local total=$2
        local percent=$(( 100 * progress / total ))
        local filled=$(( bar_length * percent / 100 ))
        local empty=$(( bar_length - filled ))
        bar=$(printf "%0.s█" $(seq 1 $filled))
        bar+=$(printf "%0.s▒" $(seq 1 $empty))
        printf "[%s] %d/%d" "$bar" "$progress" "$total"
    }

    for pkg in "${bluetooth_packages[@]}"; do
        count=$((count + 1))
        status="Already installed"
        if ! pacman -Qi "$pkg" &>/dev/null; then
            status="Installing"
            (
                i=0
                while true; do
                    printf "\r\033[K"
                    draw_progress_bar "$count" "$total"
                    frame="${spinner_frames[i]}"
                    printf " %-25s %s" "$status: $pkg" "$frame"
                    sleep 0.1
                    ((i=(i+1)%${#spinner_frames[@]}))
                done
            ) &
            spinner_pid=$!
            sudo pacman -S --noconfirm "$pkg" &>/dev/null
            kill $spinner_pid &>/dev/null
            wait $spinner_pid 2>/dev/null
        fi
        printf "\r\033[K"
        draw_progress_bar "$count" "$total"
        printf " %-25s" "$status: $pkg"
    done
    echo ""

    sudo systemctl enable --now bluetooth.service &>/dev/null
else
    :
fi

sleep 1 && clear

echo "Already have Oh-My-Zsh installed? (y/n)"
read answer
sleep 1 && clear

case $answer in
  [Yy]*)
    if [ -L $HOME/.config/zsh ]; then
    rm $HOME/.config/zsh
    fi
    ln -sf $path/.config/zsh $HOME/.config/zsh 

    if [ -L $HOME/.zshrc ]; then
    rm $HOME/.zshrc
    fi
    sleep 1 && clear
    ;;
  [Nn]*)
    echo "Installing..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ -L $HOME/.config/zsh ]; then
    rm $HOME/.config/zsh
    mv $path/.config/zsh/.zshrc.pre-oh-my-zsh $path/.config/zsh/.zshrc
    fi
    ln -sf $path/.config/zsh $HOME/.config/zsh

    if [ -f $HOME/.zshrc ]; then
    rm $HOME/.zshrc
    fi
    sleep 1 && clear
    ;;
  *)
    echo "Invalid answer, skipping..."
    sleep 1 && clear
    ;;
esac

sleep 1 && clear

echo "Organizing dotfiles..."
echo ""

files=".Xresources .xinitrc .zshenv"
directories=".config .local .local/bin"
configs="cava redshift dunst btop xsettingsd xmenu qt5ct qt6ct flameshot kitty alacritty PCSX2 mpv neofetch sxiv wal picom ranger zathura qutebrowser cmus mpd ncmpcpp user-dirs.dirs suckless nvim emacs"
bkp_dir="$HOME/.bkp_config"

if [ ! -d "$bkp_dir" ]; then
    mkdir "$bkp_dir"
fi

for file in $files; do
    if [ -f "$HOME/$file" ]; then
        mv "$HOME/$file" "$bkp_dir"
    fi
    ln -sf "$path/$file" "$HOME/$file"
done

for directory in $directories; do
    [ ! -d "$HOME/$directory" ] && mkdir "$HOME/$directory"
done

for config in $configs; do
    if [ -d "$HOME/.config/$config" ]; then
        mv "$HOME/.config/$config" "$bkp_dir"
    fi
    ln -sf "$path/.config/$config" "$HOME/.config/$config"
done

if [ -d "$HOME/.oh-my-zsh" ]; then
  mv "$HOME/.oh-my-zsh" "$HOME/.config/"
fi

ln -sf "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"
ln -sf "$HOME/.cache/wal/flameshot.ini" "$HOME/.config/flameshot/flameshot.ini"
ln -sf "$HOME/.cache/wal/config" "$HOME/.config/cava/config"
ln -sf "$HOME/.cache/wal/zathurarc" "$HOME/.config/zathura/zathurarc"
ln -sf "$HOME/.cache/wal/colors-kitty.conf" "$HOME/.config/kitty/colors-kitty.conf"
ln -sf "$HOME/.cache/wal/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

ln -sf "$path/.local/bin/statusbar" "$HOME/.local/bin"
ln -sf "$path/.local/bin/"* "$HOME/.local/bin"
ln -sf "$path/.config/xmenu/xmenu.sh" "$HOME/.local/bin/menu"

CURSOR_TARGET="/usr/share/icons/Bibata-Modern-Classic/cursors"
CURSOR_LINK="/usr/share/icons/default/cursors"

if [ -d "$CURSOR_TARGET" ]; then
    sudo ln -sf "$CURSOR_TARGET" "$CURSOR_LINK"
fi

sleep 1 && clear

echo "Preparing folders..."
	sleep 1 && clear
if [ ! -e $HOME/.config/user-dirs.dirs ]; then
	xdg-user-dirs-update
	sleep 1 && clear
else
	xdg-user-dirs-update
	sleep 1 && clear
fi

xdg-mime default pcmanfm.desktop inode/directory
xdg-settings set default-web-browser firefox.desktop
xdg-mime default org.pwmt.zathura.desktop application/pdf
sudo modprobe v4l2loopback video_nr=10 card_label="VirtualCam" exclusive_caps=1

sleep 1 && clear

echo "Do you want to download haunT Wallpapers? (y/n)"
read answer
sleep 1 && clear

case $answer in
  [Yy]*)
    repo_url="https://github.com/scarsandtears/wallpapers.git"
    parent_dir="$HOME/Pictures"
    destination_dir="$parent_dir/wallpapers"

    if [ -d "$destination_dir" ]; then
        echo "The directory $destination_dir already exists. Wallpapers will not be downloaded again."
    else
        echo "Downloading wallpapers from the repository..."
        git clone "$repo_url" "$destination_dir"
        echo "Wallpapers downloaded successfully to $destination_dir"
    fi
    sleep 2 && clear
    ;;
  [Nn]*)
    echo "Skipping..."
    sleep 1 && clear
    ;;
  *)
    echo "Invalid answer, skipping..."
    sleep 1 && clear
    ;;
esac

if pgrep -x "Xorg" >/dev/null; then
  echo "Do you want to harden your Firefox? (y/n)"
  read answer
  sleep 1 && clear

  case $answer in
    [Yy]*)
      echo "Hardening Firefox..."

      if ! command -v wget >/dev/null; then
        echo "wget is not installed. Installing..."
        yay -S wget --noconfirm
        sleep 1 && clear
      fi

      if pgrep firefox >/dev/null; then
        pkill firefox
      fi

      for profile_dir in "$HOME/.mozilla/firefox/"*.default-release/; do
        if [ -f "$profile_dir/user.js" ]; then
          rm "$profile_dir/user.js"
        fi

        if [ -f "$profile_dir/search.json.mozlz4" ]; then
          rm "$profile_dir/search.json.mozlz4"
        fi
      done

      for file in "$path/.config/firefox/"*; do
        cp -r "$file" "$profile_dir"
      done

      ublock_version="1.50.0"
      wget -O "/tmp/uBlock0_$ublock_version.firefox.signed.xpi" "https://github.com/gorhill/uBlock/releases/download/$ublock_version/uBlock0_$ublock_version.firefox.signed.xpi"
      setsid -f firefox "/tmp/uBlock0_$ublock_version.firefox.signed.xpi"

      sleep 1 && clear
      ;;
    [Nn]*)
      echo "Skipping..."
      sleep 1 && clear
      ;;
    *)
      echo "Invalid answer, skipping..."
      sleep 1 && clear
      ;;
  esac
fi

suckless=("dwm" "st" "dmenu" "dwmblocks-async")
total=${#suckless[@]}
count=0
bar_length=30
spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

draw_progress_bar() {
    local progress=$1
    local total=$2
    local percent=$(( 100 * progress / total ))
    local filled=$(( bar_length * percent / 100 ))
    local empty=$(( bar_length - filled ))

    bar=$(printf "%0.s█" $(seq 1 $filled))
    bar+=$(printf "%0.s▒" $(seq 1 $empty))

    printf "[%s] %d/%d" "$bar" "$progress" "$total"
}

echo "Installing suckless programs..."

for program in "${suckless[@]}"; do
    count=$((count + 1))

    (
        i=0
        while true; do
            printf "\r\033[K"
            draw_progress_bar "$count" "$total"
            frame="${spinner_frames[i]}"
            printf " Installing: %-20s %s" "$program" "$frame"
            sleep 0.1
            ((i=(i+1)%${#spinner_frames[@]}))
        done
    ) &
    spinner_pid=$!

    cd "$path/.config/suckless/$program" && sudo make clean install &> /dev/null

    kill $spinner_pid &>/dev/null
    wait $spinner_pid 2>/dev/null

    printf "\r\033[K"
    draw_progress_bar "$count" "$total"
    printf " Installed:  %-20s" "$program"
done

cd "$path/.config/xmenu" && sudo make install &> /dev/null
sleep 1 && clear

printf "\nInstallation of suckless programs complete.\n"
sleep 3 && clear

echo "Running pywal..."
wallpaper_dir="$HOME/Pictures/wallpapers"
reserve_wallpaper="$path/.config/wallpaper.jpeg"

if [ -d "$wallpaper_dir" ]; then
  wallpaper=$(ls "$wallpaper_dir" | shuf -n 1)
  wallpaper_path="$wallpaper_dir/$wallpaper"
else
  wallpaper_path="$reserve_wallpaper"
fi

wal -i "$wallpaper_path" &> /dev/null
sed -i ~/.Xresources -re '1,1000d'
cat ~/.cache/wal/colors.Xresources >> ~/.Xresources

if [ -n "$(pgrep Xorg)" ]; then
  pkill picom & > /dev/null
  killall dwm &
  dwmblocks &
  oomox-cli /opt/oomox/scripted_colors/xresources/xresources-reverse > /dev/null
  betterlockscreen -u "$wallpaper_path" > /dev/null 2>&1
  wal-telegram -t
  pywalfox update
  killall dunst && dunst &
  sleep 1 && clear
  notify-send "Rice updated!"
fi

picom &

chmod +x $path/.local/bin
sleep 1 && clear

if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "Changing default shell..."
  chsh -s /usr/bin/zsh
fi
sleep 1 && clear

echo "All done!"
echo "Please log out and log back in for the changes to take effect."
