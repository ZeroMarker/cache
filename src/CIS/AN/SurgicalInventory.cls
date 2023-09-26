/// 手术清点
Class CIS.AN.SurgicalInventory Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalInventory ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 手术物品
Property SurgicalMaterial As CT.AN.SurgicalMaterial [ SqlColumnNumber = 3 ];

/// 手术物品名称说明
Property MaterialNote As %String [ SqlColumnNumber = 4 ];

/// 术前清点数
Property PreopCount As %String [ SqlColumnNumber = 5 ];

/// 关体腔前清点数
Property PreCloseCount As %String [ SqlColumnNumber = 6 ];

/// 关体腔后清点数
Property PostCloseCount As %String [ SqlColumnNumber = 7 ];

/// 缝皮后清点数
Property PostSewCount As %String [ SqlColumnNumber = 8 ];

/// 术中添加数
Property OperAddCount As %String [ SqlColumnNumber = 9 ];

/// 术中加数描述
Property AddCountDesc As %String [ SqlColumnNumber = 10 ];

/// 物品类型
Property InventoryType As %String(DISPLAYLIST = ",器械,敷料,清点者1,清点者2", VALUELIST = ",I,D,ZYS,ZZS") [ SqlColumnNumber = 11 ];

/// 包切口
Property PericardialCut As %String [ SqlColumnNumber = 12 ];

/// 无菌包
Property SterilityPack As CIS.AN.SterilityPack [ SqlColumnNumber = 13 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SurgicalInventoryDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>SurgicalMaterial</Value>
</Value>
<Value name="3">
<Value>MaterialNote</Value>
</Value>
<Value name="4">
<Value>PreopCount</Value>
</Value>
<Value name="5">
<Value>PreCloseCount</Value>
</Value>
<Value name="6">
<Value>PostCloseCount</Value>
</Value>
<Value name="7">
<Value>PostSewCount</Value>
</Value>
<Value name="8">
<Value>OperAddCount</Value>
</Value>
<Value name="9">
<Value>AddCountDesc</Value>
</Value>
<Value name="10">
<Value>InventoryType</Value>
</Value>
<Value name="11">
<Value>PericardialCut</Value>
</Value>
<Value name="12">
<Value>SterilityPack</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SurgicalInventoryD</DataLocation>
<DefaultData>SurgicalInventoryDefaultData</DefaultData>
<IdLocation>^CIS.AN.SurgicalInventoryD</IdLocation>
<IndexLocation>^CIS.AN.SurgicalInventoryI</IndexLocation>
<StreamLocation>^CIS.AN.SurgicalInventoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
