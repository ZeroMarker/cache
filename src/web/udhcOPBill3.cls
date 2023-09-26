Class web.udhcOPBill3 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

ClassMethod ReadParkSumOLD(PRTRowID As %String = "") As %String
{
	;查询实际退款总额  
	;w ##class(web.udhcOPBill3).ReadParkSum("5980")
	n (PRTRowID)
	s mySum=0
	
	q:(PRTRowID="") 0
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid})
	;s myParkRowID=$o(^DHCINVPRT(0,"InitInvDR",PRTRowID,0))
	s StrikRowID=$o(^DHCINVPRT(0,"InitInvDR",PRTRowID,""))
	i StrikRowID'="" d
	.s myParkPatSum=$p($g(^DHCINVPRT(StrikRowID)),"^",16)		;PRT_PatientShare
	.s myParkYBSum=$p($g(^DHCINVPRT(StrikRowID)),"^",31)		;PRT_YBPaySum
	.s mySum=(myParkPatSum-myParkYBSum)

	s myOldRowID=$o(^DHCINVPRT(0,"OldINV",PRTRowID,0))
	
	i myOldRowID'="" d
	.s myOldPatSum=+$p($g(^DHCINVPRT(myOldRowID)),"^",16)		;PRT_PatientShare
	.s myOldYBSum=+$p($g(^DHCINVPRT(myOldRowID)),"^",31)		;PRT_YBPaySum
	.s mySum=+mySum+(myOldPatSum-myOldYBSum)
	s mySum=-mySum
	s mySum=$fn(mySum,"",2)
	
	q mySum
}

ClassMethod ReadParkSum(PRTRowID As %String = "") As %String
{
	;查询实际退款总额  
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
	
	s mySum=$fn(mySum,"",2)
	
	q mySum
}

/// add hujunbin 14.12.5
ClassMethod ReadAPIParkSum(PRTRowID As %String = "") As %String
{
	;查询实际退款总额  
	;w ##class(web.udhcOPBill3).ReadAPIParkSum("26558")
	n (PRTRowID)
	s mySum=0
	
	q:(PRTRowID="") 0
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid})
	;s myParkRowID=$o(^DHCINVPRT(0,"InitInvDR",PRTRowID,0))
	
	s myParkPatSum=-$p($g(^DHCINVPRTAP(PRTRowID)),"^",13)		;PRT_PatientShare
	s myParkYBSum=-$p($g(^DHCINVPRTAP(PRTRowID)),"^",17)		;PRT_YBPaySum
	s mySum=(myParkPatSum-myParkYBSum)
	b ;b00
	s myOldRowID=$o(^DHCINVPRTAPi(0,"OldADR",PRTRowID,0))
	
	i myOldRowID'="" d
	.s myOldPatSum=+$p($g(^DHCINVPRTAP(myOldRowID)),"^",13)		;PRT_PatientShare
	.s myOldYBSum=+$p($g(^DHCINVPRTAP(myOldRowID)),"^",17)		;PRT_YBPaySum
	.s mySum=+mySum+(myOldPatSum-myOldYBSum)
	
	s mySum=-mySum
	
	;查询费用中的,
	
	s mySum=$fn(mySum,"",2)
	
	q mySum
}

}
