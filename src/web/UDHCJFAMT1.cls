Import SQLUser

Class web.UDHCJFAMT1 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 15;

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_AMTMAG WHERE finac_rowid= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH()
{
	;
	i $d(ROW) d
	.s ROW=$o(^DHCFINAC(ROW))
	.s SQLCODE=..SELECT(ROW)
	e  s SQLCODE=100
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AMTMAG Values PLIST())
	d ..tc()
	;
	s P1=$P($g(%ROWID),$C(1))
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN()
{
	;
	i '$d(^DHCFINAC) s SQLCODE=100
	e  s ROW=0,SQLCODE=0
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AMTMAG WHERE finac_rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	s PLIST(1)=$P(PLIST(1),$C(1))
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AMTMAG VALUES PLIST() WHERE finac_rowid= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
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
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
