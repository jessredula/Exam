
#!/bin/bash

while getopts :c:w:e opt; do
	case $opt in
		c) CRITICAL=$OPTARG
			;;
		w) WARNING=$OPTARG
			;;
		e) EMAIL=$OPTARG
			;;
		?) echo "$OPTARG is an Invalid Parameter" exit 2
			;;
	esac
done
	if [[ $CRITICAL -lt $WARNING ]] then
	echo "Error: Warning Parameter is greater than Critical Parameter" 
	exit 2
	
	else	
		MONITOR=$( free | grep Mem)
		MEM_TOTAL=$(echo $MONITOR | awk '{ print $2}' )
		MEM_USED=$(echo $MONITOR | awk 'print $3' )
		MEM_FREE=$(echo $TOTAL_MEM | awk 'print $4' )

		DATE=$(date +%Y%m%d)
		TIME=$(date +%H:M)
		TIMESTAMP="$DATE $TIME"

		TEMP_WARNING_VALUE=$(($WARNING * $MEM_TOTAL ))
		WARNING_VALUE=$(($TEMP_WARNING_VALUE / 100 ))

		TEMP_CRITICAL_VALUE=$(($CRITICAL * MEM_TOTAL ))
		CRITICAL_VALUE=$(($TEMP_CRITICAL_VALUE / 100 ))

		if [[ $MEM_USED -gt $CRITICAL_VALUE ]] || [[ $MEM_USED -eq $CRITICAL_VALUE ]]
			then
			PROCESS=$(ps axo ruser,%mem,comm,pid,euser | sort -nr | head -n 10)
			mail -s "$TIMESTAMP memory check - critical" $EMAIL <<< "$PROCESS"
			echo "Status: 2  Time Stamp: $TIMESTAMP"
			exit 2
		else if [[ $MEM_USED -gt $WARNING_VALUE ]] || [[ $MEM_USED -eq $WARNING_VALUE ]] && [[ $MEM_USED -lt $CRITICAL_VALUE ]]
			then
			echo "Status: 1  Time Stamp: $TIMESTAMP"
			exit 1	
		else
			echo "Status: 0  Time Stamp: $TIMESTAMP "
			exit 0
		fi
	fi
fi
