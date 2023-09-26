Import SQLUser

Class web.DHCBillKPISetting Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SELECT(RowId)
{
	kill PLIST
	&SQL(SELECT * INTO PLIST() FROM DHC_BillKPISetting WHERE KPI_RowID = :RowId) 
	set PLIST=$o(PLIST(""),-1)
	quit SQLCODE
}

ClassMethod DELETE(RowId)
{
	set $ZT="ERROR^DHCSSERR" do ..tb()
	&SQL(DELETE FROM DHC_BillKPISetting WHERE KPI_RowID = :RowId)
	do ..tc()
	quit SQLCODE
}

ClassMethod INSERT()
{
	kill PLIST(1)
	set $ZT="ERROR^DHCSSERR" do ..tb()
	&SQL(INSERT INTO DHC_BillKPISetting VALUES PLIST())
	do ..tc()
	set myRowID=%ROWID
	if 'SQLCODE do ..SELECT(myRowID)
	
	quit SQLCODE
}

ClassMethod UPDATE(RowId)
{
	set $ZT="ERROR^DHCSSERR" do ..tb()
	&SQL(UPDATE DHC_BillKPISetting VALUES PLIST() WHERE KPI_RowID = :RowId)
	do ..tc()
	quit SQLCODE
}

ClassMethod tb()
{
	new SQLCODE
	TSTART  set SQLCODE=$zu(34)
	quit
}

ClassMethod tc()
{
	new SQLCODE
	TCOMMIT  set SQLCODE=$zu(34)
	quit
}

}
