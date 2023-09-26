/// 系统子模块
Class dbo.SYSSystemSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_SystemSub, StorageStrategy = Default ]
{

/// Foreign Key FKSystemSub created via DDL
ForeignKey FKSystemSub(SystemDR) References dbo.SYSSystem(PKSYSSYSTEM) [ SqlName = FK_SystemSub ];

/// DDL Primary Key Specification
Index IndexSystemDR On SystemDR [ SqlName = Index_SystemDR, Type = index ];

/// DDL Primary Key Specification
Index IndexCode On SubSysCode [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSSYSTEMSUB On RowID [ PrimaryKey, SqlName = PK_SYS_SYSTEMSUB, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 子系统代码  
Property SubSysCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 子系统名称  
Property SubSysName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 系统主模块  
Property SystemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 更新版本  
Property BulidNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 主版本号
Property MajorNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 修正版本号
Property ReviseNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

/// 更新日期
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 更新时间
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

/// 更新地址
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="SYSSystemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubSysCode</Value>
</Value>
<Value name="3">
<Value>SubSysName</Value>
</Value>
<Value name="4">
<Value>SystemDR</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>BulidNo</Value>
</Value>
<Value name="8">
<Value>MajorNo</Value>
</Value>
<Value name="9">
<Value>ReviseNo</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
<Value name="12">
<Value>IPAddress</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSSystemSubD</DataLocation>
<DefaultData>SYSSystemSubDefaultData</DefaultData>
<IdLocation>^dbo.SYSSystemSubD</IdLocation>
<IndexLocation>^dbo.SYSSystemSubI</IndexLocation>
<StreamLocation>^dbo.SYSSystemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
