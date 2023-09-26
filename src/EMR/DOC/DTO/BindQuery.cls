/// 名称:CF.EMR.DOC.BindQuery
/// 描述:通用文档管理模块 数据集传输对象
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.BindQuery Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String(TRUNCATE = 1);

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 绑定描述
Property Description As %String(TRUNCATE = 1);

/// 绑定方式
Property BindType As %String(TRUNCATE = 1);

/// 绑定实现方法（类名:方法名）
Property QueryName As %String(TRUNCATE = 1);

/// 是否返回多行
Property ReturnMuch As %String(TRUNCATE = 1);

}
