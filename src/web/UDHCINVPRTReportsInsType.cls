Import SQLUser

Class web.UDHCINVPRTReportsInsType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 42;

ClassMethod Insert() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_INVPRTReportsInsType Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE		;$$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVPRTReportsInsType WHERE ITC_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVPRTReportsInsType VALUES PLIST() WHERE ITC_RowID= :RowId)
	d ..tc()
	;
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE	;$$code^SSUTILSQ(SQLCODE)
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
