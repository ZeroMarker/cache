Class EMRservice.BL.BLCDSSWFService Extends %RegisteredObject
{

ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
	s resultStream = ##class(%GlobalBinaryStream).%New()
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	d resultStream.Write("{""success"":0,""message"":""维护万方URL地址""}")
	s CDSSUrl = ..getCDSSUrl()
	Q:CDSSUrl="" resultStream
	s cdssType = ##class(EMRservice.BL.BLCDSSTool).GetCDSSTool()
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1""")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""CDSSWF""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""")
	d resultStream.Write(",""CDSSUrl"":"""_CDSSUrl_"""}}")
	q resultStream
}

ClassMethod getCDSSUrl()
{
	s $ZT="ERROR"
	s (Id,CDSSUrl,paramter)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," CDSSWF"," 1",Id))
	q:Id="" CDSSUrl	
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	q:paramter="" CDSSUrl
	s CDSSUrl = paramter //"http://10.10.10.46/NoPlugnewApi.html?keys="
	q CDSSUrl
ERROR
	q ""
}

}
