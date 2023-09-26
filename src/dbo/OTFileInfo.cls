/// 文件表
Class dbo.OTFileInfo Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileInfo ]
{

Index IndexParentID On ParentID [ SqlName = Index_ParentID, Type = index ];

Index IndexFileCode On FileCode [ SqlName = Index_FileCode, Type = index ];

Index IndexFileLicense On (FileLicense, CreateDate, CreateTime) [ SqlName = Index_FileLicense, Type = index, Unique ];

Index IndexWorkGroupDR On (WorkGroupDR, CreateDate, CreateTime) [ SqlName = Index_WorkGroupDR, Type = index ];

Index IndexCreateUser On (CreateUser, CreateDate, CreateTime) [ SqlName = Index_CreateUser, Type = index ];

/// DDL Primary Key Specification
Index PKOTFileInfo On RowID [ PrimaryKey, SqlName = PK_OT_FileInfo, Type = index, Unique ];

/// Foreign Key FKFileInfoCreateUser created via DDL
ForeignKey FKFileInfoCreateUser(CreateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileInfoCreateUser ];

/// Foreign Key FKFileInfUpdateUser created via DDL
ForeignKey FKFileInfoUpdateUser(UpdateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileInfoUpdateUser ];

/// Foreign Key FKFileInfoOwner created via DDL
ForeignKey FKFileInfoOwner(Owner) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_FileInfoOwner ];

/// Foreign Key FKFileInfUpdateUser created via DDL
ForeignKey FKFileInfoFileTypeDR(OTFileTypeDR) References dbo.OTFileType(PKOTFILETYPE) [ SqlName = FK_FileInfoFileTypeDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 父节点  
Property ParentID As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 4 ];

/// 路径  
Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

/// 创建日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 创建时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 创建人  
Property CreateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 更新人  
Property UpdateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 拥有者  
Property Owner As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 关键字  
Property KeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 13 ];

/// 文件编号  
Property FileCode As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 文件主题  
Property FileSubject As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 15 ];

/// 批准日期  
Property ApprovalDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 文件类别  
Property OTFileTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 允许文件后缀  
Property AllowSuffix As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 18 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 备份索引  
Property BakIndex As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 审核人  
Property AuthUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 文件序列号  
Property FileLicense As %Library.String(MAXLEN = 30) [ SqlColumnNumber = 24 ];

/// 版本号  
Property Version As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 25 ];

/// 参与评审  
Property IsEvaluation As %Library.Boolean [ SqlColumnNumber = 26 ];

/// 状态（枚举类LQM.ENUM.OTFileStatus）  
Property Status As %Library.SmallInt [ SqlColumnNumber = 27 ];

/// 批准意见  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 28 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 批准人  
Property ApprovalUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 批准人  
Property ApprovalTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 文件状态（枚举类LQM.ENUM.OTFileFileStatus）  
Property FileStatus As %Library.SmallInt [ SqlColumnNumber = 33 ];

/// 允许借阅  
Property AllowBorrow As %Library.Boolean [ SqlColumnNumber = 34 ];

/// 审查日期  
Property ExamineDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 审查时间  
Property ExamineTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 审查人  
Property ExamineUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 发布日期  
Property ReleaseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 发布时间  
Property ReleaseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

/// 发布人  
Property ReleaseUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// 实际路径
Property ActualPath As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 41 ];

Storage Default
{
<Data name="OTFileInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentID</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FilePath</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>Owner</Value>
</Value>
<Value name="12">
<Value>KeyWord</Value>
</Value>
<Value name="13">
<Value>FileCode</Value>
</Value>
<Value name="14">
<Value>FileSubject</Value>
</Value>
<Value name="15">
<Value>ApprovalDate</Value>
</Value>
<Value name="16">
<Value>OTFileTypeDR</Value>
</Value>
<Value name="17">
<Value>AllowSuffix</Value>
</Value>
<Value name="18">
<Value>Active</Value>
</Value>
<Value name="19">
<Value>BakIndex</Value>
</Value>
<Value name="20">
<Value>AuthDate</Value>
</Value>
<Value name="21">
<Value>AuthTime</Value>
</Value>
<Value name="22">
<Value>AuthUser</Value>
</Value>
<Value name="23">
<Value>FileLicense</Value>
</Value>
<Value name="24">
<Value>Version</Value>
</Value>
<Value name="25">
<Value>IsEvaluation</Value>
</Value>
<Value name="26">
<Value>Status</Value>
</Value>
<Value name="27">
<Value>Remark</Value>
</Value>
<Value name="28">
<Value>WorkGroupDR</Value>
</Value>
<Value name="29">
<Value>Sequence</Value>
</Value>
<Value name="30">
<Value>ApprovalUser</Value>
</Value>
<Value name="31">
<Value>ApprovalTime</Value>
</Value>
<Value name="32">
<Value>FileStatus</Value>
</Value>
<Value name="33">
<Value>AllowBorrow</Value>
</Value>
<Value name="34">
<Value>ExamineDate</Value>
</Value>
<Value name="35">
<Value>ExamineTime</Value>
</Value>
<Value name="36">
<Value>ExamineUser</Value>
</Value>
<Value name="37">
<Value>ReleaseDate</Value>
</Value>
<Value name="38">
<Value>ReleaseTime</Value>
</Value>
<Value name="39">
<Value>ReleaseUser</Value>
</Value>
<Value name="40">
<Value>ActualPath</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileInfoD</DataLocation>
<DefaultData>OTFileInfoDefaultData</DefaultData>
<IdLocation>^dbo.OTFileInfoD</IdLocation>
<IndexLocation>^dbo.OTFileInfoI</IndexLocation>
<StreamLocation>^dbo.OTFileInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
