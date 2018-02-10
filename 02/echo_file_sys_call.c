/* 
  About:
  Opens/creates a file and writes into it.

  Use:
  ./echo_file_sys_call <file> "text" [-a]

  Parameters:
  -a For appending at the end of the file

  By:
  Cesar Augusto Garcia Perez
*/

#include <unistd.h>         //include POSIX functions and declarations as read(), write(), close()
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>

int main(int argc, char const *argv[]){
  int fd;
  char buffer[strlen(argv[2])];         //buffer is a memory-space to allow exchange of information

  if(argc >= 4 ){
    if(strcmp ("-a",argv[3]) == 0){
      fd = syscall(SYS_open, argv[1], O_WRONLY | O_CREAT | O_APPEND , 0755);
    }
  }else{
    fd = syscall(SYS_open, argv[1], O_WRONLY | O_CREAT | O_TRUNC  , 0755);
  }

  strcat(buffer, argv[2]);
  syscall(SYS_write, fd, buffer, strlen(buffer));
  close(fd);
  exit(1);
}
