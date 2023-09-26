Class dbo.BDPatInfoExtend Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PatInfoExtend, StorageStrategy = Default ]
{

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPATINFOEXTEND On RowID [ PrimaryKey, SqlName = PK_BD_PATINFOEXTEND, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 3 ];

Property Isdiscrepancy As %Library.Boolean [ SqlColumnNumber = 4 ];

Property ISNewSpec As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDPatInfoExtendDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>Isdiscrepancy</Value>
</Value>
<Value name="4">
<Value>ISNewSpec</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPatInfoExtendD</DataLocation>
<DefaultData>BDPatInfoExtendDefaultData</DefaultData>
<IdLocation>^dbo.BDPatInfoExtendD</IdLocation>
<IndexLocation>^dbo.BDPatInfoExtendI</IndexLocation>
<StreamLocation>^dbo.BDPatInfoExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
