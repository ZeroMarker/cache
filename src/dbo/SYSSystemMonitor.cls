Class dbo.SYSSystemMonitor Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_SystemMonitor ]
{

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On (IP, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexNum On (IP, DataNum) [ SqlName = Index_Num, Type = index ];

/// DDL Primary Key Specification
Index PKSYSSYSTEMMONITOR On RowID [ PrimaryKey, SqlName = PK_SYS_SYSTEMMONITOR, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// IP
Property IP As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 磁盘总大小
Property DiskTotalSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 磁盘使用大小
Property DiskUsedSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 磁盘可用大小
Property DiskAvailableSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 磁盘使用率 
Property DiskUse As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 数据数量 
Property DataNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 使用速度
Property DiskUseSpeed As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 使用速度移动均值
Property DiskSpeedMoveAve As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// OS
Property OS As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 13 ];

/// 内存总大小
Property MemTotalSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

/// 内存使用大小
Property MemUsedSize As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="SYSSystemMonitorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IP</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>DiskTotalSize</Value>
</Value>
<Value name="6">
<Value>DiskUsedSize</Value>
</Value>
<Value name="7">
<Value>DiskAvailableSize</Value>
</Value>
<Value name="8">
<Value>DiskUse</Value>
</Value>
<Value name="9">
<Value>DataNum</Value>
</Value>
<Value name="10">
<Value>DiskUseSpeed</Value>
</Value>
<Value name="11">
<Value>DiskSpeedMoveAve</Value>
</Value>
<Value name="12">
<Value>OS</Value>
</Value>
<Value name="13">
<Value>MemTotalSize</Value>
</Value>
<Value name="14">
<Value>MemUsedSize</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSSystemMonitorD</DataLocation>
<DefaultData>SYSSystemMonitorDefaultData</DefaultData>
<IdLocation>^dbo.SYSSystemMonitorD</IdLocation>
<IndexLocation>^dbo.SYSSystemMonitorI</IndexLocation>
<StreamLocation>^dbo.SYSSystemMonitorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
