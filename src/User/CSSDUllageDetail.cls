/// 报损明细
Class User.CSSDUllageDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_UllageDetail ]
{

Property CSSDUDMainDr As User.CSSDUllage [ SqlColumnNumber = 2, SqlFieldName = CSSDUD_MainDr ];

Property CSSDUDPkg As CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDUD_Pkg ];

Property CSSDUDItem As CSSDItem [ SqlColumnNumber = 4, SqlFieldName = CSSDUD_Item ];

Property CSSDUDNum As %Integer [ SqlColumnNumber = 5, SqlFieldName = CSSDUD_Num ];

Property CSSDUDUnitPrice As %Float [ SqlColumnNumber = 6, SqlFieldName = CSSDUD_UnitPrice ];

Property CSSDUDRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDUD_Remark ];

Property CSSDUDLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDUD_Label ];

Property CSSDUDConsumeReasonDr As User.CSSDMachineConsumeReason [ SqlColumnNumber = 9, SqlFieldName = CSSDUD_ConsumeReason_DR ];

Index CSSDUDDetailItemIndex On (CSSDUDMainDr As Exact, CSSDUDItem As Exact, CSSDUDConsumeReasonDr As Exact);

Index CSSDUDLabelItmIndex On (CSSDUDLabel As Exact, CSSDUDItem As Exact);

Index CSSDUDMainDrIndex On CSSDUDMainDr As Exact;

Index MainItemIndex On (CSSDUDMainDr As Exact, CSSDUDItem As Exact);

Storage Default
{
<Data name="CSSDUllageDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDUDMainDr</Value>
</Value>
<Value name="3">
<Value>CSSDUDPkg</Value>
</Value>
<Value name="4">
<Value>CSSDUDItem</Value>
</Value>
<Value name="5">
<Value>CSSDUDNum</Value>
</Value>
<Value name="6">
<Value>CSSDUDUnitPrice</Value>
</Value>
<Value name="7">
<Value>CSSDUDRemark</Value>
</Value>
<Value name="8">
<Value>CSSDUDLabel</Value>
</Value>
<Value name="9">
<Value>CSSDUDConsumeReasonDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDUllageDetailD</DataLocation>
<DefaultData>CSSDUllageDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDUllageDetailD</IdLocation>
<IndexLocation>^User.CSSDUllageDetailI</IndexLocation>
<StreamLocation>^User.CSSDUllageDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
