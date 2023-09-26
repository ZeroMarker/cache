/// wangjian
/// 2018-03-14
/// 门诊第三方及自助支付业务类
Class DHCBILL.SelfPay.BLL.DHCOPBillPayExp Extends %RegisteredObject
{

/// 1 明细按整包装单位 0 明细按收费项单位
Parameter PackUOMFlag = 1;

/// 充值限额
Parameter AccLimitAmt = 2000;

/// 订单明细标志  F 收费项  O 医嘱项
Parameter OrdDetailsFlag = "O";

/// 允许部分退标志（Y支持 N 不支持 谨慎修改，需修改联系产品组咨询）
Parameter PartRefFlag = "Y";

/// 医保退标志（Y支持 N 不支持 谨慎修改，需修改联系产品组咨询）
Parameter InsuRefFlag = "N";

/// 预结算锁定时间（撤销自己预结算不控制时间  锁定时间范围内他人不可撤销预结算记录）
Parameter LockSecond = 3;

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetAdmByCardNo("<Request><TradeCode>4902</TradeCode><HospitalID>2</HospitalID><CardNo>0019890501</CardNo><CardType></CardType><SecrityNo>0</SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2018-05-03</StartDate><EndDate>2018-05-04</EndDate><ExpStr></ExpStr></Request>").Read()
ClassMethod GetAdmByCardNo(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetAdmByCardNoET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetAdmByCardNo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate 
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    //调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatNo, "TTPPAY", "GetAdmByCardNo", HospitalID, UserCode, Input)
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3)
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	//组织输出就诊记录
    Set AdmCount=0
    Set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID
    Set AdmInfo=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi, myExpStr)
    For i=1:1:$l(AdmInfo,"^") Do
    .Set Adm=$p(AdmInfo,"^",i)
    .Quit:(+Adm=0)
    .Set AdmData=$g(^PAADM(Adm))
    .Set AdmDate=$p(AdmData,"^",6)
	.Quit:((StDate'="")&&(AdmDate<StDate))
	.Quit:((EndDate'="")&&(AdmDate>EndDate))
    .Set AdmTime=$p(AdmData,"^",7)
    .Set AdmStatus=$p(AdmData,"^",20)
	.Quit:(AdmStatus["C")
    .Set BillRtn=##class(web.UDHCJFBILL).BILL(Adm, UserID)
	.Quit:(+BillRtn'=0)
	.Set AdmTotalAmt=0
	.Set PBRowID=0
	.For  Set PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID)) Quit:(PBRowID="")  Do
	..Set PBData=$g(^DHCPB(PBRowID))
	..Set PBPayedFlag=$p(PBData,"^",16)
	..Quit:(PBPayedFlag'="B")
	..Set PBO=0
	..For  Set PBO=$o(^DHCPB(PBRowID,"O",PBO)) Quit:(PBO="")  Do
	...Set PBOData=$g(^DHCPB(PBRowID,"O",PBO))
	...Quit:(PBOData="")
	...Set OEORI=$p(PBOData,"^",4)
	...Set OrdStatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
	...Set OrdStatCode=$s((+OrdStatDR'=0):$p($g(^OEC("OSTAT",OrdStatDR)),"^",1),1:"")
	...Quit:(" V E "'[(" "_OrdStatCode_" "))
	...Set PatShareAmt=$p(PBOData,"^",11)
	...Set AdmTotalAmt=$i(AdmTotalAmt, PatShareAmt)
	.Quit:(+AdmTotalAmt=0)
	.Set AdmCount=$i(AdmCount)
    .Set AdmDepDR=$p(AdmData,"^",4)
    .Set AdmDept=$s((+AdmDepDR'=0):$p($g(^CTLOC(AdmDepDR)),"^",2),1:"")
	.Set AdmDocDR=$p(AdmData,"^",9)
	.Set AdmDoctor=$s((+AdmDocDR'=0):$p($g(^CTPCP(AdmDocDR,1)),"^",2),1:"")
    .Set AdmItemObj=##class(DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.AdmItem).%New()
    .Set AdmItemObj.Adm=Adm
 	.Set AdmItemObj.AdmDate=$zd(AdmDate,3)
 	.Set AdmItemObj.AdmTime=$zt(AdmTime,1)
 	.Set AdmItemObj.AdmDept=AdmDept
 	.Set AdmItemObj.AdmDoctor=AdmDoctor
 	.Set AdmItemObj.AdmAmt=AdmTotalAmt
 	.Do OutputObj.AdmList.Insert(AdmItemObj)
    If (AdmCount=0) {
	    Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无待缴费就诊记录")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取就诊记录成功")
  	Quit OutputXML
GetAdmByCardNoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-15
/// Description: 获取结算单
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetChargeOrder("<Request><TradeCode>4903</TradeCode><HospitalID></HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>41254534</PatientID><UserCode>sdp7-163</UserCode><TerminalID>ZZJ001</TerminalID><StartDate></StartDate><EndDate></EndDate><ExpStr></ExpStr><Adm>27253279</Adm></Request>").Read()
ClassMethod GetChargeOrder(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetChargeOrderET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    Set Adm=InputObj.Adm
    //调用方法存储日志 2023-02-01
    Do ..LogMsg(Adm, "", "", PatNo, "TTPPAY", "GetChargeOrder", HospitalID, UserCode, Input)
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3)
    If (StDate="") Set StDate=+$h
    If (EndDate="") Set EndDate=+$h
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}

	//创建或查询待缴费结算单 返回结算单串 ETPRowID!OrderNo^ETPRowID!OrderNo^ETPRowID!OrderNo
	Set IsPreCharge=0    //是否存在预结算记录的订单(1:是, 0:否)
	Set OrderStr=""
	Set OrdExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID
	If (Adm'="") {
		Set IsPreCharge=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckOrderTPFlagByEpisodeID(Adm)
		If (IsPreCharge=0) {
			Set OrderStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetOrder(CardNo, Adm, OrdExpStr)
		}
	}Else {
		Set AdmType=""
		While(($o(^PAPERdr(Papmi,"ADM",AdmType))'="")&&(IsPreCharge=0)) {
			Set AdmType=$o(^PAPERdr(Papmi,"ADM",AdmType))
			Continue:(" O E "'[(" "_AdmType_" "))
			Set Adm=""
			While($o(^PAPERdr(Papmi,"ADM",AdmType,Adm),-1)&&(IsPreCharge=0)) {
				Set Adm=$o(^PAPERdr(Papmi,"ADM",AdmType,Adm),-1)
				Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
				Continue:((AdmDate<StDate)||(AdmDate>EndDate))
				Set IsPreCharge=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckOrderTPFlagByEpisodeID(Adm)
				Quit:(IsPreCharge'=0)
				Set AdmDepHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
				Continue:(HospitalID'=AdmDepHospDR)
				Set AdmOrdStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetOrder(CardNo, Adm, OrdExpStr)
				Set OrderStr=$s((OrderStr=""):AdmOrdStr,1:(OrderStr_"^"_AdmOrdStr))
			}
		}
	}
	if (IsPreCharge=1) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "存在已经预结算的结算单，请完成结算或撤销后重新结算")
		Quit OutputXML
	}
	
	//组织输出结算单内容
	Set PayOrdCount=0
	For i=1:1:$l(OrderStr,"^") {
		Set OrderInfo=$p(OrderStr,"^",i)
		Set ETPRowID=$p(OrderInfo,"!",1)
		Continue:(+ETPRowID=0)
		Set OrderNo=$p(OrderInfo,"!",2)
		Set PayOrdObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.PayOrder).%New()
		Set ETPData=$g(^DHCBILLETP(ETPRowID))
		Set OrderSum=$p(ETPData,"^",23)
		Set InsTypeDR=$p(ETPData,"^",44)
		Set InsType=$p(^PAC("ADMREA",InsTypeDR),"^",2)
		Set AdmSource=$p(^PAC("ADMREA",InsTypeDR),"^",9)
		Set OrderInsuFlag=$s((+AdmSource>0):"Y",1:"N")
		Set OrdInsuData=""
		Set PayOrdCount=$i(PayOrdCount)
		Set PayOrdObj.OrderNo=OrderNo
		Set PayOrdObj.OrderSum=OrderSum
		Set PayOrdObj.OrderInsuFlag=OrderInsuFlag
		Set PayOrdObj.OrderInsType=InsType
		If (..#OrdDetailsFlag="O") Do GetOrdDetail(ETPRowID)
		Else  Do GetTarDetail(ETPRowID)
	}
	Set OutputObj.PayOrdCount=PayOrdCount
	if (PayOrdCount=0){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无待缴费结算单")
		Quit OutputXML
	}
	
  	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取结算单明细成功")
  	Quit OutputXML

GetChargeOrderET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML

GetTarDetail(ETPRowID)
	Set ETOSub=0
	For  Set ETOSub=$o(^DHCBILLETP(ETPRowID,"O",ETOSub)) Quit:(ETOSub="")  Do
	.Set ETOData=$g(^DHCBILLETP(ETPRowID,"O",ETOSub))
	.Quit:(ETOData="")
	.Set TradeRowID=ETPRowID_"||"_ETOSub
	.Set OEORI=$p(ETOData,"^",1)
	.Set ArcimRowID=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	.Set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ArcimRowID, 0)
	.Set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimRowID, OEORI)
	.Set PackQty=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9)),"^",4)
	.Set Packaging=##class(web.DHCBillCommon).GetPackUom(ArcimRowID, OEORI)
	.Set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))	//INC_Itm->RowID
	.Set ItemSpecs=$s((INCI'=""):##class(web.DHCST.Common.DrugInfoCommon).GetSpec("", INCI), 1:"")   //调用药房组接口取规格
	.Set ETTSub=0
	.For  Set ETTSub=$o(^DHCBILLETPi(0,"TradeSub",TradeRowID,ETPRowID,"T",ETTSub)) Quit:(ETTSub="")  Do
	..Set ETTData=$g(^DHCBILLETP(ETPRowID,"T",ETTSub))
	..Set ItemDR=$p(ETTData,"^",3)
	..Set ItemCode=$p($g(^DHCTARI(ItemDR)),"^",1)
	..Set ItemName=$p($g(^DHCTARI(ItemDR)),"^",2)
	..Set ItemSubCat=$p($g(^DHCTARI(ItemDR)),"^",15)
	..Set ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)
	..Set ItemCategory=$p(^DHCTarC("TOC",ItemCat),"^",2)
	..Set ItemPrice=$p(ETTData,"^",4)
	..Set ItemQty=$p(ETTData,"^",5)
	..Set ItemSum=$p(ETTData,"^",7)
	..Set UomID=$p(^DHCTARI(ItemDR),"^",3)
	..Set ItemUom=$p(^CT("UOM",UomID),"^",2)
	..If ((..#PackUOMFlag=1)&&(OrderType="R")) Do
	...Set ItemUom=Packaging
  	...Set ItemQty=PackQty
  	...Set ItemPrice=ItemPrice*ConFac
	..Set ItemObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Item).%New()
	..Set ItemObj.ItemCode=ItemCode
	..Set ItemObj.ItemName=ItemName
	..Set ItemObj.ItemCategory=ItemCategory
	..Set ItemObj.ItemPrice=$fn(ItemPrice,"",4)
	..Set ItemObj.ItemQty=ItemQty
	..Set ItemObj.ItemSum=ItemSum
	..Set ItemObj.ItemUom=ItemUom
	..Set ItemObj.ItemSpecs=ItemSpecs
	..Do PayOrdObj.ItemList.Insert(ItemObj)
	..Do ItemObj.%Close()
	Set PayOrdObj.OrdInsuData=OrdInsuData    //这里可以调用方法
	Do OutputObj.PayOrdList.Insert(PayOrdObj)
	Quit
GetOrdDetail(ETPRowID)
	Set ETOSub=0
	For  Set ETOSub=$o(^DHCBILLETP(ETPRowID,"O",ETOSub)) Quit:(ETOSub="")  Do
	.Set ETOData=$g(^DHCBILLETP(ETPRowID,"O",ETOSub))
	.Quit:(ETOData="")
	.Set TradeRowID=ETPRowID_"||"_ETOSub
	.Set OEORI=$p(ETOData,"^",1)
	.Set ArcimRowID=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	.Set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ArcimRowID, 0)
	.Set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimRowID, OEORI)
	.Set PackQty=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9)),"^",4)
	.Set Packaging=##class(web.DHCBillCommon).GetPackUom(ArcimRowID, OEORI)
	.Set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))	//INC_Itm->RowID
	.Set ItemSpecs=$s((INCI'=""):##class(web.DHCST.Common.DrugInfoCommon).GetSpec("", INCI),1:"") //调用药房组接口取规格
	.Set ItemDR=ArcimRowID
	.Set ItemCode=$p($g(^ARCIM(+ArcimRowID,1,1)),"^",1)
	.Set ItemName=$p($g(^ARCIM(+ArcimRowID,1,1)),"^",2)
	.Set ItemCategory=""
	.Set ItemPrice=$p(ETOData,"^",4)
	.Set ItemQty=$p(ETOData,"^",5)
	.Set ItemSum=$p(ETOData,"^",6)
	.Set ItemUom=##class(web.DHCBillCommon).GetBaseUom(ArcimRowID, OEORI)
	.If ((..#PackUOMFlag=1)&&(OrderType="R")) Do
	..Set ItemUom=Packaging
  	..Set ItemQty=PackQty
  	..Set ItemPrice=ItemPrice*ConFac
	.Set ItemObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Item).%New()
	.Set ItemObj.ItemCode=ItemCode
	.Set ItemObj.ItemName=ItemName
	.Set ItemObj.ItemCategory=ItemCategory
	.Set ItemObj.ItemPrice=$fn(ItemPrice,"",4)
	.Set ItemObj.ItemQty=ItemQty
	.Set ItemObj.ItemSum=ItemSum
	.Set ItemObj.ItemUom=ItemUom
	.Set ItemObj.ItemSpecs=ItemSpecs
	.Do PayOrdObj.ItemList.Insert(ItemObj)
	.Do ItemObj.%Close()
	Set PayOrdObj.OrdInsuData=OrdInsuData    //这里可以调用方法
	Do OutputObj.PayOrdList.Insert(PayOrdObj)
	Quit
}

/// Creator: wangjian
/// CreatDate: 2018-03-16
/// Description: 预结算
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PreBillCharge("<Request><TradeCode>4904</TradeCode><HospitalID></HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>41254534</PatientID><UserCode>sdp7-163</UserCode><TerminalID>ZZJ001</TerminalID><OrderNo>2020040310313420547</OrderNo><OrderSum>62.54</OrderSum><Adm></Adm><ExpStr></ExpStr></Request>").Read()
ClassMethod PreBillCharge(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="PreBillChargeET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.PreBillCharge.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set Adm=InputObj.Adm
    Set OrderNo=InputObj.OrderNo
    Set OrderSum=InputObj.OrderSum
    //调用方法存储日志 2023-02-01
    Do ..LogMsg(Adm, "", "", PatNo, "TTPPAY", "PreBillCharge", HospitalID, UserCode, Input)
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}

 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.PreBillCharge.Res.Response).%New()
 	
 	If ((CardNo="")&&(PatNo="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	Set AccountID=$p(PatInfo,"^",2)
	
	//校验并获取订单相关信息
    If (OrderNo="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单号不能为空")
		Quit OutputXML
    }
	Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
	If (+ETPRowID=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不存在的结算单号")
		Quit OutputXML
	}
	
	Set ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)
	If (ETPRc'="01") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "结算单已失效")
		Quit OutputXML
	}
	
	Set OrderSum=$fn(OrderSum,"",2)

	Set IBPPaySum=$p(^DHCBILLETP(ETPRowID),"^",23)
	Set IBPPaySum=$fn(IBPPaySum,"",2)
	If (+IBPPaySum'=+OrderSum) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "结算单金额传入有误")
		Quit OutputXML
	}
	
	Set AdmInfo=$p(^DHCBILLETP(ETPRowID),"^",43)
	Set CurIns=$p(^DHCBILLETP(ETPRowID),"^",44)
	
	Lock +^DBLock("PreBillCharge",OrderNo):3
	//+2022-10-20 ZhYW 增加锁校验
	If ('$Test) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -110, "订单："_OrderNo_"被锁定")
		Quit OutputXML
	}
	
	//判断订单是否已经预结算 已经预结算直接返回票据信息 用于一致性校验
	Set PreChargeFlag=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckPreCharge(OrderNo, OrderSum, UserID, TerminalID)
	If (PreChargeFlag="L") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单结算锁定中，锁定时效内其他终端无法结算")
		Quit OutputXML
	}
	
	If (PreChargeFlag="I") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单已经医保结算，请到窗口处理")
		Quit OutputXML
	}
	
	If (PreChargeFlag="N") {
		Set UnBillOrdStr=""
		//订单预结算
		Set OrderOEORIStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInTradeSubOrd(OrderNo)   //获取订单医嘱串
		Set OEORD=$o(^OEORD(0,"Adm",AdmInfo,""))
		Set Itm=0
		While($o(^OEORD(OEORD,"I",Itm))) {
			Set Itm=$o(^OEORD(OEORD,"I",Itm))
			Set OEORI=OEORD_"||"_Itm
			Continue:(("^"_OrderOEORIStr_"^")[("^"_OEORI_"^"))
			Set Billed=$p($g(^OEORD(+OEORD,"I",Itm,3)),"^",5)
			Continue:(" P I "[(" "_Billed_" "))
			Set OrdRecLoc=$p($g(^OEORD(+OEORD,"I",Itm,3)),"^",6)
			Set OrdInsTypeDR=$p($g(^OEORD(+OEORD,"I",Itm,11)),"^",18)
			Set OrdStatDR=$p($g(^OEORD(+OEORD,"I",Itm,1)),"^",13)
			Set OrdStatCode=$s((+OrdStatDR'=0):$p($g(^OEC("OSTAT",OrdStatDR)),"^",1),1:"")
			Continue:(" V E "'[(" "_OrdStatCode_" "))
			Set UnBillOrdStr=$s((UnBillOrdStr=""):OEORI,1:(UnBillOrdStr_"^"_OEORI))
		}
		
	    Set PayInfo=""
		Set ChargeExpStr=Grup_"^"_GLoc_"^"_AccountID_"^Y^F^^0^"
	
		ts

		Set RtnValue=##class(web.DHCOPINVCons).OPBillCharge(AdmInfo, UserID, UnBillOrdStr, CurIns, OrderSum, PayInfo, Grup, 0, "", 0, ChargeExpStr) 
		Set ErrCode=+$p(RtnValue,"^",1)
		If (ErrCode'=0) {
			Lock -^DBLock("PreBillCharge", OrderNo)
			tro
			Set ChargeErr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPreChargeErrMsg(ErrCode)
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, ChargeErr)
			Quit OutputXML
		}
		Set InvRowidStr=$p(RtnValue,"^",2,*)
		
		//记录自助机终端号
		Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).UpdtExtTerminalID(ETPRowID, TerminalID)
		If (+RtnValue'=0) {
			Lock -^DBLock("PreBillCharge",OrderNo)
			tro
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "自助机终端号失败")
			Quit OutputXML
		}
		
		//删除无效关联(针对关联后预结算被撤销)
		Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DelExtTradeConSub(ETPRowID)
		If (+RtnValue'=0) {
			Lock -^DBLock("PreBillCharge",OrderNo)
			tro
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "删除无效关联失败")
			Quit OutputXML
		}
		
		//预结算后创建关联
		Set ETPTradeType=$p(^DHCBILLETP(ETPRowID),"^",25)
		Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeConSub(ETPRowID, InvRowidStr, ETPTradeType)
		If (+RtnValue'=0) {
			Lock -^DBLock("PreBillCharge",OrderNo)
			tro
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "创建关联失败")
			Quit OutputXML
		}
		
		If ($tl>0) tc
	}Else {
		//获取已经预结算票据信息
		Set InvRowidStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder(OrderNo, ETPRowID)
	}
	Lock -^DBLock("PreBillCharge",OrderNo)
	
	Set myYBHand=""
	Set myLeftAmt=""
	Set myCPPFlag="NotCPPFlag"
	Set myStrikeFlag="N"
	Set myInsuNo=""
	Set myCardType=""
	Set myYLLB=""       //医疗类别
	Set myDicCode=""    //病种编码
	Set myDicDesc=""    //病种
	Set myDYLB=""
	Set myChargeSource="01"
	Set myDBConStr=""   //数据库连接串
	Set myMoneyType=""
	Set selPaymId=""
	Set myYBExpStr=myStrikeFlag_"^"_Grup_"^"_myInsuNo_"^"_myCardType_"^"_myYLLB_"^"_myDicCode_"^"_myDicDesc
	Set myYBExpStr=myYBExpStr_"^"_myLeftAmt_"^"_myChargeSource_"^"_myDBConStr_"^"_myDYLB_"^"_AccountID_"^"_HospitalID
	Set myYBExpStr=myYBExpStr_"^"_selPaymId_"!"_myLeftAmt_"^"_myMoneyType
	
	//组织返回值
	For i=1:1:$l(InvRowidStr,"^") {
		Set PrtRowId=$p(InvRowidStr,"^",i)
		Continue:(+PrtRowId=0)
		Set PrtData=$g(^DHCINVPRT(PrtRowId))
		Set InvoiceAmt=$p(PrtData,"^",1)
		Set PrtInsType=$p(PrtData,"^",9)
		Set AdmSource=$p(^PAC("ADMREA",PrtInsType),"^",9)
		Set InsuFlag="N"
		Set HISInsuInfo=""
		If (+AdmSource>0) {
			Set InsuFlag="Y"
			Set HISInsuInfo=0_"|"_UserID_"|"_PrtRowId_"|"_AdmSource_"|"_PrtInsType_"|"_myYBExpStr_"|"_myCPPFlag
		}
		Set InvoiceObj=##class(DHCBILL.SelfPay.Entity.PreBillCharge.Res.Invoice).%New()
		Set InvoiceObj.InvoiceNo=PrtRowId
		Set InvoiceObj.InvoiceAmt=InvoiceAmt
		Set InvoiceObj.InsuFlag=InsuFlag
		Set InvoiceObj.HISInsuInfo=HISInsuInfo
		Do OutputObj.InvoiceList.Insert(InvoiceObj)
		Do InvoiceObj.%Close()
	}
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "预结算成功")
  	Quit OutputXML
PreBillChargeET
	Set $zt=""
	tro
	Lock     //解去当前进程内所有锁
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.PreBillCharge.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-17
/// Description: 确认收费完成
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CompleteCharge("<Request><TradeCode>4904</TradeCode><HospitalID>2</HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>41254534</PatientID><UserCode>sdp7-163</UserCode><TerminalID>ZZJ001</TerminalID><OrderNo>2020040310313420547</OrderNo><InvoiceNoStr></InvoiceNoStr><PayDetails><PayModeCode>CASH</PayModeCode><TradeChannel>CLEAR</TradeChannel><PayAccountNo>0000000262</PayAccountNo><PayAmt>62.54</PayAmt><PlatformNo>2018032011123000001</PlatformNo><OutPayNo>987654321</OutPayNo><PayChannel>25</PayChannel><POSPayStr></POSPayStr><PayDate>2020-04-03</PayDate><PayTime>11:12:22</PayTime></PayDetails><ExpStr/></Request>")
ClassMethod CompleteCharge(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="CompleteChargeET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set OrderNo=InputObj.OrderNo
    Set InvoiceNoStr=InputObj.InvoiceNoStr
    Set InsuPersonInfo=InputObj.InsuPersonInfo
    Set InsuDivide=InputObj.InsuDivide
    Set InsuTradeOut=InputObj.InsuTradeOut
    Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
    Set PayModeCode=PayDetailsObj.PayModeCode
    Set TradeChannel=PayDetailsObj.TradeChannel
    Set PayAmt=PayDetailsObj.PayAmt
    Set PayAccountNo=PayDetailsObj.PayAccountNo
    Set PlatformNo=PayDetailsObj.PlatformNo
    Set OutPayNo=PayDetailsObj.OutPayNo
	/*
    Set PayChannel=PayDetailsObj.PayChannel
    Set POSPayStr=PayDetailsObj.POSPayStr
    Set PayDate=PayDetailsObj.PayDate
    Set PayTime=PayDetailsObj.PayTime
    */
	//调用方法存储日志 2023-02-01
    Do ..LogMsg("", InvoiceNoStr, "", PatNo, "TTPPAY", "CompleteCharge", HospitalID, UserCode, Input)
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Res.Response).%New()
 	
 	If ((CardNo="")&&(PatNo="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空", 1)
		Quit OutputXML
	}
	
	Set Paymode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
	If (Paymode="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "支付方式不能为空", 1)
		Quit OutputXML
	}
	Set HISPayMCode=$p($g(^CT("CTPM",Paymode)),"^",1)
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误", 1)
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	if (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误", 1)
		Quit OutputXML
	}

	Set AccountID=$p(PatInfo,"^",2)
	If ((HISPayMCode="CPP")&&(AccountID="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者无有效账户不能以院内卡支付", 1)
		Quit OutputXML
	}
	
	//校验结算单
	If (OrderNo="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单号不能为空", 1)
		Quit OutputXML
	}
	Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
	If (+ETPRowID=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不存在的结算单号", 1)
		Quit OutputXML
	}
	
	Set ETPData=$g(^DHCBILLETP(ETPRowID))
	Set ETPRc=$p(ETPData,"^",1)
	If (ETPRc="00") {
		Set TradeDate=$p(ETPData,"^",21)
		If (TradeDate'="") Set TradeDate=$zd(TradeDate,3)
		Set ETPOutTradeNo=$p(ETPData,"^",47)
		Set ETPRRN=$p(ETPData,"^",7)
		If ((OutPayNo=ETPOutTradeNo)&&(PlatformNo=ETPRRN)) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "确认已完成，成功日期:"_TradeDate)
			Quit OutputXML
		}
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "此订单已通过其他渠道支付", 1)
		Quit OutputXML
	}
	
	If (ETPRc'="01") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "结算单已失效", 1)
		Quit OutputXML
	}
	
    Set OrderInvoiceNoStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder(OrderNo, ETPRowID)
    If (InvoiceNoStr="") {
		Set InvoiceNoStr=OrderInvoiceNoStr
    }Else {
		Set EquFlag=0
		For i=1:1:$l(InvoiceNoStr,"^") {
			Quit:(EquFlag'=0)
			Set InvoiceNo=$p(InvoiceNoStr,"^",i)
			Continue:(InvoiceNo="")
			Continue:(("^"_OrderInvoiceNoStr_"^")[("^"_InvoiceNo_"^"))
			Set EquFlag=1
		}
		If (EquFlag'=0) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单号与票据流水号不匹配")
			Quit OutputXML
		}
	}
	
	If (##class(web.DHCBillCons12).ValidatePrtRowID(InvoiceNoStr)="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不存在的HIS预结记录")
		Quit OutputXML
	}
	
	//判断和预结算时是否是同一终端
	Set myTerminalID=$p(ETPData,"^",9)  //ETP_Terminal_No
	Set IsOrgTID=0
	For i=1:1:$l(InvoiceNoStr,"^") {
		Set InvoiceNo=$p(InvoiceNoStr,"^",i)
		Continue:(InvoiceNo="")
		Set PrtUserDR=$p(^DHCINVPRT(InvoiceNo),"^",21)
		if ((UserID'=PrtUserDR)||(myTerminalID'=TerminalID))  {
			Set IsOrgTID=1
			Quit
		}
	}
	If (IsOrgTID=1) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "非本终端预结算记录不能完成")
		Quit OutputXML
	}
	
	//自付金额
	Set SelfPayAmt=##class(web.DHCBillConsIF).GetPatSelfPayAmt(InvoiceNoStr)
	If (+SelfPayAmt'=+PayAmt) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入金额不符", 1)
		Quit OutputXML
	}
   	
	Set ErrCode=0
	
	ts
	
	//1.医保结算
	/* 用于第三方直接调用医保
	Set OPDivideInfo=""
	If (InsuPersonInfo'="") {
		//医保一次结算必须一张发票
		Set TradeOut=""
		Set OPDivideInfo=##class(web.DHCINSUPort).InsuOPDivide(UserID, InvoiceNoStr, InsuPersonInfo, DivideOut, TradeOut)
		If (+OPDivideInfo=-1) {
	   		tro
	   		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "医保结算失败")
			Quit OutputXML
		}
		Set RtnValue=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(OPDivideInfo, "")
		Set ErrCode=+$p(RtnValue,"^",1)
		If (ErrCode'=0) {
	   		tro
	   		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "保存医保支付方式失败")
			Quit OutputXML
		}
	}
	*/
	//2.保存交易信息
	Set TradeType="OP"
	Set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_TradeChannel
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo, InvoiceNoStr, .PayDetailsObj, myExpStr)
	If (+RtnValue'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "保存支付信息失败", 1)
		Quit OutputXML
	}
	
	//3.确认完成
	Set InsType=$p(ETPData,"^",44)
	
	//删除先前创建的关联，重新在确认完成方法中创建关联
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DelExtTradeConSub(ETPRowID)
	If (+RtnValue'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "删除先前创建的订单关联失败", 1)
		Quit OutputXML
	}
	
	Set SelfPayAmtRound=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(InvoiceNoStr, SelfPayAmt, Paymode)
	Set PayInfo=Paymode_"^^^^^^^"_SelfPayAmtRound_"^^^"_ETPRowID
	Set myExpStr=Grup_"^"_GLoc_"^"_AccountID_"^Y^F^^0^^"
	
	Set RtnValue=##class(web.DHCBillConsIF).CompleteCharge(2, UserID, InsType, InvoiceNoStr, 0, "", myExpStr, PayInfo)
	If (+RtnValue'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "HIS确认完成失败", 1)
		Quit OutputXML
	}
	
	//+2023-05-05 ZhYW 防止线上医保纯医保支付后，未与his关联
	If ('$d(^DHCBILLETP(ETPRowID,"C",0))) {
		Set RtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(ETPRowID, $tr(InvoiceNoStr,"^","!"), TradeType)
		If (+RtnValue'=0) {
			tro
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "HIS业务与订单关联失败", 1)
			Quit OutputXML
		}
	}
	
	If ($tl>0) tc
	
	//4.调用平台接口  2020-08-10 ZhYW ##class(web.DHCBillConsIF).CompleteCharge 取消了发消息
	Job ##class(web.DHCOPBillSendService).SendOPChargeInfo(InvoiceNoStr)::5
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "确认完成成功")
	Quit OutputXML
	
CompleteChargeET
	Set $zt=""
	tro
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-17
/// Description: 取消预结算
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CancelCharge("<Request><TradeCode>4910</TradeCode><HospitalID>01</HospitalID><OrderNo>20180504125008DHSZ0005</OrderNo><CardNo>0019890501</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><StartDate></StartDate><EndDate></EndDate><ExpStr></ExpStr></Request>")
ClassMethod CancelCharge(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="CancelChargeET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.CancelCharge.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set OrderNo=InputObj.OrderNo
    Set InvoiceNoStr=InputObj.InvoiceNoStr
    //调用方法存储日志 2023-02-01
    Do ..LogMsg("", InvoiceNoStr, "", PatNo, "TTPPAY", "CancelCharge", HospitalID, UserCode, Input)
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CancelCharge.Res.Response).%New()
 	
 	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	//根据订单取就诊
	Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
	If (+ETPRowID=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不存在的结算单号")
		Quit OutputXML
	}
	Set ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)
	If (ETPRc="00") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "收费成功不可撤销")
		Quit OutputXML
	}
	
	Set OrderInvoiceNoStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder(OrderNo, ETPRowID)	
	If (InvoiceNoStr="") {
		Set InvoiceNoStr=OrderInvoiceNoStr
	}Else {
		Set EquFlag=0
		For i=1:1:$l(InvoiceNoStr,"^") {
			Quit:(EquFlag'=0)
			Set InvoiceNo=$p(InvoiceNoStr,"^",i)
			Continue:(InvoiceNo="")
			Continue:(("^"_OrderInvoiceNoStr_"^")[("^"_InvoiceNo_"^"))
			Set EquFlag=1
		}
		If (EquFlag'=0) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "票据流水与结算单不符")
			Quit OutputXML
		}
	}
	
	ts
	
	Set DelExpStr=Grup_"^"_UserID
	Set RtnValue=##class(web.DHCBillConsIF).DelINVPRTForYB(InvoiceNoStr, DelExpStr)
	If (+RtnValue'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "撤销HIS预结算失败")
		Quit OutputXML
	}
	//删除无效关联(默认这里撤销订单所有关联需要重新结算订单)
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).DelExtTradeConSub(ETPRowID)
	If (+RtnValue'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +RtnValue, "删除订单无效关联失败")		
		Quit OutputXML
	}
	
	If ($tl>0) tc
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "撤销预结算成功")
	Quit OutputXML
	
CancelChargeET
	Set $zt=""
	tro
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CancelCharge.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-18
/// Description: 查询已缴费记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecord("<Request><TradeCode>4092</TradeCode><HospitalID></HospitalID><CardNo>0000000262</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000262</PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><StartDate></StartDate><EndDate></EndDate><Adm></Adm><OrderNo>20180320140958DHSZ0107</OrderNo><InvoiceNo>223304</InvoiceNo><PrtInvNo></PrtInvNo><ExpStr></ExpStr></Request>")
ClassMethod GetPaidRecord(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetPaidRecordET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecord.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate 
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    Set OrderNo=InputObj.OrderNo
    Set Adm=InputObj.Adm
    Set InvoiceNo=InputObj.InvoiceNo
    Set PrtInvNo=InputObj.PrtInvNo
    
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3) 
    //调用方法存储日志 2023-02-01
    Do ..LogMsg(Adm, PrtInvNo, "", PatNo, "TTPPAY", "GetPaidRecord", HospitalID, UserCode, Input)
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecord.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	if (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	Set PrtStr=""
	If (PrtInvNo'="") {
		Set INVPRTRowID=0
		For  Set INVPRTRowID=$o(^DHCINVPRT(0,"INV",PrtInvNo,INVPRTRowID)) Quit:(INVPRTRowID="")  Do
		.Set FairType=$p($g(^DHCINVPRT(INVPRTRowID)),"^",34)
		.//Quit:(FairType'="F")
		.Set INVHospDR=$p(^DHCINVPRT(INVPRTRowID),"^",39)
    	.Quit:(INVHospDR'=HospitalID)
		.Set PrtStr=INVPRTRowID
		
		Set APIRowID=0
		For  Set APIRowID=$o(^DHCINVPRTAPi(0,"INVNo",PrtInvNo,APIRowID))  Quit:(APIRowID="")  Do
		.Set APIHospDR=$p(^DHCINVPRTAP(APIRowID),"^",30)
		.Quit:(APIHospDR'=HospitalID)
		.Set ACPRowID=0
		.For  Set ACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,ACPRowID)) Quit:(ACPRowID="")  Do
		..Set INVPRTRowID=$p($g(^DHCINVPRTCAP(ACPRowID)),"^",1)
		..If (PrtStr="") Set PrtStr=INVPRTRowID
		..Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
		
	}ElseIf(InvoiceNo'=""){
		Set PrtStr=InvoiceNo
	}ElseIf(OrderNo'=""){
		Set PrtStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder(OrderNo, "")
	}ElseIf(Adm'=""){
		Set BCIRowID=0
		For  Set BCIRowID=$o(^DHCBCI(0,"ADM",Adm,BCIRowID)) Quit:(BCIRowID="")  Do
		.Set INVPRTRowID=$p(^DHCBCI(BCIRowID),"^",1)
		.If (PrtStr="") Set PrtStr=INVPRTRowID
		.Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
	}Else {
		//日期优先级最低
	 	If (StDate="") Set StDate=+$h
    	If (EndDate="") Set EndDate=+$h
     	For Date=StDate:1:EndDate Do
    	.Set INVPRTRowID=0
    	.For  Set INVPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",Date,Papmi,INVPRTRowID)) Quit:(INVPRTRowID="")  Do
    	..Set INVHospDR=$p(^DHCINVPRT(INVPRTRowID),"^",39)
    	..Quit:(INVHospDR'=HospitalID)
    	..If (PrtStr="") Set PrtStr=INVPRTRowID
		..Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
	}
	
	If (PrtStr=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "未找到相关缴费记录")
		Quit OutputXML
	}
	
	//组织输出
	Set RecordCount=0
	For i=1:1:$l(PrtStr,"^")  Do
	.Set PrtRowId=$p(PrtStr,"^",i)
	.Quit:(+PrtRowId=0)
	.Set PrtData=$g(^DHCINVPRT(PrtRowId))
	.Set PrtFlag=$p(PrtData,"^",8)
	.Quit:(PrtFlag'="N")
	.Set PrtDate=$p(PrtData,"^",5)
	.Set PrtTime=$p(PrtData,"^",20)
	.Set InvDate=$zd(PrtDate,3)
	.Set InvTime=$zt(PrtTime,1)
	.Set PrintFlag=$p(PrtData,"^",3)
	.If (PrintFlag="P") Set PrintFlag="Y"
	.Set TotalAmt=$p(PrtData,"^",1)
	.Set InsuShareAmt=$p(PrtData,"^",31)
	.Set PatShareAmt=TotalAmt-InsuShareAmt
	.Set PrtInvNo=$p(PrtData,"^",14)
	.Set PrtAccPDr=$p(PrtData,"^",4)
	.Set PayModeInfo=""
	.If ((PrtInvNo="")&&(PrtAccPDr'="")) Do
	..Set PrtInvNo=$p(^DHCINVPRTAP(PrtAccPDr),"^",6)
	..Set PayModeInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvPaymodeInfo(PrtAccPDr, "API")
	.Else  Do
	..Set PayModeInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvPaymodeInfo(PrtRowId, "PRT")
	.Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","OP","PRT",PrtRowId,0))
	.Set OrderNo=$s((ETPRowID'=""):$p($g(^DHCBILLETP(ETPRowID)),"^",32),1:"") 
	.Set (AdmDate, AdmTime, AdmDept, AdmDoctor)=""
	.Set RecordCount=$i(RecordCount)    //记录条数
	.Set BCIRowId=0
	.For  Set BCIRowId=$o(^DHCBCI(0,"INV",PrtRowId,BCIRowId)) Quit:(BCIRowId="")  Do
	..Set AdmID=$p(^DHCBCI(BCIRowId),"^",3)
    ..Set AdmDate=$p(^PAADM(AdmID),"^",6)
    ..Set AdmTime=$p(^PAADM(AdmID),"^",7)
    ..Set AdmDate=$zd(AdmDate,3)
    ..Set AdmTime=$zt(AdmTime,1)
	..Set AdmDepDR=$p(^PAADM(AdmID),"^",4)
	..Set AdmDept=$s((AdmDepDR'=""):$p($g(^CTLOC(AdmDepDR)),"^",2),1:"")
	..Set AdmDocDR=$p(^PAADM(AdmID),"^",9)
	..Set AdmDoctor=$s((+AdmDocDR'=0):$p($g(^CTPCP(AdmDocDR,1)),"^",2),1:"")
	.Set RecordListObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecord.Res.Record).%New()
	.Set RecordListObj.OrderNo=OrderNo
	.Set RecordListObj.InvoiceNo=PrtRowId
	.Set RecordListObj.InvDate=InvDate
	.Set RecordListObj.InvTime=InvTime
	.Set RecordListObj.TotalAmt=TotalAmt
	.Set RecordListObj.InsuShareAmt=InsuShareAmt
	.Set RecordListObj.PatShareAmt=PatShareAmt
	.Set RecordListObj.PayModeInfo=PayModeInfo
	.Set RecordListObj.PrintFlag=PrintFlag
	.Set RecordListObj.PrtInvNo=PrtInvNo
	.Set RecordListObj.AdmDate=AdmDate
	.Set RecordListObj.AdmTime=AdmTime
	.Set RecordListObj.AdmDept=AdmDept
	.Set RecordListObj.AdmDoctor=AdmDoctor
	.Do OutputObj.RecordList.Insert(RecordListObj)
	.Do OutputObj.%Close()
	
	Set OutputObj.RecordCount=RecordCount
	If (+RecordCount=0){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "没有缴费记录")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取缴费记录成功")
	Quit OutputXML
GetPaidRecordET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecord.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-18
/// Description: 查询已缴费记录明细
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetPaidRecordDetails("<Request><TradeCode>4092</TradeCode><HospitalID></HospitalID><CardNo>0000000262</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000262</PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><StartDate></StartDate><EndDate></EndDate><Adm></Adm><OrderNo>20180320143218DHSZ0106</OrderNo><InvoiceNo></InvoiceNo><PrtInvNo></PrtInvNo><ExpStr></ExpStr></Request>")
ClassMethod GetPaidRecordDetails(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetPaidRecordDetailsET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate 
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    Set OrderNo=InputObj.OrderNo
    Set Adm=InputObj.Adm
    Set InvoiceNo=InputObj.InvoiceNo
    Set PrtInvNo=InputObj.PrtInvNo
    //调用方法存储日志 2023-02-01
    Do ..LogMsg(Adm, PrtInvNo, "", PatNo, "TTPPAY", "GetPaidRecordDetails", HospitalID, UserCode, Input)
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3)
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	if (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	Set PrtStr=""
	If (PrtInvNo'="") {
		Set INVPRTRowID=0
		For  Set INVPRTRowID=$o(^DHCINVPRT(0,"INV",PrtInvNo,INVPRTRowID)) Quit:(INVPRTRowID="")  Do
		.Set FairType=$p($g(^DHCINVPRT(INVPRTRowID)),"^",34)
		.//(Quit:FairType'="F")
		.Set INVHospDR=$p(^DHCINVPRT(INVPRTRowID),"^",39)
    	.Quit:(INVHospDR'=HospitalID)
		.Set PrtStr=INVPRTRowID
		
		Set APIRowID=0
		For  Set APIRowID=$o(^DHCINVPRTAPi(0,"INVNo",PrtInvNo,APIRowID))  Quit:(APIRowID="")  Do
		.Set APIHospDR=$p(^DHCINVPRTAP(APIRowID),"^",30)
		.Quit:(APIHospDR'=HospitalID)
		.Set ACPRowID=0
		.For  Set ACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,ACPRowID)) Quit:(ACPRowID="")  Do
		..Set INVPRTRowID=$p($g(^DHCINVPRTCAP(ACPRowID)),"^",1)
		..If (PrtStr="") Set PrtStr=INVPRTRowID
		..Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
		
	}ElseIf(InvoiceNo'=""){
		Set PrtStr=InvoiceNo
	}ElseIf(OrderNo'=""){
		Set PrtStr=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder(OrderNo, "")	
	}ElseIf(Adm'=""){
		Set BCIRowID=0
		For  Set BCIRowID=$o(^DHCBCI(0,"ADM",Adm,BCIRowID)) Quit:(BCIRowID="")  Do
		.Set INVPRTRowID=$p(^DHCBCI(BCIRowID),"^",1)
		.If (PrtStr="") Set PrtStr=INVPRTRowID
		.Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
	}Else {
		//日期优先级最低
	 	If (StDate="") Set StDate=+$h
    	If (EndDate="") Set EndDate=+$h
     	For Date=StDate:1:EndDate Do
    	.Set INVPRTRowID=0
    	.For  Set INVPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",Date,Papmi,INVPRTRowID)) Quit:(INVPRTRowID="")  Do
    	..Set INVHospDR=$p(^DHCINVPRT(INVPRTRowID),"^",39)
    	..Quit:(INVHospDR'=HospitalID)
    	..If (PrtStr="") Set PrtStr=INVPRTRowID
		..Else  Set PrtStr=PrtStr_"^"_INVPRTRowID
	}
	
	If (PrtStr=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "未找到相关缴费记录")
		Quit OutputXML
	}
	
	//组织输出
	Set RecordCount=0
	For i=1:1:$l(PrtStr,"^")  Do
	.Set PrtRowId=$p(PrtStr,"^",i)
	.Quit:(+PrtRowId=0)
	.Set PrtData=$g(^DHCINVPRT(PrtRowId))
	.Set PrtFlag=$p(PrtData,"^",8)
	.Quit:(PrtFlag'="N")
	.Set PrtDate=$p(PrtData,"^",5)
	.Set PrtTime=$p(PrtData,"^",20)
	.Set InvDate=$zd(PrtDate,3)
	.Set InvTime=$zt(PrtTime,1)
	.Set PrintFlag=$p(PrtData,"^",3)
	.If (PrintFlag="P") Set PrintFlag="Y"
	.Set TotalAmt=$p(PrtData,"^",1)
	.Set InsuShareAmt=$p(PrtData,"^",31)
	.Set PatShareAmt=TotalAmt-InsuShareAmt
	.Set PrtInvNo=$p(PrtData,"^",14)
	.Set PrtAccPDr=$p(PrtData,"^",4)
	.Set PayModeInfo=""
	.If ((PrtInvNo="")&&(PrtAccPDr'="")) Do
	..Set PrtInvNo=$p(^DHCINVPRTAP(PrtAccPDr),"^",6)
	..Set PayModeInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvPaymodeInfo(PrtAccPDr, "API")
	.Else  Do
	..Set PayModeInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvPaymodeInfo(PrtRowId, "PRT")
	.Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","OP","PRT",PrtRowId,0))
	.Set OrderNo=$s((ETPRowID'=""):$p($g(^DHCBILLETP(ETPRowID)),"^",32),1:"") 
	.Set (AdmDate, AdmTime, AdmDept, AdmDoctor)=""
	.Set RecordCount=$i(RecordCount)
	.Set BCIRowId=0
	.For  Set BCIRowId=$o(^DHCBCI(0,"INV",PrtRowId,BCIRowId)) Quit:(BCIRowId="")  Do
	..Set AdmID=$p(^DHCBCI(BCIRowId),"^",3)
    ..Set AdmDate=$p(^PAADM(AdmID),"^",6)
    ..Set AdmTime=$p(^PAADM(AdmID),"^",7)
    ..Set AdmDate=$zd(AdmDate,3)
    ..Set AdmTime=$zt(AdmTime,1)
	..Set AdmDepDR=$p(^PAADM(AdmID),"^",4)
    ..Set AdmDept=$s((+AdmDepDR'=0):$p($g(^CTLOC(AdmDepDR)),"^",2),1:"")
	..Set AdmDocDR=$p(^PAADM(AdmID),"^",9)
	..Set AdmDoctor=$s((+AdmDocDR'=0):$p($g(^CTPCP(AdmDocDR,1)),"^",2),1:"")
	..Set RecordListObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Record).%New()
	..Set PB=$p(^DHCBCI(BCIRowId),"^",2)
	..Set PBO=0
	..For  Set PBO=$o(^DHCPB(PB,"O",PBO))  Quit:(PBO="")  Do
	...Set PBOData=$g(^DHCPB(PB,"O",PBO))
	...Quit:(PBOData="")
	...Set OEORI=$p(PBOData,"^",4)
	...Set ArcimRowID=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	...Set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ArcimRowID, 0)
	...Set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimRowID, OEORI)
	...Set PackQty=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9)),"^",4)
	...Set Packaging=##class(web.DHCBillCommon).GetPackUom(ArcimRowID, OEORI)
	...Set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))		//INC_Itm->RowID
	...Set ItemSpecs=$s((INCI'=""):##class(web.DHCST.Common.DrugInfoCommon).GetSpec("", INCI),1:"")
	...Set DurgWin=""
	...If (OrderType="R") Do
	....Set PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)
	....Set Window=##class(PHA.FACE.OUT.Com).GetPrtPrescWin(PrtRowId, PresNo)
	....If (DurgWin="") Set DurgWin=Window
	....Else   Do
	.....If (DurgWin'[Window) Set DurgWin=DurgWin_" ,"_Window
	...Set RecDepDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",6)  //接收科室
	...Set RecDept=$s((RecDepDR'=""):$p($g(^CTLOC(RecDepDR)),"^",2),1:"")
	...Set PBD=0
	...For  Set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))   Quit:(PBD="")  Do
	....Set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
	....Set ItemDR=$p(PBDData,"^",3)
	....Set ItemCode=$p($g(^DHCTARI(ItemDR)),"^",1)
	....Set ItemName=$p($g(^DHCTARI(ItemDR)),"^",2)
	....Set ItemSubCat=$p($g(^DHCTARI(ItemDR)),"^",15)
	....Set ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)
	....Set ItemCategory=$p(^DHCTarC("TOC",ItemCat),"^",2)
	....Set ItemPrice=$p(PBDData,"^",4)
	....Set ItemQty=$p(PBDData,"^",5)
	....Set ItemSum=$p(PBDData,"^",7)
	....Set UomID=$p(^DHCTARI(ItemDR),"^",3)
	....Set ItemUom=$p(^CT("UOM",UomID),"^",2)
	....If (..#PackUOMFlag=1)&&(OrderType="R") Do
	.....Set ItemUom=Packaging
  	.....Set ItemQty=PackQty
  	.....Set ItemPrice=ItemPrice*ConFac
	....Set ItemObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecordDetails.Res.Item).%New()
	....Set ItemObj.ItemCode=ItemCode
	....Set ItemObj.ItemName=ItemName
	....Set ItemObj.ItemCategory=ItemCategory
	....Set ItemObj.ItemRecDept=RecDept
	....Set ItemObj.ItemPrice=$fn(ItemPrice,"",4)
	....Set ItemObj.ItemQty=ItemQty
	....Set ItemObj.ItemSum=ItemSum
	....Set ItemObj.ItemUom=ItemUom
	....Set ItemObj.ItemSpecs=ItemSpecs
	....Do RecordListObj.ItemList.Insert(ItemObj)
	....Do ItemObj.%Close()
	.//
	.Set RecordListObj.OrderNo=OrderNo
	.Set RecordListObj.InvoiceNo=PrtRowId
	.Set RecordListObj.InvDate=InvDate
	.Set RecordListObj.InvTime=InvTime
	.Set RecordListObj.DurgWin=DurgWin
	.Set RecordListObj.TotalAmt=TotalAmt
	.Set RecordListObj.InsuShareAmt=InsuShareAmt
	.Set RecordListObj.PatShareAmt=PatShareAmt
	.Set RecordListObj.PayModeInfo=PayModeInfo
	.Set RecordListObj.PrintFlag=PrintFlag
	.Set RecordListObj.PrtInvNo=PrtInvNo
	.Set RecordListObj.AdmDate=AdmDate
	.Set RecordListObj.AdmTime=AdmTime
	.Set RecordListObj.AdmDept=AdmDept
	.Set RecordListObj.AdmDoctor=AdmDoctor
	.Do OutputObj.RecordList.Insert(RecordListObj)
	.Do OutputObj.%Close()
	 
	Set OutputObj.RecordCount=RecordCount
	If (+RecordCount=0){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "没有缴费记录明细")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取缴费记录明细成功")
	Quit OutputXML
GetPaidRecordDetailsET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPaidRecord.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-17
/// Description: 校验订单是否支付成功
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CheckCharge("<Request><TradeCode>4092</TradeCode><HospitalID>01</HospitalID><CardNo>000000000910</CardNo><CardType></CardType><SecrityNo>0</SecrityNo><PatientID>0000000262</PatientID><UserCode>5</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2018-03-10</StartDate><EndDate>2018-03-14</EndDate><ExpStr></ExpStr></Request>")
ClassMethod CheckCharge(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="CheckChargeET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.CheckCharge.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set OrderNo=InputObj.OrderNo
    //调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatNo, "TTPPAY", "CheckCharge", HospitalID, UserCode, Input)    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CheckCharge.Res.Response).%New()
 	
 	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	//校验结算单
	If (OrderNo="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单号不能为空")
		Quit OutputXML
	}
	Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
	If (+ETPRowID=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不存在的结算单号")
		Quit OutputXML
	}
	Set ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)
	If (ETPRc="00")	{
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "结算单结算成功")
		Quit OutputXML
	}
	If (ETPRc="01") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "结算单未结算")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "结算单失效")
	Quit OutputXML
CheckChargeET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CheckCharge.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: zfb
/// CreatDate: 2018-3-20
/// Description: 门诊收费未打印发票记录查询
/// Input: <Request><TradeCode></TradeCode><CardNo>100000013589</CardNo><SecrityNo>6298057385</SecrityNo></Request>
/// Return:
/// Debug: w ##class(web.DHCOPBillAutoPayExp).GetInvPayList("<Request><TradeCode></TradeCode><CardNo></CardNo><SecrityNo></SecrityNo></Request>")
ClassMethod GetInvPayList(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetPatAccListET"
	Set InputObj=##Class(DHCBILL.SelfPay.Entity.GetPatAccList.Req.Request).%New()
	Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
	
	Set HospitalID=InputObj.HospitalID
	Set StartDate=InputObj.StartDate
	Set EndDate=InputObj.EndDate
	Set CardNo=InputObj.CardNo
	Set CardType=InputObj.CardType
	Set SecrityNo=InputObj.SecrityNo
	Set PatientID=InputObj.PatientID
	Set UserCode=InputObj.UserCode
	Set TerminalID=InputObj.TerminalID
	Set ExpStr=InputObj.ExpStr
	//调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatientID, "TTPPAY", "GetInvPayList", HospitalID, UserCode, Input)  
	If (StartDate["-") Set StartDate=$zdh(StartDate,3)
	If (EndDate["-") Set EndDate=$zdh(EndDate,3)
	
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPatAccList.Res.Response).%New()
	If (CardNo=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号不能都为空")
		Quit OutputXML
	}
	
	Set Data=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, "")
	Set Papmi=$p(Data,"^",8)
    if (Papmi="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
    Set PatSocialStatusDR=$p(^PAPER(Papmi,"PER",1),"^",10)    //PAPER_SocialStatus_DR->CT_SocialStatus
    Set PatSocialStatus=$p(^CT("SS",PatSocialStatusDR),"^",2)
    Set AccMRowID=$p(Data,"^",2)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMBalance=AccMBalance
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
    Set AccMAccStatus=$p(^DHCACD("AccM",AccMRowID),"^",13)
	Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	If (Sex'="") Set Sex=$p(^CT("SEX",Sex),"^",2)
	Set PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmi, "", HospitalID)
	
	Set OutputObj.PatientID=PapNo
	Set OutputObj.PatName=PatName
	Set OutputObj.PatAge=PatAge
	Set OutputObj.PatSex=Sex
	Set OutputObj.PatType=""
	Set OutputObj.AccMRowID=AccMRowID
	Set OutputObj.AccMOCDate=""
	Set OutputObj.AccMOCTime=""
	Set OutputObj.AccMBalance=AccMBalance
	Set OutputObj.AccMDepPrice=""
	Set OutputObj.AccMAccStatus=AccMAccStatus
	;
	Kill PrtRowIdAry
	;
	Set myIdx=0
	Set mySub=""
	For  Set mySub=$o(^DHCACD("AccM",AccMRowID,"AccPL",mySub),-1) Quit:(mySub="")  Do
	.Quit:(mySub=0)
	.Set myPLInfo=$g(^DHCACD("AccM",AccMRowID,"AccPL",mySub))
	.Quit:(myPLInfo="")
	.Set myPLRowID=AccMRowID_"||"_mySub
	.Set myBillNo=$p(myPLInfo,"^",4)
	.Set mySSUsrDR=$p(myPLInfo,"^",5)
	.Set:(mySSUsrDR'="") mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
	.Set mySSUInitials=$p(^SSU("SSUSR",mySSUsrDR),"^",1)		//操作员代码
	.Set myPayDate=$p(myPLInfo,"^",6)
	.Quit:((myPayDate<StartDate)||(myPayDate>EndDate))
	.Set PrtDate=$zd(myPayDate,3)
	.Set myPayTime=$p(myPLInfo,"^",7)
	.Set PrtTime=$zt(myPayTime,1)
	.Set myPayNum=$p(myPLInfo,"^",8)
	.Set myPayNum=$fn(+myPayNum,"",2)
	.Set myPayLeft=$p(myPLInfo,"^",9)
	.Set myPayLeft=$fn(+myPayLeft,"",2)
	.Set myPayLocDR=$p(myPLInfo,"^",10)
	.Set:(myPayLocDR'="") myLocDesc=$p(^CTLOC(myPayLocDR),"^",2)
	.Set myPRTRowID=$p(myPLInfo,"^",2)
	.Quit:('$d(^DHCINVPRT(myPRTRowID)))
	.Set myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)
	.Quit:(" F R "'[(" "_myFairType_" "))
	.Set FairType=$case(myFairType,"R":"挂号",:"收费")
	.Set myINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	.Quit:(myINVFlag'="N")
	.Set myINVPrtFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	.Quit:(myINVPrtFlag'="N")
	.Set PrtRowIdAry(myPRTRowID)=""
	.Set OrderDetails=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetOrdDetailsByPrtRowID(myPRTRowID)
	.Set AccListDetailObj=##class(DHCBILL.SelfPay.Entity.GetPatAccList.Res.InvDetail).%New()
	.Set AccListDetailObj.Index=$i(myIdx)
	.Set AccListDetailObj.PrtDate=PrtDate
	.Set AccListDetailObj.PrtTime=PrtTime
	.Set AccListDetailObj.FairType=FairType
	.Set AccListDetailObj.Amt=myPayNum
	.Set AccListDetailObj.User=mySSUInitials
	.Set AccListDetailObj.BillNo=myBillNo
	.Set AccListDetailObj.Left=myPayLeft
	.Set AccListDetailObj.PayDept=$g(myLocDesc)
	.Set AccListDetailObj.PLRowID=myPLRowID
	.Set AccListDetailObj.PRTRowID=myPRTRowID
	.Set AccListDetailObj.OrderDetails=OrderDetails
	.Do OutputObj.InvList.Insert(AccListDetailObj)
	.Do AccListDetailObj.%Close()
	
	//查询发票表
	For myDate=StartDate:1:EndDate Do
	.Set myPRTRowID="0"
	.For  Set myPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",myDate,Papmi,myPRTRowID)) Quit:(myPRTRowID="")  Do
	..Quit:$d(PrtRowIdAry(myPRTRowID))
	..Set myPLRowID=myPRTRowID
	..Set myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)
	..Quit:(" F R "'[(" "_myFairType_" "))
	..Set FairType=$case(myFairType,"R":"挂号",:"收费")
	..Set myINVPrtFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	..Quit:(myINVPrtFlag'="N")
	..Set myINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	..Quit:(myINVFlag'="N")
	..Set mySSUsrDR=$p(^DHCINVPRT(myPRTRowID),"^",21)
	..Set mySSUInitials=$p(^SSU("SSUSR",mySSUsrDR),"^",1)
	..Set myPayDate=$zd($p(^DHCINVPRT(myPRTRowID),"^",5),3)
	..Set PrtDate=$zd(myPayDate,3)
	..Set myPayTime=$zt($p(^DHCINVPRT(myPRTRowID),"^",20),1)
	..Set PrtTime=$zt(myPayTime,1)
	..Set myPayNum=$fn($p(^DHCINVPRT(myPRTRowID),"^",1),"",2)
	..Set myPayLeft=""
	..Set myLocDesc=""
	..Set OrderDetails=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetOrdDetailsByPrtRowID(myPRTRowID)
	..Set AccListDetailObj=##class(DHCBILL.SelfPay.Entity.GetPatAccList.Res.InvDetail).%New()
	..Set AccListDetailObj.Index=$i(myIdx)
	..Set AccListDetailObj.PrtDate=PrtDate
	..Set AccListDetailObj.PrtTime=PrtTime
	..Set AccListDetailObj.FairType=FairType
	..Set AccListDetailObj.Amt=myPayNum
	..Set AccListDetailObj.User=mySSUInitials
	..Set AccListDetailObj.BillNo=""
	..Set AccListDetailObj.Left=myPayLeft
	..Set AccListDetailObj.PayDept=myLocDesc
	..Set AccListDetailObj.PLRowID=myPLRowID
	..Set AccListDetailObj.PRTRowID=myPRTRowID
	..Set AccListDetailObj.OrderDetails=OrderDetails
	..Do OutputObj.InvList.Insert(AccListDetailObj)
	..Do AccListDetailObj.%Close()
	
	Kill PrtRowIdAry

	If (myIdx=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无可打印发票")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
GetPatAccListET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetPatAccList.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: zfb
/// CreatDate: 2018-3-20
/// Description: 门诊收费未打印发票记录查询
/// Input: <Request><TradeCode></TradeCode><InvPrtRowIDStr></InvPrtRowIDStr><UserCode></UserCode><AccMRowID></AccMRowID><ExpStr></ExpStr></Request>
/// Return: 
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).PrintInvoice("<Request><TradeCode></TradeCode><InvPrtRowIDStr></InvPrtRowIDStr><UserCode></UserCode><AccMRowID></AccMRowID><ExpStr></ExpStr></Request>")
ClassMethod PrintInvoice(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="PrintInvoiceET"
	Set ResultCode="100"
	Set ResultMsg="没有查询到人员信息"
	Set InputObj=##Class(DHCBILL.SelfPay.Entity.PrintInvoice.Req.Request).%New()
	Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
	Set TradeCode=InputObj.TradeCode
	Set HospitalID=InputObj.HospitalID
	Set CardNo=InputObj.CardNo
	Set SecrityNo=InputObj.SecrityNo
	Set CardType=InputObj.CardType
	Set PatientID=InputObj.PatientID
	Set UserCode=InputObj.UserCode
	Set TerminalID=InputObj.TerminalID
	Set AccMRowID=InputObj.AccMRowID
	Set INVPrtStr=InputObj.PRTRowIDStr
	Set ExpStr=InputObj.ExpStr
	//调用方法存储日志 2023-02-01
    Do ..LogMsg("", INVPrtStr, "", PatientID, "TTPPAY", "GetInvPayList", HospitalID, UserCode, Input)  
	Set UserID=""
	If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}

	Set OutputObj=##class(DHCBILL.SelfPay.Entity.PrintInvoice.Res.Response).%New()
	If (CardNo=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号不能都为空")
		Quit OutputXML
	}
	
	Set Data=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, "")
	Set Papmi=$p(Data,"^",8)
    if (Papmi="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)	 ;SSUSR_DefaultDept
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)	 ;SSUSR_Group

	//把数据压缩到发票
	Set PrtColStr=""
	Set TMPGID=""
	Set HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(GLoc)
	Set myExpStr=GLoc_"^"_Grup_"^"_UserID_"^"_HospID
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ParPrtToINV(INVPrtStr, myExpStr, .PrtColStr, .TMPGID)
	Set ErrCode=+RtnValue
	If (+ErrCode) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "发票分解错误")
		Quit OutputXML
	}
	
	//插入发票表
	Set myExpStr=GLoc_"^"_Grup_"^"_HospID
	Set RtnValue=##class(web.UDHCAccPrtPayFoot).APayColPrtUpdate(PrtColStr, UserID, AccMRowID, Papmi, myExpStr)
	Set ErrCode=+$p(RtnValue,"^",1)
	Set APIRowIDStr=$p(RtnValue,"^",2,*)
	If (+ErrCode) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "发票生成错误")
		Quit OutputXML
	}
	
	//发票插入成功后，清除临时数据
	Do ##class(web.UDHCACINVColPrt).KTMP()
	Do ##class(web.UDHCACINVColPrt).KillINVTMP(TMPGID)

	//获取打印数据
	Set PrtDataExpStr=""
	Set OutputObj=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvoicePrintData(APIRowIDStr, PrtDataExpStr)
	Set OutputObj.AccMRowID=AccMRowID
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
	
PrintInvoiceET
	Set $zt=""
	tro
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.PrintInvoice.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatAccInfo("<Request><TradeCode>4801</TradeCode><HospitalID>2</HospitalID><CardNo>0019890501</CardNo>1<CardType></CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><ExpStr></ExpStr></Request>")
ClassMethod GetOPPatAccInfo(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetOPPatAccInfoET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetOPPatAccInfo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    //调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatNo, "TTPPAY", "GetOPPatAccInfo", HospitalID, UserCode, Input)   
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetOPPatAccInfo.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1,"卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (+$p(PatInfo,"^",1)'=0) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	Set Papmi=$p(PatInfo,"^",8)
	Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(Papmi, HospitalID)
	Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	Set OutputObj.Sex=$p(BaseInfo,"^",4)
	Set OutputObj.DOB=$p(BaseInfo,"^",5)
	Set OutputObj.CredType=$p(BaseInfo,"^",9)
	Set OutputObj.CredNo=$p(BaseInfo,"^",10)
	Set OutputObj.AccountID=$p(PatInfo,"^",2)
	Set OutputObj.BalanceAmt=$p(PatInfo,"^",4)
	Set OutputObj.LimitAmt=..#AccLimitAmt
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
GetOPPatAccInfoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetOPPatAccInfo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AddOPDeposit("<Request><TradeCode>4802</TradeCode><HospitalID>2</HospitalID><CardNo>0019890501</CardNo><CardType>1</CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><AccountID>36476</AccountID><PayDetails><PayModeCode>CASH</PayModeCode><TradeChannel>KLE</TradeChannel><PayAccountNo>smk12345</PayAccountNo><PayAmt>1000</PayAmt><PlatformNo>2018032219013000001</PlatformNo><OutPayNo>201803221902</OutPayNo><PayChannel>CASH</PayChannel><POSPayStr></POSPayStr><PayDate>2018-05-05</PayDate><PayTime>22:04:22</PayTime></PayDetails><ExpStr></ExpStr></Request>")
ClassMethod AddOPDeposit(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="AddOPDepositET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    Set AccountID=InputObj.AccountID
    
    Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
    Set Amount=PayDetailsObj.PayAmt
    Set PayModeCode=PayDetailsObj.PayModeCode
    Set TradeChannel=PayDetailsObj.TradeChannel
    Set PayAccountNo=PayDetailsObj.PayAccountNo
    Set PayDate=PayDetailsObj.PayDate
    Set OutPayNo=PayDetailsObj.OutPayNo
     //调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatNo, "TTPPAY", "AddOPDeposit", HospitalID, UserCode, Input)  
    If (PayDate["-") Set PayDate=$zdh(PayDate,3)
        
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空", 1)
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误", 1)
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (+$p(PatInfo,"^",1)'=0) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,  -1, "患者信息传入有误", 1)
		Quit OutputXML
	}
	Set AccID=$p(PatInfo,"^",2)
	Set Papmi=$p(PatInfo,"^",8)
	Set BeforeBalAmt=$p(PatInfo,"^",4)
	If (AccID'=AccountID) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,  -1, "传入账户与卡账户不符", 1)
		Quit OutputXML
	}
	
	Set LimitAmt=..#AccLimitAmt
	If (Amount>LimitAmt){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "充值金额不能大于充值限额", 1)
		Quit OutputXML
	}
	
	Set ErrCode=0
	ts
	
	//申请交易流水
	Set TradeType="PRE"
	Set TExpstr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_Papmi
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(CardNo, "", "", "C", Amount, TExpstr)
	Set ErrCode=+$p(RtnValue,"^",1)
	If (+ErrCode){
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "HIS创建交易流水号失败", 1)
		Quit OutputXML
	}
	Set ETPRowID=$p(RtnValue,"^",2)
	Set OrderNo=$p(RtnValue,"^",3)
	
	//保存交易信息
	Set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_TradeChannel
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo, "", .PayDetailsObj, myExpStr)
	Set ErrCode=+RtnValue
	If (+ErrCode) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "保存支付信息失败", 1)
		Quit OutputXML
	}

	//HIS预交金充值
	Set Paymode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
	Set BackReason=""
	Set PreType="P"
	Set Remark=""
	Set BankCardType=""
	Set Bank=""
	Set ChequeNo=""
	Set Company=""
	Set ChequeDate=""
	Set AccPDInfo=Amount_"^"_UserID_"^"_BackReason_"^"_PassWord_"^"_PreType_"^"_Remark_"^"_HospitalID
	
	Set AccPMInfo=Paymode_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate
	Set AccPMInfo=AccPMInfo_"^"_PayAccountNo_"^"_Amount_"^"_""_"^"_""_"^"_""_"^"_ETPRowID
	Set RtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccountID, AccPDInfo, AccPMInfo)
	Set ErrCode=+$p(RtnValue,"^",1)
	Set PrtRowID=$p(RtnValue,"^",2)
	If (+ErrCode) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "交押金失败", 1)
		Quit OutputXML
	}
	
	if ($tl>0) tc
	
	Set Balance=$p(^DHCACD("AccM",AccID),"^",8)
	Set DepPrice=$p(^DHCACD("AccM",AccID),"^",14)
	Set BalanceAmt=Balance-DepPrice
	Set OutputObj.SerialNo=OrderNo
	Set OutputObj.BeforeBalAmt=BeforeBalAmt
	Set OutputObj.BalanceAmt=BalanceAmt
	Set OutputObj.LimitAmt=..#AccLimitAmt
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML

AddOPDepositET
	Set $zt=""
	tro
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).RefundOPDeposit("<Request><TradeCode>4808</TradeCode><HospitalID></HospitalID><CardNo>0000001025</CardNo><CardType>1</CardType><SecrityNo></SecrityNo><PassWord></PassWord><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID></TerminalID><AccountID>39702</AccountID><RefundAmt>110</RefundAmt><RefundMode>JHZF</RefundMode><RefundDepID>39702||2</RefundDepID><CommitFlag></CommitFlag><ExpStr></ExpStr></Request>").Read()
ClassMethod RefundOPDeposit(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="RefundOPDepositET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    Set AccountID=InputObj.AccountID
    Set RefAmt=InputObj.RefundAmt   
    Set PayModeCode=InputObj.RefundMode
    Set RefundDepId=InputObj.RefundDepID
      //调用方法存储日志 2023-02-01
    Do ..LogMsg("", "", "", PatNo, "TTPPAY", "RefundOPDeposit", HospitalID, UserCode, Input)  
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set AccLeftAmt=$p(^DHCACD("AccM",AccountID),"^",8)
	If (RefAmt>AccLeftAmt){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "退款金额大于账户余额")
		Quit OutputXML
	}
	Set CanRefSum=$p(^DHCACD("AccM",AccountID,"AccPD",$p(RefundDepId,"||",2)),"^",2)
	
	Set RefSub=0
	While($o(^DHCACDi("AccM",0,"InitDR",RefundDepId,AccountID,"AccPD",RefSub))) {
		Set RefSub=$o(^DHCACDi("AccM",0,"InitDR",RefundDepId,AccountID,"AccPD",RefSub))
		Set RefundedSum=$p(^DHCACD("AccM",AccountID,"AccPD",RefSub),"^",2)
		Set CanRefSum=CanRefSum+RefundedSum
	}
	
	Set Paymode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
	If (RefAmt>CanRefSum){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "退款金额超限")
		Quit OutputXML	
	}
	
	Set RtnValue=##class(web.UDHCAccAddDeposit).HasToRefAccPD(AccountID)
	Set ErrCode=+RtnValue
	If (+ErrCode) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "存在未提交的退款申请")
		Quit OutputXML
	}
	
	Set ErrCode=0
	
	ts
	
	Set TradeType="PRE"
	Set Papmi=""
	Set TExpstr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_Papmi
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(CardNo, "", "", "T", RefAmt, TExpstr)
	Set ErrCode=$p(RtnValue,"^",1)
	If (+ErrCode) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "HIS内部申请流水号失败")
		Quit OutputXML
	}
	Set ETPRowID=$p(RtnValue,"^",2)
	Set OrderNo=$p(RtnValue,"^",3)
	
	Set BackReason=""
	Set PreType="TR"
	Set Remark=""
	Set BankCardType=""
	Set Bank=""
	Set ChequeNo=""
	Set Company=""
	Set ChequeDate=""
	Set PayAccountNo=""
	Set AccPDInfo=RefAmt_"^"_UserID_"^"_BackReason_"^"_PassWord_"^"_PreType_"^"_Remark_"^"_HospitalID_"^"_RefundDepId
	
	Set AccPMInfo=Paymode_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate
	Set AccPMInfo=AccPMInfo_"^"_PayAccountNo_"^"_RefAmt_"^"_""_"^"_""_"^"_""_"^"_ETPRowID
	
	Set RtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccountID, AccPDInfo, AccPMInfo)
	Set ErrCode=$p(RtnValue,"^",1)
	If (+ErrCode){
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "退款失败")
		Quit OutputXML
	}
    Set PrtRowID=$p(RtnValue,"^",2)
	
	if ($tl>0) tc
	
	Set Balance=$p(^DHCACD("AccM",AccountID),"^",8)
	//Set DepPrice=$p(^DHCACD("AccM",AccountID),"^",14)
	Set BalanceAmt=Balance        //-DepPrice
	Set OutputObj.SerialNo=OrderNo
	Set OutputObj.BalanceAmt=BalanceAmt
	Set OutputObj.RefundDepID=PrtRowID
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "退款成功")
	Quit OutputXML

RefundOPDepositET
	Set $zt=""
	tro
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CommitRefundOPDeposit("<Request><TradeCode>4808</TradeCode><HospitalID></HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PassWord></PassWord><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID></TerminalID><TradeChannel></TradeChannel><AccountID>35747</AccountID><RefundAmt>10</RefundAmt><RefundMode>CASH</RefundMode><RefundDepID></RefundDepID><RefDepRowid>35747||3</RefDepRowid><HisTradeNo></HisTradeNo><CommitFlag>N</CommitFlag><PayDetails><PayModeCode>CASH</PayModeCode><TradeChannel>KLE</TradeChannel><PayAccountNo>smk12345</PayAccountNo><PayAmt>1000</PayAmt><PlatformNo>2018032219013000001</PlatformNo><OutPayNo>201803221902</OutPayNo><PayChannel>CASH</PayChannel><POSPayStr></POSPayStr><PayDate>2018-05-05</PayDate><PayTime>22:04:22</PayTime></PayDetails><ExpStr></ExpStr></Request>").Read()
ClassMethod CommitRefundOPDeposit(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="CommitRefundOPDepositET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    Set AccountID=InputObj.AccountID
    Set HisTradeNo=InputObj.HisTradeNo
    Set CommitFlag=InputObj.CommitFlag     //Y 提交 N 回滚
    Set RefAmt=InputObj.RefundAmt
    Set RefundDepId=InputObj.RefDepID
    
    Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
    Set Amount=PayDetailsObj.PayAmt
    Set PayModeCode=PayDetailsObj.PayModeCode
    Set TradeChannel=PayDetailsObj.TradeChannel
    Set PayAccountNo=PayDetailsObj.PayAccountNo
    Set PayDate=PayDetailsObj.PayDate
    Set OutPayNo=PayDetailsObj.OutPayNo   
    
    If (PayDate["-") Set PayDate=$zdh(PayDate,3)
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()	 	
 	
	If (HisTradeNo=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单号不能为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",HisTradeNo,""))
	If (ETPRowID="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无效的订单号")
		Quit OutputXML
	}
	Set Rc=$p(^DHCBILLETP(ETPRowID),"^",1)	
	If (Rc'="03") {
		Set OutputObj.BalanceAmt=$p(^DHCACD("AccM",AccountID),"^",8) 
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "订单已提交或作废")
		Quit OutputXML
	}
	/*
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If ($p(PatInfo,"^",1)'=0) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	Set AccID=$p(PatInfo,"^",2)
	Set Papmi=$p(PatInfo,"^",8)
	Set BeforeBalAmt=$p(PatInfo,"^",4)
	If (AccID'=AccountID){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入账户与卡账户不符")
		Quit OutputXML
	}
	*/
	Set RefHisAmt=$p(^DHCACD("AccM",+RefundDepId,"AccPD",$p(RefundDepId,"||",2)),"^",2)
	If (+$zabs(RefHisAmt)'=+RefAmt) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入退款金额跟提交退款金额不一致")
		Quit OutputXML
	}
	
	Set ErrCode=0
	
	If (CommitFlag="N"){
		Set HandFlag=$p(^DHCACD("AccM",+RefundDepId,"AccPD",$p(RefundDepId,"||",2)),"^",10)
 		If (+HandFlag'=0) {
	 		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "该退款记录已交账，无法撤销")
	 		Quit OutputXML
		}
		
		ts
		
		Set RtnValue=##class(web.UDHCAccPreDeposit).DELETE(RefundDepId)
 		Set ErrCode=+RtnValue
 		If (ErrCode'=0) {
	 		tro
	 		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "删除退款记录失败，请重试")
			Quit OutputXML
		}
 		Set RtnValue=##class(DHCBILL.Common.DHCBILLCommon).VoidExtTradeNo(HisTradeNo)
 		Set ErrCode=+RtnValue
 		If (ErrCode'=0) {
	 		tro
	 		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "撤销退款记录失败，请重试")
			Quit OutputXML
		}
		If ($tl>0) tc
		
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "撤销退款记录成功")
		Quit OutputXML
	}
	
	ts

	Kill PLIST
	Set ErrCode=##class(web.UDHCAccPreDeposit).SELECT(RefundDepId)
	Set PLIST(3)="R"
	Set PLIST(10)=PLIST(10)+RefHisAmt
	Set ErrCode=##class(web.UDHCAccPreDeposit).UPDATE(RefundDepId)
	If (ErrCode'=0) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "保存预交金表失败")
		Quit OutputXML
	}
	Set RtnValue=##class(web.UDHCAccAddDeposit).UpdateAM(AccountID, RefHisAmt)
	Set ErrCode=+RtnValue
	If (ErrCode'=0) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "更新账号失败")
		Quit OutputXML
	}
	Set TradeType="PRE"
	//保存交易信息
	Set SaveExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_TradeChannel
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(HisTradeNo, RefundDepId, .PayDetailsObj, SaveExpStr)
	Set ErrCode=+RtnValue
	If (ErrCode'=0) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ErrCode, "保存退款信息失败,请重试!")
		Quit OutputXML
	}
	
	If ($tl>0) tc
	
	Set AccMLeft=$p(^DHCACD("AccM",AccountID),"^",8)
	Set AccMLeft=$fn(AccMLeft,"",2)
	
	Set OutputObj.BalanceAmt=AccMLeft
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "保存退款信息成功")	
	
	Quit OutputXML
CommitRefundOPDepositET
	Set $zt=""
	tro
	Lock
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatCanRefAccDetail("<Request><TradeCode>4808</TradeCode><HospitalID></HospitalID><CardNo>0000001025</CardNo><CardType>1</CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZ002</TerminalID><PayMode>JHZF</PayMode><DepCanRefAmount></DepCanRefAmount><AccountID>39702</AccountID><ExpStr></ExpStr></Request>").Read()
ClassMethod GetOPPatCanRefAccDetail(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetCanRefundListET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    //Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    Set PayModeCode=InputObj.PayMode
    Set AccountID=InputObj.AccountID
    Set RefAmt=InputObj.DepCanRefAmount
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    Set PayMode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.Response).%New()
	If (AccountID=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "账户ID不能为空")
		Quit OutputXML
	}
	If (PayMode=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "支付方式代码无效")
		Quit OutputXML
	}
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)

	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If ($p(PatInfo,"^",1)'=0) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	Set ReqAccountID=$p(PatInfo,"^",2)
	If (AccountID'=ReqAccountID){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "账户跟卡号不一致")
		Quit OutputXML
	}
	Set Papmi=$p(PatInfo,"^",8)
	Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(Papmi, HospitalID)
	Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	Set OutputObj.Sex=$p(BaseInfo,"^",4)
	Set OutputObj.DOB=$p(BaseInfo,"^",5)
	Set OutputObj.CredType=$p(BaseInfo,"^",9)
	Set OutputObj.CredNo=$p(BaseInfo,"^",10)
	Set OutputObj.BalanceAmt=$p(PatInfo,"^",4)
	
	Set AccLeftAmt=$p(^DHCACD("AccM",AccountID),"^",8)
	If (RefAmt="") Set RefAmt=AccLeftAmt
	If (RefAmt>AccLeftAmt) Set RefAmt=AccLeftAmt
	
	Set Index=0
	//倒序查充值记录
	Set PreSub=""
	For  Set PreSub=$o(^DHCACD("AccM",AccountID,"AccPD",PreSub),-1) Quit:((PreSub="")||(RefAmt<=0))  Do
	.Set PreData=$g(^DHCACD("AccM",AccountID,"AccPD",PreSub))
	.Quit:(PreData="")
	.Set PreRowID=AccountID_"||"_PreSub
	.Set PreType=$p(PreData,"^",1)
	.Quit:(PreType'="P")
	.Set PreSum=$p(PreData,"^",2) 
	.Set AddUser=$p(PreData,"^",5)
	.Set AddDate=$zd($p(PreData,"^",3),3)_" "_$zt($p(PreData,"^",4),1)
	.Set BillNo=$p(PreData,"^",6) 
	.Set PayModeDr=$p(^DHCACD("AccM",AccountID,"AccPD",PreSub,"P",1),"^",1) 
	.quit:(PayMode'="")&&(PayMode'=PayModeDr)
	.Set PayModeDesc=$p(^CT("CTPM",PayModeDr),"^",2)
	.Set CanRefSum=PreSum
	.Set RefSub=0
	.For  Set RefSub=$o(^DHCACDi("AccM",0,"InitDR",PreRowID,AccountID,"AccPD",RefSub)) Quit:(RefSub="")  Do
	..Set RefSum=$p(^DHCACD("AccM",AccountID,"AccPD",RefSub),"^",2)  
	..Set CanRefSum=CanRefSum+RefSum  //未提交的也从可退中刨除
	.Quit:(CanRefSum=0)
	.Set RefAmt=RefAmt-CanRefSum
	.Set (OutPayNo, PlatformNo, PosSysNO, PosTermnial)=""
	.Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","PRE","PRT",PreRowID,""))
	.If (ETPRowID'="")  Do
	..Set ETPData=$g(^DHCBILLETP(ETPRowID))
	..Set OutPayNo=$p(ETPData,"^",47)
	..Set PlatformNo=$p(ETPData,"^",7)
	..Set PosSysNO=$p(ETPData,"^",5)
	..Set PosTermnial=$p(ETPData,"^",9)
	.Set DepListObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.ResPayDetails).%New()
	.Set DepListObj.AccSum=PreSum
	.Set DepListObj.APPreRowid=PreRowID
	.Set DepListObj.ABillNo=BillNo
	.Set DepListObj.AccUser=AddUser
	.Set DepListObj.APDate=AddDate
	.Set DepListObj.APMode=PayModeDesc
	.Set DepListObj.CanRefAmt=CanRefSum
	.Set DepListObj.Ind=$i(Index)
	.Set DepListObj.OutPayNo=OutPayNo
	.Set DepListObj.PlatformNo=PlatformNo
	.Set DepListObj.PosSysNO=PosSysNO
	.Set DepListObj.PosTermnial=PosTermnial		
	.Do OutputObj.PayDetails.Insert(DepListObj)
	.Do DepListObj.%Close()
	
	If (Index=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "未查询到可退记录")
		Quit OutputXML
	}
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取可退信息成功")
	Quit OutputXML
GetCanRefundListET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Description: 账户充值退款明细
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetOPPatAccDetail("<Request><TradeCode>4808</TradeCode><HospitalID></HospitalID><CardNo>0000001025</CardNo><CardType>1</CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZ002</TerminalID><DepCanRefAmount></DepCanRefAmount><AccountID>39702</AccountID><ExpStr></ExpStr></Request>").Read()
ClassMethod GetOPPatAccDetail(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetOPPatAccDetailET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    //Set PassWord=InputObj.PassWord 
    Set HospitalID=InputObj.HospitalID
    Set AccountID=InputObj.AccountID     
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP","0"))
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.Response).%New()
 	If (AccountID=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "账户ID不能为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If ($p(PatInfo,"^",1)'=0) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	Set ReqAccountID=$p(PatInfo,"^",2)
	If (AccountID'=ReqAccountID){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "账户跟卡号不一致")
		Quit OutputXML
	}	
	Set Papmi=$p(PatInfo,"^",8)
	Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(Papmi, HospitalID)
	Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	Set OutputObj.Sex=$p(BaseInfo,"^",4)
	Set OutputObj.DOB=$p(BaseInfo,"^",5)
	Set OutputObj.CredType=$p(BaseInfo,"^",9)
	Set OutputObj.CredNo=$p(BaseInfo,"^",10)
	Set OutputObj.BalanceAmt=$p(PatInfo,"^",4)
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	Set AccLeftAmt=$p(^DHCACD("AccM",AccountID),"^",8)
	Set OutputObj.BalanceAmt=AccLeftAmt
	
	Set Index=1
	Set PreSub=0
	For  Set PreSub=$o(^DHCACD("AccM",AccountID,"AccPD",PreSub)) Quit:(PreSub="")  Do
	.Set PreData=$g(^DHCACD("AccM",AccountID,"AccPD",PreSub))
	.Quit:(PreData="")
	.Set PreRowID=AccountID_"||"_PreSub
	.Set PreType=$p(PreData,"^",1)
	.Set PreType=$case(PreType,"TR":"待退款","P":"交款","F":"结算","R":"退款",:"")
	.Set PreSum=$p(PreData,"^",2)
	.Set AddUser=$p(PreData,"^",5) 
	.Set AddDate=$zd($p(PreData,"^",3),3)_" "_$zt($p(PreData,"^",4),1)
	.Set BillNo=$p(PreData,"^",6) 
	.Set ALeft=$p(PreData,"^",8) 
	.Set PayModeDr=$p(^DHCACD("AccM",AccountID,"AccPD",PreSub,"P",1),"^",1) 
	.Set PayMode=$p(^CT("CTPM",PayModeDr),"^",2)	
	.Set (OutPayNo, PlatformNo, PosSysNO, PosTermnial)=""
	.Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","PRE","PRT",PreRowID,""))
	.If (ETPRowID'="")  Do
	..Set ETPData=$g(^DHCBILLETP(ETPRowID))
	..Set OutPayNo=$p(ETPData,"^",47)
	..Set PlatformNo=$p(ETPData,"^",7)
	..Set PosSysNO=$p(ETPData,"^",5)
	..Set PosTermnial=$p(ETPData,"^",9)
	.Set DepListObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.ResPayDetails).%New()
	.Set DepListObj.AccSum=PreSum
	.Set DepListObj.APPreRowid=PreRowID
	.Set DepListObj.ABillNo=BillNo
	.Set DepListObj.AccUser=AddUser
	.Set DepListObj.APDate=AddDate
	.Set DepListObj.APMode=PayMode
	.Set DepListObj.APType=PreType
	.Set DepListObj.ALeft=ALeft
	.Set DepListObj.Ind=$i(Index)
	.Set DepListObj.OutPayNo=OutPayNo
	.Set DepListObj.PlatformNo=PlatformNo
	.Set DepListObj.PosSysNO=PosSysNO
	.Set DepListObj.PosTermnial=PosTermnial	
	.Do OutputObj.PayDetails.Insert(DepListObj)
	.Do DepListObj.%Close()
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "获取账户明细信息成功")	
	
	Quit OutputXML
GetOPPatAccDetailET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.OPDepositList.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: zhenghao
/// CreatDate: 2020-02-06
/// Description: 获取可退交易记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetRefListInfoByPatient("<Request><TradeCode>4920</TradeCode><HospitalID></HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000414</PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2020-06-01</StartDate><EndDate>2020-06-04</EndDate><Adm></Adm><OrderNo></OrderNo><InvoiceNo></InvoiceNo><PrtInvNo></PrtInvNo><ExpStr></ExpStr></Request>").Read()
ClassMethod GetRefListInfoByPatient(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetRefListInfoByPatientET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetRefListInfoByPatient.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate 
    Set PayModeCode=InputObj.PayModeCode
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID  
    Set Adm=InputObj.Adm    
    
    ;If HospitalID="" Set HospitalID=$o(^CT("HOSP","0"))
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3)
    If (StDate="") Set StDate=+$h-7  ;默认查一周的
    If (EndDate="") Set EndDate=+$h
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	If HospitalID="" Set HospitalID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(GLoc) ;根据科室取院区 
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetRefListInfoByPatient.Res.Response).%New()
 	Set PayMode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo,CardType,SecrityNo,PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	If (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-3","患者信息传入有误")
		Quit OutputXML
	}
	Set UnAuditOrderCateStr=##class(web.DHCOPConfig).GetUnAuditOrderCate() ;免审核
	;判断是否需要审批  医院基本配置表中   
    s ConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)            ;OPFC_AppFlag 0:不需要审批 1:需要审批 2:申请后审核
	;组织输出结算单内容
	Set InsuRefFlag=..#InsuRefFlag
	Set PayOrdCount=0     	
	Set INVPRTRowid=""
	For  Set INVPRTRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,INVPRTRowid),-1) Quit:INVPRTRowid=""  Do
	.Quit:+INVPRTRowid=0
	.Set PrtDate=$p(^DHCINVPRT(INVPRTRowid),"^",5)
	.q:(PrtDate<StDate)!(PrtDate>EndDate)	
	.Set InsuType=$p(^DHCINVPRT(INVPRTRowid),"^",9)
	.Set InsSource=$p(^PAC("ADMREA",InsuType),"^",9)
	.q:(InsuRefFlag="N")&&(+InsSource'=0) ;医保不可退
	.q:(InsuRefFlag="N")&&($d(^DHCINVPRTInsu("0","PRT",INVPRTRowid))) ;医保分解过的也不能退
	.Set PrtFlag=$p(^DHCINVPRT(INVPRTRowid),"^",8)
	.Quit:(PrtFlag'="N") ;发票为N的才退
	.Set PrtTime=$p(^DHCINVPRT(INVPRTRowid),"^",20)
	.Set InvDate=$zd(PrtDate,3)
	.Set InvTime=$zt(PrtTime,1)
	.Set PrintFlag=$p(^DHCINVPRT(INVPRTRowid),"^",3)
	.Quit:PrintFlag="P"  ;打印发票的不退
	.set PartRefFlag=..#PartRefFlag
	.set InsuRefFlag=..#InsuRefFlag
	.set RefFlag=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckCanRef(INVPRTRowid, "OP", PartRefFlag, InsuRefFlag, PayMode)
	.Quit:(RefFlag=1)  ;不可退的退出	
	.Set PrtRefSum=0	
	.Set InsuFlag="N"
	.If (+InsSource>0) Set InsuFlag="Y"
	.set PayOrdCount=PayOrdCount+1
	.Set RecordListObj=##class(DHCBILL.SelfPay.Entity.GetRefListInfoByPatient.Res.RefItem).%New()
	.Set RecordListObj.PrtInvID=INVPRTRowid
	.Set RecordListObj.TradeDate=InvDate
	.Set RecordListObj.TradeTime=InvTime
	.Set RecordListObj.PayMode=##class(DHCBILL.Common.DHCBILLCommon).GetPayModeListByPrtType(INVPRTRowid, "OP")
	.Set RecordListObj.PrtSum=$p(^DHCINVPRT(INVPRTRowid),"^",1)
	.Set RecordListObj.SelfSum=$p(^DHCINVPRT(INVPRTRowid),"^",16)
	.Set RecordListObj.InsuSum=$p(^DHCINVPRT(INVPRTRowid),"^",31)
	.Set RecordListObj.RefFlag="Y"
	.Set RecordListObj.RefMark=""
	.Set RecordListObj.InsuType=InsuType
	.Set RecordListObj.InsuFlag=InsuFlag
	.Set RecordListObj.OutInsuInfo=""
	.Set RecordListObj.HISInsuInfo=""	
	.set ETPRowID=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrt(INVPRTRowid,"OP")
	.i ETPRowID'=""  d
	..Set RecordListObj.Channel=$p(^DHCBILLETP(ETPRowID),"^",46)  ;支付渠道
	..Set RecordListObj.HisTradeNo=$p(^DHCBILLETP(ETPRowID),"^",32)
	..Set RecordListObj.PlatformNo=$p(^DHCBILLETP(ETPRowID),"^",7)	
	.Set DHCBCIRowid=""
	.For  Set DHCBCIRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,DHCBCIRowid)) Quit:(DHCBCIRowid="")  Do
	..set AdmBill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..set PBO="0"
	..For  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	...quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	...set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	...set PBOBillQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	...set PBORefundQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	...set PBOQty=PBOBillQty+PBORefundQty
	...q:PBOQty=0
	...set PBOUnitPrice=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	...set PBOPatShare=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)
	...quit:PBOPatShare=0
	...set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	...set Reclocdesc=$p(^CTLOC(OrdRecLoc),"^",2)
	...set Prescno=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",14) ;处方号
	...set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	...set ArcimRowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	...set ARCCATRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	...set ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)	
	...set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2) ;名称
	...s UnAuditOrdItem="N"
	...i (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ARCCATRowid_$c(2)))=1 s UnAuditOrdItem="Y"	
	...;ConAppFlag 0:不需要审批 1:需要审批 2:申请后审核
    ...set ItmObj=##class(DHCBILL.SelfPay.Entity.GetRefListInfoByPatient.Res.RefDetail).%New()
    ...set ItmObj.ArcimDesc=ArcimDesc
    ...set ItmObj.ArcimId=ArcimRowid
    ...set ItmObj.OrderBillQty=PBOQty
    ...set ItmObj.OrdItemId=PBord
    ...set ItmObj.OrdPrice=PBOUnitPrice   
    ...Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
    ...set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	...set OrdStutsDesc=$case(OrdStat,"E":"执行","V":"核实","D":"停止",:"")
	...set OrdRefAmt=0
	...set CanRefQty=0
	...set CanRef=""
    ...i ARCOrdType="R" d
	....s myPhRet=##class(web.UDHCOEORDOPIF).CheckPhDispRet(PBord)	
	....s returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(PBord,INVPRTRowid)  ;退药数量
	....if (myPhRet=1)&&(returnqty=0) s CanRef="N",CanRefQty=0,OrdRefAmt=0	;发药未退不允许退
	....if (myPhRet=0)&&(ConAppFlag>0) s CanRef="N",CanRefQty=0,OrdRefAmt=0  ;未发药需审批不能退
	....if (myPhRet=0)&&(ConAppFlag=0) s CanRef="Y",CanRefQty=PBOQty,OrdRefAmt=PBOPatShare
	....if (PartRefFlag="N")&&(PBOQty=returnqty) s CanRef="Y",CanRefQty=PBOQty,OrdRefAmt=PBOPatShare  ;药品全退后可退
	....if (PartRefFlag="Y")&&(returnqty>0) s CanRef="Y",CanRefQty=returnqty,OrdRefAmt=(PBOUnitPrice*returnqty)  ;允许部分退有药品已退就可退
	
	...i ARCOrdType'="R" d
	....set CanRef=$case(OrdStat,"E":"N","V":"Y","D":"Y",:"")
	....if ConAppFlag=0  d
	.....if (PartRefFlag="N")&&(OrdStat="E") s CanRef="N",CanRefQty=0,OrdRefAmt=0		;医嘱执行后不可退	
	.....if (PartRefFlag="Y")&&(OrdStat'="E") s CanRef="Y",CanRefQty=PBOQty,OrdRefAmt=PBOPatShare	
	.....if (PartRefFlag="N")&&(OrdStat'="E") s CanRef="Y",CanRefQty=PBOQty,OrdRefAmt=PBOPatShare		
	....if ConAppFlag>0  d  ;需要审批
	.....s ApplyRefQty=##class(web.DHCOPBillRefundRequest).GetAlreadyReqQty(INVPRTRowid, AdmBill_"||"_PBO) ;申请数量
	.....if UnAuditOrdItem="Y"  d ;免审批
	......if (PartRefFlag="N")&&(OrdStat="E") s CanRef="N",CanRefQty=0,OrdRefAmt=0	;医嘱执行后不可退	
	......if (PartRefFlag="Y")&&(OrdStat'="E") s CanRef="Y",CanRefQty=PBOQty,OrdRefAmt=PBOPatShare	
	.....if UnAuditOrdItem="N" d
	......i ApplyRefQty=0 s CanRef="N",CanRefQty=0,OrdRefAmt=0  ;没审批不让退
	......i (PartRefFlag="N")&&(ApplyRefQty'=PBOQty) s CanRef="N",CanRefQty=0,OrdRefAmt=0  ;部分审批不让退
	......i (PartRefFlag="N")&&(ApplyRefQty=PBOQty) s CanRef="Y",CanRefQty=ApplyRefQty,OrdRefAmt=PBOPatShare   ;审批让退
	......i (PartRefFlag="Y")&&(ApplyRefQty'=0) s CanRef="Y",CanRefQty=ApplyRefQty,OrdRefAmt=(PBOUnitPrice*ApplyRefQty)       ;部分审批可退
    ...b ;kkk
    ...set ItmObj.OrdStuts=OrdStat
    ...set ItmObj.CanRefFlag=CanRef ;可退标志    
    ...set ItmObj.OrdRefSum=OrdRefAmt   
    ...set ItmObj.OrdRefQty=CanRefQty  ;可退数量
    ...set ItmObj.OrdStutsDesc=OrdStutsDesc
    ...set ItmObj.OrdSum=PBOPatShare
    ...set ItmObj.RecDepDesc=Reclocdesc   
    ...set PrtRefSum=PrtRefSum+OrdRefAmt  
	...d RecordListObj.ItemList.Insert(ItmObj)
	...d ItmObj.%Close()
	.Do OutputObj.RefList.Insert(RecordListObj)
	.Set RecordListObj.RefSum=PrtRefSum
	Set OutputObj.PayOrdCount=PayOrdCount
	
	if (PayOrdCount>0){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, "0", "获取可退记录成功")
	}Else{
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, "-5", "无自助可退记录")
	}
  	
  	Quit OutputXML
GetRefListInfoByPatientET
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator:zhenghao
/// CreatDate:2020-02-06
/// Desc: 提交退款请求
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).SendSelfRefundMsgToHis("<Request><TradeCode>4921</TradeCode><TradeChannel>JHZF</TradeChannel><OrdItemIdStr>797||11</OrdItemIdStr><HospitalID></HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000414</PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><StartDate></StartDate><EndDate></EndDate><Adm></Adm><OrderNo></OrderNo><RefAmt>2.7</RefAmt><PrtInvID>232825</PrtInvID><ExpStr></ExpStr></Request>").Read()
ClassMethod SendSelfRefundMsgToHis(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="SendSelfRefundMsgToHisET"
    Set err=0
    Set streamObj=##class(%Stream.GlobalCharacter).%New()
    Set InputObj=##class(DHCBILL.SelfPay.Entity.SendSelfRefundMsgToHis.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    set CardType=InputObj.CardType
    set SecrityNo=InputObj.SecrityNo
    Set TerminalId=InputObj.TerminalID
    Set PatNo=InputObj.PatientID 
    Set UserCode=InputObj.UserCode
    Set PrtInvID=InputObj.PrtInvID
    set RefAmt=InputObj.RefAmt
    Set Orderstr=InputObj.OrdItemIdStr
    set HospitalID=InputObj.HospitalID
    set TradeChannel=InputObj.TradeChannel
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.SendSelfRefundMsgToHis.Res.Response).%New()
    Set OutputXML=""  
    Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
    Set:UserCode'="" UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","用户代码传入有误")
		Quit OutputXML
	}
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo,CardType,SecrityNo,PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	if (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "患者信息传入有误")
		Quit OutputXML
	}
	/*
	Set AuthFlag=##class(DHCBILL.Common.DHCBILLCommon).CheckCompanyTrade(TradeChannel, "OP")  //取厂商业务授权
	If (AuthFlag=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -4, "此厂商未授权此业务")
		Quit OutputXML
	}
	*/
	Set AccountID=$p(PatInfo,"^",2)
	
    If (PrtInvID=""){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "退款发票不能为空")
		Quit OutputXML
    }
    
    If (Orderstr=""){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "退款医嘱不能为空")
		Quit OutputXML
    }
    
    If (+RefAmt=0){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "退款金额不能为空")
		Quit OutputXML
    }
    Quit:(+RefAmt=0) OutputXML
    set InsuRefFlag=..#InsuRefFlag
    set PartRefFlag=..#PartRefFlag
    set myINVPayMDR=""
    set myPayCode=""
    set myINVPMSub=$o(^DHCINVPRT(PrtInvID,"P",0))
    if (myINVPMSub'="") do
    .set myINVPayMDR=$p($g(^DHCINVPRT(PrtInvID,"P",myINVPMSub)),"^",1)
    .set myAccPLDR=$p($g(^DHCINVPRT(PrtInvID,"P",myINVPMSub)),"^",8)       ;IPM_AccPL_DR
    .set myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
    .if (myPayCode="CPP") do
    ..set myAccRowID=+myAccPLDR
    ..set myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
    ..set myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
    ..set myPFlag=$p($g(^DHCINVPRT(PrtInvID)),"^",3)       ;PRT_INVPrintFlag
    ..set myINVNo=$p($g(^DHCINVPRT(PrtInvID)),"^",14)      ;PRT_inv
    ..if ((myPFlag="P")&&(myINVNo="")) do
    ...set myColPFlag=1      //已经集中打印了
    ..quit:(myAccFlag="N") 
    If (myPayCode="CPP")&&(AccountID="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-19","患者无有效账户不能以院内卡支付")
		Quit OutputXML	
	}
    Set RefFlag=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckCanRef(PrtInvID,"OP",PartRefFlag,InsuRefFlag,myINVPayMDR)
    If (RefFlag=1){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","发票状态改变,现不可退")
		Quit OutputXML
    }
    
    Set PrtFlag=$p($g(^DHCINVPRT(PrtInvID)),"^",8)
    If (PrtFlag'="N") {
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","此发票已经退费或作废")
		Quit OutputXML
    }
    
    s myColPFlag=0
    s Refundflag=0
    s DHCINVPRTRDR=""    
    s flag=$p($g(^DHCINVPRT(PrtInvID)),"^",8)
    s PRTAcount=$p($g(^DHCINVPRT(PrtInvID)),"^",1)
    s PRTPatPay=$p($g(^DHCINVPRT(PrtInvID)),"^",16)
    s PRTUsr=$p($g(^DHCINVPRT(PrtInvID)),"^",21)    
    s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
    s PrtPapmiDR=$p($g(^DHCINVPRT(PrtInvID)),"^",15)
    s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
    s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
    s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)
    s PaSex=$p(^CT("SEX",PapmiSex),"^",2)    
    s myINSDivDR=$p($g(^DHCINVPRT(PrtInvID)),"^",30)  ;##class(web.UDHCJFBaseCommon).GetInsDivDRByPrtRowID(INVPRTRowid)
    s myYBPaySum=+$p($g(^DHCINVPRT(PrtInvID)),"^",31)    ;PRT_YBPaySum
    s myOPRoundSum=+$p($g(^DHCINVPRT(PrtInvID)),"^",37)  ;PRT_OPCRoundErr
    s myINSTypeDR=$p($g(^DHCINVPRT(PrtInvID)),"^",9)     ;PRT_InsType_DR    
    s Verifyflag=$p($g(^DHCINVPRT(PrtInvID)),"^",22)         ;审批标志
    s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)            ;OPFC_AppFlag    
    ;审批转换到接口类中
    s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(PrtInvID,"")
    s Verifyflag=$p(myrtn,"^",1)
    s myMixOE=$p(myrtn,"^",2)               ;混合医嘱标志
    s mySpecLFalg=$p($g(myrtn),"^",4)    
    s DHCINVPRTRDR=$p($g(^DHCINVPRT(PrtInvID)),"^",6)    
    
    i $d(^DHCINVPRT(0,"INITID",PrtInvID))'=0  s Refundflag=1
    Set gLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
    Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
    Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
    Set RecLoc=""
    If (Grup'="") {
    	Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup, gLoc)
    }
    If (HospitalID="") set HospitalID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区
    
    If ((PRTUsr=UserID)&&(DHCINVPRTRDR="")){
        Set RefundFlag="A"
    }Else{
        Set RefundFlag="S"
	}
    //Set RefSum=0 ;退费金额  需要根据医嘱算 并校验传入金额是否一致
    if (+RefAmt'=+PRTAcount)&&(PartRefFlag="N"){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","退款金额非法")
		Quit OutputXML
    }

    If (+RefAmt=+PRTAcount){
        Set RebillFlag="0"      
    }Else {
        Set RebillFlag="1"
    }
    Set PatPay=PRTAcount-RefAmt
    Set PrtInsType=$p($g(^DHCINVPRT(PrtInvID)),"^",9)
    set InsAdmSour=$p($g(^PAC("ADMREA",PrtInsType)),"^",9)   
    set PayMSub=$o(^DHCINVPRT(PrtInvID,"P",0))
    Set Paymode=$p(^DHCINVPRT(PrtInvID,"P",PayMSub),"^",1)  ;取发票默认支付方式   
    Set myPayinfo=Paymode_"^^^^"
    Set rtn=##class(web.udhcOPRefEditIF).RefundReceipt(PrtInvID,UserID,RefundFlag,Orderstr,PatPay,Grup,RebillFlag,gLoc,Paymode,"")
    If (+rtn'=0){
        Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2",+rtn_":his退费申请失败")
		Quit OutputXML
    }
    Set NewPRTRowID=$p(rtn,"^",2)
    Set StrikeRowID=$p(rtn,"^",3)
    ;插医保负记录接口
    set HisTradeno=""
    set ETPRowID=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrt(PrtInvID,"OP")    
    set PayCallModeflag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(Paymode)
    ;自费直接生成流水号(CPP的不生成),调用接口不考虑pos撤销重收
    if (ETPRowID'="")&&(+PayCallModeflag'=0)&&(+InsAdmSour=0){
	    set Adm=$p(^DHCBILLETP(ETPRowID),"^",43)
	    set ETPPayMode=$p(^DHCBILLETP(ETPRowID),"^",45)
	    Set TExpstr=UserID_"^"_Grup_"^"_gLoc_"^"_HospitalID_"^^OP"
		Set HisTradeNoInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradePay("",Adm,PrtInsType,"D",RefAmt,TExpstr)
		set IAPRowid=$p(HisTradeNoInfo,"^",2)   
		set HisTradeno=$p(HisTradeNoInfo,"^",3)  
		Set ETPTradeType=$p(^DHCBILLETP(ETPRowID),"^",25)
		Set RtnVal=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeConSub(IAPRowid, StrikeRowID, ETPTradeType)
		set OutputObj.RefHisTradeNo=HisTradeno
    }
    
    set AbortPrtObj=##class(DHCBILL.SelfPay.Entity.SendSelfRefundMsgToHis.Res.InvoiceList).%New()
    set AbortPrtObj.HISInsuInfo="" ;调用东华医保冲销参数
    set AbortPrtObj.InsuType=$p(^DHCINVPRT(StrikeRowID),"^",9)
    set AbortPrtObj.InsuFlag=+$p($g(^PAC("ADMREA",$p(^DHCINVPRT(StrikeRowID),"^",9))),"^",9)   
    set AbortPrtObj.Invoice=StrikeRowID
    set AbortPrtObj.InvoiceAmt=$p($g(^DHCINVPRT(StrikeRowID)),"^",1)
    set AbortPrtObj.InvoiceType="D"
    set AbortPrtObj.OutInsuInfo="" ;第三方调用医保冲销参数 
    d OutputObj.InvoiceList.Insert(AbortPrtObj)    
    if (NewPRTRowID'=""){ ;存在重收
        if (ETPRowID="")&&(+PayCallModeflag'=0)&&(+InsAdmSour=0){  ;自费预交金的直接确认完成
        	Set myExpStr=Grup_"^"_gLoc_"^"_AccountID_"^Y^F^^0^^"  
			Set Rtn=##class(web.DHCBillConsIF).CompleteCharge("7", UserID, InsType, NewPRTRowID, "0", "", myExpStr)
			set OutputObj.NextMethode="N"
			Set OutputObj.ResultMsg="退费成功"
        }
	    set NewPrtObj=##class(DHCBILL.SelfPay.Entity.SendSelfRefundMsgToHis.Res.InvoiceList).%New()
	    set NewPrtObj.HISInsuInfo=""  //调用东华医保参数
	    set NewPrtObj.InsuFlag=+$p($g(^PAC("ADMREA",$p(^DHCINVPRT(NewPRTRowID),"^",9))),"^",9)   
	    set NewPrtObj.InsuType=$p(^DHCINVPRT(NewPRTRowID),"^",9)
	    set NewPrtObj.Invoice=NewPRTRowID
	    set NewPrtObj.InvoiceAmt=$p($g(^DHCINVPRT(NewPRTRowID)),"^",1)
	    set NewPrtObj.InvoiceType="C"
	    set NewPrtObj.OutInsuInfo=""  
	    d OutputObj.InvoiceList.Insert(NewPrtObj)  
	} 
	if (+InsAdmSour'=0){
		set OutputObj.NextMethode="CommitInsuInfoComputeRefAmt"
		Set OutputObj.ResultMsg="退费申请成功."   
	}  
	if (+InsAdmSour=0)&&(ETPRowID'=""){
		set OutputObj.NextMethode="SaveSelfRefundInfo"
		Set OutputObj.ResultMsg="退费申请成功."   
	}
    Set OutputObj.ResultCode=0
    
    Do OutputObj.XMLExportToStream(.OutputXML,"Response")
    Do OutputObj.%Close()
    Quit OutputXML
SendSelfRefundMsgToHisET
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.SendSelfRefundMsgToHis.Res.Response).%New()
   	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// 提交医保退款信息 获取退款金额
ClassMethod CommitInsuInfoComputeRefAmt(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="CommitInsuInfoComputeRefAmtET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.CommitInsuInfo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set RefHisPrt=InputObj.RefHisPrt
    set NewHisPrt=InputObj.NewHisPrt
    set InsuPersonInfo=InputObj.InsuPersonInfo
    Set InsuCancel=InputObj.InsuCancel
    Set InsuDivide=InputObj.InsuDivide
    Set TradeOut=InputObj.TradeOut
   
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP","0"))
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CommitInsuInfo.Res.Response).%New() 	
 	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo,CardType,SecrityNo,PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	Set ErrCode=0
	ts
	
	if (InsuCancel="Y") {
		s InsuCancelRtn=""   ;预留写医保冲销负记录接口
	}
	If (InsuDivide'=""){
		;医保一次结算必须一张发票
		Set OPDivideInfo=##class(web.DHCINSUPort).InsuOPDivide(UserID,InvoiceNoStr,InsuPersonInfo,InsuDivide,TradeOut)
		If ((OPDivideInfo'="-1")&&(+OPDivideInfo'=-1)) Do
		.Set UpDataYBInfo=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(OPDivideInfo, "")
		.Set ErrCode=$p(UpDataYBInfo,"^",1)
		If (+OPDivideInfo=-1) {
	   		tro
	   		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-11","保存医保结算数据失败")
			Quit OutputXML
		}
	}
	;计算退款金额并生成退款his流水
	if (NewHisPrt'=""){
		//重收确认完成
		set InsType=$p(^DHCINVPRT(NewHisPrt),"^",9)
		Set Rtn=##class(web.DHCBillConsIF).CompleteCharge("7", UserID, InsType, NewHisPrt, "0", "", myExpStr)	
		set ErrCode=ErrCode++Rtn
	}
	set PayMSub=$o(^DHCINVPRT(RefHisPrt,"P",0))
    Set Paymode=$p(^DHCINVPRT(RefHisPrt,"P",PayMSub),"^",1)  ;取发票默认支付方式   
	set RefAmt=##class(DHCBILL.Common.DHCBILLCommon).GetRefundAmt("OP", RefHisPrt, NewHisPrt, Paymode, "") ;获取退款金额
	set ETPRowID=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrt(RefHisPrt, "OP")
	set TradeFlag="Y"
	set (HisTradeno, PlatformNo, RefHisTradeNo, TradeNoAmt)=""
	if (ETPRowID'=""){
		set ETPPayMode=$p(^DHCBILLETP(ETPRowID),"^",45)
		set HisTradeno=$p(^DHCBILLETP(ETPRowID),"^",32)
	    set PayCallModeflag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(ETPPayMode)
	    if +PayCallModeflag=0 set TradeFlag="N"
	    //全退直接生成流水号(CPP的不生成)
	    if (+PayCallModeflag'=0)&&(+RefAmt>0){
		    set Adm=$p(^DHCBILLETP(ETPRowID),"^",43)
		    Set TExpstr=UserID_"^"_Grup_"^"_gLoc_"^"_HospitalID_"^^OP"
			Set HisTradeNoInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradePay("", Adm, PrtInsType, "D", RefSum, TExpstr)
			Set ErrCode=ErrCode+$p(HisTradeNoInfo,"^",1)
			set IAPRowid=$p(HisTradeNoInfo,"^",2)
			set RefHisTradeNo=$p(HisTradeNoInfo,"^",3)  
			Set ETPTradeType=$p(^DHCBILLETP(ETPRowID),"^",25)
			Set RtnVal=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeConSub(IAPRowid, RefHisPrt_"^"_NewHisPrt, ETPTradeType)
	    	set ErrCode=ErrCode++RtnVal
	    }
	}
	If (+ErrCode'=0) {
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-12","提交医保退款信息失败")
		Quit OutputXML
	}
	
	if ($tl>0) tc
	
	set OutputObj.RefHisTradeNo=HisTradeno
	set OutputObj.PlatformNo=PlatformNo
	set OutputObj.HisTradeNo=RefHisTradeNo
	set OutputObj.TradeNoAmt=TradeNoAmt   ;
	set OutputObj.RefTradeAmt=RefAmt  	  ;退款金额
	set OutputObj.TradeFlag=TradeFlag
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","提交医保退款信息成功")
	
	Quit OutputXML
CommitInsuInfoComputeRefAmtET
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CommitInsuInfo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// 门诊退费回写
ClassMethod SaveSelfRefundInfo(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="SaveSelfRefundInfoET"
  	Set InputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID    
    Set InvoiceNoStr=InputObj.InvoiceNoStr
    set OrderNo=InputObj.OrderNo
    Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
    Set PayModeCode=PayDetailsObj.PayModeCode
    Set TradeChannel=PayDetailsObj.TradeChannel
    Set PayAmt=PayDetailsObj.PayAmt
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP","0"))
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Res.Response).%New()
 	
 	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set Papmi=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set Papmi=$p(PatInfo,"^",8)
	}
	if (Papmi="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "患者信息传入有误")
		Quit OutputXML
	}
	Set AccountID=$p(PatInfo,"^",2)
	If ((PayModeCode="CPP")&&(AccountID="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -19, "患者无有效账户不能以院内卡支付")
		Quit OutputXML
	}
	
	Set ErrCode=0
	ts
	
	Set myExpStr=Grup_"^"_GLoc_"^"_AccountID_"^Y^F^^0^^"
	set InsType=""
	set PrtLength=$L(InvoiceNoStr,"^")
	set PrtIndex=1
	do {
		Set PrtRowID=$p(InvoiceNoStr,"^",PrtIndex)
		Set PrtIndex=$i(PrtIndex)
		Set PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
		Continue:(PrtFlag'="TP")
		Set InsType=$p(^DHCINVPRT(PrtRowID),"^",9)
	}While((InsType="")&&(PrtIndex<PrtLength))
	
	Set Rtn=##class(web.DHCBillConsIF).CompleteCharge(7, UserID, InsType, InvoiceNoStr, "0", "", myExpStr)
	Set ErrCode=ErrCode+Rtn
	If (+ErrCode'=0){ 
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-13","HIS端重收确认完成失败")
		Quit OutputXML
	}
	;校验结算单
	If (OrderNo'="") {		
		Set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
		If (+ETPRowID=0) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-7","不存在的结算单号")
			Quit OutputXML
		}	
		Set ETPRc=$p(^DHCBILLETP(ETPRowID),"^",1)
		If (ETPRc="00") {
			Set TradeDate=$p($g(^DHCBILLETP(ETPRowID)),"^",21)
			Set:(TradeDate'="") TradeDate=$zd(TradeDate,3)
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","保存已完成，成功日期:"_TradeDate)
			Quit OutputXML
		}
		Set ExtTradeAmt=$p(^DHCBILLETP(ETPRowID),"^",23)
		If (+ExtTradeAmt'=+PayAmt){
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-20","传入金额不符!")
			Quit OutputXML
		}
		Set TradeType="OP"
		Set SaveExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_TradeChannel
		Set ErrCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceNoStr,.PayDetailsObj,SaveExpStr)
		//保存交易信息
		If (+ErrCode'=0){ 
			tro
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "保存退款信息失败")
			Quit OutputXML
		}
	}
	
	if ($tl>0) tc
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "回写退款信息成功")
	Quit OutputXML
SaveSelfRefundInfoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CommitInsuInfo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, "-99", "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Description: 提供给窗口调用的ws原路退的通道方法
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).RefundService()
ClassMethod RefundService(OrgETPRowID As %String, TradeType As %String, RefAmt As %String, ExpStr As %String)
{
	set RtnStr=""
	set CreatRtn=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).CreatRefPay(OrgETPRowID, TradeType, RefAmt, ExpStr)
	set Rtn=$p(CreatRtn,"^",1)
	quit:(+Rtn) "-1^"
	set IBPRowID=$p(CreatRtn,"^",2)
	set PayModeDr=$p(^DHCBILLETP(IBPRowID),"^",45)
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDr)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName'="") {
		set RtnStr=$classmethod(PMEClassName, "Refund", IBPRowID)
	}else {
		set RtnStr="-1"
	}
	
	quit RtnStr
}

/// w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AutoOPHandIn()
/// 提供给自助机调用的收费员结算方法（存在现金的开钞箱时）
ClassMethod AutoOPHandIn(UserCode)
{
	Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.HandInOutput).%New()
 	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set EndDate=+$h
	Set HospitalID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(GLoc) ;根据科室取院区 
	Set FootInfo=##class(web.DHCOPBillDailyHandin).GetStDate(UserID, EndDate,HospitalID, "U")
	Set $p(FootInfo,"^",3)=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	Set $p(FootInfo,"^",4)=$zt($p($h,",",2),1)
	Set $p(FootInfo,"^",5)="N"
	Set $p(FootInfo,"^",6)="N"
	Set myRtn=##class(web.DHCOPBillDailyHandin).Handin(UserID, HospitalID, FootInfo)
	Set ResultCode=$p(myRtn,"^",1)
	set ReportID=$p(myRtn,"^",2)
	if (ResultCode'=0){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ResultCode, "结算失败")
		Quit OutputXML
	}
	set OutputObj.ReportID=ReportID
	set (CashNum, CashSum)=0
	set sub=0 
	for  set sub=$o(^DHCOPInsFoot(ReportID,"P",sub)) q:sub=""  d
	.set PayM=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",1)
	.quit:(PayM'=1)
	.set PrtNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",3)    ;支付
	.set PrtSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",2)  
	.set PrtFNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",5)   ;退支付
	.set PrtFSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",4)
	.set PrdNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",11)   ;充值
	.set PrdSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",10)
	.set PRDFNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",13)  ;退充值
	.set PRDFSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",12)
	.set CardNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",15)  ;发卡
	.set CardSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",14)
	.set CardFNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",17) ;退卡
	.set CardFSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",16)
	.set EPDNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",19)   ;留观押金
	.set EPDSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",18)
	.set EPDFNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",21)  ;退留观
	.set EPDFSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",20) 
	.set GifNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",24)   ;代金卷
	.set GifSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",23)
	.set GifFNum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",26)  ;退代金卷
	.set GifFSum=$p(^DHCOPInsFoot(ReportID,"P",sub),"^",25)
	.set CashNum=PrtNum+PrtFNum+PrdNum+PRDFNum+CardNum+CardFNum+EPDNum+EPDFNum+GifNum+GifFNum
	.set CashSum=PrtSum+PrtFSum+PrdSum+PRDFSum+CardSum+CardFSum+EPDSum+EPDFSum+GifSum+GifFSum
	set OutputObj.CashNum=CashNum
	set OutputObj.CashSum=CashSum
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, ResultCode, "结算成功")
	
	Quit OutputXML
}

/// Creator: TianZJ
/// CreatDate: 2022-04-14
/// Description: 门诊导诊单查询接口
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).DirectInvoice("<Request><TradeCode></TradeCode><InvoiceNo>34517241</InvoiceNo><UserCode>DRZZJ</UserCode><ExpStr></ExpStr></Request>").Read()
ClassMethod DirectInvoice(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="DirectInvoiceET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set prtRowId=InputObj.InvoiceNo
    Set UserCode=InputObj.UserCode
	
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Res.Response).%New()
 	
	If (prtRowId=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "发票号为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set ExpStr=UserID_"^"_Grup_"^"_GLoc
	Set invoiceObj=##class(BILL.OP.BL.Direct.Interface).GetDirectInvoiceObj(prtRowId, ExpStr)
	Set headObj=invoiceObj.Head
	Set bodyObj=invoiceObj.Body
	Set PatNo=headObj.PatientID
	Set PatName=headObj.PatientName
	Set Sex=headObj.Sex
	Set Age=headObj.Age
	Set AdmReason=headObj.AdmReason
	Set Amount=headObj.Cost
	Set PrtUserCode=headObj.Guser
	Set PrtDate=headObj.PayTime
	Set EInvUrl=headObj.EInvUrl
	Set OutputObj.PatNo=PatNo
	Set OutputObj.PatName=PatName
	Set OutputObj.Age=Age
	Set OutputObj.AdmReason=AdmReason
	Set OutputObj.Amount=Amount
	Set OutputObj.UserCode=PrtUserCode
	Set OutputObj.PrtDate=PrtDate
	Set OutputObj.InvocieURL=EInvUrl
	
	set drugListObj=bodyObj.Drug.Druglist
	Set YpAdress=""
	for drugListIdx=1:1:drugListObj.Count() {
		Set drugItemObj=drugListObj.GetAt(drugListIdx)
		Set Guide=drugItemObj.Guide
		Set window=drugItemObj.Window         /// 发药窗口
		Set YpAdress=Guide_window
	}
	
	set DrugItemList=bodyObj.Drug.DrugItemList
	for DrugItemListIdx=1:1:DrugItemList.Count() {
		Set ItmObj1=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList).%New()
		set drugItemListObj=DrugItemList.GetAt(DrugItemListIdx)
		set grugItemName=drugItemListObj.ItemName
		set grugQty=drugItemListObj.Qty
		set grugUom=drugItemListObj.Uom
		set grugAmt=drugItemListObj.Amt
		Set ItmObj1.Adress=YpAdress
		Set ItmObj1.ArcType="药品"
		Set ItmObj1.Itm=grugItemName
		Set ItmObj1.Qty=grugQty
		Set ItmObj1.Amount=grugAmt
		Set ItmObj1.Unit=grugUom
		Do OutputObj.ItemLists.Insert(ItmObj1)
	}
	
	//2.化验
	set specimenListObj=bodyObj.Laboratory.SpecimenList
	for specimenListIdx=1:1:specimenListObj.Count() {
		Set ItmObj2=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList).%New()
		set specimenObj=specimenListObj.GetAt(specimenListIdx)
		set arcimDesc=specimenObj.ArcimDesc
		set specimenDesc=specimenObj.SpecimenDesc
		set guide=specimenObj.Guide
		set reportTime=specimenObj.ReportTime
		set prompt=specimenObj.Prompt
		Set ItmObj2.Adress=specimenDesc_guide
		Set ItmObj2.ArcType="化验"
		Set ItmObj2.Itm=arcimDesc
		Set ItmObj2.Qty=""
		Set ItmObj2.Amount=""
		Set ItmObj2.Unit=specimenDesc
		Do OutputObj.ItemLists.Insert(ItmObj2)
	}
	
	//3.治疗或其他
	set treatDeptListObj=bodyObj.Treatment.TreatDeptList
	for treatDeptListIdx=1:1:treatDeptListObj.Count() {
		set treatDeptObj=treatDeptListObj.GetAt(treatDeptListIdx)
		set deptName=treatDeptObj.DeptName
		set guide=treatDeptObj.Guide
		set treatItemListObj=treatDeptObj.TreatItemList
		for treatItemListIdx=1:1:treatItemListObj.Count() {
			Set ItmObj3=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList).%New()
			set treatItemObj=treatItemListObj.GetAt(treatItemListIdx)
			set itemName=treatItemObj.ItemName
			set qty=treatItemObj.Qty
			set uom=treatItemObj.Uom
			set amt=treatItemObj.Amt
			Set ItmObj3.Adress=deptName_guide
			Set ItmObj3.ArcType="治疗"
			Set ItmObj3.Itm=itemName
			Set ItmObj3.Qty=qty
			Set ItmObj3.Amount=amt
			Set ItmObj3.Unit=uom
			Do OutputObj.ItemLists.Insert(ItmObj3)
		}
	}
	
	//4.检查
	set examListObj=bodyObj.Examination.ExamList
	for examListIdx=1:1:examListObj.Count() {
		Set ItmObj4=##class(DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList).%New()
		set examItemObj=examListObj.GetAt(examListIdx)
		set itemName=examItemObj.ItemName
		set price=examItemObj.Price
		set qty=examItemObj.Qty
		set uom=examItemObj.Uom
		set amt=examItemObj.Amt
		set date=examItemObj.Date
		set ordDept=examItemObj.OrdDept
		set guide=examItemObj.Guide
		set deptPosition=examItemObj.DeptPosition
		set bookedNote=examItemObj.BookedNote
		set examNote=examItemObj.ExamNote
		Set ItmObj4.Adress=deptPosition_guide
		Set ItmObj4.ArcType="检查"
		Set ItmObj4.Itm=itemName
		Set ItmObj4.Qty=qty
		Set ItmObj4.Amount=amt
		Set ItmObj4.Unit=uom
		Do OutputObj.ItemLists.Insert(ItmObj4)
	}
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML

DirectInvoiceET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// Creator: TianZJ
/// CreatDate: 2022-08-15
/// Description: 线上退费审核接口
/// Debug: w ##Class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).AuditForAPP("<Request><InvID>1158972</InvID><UserCode>2651138</UserCode><AuditStr>505443||6^1</AuditStr><AuditReason>1</AuditReason><Loc>384</Loc></Request>")
ClassMethod AuditForAPP(InputXml As %String) As %String
{
	set $zt="AuditForPACSErr"
	set InputObj=##Class(DHCBILL.SelfPay.Entity.AuditOrders.Req.Request).%New()
	Do InputObj.XMLNodeDeserialize(.InputObj,"Request",InputXml)
	Set PrtRowid=InputObj.InvID
	Set UserCode=InputObj.UserCode
	Set AuditStr=InputObj.AuditStr
	Set AuditReason=InputObj.AuditReason
	Set AuditLoc=InputObj.Loc
	Set OutputObj=##Class(DHCBILL.SelfPay.Entity.AuditOrders.Res.Response).%New()
	If UserCode="" {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "操作员工号为空")
		Quit OutputXML
	}
	Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	If UserID="" {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "操作员不存在")
		Quit OutputXML
	}
	If AuditStr="" {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "没有退费审核的医嘱")
		Quit OutputXML
	}
	Set AuditInfoStr=""
	Set OrderStr=""
	For index=1:1:$l(AuditStr,"!") Do
	.Set OrderInfo=$p(AuditStr,"!",index)
	.Set OrdRowid=$p(OrderInfo,"^",1)
	.Set tmpPrtrowid=..GetInvByORORI(OrdRowid)  ;获取医嘱对应最新重结的医嘱
	.Set:(tmpPrtrowid'=PrtRowid) PrtRowid=tmpPrtrowid
	.Set RefQty=$p(OrderInfo,"^",2)
	.Set SingleAuditStr="^^^"_OrdRowid_"^"_UserID_"^^^^P^"_RefQty_"^^^"
	.if (AuditInfoStr="") set AuditInfoStr=SingleAuditStr
	.else  set AuditInfoStr=AuditInfoStr_$c(2)_SingleAuditStr
	.if (OrderStr="") set OrderStr=OrdRowid
	.else  set OrderStr=OrderStr_"^"_OrdRowid
	set AudiInfo=PrtRowid_"@@"_AuditInfoStr_"@@"_OrderStr
	;start PrtRowid_","_UserID_","_AudiInfo_","_AuditReason_","_AuditLoc
	set AuditRtn=##Class(web.DHCOPBillRefundRequestNew).VerifyByType(PrtRowid,UserID,AudiInfo,AuditReason,AuditLoc)
	;end AuditRtn
	If (AuditRtn=0) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "退费审核成功")
		Quit OutputXML
	}Else{
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -4, "退费审核失败")
		Quit OutputXML
	}

AuditForPACSErr
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AuditOrders.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// 由于退费重结会导致结算invrowid变化，根据oeoridr获取正常结算的invrowid
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).GetInvByORORI()
ClassMethod GetInvByORORI(oeoridr)
{
	s rtn=""
	q:oeoridr="" rtn
	q:'$d(^DHCPBi(0,"OEORI",oeoridr)) rtn
	s billno=0
	f  s billno=$o(^DHCPBi(0,"OEORI",oeoridr,billno)) q:billno=""  d
	.s billconinvdr=$o(^DHCBCI(0,"Bill",billno,""))
	.i billconinvdr'="" d 
	..s invrowid=$p(^DHCBCI(billconinvdr),"^",1)
	..s invFlag=$p(^DHCINVPRT(invrowid),"^",8)
	..s:invFlag="N" rtn=invrowid
	q rtn
}

/// CreatDate: 2023-02-01
/// Creator: TianZJ
/// Description: 记录自助机接口日志
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).LogMsg("7167","","","0000000024","TTPPAY","GetAdmByCardNo","2","<Request><TradeCode>4902</TradeCode><HospitalID>2</HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000024</PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2023-02-01</StartDate><EndDate>2023-02-01</EndDate><ExpStr></ExpStr></Request")
ClassMethod LogMsg(Adm, PrtRowId, PbRowID, PatNo, INMSGProductLine, INMSGYWLX, HospID, UserCode, String)
{
	Set DataObj=##class(%DynamicObject).%New()
	Do DataObj.%Set("INMSGAdmDr",Adm)
	Do DataObj.%Set("INMSGUserCode",UserCode)
	Do DataObj.%Set("INMSGInvPrtDr",PrtRowId)
	Do DataObj.%Set("INMSGPBDr",PbRowID)
	Do DataObj.%Set("INMSGRegNo",PatNo)	
	Do DataObj.%Set("INMSGProductLine",INMSGProductLine)
	Do DataObj.%Set("INMSGYWLX",INMSGYWLX)
	Do DataObj.%Set("INMSGHospDr",HospID)
	Do DataObj.%Set("INMSGMsg",String)
	Do DataObj.%Set("INMSGMsg",String)
	Do DataObj.%Set("INMSGDate",+$h)
	Set Json=DataObj.%ToJSON()
	Do ##Class(web.INSUMsgInfo).AddMsgInfoByJson(Json)
}

/// CreatDate: 2023-02-01
/// Creator: wangjian
/// Description: 获取当前可用票据
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).CheckInvoiceNo(^DHCTMP("DHCSelfPay")).Read()
ClassMethod CheckInvoiceNo(Input) As %Stream.GlobalCharacter
{
	Set $ZT="CheckInvoiceNoET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.CheckInvoiceNo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.CheckInvoiceNo.Res.Response).%New()
    //Set StartNo=InputObj.StartNo
    //Set EndNo=InputObj.EndNo
    Set UserCode=InputObj.UserCode
    Set InvoiceType=InputObj.InvoiceType
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	If (UserID="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","传入的UserCode系统中不存在")
		Quit OutputXML
	}
	
	Set InvoiceInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ReadReceiptNO(InvoiceType, UserID)

	Set CurrID=$p(InvoiceInfo,"^",1)
	
	Set OutputObj.StartNo=$p(InvoiceInfo,"^",2)
	Set OutputObj.EndNo=$p(InvoiceInfo,"^",3)
	Set OutputObj.InvoiceType=InvoiceType
	Set OutputObj.BatchNo=$p(InvoiceInfo,"^",5)
	Set OutputObj.CurrentNo=$p(InvoiceInfo,"^",4)
	If (+CurrID=0){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -109, "收费员无可用票据")
		Quit OutputXML
	}
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
CheckInvoiceNoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.CheckInvoiceNo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// CreatDate: 2023-02-01
/// Creator: wangjian
/// Description: 票据跳号
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).VoidInvoiceNo("<Request><TradeCode>4705</TradeCode><InvoiceType>O</InvoiceType><HospitalID></HospitalID><BatchNo>111060120</BatchNo><StartNo>0165552001</StartNo><EndNo>0165552500</EndNo><OutNo>0165552005</OutNo><VoidNum>1</VoidNum><UserCode>rwnqzzj01</UserCode></Request>")
ClassMethod VoidInvoiceNo(Input) As %Stream.GlobalCharacter
{
	set $zt="VoidInvoiceNoET"
	Set InputObj=##class(DHCBILL.SelfPay.Entity.VoidInvoiceNo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    
    Set BatchNo=InputObj.BatchNo
    Set StartNo=InputObj.StartNo
    Set EndNo=InputObj.EndNo
    Set OutNo=InputObj.OutNo
    Set VoidNum=InputObj.VoidNum
    Set UserCode=InputObj.UserCode
    Set InvoiceType=InputObj.InvoiceType
	Set HospitalID=InputObj.HospitalID
	
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.VoidInvoiceNo.Res.Response).%New()
    
    If (InvoiceType="") Set InvoiceType="O"
	
	Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	If (UserID="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入的UserCode系统中不存在")
		Quit OutputXML
	}
	
	Set InvoiceInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ReadReceiptNO(InvoiceType, UserID, HospitalID)

	Set CurrID=$p(InvoiceInfo,"^",1)
	
	Set StartInvNo=$p(InvoiceInfo,"^",2)
	Set EndInvNo=$p(InvoiceInfo,"^",3)
	Set ReceipNO=$p(InvoiceInfo,"^",4)
	Set Title=$p(InvoiceInfo,"^",5)
	If (BatchNo'=Title) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入票据批次与该用户可用票据批次不一致")
		Quit OutputXML
	}
	If (ReceipNO="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "当前用户没有此类型可用票据号")
		Quit OutputXML
	}
	If ((StartInvNo'=StartNo)||(EndInvNo'=EndNo)) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入起止票号与该用户可用起止号段不一致")
		Quit OutputXML
	}
	
	Set ReceiptLen=$l(ReceipNO) ;原始长度
	Set Node="0000000000"
	Set TMPVoidStNo=Node_ReceipNO
	Set TMPVoidEndNo=Node_(ReceipNO+VoidNum-1)
	
	Set VoidType=$case(InvoiceType,"I":"IP",:"OP")
	
	Set VoidStNo=$e(TMPVoidStNo,$l(TMPVoidStNo)-ReceiptLen+1,$l(TMPVoidStNo))
	Set VoidEndNo=$e(TMPVoidEndNo,$l(TMPVoidEndNo)-ReceiptLen+1,$l(TMPVoidEndNo))
	
	if ((VoidEndNo+1)'=+OutNo) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -7, "传入终端票号"_OutNo_"调整张数"_VoidNum_"后与系统用户票号将不符")
		Quit OutputXML	
	}
	
	Set UserGroup=$p(^SSU("SSUSR",UserID),"^",5)
	
	Set ExpStr=UserID_"^"_UserGroup_"^"_VoidStNo_"^"_"自助机调整票号"_"^"_VoidEndNo_"^"_VoidNum_"^"_EndInvNo_"^^"_VoidType_"^"_HospitalID
	Set RtnValue=##class(web.DHCBillSkipInvoice).SkipInvoice(ExpStr)
	Set rtn=$p(RtnValue,"^",1)
	
	Set InvoiceInfo=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ReadReceiptNO(InvoiceType,UserID)
	Set CurrID=$p(InvoiceInfo,"^",1)
	Set OutputObj.StartNo=$p(InvoiceInfo,"^",2)
	Set OutputObj.EndNo=$p(InvoiceInfo,"^",3)
	Set OutputObj.InvoiceType=InvoiceType
	Set OutputObj.BatchNo=$p(InvoiceInfo,"^",5)
	Set OutputObj.CurrentNo=$p(InvoiceInfo,"^",4)
	if (rtn){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, rtn, "跳号失败")
		Quit OutputXML
	}
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "跳号成功")
	Quit OutputXML
VoidInvoiceNoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.VoidInvoiceNo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// CreatDate: 2023-02-01
/// Creator: wangjian
/// Description: 票据打印通知
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayExp).ResultInvoiceNo(^DHCTMP("DHCSelfPay",4704,"2023-03-23 11:36:40.077996"))
ClassMethod ResultInvoiceNo(Input) As %Stream.GlobalCharacter
{
	Set $zt="ResultInvoiceNoET"
	
	Set InputObj=##class(DHCBILL.SelfPay.Entity.ResultInvoiceNo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.ResultInvoiceNo.Res.Response).%New()
    Set InvoiceType=InputObj.InvoiceType
    Set BatchNo=InputObj.BatchNo
    Set InvNo=InputObj.InvNo
    Set UserCode=InputObj.UserCode
    Set ResultFlag=InputObj.ResultFlag
    
    If (BatchNo'="") Set InvoiceNo=BatchNo_InvNo
    Else  Set InvoiceNo=InvNo
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	if (UserID="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "传入的UserCode系统中不存在")
		Quit OutputXML
	}
	if (InvoiceNo="") {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "传入发票号为空")
		Quit OutputXML
	}
	if (ResultFlag=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "传入打印结果不能为空")
		Quit OutputXML
	}
	Set UserGroup=$p(^SSU("SSUSR",UserID),"^",5)
	Set APIRowID=$o(^DHCINVPRTAPi(0,"INVNo",InvoiceNo,""),-1)
	Set PrintUser=$p(^DHCINVPRTAP(APIRowID),"^",5)
	Set PrintGroup=$p(^SSU("SSUSR",PrintUser),"^",5)
	if (UserID'=PrintUser) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "非自助机打印发票不能作废")
		Quit OutputXML
	}
	//打印是吧撤销打印
	if (ResultFlag="N"){
		Set HandIn=$p(^DHCINVPRTAP(APIRowID),"^",33)
		Set Flag=$p(^DHCINVPRTAP(APIRowID),"^",2)
		if (Flag'="N") {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "自助打印失败HIS作废发票成功")
			Quit OutputXML
		}
		Set rtnValue=##class(web.udhcOPRefEditIF).WriteOffAPI(APIRowID, UserID)
		Set rtn=$p(rtnValue,"^",1)
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, rtn, "自助打印失败，HIS作废发票"_$s((+rtn):"失败",1:"成功"))
		Quit OutputXML
	}Else {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "自助打印成功，HIS已确认")
		Quit OutputXML
	}
	
	Set OutputObj.InvoiceType=InvoiceType
	Set OutputObj.BatchNo=BatchNo
	Set OutputObj.InvNo=InvNo
	Set OutputObj.UserCode=UserCode
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "自助打印成功，HIS已确认")
	Quit OutputXML
ResultInvoiceNoET
	Set $zt=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.VoidInvoiceNo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ZERROR)
	Quit OutputXML
}

}
