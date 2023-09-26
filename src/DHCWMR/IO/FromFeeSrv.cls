/// 名称: DHCWMR.IO.FromFeeSrv
/// 描述: 计费提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-10-12
Class DHCWMR.IO.FromFeeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  取收费项单价（From计费组）
/// Input：       aTarItemID : 收费项ID
///               aDate : 日期
///               aHospID : 医院ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromFeeSrv).GetItmPrice("1000","","")
ClassMethod GetItmPrice(aTarItemID As %String, aDate As %String, aHospID As %String) As %String
{
	New (aTarItemID,aDate,aHospID)
	Set return=##class(web.UDHCJFPRICE).GetItmPrice(aTarItemID,aDate,"","","",aHospID,"")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  收费接口（From计费组）
/// Input：       aPrtInfo : 收费数据
///               aDtlInfo : 明细数据
///               aHospID : 医院ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromFeeSrv).InsertMedical("","","")
ClassMethod InsertMedical(aPrtInfo As %String, aDtlInfo As %String, aHospID As %String) As %String
{
	New (aPrtInfo,aDtlInfo,aHospID)
	Set return=##class(web.DHCIPBillMedicalInterface).InsertMedical(aPrtInfo,aDtlInfo,aHospID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  退费接口（From计费组）
/// Input：       aInvprtID : 发票ID
///               aUserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromFeeSrv).Refund("","")
ClassMethod Refund(aInvprtID As %String, aUserID As %String) As %String
{
	New (aInvprtID,aUserID)
	Set InvNo=$p($g(^DHCINVPRTMEDICAL(+aInvprtID)),"^",3)
	Set return=##class(web.DHCIPBillMedicalInterface).Refund(InvNo,aUserID)
	Quit return
}

/// Creator：     maxp
/// CreatDate：   2016-05-04
/// Description:  取用户当前可用发票号（From计费组）
/// Input：       aUserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromFeeSrv).GetReceiptNOByUser(9)
ClassMethod GetReceiptNOByUser(aUserID As %String, aHospID As %String) As %String
{
	New (aUserID,aHospID)
	Set return=""
	Quit:(aHospID="")||(aUserID="") return
	
	Set ExpStr="^^"_aHospID
	Set return=##class(web.udhcOPBillIF).ReadReceiptNO(aUserID,"",ExpStr)
	;##class(web.udhcOPBill).ReadReceiptNO(aUserID)
	Set return=$p(return,"^",2)
	Quit return
}

}
