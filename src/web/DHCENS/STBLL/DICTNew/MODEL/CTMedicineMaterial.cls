Class web.DHCENS.STBLL.DICTNew.MODEL.CTMedicineMaterial Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_MedicineMaterial";

/// 药品代码
Property CTMMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMM_Code");

Property CTPHDMIBussnessCode As %String(XMLNAME = "CTPHDMI_BussnessCode");

/// 描述
Property CTMMDesc As %Library.String(MAXLEN = 50, XMLNAME = "CTMM_Desc");

/// 通用名
Property CTMMGenericName As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_GenericName");

/// 别名
Property CTMMAnotherName As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_AnotherName");

/// 代码表类型
Property CTMMCodesystemCode As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_CodesystemCode");

/// 规格
Property CTMMSpecification As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Specification");

/// 商品名
Property CTMMTradeName As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_TradeName");

/// 剂型描述
Property CTMMDosageFormDesc As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_DosageFormDesc");

/// 单价
Property CTMMUnitPrice As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_UnitPrice");

/// 厂商
Property CTMMManufacturerName As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_ManufacturerName");

/// 计价单位
Property CTMMValuationUnit As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_ValuationUnit");

/// 零售价门诊
Property CTMMRetailPrice As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_RetailPrice");

/// 整包装单位
Property CTMMPackingUnit As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PackingUnit");

/// 整包转换系数
Property CTMMPackingCoefficient As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PackingCoefficient");

/// 医嘱大类
Property CTMMOrderCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_OrderCategory");

/// 医嘱子类
Property CTMMOrderChildCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_OrderChildCategory");

/// 药理学大类
Property CTMMPharmacologyCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PharmacologyCategory");

/// 药理学子类
Property CTMMPharmacologyChildCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PharmacologyChildCategory");

/// 药理学小类
Property CTMMPharmacologySmallCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PharmacologySmallCategory");

/// 注意事项
Property CTMMNotice As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Notice");

/// 适应症
Property CTMMIndications As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Indications");

/// 禁忌症
Property CTMMContraindication As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Contraindication");

/// 不良反应
Property CTMMUntowardEffect As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_UntowardEffect");

/// 相互作用
Property CTMMInteraction As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Interaction");

/// 提示
Property CTMMReminder As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Reminder");

/// 国家基本药物
Property CTMMEssentialMedicine As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_EssentialMedicine");

/// 贵重标记
Property CTMMValuableSign As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_ValuableSign");

/// 生效日期
Property CTMMEffectiveDate As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_EffectiveDate");

/// 医保标志
Property CTMMHealthInsuranceSign As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_HealthInsuranceSign");

/// 医保编码
Property CTMMHealthInsuranceCoding As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_HealthInsuranceCoding");

/// 皮式标记
Property CTMMSkinTestSign As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_SkinTestSign");

/// 医保类别
Property CTMMHealthInsuranceCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_HealthInsuranceCategory");

/// 药品说明书
Property CTMMDirection As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Direction");

/// 限制特性
Property CTMMLimitedCharacteristic As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_LimitedCharacteristic");

/// 年龄限制
Property CTMMAgeLimit As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_AgeLimit");

/// 危重药物标志
Property CTMMCriticalCareMedicine As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_CriticalCareMedicine");

/// 抗菌药物标志
Property CTMMAntibacterialSign As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_AntibacterialSign");

/// 状态标志
Property CTMMStatusCode As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_StatusCode");

/// 启用日期
Property CTMMStartDate As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_StartDate");

/// 停用日期
Property CTMMEndDate As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_EndDate");

/// 剂量单位
Property CTMMDosUom As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_DosUom");

/// 药品剂量
Property CTMMDosage As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_Dosage");

/// 最小包装数量
Property CTMMMinPkgNum As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_MinPkgNum");

/// 药品拼音码
Property CTMMPYCode As %Library.String(MAXLEN = 20, XMLNAME = "CTMM_PYCode");

}
