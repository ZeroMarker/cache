Class DHCEPRFS.INST.MRPrintListFee Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

// 打印暂存费用明细表

/// MRPrintChargeID
Property MRPrintChargeID As %String;

/// MREpisodeID
Property MREpisodeID As %String;

/// MRMedRecordID
Property MRMedRecordID As %String;

/// 收费类型编码
Property ChargeTypeCode As %String;

/// 流水号
Property DetailNum As %String;

/// 数量
Property Quan As %Integer;

/// 单价
Property Price As %Float;

/// 金额
Property Amount As %Float;

Index IdxMRPrintChargeID On MRPrintChargeID;

Storage Default
{
<Data name="MRPrintListFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPrintChargeID</Value>
</Value>
<Value name="3">
<Value>ChargeTypeCode</Value>
</Value>
<Value name="4">
<Value>DetailNum</Value>
</Value>
<Value name="5">
<Value>MREpisodeID</Value>
</Value>
<Value name="6">
<Value>MRMedRecordID</Value>
</Value>
<Value name="7">
<Value>Quan</Value>
</Value>
<Value name="8">
<Value>Price</Value>
</Value>
<Value name="9">
<Value>Amount</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintListFeeD</DataLocation>
<DefaultData>MRPrintListFeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintListFeeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintListFeeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintListFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
