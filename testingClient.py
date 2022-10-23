#this client exist to test sending to another client. This is a near bare bones testing program.

import socket


mainSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
serverPort = 6534

mainSocket.connect(("localhost", serverPort))
mainSocket.send("Tester".encode())
while True:
	message = input("enter message: ")
	if message == "exit":
		mainSocket.close()
		break;
	else:
		packet = "Sally---StartMessage---" + message
		mainSocket.send(packet.encode())

