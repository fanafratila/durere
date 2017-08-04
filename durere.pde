

   
 import processing.sound.*;
 import processing.video.*;
 import KinectPV2.*;
 import KinectPV2.KJoint;
 
 double noisePercentage = 20;
 int numBars = 7;
 int[] barTimeouts;
 int[] trackingSkeletons = {0,1,2};
 int[][] movementTriggers = new  int[trackingSkeletons.length][numBars+2]; 
 int timerFrames = 170;
 int fadeInFrames = 20;
 int fadeOutFrames = 30;
 int barWidth = 274;
 String[] noteStrings = {"Ab", "Bb", "C", "Db", "Eb","F","G"};
 String[] octaveStrings = {"H","M","L"};
 int whichOctave = 0;
 KinectPV2 kinect;
 FaceData [] faceData;
 SoundFile[][] pianoFiles = new SoundFile[octaveStrings.length][noteStrings.length];
 SoundFile[] noiseFiles = new SoundFile[numBars];
 Movie[] barMovies = new Movie[numBars];


void setup() {   

 size(1920,1080);
 kinect = new KinectPV2(this);
 kinect.enableSkeleton3DMap(true);
 kinect.enableFaceDetection(true);
 kinect.init();
 
 barTimeouts = new int[numBars];
 for (int i=0;i<barTimeouts.length;i++) {
   barTimeouts[i]=0; 
 }
 
 for (int j=0;j<trackingSkeletons.length;j++) {
   for (int k=0;k<barTimeouts.length;k++) {
     movementTriggers[j][k]=0; 
   }
  } 

 instantiateAudio();
 instantiateVideo();

} 

void instantiateAudio() {
  String pianoName,noiseName;
  for (int j=0;j<octaveStrings.length;j++) {
    for (int i=0;i<noteStrings.length;i++) {
      pianoName = noteStrings[i]+"_"+octaveStrings[j]+"_no_01.mp3"; 
      noiseName = "noise-"+(i+1)+".mp3";
      pianoFiles[j][i] = new SoundFile(this,pianoName);
      noiseFiles[i] = new SoundFile(this,noiseName);
    }
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
   kinect.generateFaceData();
   ArrayList<FaceData> faceData =  kinect.getFaceData();
   ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d(); 
   for (int i=0;i<skeletonArray.size();i++) {
     KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
     for (int j=0;j<trackingSkeletons.length;j++) {
       if ((trackingSkeletons[j]==i) && skeleton.isTracked()) {
         KJoint[] joints = skeleton.getJoints();
         movementConditions(joints,j);
       }
     }
     
   }
}

void movementConditions(KJoint[] joints,int whichSkeleton) {
    //left arm extension
    if ((Math.abs(joints[KinectPV2.JointType_HandLeft].getY() - joints[KinectPV2.JointType_ShoulderLeft].getY()) < 0.2) && (Math.abs(joints[KinectPV2.JointType_HandLeft].getX()- joints[KinectPV2.JointType_ShoulderLeft].getX()) > 0.3) && (movementTriggers[whichSkeleton][4] == 0)) kinectTriggered(4,whichSkeleton);
    if ((joints[KinectPV2.JointType_ShoulderLeft].getY() - joints[KinectPV2.JointType_HandLeft].getY()) > 0.4) kinectReset(4,whichSkeleton);
    //right arm extension
    if ((Math.abs(joints[KinectPV2.JointType_HandRight].getY() - joints[KinectPV2.JointType_ShoulderRight].getY()) < 0.2) && (Math.abs(joints[KinectPV2.JointType_HandRight].getX()- joints[KinectPV2.JointType_ShoulderRight].getX()) > 0.3) && (movementTriggers[whichSkeleton][5] == 0)) kinectTriggered(5,whichSkeleton);
    if ((joints[KinectPV2.JointType_ShoulderRight].getY() - joints[KinectPV2.JointType_HandRight].getY()) > 0.4) kinectReset(5,whichSkeleton);
  //right hand above head 
   if ((joints[KinectPV2.JointType_HandRight].getY() > (joints[KinectPV2.JointType_Head].getY()+0.3)) && (movementTriggers[whichSkeleton][0] == 0)) kinectTriggered(0,whichSkeleton);
   if (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(0,whichSkeleton);
   //left hand above head 
   if ((joints[KinectPV2.JointType_HandLeft].getY() > (joints[KinectPV2.JointType_Head].getY()+0.3)) && (movementTriggers[whichSkeleton][1] == 0)) kinectTriggered(1,whichSkeleton);
   if (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(1,whichSkeleton);
   //left curl 
  if (( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ()) < 0.13) && (movementTriggers[whichSkeleton][2] == 0)) kinectTriggered(2,whichSkeleton);
    if ( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ()) > 0.29) kinectReset(2,whichSkeleton);
    //right curl
   if (( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ()) < 0.13) && (movementTriggers[whichSkeleton][3] == 0)) kinectTriggered(3,whichSkeleton);
   if ( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ()) > 0.29) kinectReset(3,whichSkeleton);  
  
    //hands on head
    if (( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY(), joints[KinectPV2.JointType_Head].getZ()) < 0.2) &&
     ( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY(), joints[KinectPV2.JointType_Head].getZ()) < 0.2) && (movementTriggers[whichSkeleton][6] == 0)) kinectTriggered(6,whichSkeleton);
    if (( computeDistance(joints[KinectPV2.JointType_HandLeft].getX(),joints[KinectPV2.JointType_HandLeft].getY(),joints[KinectPV2.JointType_HandLeft].getZ(),
     joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY(), joints[KinectPV2.JointType_Head].getZ()) > 0.4) &&
     ( computeDistance(joints[KinectPV2.JointType_HandRight].getX(),joints[KinectPV2.JointType_HandRight].getY(),joints[KinectPV2.JointType_HandRight].getZ(),
     joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY(), joints[KinectPV2.JointType_Head].getZ()) > 0.4)) kinectReset(6,whichSkeleton);
     //back bridge
     if ((joints[KinectPV2.JointType_Head].getY() < (joints[KinectPV2.JointType_SpineBase].getY()+0.2)) && 
        (joints[KinectPV2.JointType_FootLeft].getY() < joints[KinectPV2.JointType_SpineBase].getY()) &&
        (joints[KinectPV2.JointType_Neck].getY() > joints[KinectPV2.JointType_Head].getY()) &&
        (movementTriggers[whichSkeleton][7] == 0)) kinectTriggered(7,whichSkeleton);
     if ((joints[KinectPV2.JointType_Head].getY() > (joints[KinectPV2.JointType_SpineBase].getY()+0.1)) &&
       ((joints[KinectPV2.JointType_FootLeft].getY()+0.1) < joints[KinectPV2.JointType_SpineBase].getY())) kinectReset(7,whichSkeleton); 
     
     
}

double computeDistance(float x1,float y1,float z1,float x2,float y2,float z2) {
  double d = Math.sqrt(Math.pow((x2-x1),2)+Math.pow((y2-y1),2)+Math.pow((z2-z1),2));
  return d;
}


void kinectReset(int t,int whichSkeleton) {
    movementTriggers[whichSkeleton][t] = 0; 
}

void kinectTriggered(int t,int whichSkeleton) {
  if (t<numBars) { //trigger sounds and bars
    resetTimeout(t);
    playAudio(t); 
    movementTriggers[whichSkeleton][t]=2; 
  } else if (t==7) { //octave shift
    println("bridge");
    octaveShift();
    movementTriggers[whichSkeleton][t]=2; 
  }
  
}

void octaveShift() {
  whichOctave++;
  if (whichOctave > 2) whichOctave = 0;
}

void playAudio(int num) {
  pianoFiles[whichOctave][num].play();
  if (Math.random() < (noisePercentage/100)) noiseFiles[num].play();
}

void keyPressed() {
 if (key == '1') {
    resetTimeout(0);
    playAudio(0);
  } else if (key == '2') {
    resetTimeout(1);
    playAudio(1);
  } else if (key == '3') {
    resetTimeout(2);
    playAudio(2);
  } else if (key == '4') {
    resetTimeout(3);
    playAudio(3);
  } else if (key == '5') {
    resetTimeout(4);
    playAudio(4);
  } else if (key == '6') {
    resetTimeout(5);
    playAudio(5);
  } else if (key == '7') {
     resetTimeout(6);
     playAudio(6);
  } else if (key == 'o') {
     octaveShift(); 
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