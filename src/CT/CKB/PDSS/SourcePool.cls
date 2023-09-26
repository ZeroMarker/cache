Class CT.CKB.PDSS.SourcePool Extends %Persistent [ SqlRowIdName = SP_RowID, SqlTableName = SourcePool ]
{

/// D ##class(CT.CKB.PDSS.SourcePool).%BuildIndices()
/// 前提条件(如给药途径,若没有优先级，需要一个固定的标记)
Property SPPreDr As %String [ SqlColumnNumber = 2, SqlFieldName = SP_PreDr ];

/// 目录
Property SPLibDr As %String [ SqlColumnNumber = 3, SqlFieldName = SP_LibDr ];

/// 顺序号
Property SPNum As %String [ SqlColumnNumber = 4, SqlFieldName = SP_Num ];

/// 知识来源id
Property SPSourceDr As %String [ SqlColumnNumber = 5, SqlFieldName = SP_SourceDr ];

/// 逻辑关系(and/or,默认值是or)
Property SPRelation As %String(VALUELIST = "and,or") [ SqlColumnNumber = 6, SqlFieldName = SP_Relation ];

/// 是否启用(Y/N)
Property SPActive As %String(VALUELIST = "Y,N") [ SqlColumnNumber = 7, SqlFieldName = SP_Active ];

/// 规则序号
Property SPRuleDr As %String [ SqlColumnNumber = 8, SqlFieldName = SP_RuleDr ];

/// 规则最高优先级标记(Y/N)
Property SPRuleAuth As %String(VALUELIST = "Y,N") [ SqlColumnNumber = 9, SqlFieldName = SP_RuleAuth ];

Storage Default
{
<Data name="SourcePoolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SPPreDr</Value>
</Value>
<Value name="3">
<Value>SPLibDr</Value>
</Value>
<Value name="4">
<Value>SPNum</Value>
</Value>
<Value name="5">
<Value>SPSourceDr</Value>
</Value>
<Value name="6">
<Value>SPRelation</Value>
</Value>
<Value name="7">
<Value>SPActive</Value>
</Value>
<Value name="8">
<Value>SPRuleDr</Value>
</Value>
<Value name="9">
<Value>SPRuleAuth</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.SourcePoolD</DataLocation>
<DefaultData>SourcePoolDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.SourcePoolD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.SourcePoolI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.SourcePoolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
