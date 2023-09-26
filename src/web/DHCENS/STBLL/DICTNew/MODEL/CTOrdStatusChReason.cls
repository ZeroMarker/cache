Class web.DHCENS.STBLL.DICTNew.MODEL.CTOrdStatusChReason Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OrdStatusChReason";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOSCRCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOSCR_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOSCRCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOSCR_CodesystemCode");

/// 描述
Property CTOSCRDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOSCR_Desc");

/// 备注
Property CTOSCRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOSCR_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOSCRStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOSCR_Status");

/// 最后更新日期
Property CTOSCRUpdateDate As %Library.Date(XMLNAME = "CTOSCR_UpdateDate");

/// 最后更新时间
Property CTOSCRUpdateTime As %Library.Time(XMLNAME = "CTOSCR_UpdateTime");

/// 最后更新人编码
Property CTOSCRUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOSCR_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTOSCROriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOSCR_OriginalCode");

/// 原描述
Property CTOSCROriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOSCR_OriginalDesc");

/// 有效开始日期
Property CTOSCRStartDate As %Library.Date(XMLNAME = "CTOSCR_StartDate");

/// 有效结束日期
Property CTOSCREndDate As %Library.Date(XMLNAME = "CTOSCR_EndDate");

/// 创建日期
Property CTOSCRCreatDate As %Library.Date(XMLNAME = "CTOSCR_CreatDate");

/// 创建时间
Property CTOSCRCreatTime As %Library.Time(XMLNAME = "CTOSCR_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
