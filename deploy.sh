
generate(){
    local source=$1
    local dist=$2
    for file in `ls $source`; do
        filesrc="$source/$file"
        filedist="$dist/$file"
        if [ -d $filesrc ]; then
            if [ ! -d $filedist ]; then
                mkdir $filedist
            fi
            generate $filesrc $filedist 
        elif [ -f $filesrc ]; then
            filedist=${filedist/%md/html}
            echo "generate file: $filesrc to $filedist"
            landslide $filesrc -i -d $filedist
        fi
        
    done

}

push(){
    local dist=$1
    local remote=$2
    cd $dist

    git init
    git checkout --orphan gh-pages
    git add .
    git commit  -m "site update  $(date '+%Y-%m-%d %H:%M:%S')"
    git remote add origin $remote
    git push -f origin gh-pages 
}
cd `dirname $0`
rm -rf dist
mkdir dist

generate ppt dist
push dist "git@github.com:xiaoyu5256/share.git"
