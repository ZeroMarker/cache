///     
Class dbo.BDAGCollFormProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollFormProduct, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormProduct created via DDL
ForeignKey FKAGCollFormProduct(AGCollectFormDR) References dbo.BDAGCollForm(PKBDAGCOLLFORM) [ SqlName = FK_AGCollFormProduct ];

/// Foreign Key FKAGCollFormProduct2 created via DDL
ForeignKey FKAGCollFormProduct2(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_AGCollFormProduct2 ];

Index IndexMaster On (AGCollectFormDR, ReqProductDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGCOLLFORMPRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_AGCOLLFORMPRODUCT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGCollectFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Volume As %Library.Float [ SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDAGCollFormProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGCollectFormDR</Value>
</Value>
<Value name="3">
<Value>ReqProductDR</Value>
</Value>
<Value name="4">
<Value>Volume</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormProductD</DataLocation>
<DefaultData>BDAGCollFormProductDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormProductD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormProductI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
