#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>


int childFunction() {
	setsid();
	
	int rc = system("./update.sh");

	char *returnStatus;
	switch(rc){
		case 0:
			returnStatus = "All good!";			
			break;
		case 1:
			returnStatus = "Unable to complete update";
			break;
		default:
			returnStatus = "Something went wrong, how did we get here?";
	}

	FILE *pfile;
	pfile = fopen("childlog.txt", "w");
	if( pfile == NULL ) {
		exit(-1);
	}
	fprintf(pfile, returnStatus);
	fclose(pfile);

	return 0;
} //Child process


int main() {
	pid_t pid = fork();

	if(pid < 0 ){
		//Fork failed
		perror("fork");
		exit(-1);
	}
	
	if(pid == 0){
		//Child process
		printf("Starting update...");
		childFunction();
		exit(0);
	}
	else{
		//Parent process
		printf("Parent process, child PID: %d\n", pid);
		int status;
		waitpid(pid, &status, 0);
	}
	return 0;
} // Main

