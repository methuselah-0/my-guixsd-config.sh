;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules 
	(gnu)
        (gnu system nss) ; nameservice switch
	(guix build-system gnu)
	(guix build-system haskell)
	(guix build utils)
	(guix gexp)
	(guix modules)
	(guix packages)
	(guix store)	
	(srfi srfi-1) ; for remove function "alist-delete"
	(srfi srfi-26)
	(ice-9 ftw)
	(guix monads))
(use-service-modules
        admin
        audio
        base
        cups
        dbus
        desktop
        mcron
        networking
        sddm
        ssh
        web
        xorg ; contained in service-module desktop if using that
        )
(use-package-modules
        abduco
        admin
        algebra ; for bc package
        autotools
        bash
        base
        certs ; https etc.
        commencement ; gcc-toolchain
        compression
        compton
        conkeror
        cryptsetup
        curl
        databases ; recsel command
        disk
        display-managers ;; sddm
        dns ; dnsmasq for virtualization
        dvtm ;; terminal dynamic window manager
        emacs
        enlightenment
        file
        flashing-tools ; for flashrom to configure grub in libreboot.
        fonts
        fontutils
        freedesktop ; xdg-utils, wayland
        gawk
        ;geiser
        ghostscript
        ;git
        gl ; for mesa and mesa-utils
        glib
        gnome
        gnupg ; https etc
        gnuzilla
        graphviz
        gtk
        guile
        haskell
        image-viewers
        irc
        java
        javascript
        ;; Terminal & Console
        linux ; inotify-tools
        libreoffice
        lisp
        ;; Utils
        mail
        messaging ; for qtox and gajim
        mpd
        mtools
        ncurses
        pkg-config
        ;; Desktop & Office
        pdf
        perl
        ;; Messaging
        ;; Audio & Video
        pulseaudio ; pavucontrol
        ;;pulseaudio-alsa
        python
        ;; databases web php for mariadb nginx and php respectively.
        ;; Virtualization
        rsync
        ruby
        screen
        shells
        ssh
        suckless ; suckless for dmenu and more
        terminals
        texinfo
        text-editors ;; for vis package
        time ; time is for python2-dateutil
        tls ; for gnutls etc.
        version-control
        virtualization
        video ; ffmpeg mpv youtube-dl
        vpn
        web-browsers
        wicd
        wget
        wm ; ghc-xmonad-contrib
        spice
        xdisorg
        xfce
        xiph ; vorbis-tools
        xorg
        )

(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.  Here we write the
  ;; job's action as a Scheme procedure.
  #~(job '(next-hour '(3))
	 (lambda ()
	   (execl (string-append #$findutils "/bin/updatedb")
		  "updatedb"
		  "--prunepaths=/tmp /var/tmp /gnu/store"))))
(define garbage-collector-job
  ;; Collect garbage 5 minutes after midnight every day.
  ;; The job's action is a shell command.
  #~(job "5 0 * * *"            ;Vixie cron syntax
	 "guix gc -F 1G"))
;(define my-screenlocker
;  #~(job "0 0 0 0 5"
					;	 "
(operating-system
  (host-name "server1")
  (timezone "Europe/Stockholm")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "my-root"
  ;; is the label of the target root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi"))) ; create /mnt/boot/efi and mount efi partition there during guix system init

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  (mapped-devices
   (list (mapped-device
          (source "/dev/sda2")
          (target "fs_root")
          (type luks-device-mapping))))

  (file-systems (cons* (file-system
                        (device "/dev/mapper/fs_root")
                        (title 'device)
                        (mount-point "/")
                        (type "btrfs")
			(needed-for-boot? #t)
                        (dependencies mapped-devices))
		      (file-system
			(device "/dev/sda1")
			(mount-point "/boot/efi")
			(type "vfat"))
                      %base-file-systems))

  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   #:extra-modules '("btrfs")
                   rest)))
  (kernel-arguments '("modprobe.blacklist=pcspkr,snd_pcsp"))
  (users (cons (user-account
                (name "user1")
                (comment "user1")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"
					"kvm" "lp"))
                (home-directory "/home/user1"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons*
             ;; Utils
             abduco
             alpine
             alsa-lib
             alsa-plugins
             alsa-utils ;; Audio & Video
             arandr
             autoconf
             automake
             autobuild ; autotools
             bash-completion
             bc
             beep
             binutils ; base
             bridge-utils ; virtualization, brctl
             btrfs-progs
             ;;bzip2 ; "conflicting entry"
             byobu ;; screen enhanced
             cl-stumpwm
             compton
             conkeror
             cpulimit
             cryptsetup ; mounting various file-systems etc
             dconf-editor
             dnsmasq ; virtualization
             dmenu
             dvtm
             dzen
             curl
             ;; Office
             emacs
             emacs-guix
             emacs-nginx-mode
             emacs-scheme-complete
             emacs-pdf-tools
             emacs-rudel
             emacs-wget
             emacs-lispy
             ;;emacs-org-contrib ; text-editing, temporarily disabled
             exfat-utils
             enlightenment
             fbcat
             fuse
             fuse-exfat
             ;; diffutils
             file ; findutils
             flashrom ; admin tools
             fbida ; framebuffer graphics
             ffmpeg ;; Audio fromat converter
             flac ;; flac audio format
             ;font-abattis-cantarell
             font-anonymous-pro
             font-awesome
             font-bitstream-vera
             font-dejavu
             font-fantasque-sans
             font-fira-mono
             font-gnu-freefont-ttf
             font-gnu-unifont
             font-go
             font-google-material-design-icons
             font-google-noto
             font-google-roboto
             font-hack
             font-inconsolata
             font-liberation
             ;font-linux-libertine
             font-mathjax
             font-rachana
             font-tamzen
             font-terminus
             font-tex-gyre
             font-ubuntu
             font-un
             font-util
             fontconfig
             ftgl
             ;font-mutt-misc
             feh
             geiser
             git
             gnome-tweak-tool
             gnupg ;for HTTPS access
             gnu-make
             gnutls
             ;;guile2.2-gnutls
             ;;guile2.2-json
             gpgme
             graphviz ; pdf tools
             gs-fonts
             gvfs ; user mounts
             ghc-x11-xft
             gcc-toolchain ; xmonad
             ghc-xmonad-contrib
             ghc
             ghc-network
             glib
             glibc-locales
             glibc-utf8-locales ; locales
             ;;gtk2fontsel
             gsettings-desktop-schemas
             htop
             iptables ; firewall, used for virtualization also
             icecat ; browser
             icedtea ; browser plugin
             ;; enlightenment
             gajim ; xmpp
             gtk+
             gtkglext
             kbd
             libgcrypt ; for compiling alock with something (see my-xmonad.sh)
             ;;libreoffice ; office suite
             libnotify
             libtool
             libxft ; xft fonts
             libxfont ; xmonad
             linux-pam ; for compiling alock with --enable-pam module
             ltrace
             lynx
             mpv ; Video-player
             mcron ; Schedule commands
             mesa
             mesa-utils
             mtools
             mupdf ; pdf tools
             mpd ; music player daemon
             mpd-mpc ; cli for mpd
             ncmpcpp ; mpd music daemon, mpd cli, and mpd-client.
             ncurses ; terminal menus written in C
             nss-certs ; certificates
             net-tools
             nmap ; check ports etc. - network tool
             ;; Virtualization
             openvpn ; virtualization, mktun
             openssh ; SSH access
             pinentry
             pinentry-tty
             pinentry-qt
             ;;pinentry-gtk
             pulseaudio
             ponymix
             pavucontrol
             perl
             python-3.6
             ;;python-2.7
             python2-dateutil
             python2-vobject ;;python
             paredit ; programming tools
             pavucontrol                ;; Audio & Video
             pkg-config
             qemu
             qtox ; tox
             recutils ; location: databases
             rxvt-unicode
             rsync ; rsync
             screen
             sddm
             setxkbmap
             spice ; virtualization
             sshfs-fuse
             ; tar ; "conflicting entry"
             terminology ; terminals
             termite ;; wayland-native terminal
             texinfo
             tree; terminal and console
             unclutter
             unzip
             vis
             ; util-linux, disabled due to "conflicting entries"
             vorbis-tools               ;; Audio & Video
             wayland
             weechat
             wicd
             wget
             wpa-supplicant
             ;; Desktop
             xauth
             xbacklight
             xclip
             xdg-utils
             xdotool; xmonad window manager related
             xfce4-pulseaudio-plugin            ;; Audio & Video
             xf86-video-qxl
             xf86-video-fbdev
             xinit
             xkill
             xlsfonts ; font
             xmodmap
             xmonad ;
             ; xmobar ; xmonad
             xorg-server
             ;xorg-xfontsel ; font
             xrandr
             xscreensaver
             xsensors
             xset ; xorg display server related
             xsetroot
             youtube-dl         ;; Audio & Video
             zip
             %base-packages))

                ;; Server stack
                ; mariadb nginx php letsencrypt

  ;; Using the "desktop" services includes
  ;; the X11 log-in service, networking with Wicd, and more.
  (services (cons*
                (gnome-desktop-service)
                (xfce-desktop-service)
                (console-keymap-service "sv-latin1")
                ;;(slim-service) ; login screen
                (sddm-service (sddm-configuration
                               (display-server "wayland")))
                (service cups-service-type
                         (cups-configuration
                          (web-interface? #t)
                          (log-level 'debug2)))

                ;;(dhcp-client-service)
                ;(remove (lambda (service)
                                        ;    (eq? (service-kind service) wicd-service-type))
                (service mpd-service-type
                         (mpd-configuration
                          (user "user1")
                                    (port "6666")))
                (gpm-service)
                (screen-locker-service slock "slock")
                (service mcron-service-type)
;;              (lsh-service #:port-number 2222)
                (service openssh-service-type
                         (openssh-configuration
                          (port-number 2222)
                          (x11-forwarding? #t)
                         ))
                (mcron-service (list garbage-collector-job
                                     updatedb-job))
                (service nginx-service-type
                         (nginx-configuration
                          (server-blocks
                           (list (nginx-server-configuration
                                  (server-name '("localhost"))
                                  (root "/srv/http/localhost")
                                  )))))
                ;;(wicd-service) ; network service ;; provided by %desktop-services
                (service network-manager-service-type (network-manager-configuration))
                (dbus-service) ; IPC or Inter-Process-Communication. ;; provided by %desktop-services
                (service wpa-supplicant-service-type wpa-supplicant)
                (udisks-service) ;; provided by %desktop-services
                (upower-service) ;; provided by %desktop-services
                (colord-service) ;; provided by %desktop-services
                (bluetooth-service) ;; provided by %desktop-services
                (geoclue-service) ;; provided by %desktop-services
                (polkit-service) ;; ;; provided by %desktop-services
                (accountsservice-service) ;; provided by %desktop-services
                (elogind-service #: config (elogind-configuration (handle-lid-switch 'ignore))) ;; provided by %desktop-services
                (ntp-service #:allow-large-adjustment? #t) ;; network time protocol ;; provided by %desktop-services
                %base-services )) ; desktop services provide lots of default services.
;;          %desktop-services )) ; desktop services provide lots of default services.

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
