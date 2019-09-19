;; -*- geiser-scheme-implementation: guile -*-
;; (use-modules (guix packages)
;;              (guix download)
;; ;             (guix gexp)             
;;              (guix build-system gnu)
;;              (guix licenses))
;; (package
;;  (name "prips")
;;  (version "1.1.1")
;;  (source
;;   (origin
;;    (method url-fetch)
;;    (uri (string-append "https://devel.ringlet.net/files/sys/" name "/" name "-" version ".tar.xz"))
;;    (sha256
;;     (base32 "1a33vbl4w603mk6mm5r3vhk87fy3dfk5wdpch0yd3ncbkg3fmvqn"))))
;;  (build-system gnu-build-system)
;;  (arguments
;;   '(#:make-flags (list "CC=gcc")
;;     #:phases (modify-phases
;;               %standard-phases
;;               (delete 'configure)
;;               (delete 'check)
;;               (replace 'install
;;                        (lambda _
;;                          (let*
;;                              ((bin-dir  (string-append %output "/bin"))
;;                               (bin-file (string-append bin-dir "/prips")))
;;                            (mkdir-p bin-dir)
;;                            (copy-file "prips" bin-file)
;;                            (chmod bin-file #o700)))))))
;;  (synopsis "Tool that prints the IP addresses in a given range")
;;  (description "Prips can be used to print all of the IP addresses in a given range. This allows the enhancement of tools only work on one host at a time (e.g. whois).")
;;  (home-page "https://devel.ringlet.net/sysutils/prips/")
;;  (license gpl2))
(define build-packages
  (list
;   "gnu-make"
   "autobuild" ; autotools   
   "automake"
   "autoconf"
   "binutils"
   "coreutils"
   "gcc"
   "gcc-toolchain"
   "glibc"
   "glibc-bootstrap"
   "guildhall" ; guile
   "guile-bootstrap"
   "libevent"
   "libtool"
   "make"
   "m4"
;   "module-import"
   "libpcap"
   "libpthread-stubs"
   "libstdc++"
   "pkg-config"))
(define audio-video-packages
  (list
   "alsa-lib"
   "alsa-plugins"
   "alsa-utils"
   "espeak"
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
   ;; "compton" ; not using xmonad anymore on GuixSD
   "dconf-editor"   
   "gnome-tweak-tool"
   "gsettings-desktop-schemas"
   ;; "gcc-toolchain" ; xmonad
   ;; "ghc-xmonad-contrib"
   ;; "ghc"
   ;; "ghc-network"
   "glibc-utf8-locales"
   "libgcrypt" ; for compiling alock with something (see my-xmonad.sh)
   "linux-pam" ; for compiling alock with --enable-pam module, xmonad
   "libnotify"
;   "libreoffice" ; office suite
   "snap" ; to install anbox and then android apk packages 
   ;;"dmenu"	  
   ;;"dzen"
   ;;"feh"
   ;;"enlightenment" ; to avoid extra builds since I don't really use it much.
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
   "xpra"
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
;;   "emacs-emms-player-mpv" ; superseded by emacs-emms
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
             "font-adobe-source-code-pro"
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
   ;; "qtox" ;; tox FIXME
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
   "gmp"
   ;;"gpgme" ;; currently has dependency that conflicts with libgcrypt
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
   "netcat"
   "net-tools"
   "nmap" ; check ports etc. - network tool
;   "prips"
   "wget"   
   "wicd"
   ;; temporarily commented due to compile time sucks "wireshark"
   "wpa-supplicant"
))

(define programming-extra-packages
  (list
   "emacs-geiser"
   "git"
   "ltrace"
   "node"   
   "perl"
   "guile@2.0"
   "guile-bash"
;; "python-3.6"
;;   "python" ;; is 3.6 version
   "python@2.7"
   "python-pycrypto"   
   "python2-dateutil"
   "python2-vobject" ;;python
   "shellcheck"
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
   "docker"
   "iptables" ; firewall, used for virtualization also
   "openvpn" ; virtualization, mktun
   ;; "qemu" ;; FIXME
   "xf86-video-qxl" ;; FIXME
   "xf86-video-fbdev" ;; FIXME   
   ;; temporarily commented due to compile time sucks "spice" ;; virtualization. Incompatible with openssl-next
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
	 ;; audio-video-packages
         ;; build-packages
	 ;; desktop-packages
	 ;; emacs-packages
	 ;; font-packages
	 ;; messaging-packages
	 ;; misc-utils-packages
	 net-tools-packages
	 ;; programming-extra-packages
	 ;; terminal-packages
	 ;; virtualization-packages
	 ;; web-packages
	 ))
