;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

(use-modules (gnu) (gnu system nss))
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

;; to try new configs here, run: herd stop cuirass-web ; herd stop cuirass ; rm /var/lib/cuirass/cuirass.db* ; guix system reconfigure /home/user1/src/my-guixsd-config.sh/VM-configs/bare-bones2.scm ;  herd start cuirass ; sleep 1 ; herd restart cuirass-web

;; old: herd stop cuirass-web ; herd stop cuirass ; rm /var/lib/cuirass/cuirass.db* ; guix system reconfigure -L /home/user1/src/my-guixsd-config.sh/VM-configs desktop_vm.scm ; herd stop ovpn-client ; herd restart cuirass ; sleep 1 ; herd restart cuirass-web
(define %spec-one
  '((#:name . "my-other-pkgs")
    (#:load-path-inputs . ("guix"))
    ;;(#:package-path-inputs . ("my-guixsd-config.sh"))
    (#:package-path-inputs . ("my-guix-packages"))
    ;;(#:package-path-inputs . ())
    (#:proc-input . "guix")
    (#:proc-file . "build-aux/cuirass/gnu-system.scm")
    (#:proc . cuirass-jobs)
    (#:proc-args .
     ((subset . ("perl-ical-data" "perl-moose"))
      (systems . ("x86_64-linux"))))
    (#:inputs . (
                    ((#:name . "guix")
                     (#:url . "git://git.savannah.gnu.org/guix.git")
                     (#:load-path . ".")
                     ;;(#:branch . "master")
                     (#:commit . "697d2e037bc999760b85b7904079679e0ccc1e62")
                     (#:no-compile? . #t))
                    
                    ((#:name . "my-guix-packages")
                     (#:url . "https://github.com/methuselah-0/my-guix-packages.git")
                     (#:load-path . "packages")
                     (#:branch . "master")
                     (#:no-compile? . #t))                    
                    ))
    (#:build-outputs . ())))
(define %spec-two
)

                    ;; ((#:name . "bcu")
                    ;;  (#:url . "https://gitlab.com/methuselah-0/bash-coding-utils.sh.git")
                    ;;  (#:load-path . "guix-channel")
                    ;;  (#:branch . "master")
                    ;;  (#:no-compile? . #t))

                    ;; (((#:name . "divoplade-site")
                    ;;  (#:url . "file:///tmp/divoplade-site.git")
                    ;;  (#:load-path . ".")
                    ;;  (#:branch . "master")
                    ;;  (#:no-compile? . #t))

(define %cuirass-specs
  #~(
     ;; spec two
     list
  '((#:name . "my-pkgs")
    (#:load-path-inputs . ("guix"))
    ;;(#:package-path-inputs . ("my-guixsd-config.sh"))
    (#:package-path-inputs . ("my-guix-packages"))
    ;;(#:package-path-inputs . ())
    ;;(#:package-path-inputs . ())
    (#:proc-input . "guix")
    (#:proc-file . "build-aux/cuirass/gnu-system.scm")
    (#:proc . cuirass-jobs)
    (#:proc-args .
     (;;(subset . manifests)
      ;;(subset . ("hello" "cowsay" "perl-moose" "jupyter" "enlightenment"))
      (subset . ("hello" "cowsay" "orgmk" "fwknop"))
      (systems . ("x86_64-linux"))
      ;;(manifests . (("my-guix-packages" . "manifest.scm")))
      ))
    (#:inputs . (
                 ((#:name . "guix")
                  (#:url . "git://git.savannah.gnu.org/guix.git")
                  (#:load-path . ".")
                  ;;(#:branch . "master")
                  (#:commit . "d7e033b9a153a9e60f52ff64f4eb355c1c3d0a6e")
                  (#:no-compile? . #t))
                 ;; still needs to be a git repo
                 ;; ((#:name . "my-guix-packages")
                 ;;  (#:url . "file:///home/cuirass/my-guix-packages")
                 ;;  (#:load-path . "packages")
                 ;;  (#:branch . "master")
                 ;;  (#:no-compile? . #t))                    

                 ((#:name . "my-guix-packages")
                  (#:url . "https://github.com/methuselah-0/my-guix-packages.git")
                  (#:load-path . "packages")
                  (#:branch . "master")
                  (#:no-compile? . #t))                    

                 ))
    (#:build-outputs . ()))     
     
))

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
                              (interval 3600)
                              (fallback? #f) ;; default is #f
                              (host "0.0.0.0")
                              (port 8082)
                              (database "/var/lib/cuirass/cuirass.db") ;; default is /var/lib/cuirass/cuirass.db
                              (use-substitutes? #t)
                              (specifications %cuirass-specs)))
                    %desktop-services))
  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
