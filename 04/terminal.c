#include <stdio.h> 
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

//Terminal
#define TERMINAL_NAME "myterminal> "
#define MAX_LINE 120
#define RUNNING 1
#define CLOSE 0
//STD's
#define KEYBOARD 0
#define CONSOLE 1

//Stack
//#define MAX_SIZE 101
//int A[MAX_SIZE];  
//int top = -1;


typedef int Process;
typedef char* String;

String* split(String str, char separator);

int main(void){
	char args[MAX_LINE];
	const char terminal_text[] = TERMINAL_NAME;
	String* splitted;

	while(RUNNING){
		write(CONSOLE, terminal_text, sizeof(terminal_text));
		read(KEYBOARD, args, MAX_LINE);
		if(strcmp(args, "exit\n") == 0)break;
 	   Process pid = fork();
		if(pid<0){
			printf("Error %d: Unable to fork\n", errno);
			return 1;
		} else if(pid == 0){
  			splitted = split(args, ' ');
  			printf("%d\n", execvp(splitted[0], splitted));
  			free(splitted);
		}else{
  			wait(NULL);
		}
		memset(args, 0, sizeof(args));
		memset(splitted, 0, sizeof(splitted));
 	}
 	return 0;
}

String* split(String str, char separator){
	int spaces = 0;
	for(int i = 0; i < strlen(str); i++){
		if(str[i] == separator){
			spaces++;
		}
	}
	
	int index = 0;
	String* array = (String*) calloc(spaces + 2 , sizeof(String));
	for(int i = 0; i < spaces + 2; i++){
		array[i] = (String) calloc(32, sizeof(char));
	}
	String word = (String) calloc(32, sizeof(char));
	for(int i = 0; i < strlen(str); i++){
		if(str[i] == '\n'){
			break;
		}
		if(str[i] == separator){
			strcpy(array[index++], word);
			free(word);
			word = (String) calloc(32, sizeof(char));
		}else{
			String c = malloc(sizeof(char));
			*c = str[i];
			strcat(word,c);
			free(c);
		}
	}
	strcpy(array[index++], word);
	array[index] = NULL;
	free(word);
	return array;
}

