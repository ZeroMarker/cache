Import sqluser

Class DHCBILL.Diet.DHCIPMealInvprt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO dhc_ipmealinvprt Values PLIST())
	d ..tc()
	q SQLCODE
}

ClassMethod DELETE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM dhc_ipmealinvprt WHERE dhcmi_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM dhc_ipmealinvprt WHERE dhcmi_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE dhc_ipmealinvprt VALUES PLIST() WHERE dhcmi_RowId= :RowId)
	d ..tc()
	;
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

}
