Class DHCEPRFS.META.FileStoreConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property StartDate As %Date [ Required, SqlColumnNumber = 2 ];

Property EndDate As %Date [ Required, SqlColumnNumber = 3 ];

// 目录结构为 

// FileServerIP/VirtualDir/NameSpace_year/month/day/file.pdf

Property FileServerIP As %String [ Required, SqlColumnNumber = 4 ];

Property VirtualDir As %String [ Required, SqlColumnNumber = 5 ];

Property NameSpace As %String [ Required, SqlColumnNumber = 6 ];

Property FileServerUserName As %String [ SqlColumnNumber = 7 ];

Property FileServerPassword As %String [ SqlColumnNumber = 8 ];

Property FileServerPort As %String [ SqlColumnNumber = 9 ];

Property FileServerTimeOut As %String [ SqlColumnNumber = 10 ];

Property FTPMethod As %String [ SqlColumnNumber = 11 ];

Index IdxDate On (NameSpace, StartDate, EndDate) [ Data = (FileServerIP, VirtualDir) ];

Storage Default
{
<Data name="FileStoreConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>FileServerIP</Value>
</Value>
<Value name="5">
<Value>VirtualDir</Value>
</Value>
<Value name="6">
<Value>NameSpace</Value>
</Value>
<Value name="7">
<Value>RootDir</Value>
</Value>
<Value name="8">
<Value>FileServerUserName</Value>
</Value>
<Value name="9">
<Value>FileServerPassword</Value>
</Value>
<Value name="10">
<Value>FileServerPort</Value>
</Value>
<Value name="11">
<Value>FileServerTimeOut</Value>
</Value>
<Value name="12">
<Value>FTPMethod</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.FileStoreConfigD</DataLocation>
<DefaultData>FileStoreConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.FileStoreConfigD</IdLocation>
<IndexLocation>^DHCEPRFS.META.FileStoreConfigI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.FileStoreConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
