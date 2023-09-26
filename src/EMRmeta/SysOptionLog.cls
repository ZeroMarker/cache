/// Desc:       系统参数操作日志
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRmeta.SysOptionLog Extends %Persistent
{

Index NameIndex On OldName;

/// 修改前描述
Property OldDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property OldIsVisible As %String(TRUNCATE = 1);

/// 修改插件是否加载
Property OldIsEditor As %String(TRUNCATE = 1);

/// 修改前名称
Property OldName As %String(TRUNCATE = 1);

/// 修改前值
Property OldOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 修改前描述
Property NewDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property NewIsVisible As %String(TRUNCATE = 1);

/// 修改插件是否加载
Property NewIsEditor As %String(TRUNCATE = 1);

/// 修改前名称
Property NewName As %String(TRUNCATE = 1);

/// 修改前值
Property NewOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 状态 添加：ADD,更新:UPDATE，删除：DELETE
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者ID
Property OperateUserID As %String(TRUNCATE = 1);

/// 操作者
Property OperateUserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property OperateMachineIP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SysOptionLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OldDescription</Value>
</Value>
<Value name="3">
<Value>OldIsVisible</Value>
</Value>
<Value name="4">
<Value>OldIsEditor</Value>
</Value>
<Value name="5">
<Value>OldName</Value>
</Value>
<Value name="6">
<Value>OldOptionValue</Value>
</Value>
<Value name="7">
<Value>NewDescription</Value>
</Value>
<Value name="8">
<Value>NewIsVisible</Value>
</Value>
<Value name="9">
<Value>NewIsEditor</Value>
</Value>
<Value name="10">
<Value>NewName</Value>
</Value>
<Value name="11">
<Value>NewOptionValue</Value>
</Value>
<Value name="12">
<Value>Action</Value>
</Value>
<Value name="13">
<Value>OperateDate</Value>
</Value>
<Value name="14">
<Value>OperateTime</Value>
</Value>
<Value name="15">
<Value>OperateUserID</Value>
</Value>
<Value name="16">
<Value>OperateMachineIP</Value>
</Value>
<Value name="17">
<Value>OperateUserName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SysOptionLogD</DataLocation>
<DefaultData>SysOptionLogDefaultData</DefaultData>
<IdLocation>^DHCEMRM.SysOptionLogD</IdLocation>
<IndexLocation>^DHCEMRM.SysOptionLogI</IndexLocation>
<StreamLocation>^DHCEMRM.SysOptionLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
