///     
Class dbo.BDReqFormProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormProduct, StorageStrategy = Default ]
{

Index IndexMaster On (ReqFormDR, ReqProductDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPurpose On (ReqFormDR, PurposeDR) [ SqlName = Index_Purpose, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQFORMPRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMPRODUCT, Type = index, Unique ];

/// Foreign Key FKBDRFPProduct created via DDL
ForeignKey FKBDRFPProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BD_RFP_Product ];

/// Foreign Key FKBDRFPPurpose created via DDL
ForeignKey FKBDRFPPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_BD_RFP_Purpose ];

/// Foreign Key FKBDRFPReqForm created via DDL
ForeignKey FKBDRFPReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFP_ReqForm ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDRFPBloodGroup(ReqBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_RFP_BloodGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Volumn As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

Property SpecialNeed As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property ReqBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Height As %Library.Float [ SqlColumnNumber = 11 ];

Property Weight As %Library.Float [ SqlColumnNumber = 12 ];

Property TestItemRes As %Library.Float [ SqlColumnNumber = 13 ];

Property RuleResMax As %Library.Float [ SqlColumnNumber = 14 ];

Property RuleResMin As %Library.Float [ SqlColumnNumber = 15 ];

Property RuleRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BDReqFormProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>ReqProductDR</Value>
</Value>
<Value name="4">
<Value>PurposeDR</Value>
</Value>
<Value name="5">
<Value>Volumn</Value>
</Value>
<Value name="6">
<Value>Unit</Value>
</Value>
<Value name="7">
<Value>SpecialNeed</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>ReqBloodGroupDR</Value>
</Value>
<Value name="10">
<Value>Height</Value>
</Value>
<Value name="11">
<Value>Weight</Value>
</Value>
<Value name="12">
<Value>TestItemRes</Value>
</Value>
<Value name="13">
<Value>RuleResMax</Value>
</Value>
<Value name="14">
<Value>RuleResMin</Value>
</Value>
<Value name="15">
<Value>RuleRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormProductD</DataLocation>
<DefaultData>BDReqFormProductDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormProductD</IdLocation>
<IndexLocation>^dbo.BDReqFormProductI</IndexLocation>
<StreamLocation>^dbo.BDReqFormProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
