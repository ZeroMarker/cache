Class dbo.RPVisitNumberImage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberImage ]
{

Index IndexMaster On (VisitNumberDR, ImageClass, ImageID) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKVisitNumberImage created via DDL
ForeignKey FKVisitNumberImage(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberImage ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property ImageID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPVisitNumberImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>ImageClass</Value>
</Value>
<Value name="4">
<Value>ImageID</Value>
</Value>
<Value name="5">
<Value>FileName</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberImageD</DataLocation>
<DefaultData>RPVisitNumberImageDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberImageD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberImageI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
