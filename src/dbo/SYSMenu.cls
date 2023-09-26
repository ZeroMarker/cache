/// 系统菜单
Class dbo.SYSMenu Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Menu, StorageStrategy = Default ]
{

/// Foreign Key FKSYSMenuSystem created via DDL
ForeignKey FKSYSMenuSystem(SystemDR) References dbo.SYSSystem(PKSYSSYSTEM) [ SqlName = FK_SYSMenu_System ];

/// Foreign Key FKSYSMenuSystemSub created via DDL
ForeignKey FKSYSMenuSystemSub(SystemSubDR) References dbo.SYSSystemSub(PKSYSSYSTEMSUB) [ SqlName = FK_SYSMenu_SystemSub ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexParent On ParentID [ SqlName = Index_Parent, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexSystemSub On SystemSubDR [ SqlName = Index_SystemSub, Type = index ];

Index IndexSystemDR On (SystemDR, ParentID, Sequence) [ SqlName = Index_SystemDR, Type = index ];

Index IndexParentSequence On (ParentID, Sequence) [ SqlName = Index_ParentSequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSMENU On RowID [ PrimaryKey, SqlName = PK_SYS_MENU, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// URL  
Property URL As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 上级  
Property ParentID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 层级  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 功能描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 图标  
Property Icon As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 是否置顶显示  {1:true,0:false}
Property IsTop As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 子系统
Property SystemSubDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 系统模块  
Property SystemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 空:在Tab页打印,0：弹窗打开,1：独立打开  
Property OpenModel As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 打开宽度 
Property OpenWidth As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 打开高度
Property OpenHeight As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="SYSMenuDefaultData">
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
<Value>URL</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>LevelNo</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Icon</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>IsTop</Value>
</Value>
<Value name="12">
<Value>SystemSubDR</Value>
</Value>
<Value name="13">
<Value>SystemDR</Value>
</Value>
<Value name="14">
<Value>OpenModel</Value>
</Value>
<Value name="15">
<Value>OpenWidth</Value>
</Value>
<Value name="16">
<Value>OpenHeight</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSMenuD</DataLocation>
<DefaultData>SYSMenuDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSMenuD</IdLocation>
<IndexLocation>^dbo.SYSMenuI</IndexLocation>
<StreamLocation>^dbo.SYSMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
