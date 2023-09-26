Import SQLUser

Class web.UDHCAccMConGroup Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

ClassMethod DELETE(RowId) As %String
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_AccMConGroup WHERE AMCG_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT() As %String
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AccMConGroup Values PLIST())
	d ..tc()
	
	i SQLCODE=0 d ..SELECT(%ROWID)
	;
	s myRowID=%ROWID
	q SQLCODE
}

ClassMethod SELECT(RowId) As %String
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccMConGroup WHERE AMCG_RowID= :RowId)
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId) As %String
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccMConGroup VALUES PLIST() WHERE AMCG_RowID= :RowId)
	d ..tc()
	
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE
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
