/// 数学运算
/// zhouxin
/// 2019-06-19
Class web.DHCCKBRuleComplexArith Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_CKBRuleComplexArith, StorageStrategy = NewStorage1 ]
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
Property RCASeq As CT.CKB.PDSS.RuleData [ SqlColumnNumber = 8, SqlFieldName = RCA_Seq ];

Storage NewStorage1
{
<SqlIdExpression>$i(^mdata("DHCCKBRULECOMPLEXARITH"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RCA_Dic">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RCA_Quote">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RCA_RuleData">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RCA_Seq">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RCA_Symbol">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RCA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RCA_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCKBRULECOMPLEXARITH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RCA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRuleDataSeq">
<Global>^DHCCKBRULECOMPLEXARITH</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RuleDataSeq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RCA_RuleData}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RCA_Seq}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RCA_RowId</SqlRowIdName>
<StreamLocation>^web.DHCCKBRuleComplexArithS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
