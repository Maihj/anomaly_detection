#include <stdio.h>  
#include <stdlib.h> 
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>  
#include <linux/input.h>  

void usage(char *str){  
	fprintf(stderr, "<usage> %s /dev/input/eventX /dev/input/eventX\n", str);  
	exit(1);
}

int main(int argc, char **argv){
	pid_t pid;
	FILE *fd1, *fd2;
	struct input_event event1, event2;

	if (argc != 3) usage(argv[0]);

	fd1 = fopen(argv[1], "r");
	fd2 = fopen(argv[2], "r");
	if (fd1 == NULL){
		perror(argv[1]);  
		exit(1);
	}
	if (fd2 == NULL){  
		perror(argv[2]);  
		exit(1);
	}

	pid = fork();
	if (pid < 0){
		perror("fork failed");
		exit(1);
	}

	while (1){
		if (pid == 0){
			fread((void *)&event1, sizeof(event1), 1, fd1);  
			if (ferror(fd1)){
				perror("fread");  
				exit(1);
			}
			printf("%d_%d_%d\n", event1.type, event1.code, event1.value);
		}
		else {
			fread((void *)&event2, sizeof(event2), 1, fd2);  
			if (ferror(fd2)){
				perror("fread");  
				exit(1);
			}
			printf("%d_%d_%d\n", event2.type, event2.code, event2.value);
		}   
	}

	fclose(fd1);
	fclose(fd2);
	return 0;
}
