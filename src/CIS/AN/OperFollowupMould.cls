/// 术后随访模板
Class CIS.AN.OperFollowupMould Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperFollowupMould, StorageStrategy = Default ]
{

/// 代码
Property MouldCode As %String [ Required, SqlColumnNumber = 2 ];

/// 描述
Property MouldDesc As %String [ Required, SqlColumnNumber = 3 ];

/// 内容
Property MouldValues As %String(MAXLEN = 99999) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="OperFollowupMould">
<Value name="1">
<Value>MouldCode</Value>
</Value>
<Value name="2">
<Value>MouldDesc</Value>
</Value>
<Value name="3">
<Value>MouldValues</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperFollowupMouldD</DataLocation>
<DefaultData>OperFollowupMouldDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperFollowupMouldD</IdLocation>
<IndexLocation>^CIS.AN.OperFollowupMouldI</IndexLocation>
<StreamLocation>^CIS.AN.OperFollowupMouldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
