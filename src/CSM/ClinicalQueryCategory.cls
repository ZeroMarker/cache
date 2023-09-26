/// 临床信息综合查询类别表
Class CSM.ClinicalQueryCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 查询项目大类名称（医嘱、检验、检查、电子病历等）
Property Name As %String(TRUNCATE = 1) [ Required ];

Index NameIndex On Name [ Unique ];

Storage Default
{
<Data name="ClinicalQueryCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CSM.ClinicalQueryCategoryD</DataLocation>
<DefaultData>ClinicalQueryCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ClinicalQueryCategoryD</IdLocation>
<IndexLocation>^CSM.ClinicalQueryCategoryI</IndexLocation>
<StreamLocation>^CSM.ClinicalQueryCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
