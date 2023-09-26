/// 麻醉方法
Class CT.AN.AnaMethod Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaMethod ]
{

/// 麻醉方法代码
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 麻醉方法名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 麻醉方法类型
Property AnaType As CT.AN.DictData [ Required, SqlColumnNumber = 4 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5 ];

/// 麻醉方法别名
Property Alias As %String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 外部系统麻醉方法ID
Property ExternalID As %String [ SqlColumnNumber = 7 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 8 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 9 ];

/// 麻醉方法代码唯一索引
Index ICode On Code [ Unique ];

/// 麻醉类型索引
Index IAnaType On AnaType;

Index IExt On ExternalID;

Storage Default
{
<Data name="AnaMethodDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>AnaType</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>Alias</Value>
</Value>
<Value name="6">
<Value>ExternalID</Value>
</Value>
<Value name="7">
<Value>ActiveDate</Value>
</Value>
<Value name="8">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^CT.AN.AnaMethodD</DataLocation>
<DefaultData>AnaMethodDefaultData</DefaultData>
<IdLocation>^CT.AN.AnaMethodD</IdLocation>
<IndexLocation>^CT.AN.AnaMethodI</IndexLocation>
<StreamLocation>^CT.AN.AnaMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
