/// 名称:CF.EMR.DOC.BindField
/// 描述:通用文档管理模块 数据集元对象
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.BindField Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 字段编码（术语集HDSD码）
Property Code As %String(TRUNCATE = 1);

/// 字段名称
Property Name As %String(TRUNCATE = 1);

/// 字段描述
Property Description As %String(TRUNCATE = 1);

/// 数据绑定查询
Property BindQuery As %String(TRUNCATE = 1);

/// 绑定属性名
Property BindFiled As %String(TRUNCATE = 1);

/// 返回值类型
Property ValueType As %String(TRUNCATE = 1);

}
