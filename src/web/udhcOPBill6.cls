Class web.udhcOPBill6 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod ReadParkSum(PRTRowID As %String = "") As %String
{
	;查询实际退款总额 
	;输入的是原发票的RowID
	;w ##class(web.udhcOPBill3).ReadParkSum("5980")
	n (PRTRowID)
	s mySum=0
	
	q:(PRTRowID="") 0
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid})
	;s myParkRowID=$o(^DHCINVPRT(0,"InitInvDR",PRTRowID,0))
	
	s myParkPatSum=-$p($g(^DHCINVPRT(PRTRowID)),"^",16)		;PRT_PatientShare
	s myParkYBSum=-$p($g(^DHCINVPRT(PRTRowID)),"^",31)		;PRT_YBPaySum
	s mySum=(myParkPatSum-myParkYBSum)
	
	s myOldRowID=$o(^DHCINVPRT(0,"OldINV",PRTRowID,0))
	
	i myOldRowID'="" d
	.s myOldPatSum=+$p($g(^DHCINVPRT(myOldRowID)),"^",16)		;PRT_PatientShare
	.s myOldYBSum=+$p($g(^DHCINVPRT(myOldRowID)),"^",31)		;PRT_YBPaySum
	.s mySum=+mySum+(myOldPatSum-myOldYBSum)
	
	s mySum=-mySum
	
	;查询费用中的,
	b
	s myOldRDSum=0
	i myOldRowID'="" d
	.s myOldRDSum=+$p($g(^DHCINVPRT(myOldRowID)),"^",37)	;PRT_OPCRoundErr
	
	s myRDSum=+$p($g(^DHCINVPRT(PRTRowID)),"^",37)	;PRT_OPCRoundErr
	
	s mySum=mySum-myOldRDSum+myRDSum
	
	s mySum=$fn(mySum,"",2)
	
	q mySum
}

}
