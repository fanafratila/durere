

   
 import processing.sound.*;
 import processing.video.*;
 import KinectPV2.*;
 import KinectPV2.KJoint;
 

 int numBars = 7;
 int[] barTimeouts;
 int[] movementTriggers;
 int trackingSkeleton = 0;
 int timerFrames = 170;
 int fadeInFrames = 20;
 int fadeOutFrames = 30;
 int barWidth = 274;
 String[] noteStrings = {"Ab", "Bb", "C", "Db", "Eb","F","G"};
 KinectPV2 kinect;
 SoundFile[] audioFiles = new SoundFile[numBars];
 Movie[] barMovies = new Movie[numBars];


void setup() {   

 size(1920,1080);
 kinect = new KinectPV2(this);
 kinect.enableSkeleton3DMap(true);
 kinect.init();
 
 barTimeouts = new int[numBars];
 for (int i=0;i<barTimeouts.length;i++) {
   barTimeouts[i]=0; 
 }
 
 movementTriggers = new int[numBars];
 for (int i=0;i<barTimeouts.length;i++) {
   movementTriggers[i]=0; 
 }
 
 instantiateAudio();
 instantiateVideo();

} 

void instantiateAudio() {
  String audioName;
  for (int i=0;i<numBars;i++) {
    audioName = noteStrings[i]+"_H_no_01.mp3"; 
    audioFiles[i]= new SoundFile(this,audioName); 
  }
}

void instantiateVideo() {
   String movieName;
   for (int i=0;i<numBars;i++) {
    movieName = (i+1)+".mp4"; 
    barMovies[i]= new Movie(this,movieName);
    barMovies[i].loop();
    barMovies[i].play();
  }
}

void draw() {  
   captureKinect();
   background(0);
   for (int i=0;i<numBars;i++) {
     barTimeouts[i] = drawBox(barTimeouts[i],i);
   }
} 

void captureKinect() {
   ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d(); 
   for (int i=0;i<skeletonArray.size();i++) {
     KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
     if ((i==trackingSkeleton) && skeleton.isTracked()) {
       KJoint[] joints = skeleton.getJoints();
       movementConditions(joints);
     }
   }
}

void movementConditions(KJoint[] joints) {
  //right hand above head 
   if ((joints[KinectPV2.JointType_HandRight].getY() > (joints[KinectPV2.JointType_Head].getY()+0.3)) && (movementTriggers[0] == 0)) kinectTriggered(0);
   if (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(0);
   //left hand above head 
   if ((joints[KinectPV2.JointType_HandLeft].getY() > (joints[KinectPV2.JointType_Head].getY()+0.3)) && (movementTriggers[1] == 0)) kinectTriggered(1);
   if (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(1);
   //left curl 
   if (( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ()) < 0.13) && (movementTriggers[2] == 0)) kinectTriggered(2);
    if ( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ()) > 0.29) kinectReset(2);
    //right curl
   if (( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ()) < 0.13) && (movementTriggers[3] == 0)) kinectTriggered(3);
   if ( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ()) > 0.29) kinectReset(3);  
    //left arm extension
    if ((Math.abs(joints[KinectPV2.JointType_HandLeft].getY() - joints[KinectPV2.JointType_ShoulderLeft].getY()) < 0.2) && (Math.abs(joints[KinectPV2.JointType_HandLeft].getX()- joints[KinectPV2.JointType_ShoulderLeft].getX()) > 0.3) && (movementTriggers[4] == 0)) kinectTriggered(4);
    if ((joints[KinectPV2.JointType_ShoulderLeft].getY() - joints[KinectPV2.JointType_HandLeft].getY()) > 0.4) kinectReset(4);
    //right arm extension
    if ((Math.abs(joints[KinectPV2.JointType_HandRight].getY() - joints[KinectPV2.JointType_ShoulderRight].getY()) < 0.2) && (Math.abs(joints[KinectPV2.JointType_HandRight].getX()- joints[KinectPV2.JointType_ShoulderRight].getX()) > 0.3) && (movementTriggers[5] == 0)) kinectTriggered(5);
    if ((joints[KinectPV2.JointType_ShoulderRight].getY() - joints[KinectPV2.JointType_HandRight].getY()) > 0.4) kinectReset(5);
     
}

double computeDistance(float x1,float y1,float z1,float x2,float y2,float z2) {
  double d = Math.sqrt(Math.pow((x2-x1),2)+Math.pow((y2-y1),2)+Math.pow((z2-z1),2));
  return d;
}

void kinectReset(int t) {
    movementTriggers[t] = 0; 
}

void kinectTriggered(int t) {
  resetTimeout(t);
  audioFiles[t].play();
  movementTriggers[t]=2; 
}

void keyPressed() {
 if (key == '1') {
    resetTimeout(0);
    audioFiles[0].play();
  } else if (key == '2') {
    resetTimeout(1);
    audioFiles[1].play();
  } else if (key == '3') {
    resetTimeout(2);
    audioFiles[2].play();
  } else if (key == '4') {
    resetTimeout(3);
    audioFiles[3].play();
  } else if (key == '5') {
    resetTimeout(4);
     audioFiles[4].play();
  } else if (key == '6') {
    resetTimeout(5);
    audioFiles[5].play();
  } else if (key == '7') {
     resetTimeout(6);
     audioFiles[6].play();
  }
}

void resetTimeout(int i) {
   barTimeouts[i]=1; 
}

void movieEvent(Movie m) {
   m.read(); 
}

int drawBox(int t, int pos) {
  if ((t > 0) && (t < timerFrames)) {
     float a = 256;
     if (t < fadeInFrames) a = float(t) / float(fadeInFrames) * 256.0;
     if (t > (timerFrames - fadeOutFrames)) a = float(fadeOutFrames - (t + (fadeOutFrames-timerFrames))) / float(fadeOutFrames) * 256.0;
     tint(255,a);
     image(barMovies[pos],barWidth*pos,0);
     t++; 
     if (t == timerFrames) t = 0;
   }
   
   return t;
}