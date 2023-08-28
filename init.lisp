(in-package :stumpwm)

;; -- Environment setup --

(setq monitor-brightness 1)

;; Run picom as the compositor to fix shadows and screen tearing.
(sb-ext:run-program "picom" '("-b" "--vsync" "--backend" "glx" "--no-fading-openclose" "-D" "3" "-i" "1.0" "--experimental-backends") :search t :wait nil)  

;; Change the prefix key to Super-d.
(set-prefix-key (kbd "s-d"))

;; Mouse click should focus the window.
(setf *mouse-focus-policy* :click)

;; Show messages in the center.
(setq *message-window-gravity* :center)

;; Set message bar colors.
(set-bg-color "#0F111A")
(set-fg-color "#8F93A2")
(set-border-color "#1A1C25")

;;(set-bg-window-color "#0F111A")
(set-focus-color "#8F93A2")
(set-unfocus-color "#0F111A")

;; -- Key Bindings --
;;(which-key-mode) ;; Uncomment this if you want the help menu to show up every time you press the prefix key.

;; Ensure that xmodmap is running.
(run-shell-command "xmodmap ~/.Xmodmap")

;; Set some super key bindings
(define-key *top-map* (kbd "s-h") "move-focus left")
(define-key *top-map* (kbd "s-l") "move-focus right")
(define-key *top-map* (kbd "s-j") "move-focus down")
(define-key *top-map* (kbd "s-k") "move-focus up")

(define-key *top-map* (kbd "s-C-h") "move-window left")
(define-key *top-map* (kbd "s-C-l") "move-window right")
(define-key *top-map* (kbd "s-C-j") "move-window down")
(define-key *top-map* (kbd "s-C-k") "move-window up")

(define-key *top-map* (kbd "s-f") "fullscreen")
(define-key *top-map* (kbd "s-r") "iresize")
(define-key *top-map* (kbd "s-q") "delete")
(define-key *top-map* (kbd "C-s-l") "run-shell-command slock")

(define-key *top-map* (kbd "s-TAB") "next-in-frame")
(define-key *top-map* (kbd "s-S-TAB") "prev-in-frame")

;; Use ALT-Space for opening ULauncher.
(define-key *top-map* (kbd "M-SPC") "run-shell-command ulauncher")

;; -- Additional Functionality --

;; End Session.
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/end-session")
(load-module "end-session")
(setf end-session:*end-session-command* "loginctl")

(undefine-key *root-map* (kbd "q"))
(define-key *root-map* (kbd "q") "end-session")

;; Notifications
;;(stumpwm:add-to-load-path "~/.stumpwm.d/modules/notify")
;;(load-module "notify")
;;(notify:notify-server-toggle)

;; Backlight Controls.
;;(defun display-brightness-up ()
  ;;(unless (eq monitor-brightness 1)
    ;;(setq monitor-brightness 0.1)
    ;;(concatenate 'string "run-shell-command xrandr --output \"eDP\" --brightness " monitor-brightness)

;;(define-key *top-map* (kbd "XF86MonBrightnessUp") "backlight-up")
;;(define-key *top-map* (kbd "XF86MonBrightnessDown") "backlight-down")

;; Volume Controls via Pulseaudio
(define-key *top-map* (kbd "XF86AudioLowerVolume") "run-shell-command pactl set-sink-volume @DEFAULT_SINK@ -5%")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "run-shell-command pactl set-sink-volume @DEFAULT_SINK@ +5%")
(define-key *top-map* (kbd "XF86AudioMute") "run-shell-command pactl set-sink-mute @DEFAULT_SINK@ toggle")

;;; -- Visual Enhancements --

;; Get gapped
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/swm-gaps")
(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 3)
(run-commands "toggle-gaps-on")

;; Enable TTF fonts
;; (load-module "ttf-fonts")
;; (setf xft:*font-dirs* '("/home/daviwil/.guix-home/profile/share/fonts/"))
;; (setf clx-truetype:+font-cache-filename+ "/home/daviwil/.local/share/fonts/font-cache.sexp")
;; (xft:cache-fonts)

;; (set-font (make-instance 'xft:font :family "JetBrains Mono" :subfamily "Regular" :size 16))

;;; -- Mode line --

;; Set mode line colors
(setf *mode-line-background-color* "#0F111A")
(setf *mode-line-foreground-color* "#8F93A2")

;; Start the mode line.
(run-commands "mode-line")

;; System Tray
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/stumptray")
(load-module "stumptray")
(stumptray::stumptray)

(stumpwm:add-to-load-path "~/.stumpwm.d/modules/battery-portable")
(load-module "battery-portable") ;; %B

(stumpwm:add-to-load-path "~/.stumpwm.d/modules/wifi")
(load-module "wifi") ;; %I 

(stumpwm:add-to-load-path "~/.stumpwm.d/modules/mem")
(load-module "mem") ;; %N

(stumpwm:add-to-load-path "~/.stumpwm.d/modules/cpu")
(load-module "cpu") ;; %c %t

(setf stumpwm:*screen-mode-line-format*
      (list "%n | %d | %I | %B"))

;; -- Start initial applications --

;;(run-shell-command "emacs")
(run-shell-command "feh --bg-scale ~/Pictures/SpaceBackground2.jpg")

;; Start the REPL
(ql:quickload :swank)
(swank:create-server)
