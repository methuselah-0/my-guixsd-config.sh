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
   "emacs-paredit"        ;; emacs-paredit
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
   "font-abattis-cantarell"
   "font-anonymous-pro"
   "font-awesome"
   "font-bitstream-vera"
   "font-dejavu"
   "font-fantasque-sans"
   "font-fira-mono"
   "font-gnu-freefont-ttf"
   "font-gnu-unifont"
   "font-go"
   "font-google-material-design-icons"
   "font-google-noto"
   "font-google-roboto"
   "font-hack"
   "font-inconsolata"
   "font-liberation"
   ;;"font-linux-libertine"
   "font-mathjax"
   "font-rachana"
   "font-tamzen"
   "font-terminus"
   "font-tex-gyre"
   "font-ubuntu"
   "font-un"
   "font-util"
   "fontconfig"
   "font-mutt-misc"
   "gs-fonts"
   "libxft" ; xft fonts
   "ghc-x11-xft"
   "libxfont" ; xmonad
   "ftgl" ; uses Freetype2 to simplify rendering fonts in OpenGL applications
   ))

(define misc-utils-packages
  (list
   "audit"
   "cpulimit"   
   "file" ; findutils   
   "flashrom"
   "gpgme"
   "graphviz" ; pdf tools   
   "htop"
   ;;bzip2 ; "conflicting entry"
   ;; diffutils
   "lvm2"
   "mupdf" ; pdf tools   
   "openssh" ; SSH access
   ;; "openssl@1.0.2n" ; 1.1.0h version is incompatible with the spice package
   ;;"openssl"
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
   "gtkglext" ;; make gtk-widgets OpenGL compatible, etc.
   ))
(specifications->manifest
 (append (list "hello")
;;	 audio-video-packages
;;	 desktop-packages
	 emacs-packages
;;	 font-packages
;;	 messaging-packages
	 misc-utils-packages
	 net-tools-packages
;;	 programming-extra-packages
	 terminal-packages
	 virtualization-packages
;;	 web-packages
	 ))
