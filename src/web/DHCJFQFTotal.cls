Import SQLUser

Class web.DHCJFQFTotal Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_JFQFTotal WHERE QF_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_JFQFTotal Values PLIST())
	d ..tc()
	;
	s myRowID=%ROWID
	i 'SQLCODE d ..SELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_JFQFTotal WHERE QF_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_JFQFTotal VALUES PLIST() WHERE QF_RowId= :RowId)
	d ..tc()
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
