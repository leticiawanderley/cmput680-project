#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

//value should be for size of one request == 4*number of features in request (4 bc of 4bytes/word)
#define MAXBUF 324

int main(){

  //hardcode fifo names, these don't need to be flexible
  const char      *fifoname = "/tmp/predictor";
  const char      *fifonameres = "/tmp/predictor-results";
  int fifofd, fiforesfd;
  ssize_t didwrite, didread;
  char buf[MAXBUF];
  memset(buf, 0, MAXBUF);
  buf[1] = "1";
  char response[MAXBUF];

  //this fifo is for our requests
  fifofd = open(fifoname, O_WRONLY);
  if(fifofd < 0){
    perror("Cannot open first fifo");
  }else{
    printf("Opened first fifo\n");
    
  }

  
  //this fifo is for predictor responses
  fiforesfd = open(fifonameres, O_RDONLY);
  if(fiforesfd < 0){
    perror("Cannot open second fifo");
  }else{
    printf("Opened second fifo\n");
    didwrite = write(fifofd, buf, MAXBUF);
    if(didwrite < 0){
      perror("Cannot write");
    }else{
      printf("Wrote to predictor, number of bytes:%u\n", didwrite);
     
    }
  }

  //setup listening for predictor response
  didread = read(fiforesfd, response, MAXBUF);
  if(didread < 0){
    perror("Cannot read predictor response");
  }else{
    printf("Read from predictor:\n %s", response);
  }
  
  sleep(10);
  close(fifofd);
  close(fiforesfd);

}
