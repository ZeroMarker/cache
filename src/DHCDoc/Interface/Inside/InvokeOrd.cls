/// creator:宋春莉
/// date:2020-08-04
/// desc:和东华医为内部系统的接口类【主要调用其他产品组的接口】，仅医嘱系统相关，本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.InvokeOrd Extends %RegisteredObject
{

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  获取出院医嘱串
/// Table:        
/// Input:       Code:(dischargeNeedArcim 出院医嘱串,deathDischargeNeedArcim 死亡医嘱串) HospID:院区ID
/// Return:      0：非皮试用法医嘱 1：皮试用法医嘱
/// Others:      w ##class(DHCDoc.Interface.Inside.InvokeOrd).GetDischargeNeedArcim
ClassMethod GetDischargeNeedArcim(Code As %String, HospID As %String) As %String
{
	Q ##class(Nur.Interface.OutSide.Order).GetDischargeNeedArcim(Code,HospID)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  判断医生是否可以办理转科/出院
/// Table:        
/// Input:       EpisodeID:就诊ID DoctorType
/// Return:      Ret^需关注项描述1^需关注项描述2…. 1、	Ret=0且需关注描述项为空，不存在需关注项。2、	Ret=0且需关注描述项不为为空，存在需关注提示但不强制处理。 3、	Ret=1存在需关注项描述控制不能转科/出院。
/// Others:      w ##class(DHCDoc.Interface.Inside.InvokeOrd).GetAbnormalOrder
ClassMethod GetAbnormalOrder(EpisodeID As %String, DoctorType = "DOCTOR", TransType = "T", AllDiagType As %String = "Y", isCheckOthertAbnormal As %String = "N", isDeathDiagFlag As %String = "N") As %String
{
	Q ##class(Nur.Interface.OutSide.Order).GetAbnormalOrder(EpisodeID,DoctorType,TransType,AllDiagType,isCheckOthertAbnormal,isDeathDiagFlag)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 获取执行记录发药状态
/// InPut: 执行记录id
/// OutPut: 0：未发药；1：发药;2:部分退药;3:全部退药
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetOreStatus
ClassMethod GetOreStatus(OrdExeRowid As %String) As %String
{
	Q ##class(web.DHCSTCOMMONSRV).GetOreStatus(OrdExeRowid)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 获取执行记录发药数量/退药数量
/// InPut: 执行记录id
/// OutPut: 发药数量^退药数量
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetDispReturnQty
ClassMethod GetDispReturnQty(OrdExeRowid As %String) As %String
{
	Q ##class(web.DHCSTCOMMONSRV).GetDispReturnQty(OrdExeRowid)
}

}
