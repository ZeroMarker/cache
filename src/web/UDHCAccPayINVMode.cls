Import SQLUser

Class web.UDHCAccPayINVMode Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

ClassMethod CLOSE()
{
	k ROW
	q 0
	;
}

ClassMethod DELETE(RowId)
{
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_AccPayINVMode WHERE APM_RowID= :RowId)
	d ..tc()
	q SQLCODE
	;
}

ClassMethod FETCH(ParRef)
{
	;^DHCACD("AccPF",{DHC_AccPFoot.AccPF_RowID},"PF",{AccPFS_Sub})
	;^DHCINVPRTAP({DHC_AccPayINV.API_RowID},"P",{APM_Sub})
	i $d(ROW) d
	.s ROW=$o(^DHCINVPRTAP(+ParRef,"P",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
	;
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AccPayINVMode Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE
	;
}

ClassMethod OPEN(ParRef)
{
	;^DHCACD("AccPF",{DHC_AccPFoot.AccPF_RowID},"PF",{AccPFS_Sub})
	i '$d(^DHCINVPRTAP(+ParRef,"P")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccPayINVMode WHERE APM_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccPayINVMode VALUES PLIST() WHERE APM_RowID= :RowId)
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
