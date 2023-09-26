Import SQLUser

Class web.UDHCJFINV Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId, endno)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AMTMAG set finac_avail='Y' WHERE finac_ednum=:endno)
	&sql(DELETE FROM DHC_INVOICE WHERE INV_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH()
{
	;
	i $d(ROW) d
	.s ROW=$o(^DHCINVOICE(ROW))
	.s SQLCODE=..SELECT(ROW)
	e  s SQLCODE=100
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVOICE Values PLIST())
	d ..tc()
	;
	s P1=$P($g(%ROWID),$C(1))
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN()
{
	i '$d(^DHCINVOICE) s SQLCODE=100
	e  s ROW=0,SQLCODE=0
	q SQLCODE
	;
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVOICE WHERE INV_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	s PLIST(1)=$P(PLIST(1),$C(1))
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVOICE VALUES PLIST() WHERE INV_RowId= :RowId)
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
