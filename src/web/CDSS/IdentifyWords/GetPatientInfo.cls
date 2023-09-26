/// Creator:丁亚男
/// CreatDate:2021-08-16
/// Description:获取有用的患者信息数据
Class web.CDSS.IdentifyWords.GetPatientInfo Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-08-16
/// Description:获取患者信息
/// Table: 
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI("DM000218^DM000218^1^住院^^^^心内科一^1","年龄")
ClassMethod DealDataByPatientEnumI(PatientInfo As %String, ItemClass As %String) As %String
{
	s info=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_ItemClass)
	if (info'="")&&($E(info,1,1)'="[")
	{
		s info="["_info_"]"
	}
	
	q info
}

}
