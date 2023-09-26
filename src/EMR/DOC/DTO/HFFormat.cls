/// 名称:		EMR.DOC.DTO.HFFormat
/// 描述:		文档管理--文档版式传输对象
/// 编写者：	duan
/// 编写日期: 	2021-04-23
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.HFFormat Extends %RegisteredObject
{

Property ID As %String;

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property LastVersion As %Integer;

/// CF.EMR.DOC.HeaderAndFooterVersion.VersionNumber
Property PublishVersion As %Integer;

/// 目录(CF.EMR.DOC.TemplateStructure表StructType类型为Document)
Property BDMCategory As %Integer;

/// 版式目录表
Property HFFormatCategory As %Integer;

}
