## Multinet
```
 ___________________________________ 
|              admin00              |
|           ip: 10.9.8.10           |
|_________________._________________|
         _________|___________ ...  
        |                   |
 _______|_______     _______|_______ 
|   server01    |   |    server02   |
| ip: 10.9.8.11 |   | ip: 10.9.8.12 |
|_______________|   |_______________|
```

### Running the scripts
```
# Checking the multinet status
./multinet-status.sh

# Executing commands on remote servers listed in server.txt
./run-everywhere.sh COMMAND

# executing sudo commands on remote servers listed in server.txt
./run-everywhere.sh -s COMMAND

# Dry-run mode
./run-everywhere.sh -n COMMAND

# Verbose mode
./run-everywhere.sh -v COMMAND
```
