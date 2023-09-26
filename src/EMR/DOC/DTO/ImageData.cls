/// 名称:	EMR.DOC.DTO.ImageData
/// 描述:	图库对象
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.ImageData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 类型
Property Type As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

Property LangID As %String(TRUNCATE = 1);

}
