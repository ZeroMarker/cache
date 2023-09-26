Class CIS.OPApp.SRV.Interface.IService [ Abstract ]
{

/// 版本
Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.OPApp.SRV";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 连接协议，支持WebService;HTTP;DirectConnect
Property ConnectProtocol As %String;

/// 服务端
Property Server As %String;

/// 客户端
Property Client As %String;

/// 是否有效
Property Active As %String;

/// 适配器
Property Adaptor As CIS.OPApp.SRV.Interface.IAdaptor;

/// 实例化Adaptor
Method Init(options As %DynamicObject) As %Status
{
	set ##this.ConnectProtocol=options.%Get("ConnectProtocol")
	set ##this.Server=options.%Get("Server")
	set ##this.Client=options.%Get("Client")
	set ##this.Active=options.%Get("Active")
	do ##this.InitAdaptor()
	
	quit $$$OK
}

/// 实例化Adaptor
Method InitAdaptor() As %Status
{
	set className=##this.#PackageName_"."_##this.ConnectProtocol_".Adaptor"
	set adaptor=""
	set options={}
	set options.Client=##this.Client
	if ##class(%ClassDefinition).%ExistsId(className)
	{
		if ..#DEBUG=1 write "adaptor is found:",className,!
		set adaptor=$classmethod(className,"%New")
		do $method(adaptor,"Init",options)
		if ..#DEBUG=1 write "adaptor is initiated",!
	}
	else
	{
		if ..#DEBUG=1 write "adaptor can not be found",!
		set adaptor=##class(CIS.OPApp.SRV.Interface.IAdaptor).%New()
	}
	
	set ##this.Adaptor=adaptor
	
	quit $$$OK
}

/// 是否有效
Method Validate() As %Boolean
{
	set className=##this.%ClassName(1)
	if className["SRV.Interface" quit 0
	if ##this.Server="" quit 0
	if ##this.Client="" quit 0
	if '##class(%ClassDefinition).%ExistsId(##this.Client) quit 0
	if ##this.Active'="Y" quit 0
	
	quit 1
}

}
