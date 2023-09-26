/// 手术物品（手术器械、敷料）
Class CT.AN.SurgicalMaterial Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalMaterial ]
{

/// 手术物品代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 手术物品名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 手术物品别名
Property Alias As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 序号
Property SeqNo As %String [ SqlColumnNumber = 5 ];

/// 手术物品说明
Property Note As %String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 10 ];

/// 物品类型
Property ItemType As %String(DISPLAYLIST = ",器械,敷料", VALUELIST = ",I,D") [ SqlColumnNumber = 11 ];

/// 手术物品单位
Property Unit As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 数据归属
Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 13 ];

/// 手术物品代码唯一索引
Index ICode On Code [ Unique ];

Index IExt On ExternalID;

Index IItemType On ItemType;

Storage Default
{
<Data name="SurgicalMaterialDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>SeqNo</Value>
</Value>
<Value name="5">
<Value>Note</Value>
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
<Value name="9">
<Value>ExternalID</Value>
</Value>
<Value name="10">
<Value>ItemType</Value>
</Value>
<Value name="11">
<Value>Unit</Value>
</Value>
<Value name="12">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^CT.AN.SurgicalMaterialD</DataLocation>
<DefaultData>SurgicalMaterialDefaultData</DefaultData>
<IdLocation>^CT.AN.SurgicalMaterialD</IdLocation>
<IndexLocation>^CT.AN.SurgicalMaterialI</IndexLocation>
<StreamLocation>^CT.AN.SurgicalMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
