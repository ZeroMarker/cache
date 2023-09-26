Class web.DHCENS.STBLL.DICTNew.MODEL.CTTarItem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ChargeItem";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 收费项目代码
Property CTCICode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_Code");

/// 收费项目描述
Property CTCIDesc As %Library.String(MAXLEN = 300, XMLNAME = "CTCI_Desc");

/// 代码表类型
Property CTCICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_CodesystemCode");

/// 备注
Property CTCIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCI_Remarks");

/// 状态
Property CTCIStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCI_Status");

/// 最后更新人编码
Property CTCIUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_UpdateUserCode");

/// 最后更新日期
Property CTCIUpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_UpdateDate");

/// 最后更新时间
Property CTCIUpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 收费子类代码
Property CTCICCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_CCCode");

/// 住院收费子类代码
Property CTCIIPCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_IPCCCode");

/// 核算收费子类代码
Property CTCIEMCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_EMCCCode");

/// 会计收费子类代码
Property CTCIACCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_ACCCCode");

/// 门诊收费子类代码
Property CTCIOPCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_OPCCCode");

/// 病案首页费用子类代码
Property CTCIMRCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_MRCCCode");

/// 国家编码
Property CTCICCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_CCode");

/// 彩虹码
Property CTCICCHCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_CCHCode");

/// 别名
Property CTCIAnoName As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_AnoName");

/// 医院代码
Property CTCIHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_HosCode");

/// 新病案首页费用子类代码
Property CTCIMRCCCodeNew As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_MRCCCodeNew");

/// 单位代码
Property CTCIUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_UnitCode");

/// 创建日期
Property CTCICreatDate As %Library.Date(XMLNAME = "CTCI_CreatDate");

/// 创建时间
Property CTCICreatTime As %Library.Time(XMLNAME = "CTCI_CreatTime");

/// 原代码
Property CTCIOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_OriginalCode");

/// 原描述
Property CTCIOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCI_OriginalDesc");

/// 有效开始日期
Property CTCIStartDate As %Library.Date(XMLNAME = "CTCI_StartDate");

/// 有效结束日期
Property CTCIEndDate As %Library.Date(XMLNAME = "CTCI_EndDate");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
