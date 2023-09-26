Import SQLUser

Class web.UDHCJFPBODNoLock Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CLOSE()
{
	k ROW
	q 0
	;
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE %NOLOCK %NOCHECK FROM DHC_PatBillDetails WHERE PBD_RowId= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	i $d(ROW) d
	.s ROW=$o(^DHCPB(+ParRef,"O",$p(ParRef,"||",2),"D",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT %NOLOCK %NOCHECK INTO DHC_PatBillDetails Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ParRef)
{
	i '$d(^DHCPB(+ParRef,"O",$p(ParRef,"||",2),"D")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT %NOLOCK * INTO PLIST() FROM DHC_PatBillDetails WHERE PBD_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE %NOLOCK %NOCHECK DHC_PatBillDetails VALUES PLIST() WHERE PBD_RowId= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
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

}
