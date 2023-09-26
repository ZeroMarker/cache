/// Desc：     特殊操作日志
/// Creator:   Candy
/// CreateDate:2017-8-13
Class EMRinstance.SpecialLog Extends (%Persistent, %XML.Adaptor)
{

Index IdxUserAction On (OperateUserID, Action);

Index IdxInstance On (InstanceID, Action, OperateUserID);

/// 目录展现结构ID
Property DocID As %String(TRUNCATE = 1);

/// 实例ID	
Property InstanceID As %String(TRUNCATE = 1);

/// 动作
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者
Property OperateUserID As %String(TRUNCATE = 1);

/// IP
Property OperateMachineIP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SpecialLogDefaultData">
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
<Value>OperateTime</Value>
</Value>
<Value name="5">
<Value>OperateUserID</Value>
</Value>
<Value name="6">
<Value>OperateMachineIP</Value>
</Value>
<Value name="7">
<Value>InstanceID</Value>
</Value>
<Value name="8">
<Value>DocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.SpecialLogD</DataLocation>
<DefaultData>SpecialLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.SpecialLogD</IdLocation>
<IndexLocation>^DHCEMRI.SpecialLogI</IndexLocation>
<StreamLocation>^DHCEMRI.SpecialLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
