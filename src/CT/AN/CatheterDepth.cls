/// 置管深度
Class CT.AN.CatheterDepth Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CatheterDepth ]
{

/// 置管深度代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 置管深度名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 置管深度单位
Property Unit As %String [ SqlColumnNumber = 4 ];

/// 导管
Property Catheter As CT.AN.Catheter [ SqlColumnNumber = 5 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8 ];

/// 导管索引
Index Catheter On Catheter;

/// 置管深度代码唯一索引
Index ICode On Code;

/// 导管外键约束
ForeignKey FKCatheter(Catheter) References CT.AN.Catheter() [ OnDelete = cascade ];

Storage Default
{
<Data name="CatheterDepthDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Unit</Value>
</Value>
<Value name="4">
<Value>Catheter</Value>
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
<DataLocation>^CT.AN.CatheterDepthD</DataLocation>
<DefaultData>CatheterDepthDefaultData</DefaultData>
<IdLocation>^CT.AN.CatheterDepthD</IdLocation>
<IndexLocation>^CT.AN.CatheterDepthI</IndexLocation>
<StreamLocation>^CT.AN.CatheterDepthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
