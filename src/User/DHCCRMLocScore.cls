Class User.DHCCRMLocScore Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = LS_RowId, SqlTableName = DHC_CRM_LocScore ]
{

Parameter ClassName = "User.DHCCRMLocScore";

Property LSDepartDR As User.RBCDepartmentGroup [ SqlColumnNumber = 2, SqlFieldName = LS_Depart_DR ];

Property LSYear As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = LS_Year ];

Property LSQuarter As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = LS_Quarter ];

Property LSMonth As %Library.String [ SqlColumnNumber = 5, SqlFieldName = LS_Month ];

Property LSScore As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = LS_Score ];

Property LSRemark As %Library.String(MAXLEN = 2000) [ SqlColumnNumber = 7, SqlFieldName = LS_Remark ];

Property LSLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = LS_Loc_DR ];

Index LSYearQuarterIndex On (LSYear, LSQuarter);

Index LSYearMonthIndex On (LSYear, LSMonth);

Index LSDepYearQIndex On (LSDepartDR, LSYear, LSQuarter);

Storage Default
{
<Data name="DHCCRMLocScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LSLocDR</Value>
</Value>
<Value name="3">
<Value>LSYear</Value>
</Value>
<Value name="4">
<Value>LSQuarter</Value>
</Value>
<Value name="5">
<Value>LSMonth</Value>
</Value>
<Value name="6">
<Value>LSScore</Value>
</Value>
<Value name="7">
<Value>LSRemark</Value>
</Value>
<Value name="8">
<Value>LSDepartDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMLocScoreD</DataLocation>
<DefaultData>DHCCRMLocScoreDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMLocScoreD</IdLocation>
<IndexLocation>^User.DHCCRMLocScoreI</IndexLocation>
<StreamLocation>^User.DHCCRMLocScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
