# ros Dockerfile
FROM ubuntu:latest

# update
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y curl wget cmake 

# set up timezone
#RUN echo 'Etc/UTC' > /etc/timezone && ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y dirmngr gnupg2 && rm -rf /var/lib/apt/lists/*

# set up environment variable
ENV ROS_DISTRO melodic

## install ros http://wiki.ros.org/melodic/Installation/Ubuntu
# setup ros keys 
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main restricted universe multiverse" > /etc/apt/sources.list.d/ros-latest.list
#RUN lsb_release -sc
#RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN cat /etc/apt/sources.list.d/ros-latest.list
#RUN apt update

## install ros2
# setup ros2 keys
RUN curl http://repo.ros2.org/repos.key | apt-key add -
RUN echo "deb http://repo.ros2.org/ubuntu/main bionic main" > /etc/apt/sources.list.d/ros2-latest.list

# add gazebo key
RUN wget http://packages.osrfoundation.org/gazebo.key
RUN apt-key add gazebo.key
RUN apt-get update && apt-get upgrade

# install ros packages
#RUN apt-get update && apt-get install -y ros-melodic-actionlib ros-melodic-bond-core ros-melodic-dynamic-reconfigure ros-melodic-nodelet-core ros-melodic-ros-core && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y ros-melodic-ros-base && rm -rf /var/lib/apt/lists/*
# install dependencies
RUN apt-get update && apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && rm -rf /var/lib/apt/lists/*
# initialize rosdep
RUN rosdep init && rosdep update

# install colcon
RUN apt-get update && apt-get install -y python3-colcon-common-extensions
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; rosdep install -y catkin"

# install colcon bundle tool
RUN apt-get install -y python-apt python-pip python3-apt python3-pip
RUN pip3 install colcon-ros-bundle

# create directory
RUN mkdir -p /home/environment
WORKDIR /home/environment

CMD ["/bin/bash", ]
