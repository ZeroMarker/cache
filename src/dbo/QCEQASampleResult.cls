Class dbo.QCEQASampleResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQASampleResult, StorageStrategy = Default ]
{

/// Foreign Key FKResultSample created via DDL
ForeignKey FKResultSample(EQASampleDR) References dbo.QCEQASample(PKQCEQASAMPLE) [ SqlName = FKResultSample ];

/// Foreign Key FKResultTestCode created via DDL
ForeignKey FKResultTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FKResultTestCode ];

Index IndexMaster On (EQASampleDR, TestCodeDR) [ SqlName = IndexMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCEQASAMPLEResult On RowID [ PrimaryKey, SqlName = PK_QC_EQASAMPLEResult, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EQASampleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

Property ResScore As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property ResStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="QCEQASampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQASampleDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>ExtraRes</Value>
</Value>
<Value name="6">
<Value>Unit</Value>
</Value>
<Value name="7">
<Value>ResScore</Value>
</Value>
<Value name="8">
<Value>ResStatus</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQASampleResultD</DataLocation>
<DefaultData>QCEQASampleResultDefaultData</DefaultData>
<IdLocation>^dbo.QCEQASampleResultD</IdLocation>
<IndexLocation>^dbo.QCEQASampleResultI</IndexLocation>
<StreamLocation>^dbo.QCEQASampleResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
