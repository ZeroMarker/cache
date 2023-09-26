Import SQLUser

Class DHCBILL.SelfPay.BLL.DHCBillCommon Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2018-03-22
/// Description: 网络测试接口
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).DHCNetTest("<Request><TradeCode>1000</TradeCode></Request>")
ClassMethod DHCNetTest(Input As %String) As %GlobalBinaryStream
{
	set Rtn="<Response><ResultCode>0</ResultCode><ResultMsg>网络连接成功</ResultMsg></Response>"
	set OutXML=##class(%Stream.GlobalCharacter).%New()
	do OutXML.Write(Rtn)
	quit OutXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号或者登记号获取患者系统中通用消息
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo("","","","0000000262")
ClassMethod GetPatCommInfo(CardNo As %String, CardType As %String, SecrityNo As %String, PatNo As %String) As %String
{
	set Rtn="^^^^"
	if (CardNo'="") {
		set ExpStr=$c(2)_CardType_$c(2)_$s((SecrityNo=""):"PatInfo",1:"")
		set Rtn=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo, SecrityNo, ExpStr)
		quit Rtn
	}
	
	if (PatNo'=""){
		set Papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),0))
		set AccInfo=##class(web.UDHCAccManageCLS7).GetAccInfoByPAPMI(PatNo, "")
		set Flag=$p(Rtn,"^",1)=-201
		if (Flag=-201) set Flag=-200
		set AccID=$p(AccInfo,"^",2)
		set AccNo=""
		set left=$p(AccInfo,"^",3)
		set Balance=""
		set DepPrice=""
		set Pass=""
		set Rtn=Flag_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass_"^"_Papmi_"^"_PatNo
		quit Rtn
	}
	
	quit Rtn
}

ClassMethod ResponseMsg(ByRef ResObj As %ObjectHandle, ResCode As %String, ResMsg As %String, IsNeedRefund As %String = "0") As %Stream.GlobalCharacter
{
	set OutXML=##class(%Stream.GlobalCharacter).%New()
	set ResObj.ResultCode=ResCode
	set ResObj.ResultMsg=ResMsg
	if (##class(BILL.Util.Tools).IsValidProperty($classname(ResObj), "IsNeedRefund")) {   //2022-03-04 ZhYW 增加第三方是否需要退款标识
		set ResObj.IsNeedRefund=IsNeedRefund
	}
	do ResObj.XMLExportToStream(.OutXML, "Response")
	quit OutXML
}

/// Description: 保存交易信息
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo()
ClassMethod SavePayInfo(OrderNo As %String, PrtStr As %String, PayDetailsObj As %ObjectHandle, ExpStr As %String) As %String
{
	set UserId=$p(ExpStr,"^",1)
	set GroupId=$p(ExpStr,"^",2)
	set CTLocId=$p(ExpStr,"^",3)
	set HospitalID=$p(ExpStr,"^",4)
	set TerminalID=$p(ExpStr,"^",5)
	set TradeType=$p(ExpStr,"^",6)
	set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,0))
	
	set PayModeCode=PayDetailsObj.PayModeCode
    set POSPayStr=PayDetailsObj.POSPayStr
    set PayDate=PayDetailsObj.PayDate
    set PayTime=PayDetailsObj.PayTime
    if (PayDate["-") set PayDate=$zdh(PayDate,3)
    if (PayTime[":") set PayTime=$zth(PayTime,1)
    set PayMode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)    //必要时更新票据支付方式?
    set PrtStr=$tr(PrtStr,"^","!")
    
    set RtnValue=0
    if (POSPayStr'="") {
	    set ETPData=$g(^DHCBILLETP(ETPRowID))
	    set Adm=$p(ETPData,"^",43)
		set Papmi=$p(ETPData,"^",40)
		//保存POS交易信息
	    set PosExpStr=CTLocId_"^"_GroupId_"^"_HospitalID_"^"_UserId_"^"_Adm_"^"_Papmi_"^"_PrtStr
	    //科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串
	    set RtnValue=##class(DHCBILL.MisPos.BLL.MisPosLogic).SaveMisPosData(POSPayStr, ETPRowID, "LD", "OP", "C", PosExpStr)
	 }else {
		set OutputObj=##class(DHCBILL.Common.DHCBILLCommon).GetClsPropJsonO("User.DHCBillExtTradePay")
		set OutputObj.ETPRc="00"
		set OutputObj.ETPRcDetail="支付成功"
		set OutputObj.ETPPan=PayDetailsObj.PayAccountNo 	        //ETP_Pan 卡号账号
		set OutputObj.ETPExtAmt=PayDetailsObj.PayAmt 	            //ETP_Ext_Amt 支付金额
		set OutputObj.ETPRRN=PayDetailsObj.PlatformNo 	            //ETP_RRN 对账唯一号 (暂时以平台号)
		set OutputObj.ETPTerminalNo=TerminalID                      //ETP_Terminal 终端号
		set OutputObj.ETPExtDate=PayDate 		                    //ETP_Ext_Date 支付日期
		set OutputObj.ETPExtTime=PayTime 		                    //ETP_Ext_Time 支付时间
		set OutputObj.ETPTradeUserDR=UserId 			            //ETP_TradeUser_DR 虚拟操作员
		set OutputObj.ETPTradeChannel=PayDetailsObj.TradeChannel 	//ETP_TradeChannel 渠道 交易来源渠道/区分对账和退费对应的第三方
		set OutputObj.ETPPayMode=PayMode 		                    //ETP_PayMode 支付方式
		set OutputObj.ETPExtTradeChannel=PayDetailsObj.PayChannel 	//ETP_ExtTradeChannel 支付渠道
		set OutputObj.ETPExtTradeNo=PayDetailsObj.OutPayNo 		    //ETP_ExtTradeNo 第三方订单号
		set OutputObj.ETPHisPrtStr=PrtStr 			                //ETP_HisPrtStr业务流水号
		set RtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
	}
	set Rtn=$p(RtnValue,"^",1)
	quit:(+Rtn) RtnValue
	
	quit Rtn
}

/// Creator: wangjian
/// CreatDate: 2018-03-16
/// Description: 插入交易关联表，这里插入只为订单和业务Id关联，不能作为最终关联
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeConSub(1, "4554^", "OP")
ClassMethod InsertExtTradeConSub(ETPRowID As %String, PrtStr As %String, TradeType As %String) As %String
{
	set PrtStr=$tr(PrtStr,"^","!")
	
	set rtn=0
	
	ts
	
	for i=1:1:$l(PrtStr,"!")  {
		set PrtRowId=$p(PrtStr,"!",i)
		continue:(+PrtRowId=0)
		&SQL(
			INSERT INTO DHC_BillExtTradeConSub (
				ETC_ETP_ParRef, ETC_HISPRT_DR, ETC_Status, ETC_TradeType
			)
			VALUES (
				:ETPRowID, :PrtRowId, 'N', :TradeType
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn)  tro  quit rtn

	if ($tl>0) tc
 	
	quit rtn
}

/// Description: 删除无效结算单关联
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DelExtTradeConSub()
ClassMethod DelExtTradeConSub(ETPRowID As %String) As %String
{
	set rtn=0
	
	quit:(+ETPRowID=0) -1_"^"_"参数错误"
	set ETPStatus=$p($g(^DHCBILLETP(ETPRowID)),"^",18)
	quit:(ETPStatus="Y") -1_"^"_"HIS业务已成功，不能删除"
	
	set ETCSub=$o(^DHCBILLETP(ETPRowID,"C",0))
	quit:(+ETCSub=0) rtn
	
	&SQL(DELETE FROM DHC_BillExtTradeConSub WHERE ETC_ETP_ParRef = :ETPRowID)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// ExpStr: UserID收费员ID^Grup安全组^GLoc默认登录科室^HospDR院区ID^TerminalID
/// 	   ^TradeType交易类型(OP,IP,DEP,PRE,CARD,INSU)^PatientID患者主索引
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertBankTradePay()
ClassMethod InsertExtTradePay(CardNo As %String, Adm As %String, InsType As %String, ExtTradeType As %String, TradeAmt As %String, ExpStr As %String) As %String
{
	set UserId=$p(ExpStr,"^",1)
	set GroupId=$p(ExpStr,"^",2)
	set CTLocId=$p(ExpStr,"^",3)
	set HospId=$p(ExpStr,"^",4)
	set TerminalID=$p(ExpStr,"^",5)
	set TradeType=$p(ExpStr,"^",6)
	set PatientID=$p(ExpStr,"^",7)
	if ((PatientID="")&&(Adm'="")) {
		set PatientID=$p(^PAADM(Adm),"^",1)
	}
	
	set Rtn=0
	
	ts
	
	//创建支付订单
	set PrtStr=""
	set OrgETPRowID=""
	set myExpStr=CTLocId_"^"_GroupId_"^"_HospId_"^"_UserId_"^"_PatientID_"^"_Adm_"^"_PrtStr_"^"_OrgETPRowID_"^"_ExtTradeType
	set RtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreatePayOrder(TradeType, "", TradeAmt, myExpStr)
	set Rtn=$p(RtnValue,"^",1)
	if (+Rtn)  tro  quit RtnValue
	set ETPRowID=$p(RtnValue,"^",2)
	
	//更新费别
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Terminal_No = :TerminalID, ETP_InsType = :InsType
		WHERE %ID = :ETPRowID
	)
	set Rtn=SQLCODE
	if (+Rtn) tro  quit Rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	set ETPData=$g(^DHCBILLETP(ETPRowID))
	set HisTradeID=$p(ETPData,"^",32)   //ETP_HISTradeID
	
	quit Rtn_"^"_ETPRowID_"^"_HisTradeID
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeOrdSub(22, "5237||1")
ClassMethod InsertExtTradeOrdSub(ETPRowID As %String, PBORowID As %String) As %String
{
	set Rtn=0
	
	set PB=+PBORowID, PBO=$p(PBORowID,"||",2)
	set PBOData=$g(^DHCPB(PB,"O",PBO))
	quit:(PBOData="") 0
	set ARCIM=$p(PBOData,"^",3)
	set OEORI=$p(PBOData,"^",4)
	set StatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
	set StatCode=$s((StatDR'=""):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
	set BillQty=$p(PBOData,"^",5)
	set RefQty=$p(PBOData,"^",6)
 	set Qty=BillQty+RefQty
 	set Price=$p(PBOData,"^",7)
 	set TotalAmt=$p(PBOData,"^",8)
    set DiscAmount=$p(PBOData,"^",9)
 	set PayorShare=$p(PBOData,"^",10)
 	set PatientShare=$p(PBOData,"^",11)
 	
	ts
	
 	//DHC_BillExtTradeOrdSub
 	&SQL(
 		INSERT INTO DHC_BillExtTradeOrdSub (
 			ETO_ETP_ParRef, ETO_OEORDER, ETO_ARCIMDR, ETO_ArmStatus, ETO_Price,
 			ETO_Qty, ETO_TotalAmt, ETO_PBORDER, ETO_DiscAmount, ETO_PayorShare,
 			ETO_PatientShare
 		)
 		VALUES (
 			:ETPRowID, :OEORI, :ARCIM, :StatCode, :Price,
 			:Qty, :TotalAmt, :PBORowID, :DiscAmount, :PayorShare,
 			:PatientShare
 		)
 	)
    set Rtn=SQLCODE
	if (+Rtn) tro  quit Rtn_"^"_$g(%msg)
    set ETORowID=$g(%ROWID)
 	
 	set PBD=0
 	while($o(^DHCPB(PB,"O",PBO,"D",PBD))) {
	 	set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))
	 	set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
	 	continue:(PBDData="")
	 	set PBDRowID=PB_"||"_PBO_"||"_PBD
	 	&SQL(SELECT * INTO PLIST() FROM DHC_PatBillDetails WHERE %ID = :PBDRowID) 
	 	&SQL(
	 		INSERT INTO DHC_BillExtTradeTarSub (
	 			ETT_ETP_ParRef, ETT_TARI_DR, ETT_UnitPrice, ETT_BillQty, ETT_DiscPerc,
	 			ETT_TotalAmount, ETT_DiscAmount, ETT_PayorShare, ETT_PatientShare, ETT_BillDate,
	 			ETT_BillTime, ETT_BillStatus, ETT_CreateDate, ETT_CreateTime, ETT_BillUser,
	 			ETT_ExecDept_Dr, ETT_DiscPrice, ETT_InsPrice, ETT_PatPrice, ETT_TradeOrd_Dr
	 		)
	 		VALUES (
	 			:ETPRowID, :PLIST(3), :PLIST(4), :PLIST(5), :PLIST(6),
	 			:PLIST(7), :PLIST(8), :PLIST(9), :PLIST(10), :PLIST(11),
	 			:PLIST(12), :PLIST(13), :PLIST(14), :PLIST(15), :PLIST(16),
	 			:PLIST(17), :PLIST(18), :PLIST(19), :PLIST(20), :ETORowID
	 		)
	 	)
	    set Rtn=SQLCODE
	    if (+Rtn) {
		    set Rtn=Rtn_"^"_$g(%msg)
		    quit
		}
	}
    if (+Rtn) tro  quit Rtn
    
    if ($tl>0) tc
    
    quit Rtn
}

/// Description: 更新订单表终端号
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).UpdtExtTerminalID("33","zzj01")
ClassMethod UpdtExtTerminalID(ETPRowID As %String, TerminalID As %String) As %String
{
	set rtn=0
	quit:(+ETPRowID=0) -1_"^"_"参数错误"
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_Terminal_No = :TerminalID
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

/// Creator: wangjian
/// CreatDate: 2014-07-13
/// Description: 判断Str1与Str2的所有不为空节点是否一致
/// Return: 正反对比 Note1Flag Note2Flag 均为Y 返回0 否则 返回1(不完全一样)
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).CheckStrEqu("^1||1^1||2^1||3^1||1^","^1||3^1||2^1||1^","^")
ClassMethod CheckStrEqu(Str1 As %String, Str2 As %String, Delimiter As %String) As %String
{
	set Len1=$l(Str1,Delimiter)
	set Len2=$l(Str2,Delimiter)
	
	set Note1Flag="Y", Note2Flag="Y"
	for i=1:1:Len1  quit:(Note1Flag="N")  do
	.set Node1=$p(Str1,Delimiter,i)
	.quit:(Node1="")
	.set Node1=Delimiter_Node1_Delimiter
	.if ((Delimiter_Str2_Delimiter)'[Node1) set Note1Flag="N"
	
	for i=1:1:Len2  quit:(Note2Flag="N")  do
	.set Node2=$p(Str2,Delimiter,i)
	.quit:(Node2="")
	.set Node2=Delimiter_Node2_Delimiter
	.if ((Delimiter_Str1_Delimiter)'[Node2) set Note2Flag="N"
	
	if ((Note1Flag="Y")&&(Note2Flag="Y")) set rtn=0
	else  set rtn=1
	
	quit rtn
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo()
ClassMethod GetPatBaseInfo(PatientId As %String, HospId As %String) As %String
{
	quit:(PatientId="") "^^^^^"
	set PatJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(PatientId, HospId)
	set PatJson=##class(%DynamicObject).%FromJSON(PatJsonStr)
	set DobDate=$p($g(^PAPER(PatientId,"ALL")),"^",6)
	if (+DobDate'=0) set DobDate=$zd(DobDate,3)
	set CredNo=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)  //证件号
	if (CredNo="") set CredNo=$p(^PAPER(PatientId,"ALL"),"^",9)
	//if ($l(CredNo)'<18) set CredNo=$e(CredNo,1,10)_"****"_$e(CredNo,15,$l(CredNo))
	set CredTypeDR=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)  //证件类型指针
	set CredTypeDesc=$s((+CredTypeDR'=0):$p(^PAC("CARD",CredTypeDR),"^",2),1:"")
	set SocSatID=$p(^PAPER(PatientId,"PER",1),"^",10)
	set SocSat=$s((+SocSatID'=0):$p(^CT("SS",SocSatID),"^",2),1:"")
	
	set Rtn=PatJson.PatientId_"^"_PatJson.PatientNo_"^"_PatJson.PatName_"^"_PatJson.Sex_"^"_DobDate_"^"_PatJson.Age_"^"_PatJson.MedicareNo_"^"_PatJson.Address_"^"_CredTypeDesc_"^"_CredNo_"^"_SocSat

	quit Rtn
}

/// ExpStr: UserID收费员ID^Grup安全组^GLoc默认登录科室^HospDR院区ID^TerminalID
/// 				^TradeType交易类型(OP,IP,DEP,PRE,CARD,INSU)^PatientID患者主索引
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo()
ClassMethod SetHISTradeNo(CardNo, Adm, InsType, ExtTradeType, TradeAmt, ExpStr) As %String
{
	quit ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradePay(CardNo, Adm, InsType, ExtTradeType, TradeAmt, ExpStr)
}

/// Description: 根据外部支付方式Code获取HIS支付方式
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PaymodeCode)
ClassMethod TransPaymodeByOutCode(PayMCode As %String) As %String
{
	quit:(PayMCode="") ""
	quit $o(^CT("CTPM",0,"Code",PayMCode,""))
}

/// Creator: wangjian
/// CreatDate: 2018-08-06
/// Description: 根据收的交易记录生成退的交易记录
/// Input: TradeType: 交易类型(OP,IP,DEP,PRE,CARD,INSU)
///        OrgETPRowID: 正交易DHC_BillExtTradepay 表 ID
///        ExtTradeType: D 、T
///        ExpStr: 扩展串(科室^安全组^院区^操作员ID^业务表指针串(以!分隔,可为空))
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertRefundExtTradePay()
ClassMethod InsertRefundExtTradePay(TradeType As %String, OrgETPRowID As %String, ExtTradeType As %String, RefundAmt As %String, ExpStr As %String) As %String
{
	set Rtn=0
	set RtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreateRefOrder(TradeType, OrgETPRowID, ExtTradeType, RefundAmt, ExpStr)
	set Rtn=$p(RtnValue,"^",1)
	quit:(+Rtn) RtnValue
	set ETPRowID=$p(RtnValue,"^",2)
	
	set ETPData=$g(^DHCBILLETP(ETPRowID))
	set HisTradeID=$p(ETPData,"^",32)      //ETP_HISTradeID
	set OldHISTradeNo=$p(ETPData,"^",33)   //ETP_HISOldTradeID
	set OldRRN=$p(ETPData,"^",38)          //ETP_OldRRN
	 	
	quit Rtn_"^"_ETPRowID_"^"_HisTradeID_"^"_OldRRN_"^"_OldHISTradeNo
}

/// Creator: Suhuide
/// CreatDate: 2021-08-18
/// Description: 根据就诊号获取患者就诊信息
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatAdmInfo()
ClassMethod GetPatAdmInfo(Adm As %String) As %String
{
	set AdmJsonStr=##class(BILL.COM.PAAdm).GetAdmInfo(Adm)
	set AdmJson=##class(%DynamicObject).%FromJSON(AdmJsonStr)
	set AdmDate=$zd($p(^PAADM(Adm),"^",6),3)		        //就诊日期
	set VisitStatus=$p(^PAADM(Adm),"^",20)				    //就诊状态
	set VisitStatusDesc=$case(VisitStatus,"A":"在院","D":"出院","P":"预住院","C":"退院",:"")
	set AdmType=$p(^PAADM(Adm),"^",2)						//就诊类型
	set AdmTypeDesc=$case(AdmType,"I":"住院","O":"门诊","E":"急诊",:"")
	set AdmInfo=AdmDate_"^"_AdmJson.Dept_"^"_AdmJson.InsType_"^"_VisitStatus_"^"_VisitStatusDesc_"^"_AdmType_"^"_AdmTypeDesc
	quit AdmInfo
}

/// Description: 根据患者找到有效住院证
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetIPBookIDByPatientID()
ClassMethod GetIPBookIDByPatientID(PatientID As %String) As %String
{
	set IPBook=""
	quit:(+PatientID=0) IPBook
	
	set IPBookID=""
	while($o(^DHCDocIPBK(0,"PatientID",PatientID,IPBookID),-1)) {
		set IPBookID=$o(^DHCDocIPBK(0,"PatientID",PatientID,IPBookID),-1)
		set ValidFlag=##class(web.DHCBillInterface).IIsIPBook(IPBookID)
		continue:(ValidFlag'="")
		set IPBook=IPBookID
		quit
	}
	quit IPBook
}

}
