/// 名称: EMRservice.entity.EToothPosition
/// 描述: 牙位表
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.entity.EToothPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

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
