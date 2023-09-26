/// creator:guorongyong
/// date:2020-06-15
/// desc:和东华医为内部系统的接口类【主要调用其他产品组的接口】，仅预约挂号系统相关，本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.InvokeOPAdm Extends %RegisteredObject
{

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript:   取病人预检号别信息【24小时内的号别】
/// InPut:      病人ID
/// OutPut:     号别ID^科室ID^分级ID^分诊日期^分诊时间^绿色通道^抢救病区ID||号别ID^科室ID^分级ID^分诊日期^分诊时间^绿色通道^抢救病区ID
/// w ##Class(DHCDoc.Interface.Inside.InvokeOPAdm).GetPatChkLvCareInfo
ClassMethod GetPatChkLvCareInfo(PatientID As %String, Admflag As %String = "1") As %String
{
	Q ##Class(web.DHCEMInterfaceCom).GetPatChkLvCareInfo(PatientID, Admflag)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript:   挂号成功后回调函数，修改病人就诊表分诊内容
/// InPut:      EmPCLvID-分级ID, EpisodeID-就诊ID，RbResourceId-资源号别
/// OutPut:     0-成功，其他-失败
/// w ##Class(DHCDoc.Interface.Inside.InvokeOPAdm).UpdateEmChk
ClassMethod UpdateEmChk(EmPCLvID As %String, EpisodeID As %String, RbResourceId As %String) As %String
{
	Q ##Class(web.DHCEMInterfaceCom).UpdateEmChk(EmPCLvID, EpisodeID, RbResourceId)
}

/// Creater: 谭吉善
/// CreateDate: 2023-02-24
/// Descript:   获取电子病历签名状态
/// InPut:      EpisodeID-就诊ID
/// OutPut:     签名描述
/// w ##class(DHCDoc.Interface.Inside.InvokeOPAdm).GetMZRecordStatus(,,)
ClassMethod GetMZRecordStatus(EpisodeID As %String) As %String
{
	s MZRecordStatus=##class(EMRservice.InterfaceService.EMROPRecord).GetMZRecordStatus(EpisodeID)
	s MZRecordStatus=$CASE(MZRecordStatus,1:"待签",2:"已签",:"空")
	q MZRecordStatus
}

}
