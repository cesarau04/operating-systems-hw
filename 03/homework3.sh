#!/bin/bash

#About:
#	This script is meant to do the following:
#	a) First, you need to put the script in ./linux folder (git clone https://github.com/torvalds/linux.git)
#	b) Make a 'tree' of the folder and its number of files.
#	c) Look for certain files inside the linus kernel and print its repetitions.
#	d) Find the ocurrencies of "#include <linux/module.h>" through the ./linux folder
#	e) Copy all .c and .h files to new folders C_FILES & H_FILES
#	f) Prove that those copied files are the same that the ones of 'c)'
#Usage:
#	./number_of_files.sh 		(must be in ./linux folder)
#Info:
#	Author: Cesar Augusto Garcia Perez
#	Year:2018
#	Version: 1.0
#
#TODO:
#	Try to make the tree [a)] more human friendly

#Make sure they aren't any files before the test.
rm -rf ./H_FILES > /dev/null 
rm -rf ./C_FILES > /dev/null

printf "b) DIRECTORY TREE \n"
for i in $(find . -maxdepth 1  -type d | cut -c 3-) ; do 
    echo -n $i": " ; (find $i -type f | wc -l) ;
done


printf "\nc) README, KCONFIG, KBUILD, MAKEFILE, C, H & PL:\n"
n_readme=$(ls -pR | grep -v / | egrep -ci 'readme')
n_kconfig=$(ls -pR | grep -v / | egrep -ci 'kconfig')
n_kbuild=$(ls -pR | grep -v / | egrep -ci 'kbuild')
n_makefile=$(ls -pR | grep -v / | egrep -ci 'makefile')
n_makefiles=$(ls -pR | grep -v / | egrep -ci 'makefiles')
n_c_files=$(ls -pR | grep -v / | egrep -ci '\.c$')
n_h_files=$(ls -pR | grep -v / | egrep -ci '\.h$')
n_pl_files=$(ls -pR | grep -v / | egrep -ci '\.pl$')
n_all=$(ls -pR | grep -cv /)
#Remove the link to the parent folder
n_all=`expr $n_all - 1` 
n_all_files=$(find . -type f | wc -l)
n_all_above=`expr $n_readme + $n_kconfig + $n_kbuild + $n_makefile + $n_makefiles + $n_c_files + $n_h_files + $n_pl_files`
n_others=`expr $n_all_files - $n_all_above`

echo "Number of README:    $n_readme"
echo "Number of KCONFIG:   $n_kconfig"
echo "Number of KBUILD:    $n_kbuild"
echo "Number of MAKEFILE:  $n_makefile"
echo "Number of MAKEFILES: $n_makefiles"
echo "Number of C FILES:   $n_c_files"
echo "Number of H FILES:   $n_h_files"
echo "Number of PL FILES:  $n_pl_files"
echo "Number of other files: $n_others"
echo "Total number of files: $n_all_files"
echo "Total number of items: $n_all"
echo "----I added both 'makefile' & 'makefiles' because I thought you made a typo in the instruccions----"


printf "\nd) <linux/module.h>\n"
module_h_usages=$(grep -rw . -e '#include <linux/module.h>' | wc -l)
module_h_usages=`expr $module_h_usages - 1`
echo "Number of times the '#include <linux/module.h> appears =  $module_h_usages"


printf "\ne) COPY OF C & H FILES\n"
mkdir C_FILES
mkdir H_FILES

#Copy all the .c files into the C_FILES folder with parent structure
echo "Copying .c files into C_FILES ..."
for i in $(find . -print -type f | grep -i '\.c$'); do
	cp --parents $i ./C_FILES
done
echo "Done!"

echo "Copying .h files into H_FILES ..."
#Copy all the .h files into the H_FILES folder with parent structure
for i in $(find . -print -type f | grep -i '\.h$'); do
	cp --parents $i ./H_FILES
done
echo "Done!"


printf "\nf) .C AND .H IN C_FILES, H_FILES\n"
n_c_files_folder=$(ls ./C_FILES -pR | grep -v / | egrep -ci '\.c$')
n_h_files_folder=$(ls ./H_FILES -pR | grep -v / | egrep -ci '\.h$')
echo "Number of C files in C_FILES: $n_c_files_folder"
echo "Number of H files in H_FILES: $n_h_files_folder"
echo " "

read -p "Do you want to erase C_FILES & H_FILES folders? [y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -rf C_FILES H_FILES
	printf "\nSuccesfully removed\nFinished\n"
else
	printf "\nNo changes to folders\nFinished!\n"
fi

exit
