Class web.DHCBL.CT.UDHCJFTITMP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

ClassMethod CLOSE()
{
 k ROW
 q 0
}

ClassMethod OPEN(ParRef)
{
 s sub=0
 i '$d(^DHCTARI(ParRef,"P")) s SQLCODE=100
 e  s sub="",SQLCODE=0
 q SQLCODE
}

ClassMethod tb()
{
 n SQLCODE
 TSTART  s SQLCODE=$zu(34)
 q
}

ClassMethod tc()
{
 n SQLCODE
 i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 q
}

ClassMethod getpath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
 &sql(select pathtoreports into :path from websys.configuration)
 q path
}

ClassMethod geterr(bill)
{
 s ord="0"
 f  s ord=$o(^DHCPB(bill,"O",ord)) q:ord=""  d
 .s ordamt=$p(^DHCPB(bill,"O",ord),"^",8)
 .s arcim=$p(^DHCPB(bill,"O",ord),"^",3)
 .s arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
 .s ordamt=ordamt
 .s det="0"
 .s detamt=0
 .f  s det=$o(^DHCPB(bill,"O",ord,"D",det))  q:det=""  d
 ..s detamt=detamt+$p(^DHCPB(bill,"O",ord,"D",det),"^",7)
 .s detamt=detamt
 .i (ordamt'=detamt) d
 ..w !,arcimdesc_"^"_ordamt_"^"_detamt
}

ClassMethod getdatetime()
{
 s stdate="",sttime=""
 s stdate=$zd(+$h,3)
 s sttime=$zt($p($h,",",2),1)
 q stdate_"^"_sttime
}

}
