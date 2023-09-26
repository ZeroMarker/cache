Class DHCEPRFS.INST.MRPrintChargeLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//打印收费日志表

Property MRPrintChargeID As %String;

Property ActionCode As %String;

Property ActDate As %Date;

Property ActTime As %Time;

Property ActUserID As %String;

Property Remark As %String;

Index IdxMRPrintChargeID On MRPrintChargeID;

Storage Default
{
<Data name="MRPrintChargeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPrintChargeID</Value>
</Value>
<Value name="3">
<Value>ActionCode</Value>
</Value>
<Value name="4">
<Value>ActDate</Value>
</Value>
<Value name="5">
<Value>ActTime</Value>
</Value>
<Value name="6">
<Value>ActUserID</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintChrgLogD</DataLocation>
<DefaultData>MRPrintChargeLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintChrgLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintChrgLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintChrgLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
