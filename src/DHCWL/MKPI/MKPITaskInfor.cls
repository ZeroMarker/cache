/// 指标4.3版本日志信息
/// DHCWL_MKPI.MKPITaskInfor		d ##class(DHCWL.MKPI.MKPITaskInfor).%BuildIndices()
/// 
Class DHCWL.MKPI.MKPITaskInfor Extends %Persistent [ ClassType = persistent, SqlTableName = MKPITaskInfor ]
{

/// 日志记录日期
Property LoginDate As %String [ SqlColumnNumber = 2, SqlFieldName = Login_Date ];

/// 开始时间
Property LoginSTime As %String [ SqlColumnNumber = 3, SqlFieldName = Login_STime ];

/// 结束时间
Property LoginETime As %String [ SqlColumnNumber = 4, SqlFieldName = Login_ETime ];

/// 调用的方法名字
Property CalledFunction As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = CalledFunction ];

/// 指标列表，操作中影响的指标列表id
Property MKPIIdList As %String(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = MKPIIdList ];

/// 备用字段1
Property BackupInfor As %String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = BackupInfor ];

/// 备用字段2
Property MBackupInfor As %String [ SqlColumnNumber = 8, SqlFieldName = MBackupInfor ];

/// 其他内容
Property OtherContent As %String [ SqlColumnNumber = 9, SqlFieldName = OtherContent ];

//Index LoginDate On (LoginDate);

Storage Default
{
<Data name="MKPITaskInforDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoginDate</Value>
</Value>
<Value name="3">
<Value>LoginSTime</Value>
</Value>
<Value name="4">
<Value>LoginETime</Value>
</Value>
<Value name="5">
<Value>CalledFunction</Value>
</Value>
<Value name="6">
<Value>MKPIIdList</Value>
</Value>
<Value name="7">
<Value>BackupInfor</Value>
</Value>
<Value name="8">
<Value>MBackupInfor</Value>
</Value>
<Value name="9">
<Value>OtherContent</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPITaskInforD</DataLocation>
<DefaultData>MKPITaskInforDefaultData</DefaultData>
<IdLocation>^DHCWL.MKPI.MKPITaskInforD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPITaskInforI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPITaskInforS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
