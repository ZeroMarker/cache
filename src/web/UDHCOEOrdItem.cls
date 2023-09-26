Import SQLUser

Class web.UDHCOEOrdItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 19;

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_OE_OrdItem WHERE DHCORI_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_OE_OrdItem Values PLIST())
	d ..tc()
	;
	s myRowID=%ROWID
	i 'SQLCODE d ..SELECT(myRowID)
	
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_OE_OrdItem WHERE DHCORI_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_OE_OrdItem VALUES PLIST() WHERE DHCORI_RowId= :RowId)
	d ..tc()
	q SQLCODE
	;
	;i 'SQLCODE q ..SELECT(%ROWID)
	;q $$code^SSUTILSQ(SQLCODE)
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
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
