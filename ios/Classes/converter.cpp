//
// Created by alexyuyl on 6/3/2023.
//

#include <cmath>
#include <algorithm>
#include <stdint.h>
#include "converter.h"

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/core/utility.hpp>
#include "NumCpp.hpp"

extern "C" {
    using namespace std;

    __attribute__((visibility("default"))) __attribute__((used)) int clamp(int lower, int higher, int val) {
        if (val < lower) return 0;
        else if (val > higher) return 255;
        else return val;
    }

    __attribute__((visibility("default"))) __attribute__((used)) int getRotatedImageByteIndex(int x, int y, int rotatedImageWidth) {
        return rotatedImageWidth * (y+1) - (x+1);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    int *convertImage(uint8_t *plane0, uint8_t *plane12, int size1, int size2, int bytesPerRow, int bytesPerPixel, int width, int height) {
        int *valueRef = (int*)malloc(sizeof(int));

        int bytesPerColumn = size1 / bytesPerRow;

        int x, y, uvIndex, index;
        int yp, up, vp;
        int r, g, b;
        int rt, gt, bt;

        int n = size2;

        uint8_t *plane1 = (uint8_t *)malloc(sizeof(uint8_t) * n / 2);
        uint8_t *plane2 = (uint8_t *)malloc(sizeof(uint8_t) * n / 2);

        int uCount = 0;
        int vCount = 0;
        for (int i = 0; i < n; i++) {
            if (i % 2 == 0) {
                plane1[uCount] = plane12[i];
                uCount++;
            } else if (i % 2 == 1) {
                plane2[vCount] = plane12[i];
                vCount++;
            }
        }

        uCount = 0; vCount = 0;

        vector<int> yuv2rgb0; vector<int> yuv2rgb1; vector<int> yuv2rgb2;
        vector<int> yuv2int0; vector<int> yuv2int1; vector<int> yuv2int2;

        for (x = 0; x < bytesPerColumn; x++) {
                for (y = 0; y < bytesPerRow; y++) {
                    uvIndex = (x/4) * bytesPerRow +  y/2;
                    index = x * bytesPerRow + y;

                    yp = plane0[index];
                    up = plane1[uvIndex];
                    vp = plane2[uvIndex];

                    rt = round(yp + vp * 1436 / 1024 - 179);
                    gt = round(yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91);
                    bt = round(yp + up * 1814 / 1024 - 227);
                    r = clamp(0,255,rt);
                    g = clamp(0,255,gt);
                    b = clamp(0,255,bt);

                    yuv2rgb0.push_back(r);
                    yuv2rgb1.push_back(g);
                    yuv2rgb2.push_back(b);
                    
                    yuv2int0.push_back(r);
                    yuv2int1.push_back(g);
                    yuv2int2.push_back(b);
                }
        }
        
        for (int i = 0; i < yuv2rgb0.size(); i++) {
            if (yuv2rgb0.at(i) < 200 || yuv2rgb1.at(i) > 200) {
                yuv2rgb0.at(i) = 0;
                yuv2rgb1.at(i) = 0;
                yuv2rgb2.at(i) = 0;
            }
        }
        
        vector<uchar> rgb2uchar0; vector<uchar> rgb2uchar1; vector<uchar> rgb2uchar2;
        vector<uchar> int2uchar0; vector<uchar> int2uchar1; vector<uchar> int2uchar2;

        for (int i = 0; i < yuv2rgb0.size(); i++) {
            rgb2uchar0.push_back(static_cast<uchar>(yuv2rgb0.at(i)));
            rgb2uchar1.push_back(static_cast<uchar>(yuv2rgb1.at(i)));
            rgb2uchar2.push_back(static_cast<uchar>(yuv2rgb2.at(i)));
            
            int2uchar0.push_back(static_cast<uchar>(yuv2int0.at(i)));
            int2uchar1.push_back(static_cast<uchar>(yuv2int1.at(i)));
            int2uchar2.push_back(static_cast<uchar>(yuv2int2.at(i)));
        }
        
        cv::Mat rgbCh0(rgb2uchar0); cv::Mat rgbCh1(rgb2uchar1); cv::Mat rgbCh2(rgb2uchar2);
        cv::Mat ch0(int2uchar0); cv::Mat ch1(int2uchar1); cv::Mat ch2(int2uchar2);

        rgbCh0 = rgbCh0.reshape(0, bytesPerColumn);
        rgbCh1 = rgbCh1.reshape(0, bytesPerColumn);
        rgbCh2 = rgbCh2.reshape(0, bytesPerColumn);
        
        ch0 = ch0.reshape(0, bytesPerColumn);
        ch1 = ch1.reshape(0, bytesPerColumn);
        ch2 = ch2.reshape(0, bytesPerColumn);

        cv::Mat mergeRgb[3] = {rgbCh0, rgbCh1, rgbCh2}; cv::Mat rgb;
        cv::Mat mergeSrc[3] = {ch0, ch1, ch2}; cv::Mat mergeDst;

        cv::merge(mergeRgb, 3, rgb);
        cv::merge(mergeSrc, 3, mergeDst);
        
        cv::Mat kernel = cv::getStructuringElement(0, cv::Size(5,5));
        
        cv::Mat opening; cv::morphologyEx(rgb, opening, 3, kernel);
        cv::Mat closing; cv::morphologyEx(opening, closing, 3, kernel);
        
        cv::Mat rgb_filter = closing;

        cv::Mat rgb2lab;
        
        cv::cvtColor(rgb_filter, rgb2lab, cv::COLOR_RGB2Lab);
        
        vector<cv::Mat> labChannels(3);
        
        cv::split(rgb2lab, labChannels);
        
        vector<uchar> lab2uchar0; vector<uchar> lab2uchar1; vector<uchar> lab2uchar2;
        
        lab2uchar0.assign(labChannels[0].data, labChannels[0].data + labChannels[0].total());
        lab2uchar1.assign(labChannels[1].data, labChannels[1].data + labChannels[1].total());
        lab2uchar0.assign(labChannels[2].data, labChannels[2].data + labChannels[2].total());
        
        vector<int> lab0int; vector<int> lab1int; vector<int> lab2int;
        
        for (int i = 0; i < lab2uchar0.size(); i++) {
            lab0int.push_back(static_cast<int>(lab2uchar0.at(i)));
            lab1int.push_back(static_cast<int>(lab2uchar1.at(i)));
            lab2int.push_back(static_cast<int>(lab2uchar0.at(i)));
        }
        
        for (int i = 0; i < lab2uchar0.size(); i++) {
            if (lab1int.at(i) - 128 < 8 || lab1int.at(i) - 128 > 22 || lab2int.at(i) - 128 < 8 || lab2int.at(i) - 128 > 22) {
                lab0int.at(i) = 0;
                lab1int.at(i) = 0;
                lab2int.at(i) = 0;
            }
            if (abs(lab1int.at(i) - lab2int.at(i)) > 30) {
                lab0int.at(i) = 0;
                lab1int.at(i) = 0;
                lab2int.at(i) = 0;
            }
        }
        
        int labPercentageCount = 0;
        for (int i = 0; i < lab1int.size(); i++) {
            if (lab1int.at(i) != 0) {
                labPercentageCount++;
            }
        }

        int value = 0;
        
        double labPercentage = double(labPercentageCount) / double(lab0int.size()) * 100;
        if (labPercentage > 0.1) {
            value += 1000;
        }
        
        lab2uchar0.clear(); lab2uchar1.clear(); lab2uchar2.clear();

        for (int i = 0; i < yuv2rgb0.size(); i++) {
            lab2uchar0.push_back(static_cast<uchar>(lab0int.at(i)));
            lab2uchar1.push_back(static_cast<uchar>(lab1int.at(i)));
            lab2uchar2.push_back(static_cast<uchar>(lab2int.at(i)));
        }
        
        cv::Mat labCh0(lab2uchar0); cv::Mat labCh1(lab2uchar1); cv::Mat labCh2(lab2uchar2);

        labCh0 = labCh0.reshape(0, bytesPerColumn);
        labCh1 = labCh1.reshape(0, bytesPerColumn);
        labCh2 = labCh2.reshape(0, bytesPerColumn);

        cv::Mat mergeLab[3] = {labCh0, labCh1, labCh2}; cv::Mat lab;

        cv::merge(mergeLab, 3, lab);
        
        cv::Mat rgb2hls; cv::cvtColor(mergeDst, rgb2hls, cv::COLOR_RGB2HLS);
        
        // Here Need To Use YUV To HLS, Not The Filtered Data

        int Lfilter1 = 50;

        vector<cv::Mat> hlsChannels(3);

        cv::split(rgb2hls, hlsChannels);

        vector<uchar> hls2uchar0; vector<uchar> hls2uchar1; vector<uchar>hls2uchar2;

        hls2uchar0.assign(hlsChannels[0].data, hlsChannels[0].data + hlsChannels[0].total());
        hls2uchar1.assign(hlsChannels[1].data, hlsChannels[1].data + hlsChannels[1].total());
        hls2uchar2.assign(hlsChannels[2].data, hlsChannels[2].data + hlsChannels[2].total());

        vector<int> hls0int; vector<int> hls1int; vector<int> hls2int;

        for (int i = 0; i < hls2uchar0.size(); i++) {
            hls0int.push_back(static_cast<int>(hls2uchar0.at(i)));
            hls1int.push_back(static_cast<int>(hls2uchar1.at(i)));
            hls2int.push_back(static_cast<int>(hls2uchar2.at(i)));
        }

        int maxL = 0;
        for (int i = 0; i < hls0int.size(); i++) {
            maxL = maxL > hls1int.at(i) ? maxL : hls1int.at(i);
        }
        for (int i = 0; i < hls0int.size(); i++) {
            if (hls1int.at(i) < (maxL - Lfilter1)) {
                hls0int.at(i) = 0;
                hls1int.at(i) = 0;
                hls2int.at(i) = 0;
            }
        }

        int hlsPercentageCount = 0;
        for (int i = 0; i < hls0int.size(); i++) {
            if (hls1int.at(i) != 0) {
                hlsPercentageCount++;
            }
        }

        double firstFilterPercentage = double(hlsPercentageCount) / double(hls0int.size()) * 100;
        if (firstFilterPercentage > 1) {
            int maxL2 = 0; int Lfilter2 = 25;
            for (int i = 0; i < hls1int.size(); i++) {
                maxL2 = maxL2 > hls1int.at(i) ? maxL2 : hls1int.at(i);
            }
            for (int i = 0; i < hls0int.size(); i++) {
                if (hls1int.at(i) < (maxL2 - Lfilter2)) {
                    hls0int.at(i) = 0;
                    hls1int.at(i) = 0;
                    hls2int.at(i) = 0;
                }
            }
        }

        /// This Transform The 2D Array Into 1D Array.
        nc::NdArray<int> columnTotals;
        nc::NdArray<int> data1NdArray(hls1int); data1NdArray.reshape(bytesPerColumn, bytesPerRow);
        columnTotals = nc::sum(data1NdArray, nc::Axis::ROW) / bytesPerColumn;

        int columnTotalsMax = columnTotals.max()[0];
        vector<int> columnTotalsVector;
        for (int i = 0; i < columnTotals.size(); i++) {
            int temp = columnTotals[i];
            if (temp != 0) {
                if (columnTotalsMax / temp > 10) {temp = 0;}
            }
            columnTotalsVector.push_back(temp);
        }

        /// This Will Store All Possible Clusters Of Points.
        vector<vector<int>> dataPointVector;
        bool clusterStart = false;
        int startIndex; int endIndex;
        for (int i = 0; i < columnTotalsVector.size(); i++) {
            if (columnTotalsVector.at(i) != 0 && clusterStart == false) {
                clusterStart = true;
                startIndex = i;
            } else if (columnTotalsVector.at(i) != 0 && clusterStart == true) {
                if (i == columnTotalsVector.size() - 1) {
                    endIndex = i;
                    if (endIndex - startIndex > 5) {
                        dataPointVector.push_back({startIndex, endIndex});
                    }
                }
            } else if (columnTotalsVector.at(i) == 0 && clusterStart == true) {
                clusterStart = false;
                endIndex = i;
                dataPointVector.push_back({startIndex, endIndex});
                }
        }

        bool merge = false;
        if (dataPointVector.size() >= 2) {
            vector<vector<int>> dataPointVectorCopy;
            for (int i = 0; i < dataPointVector.size(); i++) {
                dataPointVectorCopy.push_back(dataPointVector.at(i));
            }
            dataPointVector.clear();
            for (int i = 0; i < dataPointVectorCopy.size(); i++) {
                if (i != dataPointVectorCopy.size() - 1) {
                    if (merge == false) {
                        vector<int> point1 = dataPointVectorCopy.at(i);
                        vector<int> point2 = dataPointVectorCopy.at(i+1);
                        int startOfPoint1 = point1.at(0);
                        int endOfPoint1 = point1.at(1);
                        int startOfPoint2 = point2.at(0);
                        int endOfPoint2 = point2.at(1);
                        if (startOfPoint2 - endOfPoint1 < 50) {
                            dataPointVector.push_back({startOfPoint1, endOfPoint2});
                            merge = true;
                        } else {
                            dataPointVector.push_back({startOfPoint1, endOfPoint1});
                        }
                    } else {
                        vector<int> point1 = dataPointVector.back();
                        vector<int> point2 = dataPointVectorCopy.at(i+1);
                        int startOfPoint1 = point1.at(0);
                        int endOfPoint1 = point1.at(1);
                        int startOfPoint2 = point2.at(0);
                        int endOfPoint2 = point2.at(1);
                        if (startOfPoint2 - endOfPoint1 < 50) {
                            dataPointVector.pop_back();
                            dataPointVector.push_back({startOfPoint1, endOfPoint2});
                        } else {
                            merge = false;
                        }
                    }
                } else {
                    if (dataPointVector.size() > 0) {
                        vector<int> point1 = dataPointVector.back();
                        vector<int> point2 = dataPointVectorCopy.at(i);
                        int startOfPoint1 = point1.at(0);
                        int endOfPoint1 = point1.at(1);
                        int startOfPoint2 = point2.at(0);
                        int endOfPoint2 = point2.at(1);
                        if (startOfPoint2 - endOfPoint1 < 50) {
                            dataPointVector.pop_back();
                            dataPointVector.push_back({startOfPoint1, endOfPoint2});
                        } else {
                            dataPointVector.push_back({startOfPoint2, endOfPoint2});
                        }
                        merge = false;
                    }
                }
            }
        }
        
        if (dataPointVector.size() == 1) {
            vector<vector<int>> secondDataPointVector;
            bool clusterStart = false;
            int startIndex = 0; int endIndex = 0;
            
            vector<int> secondColumnTotalsVector;
            for (int i = 0; i < columnTotals.size(); i++) {
                secondColumnTotalsVector.push_back(columnTotals[i]);
            }
            
            for (int i = 0; i < secondColumnTotalsVector.size(); i++) {
                if (secondColumnTotalsVector.at(i) != 0 && clusterStart == false) {
                    clusterStart = true;
                    startIndex = i;
                } else if (secondColumnTotalsVector.at(i) != 0 && clusterStart == true) {
                    if (i == secondColumnTotalsVector.size() - 1) {
                        endIndex = i;
                        if (endIndex - startIndex > 5) {
                            secondDataPointVector.push_back({startIndex, endIndex});
                        }
                        startIndex = 0; endIndex = 0;
                    }
                } else if (secondColumnTotalsVector.at(i) == 0 && clusterStart == true) {
                    clusterStart = false;
                    endIndex = i;
                    secondDataPointVector.push_back({startIndex, endIndex});
                    startIndex = 0; endIndex = 0;
                }
            }
            
            bool merge = false;
            if (secondDataPointVector.size() >= 2) {
                vector<vector<int>> secondDataPointVectorCopy;
                for (int i = 0; i < secondDataPointVector.size(); i++) {
                    secondDataPointVectorCopy.push_back(secondDataPointVector.at(i));
                }
                secondDataPointVector.clear();
                for (int i = 0; i < secondDataPointVectorCopy.size(); i++) {
                    if (i != secondDataPointVectorCopy.size() - 1) {
                        if (merge == false) {
                            vector<int> point1 = secondDataPointVectorCopy.at(i);
                            vector<int> point2 = secondDataPointVectorCopy.at(i+1);
                            int startOfPoint1 = point1.at(0);
                            int endOfPoint1 = point1.at(1);
                            int startOfPoint2 = point2.at(0);
                            int endOfPoint2 = point2.at(1);
                            if (startOfPoint2 - endOfPoint1 < 50) {
                                secondDataPointVector.push_back({startOfPoint1, endOfPoint2});
                                merge = true;
                            } else {
                                secondDataPointVector.push_back({startOfPoint1, endOfPoint2});
                            }
                        } else {
                            vector<int> point1 = secondDataPointVector.back();
                            vector<int> point2 = secondDataPointVectorCopy.at(i+1);
                            int startOfPoint1 = point1.at(0);
                            int endOfPoint1 = point1.at(1);
                            int startOfPoint2 = point2.at(0);
                            int endOfPoint2 = point2.at(1);
                            if (startOfPoint2 - endOfPoint1 < 50) {
                                secondDataPointVector.pop_back();
                                secondDataPointVector.push_back({startOfPoint1, endOfPoint2});
                            } else {
                                merge = false;
                            }
                        }
                    } else {
                        if (secondDataPointVector.size() > 0) {
                            vector<int> point1 = secondDataPointVector.back();
                            vector<int> point2 = secondDataPointVectorCopy.at(i);
                            int startOfPoint1 = point1.at(0);
                            int endOfPoint1 = point1.at(1);
                            int startOfPoint2 = point2.at(0);
                            int endOfPoint2 = point2.at(1);
                            if (startOfPoint2 - endOfPoint1 < 50) {
                                secondDataPointVector.pop_back();
                                secondDataPointVector.push_back({startOfPoint1, endOfPoint2});
                            } else {
                                secondDataPointVector.push_back({startOfPoint2, endOfPoint2});
                            }
                            merge = false;
                        }
                    }
                }
            }
            if (secondDataPointVector.size() == 2) {
                dataPointVector.clear();
                for (int i = 0; i < secondDataPointVector.size(); i++) {
                    dataPointVector.push_back(secondDataPointVector.at(i));
                }
            }
        }

        /// Now Only Deal With One Cluster And Two Clusters. More Than Two Is Not Considered.
        int pixelDifference = -1;
        if (dataPointVector.size() == 1) {
            vector<int> dataPoint = dataPointVector.at(0);
            int startOfPoint = dataPoint.at(0); int endOfPoint = dataPoint.at(1);
            vector<int> columnTotalsVectorCopy(&columnTotalsVector.at(startOfPoint), &columnTotalsVector.at(endOfPoint));
            int singleMax = 0;
            for (int i = 0; i < columnTotalsVectorCopy.size(); i++) {
                singleMax = singleMax > columnTotalsVectorCopy.at(i) ? singleMax : columnTotalsVectorCopy.at(i);
            }

            vector<int> singleMaxCoordinateVector;
            for (int i = 0; i < columnTotalsVectorCopy.size(); i++) {
                if (columnTotalsVectorCopy.at(i) == singleMax) {
                    singleMaxCoordinateVector.push_back(i);
                }
            }
            int singleMaxCoordinate = singleMaxCoordinateVector.at(0);
            if (singleMaxCoordinateVector.size() > 1) {
                int sumOfCoordinate = 0;
                for (int i = 0; i < singleMaxCoordinateVector.size(); i++) {
                    sumOfCoordinate += singleMaxCoordinateVector.at(i);
                }
                singleMaxCoordinate = sumOfCoordinate / singleMaxCoordinateVector.size();
            }
            int projectCoordinate = startOfPoint + singleMaxCoordinate;
            int mirrorCoordinate = columnTotalsVector.size() - projectCoordinate;
            pixelDifference = abs(mirrorCoordinate - projectCoordinate);
        } else if (dataPointVector.size() == 2) {
            vector<int> dataPoint1 = dataPointVector.at(0); vector<int> dataPoint2 = dataPointVector.at(1);
            int startOfPoint1 = dataPoint1.at(0); int endOfPoint1 = dataPoint1.at(1);
            int startOfPoint2 = dataPoint2.at(0); int endOfPoint2 = dataPoint2.at(1);

            vector<int> columnTotalsVectorCopy1(&columnTotalsVector.at(startOfPoint1), &columnTotalsVector.at(endOfPoint1));
            vector<int> columnTotalsVectorCopy2(&columnTotalsVector.at(startOfPoint2), &columnTotalsVector.at(endOfPoint2));

            int firstMax = 0; int secondMax = 0;
            for (int i = 0; i < columnTotalsVectorCopy1.size(); i++) {
                firstMax = firstMax > columnTotalsVectorCopy1.at(i) ? firstMax : columnTotalsVectorCopy1.at(i);
            }
            for (int i = 0; i < columnTotalsVectorCopy2.size(); i++) {
                secondMax = secondMax > columnTotalsVectorCopy2.at(i) ? secondMax : columnTotalsVectorCopy2.at(i);
            }
            vector<int> firstMaxCoordinateVector; vector<int> secondMaxCoordinateVector;
            for (int i = 0; i < columnTotalsVectorCopy1.size(); i++) {
                if (columnTotalsVectorCopy1.at(i) == firstMax) {
                    firstMaxCoordinateVector.push_back(i);
                }
            }
            for (int i = 0; i < columnTotalsVectorCopy2.size(); i++) {
                if (columnTotalsVectorCopy2.at(i) == secondMax) {
                    secondMaxCoordinateVector.push_back(i);
                }
            }

            /// If Finally Succeed To Get Two Cluster, Calculate The Average Point Of Each Cluster
            int firstMaxCoordinate; int secondMaxCoordinate;
            firstMaxCoordinate = firstMaxCoordinateVector.at(0); secondMaxCoordinate = secondMaxCoordinateVector.at(0);
            if (firstMaxCoordinateVector.size() > 1) {
                int sumOfFirstCoordinate = 0;
                for (int i = 0; i < firstMaxCoordinateVector.size(); i++) {
                    sumOfFirstCoordinate += firstMaxCoordinateVector.at(i);
                }
                firstMaxCoordinate = sumOfFirstCoordinate / firstMaxCoordinateVector.size();
            }
            if (secondMaxCoordinateVector.size() > 1) {
                int sumOfSecondCoordinate = 0;
                for (int i = 0; i < secondMaxCoordinateVector.size(); i++) {
                    sumOfSecondCoordinate += secondMaxCoordinateVector.at(i);
                }
                secondMaxCoordinate = sumOfSecondCoordinate / secondMaxCoordinateVector.size();
            }
            int projectCoordinate1 = startOfPoint1 + firstMaxCoordinate;
            int projectCoordinate2 = startOfPoint2 + secondMaxCoordinate;
            pixelDifference = abs(projectCoordinate2 - projectCoordinate1);
        }

        /// Calculate The Percentage Difference
        if (pixelDifference != -1) {
            value += pixelDifference * 100 / columnTotalsVector.size();
        }

        valueRef[0] = value;

        yuv2rgb0.clear(); yuv2rgb1.clear(); yuv2rgb2.clear();
        hls0int.clear(); hls1int.clear(); hls2int.clear();

        rgb2uchar0.clear(); rgb2uchar1.clear(); rgb2uchar2.clear();
        hls2uchar0.clear(); hls2uchar1.clear(); hls2uchar2.clear();

        rgbCh0.release(); rgbCh1.release(); rgbCh2.release(); hlsChannels.clear();

        columnTotalsVector.clear(); dataPointVector.clear();

        free(plane1); free(plane2);
        
        return valueRef;
    }
 }
