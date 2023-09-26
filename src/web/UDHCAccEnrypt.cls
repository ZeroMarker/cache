Class web.UDHCAccEnrypt Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

/// /w ##class(web.UDHCAccEnrypt).Decrypt("CBA@?>=DA:<;?;5899")
ClassMethod Encrypt(x As %String) As %String
{
	;w ##class(web.UDHCOPOtherLB).Encrypt("12345678V0")
	;"置换表”相类似，“变换数据位置”
	
	k mytmp
	;能够处理150字符
	f row=0:1:150  d
	.f col=0:1:150  d
	..s mytmp(row,col)=$zabs((+col-row))
	
	s myDec=""
	s myLen=$l(x)
	f i=1:1:myLen  d
	.;b
	.s mychar=$e(x,i,i)
	.s myAsc=+$a(mychar)+20
	.s myLocVal=mytmp(i,myAsc)
	.s myDec=myDec_$c(myLocVal)
		
	k mytmp
	
	q myDec
}

ClassMethod Decrypt(x As %String) As %String
{
	k mytmp
	;能够处理150字符
	;w ##class(web.UDHCOPOtherLB).Decrypt("DDDDDDDDD:")
	;w ##class(web.UDHCAccEnrypt).Decrypt("CBA@??>=A:=<=8:5<6")
	f row=0:1:150  d
	.f col=0:1:150  d
	..s mytmp(row,col)=$zabs((+col-row))
	
	s myEnc=""
	s myLen=$l(x)
	f row=1:1:myLen  d
	.s mychar=$e(x,row,row)
	.s myAsc=+$a(mychar)
	.i (row<75) d
	..s col=myAsc+row
	.e  d
	..s col=row-myAsc
	.s myLocVal=$c(col-20)
	.s myEnc=myEnc_myLocVal
	
	
	q myEnc
}

}
