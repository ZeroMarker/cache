///     
Class dbo.BBPhenotypeXMatch Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_PhenotypeXMatch, StorageStrategy = Default ]
{

Index IndexMaster On (PatientPhenotype, PackPhenotype) [ SqlName = Index_Master, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBPhenotypeXMatch On RowID [ PrimaryKey, SqlName = PK_BB_PhenotypeXMatch, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PatientPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property PackPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBPhenotypeXMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientPhenotype</Value>
</Value>
<Value name="3">
<Value>PackPhenotype</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBPhenotypeXMatchD</DataLocation>
<DefaultData>BBPhenotypeXMatchDefaultData</DefaultData>
<IdLocation>^dbo.BBPhenotypeXMatchD</IdLocation>
<IndexLocation>^dbo.BBPhenotypeXMatchI</IndexLocation>
<StreamLocation>^dbo.BBPhenotypeXMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
