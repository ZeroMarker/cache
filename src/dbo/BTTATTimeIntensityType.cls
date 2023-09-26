///     
Class dbo.BTTATTimeIntensityType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeIntensityType, StorageStrategy = Default ]
{

/// Foreign Key FKTATTimeIntensityType created via DDL
ForeignKey FKTATTimeIntensityType(TimeIntensityDR) References dbo.BTTATTimeIntensity(PKBTTATTIMEINTENSITY) [ SqlName = FK_TATTimeIntensityType ];

Index IndexCode On (TimeIntensityDR, Sequence) [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTATTIMEINTENSITYTYPE On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMEINTENSITYTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TimeIntensityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property OperationSymbol As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property TimeData As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTATTimeIntensityTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeIntensityDR</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>OperationSymbol</Value>
</Value>
<Value name="5">
<Value>TimeData</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeIntensityTypeD</DataLocation>
<DefaultData>BTTATTimeIntensityTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTimeIntensityTypeD</IdLocation>
<IndexLocation>^dbo.BTTATTimeIntensityTypeI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeIntensityTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
