
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents) ; update package archives
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package-ensure))
(setq use-package-always-ensure t)

(use-package general
  :config
  (general-create-definer leader-def
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; simple commands
  (leader-def "TAB" '(my/switch-to-previous-buffer :which-key "prev buffer"))

  ;; files
  (leader-def "f" '(:ignore t :which-key "files"))

  ;; buffer
  (leader-def "b" '(:ignore t :which-key "buffer"))
  (leader-def "bo" '(other-window :which-key "switch window"))
  (leader-def "bk" '(kill-buffer :which-key "kill buffer"))

  ;; modes
  (leader-def "w" '(auto-fill-mode :which-key "fill mode"))

  ;; reserved keys for mode-specific bindings
  ;; navigation
  (leader-def "t" '(:ignore t :which-key "editing"))

  ;; compilation
  (leader-def "c" '(:ignore t :which-key "compilation"))

  ;; error checking
  (leader-def "x" '(:ignore t :which-key "error"))
  )

(use-package which-key
  :init
  (which-key-mode)
  )

(use-package hydra
  )

(use-package evil
  :init
  (evil-mode)
  :config
  (setq evil-emacs-state-cursor '("red" box))
  (setq evil-normal-state-cursor '("green" box))
  (setq evil-visual-state-cursor '("orange" box))
  (setq evil-insert-state-cursor '("red" bar))
  (setq evil-replace-state-cursor '("red" bar))
  (setq evil-operator-state-cursor '("red" hollow))
  )

(setq delete-old-versions -1) ; delete backup versions silently
(setq version-control t) ; use version control
(setq vc-make-backup-files t) ; make backup even when in version controlled dir
(setq backup-directory-alist '(("." . "~/.emacs.d/backups"))) ; directory for backups
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq vc-follow-symlinks t) ; don't ask for confirmation when opening a symlinked file
(setq inhibit-startup-screen t) ; inhibit default startup screen
(setq ring-bell-function 'ignore) ; silent bell when you make mistakes
(setq coding-system-for-read 'utf-8) ; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil) ; sentence should end with only a point

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-face-attribute 'default nil :height 90)

(global-linum-mode t)
