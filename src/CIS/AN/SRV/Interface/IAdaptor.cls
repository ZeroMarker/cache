Class CIS.AN.SRV.Interface.IAdaptor [ Abstract ]
{

Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.AN.SRV";

/// 连接协议，支持WebService;HTTP;DirectConnect
Parameter ConnectProtocol = "WebService";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 目标地址
Property TargetAddress As %String;

/// 目标方法
Property TargetMethod As %String;

/// 对接系统Token
Property Token As %String;

/// 目的：Query-查询数据（传入查询参数）；Sync-同步数据（传入数据模型）；Event-事件（传入事件句柄模型）；Test-测试数据（传入测试参数）
Property Purpose As %String;

/// 数据模型节点（当传入的是数据模型时）
Property ContentNode As %String;

/// 数据模型类名
Property ModelName As %String;

/// 数据结构体模型类名
Property StructName As %String;

/// 客户端
Property Client As %RegisteredObject;

/// 实例化
ClassMethod Create() As CIS.AN.SRV.Interface.IAdaptor
{
	quit ##class(CIS.AN.SRV.Interface.IAdaptor).%New()
}

/// 初始化
Method Init(options As %DynamicObject) As %Status
{
	do ##this.SetOptions(options)
	quit $$$OK
}

/// 设置参数
Method SetOptions(options As %DynamicObject) As %Status
{
	set ##this.TargetMethod = options.%Get("TargetMethod")
	set ##this.TargetAddress = options.%Get("TargetAddress")
	set ##this.Purpose = options.%Get("Purpose")
	set ##this.ContentNode = options.%Get("ContentNode")
	set ##this.ModelName = options.%Get("ModelName")
	set ##this.StructName = options.%Get("StructName")
	quit $$$OK
}

/// 清除参数
Method ClearOptions() As %Status
{
	set ##this.TargetMethod = ""
	set ##this.TargetAddress = ""
	set ##this.Purpose = ""
	set ##this.ContentNode = ""
	set ##this.ModelName = ""
	set ##this.StructName = ""
	quit $$$OK
}

/// 创建客户端实例
Method CreateClient() As %Status
{
	if ##class(%ClassDefinition).%ExistsId(##this.TargetAddress)
	{
		set client=$classmethod(##this.TargetAddress,"%New")
		set ##this.Client=client
		if ..#DEBUG=1 write "client is initiated",!
	}
	else
	{
		if ..#DEBUG=1 write "client can not be found",!
		quit $$$ERROR("client can not be found")
	}
	quit $$$OK
}

/// 是否同一个客户端
Method IsSameClient() As %Boolean
{
	set originalClientClassName=##this.Client.%ClassName(1)
	set currentClientClassName=##this.TargetAddress
	if originalClientClassName'=currentClientClassName quit 0
	
	quit 1
}

/// 发送消息
Method Send(request As CIS.AN.DTO.Abstract.Request) As CIS.AN.DTO.Abstract.Response
{
}

/// 接收消息
Method Receive(request As CIS.AN.DTO.Abstract.Request) As CIS.AN.DTO.Abstract.Response
{
}

}
