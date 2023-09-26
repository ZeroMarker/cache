Class CKB.PDSS.RuleComplexArith Extends (%Persistent, User.Abstract) [ SqlRowIdName = RCA_RowId, SqlTableName = RuleComplexArith ]
{

/// 运算符号 (+ - * %)
Property RCASymbol As %String [ SqlColumnNumber = 2, SqlFieldName = RCA_Symbol ];

/// Input/ Variable
Property RCAType As %String [ SqlColumnNumber = 3, SqlFieldName = RCA_Type ];

/// 指向的字典
Property RCADic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = RCA_Dic ];

/// 输入的值
Property RCAValue As %String [ SqlColumnNumber = 5, SqlFieldName = RCA_Value ];

/// 是否有括号
Property RCAQuote As %String [ SqlColumnNumber = 6, SqlFieldName = RCA_Quote ];

/// 关联表达式
Property RCARuleData As CT.CKB.PDSS.RuleData [ SqlColumnNumber = 7, SqlFieldName = RCA_RuleData ];

/// 关联表达式位置
/// 1:左边
/// 2:右边
Property RCASeq As %String [ SqlColumnNumber = 8, SqlFieldName = RCA_Seq ];

Property RCAParref As CKB.PDSS.RuleComplexArith [ SqlColumnNumber = 9, SqlFieldName = RCA_Parref ];

Index RuleDataSeqParref On (RCARuleData As Exact, RCASeq As Exact, RCAParref As Exact);

Storage Default
{
<Data name="RuleComplexArithDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RCASymbol</Value>
</Value>
<Value name="3">
<Value>RCAType</Value>
</Value>
<Value name="4">
<Value>RCAValue</Value>
</Value>
<Value name="5">
<Value>RCADic</Value>
</Value>
<Value name="6">
<Value>RCAQuote</Value>
</Value>
<Value name="7">
<Value>RCARuleData</Value>
</Value>
<Value name="8">
<Value>RCASeq</Value>
</Value>
<Value name="9">
<Value>RCAParref</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleComplexArithD</DataLocation>
<DefaultData>RuleComplexArithDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleComplexArithD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleComplexArithI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleComplexArithS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
