/// 重症接口工厂
Class DHCCL.Factory.ICUInterfaceFactory Extends %RegisteredObject
{

/// 版本号
Parameter Version = "0.1.0";

/// 服务名  DHCCL.Implement.ICU.ICUArrangeService
Parameter ServiceName = "DHCCL.Implement.ICU.ICUArrangeService";

/// 获取重症数据服务
/// w ##class(DHCCL.Factory.ICUInterfaceFactory).GetService().GetVAEInfoByEpisodeID("530","2017-8-1","2017-8-2").Read()
/// w ##class(DHCCL.Factory.ICUInterfaceFactory).GetService().GetICUArrangeInfo("530").Read()
/// w ##class(DHCCL.Factory.ICUInterfaceFactory).GetService().GetICUQualityControlStat("2020-11-10","2022-11-11","210","4636").Read()
/// w ##class(DHCCL.Factory.ICUInterfaceFactory).GetService().GetICUQualityControlDetail(28,"","").Read()
ClassMethod GetService() As DHCCL.Interface.ICU.IICUInfoService
{
	set service=""
	set className=..#ServiceName
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		set service=$classmethod(className,"%New")
	}
	
	quit service
}

/// d ##class(DHCCL.Factory.ICUInterfaceFactory).Test()
ClassMethod Test()
{
	set service=##class(DHCCL.Factory.ICUInterfaceFactory).GetService()
	set xmlStream=service.GetICUQualityControlDetail(28,"","")
	set reader=##class(%XML.Reader).%New()
	do reader.OpenStream(xmlStream)
	do reader.Correlate("ICUQualityControlDetail","DHCCL.DTO.ICU.ICUQualityControlDetail")
	While (reader.Next(.object,.sc)) 
	{
		w object.PatName,",",object.RegNo,!
	}
}

}
