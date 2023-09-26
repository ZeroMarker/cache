Import SQLUser

Class web.UDHCJFTITMP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_TarItemPrice WHERE TP_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH(ParRef)
{
	k PLIST
	s sub=$o(^DHCTARI(ParRef,"P",sub)) 
	i $g(sub)="" s SQLCODE=100 
	i ($g(sub)'="") d
	  .i ($g(sub)'="0") d
	  ..s ROW=ParRef_"||"_sub
	  ..s SQLCODE=..SELECT(ROW)
	e  s SQLCODE=100
	q SQLCODE
}

ClassMethod OPEN(ParRef)
{
 ;ParRef->DHC_TarItem
	;
	s sub=0
	i '$d(^DHCTARI(ParRef,"P")) s SQLCODE=100
	e  s sub="",SQLCODE=0
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_TarItemPrice WHERE TP_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	s PLIST(1)=$P(PLIST(1),$C(1))
	s PLIST(2)=$P(PLIST(2),$C(1))
	i $p(PLIST(3),$C(1))'="" s PLIST(3)=$zd(+PLIST(3),3)
	i $p(PLIST(4),$C(1))'="" s PLIST(4)=$zd(+PLIST(4),3)
	s PLIST(3)=$P(PLIST(3),$C(1))
	s PLIST(4)=$P(PLIST(4),$C(1))
	s PLIST(5)=$P(PLIST(5),$C(1))
	s PLIST(6)=$P(PLIST(6),$C(1))
	s PLIST(7)=$P(PLIST(7),$C(1))
	s PLIST(8)=$P(PLIST(8),$C(1))
	s PLIST(9)=$P(PLIST(9),$C(1))
	s PLIST(10)=$P(PLIST(10),$C(1))
	s PLIST(11)=$P(PLIST(11),$C(1))
	s PLIST(12)=$P(PLIST(12),$C(1))
	s PLIST(13)=$P(PLIST(13),$C(1))
	s PLIST(14)=$P(PLIST(14),$C(1))
	s PLIST(15)=$P(PLIST(15),$C(1))
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	k PLIST(1)
	i PLIST(5)'="" s PLIST(5)=+PLIST(5)
	i PLIST(6)'="" s PLIST(6)=+PLIST(6)
	i PLIST(7)'="" s PLIST(7)=+PLIST(7)
	i PLIST(12)'="" s PLIST(12)=+PLIST(12)
	i PLIST(14)'="" s PLIST(14)=+PLIST(14)
	i PLIST(15)'="" s PLIST(15)=+PLIST(15)
	s PLIST(9)=+$H
	s PLIST(10)=$P($H,",",2)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_TarItemPrice VALUES PLIST() WHERE TP_RowId= :RowId)
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
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
	s stdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s sttime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2),1)
	q stdate_"^"_sttime
}

}
