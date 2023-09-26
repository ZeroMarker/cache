/// 114接口对帐差异明细信息
Class User.DHCRBteleErrorCheckInfoDetail Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 对帐流水号
Property CheckId As %String(TRUNCATE = 1);

/// HIS预约纪录ID
Property ApptId As %String(TRUNCATE = 1);

/// 预约费
Property BookedFee As %String(TRUNCATE = 1);

/// 诊查费
Property ExamineFee As %String(TRUNCATE = 1);

/// 挂号费
Property RegistrationFee As %String(TRUNCATE = 1);

/// 说明
Property Remark As %String(TRUNCATE = 1);

/// 交易日期
Property TransactionDate As %Date;

/// 发起方交易流水号
Property SRCTransactionId As %String(TRUNCATE = 1);

/// 交易类型（约定：T01预约，T02取消预约，T03取号，T04违约）
Property TransactionType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCRBteleErrorCheckInfoDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApptId</Value>
</Value>
<Value name="3">
<Value>BookedFee</Value>
</Value>
<Value name="4">
<Value>ExamineFee</Value>
</Value>
<Value name="5">
<Value>RegistrationFee</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>SRCTransactionId</Value>
</Value>
<Value name="8">
<Value>TransactionDate</Value>
</Value>
<Value name="9">
<Value>TransactionType</Value>
</Value>
<Value name="10">
<Value>CheckId</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBteleErrAD4D</DataLocation>
<DefaultData>DHCRBteleErrorCheckInfoDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBteleErrAD4D</IdLocation>
<IndexLocation>^User.DHCRBteleErrAD4I</IndexLocation>
<StreamLocation>^User.DHCRBteleErrAD4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
