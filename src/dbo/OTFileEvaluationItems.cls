Class dbo.OTFileEvaluationItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileEvaluationItems ]
{

/// Foreign Key FKEvaluation created via DDL
ForeignKey FKFileEvaluation(OTFileEvaluationDR) References dbo.OTFileEvaluation(PKOTFILEEVALUATION) [ SqlName = FK_FileEvaluation ];

/// Foreign Key FKEvaluationUser created via DDL
ForeignKey FKEvaluationUser(EvaluationUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EvaluationUser ];

Index IndexEvaluationUser On (OTFileEvaluationDR, EvaluationUser, EvaluationDate, EvaluationTime) [ SqlName = Index_EvaluationUser, Type = index, Unique ];

Index IndexEvaluation On (OTFileEvaluationDR, EvaluationUser) [ SqlName = Index_Evaluation, Type = index ];

/// DDL Primary Key Specification
Index PKOTFILEEVALUATIONITEMS On RowID [ PrimaryKey, SqlName = PK_OT_FILEEVALUATIONITEMS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 评审
Property OTFileEvaluationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 评审人	
Property EvaluationUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 评审日期
Property EvaluationDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 评审时间
Property EvaluationTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 评审结果
Property Result As %Library.SmallInt [ SqlColumnNumber = 7 ];

/// 评审意见
Property Suggestion As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 提交
Property Submit As %Library.SmallInt [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="OTFileEvaluationItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileEvaluationDR</Value>
</Value>
<Value name="3">
<Value>EvaluationUser</Value>
</Value>
<Value name="4">
<Value>EvaluationDate</Value>
</Value>
<Value name="5">
<Value>EvaluationTime</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>Suggestion</Value>
</Value>
<Value name="8">
<Value>Submit</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileEvaluationItemsD</DataLocation>
<DefaultData>OTFileEvaluationItemsDefaultData</DefaultData>
<IdLocation>^dbo.OTFileEvaluationItemsD</IdLocation>
<IndexLocation>^dbo.OTFileEvaluationItemsI</IndexLocation>
<StreamLocation>^dbo.OTFileEvaluationItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
