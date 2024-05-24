echo "----- adding new/updating files -----"
git add *
echo "----- adding commit message -----"
git commit -m "$1"
echo "----- updating remote -----"
git push origin
echo "----- done -----"
