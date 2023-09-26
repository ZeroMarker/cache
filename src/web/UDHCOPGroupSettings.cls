Import SQLUser

Class web.UDHCOPGroupSettings Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_OPGroupSettings WHERE GS_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	;##class(web.UDHCOPGroupSettings).INSERT()
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_OPGroupSettings Values PLIST())
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
	&sql(SELECT * INTO PLIST() FROM DHC_OPGroupSettings WHERE GS_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;##class(web.UDHCOPGroupSettings).UPDATE()
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_OPGroupSettings VALUES PLIST() WHERE GS_RowID= :RowId)
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
