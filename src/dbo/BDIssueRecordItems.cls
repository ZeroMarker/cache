/// BDIssueRecordItems
Class dbo.BDIssueRecordItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_IssueRecordItems, StorageStrategy = Default ]
{

/// Foreign Key FKBDIRItemsIssueRecord created via DDL
ForeignKey FKBDIRItemsIssueRecord(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_BD_IRItems_IssueRecord ];

/// Foreign Key FKBDIRItemsPack created via DDL
ForeignKey FKBDIRItemsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_IRItems_Pack ];

/// Foreign Key FKBDIssueRecordXMPlan created via DDL
ForeignKey FKBDIssueRecordXMPlan(XMPlanDR) References dbo.BDXMPlan(PKBDXMPLAN) [ SqlName = FK_BD_IRItems_XMPlan ];

Index IndexMaster On (IssueRecordDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDISSUERECORDITEMS On RowID [ PrimaryKey, SqlName = PK_BD_ISSUERECORDITEMS, Type = index, Unique ];

Index IndexXMPlan On XMPlanDR [ SqlName = Index_XMPlan, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 发血记录单  
Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否退血  {1:true,0:false}
Property IsReturned As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 配血计划  
Property XMPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDIssueRecordItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IssueRecordDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>IsReturned</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>XMPlanDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDIssueRecordItemsD</DataLocation>
<DefaultData>BDIssueRecordItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDIssueRecordItemsD</IdLocation>
<IndexLocation>^dbo.BDIssueRecordItemsI</IndexLocation>
<StreamLocation>^dbo.BDIssueRecordItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
