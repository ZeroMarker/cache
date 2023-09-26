Class EMRinstance.AdmMRecordStaLog Extends %Persistent
{

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作人
Property UserID As %String;

/// 操作动作(Confirm:确认 Revoke:撤销)
Property Action As %String(TRUNCATE = 1);

/// EMRinstance.AdmRecordStatus的ID
Property RecordStatusID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdmMRecordStaLogDefaultData">
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
</Data>
<DataLocation>^DHCEMRI.AdmMRecordStaLogD</DataLocation>
<DefaultData>AdmMRecordStaLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmMRecordStaLogD</IdLocation>
<IndexLocation>^DHCEMRI.AdmMRecordStaLogI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmMRecordStaLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
