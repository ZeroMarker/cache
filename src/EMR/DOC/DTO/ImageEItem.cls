Class EMR.DOC.DTO.ImageEItem Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 目录ID
Property CategoryID As %String;

/// 图片类型
Property ImageType As %String(MAXLEN = 20, TRUNCATE = 1);

/// 图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMREImageItemStream($J)");

/// 发布状态(0:未发布;1:已发布)
Property IsPublish As %String;

/// 顺序
Property Sequence As %String;

/// Desc: 清空与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..ImageData.GetStreamId()
	if $find(id,"^CacheTempDHCEMREImageItemStream($J)")
	{
		do ..ImageData.Clear()
	}
	/*
	s id = ..HotSpotData.GetStreamId()
	if $find(id,"^CacheTempDHCEPREImageItemStream($J)")
	{
  		do ..HotSpotData.Clear()
	}
	*/
  	quit "1"
}

}
