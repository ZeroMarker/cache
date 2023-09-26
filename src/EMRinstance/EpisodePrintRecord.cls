/// 名称:EMRinstance.EpisodePrintRecord
/// 描述:实例数据-病历打印记录
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRinstance.EpisodePrintRecord Extends %Persistent
{

Index IdxEpisodeAndPrintType On (EpisodeID, PrintType);

Index IdxEpisodeAndECRecordID On (EpisodeID, PrintType, ECRecordID);

Property CurPageNum As %String(TRUNCATE = 1);

Property CurRowNum As %String(TRUNCATE = 1);

Property ECRecordID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EpisodePrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CurPageNum</Value>
</Value>
<Value name="3">
<Value>CurRowNum</Value>
</Value>
<Value name="4">
<Value>ECRecordID</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>PrintType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.EpisodePrintRecordD</DataLocation>
<DefaultData>EpisodePrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.EpisodePrintRecordD</IdLocation>
<IndexLocation>^DHCEMRI.EpisodePrintRecordI</IndexLocation>
<StreamLocation>^DHCEMRI.EpisodePrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
