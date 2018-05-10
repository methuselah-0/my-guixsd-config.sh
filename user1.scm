;; -*- geiser-scheme-implementation: guile -*-
(define audio-video-packages
  (list
   "alsa-lib"
   "alsa-plugins"
   "alsa-utils"
   "ffmpeg" ;; Audio fromat converter
   "flac" ;; flac audio format
   "mpd" ; music player daemon FIXME
   "mpd-mpc" ; cli for mpd
   "ncmpcpp" ; mpd music daemon, mpd cli, and mpd-client.   
   "mpv" ; Video-player   
   "pulseaudio"
   "ponymix"
   "pavucontrol"
   "vorbis-tools"
   "youtube-dl"
   ))
(define desktop-packages
  (list
   "arandr"
   "compton"
   "dconf-editor"   
   "gnome-tweak-tool"
   "gsettings-desktop-schemas"
   ;; "gcc-toolchain" ; xmonad
   ;; "ghc-xmonad-contrib"
   ;; "ghc"
   ;; "ghc-network"   
   "libgcrypt" ; for compiling alock with something (see my-xmonad.sh)
   "linux-pam" ; for compiling alock with --enable-pam module, xmonad
   "libnotify"
   "libreoffice" ; office suite   
   ;;"dmenu"	  
   ;;"dzen"
   ;;"feh"
   ;;"enlightenment"
   ;; xfce4-pulseaudio-plugin
   "xinit"
   "xkill"
   "setxkbmap"
   "xauth"
   "xbacklight"
   "xclip" ;; getPass etc.
   "xdg-utils"
   "xdotool" ;; xmonad window manager related
   "xeyes" ;; wayland vs X
   "xlsfonts" ; font
   "xmodmap" ;; xmonad
   ;; "xmonad"
   ;; "xmobar"
   "xorg-server"
   ;; "xorg-xfontsel ; font"
   "xrandr"
   "xscreensaver" ;; xmonad
   "xsensors"
   "xset" ;; xorg display server related
   "xsetroot"   
   ))

(define emacs-packages
;;  (specifications->manifest
  (list
   "emacs"
   "emacs-ag"
   "emacs-auto-complete"
   "emacs-bash-completion"
   "emacs-scheme-complete"
   "emacs-company"
   "emacs-emms" ;; emacs-emms
   "emacs-emms-player-mpv"
   "emacs-guix"
   "emacs-js2-mode"
   "emacs-lispy"
   "emacs-nginx-mode"
   "emacs-org"
   "emacs-org2web"
   "emacs-org-bullets"
   "emacs-org-contrib"
   "emacs-org-tree-slide" ;; emacs-org-tree-slide
;;   "emacs-paredit"        ;; emacs-paredit
   "emacs-php-mode"
   "emacs-pdf-tools"
   "emacs-rainbow-delimiters"
   "emacs-rudel"
   "emacs-scheme-complete"
   "emacs-w3m"
   "emacs-wget"
   "emacs-xmlgen"
   ))

(define font-packages
  (list
             ;; System fonts
             "font-bitstream-vera"
             "font-dejavu"
             "font-gnu-freefont-ttf"
             "font-gnu-unifont"
             "gs-fonts"
             "font-hack" ;; glyphs             
             "font-terminus"
             "font-abattis-cantarell" ;; font-abattis-cantarell
             "font-anonymous-pro"
             "font-awesome"
             
             "font-fantasque-sans"
             "font-fira-mono"
             "font-go"
             "font-google-material-design-icons"
             "font-google-noto"
             "font-google-roboto"
             
             "font-inconsolata"
             "font-liberation"
             "font-linuxlibertine" ;; font-linux-libertine
             "font-mathjax"
             "font-rachana"
             "font-tamzen"
             
             "font-tex-gyre"
             "font-ubuntu"
             "font-un"
             ;; xorg fonts
;;             font-util
;;             fontconfig
;;             font-mutt-misc
             ;; "libxft" ;; xft fonts
             ;; "ghc-x11-xft"
             ;; "libxfont" ; xmonad
             ;; "ftgl" ; uses Freetype2 to simplify rendering fonts in OpenGL applications

   
    "pango"
    "perl-pango"
    "cairo"
   ))

(define messaging-packages
  (list
   "qtox" ;; tox FIXME
   "gajim" ;; xmpp FIXME   
   "weechat" ;; IRC
   "alpine" ;; smtp
   ))

(define misc-utils-packages
  (list
   "audit"
   "cpulimit"   
   "file" ; findutils
   "gdb" ;; debugging (capture stdout from processes)
   "gpgme"
   "graphviz" ; pdf tools   
   "htop"
   ;;bzip2 ; "conflicting entry"
   ;; diffutils
   "mupdf" ; pdf tools   
   "openssh" ; SSH access
;   "openssl@1.0.2n" ; 1.1.0h version is incompatible with the spice package
;   "openssl" ; spice package provides openssl but older version which should be fine.
   "pkg-config"
   "pinentry"
   "pinentry-tty"
   "pinentry-qt"
   ;;pinentry-gtk
   "recutils" ;; location: databases   
   "rsync" ; rsync   
   "texinfo"
   "unzip"   
   "zip"
   ))

(define net-tools-packages
  (list
   "aircrack-ng"
   "curl"   
   "net-tools"
   "nmap" ; check ports etc. - network tool
   "wget"   
   "wicd"
   "wireshark"
   "wpa-supplicant"
))

(define programming-extra-packages
  (list
   "geiser"
   "git"
   "ltrace"
   "node"   
   "perl"
;; "python-3.6"
;;   "python" ;; is 3.6 version
   "python@2.7"
   "python-pycrypto"   
   "python2-dateutil"
   "python2-vobject" ;;python   
   "strace"
   ))

(define terminal-packages
  (list
   "abduco"    
   "bash-completion"
   "bc"
   "beep"
   "dvtm"
   "fbcat"
   "fbida" ; framebuffer graphics
   ;; kmscon ;; build fails (including on hydra since 2017-12-05)   
   "rxvt-unicode"
   "screen"
   "termite" ;; wayland-native terminal
   "tree" ; terminal and console
;;   "ttylog" ;; doesn't exist
   "unclutter"   
   "vis"
   ;; terminology ; terminals FIXME             
   ))

(define virtualization-packages
  (list
   "bridge-utils" ; virtualization, brctl   
   "dnsmasq" ; virtualization
   "iptables" ; firewall, used for virtualization also
   "openvpn" ; virtualization, mktun
   "qemu" ;; FIXME
   "xf86-video-qxl" ;; FIXME
   "xf86-video-fbdev" ;; FIXME   
   "spice" ;; virtualization. Incompatible with openssl-next
   ;; Server stack packages:
   ;; mariadb nginx php letsencrypt
   "mesa" ;; graphics
   "mesa-utils" ;; graphics
   ;; "gtkglext" ;; make gtk-widgets OpenGL compatible, etc.
   ))
(define web-packages
  (list
   "icecat" ; browser
   "icedtea" ; browser plugin
   "conkeror"
   "lynx"   
   ))

(specifications->manifest
 (append (list "hello")
	 audio-video-packages
	 desktop-packages
	 emacs-packages
	 font-packages
	 messaging-packages
	 misc-utils-packages
	 net-tools-packages
	 programming-extra-packages
	 terminal-packages
	 virtualization-packages
	 web-packages
	 ))
