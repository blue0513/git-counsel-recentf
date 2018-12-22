;;; git-counsel-recentf --- list files most recently opened in the current Git project via ivy interface

;; Copyright (C) 2018 Taiju Aoki

;; Author: Taiju Aoki <aokitaiju0513@gmail.com>
;; Version: 0.1
;; URL: https://github.com/blue0513/git-counsel-recentf

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Add the following to your Emacs init file:
;;
;; (require 'git-counsel-recentf)
;;
;; Call the method bellow.
;; Then list files most recently opened in the current Git project.
;;
;; M-x git-counsel-recentf

;;; Code:

(require 'recentf)

(defun git-root-dir-path ()
  "Get git root dir."
  (let* ((path buffer-file-name)
	 (root (file-truename (vc-git-root path))))
    (message root)))

(defun check-git-project ()
  "Check if it is git project."
  (vc-registered (buffer-file-name)))

(defun check-path-match (dir filepath)
  "Check if DIR partially match FILEPATH."
  (string-match dir filepath))

(defun git-counsel-recentf ()
  "Find a file on filterd `recentf-list'."
  (interactive)
  (if (not (check-git-project))
      (message "Not a Git Repository")
    (let* ((original-recentf-list recentf-list)
	   (git-root-dir (git-root-dir-path))
	   (filtered-list (--filter (check-path-match git-root-dir it) original-recentf-list)))
      (ivy-read "Git Recentf: " (mapcar #'substring-no-properties filtered-list)
		:action (lambda (f)
			  (with-ivy-window
			    (find-file f)))
		:caller 'counsel-recentf))))

;;; git-counsel-recentf.el ends here
