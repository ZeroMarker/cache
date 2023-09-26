/// 系统模块
Class dbo.SYSSystem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_System, StorageStrategy = Default ]
{

Index IndexCode On SysCode [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSSYSTEM On RowID [ PrimaryKey, SqlName = PK_SYS_SYSTEM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 系统代码  
Property SysCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 系统名称  
Property SysName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 主板本  
Property MajorNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 子版本  
Property ReviseNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 授权串  
Property LicenseNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 系统主模块  
Property SystemSubDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="SYSSystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SysCode</Value>
</Value>
<Value name="3">
<Value>SysName</Value>
</Value>
<Value name="4">
<Value>MajorNo</Value>
</Value>
<Value name="5">
<Value>ReviseNo</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>LicenseNo</Value>
</Value>
<Value name="9">
<Value>SystemSubDR</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSSystemD</DataLocation>
<DefaultData>SYSSystemDefaultData</DefaultData>
<IdLocation>^dbo.SYSSystemD</IdLocation>
<IndexLocation>^dbo.SYSSystemI</IndexLocation>
<StreamLocation>^dbo.SYSSystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
