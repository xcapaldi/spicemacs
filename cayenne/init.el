
(require 'package)
(setq package-enable-at-startup nil) ; do not load packages before startup
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package) ; unless already installed
  (package-refresh-contents) ; update package archives
  (package-install 'use-package)) ; install most recent version of use-package
(eval-when-compile
  (require 'use-package-ensure)) ; initialize use-package and ensure packages in installed if necessary
(setq use-package-always-ensure t)

(use-package general
  :config
  (general-create-definer leader-def
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; keybinds
    )

(use-package which-key
  :init
  (which-key-mode)
  )

(use-package hydra
  )

;; extensible vi layer for emacs
(use-package evil
  :init
  (evil-mode)
  )
