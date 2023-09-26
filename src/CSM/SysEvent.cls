/// 系统日志表
Class CSM.SysEvent Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//用户名

Property LoingName As %String(MAXLEN = 20, TRUNCATE = 1);

//操作时用户ID

Property UserID As %String(MAXLEN = 8, TRUNCATE = 1);

//用户所在项目组ID

Property UserProjGrpID As %String(MAXLEN = 4, TRUNCATE = 1);

//用户角色ID

Property UserRoleID As %String(MAXLEN = 4, TRUNCATE = 1);

//事件发生的日期及时间

Property EventTime As %String(MAXLEN = 30, TRUNCATE = 1);

//所属应用ID

Property ApplicationID As %String(MAXLEN = 4, TRUNCATE = 1);

//所属应用名称

Property AppName As %String(MAXLEN = 50, TRUNCATE = 1);

//PageCode模块名称

Property ModuleName As %String(MAXLEN = 50, TRUNCATE = 1);

//发生事件的PageCode

Property ModulePageCode As %String(MAXLEN = 6, TRUNCATE = 1);

//来源URL

Property URL As %String(MAXLEN = 500, TRUNCATE = 1);

//日志类型,1:操作日志2:安全日志3.错误日志

Property EventType As %String(MAXLEN = 1, TRUNCATE = 1);

//客户端IP地址

Property IP As %String(MAXLEN = 15, TRUNCATE = 1);

//详细描述

Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

///  Property EventID As %Integer;
///  Index MainIdx On EventID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="SysEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoingName</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>AppName</Value>
</Value>
<Value name="5">
<Value>ApplicationID</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>EventTime</Value>
</Value>
<Value name="8">
<Value>EventType</Value>
</Value>
<Value name="9">
<Value>IP</Value>
</Value>
<Value name="10">
<Value>ModuleName</Value>
</Value>
<Value name="11">
<Value>ModulePageCode</Value>
</Value>
<Value name="12">
<Value>URL</Value>
</Value>
<Value name="13">
<Value>UserProjGrpID</Value>
</Value>
<Value name="14">
<Value>UserRoleID</Value>
</Value>
<Value name="15">
<Value>EventID</Value>
</Value>
</Data>
<DataLocation>^CSM.SysEventD</DataLocation>
<DefaultData>SysEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.SysEventD</IdLocation>
<IndexLocation>^CSM.SysEventI</IndexLocation>
<StreamLocation>^CSM.SysEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
