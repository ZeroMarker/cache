Class EMRservice.entity.EQueue Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1);

/// 编辑器类型GRID 表格编辑器(首页用),DOC word编辑器 
Property PluginType As %String(TRUNCATE = 1);

/// 病历类型，可重复模板"Multiple"，唯一模板"Single"
Property ChartItemType As %String(TRUNCATE = 1);

/// 客户端IP
Property ClientIP As %String(MAXLEN = 20, TRUNCATE = 1);

/// 导出类型
Property Type As %String;

/// 导出页数
Property PageCount As %String;

/// 导出起始页
Property StartPage As %String;

/// 导出终止页
Property EndPage As %String(TRUNCATE = 1);

/// 优先级
Property Priority As %Integer;

/// 对列创建日期
Property HappenDate As %Date;

/// 对列创建时间
Property HappenTime As %Time;

/// 任务开始日期
Property TaskDate As %Date;

/// 任务开始时间
Property TaskTime As %Time;

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 执行任务Ip
Property TaskIP As %String(MAXLEN = 20, TRUNCATE = 1);

/// 就诊类型
Property AdmType As %String(MAXLEN = 20, TRUNCATE = 1);

/// 文件类型jpg,xml等
Property FileType As %String(MAXLEN = 20, TRUNCATE = 1);

Property CdaXml As %GlobalCharacterStream(LOCATION = "^CacheQueueCdaXmlStream($J)");

/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..CdaXml.GetStreamId()
	if $find(id,"^CacheQueueCdaXmlStream($J)")
	{
  		do ..CdaXml.Clear()
	}
  	quit "1"
}

}
