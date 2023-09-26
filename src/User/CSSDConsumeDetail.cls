/// 消耗的明细
Class User.CSSDConsumeDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDCD_Rowid, SqlTableName = CSSD_ConsumeDetail ]
{

/// 消耗数量
Property CSSDCDConsumeQty As %Numeric [ SqlColumnNumber = 2, SqlFieldName = CSSDCD_ConsumeQty ];

Property CSSDCDItmDr As User.CSSDItem [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDCD_Itm_DR ];

Property CSSDCDLocDr As User.CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = CSSDCD_Loc_DR ];

Property CSSDCDCallback As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDCD_Callback_Dr ];

Property CSSDCDCompleteFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 10, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 8, SqlFieldName = CSSDCD_CompleteFlag ];

Property CSSDCDLabel As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 9, SqlFieldName = CSSDCD_Label ];

Property CSSDCDConsumeReasonDr As User.CSSDMachineConsumeReason [ SqlColumnNumber = 10, SqlFieldName = CSSDCD_ConsumeReason_DR ];

Index CSSDCDCompFlagLabelIndex On (CSSDCDCompleteFlag As Exact, CSSDCDLabel As Exact, CSSDCDItmDr As Exact);

Index CSSDCDCallbackItmIndex On (CSSDCDCallback As Exact, CSSDCDItmDr As Exact);

Index CSSDCDLabelItmIndex On (CSSDCDLabel As Exact, CSSDCDItmDr As Exact);

Storage Default
{
<Data name="CSSDConsumeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCDConsumeQty</Value>
</Value>
<Value name="3">
<Value>CSSDCDItmDr</Value>
</Value>
<Value name="4">
<Value>CSSDCDLocDr</Value>
</Value>
<Value name="5"/>
<Value name="6"/>
<Value name="7">
<Value>CSSDCDCallback</Value>
</Value>
<Value name="8">
<Value>CSSDCDCompleteFlag</Value>
</Value>
<Value name="9">
<Value>CSSDCDLabel</Value>
</Value>
<Value name="10">
<Value>CSSDCDConsumeReasonDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDConsumeDetailD</DataLocation>
<DefaultData>CSSDConsumeDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDConsumeDetailD</IdLocation>
<IndexLocation>^User.CSSDConsumeDetailI</IndexLocation>
<SqlRowIdName>CSSDCD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDConsumeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
