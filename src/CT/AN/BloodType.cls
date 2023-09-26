Class CT.AN.BloodType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodType ]
{

/// 血型代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 血型描述
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 4 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 7 ];

Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Storage Default
{
<Data name="BloodTypeDefaultData">
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
<Value name="6">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CT.AN.BloodTypeD</DataLocation>
<DefaultData>BloodTypeDefaultData</DefaultData>
<IdLocation>^CT.AN.BloodTypeD</IdLocation>
<IndexLocation>^CT.AN.BloodTypeI</IndexLocation>
<StreamLocation>^CT.AN.BloodTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
