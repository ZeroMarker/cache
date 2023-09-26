///     
Class dbo.SYSFormUpdateLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_FormUpdateLog ]
{

Index IndexMaster On (FormDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKSYSFormUpdateLogFormDR created via DDL
ForeignKey FKSYSFormUpdateLogFormDR(FormDR) References dbo.SYSForm(PKSYSForm) [ SqlName = FK_SYSFormUpdateLogFormDR ];

/// DDL Primary Key Specification
Index PKSYSFORMUPDATELOG On RowID [ PrimaryKey, SqlName = PK_SYS_FORMUPDATELOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property FormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="SYSFormUpdateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FormDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFormUpdateLogD</DataLocation>
<DefaultData>SYSFormUpdateLogDefaultData</DefaultData>
<IdLocation>^dbo.SYSFormUpdateLogD</IdLocation>
<IndexLocation>^dbo.SYSFormUpdateLogI</IndexLocation>
<StreamLocation>^dbo.SYSFormUpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
