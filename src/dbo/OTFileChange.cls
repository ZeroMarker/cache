Class dbo.OTFileChange Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileChange ]
{

Index IndexFileCode On FileCode [ SqlName = Index_FileCode, Type = index ];

Index IndexFileInfoDR On FileCode [ SqlName = Index_FileInfoDR, Type = index ];

Index IndexWorkGroupDR On (WorkGroupDR, CreateDate, CreateTime) [ SqlName = Index_WorkGroupDR, Type = index ];

Index IndexCreateUser On (CreateUser, CreateDate, CreateTime) [ SqlName = Index_CreateUser, Type = index ];

/// DDL Primary Key Specification
Index PKOTFileChange On RowID [ PrimaryKey, SqlName = PK_OT_FileChange, Type = index, Unique ];

/// Foreign Key FKFileChangeCreateUser created via DDL
ForeignKey FKFileChangeCreateUser(CreateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileChangeCreateUser ];

/// Foreign Key FKFileChangeUpdateUser created via DDL
ForeignKey FKFileChangeAuthUser(AuthUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileChangeAuthUser ];

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileChangeInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileChangeInfoDR ];

/// Foreign Key FKEvaluation created via DDL
ForeignKey FKFileChangeEvaluation(OTFileEvaluationDR) References dbo.OTFileEvaluation(PKOTFILEEVALUATION) [ SqlName = FK_FileChangeEvaluation ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 变更类型
Property ChangeType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 修改文件
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 评审任务
Property OTFileEvaluationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 关键字
Property KeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 6 ];

/// 文件编号
Property FileCode As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 7 ];

/// 文件主题
Property FileSubject As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

/// 创建日期
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 创建时间
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 创建人
Property CreateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 审核人
Property AuthUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 状态（枚举类LQM.ENUM.OTFileChangeStatus）
Property Status As %Library.SmallInt [ SqlColumnNumber = 16 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="OTFileChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChangeType</Value>
</Value>
<Value name="3">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="4">
<Value>OTFileEvaluationDR</Value>
</Value>
<Value name="5">
<Value>KeyWord</Value>
</Value>
<Value name="6">
<Value>FileCode</Value>
</Value>
<Value name="7">
<Value>FileSubject</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>CreateUser</Value>
</Value>
<Value name="11">
<Value>AuthDate</Value>
</Value>
<Value name="12">
<Value>AuthTime</Value>
</Value>
<Value name="13">
<Value>AuthUser</Value>
</Value>
<Value name="14">
<Value>WorkGroupDR</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileChangeD</DataLocation>
<DefaultData>OTFileChangeDefaultData</DefaultData>
<IdLocation>^dbo.OTFileChangeD</IdLocation>
<IndexLocation>^dbo.OTFileChangeI</IndexLocation>
<StreamLocation>^dbo.OTFileChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
