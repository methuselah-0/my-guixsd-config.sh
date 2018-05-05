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
        certbot
	cups
	dbus
	desktop
        mcron
	networking
	sddm
	ssh
        version-control
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
        networking ;; aircrack-ng
        node ;; npm to install tern for company-tern for javascript completion in emacs
	pkg-config
	;; Desktop & Office
	pdf
	perl
	;; Messaging
	;; Audio & Video
	pulseaudio ; pavucontrol
	;;pulseaudio-alsa
	python
        python-crypto
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
        ;;web
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
(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
     #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
         (kill pid SIGHUP))))
(define %certbot-config
  (certbot-configuration
   (email "hostmaster@selfhosted.xyz")
   (webroot "/srv/http/localhost/")
   (certificates
    (list
     (certificate-configuration
      (domains '("server1.selfhosted.xyz"))
      (deploy-hook %nginx-deploy-hook))))))
(define %custom-ssl-rules
  '(;; disable weak cipher suites
    "ssl_ciphers HIGH:!aNULL:!MD5;"
    "ssl_prefer_server_ciphers on;"

    ;; disable ssl
    "ssl_protocols TLSv1.2;"

    ;; Use our own DH parameters created with:
    ;;    openssl dhparam -out dhparams.pem 2048
    ;; as suggested at <https://weakdh.org/sysadmin.html>.
    "ssl_dhparam /etc/dhparams.pem;"))
(define (cert-path host file)
;;  (format #f "/etc/letsencrypt/live/~a/~a.pem" host (symbol->string file))
    (format #f "/etc/~a/~a.pem" host (symbol->string file))
  )
(define %nginx-config
(nginx-configuration
 (server-blocks
  (list (nginx-server-configuration
         (server-name '("server1.selfhosted.xyz"))
         (root "/srv/http/localhost/")
         (listen '("443 ssl" "[::]:443 ssl"))
         (locations
          (list
           (nginx-location-configuration
            (uri "/")
            (body (list "index index.html;")))))
         ;; (ssl-certificate #f) ;; use before you have activated certbot
         ;; (ssl-certificate-key #f) ;; use before you have activated certbot
         (ssl-certificate (cert-path "server1.selfhosted.xyz" 'fullchain))
;;         (ssl-certificate "/etc/letsencrypt/live/server1.selfhosted.xyz/fullchain.pem")
         (ssl-certificate-key (cert-path "server1.selfhosted.xyz" 'privkey))         
;;         (ssl-certificate-key "/etc/letsencrypt/live/server1.selfhosted.xyz/privkey.pem")
         (raw-content %custom-ssl-rules)
         )))))
(define %public-repositories
  '("my-guix-config"
    "renew-tls-tlsa.sh"
    "nextcloud-suite.sh"
    "misc"
    "qemu-scripts.sh"))

;; I had to do chmod 750/640 (+x for hooks), chown -R git:git-daemon on
;; /var/lib/git/repositories

(define %git-daemon-config
  (git-daemon-configuration
   (base-path "/var/lib/git/repositories")
   (export-all? #t) ; export all whitelisted repos
   (whitelist (map (lambda (repository)
                     (string-append "/var/lib/git/repositories/" repository))
                   %public-repositories))))

(operating-system
 (host-name "server1")
 (hosts-file
  ;; Create a /etc/hosts file with aliases for "localhost"
  ;; and "mymachine", as well as for Facebook servers.
  (plain-file "hosts"
	      (string-append (local-host-aliases host-name)
			     %facebook-host-aliases)))
  (timezone "Europe/Stockholm")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "fs_root"
  ;; is the label of the target root file system.
  (bootloader (grub-configuration (target "/dev/sda")))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  (mapped-devices
   (list (mapped-device
          (source "/dev/sda1")
          (target "fs_root")
          (type luks-device-mapping))))

  (file-systems (cons (file-system
                        (device "/dev/mapper/fs_root")
                        (title 'device)
                        (mount-point "/")
                        (type "btrfs")
                        (needed-for-boot? #t)
                        (dependencies mapped-devices))
                      %base-file-systems))

  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   #:extra-modules '("btrfs")
                   rest)))
  (kernel-arguments (list "modprobe.blacklist=pcspkr,snd_pcsp")) ;; disable annoying console beeps.
  (groups (cons* (user-group (name "git-daemon"))
                 %base-groups))
  
  (users (cons* (user-account
                 (name "user1")
                 (comment "user1")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev"
                                         "audio" "video"
                                         "kvm" "lp")) ;; users need to be in the LP group to access dbus-services (e.g. wicd)
                 (home-directory "/home/user1"))
                (user-account
                 (name "vmail")
                 (comment "vmail")
                 (group "nogroup")
                 (home-directory "/var/lib/vmail"))
                (user-account
                 (name "git")
                 (comment "git")
                 (group "git-daemon") ; so to give read access to git-daemon
                 (home-directory "/var/lib/git"))
                %base-user-accounts))
  
  ;; This is where we specify system-wide packages.
  (packages (cons* 
	     ;; Login
	     sddm
	     wayland
             ;; Mounting various file-systems etc             
	     btrfs-progs             
	     cryptsetup
	     exfat-utils
	     fuse
	     fuse-exfat
	     sshfs-fuse
	     gvfs ; user mounts             

             ;; Build stuff
	     autoconf
	     automake
	     autobuild ; autotools
	     gnu-make
             
    	     binutils ; base	     	     

             ;; Office
	     ftgl

	     gnupg ;for HTTPS access
	     gnutls ;for HTTPS access
             
	     glib
             glibc-locales
	     glibc-utf8-locales ; locales
	     ;;gtk2fontsel

	     gtk+
	     gtkglext
	     kbd

	     libtool

	     mcron ; Schedule commands		
	     mesa
	     mesa-utils
	     mtools				

	     ncurses ; terminal menus written in C
	     nss-certs ; certificates

	     ;; Virtualization

	     pkg-config
	     ; tar ; "conflicting entry"
	     ; util-linux, disabled due to "conflicting entries"
	     %base-packages))
		
  ;; Using the "desktop" services includes 
  ;; the X11 log-in service, networking with Wicd, and more.
  (services (cons* 
             (gnome-desktop-service)
             ;;(xfce-desktop-service)
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
             ;;mpd needs started as normal user. herd stop mpd as root first (plus create ~/.mpd dir).
             (service mpd-service-type
                      (mpd-configuration
                       (user "user1") ;; default is mpd
                       (port "6600"))) ;; 6600 is default
             (gpm-service)
             (screen-locker-service slock "slock")
             ;;		(lsh-service #:port-number 2222)
             (service openssh-service-type
                      (openssh-configuration
                       (port-number 2222)
                       (x11-forwarding? #t)
                       ))
             ;; (service sysctl-service-type
             ;; 	 (sysctl-configuration
             ;; 	  (settings '(("net.ipv4.ip_forward" . "1")))))
             (mcron-service (list garbage-collector-job
                                  updatedb-job))
             (service rottlog-service-type)		
             (service nginx-service-type %nginx-config)
             (service fcgiwrap-service-type)
             (service certbot-service-type %certbot-config)                      
             ;; (service cgit-service-type)
             ;; (service cgit-service-type
             ;; 	 (cgit-configuration
             ;; 	             (config-file (local-file "./my-cgitrc.conf"))))
             ;;(wicd-service) ; network service ;; provided by %desktop-services		
             (service network-manager-service-type (network-manager-configuration))
             (dbus-service) ; IPC or Inter-Process-Communication. ;; provided by %desktop-services
             (service wpa-supplicant-service-type wpa-supplicant)		
             (udisks-service) ;; also provided by %desktop-services
             (upower-service) ;; also provided by %desktop-services
             (colord-service) ;; also provided by %desktop-services
             (bluetooth-service) ;; also provided by %desktop-services
             (geoclue-service) ;; also provided by %desktop-services
             (polkit-service) ;; ;; also provided by %desktop-services
             (accountsservice-service) ;; also provided by %desktop-services
             (elogind-service #:config (elogind-configuration (handle-lid-switch 'ignore))) ;; also provided by %desktop-services
             (ntp-service #:allow-large-adjustment? #t) ;; network time protocol ;; also provided by %desktop-services
             %base-services)) ; desktop services provide lots of default services.
  ;;	    %desktop-services )) ; desktop services provide lots of default services.		
  
  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
