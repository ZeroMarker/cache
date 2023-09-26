Class dbo.BBReqProductAuto Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductAuto ]
{

/// Foreign Key FKBBAIReqProductLinkReqProductDR created via DDL
ForeignKey FKBBAIReqProductLinkReqProductDR(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BBAIReqProductLinkReqProductDR ];

/// Foreign Key FKBBAIReqProductLinkBloodProductDR created via DDL
ForeignKey FKBBAIReqProductLinkBloodProductDR(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BBAIReqProductLinkBloodProductDR ];

/// Foreign Key FKBBAIReqProductLinkReqTypeDR created via DDL
ForeignKey FKBBAIReqProductLinkReqTypeDR(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BBAIReqProductLinkReqTypeDR ];

/// DDL Primary Key Specification
Index PKBBAIREQPRODUCTLINK On RowID [ PrimaryKey, SqlName = PK_BB_AIREQPRODUCTLINK, Type = index, Unique ];

Index IndexMaster On (ReqTypeDR, ReqProductDR, BloodProductDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBReqProductAutoDefaultData">
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
<DataLocation>^dbo.BBReqProductAutoD</DataLocation>
<DefaultData>BBReqProductAutoDefaultData</DefaultData>
<IdLocation>^dbo.BBReqProductAutoD</IdLocation>
<IndexLocation>^dbo.BBReqProductAutoI</IndexLocation>
<StreamLocation>^dbo.BBReqProductAutoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
