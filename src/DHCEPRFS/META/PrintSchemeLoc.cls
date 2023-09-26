/// Desc:打印方案分科室（扫描方案分科室）
/// Creator:杨鹏
/// Createdate:2021.5.23
Class DHCEPRFS.META.PrintSchemeLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// PrintSchemeID
Property PrintSchemeID As %String(TRUNCATE = 1);

/// LocID
Property LocID As %String(TRUNCATE = 1);

/// 排除项
Property ExSchemeItems As %String(MAXLEN = 50000, TRUNCATE = 1);

Index idxPrintSchemeLoc On (PrintSchemeID, LocID) [ Unique ];

Storage Default
{
<Data name="PrintSchemeLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrintSchemeID</Value>
</Value>
<Value name="3">
<Value>LocID</Value>
</Value>
<Value name="4">
<Value>ExSchemeItems</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.PrintSchemeLocD</DataLocation>
<DefaultData>PrintSchemeLocDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.PrintSchemeLocD</IdLocation>
<IndexLocation>^DHCEPRFS.META.PrintSchemeLocI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.PrintSchemeLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
