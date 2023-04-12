#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/stat.h>

__attribute__((constructor))
void setup(void) {
    setbuf(stdout, NULL);
    setbuf(stdin, NULL);
}
 
void sig_handler(int signum){
	printf("Sorry, you took too long and I got impatient!");
	exit(-1);
}

int main(int argc, char *argv[]){

	printf("Hello fortune teller! Please tell me my fortune!\n");
	
	signal(SIGALRM,sig_handler); // Register signal handler
 
	alarm(3);  // Scheduled alarm after 2 seconds
	char buffer[32];

	printf("> ");
	read(0, buffer, 0x100);

	return 0;
}