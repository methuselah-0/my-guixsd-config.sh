;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

;; added gnu packages only because of complaints in /var/log/cuirass/evaluations/1.gz
(use-modules (gnu) (gnu system nss) (gnu packages))
;; additions: spice, cuirass, virtualization (qemu-binfmt-service-type)
(use-service-modules networking ssh desktop spice cuirass virtualization)
;; additions: bash
(use-package-modules screen ssh gnome certs bash)

(define %my-special-files
  `(("/bin/sh" ,(file-append bash "/bin/sh"))
    ("/bin/bash" ,(file-append bash "/bin/bash"))
    ;; gitolite update hook needs it
    ;;    ("/usr/bin/perl" ,(file-append perl "/bin/perl"))
    ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))

;; to try new configs here, run:  rm -rf /home/cuirass/{my-guixsd-config.sh,my-guix-packages} ; cp -a /home/user1/src/{my-guix-packages,my-guixsd-config.sh} /home/cuirass/ ; chown -R cuirass:cuirass /home/cuirass/{my-guix-packages,my-guixsd-config.sh}  ; herd stop cuirass-web ; herd stop cuirass ; rm /var/lib/cuirass/cuirass.db* ; guix system reconfigure --allow-downgrades /home/user1/src/my-guixsd-config.sh/VM-configs/desktop_with_cuirass.scm ;  herd start cuirass ; sleep 1 ; herd restart cuirass-web ; tail -f /var/log/cuirass.log

                    ;; (((#:name . "divoplade-site")
                    ;;  (#:url . "file:///tmp/divoplade-site.git")
                    ;;  (#:load-path . ".")
                    ;;  (#:branch . "master")
                    ;;  (#:no-compile? . #t))

;; NOTE: if running this cuirass-specs with a /root/.config/guix/current somewhere after 594b2a1 cuirass-web will not report success vs failure etc. properly see bug-guix mail archive for around oct/nov 2020.
;; NOTE2: packages must have a proper license to not fail hard - strings or #f will cause a hard fail.
(define %cuirass-specs
  #~(
     ;; spec two
     list
     '((#:name . "my-pkgs")
       (#:load-path-inputs . ("guix"))
       (#:package-path-inputs . ("my-guix-packages"))
       (#:proc-input . "guix")
       (#:proc-file . "build-aux/cuirass/gnu-system.scm")
       (#:proc . cuirass-jobs)
       (#:proc-args .
        ((subset . "manifests")
         (systems . ("x86_64-linux"))
         (manifests . (("config" . "manifests/user1.scm")))
         ))
       (#:inputs . (
                    ((#:name . "guix")
                     (#:url . "git://git.savannah.gnu.org/guix.git")
                     (#:load-path . ".")
                     (#:branch . "master")
                     ;;(#:commit . "21df702808a8f4491e1ef5badc607748288fa69a")
                     ;; 
                     ;; d7 commit reports failed builds in /var/log/cuirass.log and cuirass-web reports them as scheduled.
                     ;;(#:commit . "d7e033b9a153a9e60f52ff64f4eb355c1c3d0a6e")
                  
                     ;; 594b commit works - success - until adding say perl, python or bash-coding-utils.sh package from my-guix-packages
                     ;;(#:commit . "594b2a116ea4267d88a294dd05f8dbbb8ce7bcc0")
                     (#:no-compile? . #t))
                    ;;still needs to be a git repo
                    ((#:name . "my-guix-packages")
                     ;;(#:url . "file:///home/cuirass/my-guix-packages")
                     (#:url . "https://github.com/methuselah-0/my-guix-packages.git")
                     (#:load-path . "packages")
                     (#:branch . "master")
                     (#:no-compile? . #t))
                 
                    ((#:name . "config")
                     ;;(#:url . "file:///home/cuirass/my-guixsd-config.sh")
                     (#:url . "https://github.com/methuselah-0/my-guixsd-config.sh.git")
                     (#:load-path . ".")
                     (#:branch . "master")
                     (#:no-compile? . #t))
                    ))
       (#:build-outputs . ()))))

(operating-system
  (host-name "librem13v3guixsd")
  (timezone "Europe/Stockholm")
  (locale "en_US.utf8")

  ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/vda")))
  (file-systems (cons (file-system
                        (device (file-system-label "fsroot"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons* (user-account
                 (name "user1")
                 (group "users")
                 
                 ;; Adding the account to the "wheel" group
                 ;; makes it a sudoer.  Adding it to "audio"
                 ;; and "video" allows the user to play sound
                 ;; and access the webcam.
                 (supplementary-groups '("wheel"
                                         "audio" "video"))
                 (home-directory "/home/user1"))
                (user-account
                 (name "user2")
                 (group "users")
                 
                 ;; Adding the account to the "wheel" group
                 ;; makes it a sudoer.  Adding it to "audio"
                 ;; and "video" allows the user to play sound
                 ;; and access the webcam.
                 (supplementary-groups '("wheel"
                                         "audio" "video"))
                 (home-directory "/home/user2"))                
               ;; openvpn user not needed here
               ;; (user-account
               ;;  (name "openvpn")
               ;;  (group "openvpn")
               ;;  (system? #t)
               ;;  (comment "Openvpn daemon user")
               ;;  (home-directory "/var/empty")
               ;;  (shell (file-append shadow "/sbin/nologin")))
                (user-account
                 (name "cuirass")
                 (group "cuirass")
                 (supplementary-groups '("netdev"
                                         "audio" "video"))
                 (home-directory "/home/cuirass"))
                
               %base-user-accounts))

  ;; Globally-installed packages.
  ;; added nss-certs and le-certs globally for e.g. cuirass to be able to fetch stuff
  (packages (cons* screen openssh nss-certs le-certs %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (service gnome-desktop-service-type)
		   (service xfce-desktop-service-type)
                   (spice-vdagent-service)
                    ;; https://guix.gnu.org/manual/en/html_node/Submitting-Patches.html
                    (service qemu-binfmt-service-type
                             (qemu-binfmt-configuration
                              (platforms (lookup-qemu-platforms "arm" "aarch64"))
                              (guix-support? #t)))
                   
                    (service openssh-service-type
                             (openssh-configuration
                              (permit-root-login #t)
                              ;;(allow-empty-passwords? #t)
                              (x11-forwarding? #t)
                              (port-number 2223)))
                    ;; https://lists.gnu.org/archive/html/help-guix/2017-08/msg00095.html
                    (simple-service 'store-my-config
                                    etc-service-type
                                    `(("config.scm"
                                       ,(local-file (assoc-ref
                                                     (current-source-location)
                                                     'filename)))))
		    (service special-files-service-type %my-special-files)
                    ;; https://lists.gnu.org/archive/html/help-guix/2019-06/msg00116.html
                    (service cuirass-service-type
                             (cuirass-configuration
                              (interval 60) ;; 10 hours
                              (fallback? #f) ;; default is #f
                              (host "0.0.0.0")
                              (port 8082)
                              (database "/var/lib/cuirass/cuirass.db") ;; default is /var/lib/cuirass/cuirass.db
                              (use-substitutes? #t)
                              (specifications %cuirass-specs)))
                    %desktop-services))
  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
