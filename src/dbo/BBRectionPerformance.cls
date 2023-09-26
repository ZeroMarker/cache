///     
Class dbo.BBRectionPerformance Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_RectionPerformance, StorageStrategy = Default ]
{

/// Foreign Key FKBBRECTITYPE created via DDL
ForeignKey FKBBRECTITYPE(RectionTypeDR) References dbo.BBRectionPerformanceType(PKBBRECTIONPERFORMANCETYPE) [ SqlName = FK_BB_RECTI_TYPE ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexRectionPerformance On RectionTypeDR [ SqlName = Index_RectionPerformance, Type = index ];

Index IndexSeqNum On (RectionTypeDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBRECTIONPERFORMANCE On RowID [ PrimaryKey, SqlName = PK_BB_RECTIONPERFORMANCE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property RectionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

Property DataType As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBRectionPerformanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>RectionTypeDR</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>CName</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRectionPerformanceD</DataLocation>
<DefaultData>BBRectionPerformanceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBRectionPerformanceD</IdLocation>
<IndexLocation>^dbo.BBRectionPerformanceI</IndexLocation>
<StreamLocation>^dbo.BBRectionPerformanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
