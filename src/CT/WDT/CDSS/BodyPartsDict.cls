/// Creator:谷雪萍
/// CreatDate:2020-02-08
/// Description：部位字典表V2.0
/// Table：CT.WDT.CDSS.BodyPartsDict
Class CT.WDT.CDSS.BodyPartsDict Extends (%Persistent, User.Abstract)
{

/// 部位代码
Property PartsCode As %String [ Required ];

/// 部位名称
Property PartsDesc As %String [ Required ];

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property Alias As %String;

Index CodeIndex On PartsCode [ Unique ];

Index DescIndex On PartsDesc;

Index UpdateDateIndex On UpdateDate;

Storage Default
{
<Data name="BodyPartsDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PartsCode</Value>
</Value>
<Value name="3">
<Value>PartsDesc</Value>
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
<Value>Alias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.BodyPartsDictD</DataLocation>
<DefaultData>BodyPartsDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.BodyPartsDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.BodyPartsDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.BodyPartsDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
