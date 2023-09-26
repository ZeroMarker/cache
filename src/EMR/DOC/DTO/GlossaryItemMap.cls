/// 名称:		EMR.DOC.DTO.GlossaryItemMap
/// 描述:		术语集文档元素值域关联表传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-15
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.GlossaryItemMap Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowID
Property ID As %String;

/// 术语子集ID关联EPRmeta.GlossaryItem的ID
Property GlossaryItemID As %String;

/// 模版数据ID
Property TempID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模版数据描述
Property TempDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元允许值标示符关联ID
Property DECVMID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元允许值ID
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据元允许值描述
Property DEVDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 字典单元：编码，其他为空
Property CodeSystem As %String(MAXLEN = 50, TRUNCATE = 1);

}
