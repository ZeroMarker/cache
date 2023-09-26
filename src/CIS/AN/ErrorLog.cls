/// 错误日志
Class CIS.AN.ErrorLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ErrorLog ]
{

/// 请求URL
Property RequestURL As %String(MAXLEN = 9999) [ SqlColumnNumber = 2 ];

/// 请求数据
Property RequestData As %String(MAXLEN = 999999) [ SqlColumnNumber = 3 ];

/// 错误信息
Property ErrorMsg As %String(MAXLEN = 999999) [ SqlColumnNumber = 4 ];

/// 日志日期
Property LogDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 日志时间
Property LogTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 数据模块
Property DataModule As CT.AN.DataModule [ SqlColumnNumber = 7 ];

/// 客户端电脑IP
Property ClientIP As %String [ SqlColumnNumber = 8 ];

/// 服务器IP
Property ServerIP As %String [ SqlColumnNumber = 9 ];

/// 安全组ID
Property GroupID As %String [ SqlColumnNumber = 10 ];

/// 科室ID
Property DeptID As %String [ SqlColumnNumber = 11 ];

/// 用户ID
Property UserID As %String [ SqlColumnNumber = 12 ];

/// 医院ID
Property HospID As %String [ SqlColumnNumber = 13 ];

/// 客户端页面URL
Property Referer As %String(MAXLEN = 9999) [ SqlColumnNumber = 14 ];

Index ILogDate On LogDate;

Storage Default
{
<Data name="ErrorLogDefaultData">
<Value name="1">
<Value>RequestURL</Value>
</Value>
<Value name="2">
<Value>RequestData</Value>
</Value>
<Value name="3">
<Value>ErrorMsg</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>DataModule</Value>
</Value>
<Value name="7">
<Value>ClientIP</Value>
</Value>
<Value name="8">
<Value>ServerIP</Value>
</Value>
<Value name="9">
<Value>GroupID</Value>
</Value>
<Value name="10">
<Value>DeptID</Value>
</Value>
<Value name="11">
<Value>UserID</Value>
</Value>
<Value name="12">
<Value>HospID</Value>
</Value>
<Value name="13">
<Value>Referer</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ErrorLogD</DataLocation>
<DefaultData>ErrorLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.ErrorLogD</IdLocation>
<IndexLocation>^CIS.AN.ErrorLogI</IndexLocation>
<StreamLocation>^CIS.AN.ErrorLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
