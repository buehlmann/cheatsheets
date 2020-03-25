# VirtualBox
Host OS: Ubuntu Eoan

### USB 3.0
* Install Extension Pack in Virtualbox Preferences
* Download: https://www.virtualbox.org/wiki/Download_Old_Builds_6_0

## Using Webcam in guest os
* Extension Pack must be installed
* Start VirtualBox
* `VBoxManage list webcams`
  ```
  $ VBoxManage list webcams
  Video Input Devices: 2
  .1 "Integrated Camera: Integrated C"
  /dev/video0
  .2 "Integrated Camera: Integrated C"
  /dev/video1
  ```
* `VBoxManage list vms`
  ```
  "confluent" {7cd09ee0-b2e8-4608-9454-b30193d4e052}
  "Windows 10 (Valid until 04.05.2020)" {cbf85c99-f17f-4de0-9579-bfb2c8b7effb}
  "Windows 10 (90 days trial)" {afb2ee82-cc27-4b86-a595-55f4171472a0}
  ```
* `VBoxManage controlvm "Windows 10 (90 days trial)" webcam attach .1`
