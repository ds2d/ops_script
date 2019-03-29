#!/usr/bin/env bash
# print cheng fa kou jue

for i in `seq 1 9`
do
    for j in `seq 1 $i`
    do
        k=$[$i * $j]    
        echo -n "${i}x${j}=$k  "
    done
    echo
done

awk 'BEGIN{for(n=1;n<=9;n++){for(i=1;i<=n;i++)printf i"*"n"="i*n " ";print ""}}'

#!/usr/bin/env python
# _*_ coding: utf-8 _*_

for i in [ 1 + x for x in xrange(9) ]:
    for x in xrange(i):
        j = x + 1
        print "%sx%s=%s" %(i, j, i * j),
        if i == j:
            print


for i in [ 1 + i for i in xrange(9) ]:
    for j in [ 1 + j for j in xrange(i) ]:
        print "%sx%s=%s" %(i, j, i * j),
        if i == j:
            print


print '\n'.join([' '.join(['%sx%s=%-2s' %(y, x, x * y) for y in range(1, x + 1)]) for x in range(1, 10)])

# 编写一个脚本，打印任何数的乘法表。如输入3则打印
# 1*1=1
# 2*1=2 2*2=4
# 3*1=3 3*2=6 3*3=9


awk 'BEGIN{printf "input num: ";getline a < "-";for(n=1;n<=a;n++){for(i=1;i<=n;i++)printf i"*"n"="i*n"\t";print}}'


#!/bin/bash
read -p " input num: " num
for i in `seq 1 $num`
do
    for j in `seq 1 $i`
    do
        k=$[$i * $j]
        echo -n "${i}x${j}=$k  "
    done
    echo
done
