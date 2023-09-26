/// 记录每个人的FTP信息
Class User.DHCPEFTPDirectoryRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPEFTPDirectoryRecord";

Relationship DirectoryParent As User.DHCPEFTPDirectoryManager [ Cardinality = parent, Inverse = ChildRecord ];

/// 登记号
Property DRRegNo As %String;

/// 登记号索引
Index RegNoIndex On DRRegNo As AlphaUp;

Storage Default
{
<Data name="DHCPEFTPDirectoryRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRRegNo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRecord")</DataLocation>
<DefaultData>DHCPEFTPDirectoryRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEFTPDirectoryManagerC("ChildRecord")</IdLocation>
<IndexLocation>^User.DHCPEFTPDirectoryRecordI</IndexLocation>
<StreamLocation>^User.DHCPEFTPDirectoryRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
