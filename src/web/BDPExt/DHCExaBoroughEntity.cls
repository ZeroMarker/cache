/// 名称:分诊区维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.DHCExaBoroughEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCExaBoroughEntity";

/// rowid
Property ID As %String;

/// 代码
Property ExabCode As %String;

/// 名称
Property ExabName As %String;

/// 备注
Property ExabMemo As %String;

/// 是否报到(Y/N)
Property ExabTem As %String;

/// DHCExaBoroughFilePath 通过ExabDr指向分诊区表DHCExaBorough
/// 呼叫目录
Property ExabSubCallFilePath As %String;

/// 等候目录
Property ExabSubWaitFilePath As %String;

/// 医院
Property ExabHospitalDr As %String;

}
