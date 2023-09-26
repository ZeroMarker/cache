/// 名称: 医生排班导入实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-11-25
Class web.BDPExt.RBResEffDateSessionEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.RBResEffDateSessionEntity";

/// rowid
Property SESSRowId As %String;

/// 班次 1
Property RSLDesc As %String;

/// 科室名称 2
Property LocDesc As %String;

/// 号别代码 3
Property RESCode As %String;

/// 号别名称 4
Property RESDesc As %String;

/// 出诊时间(星期) 5
Property WeekNum As %String;

/// 时段 6
Property TRDesc As %String;

/// 挂号职称 7
Property SessionTypeDesc As %String;

/// 亚专业 8
Property CLGRPDesc As %String;

/// 诊室 9
Property RoomDesc As %String;

/// 正号限额 10
Property SessLoad As %String;

/// 预约限额 11
Property SessNoApptSlot As %String;

/// 加号限额 12
Property AddtionMax As %String;

/// 预约起始号 13
Property SessNumberOfWeeks As %String;

/// 分时段就诊 14
Property TRFlag As %String;

/// 开始时间 15
Property TRStartTime As %String;

/// 结束时间 16
Property TREndTime As %String;

/// 间隔分钟 17
Property TRLength As %String;

/// 时段号数 18--不用了
Property TRRegNum As %String;

/// 分时段模板名称（不为空时走分时段模式分时，为空时按照间隔分钟分时段） 18
Property TTrtemName As %String;

/// 预约方式信息（方式|限额|起始号） 19
Property AppMethodStr As %String;

}
