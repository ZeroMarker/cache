/// 名称:EMR.DOC.DTO.HeaderAndFooterVersion
/// 描述:通用文档管理模块 Document(Doc) 数据传输对象
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-09
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.HeaderAndFooterVersion Extends %RegisteredObject
{

Property CreateDate As %Date;

Property CreateTime As %Time;

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property Status As %Integer;

/// CT.EMR.DOC.HeaderAndFooter.Code
Property HFCode As %String;

Property VersionNumber As %Integer;

Property XmlPackageData As %GlobalBinaryStream;

/// 病历摘要信息
Property Summary As %String(MAXLEN = 20000, TRUNCATE = 1);

}
