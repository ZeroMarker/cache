Class EMR.DOC.DTO.LocTemplateCategory Extends %RegisteredObject
{

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构类型  （Category目录/Document文档）
Property StructType As %String;

/// ID
Property ID As %String;

/// 父目录ID
Property ParentID As %String;

/// 目录下模板节点数
Property ResChildCount As %Integer;

/// 显示次序
Property Sequence As %Integer;

/// 业务名称
Property EMRName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联模板
Property TemplateID As %String;

/// 项目标识
Property Product As %String;

/// 病种
Property Disease As %String;

/// 状态
Property Status As %String;

}
