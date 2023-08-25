# Custom Cammands Utilty
## Description
This is a user defined custom command utilty for linux users.

## Setup
1. Clone the repository
```
git clone 
```
2. Add the path of the cloned repository to the PATH variable in the .bashrc file
```
export PATH=$PATH:<path to the cloned repository>
```
3. Source the .bashrc file
```
source ~/.bashrc
```
4. setup the environment
```
chmod +x setup-env.sh
./setup-env.sh
```

## Usage
1. To create a new command, create a new file in scripts/ dir
```
cd scripts
touch my-new-command.sh
```
2. Edit the command as required
3. Run the setup script
```
cd ..
./setup-env.sh
``` 
4. Now you should be able to use the new custom command in terminal
```
my-new-command
```


