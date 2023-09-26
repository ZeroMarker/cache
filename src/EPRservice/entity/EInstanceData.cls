Class EPRservice.entity.EInstanceData Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property CategoryID As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property CreateDate As %Date;

//Property CreateTime As %Time;

Property CreateTime As EPRmeta.Time;

Property CreateUser As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

Property HappenDate As %Date;

//Property HappenTime As %Time;

Property HappenTime As EPRmeta.Time;

Property ID As %String(TRUNCATE = 1);

Property InstanceData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRInstanceStream($J)");

Property ListNo As %String(TRUNCATE = 1);

Property MetaData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRInstanceStream($J)");

Property ModifyDate As %Date;

//Property ModifyTime As %Time;

Property ModifyTime As EPRmeta.Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PresentationData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRInstanceStream($J)");

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property TheECRecord As %String(TRUNCATE = 1);

Property Title As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

//Property Log As EPRservice.entity.EInstanceLog [ Collection = list ];

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..InstanceData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRInstanceStream($J)")
	{
  		do ..InstanceData.Clear()
	}
	
	s id = ..MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRInstanceStream($J)")
	{
		do ..MetaData.Clear() 
	}
	
	s id = ..PresentationData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRInstanceStream($J)")
	{
  		do ..PresentationData.Clear()
	}
	
  	quit "1"
}

}
