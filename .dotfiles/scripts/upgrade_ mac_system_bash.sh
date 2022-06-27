#!/bin/bash

# Must be run in system recovery mode to temporarly bypass system integrity protection (SIP)

brew install bash;
sudo csrutil disable;
sudo cp /bin/bash ~/temp_bash;
sudo rm /bin/bash;
sudo ln -s /usr/local/bin/bash /bin/bash;
sudo rm ~/temp_bash;
sudo csrutil enable;
