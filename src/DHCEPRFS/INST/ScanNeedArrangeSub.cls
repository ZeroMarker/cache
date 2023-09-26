Class DHCEPRFS.INST.ScanNeedArrangeSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 日志ID
Property MRLogDetail As %String(TRUNCATE = 1);

/// 分类页数
Property ArrangePage As %Integer;

/// 扫描页数
Property ScanPage As %Integer;

Relationship ScanNeedArrangeLog As DHCEPRFS.INST.ScanNeedArrangeLog [ Cardinality = parent, Inverse = ScanNeedArrangeSub ];

Index IdxMain On ScanNeedArrangeLog;

Storage Default
{
<Data name="ScanNeedArrangeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRLogDetail</Value>
</Value>
<Value name="3">
<Value>NeedArrangePage</Value>
</Value>
<Value name="4">
<Value>ScanPage</Value>
</Value>
<Value name="5">
<Value>ArrangePage</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ScanArrangeSubD</DataLocation>
<DefaultData>ScanNeedArrangeSubDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ScanArrangeSubD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ScanArrangeSubI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ScanArrangeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
