/// 插管途径(径路)
Class CT.AN.CatheterPath Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CatheterPath ]
{

/// 插管途径代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 插管途径名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 导管
Property Catheter As CT.AN.Catheter [ SqlColumnNumber = 4 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7 ];

/// 插管途径代码唯一索引
Index ICode On Code [ Unique ];

/// 导管索引
Index ICatheter On Catheter;

/// 导管外键约束
ForeignKey FKCatheter(Catheter) References CT.AN.Catheter() [ OnDelete = cascade ];

Storage Default
{
<Data name="CatheterPathDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Catheter</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.CatheterPathD</DataLocation>
<DefaultData>CatheterPathDefaultData</DefaultData>
<IdLocation>^CT.AN.CatheterPathD</IdLocation>
<IndexLocation>^CT.AN.CatheterPathI</IndexLocation>
<StreamLocation>^CT.AN.CatheterPathS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
