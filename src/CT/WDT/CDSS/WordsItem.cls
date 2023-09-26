/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词项目字典表V2.0
/// Table：CT.WDT.CDSS.WordsItem
Class CT.WDT.CDSS.WordsItem Extends (%Persistent, User.Abstract)
{

/// 识别词项目代码
Property WordsItemCode As %String [ Required ];

/// 识别词项目描述
Property WordsItemDesc As %String [ Required ];

/// 父节点
Property ParentDR As CT.WDT.CDSS.WordsItem;

/// 项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
Property ItemType As %String;

/// 关联表名
Property TableName As %String;

/// 关联字段名
Property FiledName As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 项目类别（中医、西医）
Property ItemCategory As %String;

Index CodeIndex On WordsItemCode [ Unique ];

Index DescIndex On WordsItemDesc;

Index ParCatIdx On ParentDR;

Index ParTypeIdx On (ItemType As Exact, ParentDR);

Storage Default
{
<Data name="WordsItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WordsItemCode</Value>
</Value>
<Value name="3">
<Value>WordsItemDesc</Value>
</Value>
<Value name="4">
<Value>ParentDR</Value>
</Value>
<Value name="5">
<Value>ItemType</Value>
</Value>
<Value name="6">
<Value>TableName</Value>
</Value>
<Value name="7">
<Value>FiledName</Value>
</Value>
<Value name="8">
<Value>UseFlag</Value>
</Value>
<Value name="9">
<Value>UpdateUser</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>Remarks</Value>
</Value>
<Value name="12">
<Value>ItemCategory</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.WordsItemD</DataLocation>
<DefaultData>WordsItemDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.WordsItemD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.WordsItemI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.WordsItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
