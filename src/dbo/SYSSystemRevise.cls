/// 系统修正信息
Class dbo.SYSSystemRevise Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_SystemRevise, StorageStrategy = Default ]
{

/// Foreign Key FKSystemRevise created via DDL
ForeignKey FKSystemRevise(SystemDR) References dbo.SYSSystem(PKSYSSYSTEM) [ SqlName = FK_SystemRevise ];

/// DDL Primary Key Specification
Index PKSYSSYSTEMREVISE On RowID [ PrimaryKey, SqlName = PK_SYS_SYSTEMREVISE, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 系统模块
Property SystemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 主版本号
Property MajorNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 修正号
Property ReviseNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 更新日期
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 更新时间
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// IP地址
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 版本
Property BulidNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="SYSSystemReviseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemDR</Value>
</Value>
<Value name="3">
<Value>MajorNo</Value>
</Value>
<Value name="4">
<Value>ReviseNo</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>BulidNo</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSSystemReviseD</DataLocation>
<DefaultData>SYSSystemReviseDefaultData</DefaultData>
<IdLocation>^dbo.SYSSystemReviseD</IdLocation>
<IndexLocation>^dbo.SYSSystemReviseI</IndexLocation>
<StreamLocation>^dbo.SYSSystemReviseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
