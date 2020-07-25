git pull origin $2
git status
# check large files
max_size=1024
files=`git ls-files --other --modified --exclude-standard`
for f in $files
do
  size=`du -k $f | awk '{print $1}'`
  if [ "$size" -gt "$max_size" ]; then
     echo "\n\n------------------------------------------------------"
     echo "\033[31m Warning: The size of file [$f] is ${size}k, too large. Please ignore it, or you need to add and commit it manually."
     exit -1;
  fi
done
git add .
git commit -m "$(Rscript -e 'fortunes::fortune()')"
git push origin $2
