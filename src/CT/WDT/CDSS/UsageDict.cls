/// Creator:丁亚男
/// CreatDate:2020-06-04
/// Description：用法字典 
/// Table：CT.WDT.CDSS.UsageDict
Class CT.WDT.CDSS.UsageDict Extends (%Persistent, User.Abstract)
{

/// 用法编码
Property UsageCode As %String [ Required ];

/// 用法名称
Property UsageName As %String;

/// 用法描述
Property UsageDesc As %String(MAXLEN = "");

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property UsageAlias As %String;

Index CodeIndex On UsageCode [ Unique ];

Index NameIndex On UsageName;

Storage Default
{
<Data name="UsageDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UsageCode</Value>
</Value>
<Value name="3">
<Value>UsageName</Value>
</Value>
<Value name="4">
<Value>UsageDesc</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>UsageAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.UsageDictD</DataLocation>
<DefaultData>UsageDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.UsageDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.UsageDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.UsageDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
