Class EPRservice.entity.EImageItem Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 图库ID
Property ImageLibID As %Integer;

/// 项目RowID
Property ImageTreeID As %Integer;

/// 原始图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEPREImageItemStream($J)");

/// 带热区图片数据
Property HotSpotData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPREImageItemStream($J)");

/// 图示数据
Property IconData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPREImageItemStream($J)");

/// 图片状态(0:新增;1:裁剪;2:发布)
Property Status As %String(TRUNCATE = 1);

/// 发布状态
Property IsPublish As %String(TRUNCATE = 1);

/// Desc: 清空与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..ImageData.GetStreamId()
	if $find(id,"^CacheTempDHCEPREImageItemStream($J)")
	{
		do ..ImageData.Clear()
	}
	
	s id = ..HotSpotData.GetStreamId()
	if $find(id,"^CacheTempDHCEPREImageItemStream($J)")
	{
  		do ..HotSpotData.Clear()
	}
	
  	quit "1"
}

}
