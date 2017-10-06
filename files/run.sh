#!/bin/bash

/tools/tivoli/ITM/bin/itmcmd agent stop lz
/tools/tivoli/ITM/bin/itmcmd agent stop 0g
#/tools/tivoli/ITM/bin/itmcmd agent -o Lin_Syslog stop lo
#/tools/tivoli/ITM/bin/itmcmd agent -o AppLogs1 stop lo

/tools/tivoli/ITM/bin/itmcmd agent start lz
/tools/tivoli/ITM/bin/itmcmd agent start 0g
#/tools/tivoli/ITM/bin/itmcmd agent -o Lin_Syslog start lo
#/tools/tivoli/ITM/bin/itmcmd agent -o AppLogs1 start lo
