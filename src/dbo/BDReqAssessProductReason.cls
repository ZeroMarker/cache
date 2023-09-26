Class dbo.BDReqAssessProductReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssessProductReason ]
{

Index IndexMaster On (ReqAssessProductDR, ReasonDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (ReqAssessProductDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQASSESSPRODUCTREASON On RowID [ PrimaryKey, SqlName = PK_BD_REQASSESSPRODUCT_REASON, Type = index, Unique ];

/// Foreign Key FKBDRFPProduct created via DDL
ForeignKey FKBDRAPRReqAssessProduct(ReqAssessProductDR) References dbo.BDReqAssessProduct(PKBDREQAEESEEPRODUCT) [ SqlName = FK_BD_RAPR_ReqAssessProduct ];

/// Foreign Key FKBDRFPPurpose created via DDL
ForeignKey FKBDRAPRReason(ReasonDR) References dbo.BBReason(PKBBREASON) [ SqlName = FK_BD_RAPR_Reason ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 输血评估单成分  
Property ReqAssessProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 合理用血理由  
Property ReasonDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDReqAssessProductReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqAssessProductDR</Value>
</Value>
<Value name="3">
<Value>ReasonDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqAssessProductReasonD</DataLocation>
<DefaultData>BDReqAssessProductReasonDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessProductReasonD</IdLocation>
<IndexLocation>^dbo.BDReqAssessProductReasonI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessProductReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
