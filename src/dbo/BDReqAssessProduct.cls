/// BDReqAssessProduct
Class dbo.BDReqAssessProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssessProduct ]
{

Index IndexMaster On (ReqAssessDR, ReqProductDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQAEESEEPRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_REQAEESEEPRODUCT, Type = index, Unique ];

/// Foreign Key FKBDRFPProduct created via DDL
ForeignKey FKBDRAPRODUCT(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BD_RAP_Product ];

/// Foreign Key FKBDRFPPurpose created via DDL
ForeignKey FKBDRAPPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_BD_RAP_Purpose ];

/// Foreign Key FKBDRFPReqForm created via DDL
ForeignKey FKBDRAPReqAssess(ReqAssessDR) References dbo.BDReqAssess(PKBDREQASSESS) [ SqlName = FK_BD_RAP_ReqAssess ];

ForeignKey FKBDRAPBloodGroup(ReqBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_RAP_BloodGroup ];

/// Foreign Key FKBDRFPReqForm created via DDL
ForeignKey FKBDRAPReqRule(ReqRuleDR) References dbo.BBRUReqRule(PKBBRUREQRULE) [ SqlName = FK_BD_RAP_ReqRule ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 评估单  
Property ReqAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 申请血产品  
Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 申请目的  
Property PurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 血量  
Property Volumn As %Library.Float [ Required, SqlColumnNumber = 6 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

/// 申请血型  
Property ReqBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 特殊要求  
Property SpecialNeed As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 输血申请规则  
Property ReqRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BDReqAssessProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqAssessDR</Value>
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
<Value>ReqBloodGroupDR</Value>
</Value>
<Value name="8">
<Value>SpecialNeed</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>ReqRuleDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqAssessProductD</DataLocation>
<DefaultData>BDReqAssessProductDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessProductD</IdLocation>
<IndexLocation>^dbo.BDReqAssessProductI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
