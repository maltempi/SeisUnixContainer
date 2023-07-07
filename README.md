# SeisUnixDocker
A container image (Docker) for portable SeisUnix with graphical interface access via Remote Desktop (RDP)

## Features

- SeisUnix: It is a powerful software package for seismic data processing and analysis. It offers a range of tools and utilities for seismic data manipulation, modeling, imaging, and more. See SeisUnix official repository: https://github.com/JohnWStockwellJr/SeisUnix

- Remote Destop (RDP) Access: The container image includes RDP access, allowing you to connect to the containerized environment using your preferred Remote Desktop client (Windows, Linux or Mac). This provides a convenient graphical interface for running SeisUnix and interacting with the seismic data.

## Container Image Repository
https://hub.docker.com/r/maltempi/seisunix

## Usual RDP clients:
- Windows (Native) 
- macOS (Microsoft Remote Desktop or CoRD)
- Linux (Remmina, FreeRDP)

## Docker Usage

### Requirements
- Docker (Linux); Docker Desktop (macOS or Windows)

### First Usage
For the initial usage, you need to download the Docker image onto your computer. Run the following command in your terminal or command prompt:

```
docker run --rm -p 3393:3389 -v ${PWD}:/home/ubuntu/data maltempi/seisunix:latest
```

### Running container
```
docker run --rm -p 3393:3389 -v ${PWD}:/home/ubuntu/data maltempi/seisunix:latest 
```

After running the above command, you can connect with your Remote Desktop client using the following credentials:
**Computer**: `localhost:3393`
**Username**: `ubuntu`
**password**: `ubuntu`

### Understanding above command:
Overall, this command creates a Docker container from the `maltempi/seisunix:latest` image, maps the RDP port, and mounts the current directory to enable data exchange between the host and the container. Let's break down the command and its components:

- `--rm`: This flag automatically removes the container when it exits, ensuring that it doesn't persist after it stops running.

- `-p 3393:3389`: This option maps port 3393 on the host machine to port 3389 within the container. Port 3389 is the default port used by Remote Desktop Protocol (RDP), allowing remote access to the container.

- `-v ${PWD}:/home/ubuntu/data`: This option mounts the current working directory (`${PWD}`) on the host machine to the `/home/ubuntu/data` directory within the container. This allows for sharing files and data between the host and the container.

- `maltempi/seisunix:latest`: This specifies the Docker image to use for creating the container. In this case, it uses the `maltempi/seisunix` image with the `latest` tag.

## Building the image

Just if you want to build it in your machine or publish a new one.

```
git clone git@github.com:maltempi/SeisUnixDocker.git
cd SeisUnixDocker
git submodule update --depth 1
docker build . -t maltempi/seisunix
```

## Contributions

Contributions to the repository are welcome! If you have ideas for improvements, bug fixes, or additional features, feel free to open an issue or submit a pull request.

## License

The code and scripts in this repository are licensed under the MIT License. You are free to use, modify, and distribute the code as per the terms of the license.

**SeisUnix License:** https://github.com/JohnWStockwellJr/SeisUnix/blob/master/LICENSE
