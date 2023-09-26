/// 名称:		EMR.DOC.DTO.HFFormatVersion
/// 描述:		文档管理--文档版式版本传输对象
/// 编写者：	duan
/// 编写日期: 	2021-04-23
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.HFFormatVersion Extends %RegisteredObject
{

Property ID As %String;

/// 起效日期
Property EffectiveDate As %Date;

/// 起效时间
Property EffectiveTime As %Time;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %Integer;

/// CF.EMR.DOC.HeaderAndFooter
Property HFFormat As %Integer;

Property VersionNumber As %Integer;

Property XmlPackageData As %GlobalBinaryStream;

}
