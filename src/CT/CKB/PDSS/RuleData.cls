Class CT.CKB.PDSS.RuleData Extends %Persistent [ SqlRowIdName = RD_RowID, SqlTableName = RuleData ]
{

/// D ##class(CT.CKB.PDSS.RuleData).%BuildIndices()
/// 表达式左边字典 （疾病，年龄，剂量，症状等）
Property RDLeftDic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = RD_LeftDic ];

/// 表达式左边值 （输入的字符）
Property RDLeftValue As %String [ SqlColumnNumber = 3, SqlFieldName = RD_LeftValue ];

/// 表达式左边类型?????????????（Input Variable Constant）
Property RDLeftType As %String [ SqlColumnNumber = 4, SqlFieldName = RD_LeftType ];

/// 比值符号 等于，大于，小于等
Property RDOp As %String [ SqlColumnNumber = 5, SqlFieldName = RD_Op ];

/// 表达式右边字典 （疾病，年龄，剂量，症状等）
Property RDRightDic As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 6, SqlFieldName = RD_RightDic ];

/// 表达式右边值 ???下限（输入的字符）
Property RDRightValue As %String(MAXLEN = 32767) [ SqlColumnNumber = 7, SqlFieldName = RD_RightValue ];

/// 表达式右边类型???????????????（Input Variable Constant）
Property RDRightType As %String [ SqlColumnNumber = 8, SqlFieldName = RD_RightType ];

/// 表达式右边（单位）
Property RDRightExt As %String [ SqlColumnNumber = 9, SqlFieldName = RD_RightExt ];

/// 表达式右边（上线）
Property RDRightLimit As %String [ SqlColumnNumber = 10, SqlFieldName = RD_RightLimit ];

/// 组号
Property RDRule As CT.CKB.PDSS.Rule [ SqlColumnNumber = 11, SqlFieldName = RD_Rule ];

/// 节点id
Property RDNode As CT.CKB.PDSS.RuleNode [ SqlColumnNumber = 12, SqlFieldName = RD_Node ];

/// 分支的管理级别 2022-04-21 qnp
Property RDManLevel As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 13, SqlFieldName = RD_ManLevel ];

Index IndexLeftDic On RDLeftDic As Exact;

Index Node On RDNode As Exact;

Index RightDic On (RDRightType As Exact, RDRightDic As Exact, RDRule As Exact);

Index RightExt On (RDRightType As Exact, RDRightExt As Exact, RDRule As Exact);

Index Rule On RDRule As Exact;

Storage Default
{
<Data name="RuleDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDRule</Value>
</Value>
<Value name="3">
<Value>RDNode</Value>
</Value>
<Value name="4">
<Value>RDLeftDic</Value>
</Value>
<Value name="5">
<Value>RDLeftValue</Value>
</Value>
<Value name="6">
<Value>RDLeftType</Value>
</Value>
<Value name="7">
<Value>RDOp</Value>
</Value>
<Value name="8">
<Value>RDRightDic</Value>
</Value>
<Value name="9">
<Value>RDRightValue</Value>
</Value>
<Value name="10">
<Value>RDRightType</Value>
</Value>
<Value name="11">
<Value>RDRightExt</Value>
</Value>
<Value name="12">
<Value>RDRightLimit</Value>
</Value>
<Value name="13">
<Value>RDManLevel</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.RuleDataD</DataLocation>
<DefaultData>RuleDataDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.RuleDataD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.RuleDataI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.RuleDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
