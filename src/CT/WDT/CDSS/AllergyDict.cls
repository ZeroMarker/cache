/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：过敏史字典表V2.0
/// Table：CT.WDT.CDSS.AllergyDict
Class CT.WDT.CDSS.AllergyDict Extends (%Persistent, User.Abstract)
{

/// 过敏史代码
Property AllergyCode As %String [ Required ];

/// 过敏史名称
Property AllergyDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property AllergyAlias As %String;

Index CodeIndex On AllergyCode [ Unique ];

Index DescIndex On AllergyDesc;

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="AllergyDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AllergyCode</Value>
</Value>
<Value name="3">
<Value>AllergyDesc</Value>
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
<Value>AllergyAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AllergyDictD</DataLocation>
<DefaultData>AllergyDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AllergyDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AllergyDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AllergyDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
