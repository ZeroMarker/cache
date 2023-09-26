///     
Class dbo.BDTransClassPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TransClassPack, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index IndexMaster On (BDTransClassDR, TransPackType, TransPackDR) [ PrimaryKey, SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKTransClassPackPack created via DDL
ForeignKey FKTransClassPackPack(TransPackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_TransClassPack_Pack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BDTransClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TransPackType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TransPackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDTransClassPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>BDTransClassDR</Value>
</Value>
<Value name="4">
<Value>TransPackType</Value>
</Value>
<Value name="5">
<Value>TransPackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTransClassPackD</DataLocation>
<DefaultData>BDTransClassPackDefaultData</DefaultData>
<IdLocation>^dbo.BDTransClassPackD</IdLocation>
<IndexLocation>^dbo.BDTransClassPackI</IndexLocation>
<StreamLocation>^dbo.BDTransClassPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
