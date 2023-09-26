Class web.DHCENS.STBLL.LIS.MODEL.PatLisOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Order";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱Rowid
Property OEORIOrderItemID As %String;

/// 检验号
Property OEORISpecimenID As %String;

/// 医嘱代码
Property OEORIARCItmMastCode As %String;

/// 医嘱名称
Property OEORIARCItmMastDesc As %String;

/// 医嘱数量
Property OEORIOrderQty As %String;

/// 收费状态代码
Property BillStatus As %String;

/// 标本类型代码
Property OEORISpecimenCode As %String;

/// 标本类型名称
Property OEORISpecimenDesc As %String;

/// 采集量
Property SpVolume As %String(TRUNCATE = 1);

/// 采集说明
Property ColInfo As %String(TRUNCATE = 1);

/// 容器代码
Property Container As %String(TRUNCATE = 1);

/// 容器描述
Property ContainerDesc As %String(TRUNCATE = 1);

/// 糖耐量序号
Property GTSeq As %String(TRUNCATE = 1);

/// 特殊标志
Property SpecFlag As %String(TRUNCATE = 1);

/// 医嘱下达日期 YYYY-MM-DD
Property VerifyDate As %String(TRUNCATE = 1);

/// 医嘱下达时间 hh:mm:ss
Property VerifyTime As %String(TRUNCATE = 1);

/// 标本采集日期 YYYY-MM-DD
Property ColDate As %String(TRUNCATE = 1);

/// 标本采集时间 hh:mm:ss
Property ColTime As %String(TRUNCATE = 1);

/// 申请科室代码
Property AppDeptCode As %String(TRUNCATE = 1);

/// 申请科室名称
Property AppDeptDesc As %String(TRUNCATE = 1);

/// 接收科室代码
Property RecDeptCode As %String(TRUNCATE = 1);

/// 接收科室名称
Property RecDeptDesc As %String(TRUNCATE = 1);

/// 价格
Property TSPrice As %String;

/// 医嘱状态
Property OrderStatus As %String;

/// 开单医生
Property DocCode As %String;

/// 医生名称
Property DocDesc As %String(TRUNCATE = 1);

/// 取报告地点
Property RepLoct As %String(TRUNCATE = 1);

/// 取报告日期
Property RepDate As %String(TRUNCATE = 1);

/// 取报告时间
Property RepTime As %String(TRUNCATE = 1);

/// 备注信息
Property Note As %String(TRUNCATE = 1);

/// 采集人代码
Property SpecUserCode As %String;

/// 采集人姓名
Property SpecUserDesc As %String;

/// 医嘱子类代码
Property OrdSubCatCode As %String;

/// 医嘱子类描述
Property OrdSubCatDesc As %String(TRUNCATE = 1);

/// 医嘱大类代码
Property OrdCatCode As %String(TRUNCATE = 1);

/// 医嘱大类描述
Property OrdCatDesc As %String(TRUNCATE = 1);

/// 医嘱计费状态
Property OEORIChargingStatus As %String(TRUNCATE = 1);

/// 生理周期代码
Property PhysiCycleCode As %String(MAXLEN = "");

/// 生理周期
Property PhysiCycle As %String(MAXLEN = "");

/// 检验医嘱外部代码
Property ExtCode As %String(MAXLEN = "");

/// 检验医嘱外部代码名称
Property ExtDesc As %String(MAXLEN = "");

}
