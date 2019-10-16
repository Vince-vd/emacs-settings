;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

;; (require 'req-package)

;; (req-package el-get ;; prepare el-get (optional)
;; 	     :force t ;; load package immediately, no dependency resolution
;; 	     :config
;; 	     (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/el-get/recipes")
;; 	     (el-get 'sync))

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    gruvbox-theme
    py-autopep8
    lsp-mode
    cquery
    traad
    virtualenvwrapper
    use-package
    company-lsp
    rtags
    cmake-ide
    fic-mode
    perspective
))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'gruvbox-dark-soft t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(global-hl-line-mode 1) ;; enable highlight line

;; Perspective enables easily tagging different projects/workspaces
;;(persp-mode 1)

;; define one single backup location
;; localize it for safety.
;; (make-variable-buffer-local 'backup-inhibited)

;; (setq bkup-backup-directory-info
;;       '((t "~/.emacs_common/backup" ok-create full-path prepend-name)))
;; (setq delete-old-versions t
;;       kept-old-versions 1
;;       kept-new-versions 3
;;       version-control t)

;; MOOS Specific config
;; ----------------------------------------
(add-to-list 'load-path "~/moos-ivp/editor-modes/")
(require 'moos-mode)


;; C++ CONFIGURATION
;; --------------------------------------

;; (req-package flycheck
;;   :config
;;   (progn
;;     (global-flycheck-mode)))
(require 'cquery)
(setq cquery-executable "/home/vincent/apps/cquery/build/release/bin/cquery")
;; (use-package cquery
;;   :ensure t
;;   :after (:any c-mode c++-mode objc-mode)
;;   :config
;;   (setq cquery-executable "~/apps/cquery/build/release/bin/cquery")
;;   (with-eval-after-load '(c-mode c++-mode objc-mode)
;;     (lsp-cquery-enable))
;;   )

(defun cquery//enable ()
  (condition-case nil
      (lsp)
    (user-error nil)))

(use-package cquery
  :commands lsp
  :init (add-hook 'c-mode-hook #'cquery//enable)
  (add-hook 'c++-mode-hook #'cquery//enable))

(setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)

(setq cquery-sem-highlight-method 'font-lock)

(cmake-ide-setup)

(add-hook 'c++-mode-hook 'turn-on-fic-mode)

;; PYTHON CONFIGURATION
;; --------------------------------------

;; First install for Python 2
;; This assumes that the environment "traad" exists and uses Python2
;;(setq traad-environment-name "traad")
;;(traad-install-server)

;; Then install for Python 3
;; This assume that the environment "traad3" exists and uses Python3
(setq traad-environment-name "traad3")
(traad-install-server)

(elpy-enable)
(setq elpy-rpc-backend "jedi")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; configure lsp-mode
;;(require 'lsp-mode)
;;(add-hook 'prog-mode-hook #'lsp)


;; init.el ends here
;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(custom-safe-themes
;;   (quote
;;    ("a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" default))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-lsp use-package traad py-autopep8 material-theme gruvbox-theme flycheck elpy ein cquery better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 98 :width normal)))))


