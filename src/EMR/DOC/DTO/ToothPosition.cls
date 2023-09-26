/// 名称:		EMR.DOC.DTO.ToothPosition
/// 描述:		牙位数据
/// 编写者：	zhangxl
/// 编写日期: 	2021-7-27
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.ToothPosition Extends %RegisteredObject
{

/// 代码
Property ToothPCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothPDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property ToothPDefine As %String(MAXLEN = 300, TRUNCATE = 1);

/// 牙象限
Property ToothPQuadrant As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型Permanent:恒牙，Deciduous:乳牙
Property ToothType As %String(MAXLEN = 300, TRUNCATE = 1);

}
