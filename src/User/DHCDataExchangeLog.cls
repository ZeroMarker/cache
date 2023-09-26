Class User.DHCDataExchangeLog Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_DataExchangeLog ]
{

/// 插入入参日期
Property LogParamsDate As %Date;

/// 插入入参时间
Property LogParamsTime As %Time;

/// 类型
Property LogType As %String(COLLATION = "Exact");

/// 类名
Property LogClassName As %String(COLLATION = "Exact");

/// 方法名
Property LogMethodName As %String(COLLATION = "Exact");

/// 参数
Property LogParams As %Stream.GlobalCharacter;

/// 返回值
Property LogResult As %Stream.GlobalCharacter;

/// 插入返回值日期
Property LogResultDate As %Date;

/// 插入返回值时间
Property LogResultTime As %Time;

/// 接口调用是否成功标志（Y,N)
Property LogSuccess As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N");

/// 接口调用是否重新发送（Y,N)
Property LogSendAgain As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N");

/// IP
Property LogIP As %String(COLLATION = "Exact");

/// HOSPID
Property HOSPID As %String(COLLATION = "Exact");

Index IndexLogSuccess On LogSuccess As Exact;

Index IndexLogType On LogType As Exact;

Index IndexLogParamsDate On LogParamsDate As Exact;

Index IndexLogTypeParamsDate On (LogParamsDate As Exact, LogType As Exact);

Index IndexLogMethodName On LogMethodName As Exact;

Index IndexLogTypeMethodName On (LogType As Exact, LogMethodName As Exact);

Storage Default
{
<Data name="DHCDataExchangeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogType</Value>
</Value>
<Value name="3">
<Value>LogClassName</Value>
</Value>
<Value name="4">
<Value>LogMethodName</Value>
</Value>
<Value name="5">
<Value>LogParams</Value>
</Value>
<Value name="6">
<Value>LogResult</Value>
</Value>
<Value name="7">
<Value>LogParamsDate</Value>
</Value>
<Value name="8">
<Value>LogParamsTime</Value>
</Value>
<Value name="9">
<Value>LogResultDate</Value>
</Value>
<Value name="10">
<Value>LogParamsTime</Value>
</Value>
<Value name="11">
<Value>LogResultTime</Value>
</Value>
<Value name="12">
<Value>LogSuccess</Value>
</Value>
<Value name="13">
<Value>LogSendAgain</Value>
</Value>
<Value name="14">
<Value>LogIP</Value>
</Value>
<Value name="15">
<Value>HOSPID</Value>
</Value>
</Data>
<DataLocation>^User.DHCDataExchangeLogD</DataLocation>
<DefaultData>DHCDataExchangeLogDefaultData</DefaultData>
<IdLocation>^User.DHCDataExchangeLogD</IdLocation>
<IndexLocation>^User.DHCDataExchangeLogI</IndexLocation>
<StreamLocation>^User.DHCDataExchangeLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
