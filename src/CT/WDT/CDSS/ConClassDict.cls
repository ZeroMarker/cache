/// Creator:钟荣枫
/// CreatDate:2020-06-15
/// Description：实施综合管理平台-对接方字典分类表
/// Table：CT.WDT.CDSS.ConClassDict
Class CT.WDT.CDSS.ConClassDict Extends (%Persistent, User.Abstract)
{

/// 第三方字典分类代码
Property DictClassCode As %String [ Required ];

/// 第三方字典分类描述
Property DictClassDesc As %String [ Required ];

/// 第三方字典分类来源 HIS/EMR/LIS/PACS/集成平台
Property DictiClassSource As %String;

/// 对照CDSS字典名
Property DictiClassMapping As %String;

/// 所属医院
Property DictiClassHosp As CT.WDT.CDSS.CustomerHosp;

/// 使用标志(0在用，1停用)
Property UseFlag As %Integer;

/// 备注
Property Remarks As %String;

Index CodeIndex On DictClassCode;

Index DescIndex On DictClassDesc;

Storage Default
{
<Data name="ConClassDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictClassCode</Value>
</Value>
<Value name="3">
<Value>DictClassDesc</Value>
</Value>
<Value name="4">
<Value>DictiClassSource</Value>
</Value>
<Value name="5">
<Value>DictiClassMapping</Value>
</Value>
<Value name="6">
<Value>DictiClassHosp</Value>
</Value>
<Value name="7">
<Value>UseFlag</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConClassDictD</DataLocation>
<DefaultData>ConClassDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConClassDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConClassDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConClassDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
