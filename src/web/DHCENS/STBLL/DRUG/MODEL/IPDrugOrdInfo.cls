/// 类名：web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo
/// 描述：住院患者药品医嘱信息Model
/// 编写者：WuXianPu
/// 编写日期：2012-02-29
Class web.DHCENS.STBLL.DRUG.MODEL.IPDrugOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "DrugOrdInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病历号
Property DocumentNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DocumentNo");

/// 病人ID号
Property PatId As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "PatId");

/// 病人姓名
Property Name As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Name");

/// 病人性别
Property Sex As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Sex");

/// 出生年月
Property DOB As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DOB");

/// 年龄
Property Age As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Age");

/// 就诊号
Property AdmNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AdmNo");

/// 科室代码
Property DeptCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DeptCode");

/// 科室名称
Property DeptName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DeptName");

/// 病区编码（实际发放地）
Property WardCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "WardCode");

/// 病区名称
Property WardName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "WardName");

/// 床号
Property BedNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "BedNo");

/// 就诊医生代码
Property AdmDoctorCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AdmDoctorCode");

/// 就诊医生名称
Property AdmDoctorName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AdmDoctorName");

/// 就诊科室代码
Property AdmDeptCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AdmDeptCode");

/// 就诊科室名称
Property AdmDeptName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AdmDeptName");

/// 医生代码
Property DocCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DocCode");

/// 医生姓名
Property DocName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DocName");

/// 发药单号
Property PageNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "PageNo");

/// 处方号
Property PresNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "PresNo");

/// 条码号
Property BarCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "BarCode");

/// 医嘱ID
Property OrdId As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OrdId");

/// 医嘱药品类别
Property OrdType As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OrdType");

/// 用药明细ID
Property OrdDetailId As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OrdDetailId");

/// 医嘱日期时间
Property OrdDateTime As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OrdDateTime");

/// 药品编码（同药品表）
Property DrugCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DrugCode");

/// 药品名称
Property DrugName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DrugName");

/// 库房编号
Property GroupNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "GroupNo");

/// 库房科室代码
Property GroupCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "GroupCode");

/// 库房科室名称
Property GroupDesc As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "GroupDesc");

/// 嘱托
Property Comment As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Comment");

/// 服法
Property Usage As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Usage");

/// 规格
Property Specification As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Specification");

/// 包装规格
Property DrugSpec As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DrugSpec");

/// 最小包装剂量
Property MinDos As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "MinDos");

/// 最小包装单位
Property MinDosUnits As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "MinDosUnits");

/// 药品剂量
Property Dosage As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Dosage");

/// 剂量单位
Property DosUnit As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DosUnit");

/// 实际服药数量
Property UsageNum As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "UsageNum");

/// 计价数量
Property TotalNum As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "TotalNum");

/// 口服时间
Property OccTime As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OccTime");

/// 用药次数
Property UsageCount As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "UsageCount");

/// 是否分包标志（默认写0）
Property Flag As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Flag");

/// 机器号
Property MacNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "MacNo");

/// 优先标志（默认写0）
Property PriFlag As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "PriFlag");

/// 明细编号（腕带用）
Property DetailSeq As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DetailSeq");

/// 分包时间（默认写Null）
Property GenDateTime As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "GenDateTime");

/// 长期或者临时标识
Property Priority As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Priority");

/// 药品单价（售）
Property Price As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Price");

/// 序号
Property SeqNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "SeqNo");

/// 频次
Property Freq As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "Freq");

/// 频次描述
Property FreqDesc As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "FreqDesc");

/// 批号
Property BatNo As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "BatNo");

/// 草药付数
Property FrescFac As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "FrescFac");

/// 药品厂商
Property ManfName As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "ManfName");

/// 剂量单位与基本单位系数
Property AmountUomFac As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "AmountUomFac");

/// 发药单类别
Property DrugType As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DrugType");

/// 剂型
Property FormCode As %String(MAXLEN = 32767, XMLNAME = "FormCode");

/// 基本单位
Property BaseUnit As %String(MAXLEN = 32767, XMLNAME = "BaseUnit");

/// 打印时间
Property PrintTime As %String(MAXLEN = 32767, XMLNAME = "PrintTime");

}
