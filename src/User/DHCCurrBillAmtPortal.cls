Class User.DHCCurrBillAmtPortal Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CBA_RowID, Not SqlRowIdPrivate, SqlTableName = DHC_CurrBillAmtPortal, StorageStrategy = NewStorage1 ]
{

Property CBAAdmDR As %String [ SqlColumnNumber = 2, SqlFieldName = CBA_Adm_DR ];

Property CBATotalAmt As %String [ SqlColumnNumber = 3, SqlFieldName = CBA_TotalAmt ];

Property CBAPatShare As %String [ SqlColumnNumber = 4, SqlFieldName = CBA_PatShare ];

Property CBAYBAmt As %String [ SqlColumnNumber = 5, SqlFieldName = CBA_YBAmt ];

Property CBADeposit As %String [ SqlColumnNumber = 6, SqlFieldName = CBA_Deposit ];

Property CBAWarrAmt As %String [ SqlColumnNumber = 7, SqlFieldName = CBA_WarrAmt ];

Property CBAQFFlag As %String [ SqlColumnNumber = 8, SqlFieldName = CBA_QFFlag ];

Property CBADate As %Date [ SqlColumnNumber = 9, SqlFieldName = CBA_Date ];

Property CBATime As %Time [ SqlColumnNumber = 10, SqlFieldName = CBA_Time ];

Index IndexAdmDR On CBAAdmDR As Exact;

Storage NewStorage1
{
<Data name="DHCCurrBillAmtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CBAAdmDR</Value>
</Value>
<Value name="3">
<Value>CBATotalAmt</Value>
</Value>
<Value name="4">
<Value>CBAPatShare</Value>
</Value>
<Value name="5">
<Value>CBAYBAmt</Value>
</Value>
<Value name="6">
<Value>CBADeposit</Value>
</Value>
<Value name="7">
<Value>CBAQFFlag</Value>
</Value>
<Value name="8">
<Value>CBADate</Value>
</Value>
<Value name="9">
<Value>CBATime</Value>
</Value>
<Value name="10">
<Value>CBAWarrAmt</Value>
</Value>
</Data>
<DataLocation>^User.DHCCurrBillAmtPortalD</DataLocation>
<DefaultData>DHCCurrBillAmtDefaultData</DefaultData>
<IdLocation>^User.DHCCurrBillAmtPortalD</IdLocation>
<IndexLocation>^User.DHCCurrBillAmtPortalI</IndexLocation>
<StreamLocation>^User.DHCCurrBillAmtPortalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
