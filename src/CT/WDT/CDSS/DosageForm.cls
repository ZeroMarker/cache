/// Creator:徐文虎
/// CreatDate:2021-08-27
/// Description：药物剂型分类表 
/// Table：CT.WDT.CDSS.DosageForm
Class CT.WDT.CDSS.DosageForm Extends (%Persistent, User.Abstract)
{

/// 剂型编码
Property DosageFormCode As %String [ Required ];

/// 剂型描述
Property DosageFormDesc As %String [ Required ];

/// 父节点
Property ParentDR As CT.WDT.CDSS.DosageForm;

/// 状态（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property DosageAlias As %String;

Index CodeIndex On DosageFormCode [ Unique ];

Index DescIndex On DosageFormDesc;

Index ParCatIdx On ParentDR;

Storage Default
{
<Data name="DosageFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DosageFormCode</Value>
</Value>
<Value name="3">
<Value>DosageFormDesc</Value>
</Value>
<Value name="4">
<Value>ParentDR</Value>
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
<Value name="9">
<Value>DosageAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DosageFormD</DataLocation>
<DefaultData>DosageFormDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DosageFormD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DosageFormI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DosageFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
