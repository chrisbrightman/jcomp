/// compile-dependencies.c
/// @author: Christopher Brightman
/// this wiil parse the jcomp.conf file and compile dependancies for the 
/// given file

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "dynamic_array.h"

#define MAX_LINE_LENGTH 1024


bool is_breaker(char *str) {
	bool rtn_val = false;
	rtn_val = rtn_val || (str[0] == '[');
	rtn_val = rtn_val || (str[strlen(str) - 1] == ']');
	return rtn_val;
}

/*
dynamic_array_t *tokenize_config(FILE *fl) {
	dynamic_array_t *array = create_array();
	// tokenizing config block
	char *buff;
	while (strcmp(&buff, MAX_LINE_LENGTH, fl)) {
		if (strcmp(buff, "[working_dir]") == 0) {
			continue;
		}
		if (is_breaker(buff)) {
			break;
		}
		array_add(array, buff);
	}
	return array;
}

char **find_dependancies(char *file_to_comp) {
	FILE *jcomp_config = fopen(top_dir, "r");
	char *buff
	while (fgetline)
}

char *find_working_dir(FILE *jcomp_config) {
	dynamic_array_t *working_dir_array = tokenize_config(jcomp_config);
	char *working_dir = array_get(working_dir_array, 0); 
	return working_dir;
}
*/

int main(int argc, char const *argv[]) {
	const char *file_to_comp = argv[1];
	FILE *jcomp_config = fopen("./jcomp.conf", "r");
	//char *working_dir = find_working_dir(jcomp_config);
	char *buff;
	size_t line_length = MAX_LINE_LENGTH;
	int file_to_comp_len = strlen(file_to_comp);
	while (getline(&buff, &line_length, jcomp_config)) {
		if (strncmp(buff, file_to_comp, file_to_comp_len) == 0) {
			printf("%s\n", buff + file_to_comp_len + 1);
			break;
		}
	}
	free(buff);
	fclose(jcomp_config);
	return 0; 
}