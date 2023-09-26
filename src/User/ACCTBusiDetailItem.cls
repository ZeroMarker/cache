Class User.ACCTBusiDetailItem Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_BusiDetailItem ]
{

/// des ref to ACCTBusiDetail
Property AcctBusiDetailDr As ACCTBusiDetail [ SqlFieldName = ACCT_BusiDetail_Dr ];

Property IntoutTypeCode As %String(MAXLEN = 20) [ Required, SqlFieldName = intout_type_code ];

Property AcctSubjCode As %String(MAXLEN = 50) [ Required, SqlFieldName = acct_subj_code ];

Index PKAcctBusiDetail On (AcctBusiDetailDr, IntoutTypeCode) [ Unique ];

Storage Default
{
<Data name="ACCTBusiDetailItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctBusiDetailDr</Value>
</Value>
<Value name="3">
<Value>AcctSubjCode</Value>
</Value>
<Value name="4">
<Value>IntoutTypeCode</Value>
</Value>
</Data>
<DataLocation>^User.ACCTBusiDetailItemD</DataLocation>
<DefaultData>ACCTBusiDetailItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTBusiDetailItemD</IdLocation>
<IndexLocation>^User.ACCTBusiDetailItemI</IndexLocation>
<StreamLocation>^User.ACCTBusiDetailItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
