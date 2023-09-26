/// 名称:EMRinstance.InstanceData
/// 描述:实例数据-实例数据表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRinstance.InstanceData Extends (%Persistent, User.Abstract)
{

Index IdxECRecord On TheECRecord;

Index IdxModifyDate On ModifyDate;

Index IdxEcRecordAndListNo On (TheECRecord, ListNo) [ Unique ];

Index IdxListNoTemplateIDVersion On (TemplateID, TemplateVersion, ListNo);

Index IdxHappenDateTime On (TheECRecord, Status, HappenDate, HappenTime);

Index IdxEcrecordTemplateStatus On (TheECRecord, TemplateID, Status);

Index IdxEpisodeStatusHappenDateTime On (EpisodeID, Status, HappenDate, HappenTime);

Index IdxEpisodeTitleCodeStatus On (EpisodeID, TitleCode, Status);

Index IdxHappenDTTS On (HappenDate, HappenTime, TemplateID, Status);

Relationship TheECRecord As EMRinstance.ECRecord [ Cardinality = parent, Inverse = Instances ];

/// 病历创建日期
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalBinaryStream(LOCATION = "^DHCEMRI.InstanceDataS");

/// 实例数据-是模板元数据定义的实例，与InstanceData对应
Property InstanceMetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRI.InstanceDataS");

/// 病历模板规则脚本定义信息
Property InstanceScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRI.InstanceDataS");

/// 媒体信息
Property InstanceMedia As %GlobalBinaryStream(LOCATION = "^DHCEMRI.InstanceDataS");

/// 默认值
Property InstanceInitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRI.InstanceDataS");

Property ListNo As %String(TRUNCATE = 1);

/// 病历修改日期
Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As EMRmeta.Template;

Property TemplateVersion As %Integer;

Property Title As %String(TRUNCATE = 1);

/// 历次病程记录备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标题代码
Property TitleCode As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 备注
Property Memo As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 起始页
Property StartPageNum As %Integer;

/// 起始行
Property StartRowNum As %Integer;

/// 结束页
Property EndPageNum As %Integer;

/// 结束行
Property EndRowNum As %Integer;

/// 是否加密
Property IsEncrypt As %Integer;

Property RealTemplateID As %String [ Calculated, Private ];

Property RealEpisodeID As %String [ Calculated, Private ];

Method RealTemplateIDGet(this) As %String
{
	if (..TemplateID = "") q ""
	q ..TemplateID.%Id()
}

Method RealEpisodeIDGet() As %String
{
	
	if (..EpisodeID="") q ""
	q ..EpisodeID.%Id()
}

Storage Default
{
<Data name="InstanceDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>CreateUser</Value>
</Value>
<Value name="5">
<Value>GroupItemID</Value>
</Value>
<Value name="6">
<Value>GroupItemName</Value>
</Value>
<Value name="7">
<Value>HappenDate</Value>
</Value>
<Value name="8">
<Value>HappenTime</Value>
</Value>
<Value name="9">
<Value>InstanceData</Value>
</Value>
<Value name="10">
<Value>ListNo</Value>
</Value>
<Value name="11">
<Value>ModifyDate</Value>
</Value>
<Value name="12">
<Value>ModifyTime</Value>
</Value>
<Value name="13">
<Value>ModifyUser</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>TemplateID</Value>
</Value>
<Value name="16">
<Value>TemplateVersion</Value>
</Value>
<Value name="17">
<Value>Title</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>InstanceMetaData</Value>
</Value>
<Value name="20">
<Value>InstanceScriptData</Value>
</Value>
<Value name="21">
<Value>TitleCode</Value>
</Value>
<Value name="22">
<Value>EpisodeID</Value>
</Value>
<Value name="23">
<Value>InstanceMedia</Value>
</Value>
<Value name="24">
<Value>Memo</Value>
</Value>
<Value name="25">
<Value>StartPageNum</Value>
</Value>
<Value name="26">
<Value>StartRowNum</Value>
</Value>
<Value name="27">
<Value>EndPageNum</Value>
</Value>
<Value name="28">
<Value>EndRowNum</Value>
</Value>
<Value name="29">
<Value>InstanceInitialData</Value>
</Value>
<Value name="30">
<Value>IsEncrypt</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Instances")</DataLocation>
<DefaultData>InstanceDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Instances")</IdLocation>
<IndexLocation>^DHCEMRI.InstanceDataI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
