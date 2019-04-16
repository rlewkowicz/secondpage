for i in `\ls | grep second`; do rm -rf $i;  git clone https://github.com/rlewkowicz/$i.git; done
