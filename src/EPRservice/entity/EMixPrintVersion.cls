Class EPRservice.entity.EMixPrintVersion Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property BindTemplateID As %String(TRUNCATE = 1);

Property BindTemplateName As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property ContinuePrint As %Boolean;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Data As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPREMixPrtVerStream($J)");

Property Description As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(TRUNCATE = 1);

Property NewPage As %Boolean;

Property PrintTemplateCategoryID As %String(TRUNCATE = 1);

Property PrintTemplateFormat As %String(TRUNCATE = 1);

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PublicationDate As %Date;

Property PublicationTime As %Time;

/// 发布版本
Property PublishVersion As %Integer;

Property ShapeNames As %String(TRUNCATE = 1);

Property Status As %Integer;

Property VersionNumber As %Integer;

/// 标题行起始页
Property HeadStartPageNum As %String(TRUNCATE = 1);

Property FootRepeatRowStart As %String(TRUNCATE = 1);

Property FootRepeatRowEnd As %String(TRUNCATE = 1);

Property OnePageRowCount As %String(TRUNCATE = 1);

/// 唯一模板中是否在后面的空白部分打印格线
Property UnderLine As %Boolean;

/// 添加空白行时是否复制文本行格式（如格线等）
Property BlankRowWithBorder As %Boolean;

Property Duplex As %Boolean;

Property MultiplePagesOption As %String(TRUNCATE = 1);

Property NewPageStartOdd As %Boolean;

Property BlankPageStyle As %String(TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..Data.GetStreamId()
	if $find(id,"^CacheTempDHCEPREMixPrtVerStream($J)")
	{
		do ..Data.Clear()
	}
	
  	quit "1"
}

}
