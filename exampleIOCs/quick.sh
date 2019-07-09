for D in `find . -type d`
do
    cd $D
    rm -rf .git .gitignore
    cd ..
done


