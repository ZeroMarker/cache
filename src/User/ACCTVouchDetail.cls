Class User.ACCTVouchDetail Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = Detail_Rowid, SqlTableName = ACCT_VouchDetail ]
{

/// des ref to ACCTVouch
Property AcctVouchParref As ACCTVouch [ SqlFieldName = ACCT_VouchParref ];

/// des ref to ACCTSubj
Property AcctSubjDr As ACCTSubj [ SqlFieldName = ACCT_Subj_Dr ];

Property VouchPage As %Integer [ Required, SqlFieldName = vouch_page ];

Property VouchRow As %Integer [ Required, SqlFieldName = vouch_row ];

Property AmtDebit As %Numeric [ InitialExpression = 0, Required, SqlFieldName = amt_debit ];

Property AmtCredit As %Numeric [ InitialExpression = 0, Required, SqlFieldName = amt_credit ];

Property NumDebit As %Numeric [ InitialExpression = 0, Required, SqlFieldName = num_debit ];

Property NumCredit As %Numeric [ InitialExpression = 0, Required, SqlFieldName = num_credit ];

Property summary As %String(MAXLEN = 100) [ Required, SqlFieldName = summary ];

Storage Default
{
<Data name="ACCTVouchDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSubjDr</Value>
</Value>
<Value name="3">
<Value>AcctVouchParref</Value>
</Value>
<Value name="4">
<Value>AmtCredit</Value>
</Value>
<Value name="5">
<Value>AmtDebit</Value>
</Value>
<Value name="6">
<Value>NumCredit</Value>
</Value>
<Value name="7">
<Value>NumDebit</Value>
</Value>
<Value name="8">
<Value>VouchPage</Value>
</Value>
<Value name="9">
<Value>VouchRow</Value>
</Value>
<Value name="10">
<Value>summary</Value>
</Value>
</Data>
<DataLocation>^User.ACCTVouchDetailD</DataLocation>
<DefaultData>ACCTVouchDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTVouchDetailD</IdLocation>
<IndexLocation>^User.ACCTVouchDetailI</IndexLocation>
<StreamLocation>^User.ACCTVouchDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
