(setq inhibit-startup-message t)
(setq visible-bell t)
(setq cursor-in-non-selected-windows t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(column-number-mode t)
(electric-pair-mode t)
(setq-default cursor-type 'bar)
(global-hl-line-mode t)
(setq backup-directory-alist '(("." . "~/.cache/.saves")))
(delete-selection-mode t)
(global-visual-line-mode t)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 5)

 (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
         ("org" . "https://orgmode.org/elpa/")
         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "18:00"))

(use-package which-key
  :config (which-key-mode))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-startup-banner "~/.config/emacs/logo/unix.png")
(setq dashboard-banner-logo-title nil)
(setq dashboard-center-content t)
(setq dashboard-items '((recents  . 4)
                        (bookmarks . 4)))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (setq-default neo-show-hidden-files t))

(use-package beacon
  :config
  (beacon-mode 1))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package ewal
  :init (setq ewal-use-built-in-always-p nil
              ewal-use-built-in-on-failure-p t
              ewal-built-in-palette "sexy-material"))

(use-package ewal-spacemacs-themes
  :init
  (progn
    (setq spacemacs-theme-underline-parens t)
    (let ((font-name "JetBrainsMonoNL Nerd Font Propo"))
      (when (member font-name (font-family-list))
        (setq my:rice:font (font-spec
                            :family font-name
                            :weight 'semi-bold
                            :size 11.0))
        (set-frame-font my:rice:font nil t)
        (add-to-list 'default-frame-alist
                     `(font . ,(font-xlfd-name my:rice:font))))))
  :config
  (progn
    (load-theme 'ewal-spacemacs-modern t)
    (enable-theme 'ewal-spacemacs-modern)))

(use-package ewal-evil-cursors
  :after (ewal-spacemacs-themes)
  :config (ewal-evil-cursors-get-colors
           :apply t :spaceline t))

(when (and (display-graphic-p)
           (string= (face-attribute 'default :family) "JetBrainsMonoNL Nerd Font Propo"))
  (set-fontset-font t 'symbol
                    (font-spec :family "JetBrainsMonoNL Nerd Font Propo") nil 'prepend)
  (setq prettify-symbols-unprettify-at-point 'right-edge)
  (global-prettify-symbols-mode +1))

(use-package treesit-auto
  :config
  (global-treesit-auto-mode)
  (setq treesit-auto-install 'prompt))

(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-auto-enabled t
        highlight-indent-guides-responsive 'top))

(use-package auto-complete
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
