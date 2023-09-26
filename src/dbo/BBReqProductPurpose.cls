///     
Class dbo.BBReqProductPurpose Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductPurpose, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPPPurpose created via DDL
ForeignKey FKBBRPPPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_BB_RPP_Purpose ];

/// Foreign Key FKBBRPPReqProduct created via DDL
ForeignKey FKBBRPPReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPP_ReqProduct ];

Index IndexMaster On (ReqProductDR, PurposeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPurpose On (PurposeDR, ReqProductDR) [ SqlName = Index_Purpose, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTPURPOSE On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTPURPOSE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBReqProductPurposeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqProductDR</Value>
</Value>
<Value name="3">
<Value>PurposeDR</Value>
</Value>
<Value name="4">
<Value>IsDefault</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductPurposeD</DataLocation>
<DefaultData>BBReqProductPurposeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductPurposeD</IdLocation>
<IndexLocation>^dbo.BBReqProductPurposeI</IndexLocation>
<StreamLocation>^dbo.BBReqProductPurposeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
