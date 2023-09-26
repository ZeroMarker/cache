/// 114接口对帐信息
Class User.DHCRBteleCheckInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 预约次数
Property BookedCount As %String(TRUNCATE = 1);

/// 预约费总额
Property BookedFee As %String(TRUNCATE = 1);

/// 预约交易号串
Property BookedStr As %String(TRUNCATE = 1);

/// 取消预约次数
Property CancelCount As %String(TRUNCATE = 1);

/// 取消预约交易号串
Property CancelStr As %String(TRUNCATE = 1);

/// 对帐流水号
Property CheckId As %String(TRUNCATE = 1);

/// **对帐状态(约定：0不成功、1成功)
Property CheckStatus As %String(TRUNCATE = 1);

/// 诊查费总额
Property ExamineFee As %String(TRUNCATE = 1);

/// 取号次数
Property FixedCount As %String(TRUNCATE = 1);

/// 取号交易号串
Property FixedStr As %String(TRUNCATE = 1);

/// 违约次数
Property OverdueCount As %String(TRUNCATE = 1);

/// 违约交易号串
Property OverdueStr As %String(TRUNCATE = 1);

/// 挂号费总额
Property RegistrationFee As %String(TRUNCATE = 1);

/// 交易日期
Property TransactionDate As %Date;

Storage Default
{
<Data name="DHCRBteleCheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BookedCount</Value>
</Value>
<Value name="3">
<Value>BookedFee</Value>
</Value>
<Value name="4">
<Value>BookedStr</Value>
</Value>
<Value name="5">
<Value>CancelCount</Value>
</Value>
<Value name="6">
<Value>CancelStr</Value>
</Value>
<Value name="7">
<Value>CheckId</Value>
</Value>
<Value name="8">
<Value>CheckStatus</Value>
</Value>
<Value name="9">
<Value>ExamineFee</Value>
</Value>
<Value name="10">
<Value>FixedCount</Value>
</Value>
<Value name="11">
<Value>FixedStr</Value>
</Value>
<Value name="12">
<Value>OverdueCount</Value>
</Value>
<Value name="13">
<Value>OverdueStr</Value>
</Value>
<Value name="14">
<Value>RegistrationFee</Value>
</Value>
<Value name="15">
<Value>TransactionDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBteleCheckInfoD</DataLocation>
<DefaultData>DHCRBteleCheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBteleCheckInfoD</IdLocation>
<IndexLocation>^User.DHCRBteleCheckInfoI</IndexLocation>
<StreamLocation>^User.DHCRBteleCheckInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
