#! /bin/zsh
# this is a shell script to compile all .java files in a directory 
# and puts them in a directory called out

# intitialize the current directory of the java files
CURDIR="./"


# ANSI values for coloring the output
PURPLE="\033[0;35m"
GREEN="\033[0;32m"
NOCOLOR="\033[0m"

# will contain the java comialation flags if needed otherwise will be blank
JAVAFLAGS=$1

if [ -d "src" ]; then
	CURDIR="./src"
fi

# this wiil do a compiliation given that there are no sub packages in 
# the main directory
function singlelevel_compile {
	for FILE in $(ls $CURDIR | grep .java) 
	do
		if [ $CURDIR/$FILE -nt ./out/${FILE%.java}.class ] || [ "$1" = "1" ] || [ ! -e ./out/${FILE%.java}.class ]; then
			for DEPENDANCY in $(../src/get-dependancies $CURDIR/$FILE) 
			do
				OUT="./out${DEPENDANCY#./src}"
				if [ $DEPENDANCY -nt ${OUT%.java}.class ] || [ ! -e ${OUT%.java}.class ]; then
					echo -e "${PURPLE} Compiling $DEPENDANCY ${NOCOLOR}"
					javac $JAVAFLAGS -classpath ./out $DEPENDANCY -d ./out/	
				fi
			done
			echo -e "${PURPLE} Compiling $CURDIR/$FILE ${NOCOLOR}"
			javac $JAVAFLAGS -classpath ./out $CURDIR/$FILE -d ./out/
		fi
	done
}

# this does a recursive compiliation of the of the directory given there are 
# sub packages in the directory
function multilevel_compile {
	for FILE in $(ls $CURDIR/$1 | grep .java) 
	do
		if [ $CURDIR/$1$FILE -nt ./out/$1${FILE%.java}.class ] || [ "$2"  = "1" ] || [ ! -e ./out/$1${FILE%.java}.class ]; then
			for DEPENDANCY in $(../src/get-dependancies $CURDIR/$1$FILE) 
			do
				OUT="./out${DEPENDANCY#./src}"
				if [ $DEPENDANCY -nt ${OUT%.java}.class ] || [ ! -e ${OUT%.java}.class ]; then
					echo -e "${PURPLE} Compiling $DEPENDANCY ${NOCOLOR}"
					javac $JAVAFLAGS -classpath ./out $DEPENDANCY -d ./out/	
				fi
			done
			echo -e "${PURPLE} Compiling $CURDIR/$1$FILE ${NOCOLOR}"
			javac $JAVAFLAGS -classpath ./out $CURDIR/$1$FILE -d ./out/ 
		fi
	done
	for FILE in $(ls $CURDIR/$1 | grep -v .java)
	do 
		if [ -d $CURDIR/$1$FILE ]; then 
			multilevel_compile $1$FILE/ $2
		fi
	done
}

# tells if there are sub packages in the working directory
ARE_PACKAGES="no"

# this scans all .java files and sees if they are newer then the archived
# one then it will recompile them otherwise it will do nothing
function compile {
	if [ "$ARE_PACKAGES" = "yes" ]; then
		for DIR in $(cd $CURDIR; ls -d */)
		do
			multilevel_compile $DIR $1
		done
	fi
	singlelevel_compile $1
}

if [ ! -d "$(ls $CURDIR | grep -v "out" | grep -v ".java" | grep -v ".sh")" ]; then
	ARE_PACKAGES="yes"
fi




# if the out dir does not exist then it will create one
if [ ! -d "out" ]; then
	mkdir out

	compile 1 
fi

compile 0

# print exit message
echo -e "${GREEN} Done. ${NOCOLOR}"
