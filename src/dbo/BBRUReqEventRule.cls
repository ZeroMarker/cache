///     
Class dbo.BBRUReqEventRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBRU_ReqEventRule, StorageStrategy = Default ]
{

/// Foreign Key FKBBRURERuleEvent created via DDL
ForeignKey FKBBRURERuleEvent(ReqEventDR) References dbo.BBRUReqEvent(PKBBRUREQEVENT) [ SqlName = FK_BBRU_RERule_Event ];

/// Foreign Key FKBBRURERuleRule created via DDL
ForeignKey FKBBRURERuleRule(ReqRuleDR) References dbo.BBRUReqRule(PKBBRUREQRULE) [ SqlName = FK_BBRU_RERule_Rule ];

Index IndexMaster On (ReqEventDR, ReqRuleDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBRUREQEVENTRULE On RowID [ PrimaryKey, SqlName = PK_BBRU_REQEVENTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqEventDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property UseHosptialList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property NotHosptialList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property IsUsed As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBRUReqEventRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqEventDR</Value>
</Value>
<Value name="3">
<Value>ReqRuleDR</Value>
</Value>
<Value name="4">
<Value>UseHosptialList</Value>
</Value>
<Value name="5">
<Value>NotHosptialList</Value>
</Value>
<Value name="6">
<Value>IsUsed</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRUReqEventRuleD</DataLocation>
<DefaultData>BBRUReqEventRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBRUReqEventRuleD</IdLocation>
<IndexLocation>^dbo.BBRUReqEventRuleI</IndexLocation>
<StreamLocation>^dbo.BBRUReqEventRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
