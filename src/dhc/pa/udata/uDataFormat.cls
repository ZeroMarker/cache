/// Creator: 李明忠
/// CreatDate: 2010-11-17
/// Description: 数据格式
Class dhc.pa.udata.uDataFormat Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-11-17
/// Description:将数据转换成千分位格式
/// Table:
/// Input:num-数值型数据
/// Output:
/// Return:转换后的num
/// Others:w ##class(dhc.pa.udata.uDataFormat).Num(20000)
ClassMethod Num(num) As %String
{
	n (num)
	
	s newNum="",newStr=""
	s tempNum=$P($fn(num,"",2),".",1)
	s Length=$L(tempNum)
	s count=0
	f k=Length:-1:1 d
	.s count=count+1
	.i (count/3)=$fn((count/3),"",0) d
	..i newStr'="" d
	...i k'=1 s newStr=","_$E(tempNum,k)_newStr
	...e  s newStr=$E(tempNum,k)_newStr
	..e  s newStr=$E(tempNum,k)
	.e  d
	..i newStr'="" s newStr=$E(tempNum,k)_newStr
	..e  s newStr=$E(tempNum,k)
	
	s newNum=newStr_"."_$P($fn(num,"",2),".",2)
	
	q newNum
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDataFormatS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
