/// 导管型号
Class CT.AN.CatheterType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CatheterType ]
{

/// 导管型号代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 导管型号名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 导管
Property Catheter As CT.AN.Catheter [ SqlColumnNumber = 4 ];

/// 是否生效
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5 ];

/// 排序号
Property SeqNo As %Integer [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 导管型号代码唯一索引
Index ICode On Code [ Unique ];

/// 导管索引
Index ICatheter On Catheter;

/// 导管外键约束
ForeignKey FKCatheter(Catheter) References CT.AN.Catheter() [ OnDelete = cascade ];

Storage Default
{
<Data name="CatheterTypeDefaultData">
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
<Value>Active</Value>
</Value>
<Value name="5">
<Value>SeqNo</Value>
</Value>
<Value name="6">
<Value>ActiveDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^CT.AN.CatheterTypeD</DataLocation>
<DefaultData>CatheterTypeDefaultData</DefaultData>
<IdLocation>^CT.AN.CatheterTypeD</IdLocation>
<IndexLocation>^CT.AN.CatheterTypeI</IndexLocation>
<StreamLocation>^CT.AN.CatheterTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
