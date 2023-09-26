/// 润乾报表对应的Cache服务器配置
Class User.DHCRepServerConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_RepServerConfig ]
{

/// 报表服务器的IP地址
Property RSCServerIP As %String(MAXLEN = 20) [ Required, SqlFieldName = RSC_ServerIP ];

/// 报表服务器的 名称 识别报表服务器
Property RSCServerName As %String(MAXLEN = 100) [ Required, SqlFieldName = RSC_ServerName ];

/// 报表服务器 端口
Property RSCServerPort As %String [ InitialExpression = "8080", Required, SqlFieldName = RSC_ServerPort ];

/// dtHealth 站点IP 地址
Property RSCHealthWebSite As %String(MAXLEN = 100) [ SqlFieldName = RSC_HealthWebSite ];

Index HWSIdx On RSCHealthWebSite;

/// 对应报表服务器 的 应用名称
Property RSCAppName As %String(MAXLEN = 200) [ InitialExpression = "runqianReport", Required, SqlFieldName = RSC_AppName ];

/// 定义报表服务器的唯一性
Index RSCUq On (RSCHealthWebSite, RSCServerIP, RSCServerPort, RSCAppName) [ Unique ];

Storage Default
{
<Data name="DHCRepServerConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RSCServerIP</Value>
</Value>
<Value name="3">
<Value>RSCServerName</Value>
</Value>
<Value name="4">
<Value>RSCServerPort</Value>
</Value>
<Value name="5">
<Value>RSCHealthWebSite</Value>
</Value>
<Value name="6">
<Value>RSCAppName</Value>
</Value>
</Data>
<DataLocation>^User.DHCRepServerConfigD</DataLocation>
<DefaultData>DHCRepServerConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRepServerConfigD</IdLocation>
<IndexLocation>^User.DHCRepServerConfigI</IndexLocation>
<StreamLocation>^User.DHCRepServerConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
