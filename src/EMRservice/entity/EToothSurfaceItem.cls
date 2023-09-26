/// 名称: 牙面表
/// 描述: 牙面表
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.entity.EToothSurfaceItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 牙位代码
Property ToothPCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙面代码
Property ToothSICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothSIDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property ToothSIDefine As %String(MAXLEN = 300, TRUNCATE = 1);

/// 上标：SuperScript，下标：SubScript
Property ScriptMode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型Permanent:恒牙，Deciduous:乳牙
Property ToothType As %String(MAXLEN = 300, TRUNCATE = 1);

}
