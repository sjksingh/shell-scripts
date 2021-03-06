#/bin/bash
critVar=$(sqlplus -s <<EOF
test/test@test
SET HEAD OFF FEED OFF
SELECT count(*) FROM user_mviews WHERE sysdate-last_refresh_date > 1;
EXIT;
EOF)
if [ $critVar -ne 0 ]; then
mail -s "Problem with MV refresh" dba@gmail.com <<EOF
MVs not okay.
EOF
else
echo "MVs okay."
fi
exit 0
