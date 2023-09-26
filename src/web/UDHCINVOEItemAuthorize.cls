Import SQLUser

Class web.UDHCINVOEItemAuthorize Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	&sql(DELETE FROM DHC_INVOEItemAuthorize WHERE IOA_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"OA",{IPM_Sub})
	i $d(ROW) d
	.s ROW=$o(^DHCINVPRT(+ParRef,"OA",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVOEItemAuthorize Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE
	
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"OA",{IPM_Sub})
	i '$d(^DHCINVPRT(+ParRef,"OA")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVOEItemAuthorize WHERE IOA_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVOEItemAuthorize VALUES PLIST() WHERE IOA_RowID= :RowId)
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
