/// 文件分类
Class dbo.OTFileType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileType ]
{

/// DDL Primary Key RUGenusDR
Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKOTFILETYPE On RowID [ PrimaryKey, SqlName = PK_OT_FILETYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 是否有附件  {1:true,0:false}
Property HasFile As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 是否需要审批  {1:true,0:false}
Property IsNeedApprove As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 是否可下载或另存  {1:true,0:false}
Property IsDownLoad As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 是否可打印  {1:true,0:false}
Property IsPrint As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="OTFileTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>HasFile</Value>
</Value>
<Value name="7">
<Value>IsNeedApprove</Value>
</Value>
<Value name="8">
<Value>IsDownLoad</Value>
</Value>
<Value name="9">
<Value>IsPrint</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileTypeD</DataLocation>
<DefaultData>OTFileTypeDefaultData</DefaultData>
<IdLocation>^dbo.OTFileTypeD</IdLocation>
<IndexLocation>^dbo.OTFileTypeI</IndexLocation>
<StreamLocation>^dbo.OTFileTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
