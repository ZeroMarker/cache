Import SQLUser

Class web.UDHCINVPRTReportsSub Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 41;

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_INVPRTReportsSub WHERE HisSub_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod Insert() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_INVPRTReportsSub Values PLIST())
	;;b
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE		;;$$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVPRTReportsSub WHERE HisSub_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVPRTReportsSub VALUES PLIST() WHERE HisSub_RowId= :RowId)
	d ..tc()
	;q SQLCODE
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE			; $$code^SSUTILSQ(SQLCODE)
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
