Class dbo.BBRUReqRuleReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBRUReqRule_Reason, StorageStrategy = Default ]
{

/// Foreign Key FKBBRUReqRuleAType created via DDL
ForeignKey FKBBRURRReasonReqRule(ReqRuleDR) References dbo.BBRUReqRule(PKBBRUREQRULE) [ SqlName = FK_BBRURRReason_ReqRule ];

Index IndexReqRule On (ReqRuleDR, SeqNum) [ SqlName = Index_ReqRule, Type = index ];

/// DDL Primary Key Specification
Index PKBBRUREQRULEREASON On RowID [ PrimaryKey, SqlName = PK_BBRUREQRULE_REASON, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property ReqRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property Remark As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBRUReqRuleReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqRuleDR</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRUReqRuleReasonD</DataLocation>
<DefaultData>BBRUReqRuleReasonDefaultData</DefaultData>
<IdLocation>^dbo.BBRUReqRuleReasonD</IdLocation>
<IndexLocation>^dbo.BBRUReqRuleReasonI</IndexLocation>
<StreamLocation>^dbo.BBRUReqRuleReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
