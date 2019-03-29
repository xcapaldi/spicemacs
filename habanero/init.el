;;;  🌶🌶🌶 Spicemacs Habanero 🌶🌶🌶
;;; Author: Xavier Capaldi
;;; License: MIT

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

;; remove toolbar, menu and scroll bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; set font size
(set-face-attribute 'default nil :height 90)

;; enable line numbers globally
(global-linum-mode t)

;; package
(require 'package)
(setq package-enable-at-startup nil) ; do not load packages before startup
;; where to look for new packages
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; bootstrap use-package to automate the rest of our packages
(unless (package-installed-p 'use-package) ; unless already installed
  (package-refresh-contents) ; update package archives
  (package-install 'use-package)) ; install most recent version of use-package
(eval-when-compile
  (require 'use-package-ensure)) ; initialize use-package and ensure packages in installed if necessary
(setq use-package-always-ensure t)

;; auto-package-update
;; automatically keep packaged updated
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; general
;; a convenient method for binding keys in emacs
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

  ;; references/bib management
  (leader-def "r" '(:ignore t :which-key "ref"))
  (leader-def "rd" '(my/doi-crossref :which-key "doi to ref"))

  ;; reserved keys for mode-specific bindings
  ;; navigation
  (leader-def "t" '(:ignore t :which-key "editing"))

  ;; compilation
  (leader-def "c" '(:ignore t :which-key "compilation"))

  ;; error checking
  (leader-def "x" '(:ignore t :which-key "error"))
  )

;; custom command to switch between two most recently opened buffers
(defun my/switch-to-previous-buffer ()
  "Switch to previously open buffer. Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; which-key
;; display available keybinding in a popup
(use-package which-key
  :init
  (which-key-mode)
  )

;; hydra
;; tie related commands in a repeatable family
(use-package hydra
  :config
  (defhydra hydra-vi ()
    "question"
    ("t" forward-char)
    ("r" backward-char))
  :general
  (leader-def "h" '(hydra-vi/forward-char :which-key "hydra"))
  )

;; evil
;; extensible vi layer for emacs
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

;; quality of life packages

;; avy
;; jump to visible text using char-based decision tree
(use-package avy
  :general
  (leader-def "SPC" '(avy-goto-word-or-subword-1 :which-key "go to char"))
  (leader-def "g" '(avy-goto-line :which-key "go to line"))
  )

;; abo-abo completion framework/ecosystem

;; ivy
;; generic completion mechanism
(use-package ivy
  :general
  (leader-def "bs" '(ivy-switch-buffer :which-key "switch buffer"))
  )

;; counsel
;; provides versions of common emacs commands to make best of ivy
(use-package counsel
  :general
  ("M-x" 'counsel-M-x) ;; replace default M-x with ivy backend
  (leader-def "ff" '(counsel-find-file :which-key "find file"))
  (leader-def "fr" '(counsel-recentf :which-key "recent file"))
  )

;; swiper
;; alternative to isearch that uses ivy to show overview of matches
(use-package swiper
  :general
  ("C-s" 'swiper) ;; search for string in current buffer
  (leader-def "s" '(swiper :which-key "search")) ;; search for string in current buffer
  )

;; iedit
;; edit multiple occurences in text with visual feedback
(use-package iedit
  :general
  (leader-def "e" '(iedit-mode :which-key "iedit"))
  )
