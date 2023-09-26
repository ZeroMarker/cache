/// 医嘱套导入实体类
/// Creator:陈莹 
/// CreatDate:2020-03-20
/// 基础数据平台组
Class web.BDPExt.ARCOrdSetsEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.ARCOrdSetsEntity";

Property ARCOSRowId As %String;

// 医嘱套代码

Property ARCOSCode As %String;

// 医嘱套名称

Property ARCOSDesc As %String;

// 激活标志

Property ARCOSActiveFlag As %String;

// 医嘱套开始日期

Property ARCOSEffDateFrom As %String;

// 医嘱套结束日期

Property ARCOSEffDateTo As %String;

// 医嘱大类

Property ARCOSOrdCatDR As %String;

// 医嘱子类

Property ARCOSOrdSubCatDR As %String;

// 项目类型

Property Type As %String;

// 序列码

Property ITMSerialNo As %String;

// 项目代码

Property ARCIMCode As %String;

// 项目名称

Property ARCIMDesc As %String;

// 用法

Property ITMInstrucDR As %String;

// 频次

Property ITMFreqDR As %String;

// 数量

Property ITMQty As %String;

// 接收科室

Property ITMRecLocDR As %String;

// 医嘱类型

Property ITMType As %String;

// 项目开始日期

Property ARCIMEffDate As %String;

// 项目结束日期

Property ARCIMEffDateTo As %String;

// 剂量

Property ITMDoseQty As %String;

// 剂量单位

Property ITMUOMDR As %String;

// 可见

Property ITMVisible As %String;

// 关联

Property ITMLinkToVisibleItem As %String;

// 备注

Property ITMNotes As %String;

// 标本

Property Specimen As %String;

// 附加说明

Property Remarks As %String;

// 疗程

Property ITMDuratDR As %String;

// 医嘱阶段

Property ITMStage As %String;

// 整包装单位

Property ITMPackQtyUomDR As %String;

// 皮试

Property ITMSkinTest As %String;

// 皮试备注

Property ITMSkinTestAction As %String;

// 科室

Property FavDepDr As %String;

// 个人（工号）

Property FavUserDr As %String;

// 个人（姓名）

Property FavUserDrDesc As %String;

// 医院 2020-06-23（全院医嘱套）

Property FavHospDr As %String;

// 医嘱套医院 2020-06-23

Property FavUseHospDr As %String;

// 是否必开

Property OrderMustEnter As %String;

// 别名 2019-06-05

Property Alias As %String;

// 关联医生

Property ITMLinkDoctor As %String;

}
