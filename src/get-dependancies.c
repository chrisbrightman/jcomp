/// compile-dependencies.c
/// @author: Christopher Brightman
/// this wiil parse the jcomp.conf file and compile dependancies for the 
/// given file
/// Compile:
/// Debug:
/// gcc -ggdb ./get-dependancies.c -o get-dependancies
/// Release:
/// gcc -O ./get-dependancies.c -o get-dependancies
/// 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024

/// this opens the jcomp.conf file in the working directory 
/// and reads the file and prints to stdout the dependacies of 
/// that file as stated in the config file
int main(int argc, char const *argv[]) {
	const char *file_to_comp = argv[1];
	FILE *jcomp_config = fopen("./jcomp.conf", "r");
	char *buff = NULL;
	size_t line_length = MAX_LINE_LENGTH;
	int file_to_comp_len = strlen(file_to_comp);
	while (getline(&buff, &line_length, jcomp_config)) {
		if (strncmp(buff, file_to_comp, file_to_comp_len) == 0) {
			printf("%s\n", buff + file_to_comp_len + 1);
			free(buff);
			break;
		}
		free(buff);
		buff = NULL;
	}
	fclose(jcomp_config);
	return 0; 
}