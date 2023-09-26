/// 库存项
Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHDrgMaterialStock Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PHDrgMaterialStock";

Parameter XMLIGNAMEINVALIDTAG = 1;

Parameter XMLIGNAMENULL = 1;

/// 代码
Property CTPHDMSCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_Code");

/// 名称
Property CTPHDMSDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPHDMS_Desc");

/// 别名
Property CTPHDMSAlias As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMS_Alias");

/// 规格
Property CTPHDMSSpec As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMS_Spec");

/// 入库单位
Property CTPHDMSCheckInUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_CheckInUnitCode");

/// 基本单位
Property CTPHDMSBasicUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_BasicUnitCode");

/// 大包装单位
Property CTPHDMSPackageUnitCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_PackageUnitCode");

/// 大包转换系数
Property CTPHDMSPackConvFacCode As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMS_PackConvFacCode");

/// 注意事项
Property CTPHDMSNotice As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHDMS_Notice");

/// 国家基本药物
Property CTPHDMSStateBasicDryFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_StateBasicDryFlag");

/// 贵重标记
Property CTPHDMSValuableFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_ValuableFlag");

/// 皮式标记
Property CTPHDMSSkinTestFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_SkinTestFlag");

/// 停用标记
Property CTPHDMSStopStatusFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_StopStatusFlag");

/// 入库转换系数
Property CTPHDMSCheckInConvFacCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_CheckInConvFacCode");

/// 批准文号
Property CTPHDMSApprovalNum As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMS_ApprovalNum");

/// 冷藏标识
Property CTPHDMSColdStorageFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_ColdStorageFlag");

/// 创建日期
Property CTPHDMSCreatDate As %Library.String(XMLNAME = "CTPHDMS_CreatDate");

/// 创建时间
Property CTPHDMSCreatTime As %Library.String(XMLNAME = "CTPHDMS_CreatTime");

/// 更新日期
Property CTPHDMSUpdateDate As %Library.String(XMLNAME = "CTPHDMS_UpdateDate");

/// 更新时间
Property CTPHDMSUpdateTime As %Library.String(XMLNAME = "CTPHDMS_UpdateTime");

/// 原代码
Property CTPHDMSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_OriginalCode");

/// 原描述
Property CTPHDMSOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHDMS_OriginalDesc");

/// 有效开始日期
Property CTPHDMSStartDate As %Library.String(XMLNAME = "CTPHDMS_StartDate");

/// 有效结束日期
Property CTPHDMSEndDate As %Library.String(XMLNAME = "CTPHDMS_EndDate");

/// 代码表类型
Property CTPHDMSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_CodesystemCode");

/// 最后更新人编码
Property CTPHDMSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_UpdateUserCode");

/// 医院代码
Property CTPHDMSHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_HosCode");

/// 库存分类代码
Property CTPHDMSStkCatCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHDMS_StkCatCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
