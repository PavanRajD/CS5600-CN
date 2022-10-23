
import socket
import threading
from typing import Tuple

connectedUsers = {}

def sendMessage(messageFormat: str) -> None:
	#need to decide on message formating, will likely need to refactor after
	messageParsed = messageFormat.split("---StartMessage---")
	if messageParsed[0] in connectedUsers.keys():
		recipientConn = connectedUsers[messageParsed[0]]
		recipientConn["Socket"].send(messageParsed[1].encode())
	else:
		#again add stuff for when we store messages
		print("no connection")
	

def clientConnection(clientSocket: socket.socket, address: Tuple[str,int]) -> None:
	
	try:
		username = clientSocket.recv(1024).decode()
		
		connectionDict = {"Socket": clientSocket, "Address": address}
		
		connectedUsers[username] = connectionDict
		
		#give unsent messages
		
		while True:
			#keep running while connected
			messageSent = clientSocket.recv(1024).decode()
			#this stops us from looking for a client of empty string, thus calling send and getting a spam of prints
			if messageSent != "":
				sendMessage(messageSent)
		
	except:
		print("There has been an exception, maybe the connection was closed")
	
	finally:
		#clean up so people don't think we are still connected
		connectedUsers.pop(username)
		clientSocket.close()
		
		
		
	
	
	
def main() -> None:
	mainSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
	mainPort = 6534
	
	mainSocket.bind(("",mainPort))
	
	mainSocket.listen(5)
	
	threads = []
	
	try:
		while True:
			
			clientSocket, clientIP = mainSocket.accept()
			
			newThread = threading.Thread(target=clientConnection, args=(clientSocket, clientIP))
			
			newThread.start()
			
			threads.append(newThread)
			
	except:
		print("an exception occured, perhaps from killing the server")
	finally:
		mainSocket.close()
			
main()
