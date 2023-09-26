Class EMRmeta.FileStoreConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property NameSpace As %String [ Required, SqlColumnNumber = 2 ];

Property StartDate As %Date [ Required, SqlColumnNumber = 3 ];

Property EndDate As %Date [ Required, SqlColumnNumber = 4 ];

Property FileServerIP As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property VirtualDir As %String(MAXLEN = 500) [ Required, SqlColumnNumber = 6 ];

/// 患者就诊级别图片目录存储策略
/// VOL : 分卷存储，每个vol目录存储10000个PatientID
/// ADMDATE : 按照入院日期存储，目录类型为：/dhcepr/2018-01-01/
Property AdmDirType As %String [ Required, SqlColumnNumber = 7 ];

Index IdxDate On (NameSpace, StartDate, EndDate) [ Data = (FileServerIP, VirtualDir, AdmDirType) ];

Storage Default
{
<Data name="FileStoreConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NameSpace</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>FileServerIP</Value>
</Value>
<Value name="6">
<Value>VirtualDir</Value>
</Value>
<Value name="7">
<Value>AdmDirType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.FileStoreConfigD</DataLocation>
<DefaultData>FileStoreConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.FileStoreConfigD</IdLocation>
<IndexLocation>^DHCEMRM.FileStoreConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.FileStoreConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
