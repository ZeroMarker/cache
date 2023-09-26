Import SQLUser

Class web.UDHCJFINVPRTZY Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_INVPRTZY WHERE PRT_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH()
{
	i $d(ROW) d
	.s ROW=$o(^DHCINVPRTZY(ROW))
	.s SQLCODE=..SELECT(ROW)
	e  s SQLCODE=100
	q SQLCODE
}

ClassMethod INSERT()
{
	k PLIST(1)
	
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVPRTZY Values PLIST())
	d ..tc()
	;
	s P1=$p($g(%ROWID),$c(1))
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN()
{
	;
	i '$d(^DHCINVPRTZY) s SQLCODE=100
	e  s ROW=$o(^DHCINVPRTZY(0)),SQLCODE=0
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVPRTZY WHERE PRT_RowId= :RowId) 
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
	&sql(UPDATE DHC_INVPRTZY VALUES PLIST() WHERE PRT_RowId= :RowId)
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
