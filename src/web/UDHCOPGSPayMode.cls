Import SQLUser

Class web.UDHCOPGSPayMode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 25;

ClassMethod CLOSE()
{
	k ROW
	q 0
	;
}

ClassMethod DELETE(RowId)
{
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_OPGSPayMode WHERE PM_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCOPGS("GS",{DHC_OPGroupSettings.GS_RowID},"PM",{PM_Sub})
	i $d(ROW) d
	.;s ROW=$o(^DHCPB(+ParRef,"O",$p(ParRef,"||",2),"D",ROW))
	.s ROW=$o(^DHCOPGS("GS",+ParRef,"PM",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	;##class(web.UDHCOPGSPayMode).INSERT
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_OPGSPayMode Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCOPGS("GS",{DHC_OPGroupSettings.GS_RowID},"PM",{PM_Sub})
	if '$d(^DHCOPGS("GS",+ParRef,"PM"))  s SQLCODE=100
	;i '$d(^DHCPB(+ParRef,"O",$p(ParRef,"||",2),"D")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_OPGSPayMode WHERE PM_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;##class(web.UDHCOPGSPayMode).UPDATE()
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_OPGSPayMode VALUES PLIST() WHERE PM_RowID= :RowId)
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
