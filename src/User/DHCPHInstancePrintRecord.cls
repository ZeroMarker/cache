/// 名称:EMRinstance.InstancePrintRecord
/// 描述:实例数据-病历打印记录子表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class User.DHCPHInstancePrintRecord Extends (%Persistent, User.Abstract)
{

Index IdxECRecordIDAndSeq On (ECRecordID, ECRSeq);

Index IdxEpisodePrintRecordID On EpisodePrintRecordID;

Index IdxInstanceDataID On InstanceDataID;

Property ContinuePrint As %Boolean;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUserID As %String(TRUNCATE = 1);

/// = $P(InstanceDataID,"||",2); = 历次病历的序号/成组模板的序号/唯一模板是1
Property ECRSeq As %String(TRUNCATE = 1);

Property ECRecordID As %String(TRUNCATE = 1);

Property EndPageNum As %Integer;

Property EndRowNum As %Integer;

Property EpisodePrintRecordID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property LastRowProperty As %String(TRUNCATE = 1);

Property PrintStatus As %String(TRUNCATE = 1);

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PrintTemplateVersion As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

Property StartPageNum As %Integer;

Property StartRowNum As %Integer;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Property UpdateUserID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="InstancePrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContinuePrint</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>CreateUserID</Value>
</Value>
<Value name="6">
<Value>ECRSeq</Value>
</Value>
<Value name="7">
<Value>ECRecordID</Value>
</Value>
<Value name="8">
<Value>EndPageNum</Value>
</Value>
<Value name="9">
<Value>EndRowNum</Value>
</Value>
<Value name="10">
<Value>EpisodePrintRecordID</Value>
</Value>
<Value name="11">
<Value>InstanceDataID</Value>
</Value>
<Value name="12">
<Value>LastRowProperty</Value>
</Value>
<Value name="13">
<Value>PrintStatus</Value>
</Value>
<Value name="14">
<Value>PrintTemplateID</Value>
</Value>
<Value name="15">
<Value>PrintTemplateVersion</Value>
</Value>
<Value name="16">
<Value>PrintType</Value>
</Value>
<Value name="17">
<Value>StartPageNum</Value>
</Value>
<Value name="18">
<Value>StartRowNum</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
<Value name="21">
<Value>UpdateUserID</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.InstancePrintRecordD</DataLocation>
<DefaultData>InstancePrintRecordDefaultData</DefaultData>
<IdLocation>^DHCPHI.InstancePrintRecordD</IdLocation>
<IndexLocation>^DHCPHI.InstancePrintRecordI</IndexLocation>
<StreamLocation>^DHCPHI.InstancePrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
