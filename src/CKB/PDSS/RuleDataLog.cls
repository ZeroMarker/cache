Class CKB.PDSS.RuleDataLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = RDL_RowId, SqlTableName = RuleDataLog ]
{

/// 表达式左边字典 
Property RDLLeftDic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = RDL_LeftDic ];

/// 表达式左边值 （输入的字符）
Property RDLLeftValue As %String [ SqlColumnNumber = 3, SqlFieldName = RDL_LeftValue ];

/// 表达式左边类型?????????????（Input Variable Constant）
Property RDLLeftType As %String [ SqlColumnNumber = 4, SqlFieldName = RDL_LeftType ];

/// 比值符号 等于，大于，小于等
Property RDLOp As %String [ SqlColumnNumber = 5, SqlFieldName = RDL_Op ];

/// 表达式右边字典 （疾病，年龄，剂量，症状等）
Property RDLRightDic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 6, SqlFieldName = RDL_RightDic ];

/// 表达式右边值 ???下限（输入的字符）
Property RDLRightValue As %String(MAXLEN = 32767) [ SqlColumnNumber = 7, SqlFieldName = RDL_RightValue ];

/// 表达式右边类型???????????????（Input Variable Constant）
Property RDLRightType As %String [ SqlColumnNumber = 8, SqlFieldName = RDL_RightType ];

/// 表达式右边（单位）
Property RDLRightExt As %String [ SqlColumnNumber = 13, SqlFieldName = RDL_RightExt ];

/// 表达式右边（上线）
Property RDLRightLimit As %String [ SqlColumnNumber = 14, SqlFieldName = RDL_RightLimit ];

/// RD_LinkRelation 关系（And,or） 在 RDAction是(else和then) 输出类型 / console-print(控制台打印) / var-assign (变量赋值)
Property RDLCondition As %String [ SqlColumnNumber = 9, SqlFieldName = RDL_Condition ];

/// 组号
Property RDLRule As CT.CKB.PDSS.Rule [ SqlColumnNumber = 10, SqlFieldName = RDL_Rule ];

/// 父层级
Property RDLPrentLev As %String [ SqlColumnNumber = 11, SqlFieldName = RDL_ParentLev ];

/// 层级
Property RDLLevel As %String [ SqlColumnNumber = 12, SqlFieldName = RDL_Level ];

/// 类型 if / then /else
Property RDLAction As %String [ SqlColumnNumber = 15, SqlFieldName = RDL_Action ];

/// 日志父表
Property RDLLog As CKB.PDSS.RuleLog [ SqlColumnNumber = 16, SqlFieldName = RDL_Log ];

/// 操作类型
/// 新增(Add) / 修改(Edit) / 删除(Remove)  / 未操作(Unchanged)
Property RDLType As %String [ SqlColumnNumber = 17, SqlFieldName = RDL_Type ];

/// 对应上次的日志id CKB.PDSS.RuleDataLog
Property RDLLastDataLog As %String [ SqlColumnNumber = 18, SqlFieldName = RDL_LastDataLog ];

/// 规则明细id
Property RDLRuleData As CT.CKB.PDSS.RuleData [ SqlColumnNumber = 19, SqlFieldName = RDL_RuleData ];

Index Parent On RDLLog As Exact;

Index RuleData On RDLRuleData As Exact;

Storage Default
{
<Data name="RuleDataLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDLRule</Value>
</Value>
<Value name="3">
<Value>RDLCondition</Value>
</Value>
<Value name="4">
<Value>RDLLeftDic</Value>
</Value>
<Value name="5">
<Value>RDLLeftValue</Value>
</Value>
<Value name="6">
<Value>RDLLeftType</Value>
</Value>
<Value name="7">
<Value>RDLOp</Value>
</Value>
<Value name="8">
<Value>RDLRightDic</Value>
</Value>
<Value name="9">
<Value>RDLRightValue</Value>
</Value>
<Value name="10">
<Value>RDLRightType</Value>
</Value>
<Value name="11">
<Value>RDLPrentLev</Value>
</Value>
<Value name="12">
<Value>RDLLevel</Value>
</Value>
<Value name="13">
<Value>RDLRightExt</Value>
</Value>
<Value name="14">
<Value>RDLRightLimit</Value>
</Value>
<Value name="15">
<Value>RDLAction</Value>
</Value>
<Value name="16">
<Value>RDLLog</Value>
</Value>
<Value name="17">
<Value>RDLType</Value>
</Value>
<Value name="18">
<Value>RDLLastDataLog</Value>
</Value>
<Value name="19">
<Value>RDLRuleData</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleDataLogD</DataLocation>
<DefaultData>RuleDataLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleDataLogD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleDataLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleDataLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
