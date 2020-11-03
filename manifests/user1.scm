;; -*- geiser-scheme-implementation: guile -*-
;; INFO: make sure to add job.guile and mcron & in ~/.profile

(define build-pkgs
  (list "autobuild"
        "autoconf"
        "automake"
        "binutils"
        ;;"gcc" ; has been superseded by gcc-toolchain       
        "gcc-toolchain"
        "m4"
        "make"
        "mesa"
        "mesa-utils"
        "pkg-config"
        "elfutils"        
        ))
(define admin-pkgs
  (list
   "audit"   
   "beep"
   "cpulimit"
   "cowsay"
   "cpio"
   "iptables"
   "htop"

   "ccrypt"
   
   "rsync"
   "tree"   
   "unzip"
   "zip"

   "strace"   
)
)

(define desktop-pkgs
  (list
   "scrot" ;; screenshot
   
   "pulseaudio"
   ;; "qbittorrent" ;; build fail
   
   "dconf-editor"
   "arandr"
   "gnome-tweaks"
   
   "libreoffice"

   "pavucontrol"
      
   "ipcalc"
   "libnotify"

   "libxml2"
   "libxml2-xpath0"

   "mpd"
   "mpd-mpc"
   "mps-youtube"
   "mpv"
   "mupdf"
   "ncmpcpp"
   "weechat"

   ;;"xpra"
   ;;"xscreensaver"
   "xsensors"
   
))

(define misc-pkgs
  (list
   "xf86-video-fbdev" ;; spice-client
   "xf86-video-qxl" ;; spice-client
   "youtube-dl"
   
   "nss-certs"
   "glibc-locales"
   
   "gnupg"   
   "pinentry"
   "pinentry-qt"
   "pinentry-tty"
   
   "icecat" ;; browser
   "nyxt" ;; browser
   "ungoogled-chromium" ;; browsers

   "alpine" ;; email

   "mcron" ;; scheduled commands, see job.guile
   "gajim" ;; build fails

   "ccrypt"

   "ffmpeg"
   "file"
   "flac"
   "alsa-lib"
   "alsa-plugins"
   "alsa-utils"

   "xrandr"
   "haunt"
   "icedtea"
))
(define net-pkgs
  (list
   "dnsmasq"
   "curl"
   "bridge-utils"
   "bind"
   "aircrack-ng"
   "netcat"
   "net-tools"
   "nmap"
   "openssh"
   "openvpn"
   "wget"
   ;;"wicd"
   "wpa-supplicant"   
))

(define terminal-pkgs
  (list
   "xrdb"
   
   "screen"
   "rxvt-unicode"   
   "terminology"

   "setxkbmap"
   "xmodmap"

   "coreutils"
   "bash-completion"
   "dvtm"
   "abduco"
   "fbcat"
   "fbida"
   "feh"
   "gash"

   "lynx" ;; browser
      
   "unclutter"
   "vis"
   "recutils"   
   "xclip"
   "xdotool"   
   "xdg-utils"

   ;; BASH DEV-ENVIRONMENT PACKAGES
   "shellcheck"   
   "xmlstarlet"   
   "moreutils"   
   "git"   
   ;;"bash-coding-utils.sh"
   "libhandy"
   "pcre"
   "pcre2"
   
))
(define emacs-pkgs
  (list

   ;; to produce some org-babel outputs
   "texinfo"
   "texlive"
   "texlive-latex-preview"

   "js-mathjax"    ;; some org-babel or texlive outputs I think
   "imagemagick" ;; for org-babel picture outputs   
   "graphviz" ;; dot output org-babel

   "emacs"
   ;; dependencies for vcard2org-contacts.py
   "python2"
   "python2-dateutil"
   "python2-vobject"

   ;; dependencies for org-schedule.pl
   ;; "pango" - maybe needed?
   "perl-pango"
   "perl"
   "perl-data"
   "perl-datetime-format-ical"
   "perl-data-ical"
   "perl-devel-repl"

   ;; espeak to be used for notifications with org-agend (ical2org cronjob)
   "espeak-ng"
   "espeak"
   ;; for calendar stuff
   "emacs-org-caldav"

   ;; EMACS-GENERAL
   "emacs-ag"
   "emacs-auto-complete"
   "emacs-bash-completion"
   "emacs-browse-at-remote"
   "emacs-company"
   "emacs-deferred"
   "emacs-emms"
   "emacs-flycheck"
   "emacs-geiser"
   "emacs-guix"
   "emacs-jedi"
   "emacs-js2-mode"
   "emacs-lispy"
   "emacs-nginx-mode"
   "emacs-org"
   "emacs-org2web"
   "emacs-org-bullets"
   "emacs-org-contrib"
   "emacs-org-re-reveal"
   "emacs-org-reveal"
   "emacs-org-tree-slide"
   "emacs-pdf-tools"
   "emacs-php-mode"
   "emacs-rainbow-delimiters"
   "emacs-realgud"
   "emacs-rudel"
   "emacs-scheme-complete"
   "emacs-tramp"
   "emacs-w3m"
   "emacs-wget"
   "emacs-xmlgen"
))
(define font-pkgs
  (list
   "xlsfonts"
   "gs-fonts"

   "font-abattis-cantarell"
   "font-adobe-source-code-pro"
   "font-anonymous-pro"
   "font-awesome"
   "font-bitstream-vera"
   "font-dejavu"
   "font-fantasque-sans"
   "font-fira-mono"
   "font-gnu-freefont"
   "font-gnu-unifont"
   "font-go"
   "font-google-material-design-icons"
   "font-google-noto"
   "font-google-roboto"
   "font-hack"
   "font-inconsolata"
   "font-liberation"
   "font-linuxlibertine"
   "font-mathjax"
   "font-rachana"
   "font-tamzen"
   "font-terminus"
   "font-tex-gyre"
   "font-ubuntu"
   "font-un"
))

(define non-sorted-packages
  (list
   "docker"
   "cabal-install"
   "cairo"

   ;; ADMIN-tools

   ;; DESKTOP

   ;; MISC

   ;; NET-TOOLS

   ;; TERMINAL

   ;; EMACS

   ;; FONTS
   "gettext"
   ;;"ghc" ;; tests fail
   ;;"ghc-digest"
   ;;"ghc-pandoc-citeproc"
   ;;"ghc-texmath"
   ;;"ghc-zlib"
   ;;"ghc-zlib-bindings"
   ;;"ghc-zstd"

   "glibc"
   "glibc-bootstrap"
   "glibc-utf8-locales"

   "gmp"
   
   "gsettings-desktop-schemas"

   "libbsd"
   "libelf"
   "libevent"

   "libffi"

   "libgcrypt"   

   "libpcap"

   "libpthread-stubs"
   
   ;;"libstdc++" ; doesn't exist
   "libstdc++-doc"
   "libtool"

   "linux-pam"

   "llvm"

   "lsh"
   
   "ltrace"
   
   ;;"next"
   "node"

   "openlibm"

   "ponymix"

   "postgresql"

   "snap"
   
   "termite"

   "vorbis-tools"

   "xauth"
   "xbacklight"

   "xeus"

   "xeyes"
   
   "xinit"
   "xkill"

   "xorg-server"
   "xset"
   "xsetroot"
   
   "zlib"
   ))

(define python-dev-pkgs
  (list    ;; PYTHON DEV-ENVIRONMENT PACKAGES, minus the emacs one
   "python-bash-kernel" ;; must run python -m bash_kernel first
   "jupyter-next"
   "python-pip"
   "python-netaddr"
   "python"
   "python-nbdev-org-babel" ;; should install ruby to get gem
   "python-trepan3k"
   "python-pylint"
   "python-pydotplus"
   "python-pycrypto"
   "fwknop"
   "python-virtualenv" ;; to run in emacs M-x jedi:install-server
   "gdb"))
(define guile-dev-pkgs
  (list    ;; GUILE DEV-ENVIRONMENT PACKAGES
   "guildhall"
   "guile@2.2"
   "guile2.0-haunt"
   "guile-base64"
   ;;"guile-bash"
   "guile-bash-2.2"
   "guile-bootstrap"
   "guile-config"
   "guile-csv"
   "guile-curl"
   "guile-dsv"
   "guile-pfds"
   "guile-sjson"
   ;;"guile-stis-parser" ; later version via "bash-coding-utils.sh"
   "guix-jupyter"
))
(specifications->manifest
 (append (list "hello")
         build-pkgs
         admin-pkgs
         desktop-pkgs
         misc-pkgs
         net-pkgs
         terminal-pkgs
         emacs-pkgs
         font-pkgs
         python-dev-pkgs
         guile-dev-pkgs
          '()
          ))
;; (append (list "hello")
;;          ;;build-pkgs
;;          admin-pkgs
;;          desktop-pkgs
;;          misc-pkgs
;;          net-pkgs
;;          terminal-pkgs
;;          emacs-pkgs
;;          font-pkgs
;;          python-dev-pkgs
;;          guile-dev-pkgs)
