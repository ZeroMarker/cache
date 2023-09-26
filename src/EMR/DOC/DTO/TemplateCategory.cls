/// 名称:EMR.DOC.DTO.TemplateCategory
/// 描述:通用文档管理模块 Document(Doc) 数据传输对象
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-09
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.TemplateCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String;

/// 文档类型
Property StructType As %String;

/// 业务名称
Property EMRName As %String;

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父目录ID
Property ParentID As %String;

/// 父目录ID
Property ParentType As %String;

/// 目录下模板节点数
Property ResChildCount As %Integer;

/// 目录下模板节点数
Property BDMCategory As %String;

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 别名（拼音简写)
Property Alias As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

/// 标题
Property Title As %Integer;

}
