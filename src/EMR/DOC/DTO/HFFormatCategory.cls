/// 名称:EMR.DOC.DTO.HFFormatCategory
/// 描述:通用文档管理 文档版式模块 目录(文档)数据传输对象
/// 编写者：duan
/// 编写日期: 2021-06-08
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.HFFormatCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String;

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父目录ID
Property ParentID As %String;

/// 目录下模板节点数
Property ResChildCount As %Integer;

Property ParentType As %String;

}
