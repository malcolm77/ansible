#/bin/bash
echo '-------------------- git pull ------------------'
git pull
echo '-------------------- git add ------------------'
git add *
echo '-------------------- git commit  ------------------'
git commit -m "automatic update"
echo '-------------------- git push ------------------'
git push
echo '-------------------- DONE ------------------'
