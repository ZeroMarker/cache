Class User.ACCTVouch Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = Vouch_Rowid, SqlTableName = ACCT_Vouch ]
{

/// des ref to ACCTYearPeriod
Property AcctYearPeriod As ACCTYearPeriod [ SqlFieldName = ACCT_YearPeriod_Dr ];

/// des ref to ACCTVouchType
Property AcctVouchTypeDr As ACCTVouchType [ SqlFieldName = ACCT_VouchType_Dr ];

/// des ref to AcctVouchSource
Property VouchSource As %String [ SqlFieldName = vouch_source ];

/// des ref to ACCTSysBusiType
Property AcctBusiTypeDr As ACCTSysBusiType [ SqlFieldName = ACCT_BusiType_Dr ];

Property VouchNo As %String(MAXLEN = 50) [ Required, SqlFieldName = vouch_no ];

Property VouchNoUse As %String(MAXLEN = 20) [ Required, SqlFieldName = vouch_no_use ];

Property VouchDate As %Date [ Required, SqlFieldName = vouch_date ];

Property VouchBillNum As %Integer [ Required, SqlFieldName = vouch_bill_num ];

Property Operator As %String(MAXLEN = 40) [ SqlFieldName = operator ];

Property Auditor As %String(MAXLEN = 40) [ SqlFieldName = auditor ];

Property Poster As %String(MAXLEN = 40) [ SqlFieldName = poster ];

Property IsCheck As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_check ];

Property IsAcc As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_acc ];

Property IsCx As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_cx ];

Property IsCancel As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_cancel ];

Property CVouchId As %Integer [ SqlFieldName = c_vouch_id ];

Property OutSubjCode As %String(MAXLEN = 30) [ SqlFieldName = out_subj_code ];

Index IndexACCTVouchNo On VouchNo [ Unique ];

Storage Default
{
<Data name="ACCTVouchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctMonth</Value>
</Value>
<Value name="3">
<Value>AcctSubjDr</Value>
</Value>
<Value name="4">
<Value>AcctVouchSourceDr</Value>
</Value>
<Value name="5">
<Value>AcctVouchTypeDr</Value>
</Value>
<Value name="6">
<Value>AcctYearDr</Value>
</Value>
<Value name="7">
<Value>Auditor</Value>
</Value>
<Value name="8">
<Value>CVouchId</Value>
</Value>
<Value name="9">
<Value>IsAcc</Value>
</Value>
<Value name="10">
<Value>IsCancel</Value>
</Value>
<Value name="11">
<Value>IsCheck</Value>
</Value>
<Value name="12">
<Value>IsCx</Value>
</Value>
<Value name="13">
<Value>Operator</Value>
</Value>
<Value name="14">
<Value>OutSubjCode</Value>
</Value>
<Value name="15">
<Value>Poster</Value>
</Value>
<Value name="16">
<Value>VouchBillNum</Value>
</Value>
<Value name="17">
<Value>VouchDate</Value>
</Value>
<Value name="18">
<Value>VouchNo</Value>
</Value>
<Value name="19">
<Value>VouchNoUse</Value>
</Value>
<Value name="20">
<Value>AcctBusiTypeDr</Value>
</Value>
<Value name="21">
<Value>AcctYearPeriod</Value>
</Value>
<Value name="22">
<Value>VouchSource</Value>
</Value>
</Data>
<DataLocation>^User.ACCTVouchD</DataLocation>
<DefaultData>ACCTVouchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTVouchD</IdLocation>
<IndexLocation>^User.ACCTVouchI</IndexLocation>
<StreamLocation>^User.ACCTVouchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
