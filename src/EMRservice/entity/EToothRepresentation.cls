/// 名称:EMRservice.entity.EToothRepresentation
/// 描述: 当前使用牙位表示法
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.entity.EToothRepresentation Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property ToothCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态(0:未使用，1：正在使用)
Property Status As %String(MAXLEN = 100, TRUNCATE = 1);

}
