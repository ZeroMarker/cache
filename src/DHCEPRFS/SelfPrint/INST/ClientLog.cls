Class DHCEPRFS.SelfPrint.INST.ClientLog Extends %Persistent
{

/// 日志类型 DEBUG,INFO,ERROR
Property LogType As %String(TRUNCATE = 1);

/// 客户端日期时间
Property LocalDateTime As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 信息
Property InfoMsg As %String(TRUNCATE = 1);

/// 错误信息
Property ErrMsg As %String(TRUNCATE = 1);

/// 来源
Property Source As %String(TRUNCATE = 1);

/// 堆栈
Property StackTrace As %String(TRUNCATE = 1);

/// 目标站点
Property TargetSite As %String(TRUNCATE = 1);

/// 程序版本
Property Version As %String(TRUNCATE = 1);

/// 程序运行路径
Property WorkDirectory As %String(TRUNCATE = 1);

/// IP
Property ClientIP As %String(TRUNCATE = 1);

/// 机器名
Property MachineName As %String(TRUNCATE = 1);

/// 操作系统
Property ClientOS As %String(TRUNCATE = 1);

/// 服务器日期
Property ServerDate As %Date;

/// 服务器时间
Property ServerTime As %Time;

Storage Default
{
<Data name="ClientLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocalDateTime</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>InfoMsg</Value>
</Value>
<Value name="5">
<Value>ErrMsg</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>StackTrace</Value>
</Value>
<Value name="8">
<Value>TargetSite</Value>
</Value>
<Value name="9">
<Value>Version</Value>
</Value>
<Value name="10">
<Value>WorkDirectory</Value>
</Value>
<Value name="11">
<Value>ClientIP</Value>
</Value>
<Value name="12">
<Value>MachineName</Value>
</Value>
<Value name="13">
<Value>ClientOS</Value>
</Value>
<Value name="14">
<Value>ServerDate</Value>
</Value>
<Value name="15">
<Value>ServerTime</Value>
</Value>
<Value name="16">
<Value>LogType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.SP.ClientLogD</DataLocation>
<DefaultData>ClientLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.SP.ClientLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.SP.ClientLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.SP.ClientLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
