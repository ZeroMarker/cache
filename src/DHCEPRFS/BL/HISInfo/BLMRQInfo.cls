Class DHCEPRFS.BL.HISInfo.BLMRQInfo [ ClassType = "", ProcedureBlock ]
{

/// 从医政组首页数据池取数据
/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm()
ClassMethod GetArrayOfDataByAdm(AEpisodeID As %String) As %ArrayOfDataTypes
{
	
	// Creator：     zhufei
	// CreatDate：   2016-07-29
	// Description:  根据代码取病案首页信息
	// Table：       DHCMRQ.MR.DataMaster
	// Input：       AppType : 应用类型
	//               HospCode : 组织机构代码
	//               EpisodeID : 就诊号
	//               Code : 字段代码
	// arr：      返回String
	// Set arr=##Class(DHCMRQ.IO.GetDataByMed).GetArrayOfDataByAdm("Coding","41858519X",190110)
	// w arr.GetAt("P00060000")
	
	//AppType: Coding - 编目后，Clinic - 电子病历原始数据
	//HospCode: 河南周口市中心医院 - 41858519X
	s arr=##Class(DHCMRQ.IO.GetDataByMed).GetArrayOfDataByAdm("Coding","41858519X",AEpisodeID)
	q arr
}

}
