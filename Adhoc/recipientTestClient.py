#this client exists to recieve messages from the other. This is a testing client and is bare bones

import socket


mainSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
serverPort = 6534

mainSocket.connect(("localhost", serverPort))
mainSocket.send("Sally".encode())

while True:
	message = mainSocket.recv(1024).decode()
	print(message)
	if message == "close":
		mainSocket.close()
		break
