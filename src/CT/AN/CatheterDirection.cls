/// 置管方向
Class CT.AN.CatheterDirection Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CatheterDirection ]
{

/// 置管方向代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 置管方向名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6 ];

/// 置管方向代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="CatheterDirectionDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>ExpireDate</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.CatheterDirectionD</DataLocation>
<DefaultData>CatheterDirectionDefaultData</DefaultData>
<IdLocation>^CT.AN.CatheterDirectionD</IdLocation>
<IndexLocation>^CT.AN.CatheterDirectionI</IndexLocation>
<StreamLocation>^CT.AN.CatheterDirectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
