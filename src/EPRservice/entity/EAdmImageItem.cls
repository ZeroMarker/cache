/// 描述：患者就诊图片实体对象
/// 创建者：HouJian
/// 创建日期：2011-09-26
Class EPRservice.entity.EAdmImageItem Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// RowID
Property ID As %String(TRUNCATE = 1);

/// 就诊指针
Property EpisodeID As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEPRAdmImageItemStream($J)");

/// 热区数据
Property HotSpotData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRAdmImageItemStream($J)");

/// 图示数据
Property IconData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPREImageItemStream($J)");

/// 状态
Property Status As %String(TRUNCATE = 1);

/// 发布状态
Property IsPublish As %String(TRUNCATE = 1);

/// Desc: 清空与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..ImageData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRAdmImageItemStream($J)")
	{
		do ..ImageData.Clear()
	}
	
	s id = ..HotSpotData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRAdmImageItemStream($J)")
	{
  		do ..HotSpotData.Clear()
	}
	
  	quit "1"
}

}
