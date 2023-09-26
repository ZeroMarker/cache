Import SQLUser

Class web.UDHCSOPADMReasonExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 4;

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_SOPADMReasonExp WHERE SARE_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	;##class(web.UDHCSOPADMReasonExp).INSERT()
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_SOPADMReasonExp Values PLIST())
	d ..tc()
	;
	i SQLCODE=0 d ..SELECT(%ROWID)
	
	s myRowID=%ROWID
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	;##class(web.UDHCOPGroupSettings).SELECT("")
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_SOPADMReasonExp WHERE SARE_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;##class(web.UDHCOPGroupSettings).UPDATE()
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_SOPADMReasonExp VALUES PLIST() WHERE SARE_RowID= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE
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
