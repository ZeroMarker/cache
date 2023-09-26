/// 名称: 用法接收科室维护
/// 描述: 实体类
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-2-26
Class web.Entity.CT.DHCPHCInstrRecLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCPHCInstrRecLoc";

/// RowID
Property RowID As %String;

/// ParRef
Property InstrRecLocParRef As %String;

/// Sub
Property InstrRecLocSub As %String;

/// 病人科室
Property InstrOrdDep As %String;

/// 接收科室
Property InstrRecLoc As %String;

/// 默认
Property InstrDefault As %String;

/// 医嘱子类
Property InstrOrdSubCat As %String;

/// 医嘱类型
Property InstrOrdPrior As %String;

/// 时间范围
Property InstrTimeRange As %String;

/// 医院
Property InstrHospitalDR As %String;

}
