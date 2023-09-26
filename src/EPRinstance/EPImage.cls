/// 名称：EPRinstance.EPImage
/// 描述：病历预览图片
/// 编写者：HouJ
/// 编写日期：2009-07-24
Class EPRinstance.EPImage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EPRLogsID As %String(TRUNCATE = 1);

/// 打印类型：Single, Multiple
Property PrintType As %String(TRUNCATE = 1);

/// 保存方式：Local, Remote, DB
Property SaveType As %String(TRUNCATE = 1);

Property PageCount As %Integer;

Property PageWidth As %Float;

Property PageHeight As %Float;

/// 是否有独立的标题行图片
Property HasTitlePage As %String(TRUNCATE = 1);

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Index IdxForLink On (EpisodeID, EPRLogsID) [ Unique ];

ClassMethod GetImageCount(argEpisodeID As %String, argEPRLogsID As %String) As %Integer
{
	s count = ""
	&sql(select count(EpisodeID) into :count from EPRinstance.EPImage 
		where EpisodeID = :argEpisodeID and EPRLogsID = :argEPRLogsID)
	q:(count="") 0
	q count
}

ClassMethod GetEPImageID(argEpisodeID As %String, argEPRLogsID As %String) As %String
{
	q:(($d(argEpisodeID)=0)||($d(argEPRLogsID)="")) ""
	
	s episodeID = " "_argEpisodeID
	s logsID = " "_argEPRLogsID
	
	s rowId = $O(^DHCEPRI.EPImageI("IdxForLink",episodeID,logsID,""))	
	q rowId
}

Storage Default
{
<Data name="EPImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ImageData</Value>
</Value>
<Value name="4">
<Value>PageHeight</Value>
</Value>
<Value name="5">
<Value>PageNumber</Value>
</Value>
<Value name="6">
<Value>PageWidth</Value>
</Value>
<Value name="7">
<Value>PrintTemplateID</Value>
</Value>
<Value name="8">
<Value>PageIndex</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>ModifyDate</Value>
</Value>
<Value name="12">
<Value>ModifyTime</Value>
</Value>
<Value name="13">
<Value>PageCount</Value>
</Value>
<Value name="14">
<Value>SaveType</Value>
</Value>
<Value name="15">
<Value>PrintType</Value>
</Value>
<Value name="16">
<Value>InstanceDataID</Value>
</Value>
<Value name="17">
<Value>ImagePages</Value>
</Value>
<Value name="18">
<Value>EPRDocID</Value>
</Value>
<Value name="19">
<Value>HappenDate</Value>
</Value>
<Value name="20">
<Value>HappenTime</Value>
</Value>
<Value name="21">
<Value>EPRLogsID</Value>
</Value>
<Value name="22">
<Value>PatientID</Value>
</Value>
<Value name="23">
<Value>HasTitle</Value>
</Value>
<Value name="24">
<Value>HasTitlePage</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPImageD</DataLocation>
<DefaultData>EPImageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EPImageD</IdLocation>
<IndexLocation>^DHCEPRI.EPImageI</IndexLocation>
<StreamLocation>^DHCEPRI.EPImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
