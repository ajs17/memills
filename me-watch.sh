#!/bin/bash
# run in the directory to watch

# SCRIPTDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

DATADIR="$PWD/data_files"
MDDIR="$PWD/metadata_files"
CITEFILE="$PWD/.cite"

CLIP=`xclip -sel clip -o`
echo "clip contains: $CLIP"
if [[ "$CLIP" =~ \.[a-z]{2,3}$ ]]; then
  echo "Setting clipped citation: $CLIP"
  echo $CLIP > $CITEFILE
fi
CITE=`cat $CITEFILE`
echo "$CITE will now be used until changed with me-clip"

# default of space, tab and nl
unset IFS                                 

# Wait for filesystem events below the current directory                                    
inotifywait -m -r -e close_write $DATADIR |
while read DIR OP FILE; do 
  echo "detected changed file: $FILE in $DIR"
  RELDIR=${DIR/$DATADIR/}
  RELDIR=${RELDIR/\//}
  echo "RELDIR: $RELDIR"

  BASENAME=${FILE%.*}
  # echo "basename: $BASENAME"
  MDFILE=$MDDIR/$RELDIR$BASENAME.md
  # echo "MDFILE: $MDFILE"

  mkdir -p $MDDIR/$RELDIR
  if [[ -f $MDFILE ]]; then 
    echo "MDFILE exists, won't touch"
    continue
  else
    touch $MDFILE

    DATE=`echo $BASENAME | cut -c1-10`
    DATE=`date -d $DATE  +'%d %b %Y'`
    NAME=`echo $BASENAME | cut -c12-`
    NAME=${NAME//-/ }
    
    # echo "DATE is $DATE"
    # echo "NAME is $NAME"

    MDCONTENT="---\ncitation: \"$DATE, $NAME, $CITE\"\n---\n"
    echo -e $MDCONTENT > $MDFILE
    code $MDFILE
  fi
  
  printf $'{{%% mefig "%s" /%%}}' $RELDIR$BASENAME | xclip -sel clip
  git add -A .
  sleep 1

done


