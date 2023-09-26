Class dbo.SYSUpdateLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UpdateLog ]
{

Index IndexUpdateDate On UpdateDate [ SqlName = Index_UpdateDate, Type = index ];

/// DDL Primary Key Specification
Index PKSYSUPDATELOG On RowID [ PrimaryKey, SqlName = PK_SYS_UPDATELOG, Type = index, Unique ];

Property RowID As %Library.Numeric(MAXVAL = 2147483647, MINVAL = -2147483648, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property UpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="SYSUpdateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpdateDate</Value>
</Value>
<Value name="3">
<Value>UpdateUser</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUpdateLogD</DataLocation>
<DefaultData>SYSUpdateLogDefaultData</DefaultData>
<IdLocation>^dbo.SYSUpdateLogD</IdLocation>
<IndexLocation>^dbo.SYSUpdateLogI</IndexLocation>
<StreamLocation>^dbo.SYSUpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
