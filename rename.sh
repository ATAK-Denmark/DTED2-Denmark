# for filename in repo/*/*; do 
#     echo $filename
#     [ -f "$filename" ] || continue
#     mv "$filename" "${filename//dk_/}"
# done


for f in repo/*/*; do mv "$f" "$f.tmp"; mv "$f.tmp" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done
