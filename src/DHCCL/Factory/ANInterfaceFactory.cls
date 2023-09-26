/// 麻醉接口工厂
Class DHCCL.Factory.ANInterfaceFactory Extends %RegisteredObject
{

/// 版本号
Parameter Version = "0.1.0";

/// 服务名  DHCCL.Implement.ANNew.OperScheduleService  或 DHCCL.Implement.ANOld.OperArrangeService 
Parameter ServiceName = "DHCCL.Implement.ANNew.OperScheduleService";

/// 获取麻醉数据服务
/// w ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaQualityControlDetail(1,"","").Read()
/// w ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaOperThemeInfoJson(1,"","")
ClassMethod GetService() As DHCCL.Interface.AN.IOperInfoService
{
	set service=""
	set className=..#ServiceName
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		set service=$classmethod(className,"%New")
	}
	
	quit service
}

/// d ##class(DHCCL.Factory.ANInterfaceFactory).Test()
ClassMethod Test()
{
	set service=##class(DHCCL.Factory.ANInterfaceFactory).GetService()
	set xmlStream=service.GetAnaQualityControlDetail(1,"","")
	set reader=##class(%XML.Reader).%New()
	do reader.OpenStream(xmlStream)
	do reader.Correlate("AnaQualityControlDetail","DHCCL.DTO.AN.AnaQualityControlDetail")
	While (reader.Next(.object,.sc)) 
	{
		w object.PatName,",",object.PatGender,!
	}
}

}
