Import sqluser

Class web.DHCBillExtTradePay Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_BillExtTradePay WHERE ETP_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT() As %String
{
	;s $zt="ERROR^DHCSSERR"
	;d ..tb()
	k PLIST(1)
	&sql(INSERT INTO DHC_BillExtTradePay VALUES PLIST())
	;d ..tc()
	s myRowID=%ROWID

	;i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE_"^"_myRowID
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillExtTradePay WHERE ETP_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_BillExtTradePay VALUES PLIST() WHERE ETP_RowID= :RowId)
	;d ..tc()
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
