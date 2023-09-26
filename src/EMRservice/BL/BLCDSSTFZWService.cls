Class EMRservice.BL.BLCDSSTFZWService Extends %RegisteredObject
{

/// desc 获取同方知网初始化数据和需要的公共参数
/// input "AEpisodeID:4,AUserLocID:,AHospitalID:,AUserID:"
/// debug s obj = ##class(EMRservice.BL.BLCDSSTFZWService).GetInitData("AEpisodeID:4,AUserLocID:23,AHospitalID:2,AUserID:20")
ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
 	s resultStream = ##class(%GlobalBinaryStream).%New()
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	d resultStream.Write("{""success"":""1""")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""CDSSTFZW""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""}}")
	q resultStream
}

}
