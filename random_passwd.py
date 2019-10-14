#!/usr/bin/env python3
#-*-coding:utf-8-*-
#随机生成12位数的密码

import random

str_list = ['*','&','^','$','@','!']
passwd = []

l1 = [1,4,6,8]
l2 = [2,5,9,12]
l3 = [3,7,10,11]

for n in range(0,11):
    random_luck_num = int(random.randrange(1,12))
    if random_luck_num in l1:
        cap = chr(random.randrange(65,91))#大写字母
        passwd.append(cap)
    elif random_luck_num in l2:
        low = chr(random.randrange(97,112))#小写字母
        passwd.append(low)
    else:
        random_num = int(random.randrange(0,5))
        cha = str_list[random_num] #生成随机字符
        passwd.append(cha)

ret = ''.join(passwd)
print(ret)
