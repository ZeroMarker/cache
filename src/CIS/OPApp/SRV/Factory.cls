Class CIS.OPApp.SRV.Factory Extends %RegisteredObject
{

/// 版本号
Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.AN.SRV.System";

/// 已实现系统
Parameter AvailableSystem = "ENS;OPApp";

/// 获取数据传输服务参数
/// w ##class(CIS.OPApp.SRV.Factory).GetDataTransServiceOptions("ENS").%ToJSON()
ClassMethod GetDataTransServiceOptions(systemName As %String) As %DynamicObject
{
	set system=..GetSystem(systemName)
	set service={}
	if system.%Get("RowId")'=""
	{
		set service.Vendor=system.Vendor
		set rowId=$o(^CF.AN.DataTransServiceI("ISys",system.%Get("RowId"),""))
		if ##class(CF.AN.DataTransService).%ExistsId(rowId)
		{
			set obj=##class(CF.AN.DataTransService).%OpenId(rowId)
			set service.RowId=rowId
			set service.ConnectProtocol=obj.ConnectProtocol
			set service.Server=obj.ServerAddress
			set service.Client=obj.ClientAddress
			set service.Active=obj.Active
		}
	}
	
	quit service
}

/// 获取信息系统
ClassMethod GetSystem(systemName As %String) As %DynamicObject
{
	set rowId=$o(^CF.AN.SystemI("IName"," "_systemName,""))
	set system={}
	if ##class(CF.AN.System).%ExistsId(rowId)
	{
		set obj=##class(CF.AN.System).%OpenId(rowId)
		set system.RowId=rowId
		set system.Name=obj.Name
		set system.Vendor=obj.Vendor
		set system.Description=obj.Description
	}
	quit system
}

/// 获取ENS数据传输服务
ClassMethod GetENSService() As CIS.OPApp.SRV.Interface.IENSService
{
	set service="",systemName="ENS"
	set options=..GetDataTransServiceOptions(systemName)
	if options.%Get("RowId")'=""
	{
		set className=..#PackageName_"."_systemName_"."_options.Vendor
		if ##class(%ClassDefinition).%ExistsId(className)
		{
			set service=$classmethod(className,"%New")
			do $method(service,"Init",options)
		}
	}
	else
	{
		set service=##class(CIS.OPApp.SRV.Interface.IENSService).%New()
	}
	quit service
}

/// 获取HIS数据传输服务
ClassMethod GetHISService() As CIS.OPApp.SRV.Interface.IHISService
{
	set service="",systemName="HIS"
	set options=..GetDataTransServiceOptions(systemName)
	if options.%Get("RowId")'=""
	{
		set className=..#PackageName_"."_systemName_"."_options.Vendor
		if ##class(%ClassDefinition).%ExistsId(className)
		{
			set service=$classmethod(className,"%New")
			do $method(service,"Init",options)
		}
	}
	else
	{
		set service=##class(CIS.OPApp.SRV.Interface.IHISService).%New()
	}
	quit service
}

/// 获取LIS数据传输服务
ClassMethod GetLISService() As CIS.OPApp.SRV.Interface.ILISService
{
	set service="",systemName="LIS"
	set options=..GetDataTransServiceOptions(systemName)
	if options.%Get("RowId")'=""
	{
		set className=..#PackageName_"."_systemName_"."_options.Vendor
		if ##class(%ClassDefinition).%ExistsId(className)
		{
			set service=$classmethod(className,"%New")
			do $method(service,"Init",options)
		}
	}
	else
	{
		set service=##class(CIS.OPApp.SRV.Interface.ILISService).%New()
	}
	quit service
}

/// 获取AIS数据传输服务
ClassMethod GetAISService() As CIS.OPApp.SRV.Interface.IAISService
{
	set service="",systemName="AIS"
	set options=..GetDataTransServiceOptions(systemName)
	if options.%Get("RowId")'=""
	{
		set className=..#PackageName_"."_systemName_"."_options.Vendor
		if ##class(%ClassDefinition).%ExistsId(className)
		{
			set service=$classmethod(className,"%New")
			do $method(service,"Init",options)
		}
	}
	else
	{
		set service=##class(CIS.OPApp.SRV.Interface.IAISService).%New()
	}
	quit service
}

}
