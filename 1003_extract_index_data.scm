(use util.match)

(define (main args)
  (match args
    [(_ infile outfile) (make-output-file infile outfile)]
    [_ (usage)])
  0)

(define (usage)
  (display
   "Usage: gosh 1003_extract_index_data.scm infile outfile\n"
   (current-error-port))
  (exit 1))

(define (make-output-file infile outfile)
  (with-input-from-file infile
    (lambda ()
      (with-output-to-file outfile
        (lambda ()
          (extract-index-data infile))
        :if-exists :append))))

(define (extract-index-data infile)
  (let ((index-scope-flag #f)
        (href-str (or (values-ref (string-scan-right infile #\/ 'after*) 0)
                      infile)))
    (do ((line (read-line) (read-line)))
        ((eof-object? line) #f)
      (cond
       ((not index-scope-flag)
        (if (rxmatch #/class="index-/ line)
          (set! index-scope-flag #t)))
       ((rxmatch #/<code>/ line)
        (print (regexp-replace-all*
                line
                #/<a href="/
                (format "<a target=\"frame2\" href=\"~a" href-str)
                #/<tr><td><\/td>/
                "<tr>"
                #/<td>&nbsp;<\/td>/
                "")))
       ((or (rxmatch #/<\/table>/ line)
            (rxmatch #/<\/ul>/    line))
        (set! index-scope-flag #f))
       ))
    ))

