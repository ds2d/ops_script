#!/bin/bash
trapper() {
    trap ':' INT EXIT TSTP TERM HUP
}

main() {
    while :
    do
        #trapper
        clear
        cat <<menu
**************************************************************************
*                                                                        *
*                                                                        *
*           1)ubuntu:192.168.154.131                                     *
*           2)centos:192.168.154.135                                 *
*           3)locathost                                                  *
*           if you want quit the server,please input the Q|q for quit.   *
*                                                                        *
*                                                                        *
**************************************************************************
menu
#  read -p "Please input the server what you want to login: " num
    read -p "" num
        case $num in
          1)
            echo "login the 192.168.154.131"
            ssh 192.168.154.131
            ;;
          2)
            echo "login the 192.168.154.135"
            ssh 192.168.154.135
            ;;
          3)
         echo "logint localhost..."
         break
         #bash
         ;;
          Q|q)
        echo "quit ......"
            exit 0
        ;;
          *)
            echo "Your input is error."
            sleep 2
            ;;
        esac
    done
}
main
