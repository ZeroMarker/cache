/// 临床信息综合查询项目属性表
Class CSM.ClinicalItemProperty Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCategoryID On CategoryID;

/// 临床信息综合查询类别ID
Property CategoryID As %Integer [ Required ];

/// 属性代码，对应查询结果临时global中的节点名称
Property Code As %String(TRUNCATE = 1) [ Required ];

/// 属性名称
Property Name As %String(TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="ClinicalItemPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CSM.ClinicalItemPropertyD</DataLocation>
<DefaultData>ClinicalItemPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ClinicalItemPropertyD</IdLocation>
<IndexLocation>^CSM.ClinicalItemPropertyI</IndexLocation>
<StreamLocation>^CSM.ClinicalItemPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
