/// 类名：web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo
/// 描述：门诊患者药品医嘱信息Model
/// 编写者：WuXianPu
/// 编写日期：2012-02-29
Class web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "OPDrugOrdInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人ID号
Property PatId As %String(MAXLEN = 32767, XMLNAME = "PatId");

/// 病人姓名
Property Name As %String(MAXLEN = 32767, XMLNAME = "Name");

/// 年龄
Property Age As %String(MAXLEN = 32767, XMLNAME = "Age");

/// 病人性别
Property Sex As %String(MAXLEN = 32767, XMLNAME = "Sex");

/// 诊断
Property DiagnoDesc As %String(MAXLEN = 32767, XMLNAME = "DiagnoDesc");

/// 身高
Property PatHeight As %String(MAXLEN = 32767, XMLNAME = "PatHeight");

/// 配药人
Property PName As %String(MAXLEN = 32767, XMLNAME = "PName");

/// 发药人
Property FName As %String(MAXLEN = 32767, XMLNAME = "FName");

/// 配药日期
Property PDateTime As %String(MAXLEN = 32767, XMLNAME = "PDateTime");

/// 发药日期
Property FDateTime As %String(MAXLEN = 32767, XMLNAME = "FDateTime");

/// 系统时间
Property DateTime As %String(MAXLEN = 32767, XMLNAME = "DateTime");

/// 接收科室药房
Property RecCtLoc As %String(MAXLEN = 32767, XMLNAME = "RecCtLoc");

/// 患者单位
Property PatCompany As %String(MAXLEN = 32767, XMLNAME = "PatCompany");

/// 就诊日期
Property AdmDateTime As %String(MAXLEN = 32767, XMLNAME = "AdmDateTime");

/// 就诊卡号
Property AdmCardNo As %String(MAXLEN = 32767, XMLNAME = "AdmCardNo");

/// 处方号
Property PrescNo As %String(MAXLEN = 32767, XMLNAME = "PrescNo");

/// 就诊科室
Property AdmCtLoc As %String(MAXLEN = 32767, XMLNAME = "AdmCtLoc");

/// 就诊科室代码
Property AdmCtLocCode As %String(MAXLEN = 32767, XMLNAME = "AdmCtLocCode");

/// 配药窗口
Property WindowNo As %String(MAXLEN = 32767, XMLNAME = "WindowNo");

/// 患者电话
Property TelePhone As %String(MAXLEN = 32767, XMLNAME = "TelePhone");

/// 患者住址
Property Address As %String(MAXLEN = 32767, XMLNAME = "Address");

/// 处方煎药方式
Property PrescMake As %String(MAXLEN = 32767, XMLNAME = "PrescMake");

/// 处方数量
Property PrescNum As %String(MAXLEN = 32767, XMLNAME = "PrescNum");

/// 处方类别
Property PrescType As %String(MAXLEN = 32767, XMLNAME = "PrescType");

/// 医生科室
Property DocCtLoc As %String(MAXLEN = 32767, XMLNAME = "DocCtLoc");

/// 医生
Property Doctor As %String(MAXLEN = 32767, XMLNAME = "Doctor");

/// 处方用法(草药)
Property HerbPrescMake As %String(MAXLEN = 32767, XMLNAME = "HerbPrescMake");

/// 处方剂数(草药)
Property HerbPrescNum As %String(MAXLEN = 32767, XMLNAME = "HerbPrescNum");

/// 处方日期(草药)
Property HerbPrescStartDate As %String(MAXLEN = 32767, XMLNAME = "HerbPrescStartDate");

/// 处方停止日期(草药)
Property HerbPrescStopDate As %String(MAXLEN = 32767, XMLNAME = "HerbPrescStopDate");

/// 处方备注(草药)
Property PrescNote As %String(MAXLEN = 32767, XMLNAME = "PrescNote");

/// 医嘱日期
Property OrdDateTime As %String(MAXLEN = 32767, XMLNAME = "OrdDateTime");

/// 结算日期
Property BalanceDateTime As %String(MAXLEN = 32767, XMLNAME = "BalanceDateTime");

/// 药品编码
Property DrugCode As %String(MAXLEN = 32767, XMLNAME = "DrugCode");

/// 药品名称
Property DrugName As %String(MAXLEN = 32767, XMLNAME = "DrugName");

/// 数量
Property Qty As %String(MAXLEN = 32767, XMLNAME = "Qty");

/// 单位
Property Unit As %String(MAXLEN = 32767, XMLNAME = "Unit");

/// 剂量
Property Dosage As %String(MAXLEN = 32767, XMLNAME = "Dosage");

/// 剂量单位
Property DosageUnit As %String(MAXLEN = 32767, XMLNAME = "DosageUnit");

/// 用法
Property Common As %String(MAXLEN = 32767, XMLNAME = "Common");

/// 频次
Property Freq As %String(MAXLEN = 32767, XMLNAME = "Freq");

/// 疗程
Property Phdur As %String(MAXLEN = 32767, XMLNAME = "Phdur");

/// 单价
Property Price As %String(MAXLEN = 32767, XMLNAME = "Price");

/// 总价
Property TotalPrice As %String(MAXLEN = 32767, XMLNAME = "TotalPrice");

/// 皮试
Property Skintest As %String(MAXLEN = 32767, XMLNAME = "Skintest");

/// 医嘱备注
Property OrdreMark As %String(MAXLEN = 32767, XMLNAME = "OrdreMark");

/// 特殊用法
Property Specinst As %String(MAXLEN = 32767, XMLNAME = "Specinst");

/// 发票号
Property Invoice As %String(MAXLEN = 32767, XMLNAME = "Invoice");

/// 厂家
Property Manuactory As %String(MAXLEN = 32767, XMLNAME = "Manuactory");

/// 规格
Property Specification As %String(MAXLEN = 32767, XMLNAME = "Specification");

/// 拆零系数
Property quotiety As %String(MAXLEN = 32767, XMLNAME = "quotiety");

}
