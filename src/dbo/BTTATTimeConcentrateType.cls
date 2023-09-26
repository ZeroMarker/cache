///     
Class dbo.BTTATTimeConcentrateType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeConcentrateType, StorageStrategy = Default ]
{

/// Foreign Key FKTATTimeConcentrateType created via DDL
ForeignKey FKTATTimeConcentrateType(TimeConcentrateDR) References dbo.BTTATTimeConcentrate(PKBTTATTIMECONCENTRATE) [ SqlName = FK_TATTimeConcentrateType ];

Index IndexCode On (TimeConcentrateDR, Sequence) [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTATTIMECONCENTRATETYPE On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMECONCENTRATETYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TimeConcentrateDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property OperationSymbol As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property TimeData As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTATTimeConcentrateTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeConcentrateDR</Value>
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
<DataLocation>^dbo.BTTATTimeConcentrateTypeD</DataLocation>
<DefaultData>BTTATTimeConcentrateTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTimeConcentrateTypeD</IdLocation>
<IndexLocation>^dbo.BTTATTimeConcentrateTypeI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeConcentrateTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
