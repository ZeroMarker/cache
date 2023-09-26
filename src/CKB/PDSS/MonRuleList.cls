Class CKB.PDSS.MonRuleList Extends (%Persistent, User.Abstract) [ SqlRowIdName = CM_RowID, SqlTableName = MonRuleList ]
{

/// D ##class(CKB.PDSS.MonRuleList).%BuildIndices()
/// 监测主表ID  CM_Parrf_Dr
Property CMParrfDr As CKB.PDSS.MonMaster [ SqlColumnNumber = 2, SqlFieldName = CM_Parrf_Dr ];

/// 规则ID  CM_Rule_Dr
Property CMRuleDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = CM_Rule_Dr ];

/// 管理级别  CM_ManLev_Dr
Property CMManLevDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = CM_ManLev_Dr ];

/// 行标识  CM_Item_Dr
Property CMItemDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CM_Item_Dr ];

Index Parref On CMParrfDr As Exact;

Storage Default
{
<Data name="MonRuleListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMParrfDr</Value>
</Value>
<Value name="3">
<Value>CMRuleDr</Value>
</Value>
<Value name="4">
<Value>CMManLevDr</Value>
</Value>
<Value name="5">
<Value>CMItemDr</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.MonRuleListD</DataLocation>
<DefaultData>MonRuleListDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.MonRuleListD</IdLocation>
<IndexLocation>^CKB.PDSS.MonRuleListI</IndexLocation>
<StreamLocation>^CKB.PDSS.MonRuleListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
