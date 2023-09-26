Class web.UHDCTeleTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod NewMethod1()
{
	;d ##class(web.UHDCTeleTest).NewMethod1()
	;d ##class(web.DHCTeleTransaction).Insert("", "TransactionType", "<RequestMsg>", "<ResponseMsg>", 1, "RecordType", "ErrorMsg")
	s myobj=##class(User.DHCTeleTransaction).%New()
	
	s myobj.ErrorMsg="ErrorMsg"
	
	d myobj.RequestMsg.Write("<RequestMsg>")
	;RecordType
	;TransactionDate
	;TransactionStatus
	;TransactionType
	
	d myobj.%Save()
	
	d myobj.%Close()
}

}
