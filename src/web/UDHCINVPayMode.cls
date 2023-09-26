Import SQLUser

Class web.UDHCINVPayMode Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_INVPayMode WHERE IPM_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	i $d(ROW) d
	.s ROW=$o(^DHCINVPRT(+ParRef,"P",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVPayMode VALUES PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	i '$d(^DHCINVPRT(+ParRef,"P")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVPayMode WHERE IPM_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVPayMode VALUES PLIST() WHERE IPM_RowID= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
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
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
