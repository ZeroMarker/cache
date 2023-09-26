/// Creator:谷雪萍
/// CreatDate:2020-02-08
/// Description：药物分类字典表V2.0
/// Table：CT.WDT.CDSS.DrugTypeDict
Class CT.WDT.CDSS.DrugTypeDict Extends (%Persistent, User.Abstract)
{

/// 药物分类代码
Property DrugTypeCode As %String [ Required ];

/// 药物分类名称
Property DrugTypeDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property AliasName As %String;

Index CodeIndex On DrugTypeCode [ Unique ];

Index DescIndex On DrugTypeDesc;

Storage Default
{
<Data name="DrugTypeDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrugTypeCode</Value>
</Value>
<Value name="3">
<Value>DrugTypeDesc</Value>
</Value>
<Value name="4">
<Value>UseFlag</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>AliasName</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DrugTypeDictD</DataLocation>
<DefaultData>DrugTypeDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DrugTypeDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DrugTypeDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DrugTypeDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
