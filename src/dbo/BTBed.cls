///     
Class dbo.BTBed Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Bed, StorageStrategy = Default ]
{

/// Foreign Key FKBedWard created via DDL
ForeignKey FKBedWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BedWard ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On HISCode [ SqlName = Index_HISCode, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexWard On WardDR [ SqlName = Index_Ward, Type = index ];

/// DDL Primary Key Specification
Index PKBTBED On RowID [ PrimaryKey, SqlName = PK_BT_BED, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTBedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HISCode</Value>
</Value>
<Value name="5">
<Value>WardDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTBedD</DataLocation>
<DefaultData>BTBedDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTBedD</IdLocation>
<IndexLocation>^dbo.BTBedI</IndexLocation>
<StreamLocation>^dbo.BTBedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
