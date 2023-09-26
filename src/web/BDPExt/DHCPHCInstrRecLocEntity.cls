/// 名称: 药品用法接收科室导入用类
/// 描述: 用于药品用法接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-15
Class web.BDPExt.DHCPHCInstrRecLocEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.DHCPHCInstrRecLocEntity";

/// 药品用法代码
Property PHCINCode As %String;

/// 押品用法描述
Property PHCINDesc As %String;

/// Rowid
Property RowID As %String;

/// 接收科室
Property InstrRecLoc As %String;

/// 病人科室
Property InstrOrdDep As %String;

/// 默认 
Property InstrDefault As %String;

/// 医嘱子类
Property InstrOrdSubCat As %String;

/// 医嘱优先级
Property InstrOrdPrior As %String;

/// 开始时间
Property InstrTimeRangeFrom As %String;

/// 结束时间
Property InstrTimeRangeTo As %String;

/// 医院
Property InstrHospitalDR As %String;

/// 医嘱子类医院
Property InstrOrdSubCatDR As %String;

/// 病人科室医院
Property InstrOrdDepHosp As %String;

/// 接收科室医院
Property LinkHospId As %String;

}
