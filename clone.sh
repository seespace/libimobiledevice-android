#/bin/bash
ROOT_DIR=$(pwd)

git clone https://github.com/libimobiledevice/libimobiledevice.git
cd libimobiledevice
git checkout f268393d4e447ac901879bee751d7350c495fed2
cd ${ROOT_DIR}

git clone https://github.com/libimobiledevice/libplist.git
cd libplist
git checkout 9ca25d293fe7f8aca8d952fc7bb91464fe2d34ab
cd ${ROOT_DIR}

git clone https://github.com/libimobiledevice/libusbmuxd.git
cd libusbmuxd
git checkout 4d365eefe8255e8f693bce008dc71bf415279c7e
cd ${ROOT_DIR}

git clone https://github.com/libimobiledevice/usbmuxd.git
cd usbmuxd
git checkout 423fb8c0e9750190d2b7f9c306df9efaa7080dbd
cd ${ROOT_DIR}

git clone git://git.gnome.org/libxml2
cd libxml2
git checkout 3eaedba1b64180668fdab7ad2eba549586017bf3
cd ${ROOT_DIR}

git clone https://github.com/libusb/libusb.git
cd libusb
git checkout c141457debff6156b83786eb69b46d873634e5bd
cd ${ROOT_DIR}