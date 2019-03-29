;;;  🌶🌶🌶 Spicemacs Jalapeno 🌶🌶🌶
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
;;(use-package auto-package-update
;;  :config
;;  (setq auto-package-update-delete-old-versions t)
;;  (setq auto-package-update-hide-results t)
;;  (auto-package-update-maybe))

;; xresources-theme
;; use .xresources as the Emacs theme
(use-package xresources-theme
  )

;; general
;; a convenient method for binding keys in emacs
(use-package general
  :config
  (general-create-definer leader-def
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; simple commands
  ;;(leader-def "'" '(iterm-focus :which-key "iterm"))
  ;;(leader-def "?" '(iterm-goto-filedir-or-home :which-key "iterm - goto dir"))
  ;;(leader-def "/" 'counsel-ag)
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

;; smartparens
;; minor mode for dealing with pairs
(use-package smartparens
  :init
  (smartparens-global-strict-mode)
  )

;; rainbow-delimiters
;; highlight delimiters according to depth
(use-package rainbow-delimiters
  :hook (python-mode . rainbow-delimiters-mode)
  )

;; markdown-mode
;; major mode for editing markdown files
(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode) ;; assume github-flavored markdown for README
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
  :general
  (leader-def :keymaps 'markdown-mode-map "tl" '(markdown-insert-link :which-key "insert link")) ;; insert link
  (leader-def :keymaps 'markdown-mode-map "ti" '(markdown-insert-image :which-key "insert image")) ;; insert image
  (leader-def :keymaps 'markdown-mode-map "te" '(markdown-insert-italic :which-key "italicize")) ;; italicize
  (leader-def :keymaps 'markdown-mode-map "tp" '(markdown-live-preview-mode :which-key "live preview"))
  )

;; python-mode
(use-package python
  :mode (("\\.py\\'" . python-mode))
  :init
  (setq default-fill-column 88) ;; wrapping text at 88th character
  )

;; blacken
;; python autoformatter
(use-package blacken 
  :hook (python-mode . blacken-mode)
  :general
  (leader-def :keymaps 'python-mode-map "tb" '(blacken-buffer :which-key "blacken buffer"))
  )

;;(use-package ein
;;  :defer t)

;; fill-column-indicator
;; set indicator for the max column length
(use-package fill-column-indicator
  :general
  (leader-def "w" '(my/wrapping :which-key "wrapping"))
  )
 
;; custom command to turn on wrapping and the fill-column-indicator
(defun my/wrapping ()
  "turn on wrapping and fill-column-indicator"
  (interactive)
  (auto-fill-mode)
  (fci-mode))

;; Flycheck
;; live python linting
;;(use-package flycheck
;;  )

;; elpy
;; python ide-like functionality
;;(use-package elpy
;;  )

;; magit
;; git porcelain
;;(use-package magit
;;  )

;; ebib
;; manage bibTeX and bibLaTeX database files
(use-package ebib
  :general
  (leader-def "re" '(ebib :which-key "ebib"))
  (leader-def "ri" '(ebib-insert-citation :which-key "insert ref")) ;; still needs work
  :init
  (setq ebib-preload-bib-files '("~/Dropbox/literature/library.bib")
        ebib-bibtex-dialect 'BibTeX
        ebib-file-associations '(("pdf" . "mupdf")("ps" . "gv"))
        ebib-file-search-dirs '("~/Dropbox/literature")
        ebib-autogenerate-keys nil
        ebib-notes-directory "~/Dropbox/literature/notes"
        ebib-reading-list-file "~/Dropbox/literature/reading-list.org"
        )
  (setq ebib-citation-commands
	'((any (("cite"         "\\cite%<[%A]%>[%A]{%(%K%,)}")))
	(org-mode (("ebib"         "[[ebib:%K][%D]]")))
	(markdown-mode (("text"         "@%K%< [%A]%>")))))
  )

;; custom function to call python script for generating bibtex entry
(defun my/doi-crossref (doi)
  (interactive "MDOI: ")
  (shell-command (concat "python3 /home/xavier/.emacs.d/doi-crossref.py " doi))
  (switch-to-buffer "*Shell Command Output*")
  (search-forward "{")
  (downcase-word 1)
  (search-forward "_")
  (backward-char 1)
  (delete-char 1)
  (search-backward "{")
  (forward-char 1)
  (mark-word 1)
  (copy-region-as-kill (region-beginning) (region-end))
  (search-forward "doi")
  (end-of-line)
  (newline-and-indent)
  (insert "file = {")
  (yank)
  (insert ".pdf},")
  (search-forward "year = ")
  (insert "{")
  (forward-word 1)
  (insert "}")
  (beginning-of-buffer)
  (kill-paragraph 1)
  (kill-buffer-and-window))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (xresources-theme which-key use-package smartparens rainbow-delimiters markdown-mode magit jedi-core iedit hydra general flycheck fill-column-indicator evil elpy ein ebib counsel blacken avy auto-package-update))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
