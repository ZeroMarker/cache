/// 名称:     User.DHCPHInstanceLog ----- EMRinstance.InstanceLog
/// 描述:     实例数据-实例数据操作日志表
/// 编写者：  bianshuai
/// 编写日期: 2014-01-03
Class User.DHCPHInstanceLog Extends (%Persistent, User.Abstract)
{

Index IdxParRef On ParRef;

Index IdxParRefActionDateTime On (ParRef, Action, OperateDate, OperateTime);

Index IdxParRefFinalStatusDateTime On (ParRef, FinalStatus, OperateDate, OperateTime);

Index IdxEMRSignID On EMRSignID;

Relationship ParRef As User.DHCPHEMRLogs [ Cardinality = parent, Inverse = InstanceLog ];

Property Action As %String(TRUNCATE = 1);

Property OperateDate As %Date;

Property FinalStatus As %String(TRUNCATE = 1);

Property InitStatus As %String(TRUNCATE = 1);

Property OperateTime As %Time;

Property OperateUserID As %String(TRUNCATE = 1);

Property OperateMachineIP As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property RealOperateUserID As %String(TRUNCATE = 1);

Property OperateUserName As %String(TRUNCATE = 1);

Property LoginUserID As %String(TRUNCATE = 1);

Property LoginUserName As %String(TRUNCATE = 1);

/// 签名日志
Property EMRSignID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="InstanceLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>OperateDate</Value>
</Value>
<Value name="4">
<Value>FinalStatus</Value>
</Value>
<Value name="5">
<Value>InitStatus</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>OperateUserID</Value>
</Value>
<Value name="8">
<Value>OperateMachineIP</Value>
</Value>
<Value name="9">
<Value>TemplateID</Value>
</Value>
<Value name="10">
<Value>RealOperateUserID</Value>
</Value>
<Value name="11">
<Value>OperateUserName</Value>
</Value>
<Value name="12">
<Value>LoginUserID</Value>
</Value>
<Value name="13">
<Value>LoginUserName</Value>
</Value>
<Value name="14">
<Value>EMRSignID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("InstanceLog")</DataLocation>
<DefaultData>InstanceLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("InstanceLog")</IdLocation>
<IndexLocation>^DHCPHI.InstanceLogI</IndexLocation>
<StreamLocation>^DHCPHI.InstanceLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
