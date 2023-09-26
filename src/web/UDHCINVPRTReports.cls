Import SQLUser

Class web.UDHCINVPRTReports Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 89;

/// w ##class(web.UDHCINVPRTReports).Insert()
ClassMethod Insert() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_INVPRTReports Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVPRTReports WHERE HIS_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	&sql(UPDATE DHC_INVPRTReports VALUES PLIST() WHERE HIS_Rowid= :RowId)
	d ..tc()
	;q SQLCODE
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod DELETE(RowId)
{
	set $ZT="ERROR^DHCSSERR"
	do ..tb()
	&SQL(DELETE FROM DHC_INVPRTReports WHERE HIS_Rowid = :RowId)
	do ..tc()
	quit SQLCODE
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
