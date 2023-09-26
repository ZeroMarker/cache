Class User.ACCTVouchBuss Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_VouchBuss ]
{

Property AcctVouchDr As ACCTVouch [ Required, SqlFieldName = Acct_Vouch_Dr ];

Property BussNo As %String(MAXLEN = 30) [ Required, SqlFieldName = buss_no ];

Index PKVouchBussno On (AcctVouchDr, BussNo) [ Unique ];

Index PKBussnoVouch On (BussNo, AcctVouchDr) [ Unique ];

Storage Default
{
<Data name="ACCTVouchBussDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctVouchDr</Value>
</Value>
<Value name="3">
<Value>BussNo</Value>
</Value>
</Data>
<DataLocation>^User.ACCTVouchBussD</DataLocation>
<DefaultData>ACCTVouchBussDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTVouchBussD</IdLocation>
<IndexLocation>^User.ACCTVouchBussI</IndexLocation>
<StreamLocation>^User.ACCTVouchBussS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
