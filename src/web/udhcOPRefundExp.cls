Class web.udhcOPRefundExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetAPINVRowID(ReceipNO As %String) As %String
{
	n (ReceipNO)
	s ret=0
	
	;^DHCINVPRTAPi(0,"INVNo",{API_INVNo},{API_RowID})
	i $d(^DHCINVPRTAPi(0,"INVNo",ReceipNO))=0 s ret=-1    
	s myAPIRowID=""
	f  s myAPIRowID=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,myAPIRowID))  q:(myAPIRowID="")  d
	.s ret=myAPIRowID
	
	q ret
}

ClassMethod GetRepROWID(ReceipNO As %String)
{
	n (ReceipNO)
	
	s ret=0
	s ReceipNO=ReceipNO
	i $d(DHCINVPRT(0,"INV",ReceipNO))=0  s ret=-1
	s INVPRTRowid="0"
	f  s INVPRTRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,INVPRTRowid)) q:INVPRTRowid=""  d
	.s ret=INVPRTRowid
	
	q ret
}

/// w ##class(web.udhcOPRefundExp).GetRepROWIDBroker("","","053621020")
ClassMethod GetRepROWIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", ReceipNO As %String)
{
	s myTabFlag="PRT"
	s ret=..GetRepROWID(ReceipNO)
	i (+ret=-1) d
	.s ret=..GetAPINVRowID(ReceipNO)
	.s myTabFlag="API"
	
	s myrtn=ret_"^"_myTabFlag
	
	s retval=itmjs_"('"_$ZCVT(myrtn,"O","JS")_"');"
	&javascript<#(retval)#>
	q ret
}

/// w ##class(web.udhcOPRefundExp).GetRcptinfo("","","17","API")
ClassMethod GetRcptinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPRTRowid As %String, TabFlag As %String) As %String
{
	n (itmjs, itmjsex, INVPRTRowid, TabFlag)
	
	i (TabFlag="PRT") d
	.s ret=..ReadPRTByRowID(INVPRTRowid, "")
	e  d
	.s ret=..ReadAPINVByRowID(INVPRTRowid, "")
	
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	
	q 0
}

ClassMethod ReadAPINVByRowID(APIRowID As %String, ExpStr As %String) As %String
{
	n (APIRowID, ExpStr)
	;
	s myColPFlag=0
	s Refundflag=0
	
	s myAPIInfo=""
	
	;^DHCINVPRTAP({API_RowID})
	s flag=$p($g(^DHCINVPRTAP(APIRowID)),"^",2)
	s PRTAcount=$p($g(^DHCINVPRTAP(APIRowID)),"^",1)
	s PRTAcount=$fn(PRTAcount,"",2)
	s PRTPatPay=$p($g(^DHCINVPRTAP(APIRowID)),"^",13)
	s PRTPatPay=$fn(PRTPatPay,"",2)
	s PRTUsr=$p($g(^DHCINVPRTAP(APIRowID)),"^",5)
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PrtPapmiDR=$p($g(^DHCINVPRTAP(APIRowID)),"^",11)
	s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)
	s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	s myINSDivDR=$p($g(^DHCINVPRTAP(APIRowID)),"^",19)		;
	s myYBPaySum=+$p($g(^DHCINVPRTAP(APIRowID)),"^",17)		;
	
	s Verifyflag=""		;$p($g(^DHCINVPRTAP(INVPRTRowid)),"^",22)			;审批标志
	
	s DHCINVPRTRDR=$p($g(^DHCINVPRTAP(APIRowID)),"^",10)			;API_PayINV_DR
	s myINVPayMDR=""
	s myINVPMSub=$o(^DHCINVPRTAP(APIRowID,"P",0))
	i (myINVPMSub'="") d
	.s myINVPayMDR=$p($g(^DHCINVPRTAP(APIRowID,"P",myINVPMSub)),"^",1)
	.s myAccPLDR=""
	.s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	.i (myPayCode="CPP") d
	..s myAccRowID=+myAccPLDR
	..s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	..s myAccFlag=""			;$p(^DHCACD("AccM",myAccRowID),"^",13)
	..;如果是账户支付，判断是否能够退费；
	..;如果没有打印发票，必须在此退；
	..;N   P
	..;如果已经打印发票，不能退,必须到集中打印发票处退
	..s myPFlag="P"
	..s myINVNo=$p($g(^DHCINVPRTAP(APIRowID)),"^",6)		;API_INVNo
	..i ((myPFlag="P")&&(myINVNo="")) d
	...s myColPFlag=1		;已经集中打印了
	..q:(myAccFlag="N")		;账户正常退出，否则转为现金支付；
	..s myINVPayMDR=myCashPMDR
	
	;i $d(^DHCINVPRT(0,"INITID",INVPRTRowid))'=0  s Refundflag=1
	
	s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^^"
	s ret=ret_"^"_myINSDivDR
	s ret=ret_"^"_"^"_myYBPaySum
	
	s myAPIInfo=ret
	
	q myAPIInfo
}

ClassMethod ReadPRTByRowID(INVPRTRowid As %String, ExpStr As %String) As %String
{
	n (INVPRTRowid, ExpStr)
	
	s myPRTInfo=""
	
	s myColPFlag=0
	s Refundflag=0
	s DHCINVPRTRDR=""
	
	s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
	s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
	s PRTAcount=$fn(PRTAcount,"",2)
	s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
	s PRTPatPay=$fn(PRTPatPay,"",2)
	s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PrtPapmiDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",15)
	s PapmiNo=$p($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	s PapmiName=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	s PapmiSex=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",7)
	s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	s myINSDivDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",30)		;PRT_InsDiv_DR
	s myYBPaySum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",31)	;PRT_YBPaySum
	
	s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)			;审批标志
	;判断是否需要审批  医院基本配置表中   
	;myConAppFlag=1    不需要审批
	;myConAppFlag=0    需要审批，默认的值
	;myConAppFlag=2		需要审批到医嘱  需要在审批时，判断
	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	
	;审批转换到接口类中
	s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(INVPRTRowid, "")
	s Verifyflag=$p(myrtn,"^",1)
	s myMixOE=$p(myrtn,"^",2)				;混合医嘱标志
	;增加一个特殊限制标志   大同
	;此特殊标志，使界面的操作员退自己出的发票失效
	;=Y  表示失效
	;=N  或  ""  表示无效
	s mySpecLFalg=$p($g(myrtn),"^",4)
	
	s DHCINVPRTRDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",6)
	s myINVPayMDR=""
	s myINVPMSub=$o(^DHCINVPRT(INVPRTRowid,"P",0))
	i (myINVPMSub'="") d
	.s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
	.s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)		;IPM_AccPL_DR
	.s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	.i (myPayCode="CPP") d
	..s myAccRowID=+myAccPLDR
	..s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	..s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..;如果是账户支付，判断是否能够退费
	..;如果没有打印发票，必须在此退
	..;N   P
	..;如果已经打印发票，不能退,必须到集中打印发票处退
	..s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)		;PRT_INVPrintFlag
	..s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)		;PRT_inv
	..i ((myPFlag="P")&&(myINVNo="")) d
	...s myColPFlag=1		;已经集中打印了
	..q:(myAccFlag="N")		;账户正常退出，否则转为现金支付
	..s myINVPayMDR=myCashPMDR
	
	i $d(^DHCINVPRT(0,"INITID",INVPRTRowid))'=0  s Refundflag=1
	
	s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag_"^"_myMixOE
	s ret=ret_"^"_myINSDivDR
	s ret=ret_"^"_mySpecLFalg_"^"_myYBPaySum
	
	s myPRTInfo=ret
	
	q myPRTInfo
}

ClassMethod GetOrderRequestFlag(PrtID, Oeori)
{
	n (PrtID,Oeori)
	s rtn=""
	q:(PrtID="") rtn
	s sub=0
	f  s sub=$o(^DHCINVPRT(PrtID,"OA",sub)) q:((sub="")||(rtn="Y"))  d
	.s OEORI=$p(^DHCINVPRT(PrtID,"OA",sub),"^",1)
	.i (Oeori=OEORI) s rtn="Y"

	q rtn
}

}
