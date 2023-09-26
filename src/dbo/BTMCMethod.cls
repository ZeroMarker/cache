/// 鉴定方法
Class dbo.BTMCMethod Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_Method, StorageStrategy = Default ]
{

/// Foreign Key FKMCMethodProcess created via DDL
ForeignKey FKMCMethodProcess(ProcessDR) References dbo.BTMCProcess(PKBTMCPROCESS) [ SqlName = FK_MC_Method_Process ];

/// Foreign Key FKMCMethodProcess created via DDL
ForeignKey FKMCMethodParent(ParentID) References dbo.BTMCMethod(PKBTMCMETHOD) [ SqlName = FK_MC_Method_Parent ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexProcessDR On (ProcessDR, ParentID, Sequence) [ SqlName = Index_ProcessDR, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCMETHOD On RowID [ PrimaryKey, SqlName = PK_BTMC_METHOD, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 4 ];

/// 描述  
Property ProcessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活状态  {1:true,0:false}
Property Active As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 7 ];

/// 方法类型  
Property MethodType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 方法名称  
Property ParentID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 输出时间  
Property TimePoint As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 项目代码  
Property TestCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 浏览状态  {1:true,0:false}
Property DocView As %Library.Boolean [ InitialExpression = 0, SqlColumnNumber = 12 ];

/// 是否打印  {1:true,0:false}
Property NoPrint As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 13 ];

/// 准入入口  {1:true,0:false}
Property EntryDirect As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 14 ];

/// 打印序号  
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTMCMethodDefaultData">
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
<Value>ProcessDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>MethodType</Value>
</Value>
<Value name="8">
<Value>ParentID</Value>
</Value>
<Value name="9">
<Value>TimePoint</Value>
</Value>
<Value name="10">
<Value>TestCode</Value>
</Value>
<Value name="11">
<Value>DocView</Value>
</Value>
<Value name="12">
<Value>NoPrint</Value>
</Value>
<Value name="13">
<Value>EntryDirect</Value>
</Value>
<Value name="14">
<Value>PrintNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCMethodD</DataLocation>
<DefaultData>BTMCMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCMethodD</IdLocation>
<IndexLocation>^dbo.BTMCMethodI</IndexLocation>
<StreamLocation>^dbo.BTMCMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
