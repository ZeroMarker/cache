/// 名称:EMR.DOC.DTO.Template
/// 描述:通用文档管理模块 Document(Doc) 数据传输对象
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-09
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.Template Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 文档模板编码
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 文档业务名称
Property EMRName As %String(MAXLEN = 200, TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 项目标识
Property Product As %String(TRUNCATE = 1);

/// 文档板式  CF.EMR.DOC.HFFormat（CF.EMR.DOC.HFFormat表中BDMCategory属性标示文档结构）
Property HFFormat As %String(TRUNCATE = 1);

/// 文档标示 （唯一：Single/重复：Multiple）
Property ChartItemType As %String(TRUNCATE = 1);

/// 文档类型 DOC/GRID/FREEFORM
Property DocumentType As %String(TRUNCATE = 1);

/// 文档模板最后保存版本
Property TempLastVersion As %Integer;

/// 文档模板发布版本
Property TempPublishVersion As %Integer;

/// 文档目录
Property TemplateCategory As %String(TRUNCATE = 1);

}
