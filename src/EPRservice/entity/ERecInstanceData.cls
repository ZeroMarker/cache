Class EPRservice.entity.ERecInstanceData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property InstanceID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

/// 病历创建日期
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRRecInstanceStream($J)");

Property ListNo As %String(TRUNCATE = 1);

Property SeqNo As %String(TRUNCATE = 1);

/// 病历修改日期
Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property Title As %String(TRUNCATE = 1);

/// 历次病程记录备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..InstanceData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRRecInstanceStream($J)")
	{
  		do ..InstanceData.Clear()
	}
	/*
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
	*/
  	quit "1"
}

}
