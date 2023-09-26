///     
Class dbo.BTMICQCMatChild Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMICQC_MatChild ]
{

/// Foreign Key FKBTMICQCMatChildMICQCMaterialDR created via DDL
ForeignKey FKBTMICQCMatChildMICQCMaterialDR(MICQCMaterialDR) References dbo.BTMICQCMaterial(PKBTMICQCMATERIAL) [ SqlName = FK_BTMICQCMatChildMICQCMaterialDR ];

/// DDL Primary Key Specification
Index PKBTMICQCMATCHILD On RowID [ PrimaryKey, SqlName = PK_BTMICQC_MATCHILD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MICQCMaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property IndicatorLot As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Property IndicatorProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property IndicatorExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property MediumLot As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

Property MediumProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property MediumExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

Property RgProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property RgExpiryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTMICQCMatChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MICQCMaterialDR</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>IndicatorLot</Value>
</Value>
<Value name="6">
<Value>IndicatorProductDate</Value>
</Value>
<Value name="7">
<Value>IndicatorExpiryDate</Value>
</Value>
<Value name="8">
<Value>MediumLot</Value>
</Value>
<Value name="9">
<Value>MediumProductDate</Value>
</Value>
<Value name="10">
<Value>MediumExpiryDate</Value>
</Value>
<Value name="11">
<Value>RgLot</Value>
</Value>
<Value name="12">
<Value>RgProductDate</Value>
</Value>
<Value name="13">
<Value>RgExpiryDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICQCMatChildD</DataLocation>
<DefaultData>BTMICQCMatChildDefaultData</DefaultData>
<IdLocation>^dbo.BTMICQCMatChildD</IdLocation>
<IndexLocation>^dbo.BTMICQCMatChildI</IndexLocation>
<StreamLocation>^dbo.BTMICQCMatChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
