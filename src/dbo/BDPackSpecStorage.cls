///     
Class dbo.BDPackSpecStorage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackSpecStorage, StorageStrategy = Default ]
{

Index IndexMaster On (SpecimenRackDR, PositionNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPackSpecNo On PackSpecNo [ SqlName = Index_PackSpecNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackSpecStorage On RowID [ PrimaryKey, SqlName = PK_BD_PackSpecStorage, Type = index, Unique ];

/// Foreign Key FKPackSpecStorageSpecimenRack created via DDL
ForeignKey FKPackSpecStorageSpecimenRack(SpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_PackSpecStorage_SpecimenRack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackSpecNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 5 ];

Property AddDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDPackSpecStorageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecimenRackDR</Value>
</Value>
<Value name="3">
<Value>PositionNo</Value>
</Value>
<Value name="4">
<Value>PackSpecNo</Value>
</Value>
<Value name="5">
<Value>AddDays</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackSpecStorageD</DataLocation>
<DefaultData>BDPackSpecStorageDefaultData</DefaultData>
<IdLocation>^dbo.BDPackSpecStorageD</IdLocation>
<IndexLocation>^dbo.BDPackSpecStorageI</IndexLocation>
<StreamLocation>^dbo.BDPackSpecStorageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
