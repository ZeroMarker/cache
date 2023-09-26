/// ICU对外服务接口
Class DHCCL.Interface.ICU.IICUInfoService [ Abstract ]
{

/// 获取重症监护信息	
Method GetICUArrangeInfo(EpisodeID As %String) As %GlobalCharacterStream
{
}

/// 院感业务（呼吸机 VAE 监测）与重症系统对接，完成患者呼吸机 PEEP、FiO2 数据回传到院感系统
Method GetVAEInfoByEpisodeID(EpisodeID As %String, DateFrom As %String, DateTo As %String) As %GlobalCharacterStream
{
}

/// 获取重症质控指标信息
Method GetICUQualityControlStat(startDate As %String, endDate As %String, locIdStr As %String, userId As %String, version As %String = "") As %GlobalCharacterStream
{
}

/// 获取重症病人质控指标详细信息
Method GetICUQualityControlDetail(icuaId As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %GlobalCharacterStream
{
}

}
