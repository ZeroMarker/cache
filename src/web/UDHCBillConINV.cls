Import SQLUser

Class web.UDHCBillConINV Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_BillConINV WHERE DHCBCI_Rowid= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_BillConINV Values PLIST())
	d ..tc()
	;
	s myRowID=%ROWID
	i 'SQLCODE d ..SELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillConINV WHERE DHCBCI_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_BillConINV VALUES PLIST() WHERE DHCBCI_Rowid= :RowId)
	d ..tc()
	q SQLCODE
	;
	;i 'SQLCODE q ..SELECT(%ROWID)
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
