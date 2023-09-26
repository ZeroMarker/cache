/// 用药途径
Class CT.AN.Instruction Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Instruction ]
{

/// 代码，唯一标识
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 中文描述
Property Description As %String [ SqlColumnNumber = 3 ];

/// 英文描述
Property EnglishDesc As %String [ SqlColumnNumber = 4 ];

/// 缩写
Property Abbreviation As %String [ SqlColumnNumber = 5 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// 用药途径代码唯一索引
Index ICode On Code [ Unique ];

/// 外部系统ID索引
Index IExt On ExternalID;

Storage Default
{
<Data name="InstructionDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>EnglishDesc</Value>
</Value>
<Value name="4">
<Value>Abbreviation</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
<Value name="6">
<Value>ActiveDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.InstructionD</DataLocation>
<DefaultData>InstructionDefaultData</DefaultData>
<IdLocation>^CT.AN.InstructionD</IdLocation>
<IndexLocation>^CT.AN.InstructionI</IndexLocation>
<StreamLocation>^CT.AN.InstructionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
