![Logo](https://ycit-team-terraformers.github.io/favicon.png)

# Description

Builds an image capable to run terraform version 1.0.10. This image could be used to run a container as an executable.

The image creates a volume called /terraformfiles that will be the terraform working directory.

## Why running terraform in a container

Terraform can also run in a non-containerized mode where the Terraform CLI packages need to be installed in your local environment, however there are some advatages to run terraform from a container.

the following articles give some reasons to run terraform from a container.

 - [Treating Your Terraform like an Application: Part 1](https://medium.com/capital-one-tech/treating-your-terraform-like-an-application-why-terraform-in-a-docker-container-31e802314b4)

   And More details.
 - [Treating Your Terraform like an Application: Part 2](https://medium.com/capital-one-tech/treating-your-terraform-like-an-application-how-to-dockerize-terraform-5d7edac741fc)

 The articles sumarize, Terraform in a Docker container allows for:
 - Terraform to fit into your already created artifact management procedures.
 - Properly versioned infrastructure.
 - Duplicate environments based on versioned infrastructure.
 - Standardization and Portability of deployment environments.


# Build image

1. Copy the Dockerfile on your environment having docker installed.

2. Run the following command to create the image.  the command expects the Dockerfile exist in the local directory where it is running.

 Example, the following command creates an image named 'terraformers' with tag 'v1'.

 ```
 docker build -t terraformers:v1 .
 ```

 > **Note**: if the Dockerfile is not in the folder where docker build runs, then replace the final dot (.) with the Dockerfile path.

### Inspect the image (optional)

```
docker image inspect --format='' terraformers:v1
```

# Test

You can test the image using docker run command.
the following command will create a container running the image and execute terraform --version, the output will be the version and the OS platform.

```
docker run --rm -it terraformers:v1 --version
```

## Running terraform container

To run the terraform container you need to specify the working directory as a volume to be mounted. 

You can define the working directory in two ways:

 1. **Using absolute path**
 
  You can explicitly define the directory containing the terraform files
 
  The following command will run the init command specifying the working folder
  ```
  docker run --rm -it -v D:\YCIT021\terraform-scripts:/terraformfiles terraformers:v1 init
  ```

  *_Where_* the terraform files are in a folder named 'terraform-scripts' under the path D:\YCIT021\ 

 2. **Using current directory variable**
 
  The following command assumes the terraform files are in the local directory where the 'docker run' command is launched.

  ```
  docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 init
  ```

  3. **Using an alias & the current directory**

  In a bash shell, you can shorten the above command by adding the following to your ~/.bash_aliases file:
   
  ```
  alias tform='docker run --rm -it -v $PWD:/data -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker -w /data terraformers:v1'
  ```
  
  Then launch a new shell (or run: `source ~/.bash_aliases` to make changes effective in your current shell), and you'll be able to run:
  ```
  tform version
  tform init
  tform plan
  ```
 
 
## Create infrastructure

Examples of commands to run using the terraform container

> _Change the path according to your environment if needed._

>> _Change the image name if you used a different name building the image._
 
>>> _/terraformfiles is the volume in the image that is setup as the working directory._


1. Run container && init

```
docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 init
```

2. Run container && Plan

```
docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 plan
```

3. Run container && Auto Apply

```
docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 apply "-auto-approve"
```

 3. A) Command without the "auto-approve" flag: 
    
    
    ``` 
    docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 apply 
    ```

4. Run container && Destroy

```
docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 apply "-destroy" "-auto-approve"
```

4. A) Destroy Command without the "auto-approve" flag: 


```
docker run --rm -it -v "$(pwd):/terraformfiles" terraformers:v1 apply "-destroy"
```

## Team

- Antonio M
- Camilo M
- Christian B
- Devon P
- Diego P
- Mohammad B