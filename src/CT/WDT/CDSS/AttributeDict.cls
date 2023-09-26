/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：定语字典表V2.0
/// Table：CT.WDT.CDSS.AttributeDict
Class CT.WDT.CDSS.AttributeDict Extends (%Persistent, User.Abstract)
{

/// 定语代码
Property AttributeCode As %String [ Required ];

/// 定语名称
Property AttributeDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 适用范围
Property Applyarea As %String;

/// 别名
Property AttributeAlias As %String;

Index CodeIndex On AttributeCode [ Unique ];

Index DescIndex On AttributeDesc;

Index UpdateDateIndex On UpdateDate;

Storage Default
{
<Data name="AttributeDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AttributeCode</Value>
</Value>
<Value name="3">
<Value>AttributeDesc</Value>
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
<Value>Applyarea</Value>
</Value>
<Value name="9">
<Value>AttributeAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AttributeDictD</DataLocation>
<DefaultData>AttributeDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AttributeDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AttributeDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AttributeDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
