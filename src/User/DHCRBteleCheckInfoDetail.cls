/// 114接口对帐明细信息
Class User.DHCRBteleCheckInfoDetail Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// HIS预约纪录ID
Property ApptId As %String(TRUNCATE = 1);

/// 预约费
Property BookedFee As %String(TRUNCATE = 1);

/// **指向DHCRBteleCheckInfo
Property CheckInfoRef As User.DHCRBteleCheckInfo;

/// 诊查费
Property ExamineFee As %String(TRUNCATE = 1);

/// 挂号费
Property RegistrationFee As %String(TRUNCATE = 1);

/// 交易日期
Property TransactionDate As %Date;

/// 发起方交易流水号
Property SRCTransactionId As %String(TRUNCATE = 1);

/// 交易类型（约定：T01预约，T02取消预约，T03取号，T04违约）
Property TransactionType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCRBteleCheckInfoDetailDefaultData">
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
<Value>CheckInfoRef</Value>
</Value>
<Value name="5">
<Value>ExamineFee</Value>
</Value>
<Value name="6">
<Value>RegistrationFee</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>SRCTransactionId</Value>
</Value>
<Value name="9">
<Value>TransactionDate</Value>
</Value>
<Value name="10">
<Value>TransactionType</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBteleCheckInfoDetailD</DataLocation>
<DefaultData>DHCRBteleCheckInfoDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBteleCheckInfoDetailD</IdLocation>
<IndexLocation>^User.DHCRBteleCheckInfoDetailI</IndexLocation>
<StreamLocation>^User.DHCRBteleCheckInfoDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
