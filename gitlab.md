*Find open merge request by commit hash*
```
- curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > jq && chmod a+x jq
- GITLAB_API_UPSTREAM_URL="https://gitlab.foo.bar/api/v4/projects/$UPSTREAM_CI_PROJECT_ID/repository/commits/$UPSTREAM_CI_COMMIT_SHORT_SHA"
- 'PARENT_HASHES=`curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_API_UPSTREAM_URL" | ./jq -c ".parent_ids" | ./jq -c -r ".[]"`'
- if [ -z "${PARENT_HASHES}" ]; then echo "Could not fetch parent commits for git commit $GITLAB_API_UPSTREAM_URL. Maybe the user does not have the right access privileges?" && exit 1; fi
- |
    for PARENT_HASH in $PARENT_HASHES; do 
      mr=`curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.foo.bar/api/v4/projects/$UPSTREAM_CI_PROJECT_ID/repository/commits/$PARENT_HASH/merge_requests" | ./jq -c '.[] | select(.merge_commit_sha != null) | select(.merge_commit_sha | contains('\""$UPSTREAM_CI_COMMIT_SHORT_SHA"\"')) | '.iid''`
      if [ -n "$mr" ]; then 
        break
      fi
    done
- if [ -z "$mr" ]; then echo "No Merge Request found for commit $GITLAB_API_UPSTREAM_URL"; fi
- echo "Resolved merge request number $mr for commit hash $PARENT_HASH"
```
