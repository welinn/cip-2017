#include "opencv2/imgproc/imgproc.hpp" //openCV image processing libruary
#include "opencv2/highgui/highgui.hpp" //openCV high gui libruary
#include <stdio.h>

using namespace cv;

void SliderCallback(int, void*);

int slider_mode = 0;       //mode slider return value
int slider_value = 50;     //value slider return value
int const max_value = 100; //value slider MAX
Mat img;

int main(int argc, char** argv){

  double rate;

  img = imread("./sorce.jpg");
  if (!img.data) {
    printf("Image not found!\n");
    return -1;
  }

  printf("Input image size:\n  w: %d, h: %d\n", img.cols, img.rows);

  rate = 650.0 / img.cols;
  resize(img, img, Size(img.cols * rate, img.rows * rate));
  printf("Resized image size:\n  w: %d, h: %d\n", img.cols, img.rows);

  putText(img, "M10515103", Point(50, img.rows * .9),
    FONT_HERSHEY_COMPLEX | FONT_ITALIC, 2, CV_RGB(255, 0, 255), 3, CV_AA);

  printf("Mode:\n  0. Negative (partly)\n  1. Hue adjustment\n");
  printf("  2. Saturation adjustment\n  3. Value adjustment\n");

  namedWindow("HW2");
  createTrackbar("Mode", "HW2", &slider_mode, 3, SliderCallback);
  createTrackbar("Val", "HW2", &slider_value, max_value, SliderCallback);
  SliderCallback(0, 0);

  while (waitKey() == 27){
    break;
  }
  return 0;
}

void SliderCallback(int, void*){
  Mat dst = img.clone();
  Mat inv, invCut, cut;
  Rect rect;
  double valueRate;
  int x;

  if(slider_mode == 0){ //Anti-White

    bitwise_not(dst, inv);

    valueRate = (double) slider_value / (double) max_value;
    x = (int) dst.cols * valueRate;

    cut = dst(Rect(0, 0, x, dst.rows));
    invCut = inv(Rect(0, 0, x, dst.rows));
    addWeighted(cut, 0, invCut, 1, 0, cut);
  }
  else{
    cvtColor(dst, dst, CV_BGR2HSV);
    vector<Mat> hsv_plane;
    split(dst, hsv_plane);    //3 channels to 1 channel

    if(slider_mode == 1)      //H
      convertScaleAbs(hsv_plane.at(0), hsv_plane.at(0), 1, slider_value - 50);
    else if(slider_mode == 2) //S
      convertScaleAbs(hsv_plane.at(1), hsv_plane.at(1), slider_value / 50.0, 0);
    else                      //V
      convertScaleAbs(hsv_plane.at(2), hsv_plane.at(2), slider_value / 50.0, 0);

    merge(hsv_plane, dst);    //1 channel to 3 channels
    cvtColor(dst, dst, CV_HSV2BGR);
  }
  imshow("HW2", dst);
}
