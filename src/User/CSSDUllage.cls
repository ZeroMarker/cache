/// 报损主表
Class User.CSSDUllage Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_Ullage ]
{

Property CSSDUNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDU_No ];

Property CSSDULoc As CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDU_Loc ];

Property CSSDUDt As %TimeStamp [ SqlColumnNumber = 4, SqlFieldName = CSSDU_Dt ];

Property CSSDURegister As SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDU_Register ];

Property CSSDUResult As %Integer [ SqlColumnNumber = 6, SqlFieldName = CSSDU_Result ];

Property CSSDUYearMonth As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDU_YearMonth ];

Property CSSDUHospital As CTHospital [ SqlColumnNumber = 8, SqlFieldName = CSSDU_Hospital ];

Property CSSDUComplateFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = CSSDU_ComplateFlag ];

/// 报损登记日期
Property CSSDUDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = CSSDU_Date ];

/// 报损登记时间
Property CSSDUTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = CSSDU_Time ];

Index DateLoc On (CSSDUDate As Exact, CSSDULoc As Exact);

Storage Default
{
<Data name="CSSDUllageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDUNo</Value>
</Value>
<Value name="3">
<Value>CSSDULoc</Value>
</Value>
<Value name="4">
<Value>CSSDUDt</Value>
</Value>
<Value name="5">
<Value>CSSDURegister</Value>
</Value>
<Value name="6">
<Value>CSSDUResult</Value>
</Value>
<Value name="7">
<Value>CSSDUYearMonth</Value>
</Value>
<Value name="8">
<Value>CSSDUHospital</Value>
</Value>
<Value name="9">
<Value>CSSDUComplateFlag</Value>
</Value>
<Value name="10">
<Value>CSSDUDate</Value>
</Value>
<Value name="11">
<Value>CSSDUTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDUllageD</DataLocation>
<DefaultData>CSSDUllageDefaultData</DefaultData>
<IdLocation>^User.CSSDUllageD</IdLocation>
<IndexLocation>^User.CSSDUllageI</IndexLocation>
<StreamLocation>^User.CSSDUllageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
