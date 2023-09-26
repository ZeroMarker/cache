/// 名称: EMRinstance.RecordTransferLog
/// 描述: 病历转移操作日志
/// 编写者：牛才才
/// 编写日期: 2019-5-15
Class EMRinstance.RecordTransferLog Extends %Persistent
{

Index EpisodeIDIdx On EpisodeID;

Index EpisodeAndOpDate On (EpisodeID, OperationDate);

Property EpisodeID As %String(TRUNCATE = 1);

// O:转出  I:收回

Property Action As %String(TRUNCATE = 1);

Property OperationDate As %Date;

Property OperationTime As %Time;

Property OperationUserID As %String(TRUNCATE = 1);

Property TransInDeptID As %String(TRUNCATE = 1);

Property TransOutStartDate As %Date;

Property TransOutStartTime As %Time;

Property TransOutEndDate As %Date;

Property TransOutEndTime As %Time;

Storage Default
{
<Data name="RecordTransferLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>Action</Value>
</Value>
<Value name="4">
<Value>OperationDate</Value>
</Value>
<Value name="5">
<Value>OperationTime</Value>
</Value>
<Value name="6">
<Value>OperationUserID</Value>
</Value>
<Value name="7">
<Value>TransInDeptID</Value>
</Value>
<Value name="8">
<Value>TransOutStartDate</Value>
</Value>
<Value name="9">
<Value>TransOutStartTime</Value>
</Value>
<Value name="10">
<Value>TransOutEndDate</Value>
</Value>
<Value name="11">
<Value>TransOutEndTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.RecordTransferLogD</DataLocation>
<DefaultData>RecordTransferLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.RecordTransferLogD</IdLocation>
<IndexLocation>^DHCEMRI.RecordTransferLogI</IndexLocation>
<StreamLocation>^DHCEMRI.RecordTransferLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
