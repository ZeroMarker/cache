/// 体检使用ftp目录
Class User.DHCPEFTPDirectoryManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPEFTPDirectoryManager";

/// ip地址
Property FTPIP As %String;

/// FTP用户
Property FTPUser As %String;

/// FTP密码
Property FTPPassWord As %String;

/// FTP端口
Property FTPPort As %String;

/// FTP根目录
Property FTPDirectory As %String;

/// 目录类型 1：基本信息照片  2：报告PDF
Property FTPType As %String;

/// FTP信息记录的子表
Relationship ChildRecord As User.DHCPEFTPDirectoryRecord [ Cardinality = children, Inverse = DirectoryParent ];

/// FTP目录是否可以使用  1：可用  0：不可用
Property FTPActiveFlag As %String;

Storage Default
{
<Data name="DHCPEFTPDirectoryManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FTPIP</Value>
</Value>
<Value name="3">
<Value>FTPUser</Value>
</Value>
<Value name="4">
<Value>FTPPassWord</Value>
</Value>
<Value name="5">
<Value>FTPPort</Value>
</Value>
<Value name="6">
<Value>FTPDirectory</Value>
</Value>
<Value name="7">
<Value>FTPType</Value>
</Value>
<Value name="8">
<Value>FTPActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEFTPDirectoryManagerD</DataLocation>
<DefaultData>DHCPEFTPDirectoryManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEFTPDirectoryManagerD</IdLocation>
<IndexLocation>^User.DHCPEFTPDirectoryManagerI</IndexLocation>
<StreamLocation>^User.DHCPEFTPDirectoryManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
