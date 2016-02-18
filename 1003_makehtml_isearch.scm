(use util.match)

(define (main args)
  (define (usage) (exit 1 (format #f "Usage: ~a infile outfile" *program-name*)))
  (match (cdr args)
    [(infile outfile) (make-outfile infile outfile)]
    [_ (usage)])
  0)

(define (make-outfile infile outfile)
  (with-input-from-file infile
    (lambda ()
      (with-output-to-file outfile
        (cut output-index-data infile)
        :if-exists :append))))

(define (output-index-data infile)
  (let ((index-scope-flag #f)
        (href-str         (or (values-ref (string-scan infile #\/ 'after*) 0)
                              infile)))
    (let loop ((line (read-line)))
      (cond
       (index-scope-flag
        (cond
         ((rxmatch #/<code>/ line)
          (print (regexp-replace-all 
                  #/<a href="/
                  line 
                  (format #f "<a target=\"frame2\" href=\"~a" href-str))))
         ((or (rxmatch #/<\/table>/ line)
              (rxmatch #/<\/ul>/    line))
          (set! line (eof-object)))))
       (else
        (when (rxmatch #/class="index-fn"/ line)
          (set! index-scope-flag #t))))
      (if (not (eof-object? line))
        (loop (read-line)))
      )))

