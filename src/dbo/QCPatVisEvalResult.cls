/// 失控标本评估
Class dbo.QCPatVisEvalResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_PatVisEvalResult ]
{

/// Foreign Key FKQCPatVisEvalResultMaterialDR created via DDL
ForeignKey FKQCPatVisEvalResultMaterialDR(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_QCPatVisEvalResultMaterialDR ];

/// Foreign Key FKQCPatVisEvalResultTestCodeDR created via DDL
ForeignKey FKQCPatVisEvalResultTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCPatVisEvalResultTestCodeDR ];

/// Foreign Key FKQCPatVisEvalResultAddUserDR created via DDL
ForeignKey FKQCPatVisEvalResultAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCPatVisEvalResultAddUserDR ];

Index IndexMaster On (MaterialDR, TestCodeDR, EvlDate, EvlTime) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKQCPATVISEVALRESULT On RowID [ PrimaryKey, SqlName = PK_QC_PATVISEVALRESULT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 评估日期
Property EvlDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 评估时间
Property EvlTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 样本号
Property VisNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 老结果
Property OldResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 新结果
Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 偏差
Property Deviation As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 评估标准
Property PatVisEval As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 结论
Property EvalConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 添加人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="QCPatVisEvalResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>EvlDate</Value>
</Value>
<Value name="5">
<Value>EvlTime</Value>
</Value>
<Value name="6">
<Value>VisNumber</Value>
</Value>
<Value name="7">
<Value>OldResult</Value>
</Value>
<Value name="8">
<Value>NewResult</Value>
</Value>
<Value name="9">
<Value>Deviation</Value>
</Value>
<Value name="10">
<Value>PatVisEval</Value>
</Value>
<Value name="11">
<Value>EvalConclusion</Value>
</Value>
<Value name="12">
<Value>AddDate</Value>
</Value>
<Value name="13">
<Value>AddTime</Value>
</Value>
<Value name="14">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCPatVisEvalResultD</DataLocation>
<DefaultData>QCPatVisEvalResultDefaultData</DefaultData>
<IdLocation>^dbo.QCPatVisEvalResultD</IdLocation>
<IndexLocation>^dbo.QCPatVisEvalResultI</IndexLocation>
<StreamLocation>^dbo.QCPatVisEvalResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
