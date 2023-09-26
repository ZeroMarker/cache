Class User.CSSDItem Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_Item ]
{

Property CSSDIDesc As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSDI_Desc ];

Property CSSDISpec As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDI_Spec ];

Property CSSDIPrice As %Numeric [ InitialExpression = 0, SqlColumnNumber = 4, SqlFieldName = CSSDI_Price ];

Property CSSDIUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = CSSDI_UseFlag ];

Property CSSDIRemarks As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDI_Remarks ];

Property CSSDICreateLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = CSSDI_CreateLocDr ];

Property CSSDIAlias As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDI_Alias ];

/// 一次性标志
Property CSSDIOneOffFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = CSSDI_OneOffFlag ];

/// 是否植入物
Property CSSDIImplantsFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = CSSDI_ImplantsFlag ];

Index CSSDIDescSPecCreateLocIndex On (CSSDIDesc As Exact, CSSDISpec As Exact, CSSDICreateLocDr As Exact);

Index IdxCSSDIDesc On CSSDIDesc As Exact;

Storage Default
{
<Data name="CSSDItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDIDesc</Value>
</Value>
<Value name="3">
<Value>CSSDISpec</Value>
</Value>
<Value name="4">
<Value>CSSDIPrice</Value>
</Value>
<Value name="5">
<Value>CSSDIUseFlag</Value>
</Value>
<Value name="6">
<Value>CSSDIRemarks</Value>
</Value>
<Value name="7">
<Value>CSSDICreateLocDr</Value>
</Value>
<Value name="8">
<Value>CSSDIAlias</Value>
</Value>
<Value name="9">
<Value>CSSDIOneOffFlag</Value>
</Value>
<Value name="10">
<Value>CSSDIImplantsFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDItemD</DataLocation>
<DefaultData>CSSDItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDItemD</IdLocation>
<IndexLocation>^User.CSSDItemI</IndexLocation>
<StreamLocation>^User.CSSDItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
