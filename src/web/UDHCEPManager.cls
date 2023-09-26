Import SQLUser

Class web.UDHCEPManager Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod DELETE(RowId) As %String
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_EPManager WHERE EPM_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT() As %String
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_EPManager VALUES PLIST())
	d ..tc()
	s myRowID=%ROWID
	i SQLCODE=0 d ..SELECT(%ROWID)
	
	q SQLCODE
}

ClassMethod SELECT(RowId) As %String
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_EPManager WHERE EPM_RowID= :RowId)
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId) As %String
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_EPManager VALUES PLIST() WHERE EPM_RowID= :RowId)
	d ..tc()
	
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
