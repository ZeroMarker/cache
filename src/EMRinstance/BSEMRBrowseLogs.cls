Class EMRinstance.BSEMRBrowseLogs Extends %Persistent
{

/// 访问日期
Property ActDate As %Date;

/// 访问时间
Property ActTime As %Time;

/// 访问类型  WEBDOC 移动查房/ WEBPAT 互联网患者查看病历
Property ActType As %String;

/// 访问病历ID
Property InstanceId As %String(TRUNCATE = 1);

/// 访问者
Property UserCode As %String(TRUNCATE = 1);

Index IdxInstanceIdType On (InstanceId, ActType);

Storage Default
{
<Data name="BSEMRBrowseLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActDate</Value>
</Value>
<Value name="3">
<Value>ActTime</Value>
</Value>
<Value name="4">
<Value>ActType</Value>
</Value>
<Value name="5">
<Value>InstanceId</Value>
</Value>
<Value name="6">
<Value>UserCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.BSEMRBrowseLogsD</DataLocation>
<DefaultData>BSEMRBrowseLogsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.BSEMRBrowseLogsD</IdLocation>
<IndexLocation>^DHCEMRI.BSEMRBrowseLogsI</IndexLocation>
<StreamLocation>^DHCEMRI.BSEMRBrowseLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
