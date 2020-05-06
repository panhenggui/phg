#!/bin/bash
tar -xvf $1
var=$1
echo $var
var1=`echo ${var%.*}`
echo $var1
var2=`echo ${var1%.*}`
echo $var2
echo "use qdam;" >oper.sql
sed -n '/Database: qdam/,/40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */p' $var2 >>oper.sql
sed -n '/Table structure for table `t_oper_adviceorder`/,/Table structure for table `t_operation_log`/p' $var2 >>oper.sql
sed -n '/40103 SET TIME_ZONE=@OLD_TIME_ZONE */,/40111 SET SQL_NOTES=@OLD_SQL_NOTES */p' $var2 >> oper.sql
sed -i '/Table structure for table `t_operation_log`/d' oper.sql
mysql -h$2 -uqdam -pqdam << EOF
source oper.sql
EOF
if [ $? != 0 ];then
    echo "oper表导入失败"
    exit 1
fi
echo "oper表导入成功"
rm -f $var2 oper.sql

