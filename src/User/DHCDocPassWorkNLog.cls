/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 医生交班本日志表
Class User.DHCDocPassWorkNLog Extends (%Persistent, User.Abstract)
{

Relationship LParRef As User.DHCDocPassWorkNSub [ Cardinality = parent, Inverse = ChildLog, Required, SqlFieldName = L_ParRef ];

/// 日志类型
Property LType As %String [ SqlColumnNumber = 2, SqlFieldName = L_Type ];

/// 修改人
Property LUser As SSUser [ SqlColumnNumber = 3, SqlFieldName = L_User ];

/// 修改内容
Property LContent As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = L_Content ];

/// 日期
Property LDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = L_Date ];

/// 时间
Property LTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = L_Time ];

Storage Default
{
<Data name="DHCDocPassWorkNLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LType</Value>
</Value>
<Value name="3">
<Value>LUser</Value>
</Value>
<Value name="4">
<Value>LContent</Value>
</Value>
<Value name="5">
<Value>LDate</Value>
</Value>
<Value name="6">
<Value>LTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildLog")</DataLocation>
<DefaultData>DHCDocPassWorkNLogDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNSubC("ChildLog")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNLogI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
