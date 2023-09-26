/// 名称:EMRinstance.PrintToolRecord
/// 描述:通过工具打印-病历打印记录
/// 编写者：yejian
/// 编写日期: 2018-4-8
Class EMRinstance.PrintToolRecord Extends %Persistent
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

Property UserRoleCode As %String;

Storage Default
{
<Data name="PrintToolRecordDefaultData">
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
<Value name="7">
<Value>ContinuePrint</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>CreateUserID</Value>
</Value>
<Value name="11">
<Value>ECRSeq</Value>
</Value>
<Value name="12">
<Value>EndPageNum</Value>
</Value>
<Value name="13">
<Value>EndRowNum</Value>
</Value>
<Value name="14">
<Value>EpisodePrintRecordID</Value>
</Value>
<Value name="15">
<Value>InstanceDataID</Value>
</Value>
<Value name="16">
<Value>LastRowProperty</Value>
</Value>
<Value name="17">
<Value>PrintStatus</Value>
</Value>
<Value name="18">
<Value>PrintTemplateID</Value>
</Value>
<Value name="19">
<Value>PrintTemplateVersion</Value>
</Value>
<Value name="20">
<Value>StartPageNum</Value>
</Value>
<Value name="21">
<Value>StartRowNum</Value>
</Value>
<Value name="22">
<Value>UpdateDate</Value>
</Value>
<Value name="23">
<Value>UpdateTime</Value>
</Value>
<Value name="24">
<Value>UpdateUserID</Value>
</Value>
<Value name="25">
<Value>UserRoleCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PrintToolRecordD</DataLocation>
<DefaultData>PrintToolRecordDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PrintToolRecordD</IdLocation>
<IndexLocation>^DHCEMRI.PrintToolRecordI</IndexLocation>
<StreamLocation>^DHCEMRI.PrintToolRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
