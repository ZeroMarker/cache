/// 工作量明细
Class dbo.BSDepWorkLoadItem Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_DepWorkLoadItem ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSDepWorkLoadDR) References dbo.BSDepWorkLoad(PKWorkLoadId) [ SqlName = FK_BS_DepWorkLoadItemDR ];

Index IndexMaster On (BSDepWorkLoadDR, OperationRowId) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSDepWorkLoadDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  操作类型业务Id
Property OperationRowId As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4 ];

/// 操作时间
Property OperationTime As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BSDepWorkLoadItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSDepWorkLoadDR</Value>
</Value>
<Value name="3">
<Value>OperationRowId</Value>
</Value>
<Value name="4">
<Value>OperationTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDepWorkLoadItemD</DataLocation>
<DefaultData>BSDepWorkLoadItemDefaultData</DefaultData>
<IdLocation>^dbo.BSDepWorkLoadItemD</IdLocation>
<IndexLocation>^dbo.BSDepWorkLoadItemI</IndexLocation>
<StreamLocation>^dbo.BSDepWorkLoadItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
