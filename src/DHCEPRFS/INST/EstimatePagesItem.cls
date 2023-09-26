Class DHCEPRFS.INST.EstimatePagesItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目ID
Property ItemID As %String(TRUNCATE = 1);

/// 项目名字
Property ItemName As %String(TRUNCATE = 1);

/// 项目估算页数
Property ItemPages As %String(TRUNCATE = 1);

/// 此项目总价
Property TotalPrice As %String(TRUNCATE = 1);

Relationship EstimatePagesLog As DHCEPRFS.INST.EstimatePagesLog [ Cardinality = parent, Inverse = EstimatePagesItem ];

Index IdxMain On (EstimatePagesLog, ItemID);

Storage Default
{
<Data name="EstimatePagesItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemID</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>ItemPages</Value>
</Value>
<Value name="5">
<Value>TotalPrice</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.EstimateItemD</DataLocation>
<DefaultData>EstimatePagesItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.EstimateItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.EstimateItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.EstimateItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
