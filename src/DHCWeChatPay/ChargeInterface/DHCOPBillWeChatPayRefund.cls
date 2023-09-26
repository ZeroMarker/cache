Import SQLUser

/// wangjian
/// 2014-12-25
/// 微信在线退费业务类
Class DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// wangjian
/// 2014-07-07
/// 微信退费列表推送
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund).GetRefundList("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>71066</patientId><admId>1252405</admId><userCode>wechatpay001</userCode></Request>")
ClassMethod GetRefundList(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="WeChatPayGetRefundListET"
	Set ^DHCBillWeChatPay("GetRefundList",+$h,$p($h,",",2),"Input")=Input
	New (Input)
	b ;;;
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCWeChatPay.DHCEntity.PCA.WeChatPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Do inputObj.%Close()
    Set RefundListObj=##class(DHCWeChatPay.DHCEntity.PCA.RefundList).%New()
    Set OutputXML=""  
    If (AdmInfo=""){
		Set RefundListObj.ResultCode=-1
		Set RefundListObj.ErrorMsg="就诊不存在"
		Do RefundListObj.XMLExportToString(.OutputXML,"Response")
		Do RefundListObj.%Close()
	}
	Quit:(AdmInfo="") OutputXML
	B ;;;;;
  	Set BCIDr=0 ,ListNum=0
  	For  Set BCIDr=$o(^DHCBCI(0,"ADM",AdmInfo,BCIDr)) Quit:BCIDr=""  Do
	.Set InvDr=$p($g(^DHCBCI(BCIDr)),"^",1)
	.Quit:InvDr=""
	.Set PrtFairType=$p($g(^DHCINVPRT(InvDr)),"^",34)
	.Quit:PrtFairType'="F"
	.Set PrtINVPrintFlag=$p($g(^DHCINVPRT(InvDr)),"^",3)
	.Quit:PrtINVPrintFlag="P"	;过滤打印过发票的记录
	.Set PrtFlag=$p($g(^DHCINVPRT(InvDr)),"^",8)
	.Quit:PrtFlag'="N"
	.Set PrtAllowRef=$p($g(^DHCINVPRT(InvDr)),"^",22)
	.Quit:PrtAllowRef'="Y"
	.Set WeChatFlag=##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).CheckPayMByPrtRowID(InvDr,"")
	.Quit:+WeChatFlag=0
	.Set AmtSum=$p($g(^DHCINVPRT(InvDr)),"^",1)
	.Set RefReason=$p($g(^DHCINVPRT(InvDr)),"^",32)
	.Set RefSum=..GetRefundAmt(InvDr)
	.If $d(^DHCINVALITPi(0,"S","IPDR",InvDr))'=0 d
	..Set Rowid=$o(^DHCINVALITPi(0,"S","IPDR",InvDr,""))
	..Set Rc=$p(^DHCINVALITP(Rowid),"^",1)
	..If ((Rc="0000")!(Rc="00")) d
	...Set ListNum=ListNum+1
	...Set HISTradeNo=$p(^DHCINVALITP(Rowid),"^",32)
	...Set Tradeno=$p(^DHCINVALITP(Rowid),"^",7)
	...Set RefListObj=##class(DHCWeChatPay.DHCEntity.PCA.RefList).%New()
	...Set RefListObj.WeChatTradeNo=Tradeno
	...Set RefListObj.HisTradeNo=HISTradeNo
	...Set RefListObj.PrtInvID=InvDr
	...Set RefListObj.AmtSum=$fn(AmtSum,"",2)
	...Set RefListObj.RefReason=RefReason
	...Set RefListObj.RefAmtSum=$fn(RefSum,"",2)
	...Do RefundListObj.RefLists.Insert(RefListObj)
	...Do RefListObj.%Close()
  
	If (+ListNum=0) {
		Set RefundListObj.ResultCode=-2
		Set RefundListObj.ErrorMsg="无可退费记录"
		Do RefundListObj.XMLExportToString(.OutputXML,"Response")
		Do RefundListObj.%Close()
	}
	Quit:(+ListNum=0) OutputXML
  
	Set RefundListObj.ResultCode=0
	Set RefundListObj.ErrorMsg="获取退费列表成功."
	Do RefundListObj.XMLExportToString(.OutputXML,"Response")
	Do RefundListObj.%Close()
	Quit OutputXML
	
WeChatPayGetRefundListET
   	Set RefundListObj=##class(DHCWeChatPay.DHCEntity.PCA.RefundList).%New()
   	Set RefundListObj.ResultCode=-10
   	Set RefundListObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do RefundListObj.XMLExportToString(.OutputXML,"Response")
   	Do RefundListObj.%Close()
	Quit OutputXML
}

/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund).GetRefundAmt()
ClassMethod GetRefundAmt(PrtRowid)
{
	New (PrtRowid)
	Set RefSum=0
	Set Row=0,RecordCount=0
	Set rs=##Class(%ResultSet).%New("web.udhcOPRefund:GetOrderbyReceipID")
		If rs.QueryIsValid() { 
			Set Status=rs.Execute(PrtRowid,"")
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				Set myRefSum=rs.GetDataByName("RefSum")
				Set AuditSelFlag=rs.GetDataByName("AuditSelFlag")
				If (+AuditSelFlag=1) {
				Set RefSum=RefSum+myRefSum
				}
				Set RecordCount=RecordCount+1
				}
		}
	Quit RefSum
}

/// wangjian
/// 2014-07-07
/// 微信退费明细推送
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund).GetRefundDetail("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>71066</patientId><admId>1252405</admId><userCode>wechatpay001</userCode></Request>")
ClassMethod GetRefundDetail(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="WeChatPayGetRefundDetailET"
	Set ^DHCBillWeChatPay("GetRefundDetail",+$h,$p($h,",",2),"Input")=Input
	New (Input)
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCWeChatPay.DHCEntity.PCA.WeChatPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set InvInfo=inputObj.InvInfo
    Do inputObj.%Close()
    Set RefundDetailObj=##class(DHCWeChatPay.DHCEntity.PCA.RefundDetail).%New()
    Set OutputXML=""  
    If (InvInfo=""){
		Set RefundDetailObj.ResultCode=-1
		Set RefundDetailObj.ErrorMsg="交易不存在"
		Do RefundDetailObj.XMLExportToString(.OutputXML,"Response")
		Do RefundDetailObj.%Close()
	}
	Quit:(InvInfo="") OutputXML
	
	Set Row=0,RecordCount=0
	Set rs=##Class(%ResultSet).%New("web.udhcOPRefund:GetOrderbyReceipID")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(InvInfo,"")
		Set columns = rs.GetColumnCount()
		;b ;Status
		;If 'Status Quit
		While rs.Next() {
			Set Row=Row+1
			Set AuditSelFlag=rs.GetDataByName("AuditSelFlag")
			If (+AuditSelFlag=1) {
				Set RefDetailObj=##Class(DHCWeChatPay.DHCEntity.PCA.RefDetail).%New()
				Set RefDetailObj.ArcimDesc=rs.GetDataByName("TOrder")
				Set RefDetailObj.PatSum=rs.GetDataByName("TOrderSum")
				Set RefDetailObj.OrderBillQty=rs.GetDataByName("TOrderQty")
				Set RefDetailObj.RecDepDesc=rs.GetDataByName("TRecloc")
				Set RefDetailObj.RefSum=rs.GetDataByName("RefSum")
				Set RefDetailObj.ReturnQty=rs.GetDataByName("TReturnQty")
				Do RefundDetailObj.RefDetails.Insert(RefDetailObj)
				Do RefDetailObj.%Close()
				Set RecordCount=RecordCount+1
			}
		}
	}
	If (+RecordCount=0) {
		Set RefundDetailObj.ResultCode=-2
		Set RefundDetailObj.ErrorMsg="无记录"
		Do RefundDetailObj.XMLExportToString(.OutputXML,"Response")
		Do RefundDetailObj.%Close()
	}
	Quit:(+RecordCount=0) OutputXML
 		
	Set RefundDetailObj.ResultCode=0
	Set RefundDetailObj.ErrorMsg="获取退费列表成功."
	Do RefundDetailObj.XMLExportToString(.OutputXML,"Response")
	Do RefundDetailObj.%Close()
	Quit OutputXML
 		
 		
 		
 		
WeChatPayGetRefundDetailET
   	Set RefundDetailObj=##class(DHCWeChatPay.DHCEntity.PCA.RefundDetail).%New()
   	Set RefundDetailObj.ResultCode=-10
   	Set RefundDetailObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do RefundDetailObj.XMLExportToString(.OutputXML,"Response")
   	Do RefundDetailObj.%Close()
	Quit OutputXML
}

/// wangjian
/// 2014-07-07
/// 微信在线退费
/// w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund).RefundByWeChat("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>71066</patientId><admId>1252405</admId><userCode>wechatpay001</userCode></Request>")
ClassMethod RefundByWeChat(Input As %String) As %GlobalCharacterStream
{
	;Set $ZT="WeChatPayRefundByWeChatET"
	Set ^DHCBillWeChatPay("RefundByWeChat",+$h,$p($h,",",2),"Input")=Input
	New (Input)
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCWeChatPay.DHCEntity.PCA.WeChatPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set InvInfo=inputObj.InvInfo
    Do inputObj.%Close()
    Set RefundResultObj=##class(DHCWeChatPay.DHCEntity.PCA.WeChatRefundResult).%New()
    Set OutputXML=""  
    If (InvInfo=""){
		Set RefundResultObj.ResultCode=-1
		Set RefundResultObj.ErrorMsg="交易不存在"
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(InvInfo="") OutputXML
	
	Set PrtINVPrintFlag=$p($g(^DHCINVPRT(InvInfo)),"^",3)
	If (PrtINVPrintFlag="P"){
		Set RefundResultObj.ResultCode=-3
		Set RefundResultObj.ErrorMsg="已打印发票请到窗口退费"
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(PrtINVPrintFlag="P") OutputXML
	
  	Set PrtFlag=$p($g(^DHCINVPRT(InvInfo)),"^",8)
  	If (PrtFlag'="N") {
		Set RefundResultObj.ResultCode=-4
		Set RefundResultObj.ErrorMsg="此条记录已经退费"
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(PrtFlag'="N") OutputXML
	  
  	Set PrtAllowRef=$p($g(^DHCINVPRT(InvInfo)),"^",22)
  	If (PrtAllowRef'="Y"){
		Set RefundResultObj.ResultCode=-5
		Set RefundResultObj.ErrorMsg="已经撤销退费审核,不能退费"
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(PrtAllowRef'="Y") OutputXML
	
	Set Rcptinfo=..GetRcptinfo(InvInfo)
	
	If (Rcptinfo=""){
		Set RefundResultObj.ResultCode=-6
		Set RefundResultObj.ErrorMsg="获取发票信息失败"
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(Rcptinfo="") OutputXML
	
	If UserCode="" Set UserCode="wechatpay001"
	Set UserCode="wechatpay001"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set RecLoc=""
	If Grup'=""  d
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gLoc)
	If HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区
	If (($p(Rcptinfo,"^",7)=Userid)&&($p(Rcptinfo,"^",8)="")){
		Set RefundFlag="A"
	}Else{
		Set RefundFlag="S"
		}
	Set RefSum=0 ;退费金额
	Set InvSum=$p(Rcptinfo,"^",19)
	Set Orderstr=""
	;Orderstr
	Set Row=0,RecordCount=0
	Set rs=##Class(%ResultSet).%New("web.udhcOPRefund:GetOrderbyReceipID")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(InvInfo,"")
		Set columns = rs.GetColumnCount()
		;b ;Status
		;If 'Status Quit
		While rs.Next() {
			Set Row=Row+1
			Set AuditSelFlag=rs.GetDataByName("AuditSelFlag")
			Set myRefSum=rs.GetDataByName("RefSum")
			Set OrderRowid=rs.GetDataByName("TOrderRowid")
			If (+AuditSelFlag=1) {
				Set RefSum=RefSum+myRefSum
				If Orderstr="" set Orderstr=OrderRowid
				Else  Set Orderstr=Orderstr_"^"_OrderRowid
			}Else {
				}
		}
	}
	If (+RefSum=+InvSum){
		Set RebillFlag="0"		
	}Else {
		Set RebillFlag="1"
		}
	Set PatPay=InvSum-RefSum
	Set Paymode=$o(^CT("CTPM",0,"Code","WECHATPAY",""))
    Set myPayinfo=Paymode_"^^^^"
	b ;strart
	
	Set rtn=##class(web.udhcOPRefBroker).RefundReceipt(InvInfo,Userid,RefundFlag,Orderstr,PatPay,Grup,RebillFlag,gLoc,Paymode,"^^^^^")
	b ;rtn
	If (+rtn'=0){
		Set RefundResultObj.ResultCode=-2
		Set RefundResultObj.ErrorMsg="His退费失败"_rtn
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:(+rtn'=0) OutputXML
	
	Set myPRTRowID=$p(rtn,"^",2)
	Set StrikeRowID=$p(rtn,"^",3)
	;微信端申请退费
	Set ExpStr=gLoc_"^"_Grup_"^"_HospitalId_"^^^"_Userid_"^线上退费"
	b ;b ;strart1
	Set wechatrtn=##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).WeChatPay("OP",myPRTRowID,StrikeRowID,"","D",ExpStr)
	b ;wechatrtn
	If ((+wechatrtn'=0)&&(+wechatrtn'=-1)){
		Set RefundResultObj.ResultCode=-2.1
		Set RefundResultObj.ErrorMsg="微信端退费请求失败,His退费成功"_wechatrtn
		Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
		Do RefundResultObj.%Close()
	}
	Quit:((+wechatrtn'=0)&&(+wechatrtn'=-1)) OutputXML
		
	Set RefundResultObj.ResultCode=0
	Set RefundResultObj.ErrorMsg="退费成功."
	Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
	Do RefundResultObj.%Close()
	Quit OutputXML	
WeChatPayRefundByWeChatET
	Set RefundResultObj=##class(DHCWeChatPay.DHCEntity.PCA.WeChatRefundResult).%New()
   	Set RefundResultObj.ResultCode=-10
   	Set RefundResultObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do RefundResultObj.XMLExportToString(.OutputXML,"Response")
   	Do RefundResultObj.%Close()
	Quit OutputXML
}

ClassMethod GetRcptinfo(INVPRTRowid As %String) As %String
{
	;获取发票信息 DHC_INPVRT表的信息
	;所有的发票都需要审批,可以出现假审批,当时只有=Y  时才能退费
	;。。。。。。
	;w ##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayRefund).GetRcptinfo("19736146")
	s myColPFlag=0
	s Refundflag=0
	s DHCINVPRTRDR=""
	
	s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
	s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
	s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
	s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
	q:PRTUsr=""
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PrtPapmiDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",15)
	s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)
	s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	;s myINSDivDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",30)		;PRT_InsDiv_DR
	
	//Lid 2014-07-11 微信/微信支付上线后，医保指针根据业务不同，会存到两个地方
	//dhc_invprt -> PRT_InsDiv_DR
	//dhc_invprtinsu -> PrtInsu_InsDiv_DR
	;s myINSDivDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",30)		;PRT_InsDiv_DR
	s myINSDivDR=##class(web.UDHCJFBaseCommon).GetInsDivDRByPrtRowID(INVPRTRowid)
	
	s myYBPaySum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",31)	;PRT_YBPaySum
	s myOPRoundSum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",37)	;PRT_OPCRoundErr
	s myINSTypeDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",9)		;PRT_InsType_DR
	
	s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)			;审批标志
	;判断是否需要审批  医院基本配置表中   
	;myConAppFlag=1    不需要审批
	;myConAppFlag=0    需要审批，默认的值
	;myConAppFlag=2		需要审批到医嘱  需要在审批时，判断
	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	;i +myConAppFlag=1 d
	;.s Verifyflag="Y"
	
	;审批转换到接口类中
	s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(INVPRTRowid,"")
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
	i myINVPMSub'="" d
	.s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
	.s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)		;IPM_AccPL_DR
	.s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	.i myPayCode="CPP" d
	..s myAccRowID=+myAccPLDR
	..s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	..s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..;如果是账户支付，判断是否能够退费；
	..;如果没有打印发票，必须在此退；
	..;N   P
	..;如果已经打印发票，不能退,必须到集中打印发票处退
	..s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)		;PRT_INVPrintFlag
	..s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)		;PRT_inv
	..i ((myPFlag="P")&&(myINVNo="")) d
	...s myColPFlag=1		;已经集中打印了
	..q:(myAccFlag="N")		;账户正常退出，否则转为现金支付；
	..s myINVPayMDR=myCashPMDR
	..
	
	i $d(^DHCINVPRT(0,"INITID",INVPRTRowid))'=0  s Refundflag=1
	
	s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag_"^"_myMixOE
	s ret=ret_"^"_myINSDivDR
	s ret=ret_"^"_mySpecLFalg_"^"_myYBPaySum
	s ret=ret_"^"_myOPRoundSum
	s ret=ret_"^"_myINSTypeDR_"^"_PRTAcount
	
	q ret
}

}
