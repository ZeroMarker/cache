Import SQLUser

Class web.UDHCAccPFootSub Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod CLOSE()
{
	k ROW
	q 0
	;
}

ClassMethod DELETE(RowId)
{
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_AccPFootSub WHERE AccPFS_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCACD("AccPF",{DHC_AccPFoot.AccPF_RowID},"PF",{AccPFS_Sub})
	i $d(ROW) d
	.s ROW=$o(^DHCACD("AccPF",+ParRef,"PF",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AccPFootSub Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCACD("AccPF",{DHC_AccPFoot.AccPF_RowID},"PF",{AccPFS_Sub})
	i '$d(^DHCACD("AccPF",+ParRef,"PF")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccPFootSub WHERE AccPFS_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccPFootSub VALUES PLIST() WHERE AccPFS_RowID= :RowId)
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
