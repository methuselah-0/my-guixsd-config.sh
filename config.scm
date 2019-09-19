;; -*- geiser-scheme-implementation: guile -*-
;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules 
 (gnu)
 (gnu system nss) ; nameservice switch
 (gnu system locale) ; seems to be required for locale from now on
 (guix build-system ant)
 (guix build-system asdf)
 (guix build-system cargo)
 (guix build-system cmake)
 (guix build-system dub)
 (guix build-system emacs)
 (guix build-system font)       
 (guix build-system gnu)
 (guix build-system go)
 (guix build-system haskell)
 (guix build-system glib-or-gtk)
 (guix build-system meson)              
 (guix build-system minify)
 (guix build-system ocaml)
 (guix build-system python)                
 (guix build-system perl)
 (guix build-system r)
 (guix build-system ruby)
 (guix build-system scons)
 (guix build-system texlive)                        
 (guix build-system waf)
 (guix build utils)
 (guix gexp)
 (guix modules)
 (guix packages)
 (guix store)
 (srfi srfi-1) ; for remove function "alist-delete"
 (srfi srfi-26)
 (srfi srfi-34) 
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
 sound
 ssh
 version-control
 web
 xorg ; contained in service-module desktop if using that
 )
(use-package-modules
 admin
 autotools ;; autoconf and other build-packages
 bash	
 certs ; https etc.
 cups
 cryptsetup
 display-managers ;; sddm
 enlightenment 
 fonts
 freedesktop ; xdg-utils, wayland
 ghostscript ;; gs-fonts package
 gnome ;; gvfs for user-mounts
 gnupg ; https etc
 javascript ;; font-mathjax 
 linux ; btrfs-progs, inotify-tools
 mtools ;; exfat-utils
 perl
 pulseaudio
 suckless ; suckless for slock screensaver service, dmenu and more 
 tls ; for gnutls etc.
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
(define fetch-calendars
  #~(job "5 * * * *"
	 "/home/user1/bin/fetch-calendars.pl"))
;; (define fetch-calendars
;;   #~ (job '(next-minute (range 0 60 5)) "/home/user1/bin/fetch-calendars.pl"))

(define network-check
  #~(job "5 * * * *"
	 "curl ipinfo.io >/dev/null 2>/dev/null || herd restart networking"))
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
  '("my-guixsd-config"
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
(define %my-special-files
  `(("/bin/sh" ,(file-append bash "/bin/sh"))
    ("/bin/bash" ,(file-append bash "/bin/bash"))
    ;; gitolite update hook needs it
;;    ("/usr/bin/perl" ,(file-append perl "/bin/perl"))
    ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))

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
			(options "subvolid=363,subvol=/snap2_rw")
                        (dependencies mapped-devices))
                      %base-file-systems))

  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   #:extra-modules '("btrfs")
                   rest)))
  (kernel-arguments (list "modprobe.blacklist=pcspkr,snd_pcsp" "iomem=relaxed")) ;; disable annoying console beeps. enable access to /dev/mem for the flashrom tool
  (groups (cons* (user-group (name "git-daemon"))
                 %base-groups))
  
  (users (cons* (user-account
                 (name "user1")
                 (comment "user1")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev"
                                         "audio" "video"
                                         "kvm" "lp")) ;; users need to be in the LP group to access dbus-services (e.g. wicd, bluetooth)
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
	     ;; Login screen
	     sddm
	     wayland
             ;;enlightenment

             ;; xorg fonts
;;             font-util
;;             fontconfig
;;             font-mutt-misc
;;             libxft ; xft fonts
;;             ghc-x11-xft
;;             libxfont ; xmonad
             ;; "ftgl" ; uses Freetype2 to simplify rendering fonts in OpenGL applications
    
             ;; Mounting various file-systems etc             
	     btrfs-progs ;; btrfs filesystem utilities
	     cryptsetup ;; luks-encrypted volumes
	     exfat-utils
	     fuse
	     fuse-exfat
	     sshfs-fuse
	     mtools  ;; access ms-dos disks etc.             
	     gvfs ; user mounts

             ;; Build stuff
	     autoconf
	     automake
	     autobuild ; autotools
	     gnu-make
             binutils

             ;; SSL, HTTPS access
	     nss-certs ; certificates             
	     gnupg
	     gnutls

             ;; Locale
             glibc-locales
	     glibc-utf8-locales

	     kbd ;; loadkeys command etc.
	     libtool
             perl ;; cronjob perl-scripts

	     %base-packages))
		
  ;; Using the "desktop" services includes 
  ;; the X11 log-in service, networking with Wicd, and more.
  (services (cons* 
             (gnome-desktop-service)
             (service enlightenment-desktop-service-type)
             ;;(xfce-desktop-service)
             (console-keymap-service "sv-latin1")
             (slim-service) ; login screen
;;             (sddm-service (sddm-configuration
;;                            (display-server "wayland")))
;;                            (display-server "x11")))
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
	     (service alsa-service-type)
             (service special-files-service-type %my-special-files)
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
                                  network-check
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
             ;; (service wpa-supplicant-service-type wpa-supplicant)
             (service wpa-supplicant-service-type)		             
             (udisks-service) ;; also provided by %desktop-services
             (upower-service) ;; also provided by %desktop-services
             (colord-service) ;; also provided by %desktop-services
             (bluetooth-service) ;; also provided by %desktop-services
             (geoclue-service) ;; also provided by %desktop-services
             (polkit-service) ;; ;; also provided by %desktop-services
             (accountsservice-service) ;; also provided by %desktop-services
             (elogind-service #:config (elogind-configuration (handle-lid-switch 'ignore))) ;; also provided by %desktop-services
             (ntp-service #:allow-large-adjustment? #t) ;; network time protocol ;; also provided by %desktop-services
	     (modify-services
		(guix-service-type config => 
			(guix-configuration
			  (inherit config)
			  (substitute-urls
			    (cons *
 "https://mirror.hydra.gnu.org" "https://mirror.guixsd.org" "ci.guix.gnu.org"
			      "https://berlin.guixsd.org"
			      %default-substitute-urls))))
;			    (extra-options
;			      '("--cores=1"))))) ; to avoid overheating from build-processes
             %base-services))) ; desktop services provide lots of default services.
  ;;	    %desktop-services )) ; desktop services provide lots of default services.		
  
  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
