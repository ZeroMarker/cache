Import SQLUser

Class web.UDHCEPPrePayMode Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_EPPrePayMode WHERE EPDPM_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_EPPrePayMode Values PLIST())
	d ..tc()
	s myRowID=%ROWID
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_EPPrePayMode WHERE EPDPM_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_EPPrePayMode VALUES PLIST() WHERE EPDPM_RowID= :RowId)
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
