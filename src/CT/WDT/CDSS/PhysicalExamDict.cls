/// Creator:丁亚男
/// CreatDate:2019-12-16
/// Description：体格检查字典表
/// Table：CT.WDT.CDSS.PhysicalExamDict
Class CT.WDT.CDSS.PhysicalExamDict Extends (%Persistent, User.Abstract)
{

/// 体格检查编码
Property PhysicalExamCode As %String(MAXLEN = 50) [ Required ];

/// 体格检查名称
Property PhysicalExamName As %String(MAXLEN = "");

/// 体格检查概述
Property PhysicalExamDesc As %String(MAXLEN = "");

/// 体格检查说明
Property PhysicalExamExplain As %String(MAXLEN = "");

/// 体格检查值域
Property PhysicalExamValue As %String(MAXLEN = "");

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 别名
Property PhysicalExamAlias As %String;

Index CodeIndex On PhysicalExamCode [ Unique ];

Index NameIndex On PhysicalExamName;

Storage Default
{
<Data name="PhysicalExamDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhysicalExamCode</Value>
</Value>
<Value name="3">
<Value>PhysicalExamName</Value>
</Value>
<Value name="4">
<Value>PhysicalExamDesc</Value>
</Value>
<Value name="5">
<Value>PhysicalExamExplain</Value>
</Value>
<Value name="6">
<Value>PhysicalExamValue</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateUserID</Value>
</Value>
<Value name="10">
<Value>UseFlag</Value>
</Value>
<Value name="11">
<Value>PhysicalExamAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.PhysicalExamDictD</DataLocation>
<DefaultData>PhysicalExamDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.PhysicalExamDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.PhysicalExamDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.PhysicalExamDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
