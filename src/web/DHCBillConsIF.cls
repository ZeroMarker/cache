Class web.DHCBillConsIF Extends BILL.COM.Abstract
{

/// ClsType 表示系统的版本号码
/// 此类抽象为接口?用来版本控制
ClassMethod GetBillData(billStr As %String, ordItmIdStr As %String, insTypeId As %String, SFlag As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.DHCBillCons).GetBillData(billStr, ordItmIdStr, insTypeId, SFlag, ExpStr)
	quit myrtn
}

ClassMethod KTMP() As %String
{
	do ##class(DHCBillCons).KTMP()
	quit 0
}

ClassMethod ParDataToBill(RecInvCount As %String, PrintCount As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.DHCBillCons).ParDataToBill(RecInvCount, PrintCount)
	quit myrtn
}

ClassMethod ReBill(userno As %String, PARowid As %String, myPayor As %String, myPatPaySum As %String, rbPayinfo As %String, SFlag As %String, OldINVRID As %String = "", ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCBillCons12).ReBill(userno, PARowid, myPayor, myPatPaySum, rbPayinfo, SFlag, OldINVRID, ExpStr)
	quit myrtn
}

/// 更新发票表为医保
ClassMethod UpdateINVPRTYBInfo(YBInfo As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.DHCBillCons11).UpdateINVPRTYBInfo(YBInfo)	
	quit myrtn
}

/// Debug: w ##class(web.DHCBillConsIF).DelINVPRTForYB("237157","122^5")
ClassMethod DelINVPRTForYB(INVStr As %String, ExpStr As %String) As %String
{
	set ^TMP("DelINVPRTForYB")=$lb(INVStr, ExpStr)
	set myrtn=##class(web.DHCBillCons11).DelINVPRTForYB(INVStr, ExpStr)	
	quit myrtn
}

/// Description: 目的是为了给每张发票打入一个收入，找零和舍入的节点值
ClassMethod BuildOPCINVRound(PreSum As %String, ChargeSum As %String, RoundSum As %String, PayModeDR As %String, ExpStr As %String) As %String
{
	set rtn=##class(web.DHCBillCons1).BuildOPCINVRound(PreSum, ChargeSum, RoundSum, PayModeDR, ExpStr)
	quit 0
}

/// Description: 舍入函数接口
/// Debug: w ##class(web.DHCBillConsIF).OPCRound(2.12, 2, "")
ClassMethod OPCRound(MSum As %String, HospId As %String, ExpStr As %String) As %String
{
	set PayModeID=$p(ExpStr,"^",1)
	set PayModCode=$s((PayModeID'=""):$p($g(^CT("CTPM",PayModeID)),"^",1),1:"CASH")
	quit:(PayModCode'="CASH") MSum
	
	set OPFCRowID=##class(web.DHCOPConfig).GetSOPFCfgId(HospId)
	quit:(+OPFCRowID=0) MSum
	
	set RoundNum=+$p($g(^DHCSOPFCON(OPFCRowID)),"^",16)
	quit:(RoundNum=0) MSum
	
	set myrtn=##class(web.DHCOPCommonFunLib).Round(MSum, 1, RoundNum)
	set myrtn=$fn(myrtn,"",2)

	quit myrtn
}

/// Creator: Lid
/// CreatDate: 2012-03-27
/// Description: 门诊收费确认
ClassMethod CompleteCharge(CallFlag As %String, Guser As %String, InsTypeDR As %String, PrtRowIDStr As %String, SFlag As %String, OldPrtInvDR As %String, ExpStr As %String, PayInfo As %String = "")
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set myrtn=0
	}else{
		set myrtn=##class(web.DHCBillCons12).CompleteCharge(CallFlag,Guser, InsTypeDR, PrtRowIDStr, SFlag, OldPrtInvDR, ExpStr,PayInfo)
	}
	quit myrtn
}

/// Creator: ZhYW
/// CreatDate: 2020-05-28
/// Description: 判断是否打印票据
/// Input: insTypeId:PAC_AdmReason.RowId
///        groupId:SS_Group.RowId, 
///        hospId:CT_Hospital.RowId
///        printInvFlag:(N/Y:此参数优先级最高,为N时不打印,Y时再根据其他配置判断是否打印)
/// Return: prtFlag(=0:打印, =1:不打印)
/// Debug: w ##class(web.DHCBillConsIF).CheckPrtFlag("3", "46", 2, "Y")
ClassMethod CheckPrtFlag(insTypeId As %String, groupId As %String, hospId As %String, printInvFlag As %String) As %String
{
	set myrtn=##class(web.DHCBillCons).CheckPrtFlag(insTypeId, groupId, hospId, printInvFlag)
	quit myrtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 读取发票负记录的支付方式列表
/// Debug: w ##class(web.DHCBillConsIF).ReadINVPayModeNew()
ClassMethod ReadINVPayModeNew(prtRowId As %String) As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0) {
		set myrtn=""
	}else {
		set myrtn=##class(web.UDHCINVPRT).ReadINVPayModeNew(prtRowId)
	}
	quit myrtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 计算误差金额
ClassMethod GetManyInvRoundErrAmt(prtRowIdStr As %String, amt As %String, expStr As %String = "") As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.DHCBillCons12).GetManyInvRoundErrAmt(prtRowIdStr, amt, expStr)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 获取发票的自费金额
/// Debug: w ##class(web.DHCBillConsIF).GetPatSelfPayAmt(1847)
ClassMethod GetPatSelfPayAmt(prtRowIdStr As %String) As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.DHCBillCons12).GetPatSelfPayAmt(prtRowIdStr)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 获取发票金额信息
/// Debug: w ##class(web.DHCBillConsIF).GetInvAmtData(1848)
ClassMethod GetInvAmtData(prtRowIdStr As %String) As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.DHCBillCons12).GetInvAmtData(prtRowIdStr)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 获取发票金额信息
/// Debug: w ##class(web.DHCBillConsIF).GetInvPayMAmtData(1847)
ClassMethod GetInvPayMAmtData(prtRowIdStr As %String, flag As %String = "") As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.DHCBillCons12).GetInvPayMAmtData(prtRowIdStr, flag)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-06-02
/// Description: 获取部分退费新发票的支付方式信息
/// Debug: w ##class(web.DHCBillConsIF).GetNewInvPayMList(2982, "", 2987, 1)
ClassMethod GetNewInvPayMList(oldPrtRowId As %String, strikeRowId As %String, prtRowId As %String, refundPayMode As %String = "") As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.udhcOPRefEdit1).GetNewInvPayMList(oldPrtRowId, strikeRowId, prtRowId, refundPayMode)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-06-10
/// Description: 获取发票对应的就诊
/// Debug: w ##class(web.DHCBillConsIF).GetAdmByPrtRowId(2119)
ClassMethod GetAdmByPrtRowId(prtRowIdStr As %String) As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		set rtn=""
	}else {
		set rtn=##class(web.DHCBillCons12).GetAdmByPrtRowId(prtRowIdStr)
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-06-18
/// Description: 根据发票支付方式判断是否打印发票
///              当且仅当所有支付方式都配置不打印发票时，这张发票不打印
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: prtFlag(=0:打印, =1:不打印)
/// Debug: w ##class(web.DHCBillConsIF).CheckPrtFlagByGSPM(3018)
ClassMethod CheckPrtFlagByGSPM(prtRowId As %String) As %String
{
	set myrtn=##class(web.DHCBillCons12).CheckPrtFlagByGSPM(prtRowId)
	quit myrtn
}

/// Creator: ZhYW
/// CreatDate: 2020-08-17
/// Description: 校验结算支付方式是否是配置的支付方式
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospial.RowId,
///        typeFlag: "DEP"(预交金)
/// 	  			 "FEE"(收费	-- 默认)
/// 				 "REG"(挂号)
/// 				 "REF"(退费)
///        insTypeId:PAC_AdmReason.RowId, payInfo:支付方式串
/// Return: 0:是, 139:否
/// Debug: w ##class(web.DHCBillConsIF).CheckPayMode(122, 2, 1, "1^2^4"_$c(2)_"5^2^4")
ClassMethod CheckPayMode(groupId As %String, hospId As %String, typeFlag As %String, insTypeId As %String, payInfo As %String) As %String
{
	set myrtn=##class(web.DHCBillCons12).CheckPayMode(groupId, hospId, typeFlag, insTypeId, payInfo)
	quit myrtn
}

/// Creator: ZhYW
/// CreatDate: 2020-10-09
/// Description: 将业务表关联到第三方支付订单表
/// Input: prtRowIdStr:DHC_INVPRT.RowId串, sFlag:收退标识(0:收, 1:退)
/// Return: rtn(=0:成功, <>0:失败)
/// Debug: w ##class(web.DHCBillConsIF).RelationHISToOrder()
ClassMethod RelationHISToOrder(prtRowIdStr As %String, sFlag As %String) As %String
{
	set myrtn=##class(web.DHCBillCons12).RelationHISToOrder(prtRowIdStr, sFlag)
	quit myrtn
}

}
