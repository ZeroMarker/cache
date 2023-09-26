/// 名称:EPRinstance.DirectoryInformation
/// 描述:患者就诊病历目录信息
/// 编写者：Guozongtao
/// 编写日期: 2014-01-02
/// DirInfoData 格式 <NInstanceData><InstanceData><ID>11|1</ID><StartPageNum>1</StartPageNum><StartRowNum>1</StartRowNum><EndPageNum>2</EndPageNum><EndRowNum>11</EndRowNum></InstanceData><InstanceData><ID>11|2</ID><StartPageNum>1</StartPageNum><StartRowNum>1</StartRowNum><EndPageNum>2</EndPageNum><EndRowNum>11</EndRowNum></InstanceData></NInstanceData>
Class EMRinstance.DirectoryInformation Extends (%Persistent, User.Abstract)
{

Property DocID As %String;

Property DocName As %String;

Property EpisodeID As %String;

Property ECRecordID As %String;

Property DirInfoData As %GlobalBinaryStream;

Index IdxECRecordID On ECRecordID [ Unique ];

Index IdxEpisodeIDDocID On (EpisodeID, DocID) [ Unique ];

Storage Default
{
<Data name="DirectoryInformationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DirInfoData</Value>
</Value>
<Value name="3">
<Value>ECRecordID</Value>
</Value>
<Value name="4">
<Value>DocID</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>DocName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.DirectoryInformationD</DataLocation>
<DefaultData>DirectoryInformationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.DirectoryInformationD</IdLocation>
<IndexLocation>^DHCEMRI.DirectoryInformationI</IndexLocation>
<StreamLocation>^DHCEMRI.DirectoryInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
