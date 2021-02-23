network_name=`ip link show | awk '/state UP/ {print $2}' | head -c -2`


while :
do

  # Network -----------------------------------------------
  R1=`cat /sys/class/net/$network_name/statistics/rx_bytes`
  T1=`cat /sys/class/net/$network_name/statistics/tx_bytes`
  sleep 1
  R2=`cat /sys/class/net/$network_name/statistics/rx_bytes`
  T2=`cat /sys/class/net/$network_name/statistics/tx_bytes`
  TXBPS=`expr $T2 - $T1`
  RXBPS=`expr $R2 - $R1`
  # -----------------------------------------------------

  #speed=`expr $RXBPS / 1048576`
  speed=`[ ${RXBPS} -gt 1024000 ] && echo $(($RXBPS/1048576)) MiB || echo $(($RXBPS/1024)) KiB`

  speed1=`echo $RXBPS | awk '{ split( "k m g" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ } print int($1) v[s] }'`


  today=`date '+%A, %B %d, %Y'`

  memory=`free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }'`
  disk=`df -h | awk '$NF=="/"{printf "%s", $5}'`
  cpu=`top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}'`


  echo " ${speed} | MEM. $memory |  $disk |  $cpu | $today"

done

# echo "$rx_speed MiB | $tx_speed MiB"
