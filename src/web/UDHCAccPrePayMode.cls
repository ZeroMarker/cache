Import SQLUser

Class web.UDHCAccPrePayMode Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
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
	&sql(DELETE FROM DHC_AccPrePayMode WHERE APPM_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	;i $d(ROW) d
	;.s ROW=$o(^DHCACD("AccM",+ParRef,"AccPD",ROW))
	;.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	;e  s SQLCODE=100
	;q SQLCODE
	;
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AccPrePayMode Values PLIST())
	d ..tc()
	s myRowID=%ROWID
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	;i '$d(^DHCACD("AccM",+ParRef,"AccPD")) s SQLCODE=100
	;e  s ROW="",SQLCODE=0
	;q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccPrePayMode WHERE APPM_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccPrePayMode VALUES PLIST() WHERE APPM_RowID= :RowId)
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
