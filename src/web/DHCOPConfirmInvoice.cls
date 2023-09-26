/// author：wanghuicai
/// date：  2009-4-14
/// 描述：  对表DHC_ConfirmInvoice的增删改查的基础操作,用来被web.DHCOPConfirmInvoiceManage类调用
Class web.DHCOPConfirmInvoice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM SQLUser.DHC_ConfirmInvoice WHERE Confirm_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO SQLUser.DHC_ConfirmInvoice Values PLIST())
	d ..tc()
	;
	;s myRowID=%ROWID
	;i 'SQLCODE d ..SELECT(myRowID)
	
	q SQLCODE  ;_"^"_myRowID
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM SQLUser.DHC_ConfirmInvoice WHERE Confirm_RowID= :RowId) 
	;s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE SQLUser.DHC_ConfirmInvoice VALUES PLIST() WHERE Confirm_RowID= :RowId)
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
