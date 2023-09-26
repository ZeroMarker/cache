Class CT.AN.Sex Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Sex ]
{

/// 性别代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 性别描述
Property Description As %String [ SqlColumnNumber = 3 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 4 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6 ];

/// Gender
Property Gender As %String(MAXLEN = 201, TRUNCATE = 1, VALUELIST = ",M||Male,F||Female,U||Unknown") [ SqlColumnNumber = 7 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 8 ];

Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Storage Default
{
<Data name="SexDefaultData">
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
<Value>Gender</Value>
</Value>
<Value name="7">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CT.AN.SexD</DataLocation>
<DefaultData>SexDefaultData</DefaultData>
<IdLocation>^CT.AN.SexD</IdLocation>
<IndexLocation>^CT.AN.SexI</IndexLocation>
<StreamLocation>^CT.AN.SexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
