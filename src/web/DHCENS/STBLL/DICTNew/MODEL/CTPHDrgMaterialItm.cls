Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHDrgMaterialItm Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 药品代码
Property CTPHDMICode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_Code");

/// 药品名称
Property CTPHDMIDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPHDMI_Desc");

/// 通用名
Property CTPHDMIGenericName As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_GenericName");

/// 商品名
Property CTPHDMIGoodsName As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMI_GoodsName");

/// 剂型代码
Property CTPHDMIDoseFormsCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_DoseFormsCode");

/// 厂商代码
Property CTPHDMIManufacturerCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_ManufacturerCode");

/// 危重药物标志
Property CTPHDMICriticalFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_CriticalFlag");

/// 抗菌药物标志
Property CTPHDMIAntibioticFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_AntibioticFlag");

/// 基本数量
Property CTPHDMIBasicQty As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_BasicQty");

/// 基本单位
Property CTPHDMIBasicUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_BasicUnitCode");

/// 管制分类
Property CTPHDMIRegulatoryClassCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_RegulatoryClassCode");

/// 适应症
Property CTPHDMIIndication As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHDMI_Indication");

/// 禁忌症
Property CTPHDMIContraInd As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHDMI_ContraInd");

/// 不良反应
Property CTPHDMIAdvReaction As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHDMI_AdvReaction");

/// 相互作用
Property CTPHDMIInteraction As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHDMI_Interaction");

/// 药学分类
Property CTPHDMICategoryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_CategoryCode");

/// 年龄限制
Property CTPHDMIAgeLimit As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMI_AgeLimit");

/// 疗程
Property CTPHDMIDurationCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_DurationCode");

/// 频次
Property CTPHDMIFreqCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_FreqCode");

/// 创建日期
Property CTPHDMICreatDate As %Library.Date(XMLNAME = "CTPHDMI_CreatDate");

/// 创建时间
Property CTPHDMICreatTime As %Library.Time(XMLNAME = "CTPHDMI_CreatTime");

/// 更新日期
Property CTPHDMIUpdateDate As %Library.Date(XMLNAME = "CTPHDMI_UpdateDate");

/// 更新时间
Property CTPHDMIUpdateTime As %Library.Time(XMLNAME = "CTPHDMI_UpdateTime");

/// 原代码
Property CTPHDMIOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_OriginalCode");

/// 原描述
Property CTPHDMIOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMI_OriginalDesc");

/// 有效开始日期
Property CTPHDMIStartDate As %Library.Date(XMLNAME = "CTPHDMI_StartDate");

/// 有效结束日期
Property CTPHDMIEndDate As %Library.Date(XMLNAME = "CTPHDMI_EndDate");

/// 代码表类型
Property CTPHDMICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_CodesystemCode");

/// 最后更新人编码
Property CTPHDMIUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_UpdateUserCode");

/// 医院代码
Property CTPHDMIHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_HosCode");

/// 药品剂量
Property CTPHDMIDosage As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_Dosage");

/// 药品计量单位代码
Property CTPHDMIDosageUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_DosageUnitCode");

/// 药品流水码
Property CTPHDMIRowId As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMI_RowId");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_PHDrgMaterialItm";

}
