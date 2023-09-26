Class web.DHCENS.STBLL.DICTNew.MODEL.CTConFac Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PHConversionFactor";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 关联id
Property CTPHCFLinkId As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_LinkId");

/// 源单位代码
Property CTPHCFCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_SourceCode");

/// 目标单位代码
Property CTPHCFTargetCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_TargetCode");

/// 类别
Property CTPHCFType As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_Type");

/// 代码表类型
Property CTPHCFCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_CodesystemCode");

/// 最后更新人编码
Property CTPHCFUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_UpdateUserCode");

/// 最后更新日期
Property CTPHCFUpdateDate As %Library.Date(XMLNAME = "CTPHCF_UpdateDate");

/// 最后更新时间
Property CTPHCFUpdateTime As %Library.Time(XMLNAME = "CTPHCF_UpdateTime");

/// 备注
Property CTPHCFRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCF_Remarks");

/// 创建日期
Property CTPHCFCreatDate As %Library.Date(XMLNAME = "CTPHCF_CreatDate");

/// 创建时间
Property CTPHCFCreatTime As %Library.Time(XMLNAME = "CTPHCF_CreatTime");

/// 原源代码
Property CTPHCFOriginalSourceCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_OriginalSourceCode");

/// 原目标代码
Property CTPHCFOriginalTargetCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_OriginalTargetCode");

/// 有效开始日期
Property CTPHCFStartDate As %Library.Date(XMLNAME = "CTPHCF_StartDate");

/// 有效结束日期
Property CTPHCFEndDate As %Library.Date(XMLNAME = "CTPHCF_EndDate");

/// 医院代码
Property CTPHCFHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCF_HosCode");

/// 药品转换系数
Property CTPHCFFactor As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHCF_Factor");

/// 状态
Property CTPHCFStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHCF_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
