/// 科室列表
Class CT.AN.DeptList Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DeptList ]
{

/// 科室列表代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 科室列表名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 科室列表说明
Property Note As %String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 5 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",有,无", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8 ];

/// 科室列表代码索引
Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Storage Default
{
<Data name="DeptListDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Note</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DeptListD</DataLocation>
<DefaultData>DeptListDefaultData</DefaultData>
<IdLocation>^CT.AN.DeptListD</IdLocation>
<IndexLocation>^CT.AN.DeptListI</IndexLocation>
<StreamLocation>^CT.AN.DeptListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
