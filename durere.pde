

   
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
    println(audioName);
    audioFiles[i]= new SoundFile(this,audioName); 
  }
}

void instantiateVideo() {
   String movieName;
   for (int i=0;i<numBars;i++) {
    movieName = (i+1)+".mp4"; 
    println(movieName);
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
   if ((joints[KinectPV2.JointType_HandRight].getY() > joints[KinectPV2.JointType_Head].getY()) && (movementTriggers[0] == 0)) kinectTriggered(0);
   if (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(0);
   if ((joints[KinectPV2.JointType_HandLeft].getY() > joints[KinectPV2.JointType_Head].getY()) && (movementTriggers[1] == 0)) kinectTriggered(1);
   if (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(1);
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