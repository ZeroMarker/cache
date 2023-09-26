Class DHCEPRFS.INST.MRPrintInvoice Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//打印收费发票表

//打印收费ID

Property MRPrintChargeID As %String;

//发票号

Property InvoiceNO As %String;

//操作日期

Property ActDate As %Date;

//操作时间

Property ActTime As %Time;

//操作员

Property ActUserID As %String;

//取消标志(0/1)

Property CancelFlag As %String;

//取消原因

Property CancelReason As %String;

Index IdxMRPrintChargeID On MRPrintChargeID;

Storage Default
{
<Data name="MRPrintInvoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPrintChargeID</Value>
</Value>
<Value name="3">
<Value>InvoiceNO</Value>
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
<Value>CancelFlag</Value>
</Value>
<Value name="8">
<Value>CancelReason</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintInvoiceD</DataLocation>
<DefaultData>MRPrintInvoiceDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MRPrintInvoiceD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintInvoiceI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintInvoiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
