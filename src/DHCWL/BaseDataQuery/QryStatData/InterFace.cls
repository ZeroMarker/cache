Class DHCWL.BaseDataQuery.QryStatData.InterFace Extends %RegisteredObject
{

ClassMethod GetLineRptStatDataJson(startDate As %String, endDate As %String, searchArgs As %Text = "", dataStartInx As %Integer, dataEndInx As %Integer, ByRef inParam) As %String
{
	k ^||DHCWLTEMP
	//1、根据报表名称创建一个报表统计对象
	s rptObj=##class(DHCWL.BaseDataQuery.QryStatData.FactoryOfQry).creator()
	q:'$ISOBJECT($g(rptObj)) $$$OK
	

	
	//3、创建一个输出接口
	s outCfg("start")=dataStartInx
	s outCfg("end")=dataEndInx
	s outCfg("delimiter")="&"
	s outputIF=##class(DHCWL.BaseDataQuery.QryStatData.ServOfOutIFJson).%New(.outCfg)
	
	
	//3、查询并输出统计数据
	d rptObj.QryRptStatData(startDate,endDate,outputIF,.inParam)
	

	
	
	k ^||DHCWLTEMP
	
	q ""
}

ClassMethod GetLineRptStatDataJsonHttp(ByRef inParam) As %String
{
	k ^||DHCWLTEMP
	
	s startDate=inParam("daterangeStart")
	s endDate=inParam("daterangeEnd")
	s start=inParam("start")
	s end=inParam("end")
	
	s ret=..GetLineRptStatDataJson(startDate,endDate,"",start,end,.inParam)

	
	q ""
}

}
