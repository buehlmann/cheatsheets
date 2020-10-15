Find files recursively by content

`grep -r --include "*.md" "string-to-grep-for" .`

Verify by commit sha if it's a merge commit (more than one parent) or not

```
if [ "`git show -s --pretty=format:%p $CI_COMMIT_SHA | awk -F' ' '{print NF}'`" -gt "1" ]; then echo "It's a merge commit!"; fi
```
