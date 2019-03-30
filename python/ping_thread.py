#!/usr/bin/env python
# _*_ coding: utf-8 _*_
# encoding:utf8

import threading
import subprocess
import time
from multiprocessing import Queue

# 定义工作线程
WORD_THREAD = 100

# 将需要 ping 的 ip 加入队列
IP_QUEUE = Queue()
for i in range(1, 255):
    IP_QUEUE.put('192.168.16.'+str(i))


# 定义一个执行 ping 的函数
def ping_ip():
    while not IP_QUEUE.empty():
        ip = IP_QUEUE.get()
        # res = subprocess.call('ping -n 2 -w 5 %s' % ip, stdout=subprocess.PIPE)  # linux 系统将 '-n' 替换成 '-c'
        res = subprocess.call('ping -c 4 -w 5 %s' % ip, shell=True, stdout=subprocess.PIPE)  #linux系统将'-n'替换成'-c'
        # 打印运行结果
        print(ip, True if res == 0 else False)


if __name__ == '__main__':
    threads = []
    start_time = time.time()
    for i in range(WORD_THREAD):
        thread = threading.Thread(target=ping_ip)
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

    print('程序运行耗时：%s' % (time.time() - start_time))

