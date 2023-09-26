/// 名称:EMRinstance.EMRLogs
/// 描述:存储病历操作日志和状态
/// 编写者：Guozongtao
/// 编写日期: 2014-01-07
Class EMRinstance.EMRLogs Extends %Persistent
{

Index IdxMain On (EpisodeID, EMRDocID, EMRNum) [ Unique ];

Index IdxForLink On (EpisodeID, HappenDate, HappenTime, EMRDocID) [ Unique ];

Index IdxCreateDateTime On (CreateDate, CreateTime, EpisodeID, EMRDocID, EMRNum);

Property EpisodeID As User.PAAdm;

/// 病历结构ID，即打印模板在病历结构表中的RowID
Property EMRDocID As EMRmeta.EMRTemplateCategory;

/// 病历顺序号，对唯一病历，该值始终为1，对可重复病历的可重复模板，该值为相应的ListNo, 对可重复病历的唯一模板，该值为0
Property EMRNum As %Integer;

/// 病历目前最新状态Code(EMRmeta.EMRStatus)
Property EMRStatus As %String(TRUNCATE = 1);

/// 病历操作日志
Relationship InstanceLog As EMRinstance.InstanceLog [ Cardinality = children, Inverse = ParRef ];

/// 病历对应医疗行为发生日期（如是哪天的病程记录，可以修改，内部格式）
Property HappenDate As %Date;

/// 病历对应医疗行为发生时间(如是哪天的病程记录，可以修改，内部格式)
Property HappenTime As %Time;

/// 病历创建的实际日期(不可修改，内部格式)
Property CreateDate As %Date;

/// 病历创建的实际时间(不可修改，内部格式)
Property CreateTime As %Time;

/// 病历创建者的UserID
Property CreateUserID As %String(TRUNCATE = 1);

Property RealEMRDocID As %String [ Calculated, Private ];

Property RealEpisodeID As %String [ Calculated, Private ];

Method RealEMRDocIDGet(this) As %String
{
	
	if (..EMRDocID="") q ""
	q ..EMRDocID.%Id()
}

Method RealEpisodeIDGet() As %String
{
	
	if (..EpisodeID="") q ""
	q ..EpisodeID.%Id()
}

Storage Default
{
<Data name="EMRLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRDocID</Value>
</Value>
<Value name="4">
<Value>EMRNum</Value>
</Value>
<Value name="5">
<Value>EMRStatus</Value>
</Value>
<Value name="6">
<Value>HappenDate</Value>
</Value>
<Value name="7">
<Value>HappenTime</Value>
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
</Data>
<DataLocation>^DHCEMRI.EMRLogsD</DataLocation>
<DefaultData>EMRLogsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.EMRLogsD</IdLocation>
<IndexLocation>^DHCEMRI.EMRLogsI</IndexLocation>
<StreamLocation>^DHCEMRI.EMRLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
