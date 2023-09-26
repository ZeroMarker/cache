/// Creator:Xuwenhu
/// CreatDate:2020-07-20
/// Description：检验医嘱字典表 
/// Table：CT.WDT.CDSS.LabOrdersDict
Class CT.WDT.CDSS.LabOrdersDict Extends (%Persistent, User.Abstract)
{

/// 检验医嘱代码
Property LabOrdersCode As %String [ Required ];

/// 检验医嘱描述
Property LabOrdersDesc As %String [ Required ];

/// 别名
Property Alias As %String(MAXLEN = "");

/// 使用标志（0编辑中,1已删除,2已审核）
Property UseFlag As %Integer;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On LabOrdersCode [ Unique ];

Index DescIndex On LabOrdersDesc;

Storage Default
{
<Data name="LabOrdersDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabOrdersCode</Value>
</Value>
<Value name="3">
<Value>LabOrdersDesc</Value>
</Value>
<Value name="4">
<Value>Alias</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.LabOrdersDictD</DataLocation>
<DefaultData>LabOrdersDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabOrdersDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabOrdersDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabOrdersDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
