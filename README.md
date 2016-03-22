# jdk-cluster-installer

A bash scripting for install a new JDK version on cluster using ssh.

### Version
1.0

### Requirements
- open-ssh-client on local machine
- open-ssh-server on remote machine
- user with root privileges on cluster
- the extracted JDK folder

### Installation
Download the scripts and make them executable

```sh
$ chmod +x jdk-cluster-installer.sh set-jdk-as-default.sh
```

After download and extract the JDK which you want to install, you need just to copy both scripts and the JDK folder on cluster master node in $HOME directory.

```sh
$ scp jdk-cluster-installer.sh set-jdk-as-default.sh host@server:.

$ scp -r JDK_FOLDER host@server:.
```

## How to use

#### Install JDK on master node
On master node runs
```sh
$ sudo ./set-jdk-as-default.sh JDK_FOLDER
```


#### Install JDK on slave nodes
From master node easly runs

```sh
$ ./jdk-cluster-installer.sh -j JDK_FOLDER -h "slave1 slave2 ...."
```
Arguments:
- **j**    
    The JDK folder to install
- **h**  
    A slaves node list which on install the JDK

## Conclusions
For checking if the installation was successful, run
```sh
$ java -version
```
