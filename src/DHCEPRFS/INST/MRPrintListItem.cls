Class DHCEPRFS.INST.MRPrintListItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 打印暂存明细项目
Property MRPrintListRecID As %String;

Property DetailNum As %Integer;

Property MRVerItemID As %String;

Property MRItemID As %String;

Property MRItemDesc As %String;

Property OriginalPageTotal As %Integer;

Property PrintPageTotal As %Integer;

Property PageNumStr As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxMRPrintListRecID On MRPrintListRecID;

Storage Default
{
<Data name="MRPrintListItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPrintListRecID</Value>
</Value>
<Value name="3">
<Value>VerItemID</Value>
</Value>
<Value name="4">
<Value>MRItemID</Value>
</Value>
<Value name="5">
<Value>MRItemDesc</Value>
</Value>
<Value name="6">
<Value>OriginalPageTotal</Value>
</Value>
<Value name="7">
<Value>PrintPageTotal</Value>
</Value>
<Value name="8">
<Value>PageNumStr</Value>
</Value>
<Value name="9">
<Value>MRVerItemID</Value>
</Value>
<Value name="10">
<Value>DetailNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintListItemD</DataLocation>
<DefaultData>MRPrintListItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintListItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintListItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintListItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
