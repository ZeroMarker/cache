/// 名称:CT.EMR.IP.SysOptionMLog
/// 描述:系统参数设置操作记录表（住院 IP）
/// 编写者：yejian
/// 编写日期: 2020-7-8
Class CT.EMR.IP.SysOptionMLog Extends %Persistent
{

Index idxTypeName On (OldType, OldName) [ Unique ];

Index idxName On OldName;

/// 修改前名称
Property OldName As %String(TRUNCATE = 1);

/// 修改前参数类型(通用文档:DOC，住院：IP，门急诊：OP)
Property OldType As %String(TRUNCATE = 1);

/// 修改前描述
Property OldDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property OldIsVisible As %String(TRUNCATE = 1);

/// 修改前值
Property OldOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 修改前名称
Property NewName As %String(TRUNCATE = 1);

/// 修改前参数类型(通用文档:DOC，系统通用：COM，住院：IP，门急诊：OP)
Property NewType As %String(TRUNCATE = 1);

/// 修改前描述
Property NewDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property NewIsVisible As %String(TRUNCATE = 1);

/// 修改前值
Property NewOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 状态 添加：ADD,更新:UPDATE
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者ID
Property OperateUserID As %String(TRUNCATE = 1);

/// 操作者名称
Property OperateUserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property OperateMachineIP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SysOptionMLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OldName</Value>
</Value>
<Value name="3">
<Value>OldType</Value>
</Value>
<Value name="4">
<Value>OldDescription</Value>
</Value>
<Value name="5">
<Value>OldIsVisible</Value>
</Value>
<Value name="6">
<Value>OldOptionValue</Value>
</Value>
<Value name="7">
<Value>NewName</Value>
</Value>
<Value name="8">
<Value>NewType</Value>
</Value>
<Value name="9">
<Value>NewDescription</Value>
</Value>
<Value name="10">
<Value>NewIsVisible</Value>
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
<Value>OperateUserName</Value>
</Value>
<Value name="17">
<Value>OperateMachineIP</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.IP.SysOptionMLogD</DataLocation>
<DefaultData>SysOptionMLogDefaultData</DefaultData>
<IdLocation>^CT.EMR.IP.SysOptionMLogD</IdLocation>
<IndexLocation>^CT.EMR.IP.SysOptionMLogI</IndexLocation>
<StreamLocation>^CT.EMR.IP.SysOptionMLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
