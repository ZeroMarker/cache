///     
Class dbo.BBRUReqRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBRU_ReqRule, StorageStrategy = Default ]
{

/// Foreign Key FKBBRUReqRuleAType created via DDL
ForeignKey FKBBRUReqRuleAType(ApprovalTypeDR) References dbo.BBApprovalType(PKBBAPPROVALTYPE) [ SqlName = FK_BBRU_ReqRule_AType ];

/// Foreign Key FKBBRUReqRuleAType created via DDL
ForeignKey FKBBRUReqRuleLocationClass(LocationClassDR) References dbo.BBRULocationClass(PKBBRULOCATIONCLASS) [ SqlName = FK_BBRU_ReqRule_LocationClass ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBRUREQRULE On RowID [ PrimaryKey, SqlName = PK_BBRU_REQRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property RuleDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

Property RuleFormula As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 6 ];

Property IsRemarked As %Library.Boolean [ SqlColumnNumber = 7 ];

Property RemarkList As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

Property IsCreateApproval As %Library.Boolean [ SqlColumnNumber = 9 ];

Property ApprovalTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property ApproveModle As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 13 ];

/// RC红细胞,PLT血小板…
Property BloodComp As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 14 ];

/// 适用临床科室类别
Property LocationClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BBRUReqRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>RuleDesc</Value>
</Value>
<Value name="5">
<Value>RuleFormula</Value>
</Value>
<Value name="6">
<Value>IsRemarked</Value>
</Value>
<Value name="7">
<Value>RemarkList</Value>
</Value>
<Value name="8">
<Value>IsCreateApproval</Value>
</Value>
<Value name="9">
<Value>ApprovalTypeDR</Value>
</Value>
<Value name="10">
<Value>ApproveModle</Value>
</Value>
<Value name="11">
<Value>SeqNum</Value>
</Value>
<Value name="12">
<Value>Active</Value>
</Value>
<Value name="13">
<Value>BloodComp</Value>
</Value>
<Value name="14">
<Value>LocationClassDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRUReqRuleD</DataLocation>
<DefaultData>BBRUReqRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBRUReqRuleD</IdLocation>
<IndexLocation>^dbo.BBRUReqRuleI</IndexLocation>
<StreamLocation>^dbo.BBRUReqRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
