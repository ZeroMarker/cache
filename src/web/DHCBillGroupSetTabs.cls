Import SQLUser

/// 名称: web.DHCBillGroupSetTabs.cls
/// 描述: 
/// 编写者：ZhYW
/// 编写日期: 2018-03-08
Class web.DHCBillGroupSetTabs Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1264;

ClassMethod SELECT(RowID)
{
	kill PLIST
	&SQL(SELECT * INTO PLIST() FROM DHC_BillGroupSetTabs WHERE GT_RowID = :RowID) 
	set PLIST=$o(PLIST(""),-1)
	quit SQLCODE
}

ClassMethod DELETE(RowID)
{
	set $ZT="ERROR^DHCSSERR"
	do ..tb()
	&SQL(DELETE FROM DHC_BillGroupSetTabs WHERE GT_RowID = :RowID)
	do ..tc()
	quit SQLCODE
}

ClassMethod INSERT()
{
	kill PLIST(1)
	set $ZT="ERROR^DHCSSERR" 
	do ..tb()
	&SQL(INSERT INTO DHC_BillGroupSetTabs VALUES PLIST())
	do ..tc()
	set myRowID=%ROWID
	if 'SQLCODE do ..SELECT(myRowID)
	
	quit SQLCODE
}

ClassMethod UPDATE(RowID)
{
	set $ZT="ERROR^DHCSSERR"
	do ..tb()
	&SQL(UPDATE DHC_BillGroupSetTabs VALUES PLIST() WHERE GT_RowID = :RowID)
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
