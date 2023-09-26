///     
Class dbo.BDReqFormRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormRule, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFRuleReqForm created via DDL
ForeignKey FKBDRFRuleReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFRule_ReqForm ];

/// Foreign Key FKBDRFRulerule created via DDL
ForeignKey FKBDRFRulerule(ReqRuleDR) References dbo.BBRUReqRule(PKBBRUREQRULE) [ SqlName = FK_BD_RFRule_rule ];

Index IndexMaster On (ReqFormDR, ReqRuleDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQFORMRULE On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDReqFormRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>ReqRuleDR</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormRuleD</DataLocation>
<DefaultData>BDReqFormRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormRuleD</IdLocation>
<IndexLocation>^dbo.BDReqFormRuleI</IndexLocation>
<StreamLocation>^dbo.BDReqFormRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
