Class web.DHCENS.STBLL.DICTNew.MODEL.CTRBCAppointMethod Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTRBCAMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRBCAM_Code");

/// 代码表类型 
Property CTRBCAMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRBCAM_CodesystemCode");

/// 描述
Property CTRBCAMDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTRBCAM_Desc");

/// 备注
Property CTRBCAMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRBCAM_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTRBCAMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRBCAM_Status");

/// 最后更新日期
Property CTRBCAMUpdateDate As %Library.Date(XMLNAME = "CTRBCAM_UpdateDate");

/// 最后更新时间
Property CTRBCAMUpdateTime As %Library.Time(XMLNAME = "CTRBCAM_UpdateTime");

/// 最后更新人编码
Property CTRBCAMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRBCAM_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTRBCAMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRBCAM_OriginalCode");

/// 原描述
Property CTRBCAMOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTRBCAM_OriginalDesc");

/// 有效开始日期
Property CTRBCAMStartDate As %Library.Date(XMLNAME = "CTRBCAM_StartDate");

/// 有效结束日期
Property CTRBCAMEndDate As %Library.Date(XMLNAME = "CTRBCAM_EndDate");

/// 创建日期
Property CTRBCAMCreatDate As %Library.Date(XMLNAME = "CTRBCAM_CreatDate");

/// 创建时间
Property CTRBCAMCreatTime As %Library.Time(XMLNAME = "CTRBCAM_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_RBCAppointMethod";

}
