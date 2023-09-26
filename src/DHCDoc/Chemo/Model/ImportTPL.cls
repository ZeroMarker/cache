/// CTOR: QP
/// DATE: 2020-08-20
/// DESC: 化疗模板导入
Class DHCDoc.Chemo.Model.ImportTPL Extends %RegisteredObject
{

/// 模板类型
Property TPType As %String;

/// 模板描述
Property TPDesc As %String;

/// 化疗方案名称
Property TPName As %String;

/// 总周期数
Property TPStageNum As %String;

/// 周期代码
Property TSCode As %String;

/// 周期描述
Property TSDesc As %String;

/// 周期开始日期
Property TSStartDate As %String;

/// 周期结束日期
Property TSEndDate As %String;

/// 周期数
Property TSNextNum As %String;

/// 周期化疗日期
Property TSChemoDate As %String;

/// 组编号
Property TGCode As %String;

/// 组描述
Property TGDesc As %String;

/// 多选化疗日期
Property TGPlanDate As %String;

/// 是否主药组
Property TGMainDrug As %String;

/// 组备注
Property TGNote As %String;

/// 药品rowid
Property TIArcim As %String;

/// 药品Code
Property TIArcimCode As %String;

/// 药品名称
Property TIOrderName As %String;

/// 关联
Property TILink As %String;

/// 显示日期
Property TIShowDate As %String;

/// 输入值
Property TIInput As %String;

/// 计算公式
Property TIFormula As %String;

/// 标准值
Property TISTValue As %String;

/// 是否主药
Property TIMainDrug As %String;

/// 单次剂量
Property TIDose As %String;

/// 剂量单位
Property TIDoseUom As %String;

/// 频次
Property TIFreq As %String;

/// 用法
Property TIInstruc As %String;

/// 疗程
Property TIDura As %String;

/// 数量
Property TIQty As %String;

/// 单位
Property TIUom As %String;

/// 备注
Property TINote As %String;

/// 医嘱类型
Property TIPrior As %String;

/// 接受科室
Property TIRecLoc As %String;

/// 输液流速
Property TISpeed As %String;

/// 流速单位
Property TISpeedUom As %String;

/// 所属院区
Property TPHosp As %String;

}
