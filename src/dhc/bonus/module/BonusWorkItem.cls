Class dhc.bonus.module.BonusWorkItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusWorkItemID ]
{

/// 工作量类别ID
Property WorkItemTypeID As dhc.bonus.module.WorkItemType [ SqlColumnNumber = 2 ];

/// 收费项目编码
Property WorkItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 收费项目名称
Property WorkItemName As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 项目单价
Property ItemPrice As %Library.Float [ SqlColumnNumber = 5 ];

/// 更新日期
Property UpdateDate As %Library.Date [ SqlColumnNumber = 6 ];

/// 是否有效
Property IsValid As %Library.Integer [ SqlColumnNumber = 7 ];

/// 审核状态
Property AuditingPerson [ SqlColumnNumber = 8 ];

/// 审核时间
Property AuditingDate As %Library.Date [ SqlColumnNumber = 9 ];

/// 数据状态
Property State As %Library.Integer [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BonusWorkItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItemTypeID</Value>
</Value>
<Value name="3">
<Value>WorkItemCode</Value>
</Value>
<Value name="4">
<Value>WorkItemName</Value>
</Value>
<Value name="5">
<Value>ItemPrice</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>AuditingPerson</Value>
</Value>
<Value name="9">
<Value>AuditingDate</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusWorkItemD</DataLocation>
<DefaultData>BonusWorkItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusWorkItemD</IdLocation>
<IndexLocation>^dhcbsBonusWorkItemI</IndexLocation>
<StreamLocation>^dhcbsBonusWorkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
