(global-linum-mode 1)
;; hide toolbar menubar scrollbar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
;; hightlight
(global-hl-line-mode 1)
;; show time
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq initial-frame-alist (quote ((fullscreen . maximized))))

(setq mac-option-key-is-meta t
      x-select-enable-clipboard 't
      ;; mac-command-key-is-meta nil
      mac-command-modifier 'super
      mac-option-modifier 'meta)

;; 这两段一定要在 init.el 的最上方
(require 'package)
;; 初始化包管理器
(package-initialize)

;; 设置软件源
;; 默认软件源里只有 ELPA，也就是 GNU Emacs 官方的软件源
;; 我们引入以下几个最常用的软件源：

;; MELPA：软件包比 ELPA 多（软件进入 MELPA 比 ELPA 手续更简单）、新
;; （nightly 级别的更新速度，以时间作为版本号）
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; 稳定版 MELPA （非 nightly，有版本号）
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;; org-mode 专用软件源。它几乎只服务于 org-plus-contrib 这一个包
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; 以下用来 bootstrap use-package 自己。在上文设置好软件源后，

;; 如果 use-package 没安装
(unless (package-installed-p 'use-package)
  ;; 更新本地缓存
  (package-refresh-contents)
  ;; 之后安装它。use-package 应该是你配置中唯一一个需要这样安装的包。
  (package-install 'use-package))

(require 'use-package)
;; 让 use-package 永远按需安装软件包
(setq use-package-always-ensure t)

;; 之后就可以使用它了。
;; 比如上文安装并 require better-defaults 的过程就可以简化为这一行：
(use-package better-defaults)
;; 1. 它会判断是否已安装。没有时才会更新 package 缓存并安装它
;; 2. 它会自动 (require)
;; 3. 它有很多配置项能让你控制每个环节，从而做到把和这个软件包有关的所
;; 有配置写在一个闭包里。

;; quelpa - For those packages which are not in MELPA
(use-package quelpa
  :config ; 在 (require) 之后需要执行的表达式
  (use-package quelpa-use-package) ; 把 quelpa 嵌入 use-package 的宏扩展
  (quelpa-use-package-activate-advice)) ; 启用这个 advice

(use-package helm
  ;; 等价于 (bind-key "M-x" #'helm-M-x)
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files))
  :config
  ;; 全局启用 Helm minor mode
  (helm-mode 1))

;; 好了。按个 M-x 试试

(use-package company
  ;; 等价于 (add-hook 'after-init-hook #'global-company-mode)
  :hook (after-init . global-company-mode)
  :config
  ;; setq 可以像这样连着设置多个变量的值
  (setq company-tooltip-align-annotations t ; 注释贴右侧对齐
        company-tooltip-limit 20            ; 菜单里可选项数量
        company-show-numbers t              ; 显示编号（然后可以用 M-数字 快速选定某一项）
        company-idle-delay .2               ; 延时多少秒后弹出
        company-minimum-prefix-length 1     ; 至少几个字符后开始补全
        ))

(use-package flycheck
  :init ;; 在 (require) 之前需要执行的
  (setq flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode))

;; ~/.emacs.d/init.el
(use-package projectile
  :config
  ;; 把它的缓存挪到 ~/.emacs.d/.cache/ 文件夹下，让 gitignore 好做
  (setq projectile-cache-file (expand-file-name ".cache/projectile.cache" user-emacs-directory))
  ;; 全局 enable 这个 minor mode
  (projectile-mode 1)
  ;; 定义和它有关的功能的 leader key
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map))

(use-package helm-projectile
  :if (functionp 'helm) ;; 如果使用了 helm 的话，让 projectile 的选项菜单使用 Helm 呈现
  :config
  (helm-projectile-on))

;; ~/.emacs.d/init.el
(use-package magit)

;; 没错，好了。

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")'
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))
