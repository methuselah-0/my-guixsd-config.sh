;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) (gnu system nss))
;;(use-service-modules desktop ssh spice cuirass)
(use-service-modules
 admin
 audio
 base
 certbot
 cuirass
 cups
 dbus
 desktop
 mcron
 networking
 sddm
 sound
 spice
 ssh
 version-control
 web
 xorg ; contained in service-module desktop if using that
)

(use-package-modules admin certs gnome ssh bash)

(define %my-special-files
  `(("/bin/sh" ,(file-append bash "/bin/sh"))
    ("/bin/bash" ,(file-append bash "/bin/bash"))
    ;; gitolite update hook needs it
;;    ("/usr/bin/perl" ,(file-append perl "/bin/perl"))
    ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))


;; https://lists.gnu.org/archive/html/help-guix/2018-08/msg00058.html
;; info cuirass for up to date manual information
(define %cuirass-specs
  #~(list
      '((#:name . "user1-manifest")
        (#:load-path-inputs . ("guix"))
        (#:package-path-inputs . ("bash-coding-utils"))
        (#:proc-input . "guix")
        (#:proc-file . "build-aux/cuirass/gnu-system.scm")
        ;; (#:proc-input . "config")        
        ;; (#:proc-file . "drv-list.scm")
        (#:proc . cuirass-jobs)
        ;; (#:proc-args . ((subset . "manifests")
        ;;                 (systems . ("x86_64-linux"))
        ;;                 (manifests . (("config" . "user1.scm") ))
        ;;                 ))
        ;; (#:proc-args . ((subset . "libhandy")
        ;;                 (systems . ("x86_64-linux"))
        ;;                 ;; (manifests . (("config" . "user1.scm") ))
        ;;                 ))
        
        (#:proc-args . ((subset . "manifests")
                        (systems . ("x86_64-linux"))
                        (manifests . (("user1.scm") ))))
                        ;; (manifests . (("config" . "user1.scm") ))))
        (#:inputs . (
                     ((#:name . "guix")
                      (#:url . "git://git.savannah.gnu.org/guix.git")
                      (#:load-path . ".")
                      (#:branch . "master")
                      (#:no-compile? . #t))
                     ((#:name . "config")
                     ;;  (#:url . "git://git.example.org/config.git")
                      (#:url . "file:///home/user1/src/my-guixsd-config.sh")
                      (#:load-path . ".")
                      (#:branch . "master")
                      (#:no-compile? . #t))
                     ((#:name . "bash-coding-utils")
                      (#:url . "https://gitlab.com/methuselah-0/bash-coding-utils.sh.git")
                      (#:load-path . "/guix-channel")
                      (#:branch . "master")
                      (#:no-compile? . #t)))))
      ;; '((#:name . "hello")
      ;;   (#:load-path-inputs . ("guix"))
      ;;   (#:package-path-inputs . ("bash-coding-utils"))
      ;;   (#:proc-input . "guix")
      ;;   (#:proc-file . "build-aux/cuirass/gnu-system.scm")
      ;;   ;; (#:proc-input . "config")        
      ;;   ;; (#:proc-file . "drv-list.scm")
      ;;   (#:proc . cuirass-jobs)
      ;;   (#:proc-args . ((subset . "hello")
      ;;                   (systems . ("x86_64-linux"))
      ;;                   ;; (manifests . (("config" . "user1.scm") ))
      ;;                   ))
        
      ;;   ;; (#:proc-args . ((subset . "manifests")
      ;;   ;;                 (systems . ("x86_64-linux"))
      ;;   ;;                 (manifests . (("user1.scm") ))))
      ;;                   ;; (manifests . (("config" . "user1.scm") ))))
      ;;   (#:inputs . (
      ;;                ((#:name . "guix")
      ;;                 (#:url . "git://git.savannah.gnu.org/guix.git")
      ;;                 (#:load-path . ".")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t))
      ;;                ((#:name . "config")
      ;;                ;;  (#:url . "git://git.example.org/config.git")
      ;;                 (#:url . "file:///home/user1/src/my-guixsd-config.sh")
      ;;                 (#:load-path . ".")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t))
      ;;                ((#:name . "bash-coding-utils")
      ;;                 (#:url . "https://gitlab.com/methuselah-0/bash-coding-utils.sh.git")
      ;;                 (#:load-path . "/guix-channel")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t)))))
      ;; '((#:name . "bash-coding-utils.sh")
      ;;   (#:load-path-inputs . ("guix"))
      ;;   (#:package-path-inputs . ("bash-coding-utils"))
      ;;   (#:proc-input . "guix")
      ;;   (#:proc-file . "build-aux/cuirass/gnu-system.scm")
      ;;   ;; (#:proc-input . "config")        
      ;;   ;; (#:proc-file . "drv-list.scm")
      ;;   (#:proc . cuirass-jobs)
      ;;   (#:proc-args . ((subset . "bash-coding-utils.sh")
      ;;                   (systems . ("x86_64-linux"))
      ;;                   ;; (manifests . (("config" . "user1.scm") ))
      ;;                   ))
        
      ;;   ;; (#:proc-args . ((subset . "manifests")
      ;;   ;;                 (systems . ("x86_64-linux"))
      ;;   ;;                 (manifests . (("user1.scm") ))))
      ;;                   ;; (manifests . (("config" . "user1.scm") ))))
      ;;   (#:inputs . (
      ;;                ((#:name . "guix")
      ;;                 (#:url . "git://git.savannah.gnu.org/guix.git")
      ;;                 (#:load-path . ".")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t))
      ;;                ((#:name . "config")
      ;;                ;;  (#:url . "git://git.example.org/config.git")
      ;;                 (#:url . "file:///home/user1/src/my-guixsd-config.sh")
      ;;                 (#:load-path . ".")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t))
      ;;                ((#:name . "bash-coding-utils")
      ;;                 (#:url . "https://gitlab.com/methuselah-0/bash-coding-utils.sh.git")
      ;;                 (#:load-path . "/guix-channel")
      ;;                 (#:branch . "master")
      ;;                 (#:no-compile? . #t)))))
      ))

(operating-system
 (host-name "librem13v3guixsd")
 (timezone "Europe/Stockholm")
 (locale "en_US.utf8")
 
 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
                (target "/dev/vda")))
 (file-systems (cons (file-system
                      (device (file-system-label "fsroot"))
                      (mount-point "/")
                      (type "btrfs"))
                     %base-file-systems))
 
 (users (cons* (user-account
                (name "user1")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/user1"))
               (user-account
                (name "cuirass")
                (group "cuirass")
                (supplementary-groups '("netdev"
                                        "audio" "video"))
                (home-directory "/home/cuirass"))
               %base-user-accounts))
 
 ;; This is where we specify system-wide packages.
 (packages (cons* nss-certs         ;for HTTPS access
                  ;;gvfs              ;for user mounts
		  le-certs
                  %base-packages))
 
 ;; Add GNOME and/or Xfce---we can choose at the log-in
 ;; screen with F1.  Use the "desktop" services, which
 ;; include the X11 log-in service, networking with
 ;; NetworkManager, and more.
 (services (cons* (service gnome-desktop-service-type)
                  (spice-vdagent-service)
                  (service openssh-service-type
                           (openssh-configuration
                            (permit-root-login #t)
                            ;;(allow-empty-passwords? #t)
                            (x11-forwarding? #t)
                            (port-number 2222)))
                  ;; https://lists.gnu.org/archive/html/help-guix/2019-06/msg00116.html
                  (service cuirass-service-type
                           (cuirass-configuration
                            (interval 60)
                            ;; (use-substitutes? #t)
                            (fallback? #t) ;; default is #f
                            (host "0.0.0.0")
                            (port 8082)
                            (database "/var/lib/cuirass/cuirass.db") ;; default is /var/lib/cuirass/cuirass.db
                            (specifications %cuirass-specs)))
                  ;; https://lists.gnu.org/archive/html/help-guix/2017-08/msg00095.html
                  (simple-service 'store-my-config
                                  etc-service-type
                                  `(("config.scm"
                                     ,(local-file (assoc-ref
                                                   (current-source-location)
                                                   'filename)))))
		  ;; (service console-keymap-service-type "sv-latin1")
		  (service slim-service-type) ; login screen
		  ;;             (sddm-service (sddm-configuration
		  ;;                            (display-server "wayland")))
		  ;;                            (display-server "x11")))
		  ;; (service cups-service-type
		  ;; 	   (cups-configuration
		  ;; 	    (web-interface? #t)
		  ;; 	    (log-level 'debug2)))
		  ;;(dhcp-client-service)
                                        ;(remove (lambda (service)
					;    (eq? (service-kind service) wicd-service-type))
		  ;;mpd needs started as normal user. herd stop mpd as root first (plus create ~/.mpd dir).
		  ;; (service mpd-service-type
		  ;; 	   (mpd-configuration
		  ;; 	    (user "user1") ;; default is mpd
		  ;; 	    (port "6600"))) ;; 6600 is default
		  (service gpm-service-type)
		  (service alsa-service-type)
		  (service special-files-service-type %my-special-files)
		  ;;(screen-locker-service slock "slock")
		  ;;		(lsh-service #:port-number 2222)

		  ;; (service openssh-service-type
		  ;;          (openssh-configuration
		  ;;           (port-number 2222)
		  ;;           (x11-forwarding? #t)
		  ;;           )) 

		  ;; (service sysctl-service-type
		  ;; 	 (sysctl-configuration
		   ;; 	  (settings '(("net.ipv4.ip_forward" . "1")))))
		  ;;(mcron-service (list garbage-collector-job
		  ;;                     network-check
		  ;;                     updatedb-job))
		  ;;(service rottlog-service-type)		
		  ;;(service nginx-service-type %nginx-config)
		  ;;(service fcgiwrap-service-type)
		  ;;(service certbot-service-type %certbot-config)                      
		  ;; (service cgit-service-type)
		  ;; (service cgit-service-type
		  ;; 	 (cgit-configuration
		  ;; 	             (config-file (local-file "./my-cgitrc.conf"))))
		  ;;(wicd-service) ; network service ;; provided by %desktop-services		
		  (service network-manager-service-type (network-manager-configuration))
		  (dbus-service) ; IPC or Inter-Process-Communication. ;; provided by %desktop-services
		  ;; (service wpa-supplicant-service-type wpa-supplicant)
		  (service wpa-supplicant-service-type)		             
		  ;;(udisks-service) ;; also provided by %desktop-services
		  (service upower-service-type) ;; also provided by %desktop-services
		  (colord-service) ;; also provided by %desktop-services
		  (bluetooth-service) ;; also provided by %desktop-services
		  (geoclue-service) ;; also provided by %desktop-services
		  ;;(polkit-service) ;; ;; also provided by %desktop-services
		  (accountsservice-service) ;; also provided by %desktop-services
		  (elogind-service #:config (elogind-configuration (handle-lid-switch 'ignore))) ;; also provided by %desktop-services
		  (service ntp-service-type) ;; #:allow-large-adjustment? #t) ;; network time protocol ;; also provided by %desktop-services
		  
		  ;; (modify-services
		  ;;  (guix-service-type config => 
		  ;; 		      (guix-configuration
		  ;; 		       (inherit config)
		  ;; 		       (substitute-urls
		  ;; 			(cons* '("https://mirror.hydra.gnu.org" "https://mirror.guixsd.org" "https://berlin.guixsd.org")
		  ;; 			      %default-substitute-urls))))
		  ;; 			;			    (extra-options
		  ;; 			;			      '("--cores=1"))))) ; to avoid overheating from build-processes
		  %base-services)) ; desktop services provide lots of default services.
 
 ;; %desktop-services))
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
