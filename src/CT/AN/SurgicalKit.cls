/// 手术包
Class CT.AN.SurgicalKit Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalKit ]
{

/// 手术包代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 手术包名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 主手术包
Property MainKit As CT.AN.SurgicalKit [ SqlColumnNumber = 4 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 手术包别名
Property Alias As %String [ SqlColumnNumber = 7 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 9 ];

/// 包类型
Property KitType As %String(DISPLAYLIST = ",器械包,敷料包", VALUELIST = ",I,D") [ SqlColumnNumber = 10 ];

/// 数据归属
Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 11 ];

/// 手术包代码唯一索引
Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Index IKitType On KitType;

Storage Default
{
<Data name="SurgicalKitDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>MainKit</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>Alias</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>ExternalID</Value>
</Value>
<Value name="9">
<Value>KitType</Value>
</Value>
<Value name="10">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^CT.AN.SurgicalKitD</DataLocation>
<DefaultData>SurgicalKitDefaultData</DefaultData>
<IdLocation>^CT.AN.SurgicalKitD</IdLocation>
<IndexLocation>^CT.AN.SurgicalKitI</IndexLocation>
<StreamLocation>^CT.AN.SurgicalKitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
