/// 名称:EMRinstance.InstanceLog
/// 描述:实例数据-实例数据操作日志表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRinstance.InstanceLog Extends %Persistent
{

Index IdxParRef On ParRef;

Index IdxParRefActionDateTime On (ParRef, Action, OperateDate, OperateTime);

Index IdxParRefFinalStatusDateTime On (ParRef, FinalStatus, OperateDate, OperateTime);

Index IdxEMRSignID On EMRSignID;

Index IdxActionDateTimeUserID On (Action, OperateDate, OperateTime, OperateUserID);

Relationship ParRef As EMRinstance.EMRLogs [ Cardinality = parent, Inverse = InstanceLog ];

Property Action As %String(TRUNCATE = 1);

Property OperateDate As %Date;

Property FinalStatus As %String(TRUNCATE = 1);

Property InitStatus As %String(TRUNCATE = 1);

Property OperateTime As %Time;

Property OperateUserID As User.SSUser;

Property OperateMachineIP As %String(TRUNCATE = 1);

Property TemplateID As EMRmeta.Template;

Property RealOperateUserID As %String(TRUNCATE = 1);

Property OperateUserName As %String(TRUNCATE = 1);

Property LoginUserID As %String(TRUNCATE = 1);

Property UserLoginLocID As %String(TRUNCATE = 1);

Property LoginUserName As %String(TRUNCATE = 1);

/// 签名日志
Property EMRSignID As %String(TRUNCATE = 1);

/// 产品模块
Property ProductSource As %String(TRUNCATE = 1);

/// EMRSignLog
Property EMRSignLogID As %String(TRUNCATE = 1);

Index IdxOperUserParRefDateTimeFinal On (OperateUserID, ParRef, OperateDate, OperateTime, FinalStatus);

Property RealTemplateID As %String [ Calculated, Private ];

Property RRealOperateUserID As %String [ Calculated, Private ];

Method RealTemplateIDGet(this) As %String
{
	
	if (..TemplateID="") q ""
	q ..TemplateID.%Id()
}

Method RRealOperateUserIDGet() As %String
{
	
	if (..OperateUserID="") q ""
	q ..OperateUserID.%Id()
}

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
<Value name="15">
<Value>UserLoginLocID</Value>
</Value>
<Value name="16">
<Value>ProductSource</Value>
</Value>
<Value name="17">
<Value>EMRSignLogID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("InstanceLog")</DataLocation>
<DefaultData>InstanceLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("InstanceLog")</IdLocation>
<IndexLocation>^DHCEMRI.InstanceLogI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
