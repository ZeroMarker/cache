/// Creator:丁亚男
/// CreatDate:2020-06-04 
/// Description：检验标本字典
/// Table：CT.WDT.CDSS.LabSpecimenDict
Class CT.WDT.CDSS.LabSpecimenDict Extends (%Persistent, User.Abstract)
{

/// 标本编码
Property SpecimenCode As %String [ Required ];

/// 中文名称
Property SpecimenName As %String;

/// 标本描述
Property SpecimenDesc As %String(MAXLEN = "");

/// 标本采集标准
Property SpecimenNorm As %String(MAXLEN = "");

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 标本类型
Property SpecimenType As %String;

/// 英文名称
Property EnglishName As %String(MAXLEN = "");

/// 单位
Property Unit As %String;

/// 检验单名称
Property InspectionSheet As %String(MAXLEN = "");

/// 标本别名
Property SpecimenAlias As %String;

Index CodeIndex On SpecimenCode [ Unique ];

Index NameIndex On SpecimenName;

Index TypeIndex On SpecimenType;

Storage Default
{
<Data name="LabSpecimenDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecimenCode</Value>
</Value>
<Value name="3">
<Value>SpecimenName</Value>
</Value>
<Value name="4">
<Value>SpecimenDesc</Value>
</Value>
<Value name="5">
<Value>SpecimenNorm</Value>
</Value>
<Value name="6">
<Value>UseFlag</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateUserID</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>SpecimenType</Value>
</Value>
<Value name="11">
<Value>EnglishName</Value>
</Value>
<Value name="12">
<Value>Unit</Value>
</Value>
<Value name="13">
<Value>InspectionSheet</Value>
</Value>
<Value name="14">
<Value>SpecimenAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.LabSpecimenDictD</DataLocation>
<DefaultData>LabSpecimenDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabSpecimenDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabSpecimenDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabSpecimenDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
