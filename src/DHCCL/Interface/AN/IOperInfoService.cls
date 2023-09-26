/// 手术信息服务对外接口
Class DHCCL.Interface.AN.IOperInfoService [ Abstract ]
{

/// 获取手术信息
Method GetOperInfoByEpisodeID(EpisodeID As %String) As %GlobalCharacterStream
{
}

/// 获取质控指标信息
Method GetAnaQualityControl(startDate As %String, endDate As %String, anaDeptId As %String, userId As %String, Version As %String = "") As %GlobalCharacterStream
{
}

/// 获取麻醉质控指标病人详细信息
Method GetAnaQualityControlDetail(OperScheduleID As %String = "", EpisodeID As %String = "", DischargeDate As %String = "")
{
}

/// 获取麻醉质控接口(Json格式)
Method GetAnaQualityControlJson(OperScheduleID As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %String
{
}

/// 获取麻醉主题接口(Json格式)
Method GetAnaOperThemeInfoJson(OperScheduleID As %String = "", EpisodeID As %String = "", OperDate As %String = "") As %String
{
}

}
