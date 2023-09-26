///     
Class dbo.BBReqProductLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductLink, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPLinkBloodProduct created via DDL
ForeignKey FKBBRPLinkBloodProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_RPLink_BloodProduct ];

/// Foreign Key FKBBRPLinkReqProduct created via DDL
ForeignKey FKBBRPLinkReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPLink_ReqProduct ];

/// Foreign Key FKBBRPLinkReqType created via DDL
ForeignKey FKBBRPLinkReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BB_RPLink_ReqType ];

Index IndexMaster On (ReqTypeDR, ReqProductDR, BloodProductDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTLINK On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTLINK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBReqProductLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqProductDR</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
<Value name="4">
<Value>ReqTypeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductLinkD</DataLocation>
<DefaultData>BBReqProductLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductLinkD</IdLocation>
<IndexLocation>^dbo.BBReqProductLinkI</IndexLocation>
<StreamLocation>^dbo.BBReqProductLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
