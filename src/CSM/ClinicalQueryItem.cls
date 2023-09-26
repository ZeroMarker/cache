Class CSM.ClinicalQueryItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目在其原生系统中的Code，如医嘱ID，检验项目别名等
Property InternalCode As %String(TRUNCATE = 1) [ Required ];

/// 项目名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 父级项目ID，0为顶级
Property ParentID As %Integer [ Required ];

/// 查询项目大类（医嘱、检验、检查、电子病历等）
Property CategoryID As %Integer [ Required ];

Index IdxName On (CategoryID, Name);

Index IdxParentID On (CategoryID, ParentID);

Storage Default
{
<Data name="ClinicalQueryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryName</Value>
</Value>
<Value name="3">
<Value>InternalCode</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>CategoryID</Value>
</Value>
</Data>
<DataLocation>^CSM.ClinicalQueryItemD</DataLocation>
<DefaultData>ClinicalQueryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ClinicalQueryItemD</IdLocation>
<IndexLocation>^CSM.ClinicalQueryItemI</IndexLocation>
<StreamLocation>^CSM.ClinicalQueryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
