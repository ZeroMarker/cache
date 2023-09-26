Class CIS.AN.BL.OEOrderItem Extends %RegisteredObject
{

/// 就诊号
Property EpisodeID As %String;

/// 就诊原因
Property AdmReason As %String;

/// 医嘱项ID
Property ArcimID As %String;

/// 医嘱类型
Property OrderType As %String;

/// 医嘱优先级（临时、长期、取药）
Property Priority As %String;

/// 开始日期
Property StartDate As %String;

/// 开始时间
Property StartTime As %String;

/// 开单科室
Property BillDept As %String;

/// 接收科室
Property ExecDept As %String;

/// 单次剂量
Property SingleDoseQty As %String;

/// 总剂量
Property DoseQty As %String;

/// 剂量单位
Property DoseUom As %String;

/// 小包装数量
Property PackQty As %String;

/// 小包装单位
Property PackUom As %String;

/// 用药途径
Property Instruction As %String;

/// 医嘱频次
Property Frequency As %String;

/// 疗程
Property Duration As %String;

/// 备注
Property Note As %String;

/// 序号
Property SeqNo As %String;

/// 主医嘱序号
Property MainSeqNo As %String;

/// 价格
Property Price As %String;

/// 皮试
Property SkinTest As %String;

/// 医保标识
Property MedicalInsurance As %String;

/// 麻醉表ID
Property Anaesthesia As %String;

/// 记费明细ID
Property ChargeDetailID As %String;

Method ToString() As %String
{
	set list=$lb(..ArcimID,..OrderType,..Priority,..StartDate,..StartTime)
	set list=list_$lb(..PackQty,..Price,..ExecDept,..AdmReason,"")
	set list=list_$lb(..Note,..SingleDoseQty,..DoseUom,..DoseQty,..Frequency)
	set list=list_$lb(..Duration,..Instruction,"",..MainSeqNo,..SeqNo)
	set list=list_$lb(..SkinTest,"",..MedicalInsurance,"","")
	set list=list_$lb("","","","","")
	set list=list_$lb("","","","","")
	set list=list_$lb("",..Anaesthesia)
	
	quit $ListToString(list,"^")
}

}
