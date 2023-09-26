/// Desc:       病历全部完成状态操作日志表
/// Creator:    DongLuLu
/// CreateDate: 2019-4-18
Class EMRinstance.AdmRecordStatusLog Extends %Persistent
{

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作人
Property UserID As %String;

/// 操作动作(Confirm:确认 Revoke:撤销 WithDraw:退回 Recall:召回)
Property Action As %String(TRUNCATE = 1);

/// 操作人IP地址
Property IPAddress As %String(TRUNCATE = 1);

/// 操作产品模块来源
Property ProductSource As %String(TRUNCATE = 1);

/// EMRinstance.AdmRecordStatus的ID
Property RecordStatusID As %String(TRUNCATE = 1);

/// 当前操作后病历提交状态（1：提交，0：撤销 -1:退回 -2:召回）
Property CompletedStatus As %String(TRUNCATE = 1);

/// 备注(撤销送病案室原因等)
Property Remark As %String(TRUNCATE = 1);

Index IdxRecordStatusID On RecordStatusID;

Storage Default
{
<Data name="AdmRecordStatusLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperateDate</Value>
</Value>
<Value name="3">
<Value>OperateTime</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>Action</Value>
</Value>
<Value name="6">
<Value>RecordStatusID</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>ProductSource</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>CompletedStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AdmRecordStatusLogD</DataLocation>
<DefaultData>AdmRecordStatusLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmRecordStatusLogD</IdLocation>
<IndexLocation>^DHCEMRI.AdmRecordStatusLogI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmRecordStatusLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
