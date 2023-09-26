/// 术语库字典表：TKB_TremBase （父）
Class User.TKBTremBase Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = TKB_TremBase ]
{

Relationship ChildField As User.TKBTremBaseField [ Cardinality = children, Inverse = ParRef ];

Property TKBTRBCode As %String [ Required, SqlFieldName = TKBTRB_Code ];

Property TKBTRBDesc As %String [ SqlFieldName = TKBTRB_Desc ];

Property TKBTRBType As %String(DISPLAYLIST = ",列表,树形", VALUELIST = ",L,T") [ SqlFieldName = TKBTRB_Type ];

Property TKBTRBVersion As %String [ SqlFieldName = TKBTRB_Version ];

Property TKBTRBSource As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlFieldName = TKBTRB_Source ];

Property TKBTRBPYCode As %String [ SqlFieldName = TKBTRB_PYCode ];

Property TKBTRBNote As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlFieldName = TKBTRB_Note ];

Property TKBTRBName As %String [ SqlFieldName = TKBTRB_Name ];

Property TKBTRBDispName As %String [ SqlFieldName = TKBTRB_DispName ];

Property TKBTRBCatDr As %String [ SqlFieldName = TKBTRB_Cat_Dr ];

Property TKBTRBFlag As %String(DISPLAYLIST = ",诊断,药品,检验,检查,手术,分类", VALUELIST = ",Diagnose,Drug,Lab,Check,Operation,Cat") [ SqlFieldName = TKBTRB_Flag ];

Property TKBTRBExtendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlFieldName = TKBTRB_ExtendFlag ];

Property TKBTRBSequence As %String [ SqlFieldName = TKBTRB_Sequence ];

Index CodeIndex On TKBTRBCode [ Unique ];

Index DescIndex On TKBTRBDesc [ Unique ];

Index FlagIndex On TKBTRBFlag [ Unique ];

Storage Default
{
<Data name="TKBTremBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBTRBCode</Value>
</Value>
<Value name="3">
<Value>TKBTRBDesc</Value>
</Value>
<Value name="4">
<Value>TKBTRBType</Value>
</Value>
<Value name="5">
<Value>TKBTRBVersion</Value>
</Value>
<Value name="6">
<Value>TKBTRBSource</Value>
</Value>
<Value name="7">
<Value>TKBTRBPYCode</Value>
</Value>
<Value name="8">
<Value>TKBTRBNote</Value>
</Value>
<Value name="9">
<Value>TKBTRBName</Value>
</Value>
<Value name="10">
<Value>TKBTRBDispName</Value>
</Value>
<Value name="11">
<Value>TKBTRBCatDr</Value>
</Value>
<Value name="12">
<Value>TKBTRBFlag</Value>
</Value>
<Value name="13">
<Value>TKBTRBExtendFlag</Value>
</Value>
<Value name="14">
<Value>TKBTRBSequence</Value>
</Value>
</Data>
<DataLocation>^User.TKBTremBaseD</DataLocation>
<DefaultData>TKBTremBaseDefaultData</DefaultData>
<IdLocation>^User.TKBTremBaseD</IdLocation>
<IndexLocation>^User.TKBTremBaseI</IndexLocation>
<StreamLocation>^User.TKBTremBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
