/// 手术操作类型[病案]字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTOperationType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_OperationType";

/// 代码
Property CTOTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOT_Code");

/// 代码表类型
Property CTOTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOT_CodesystemCode");

/// 描述
Property CTOTDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTOT_Desc");

/// 备注
Property CTOTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOT_Remarks");

/// 最后更新日期
Property CTOTUpdateDate As %Library.Date(XMLNAME = "CTOT_UpdateDate");

/// 最后更新时间
Property CTOTUpdateTime As %Library.Time(XMLNAME = "CTOT_UpdateTime");

/// 最后更新人编码
Property CTOTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOT_UpdateUserCode");

/// 创建日期
Property CTOTCreatDate As %Library.Date(XMLNAME = "CTOT_CreatDate");

/// 创建时间
Property CTOTCreatTime As %Library.Time(XMLNAME = "CTOT_CreatTime");

/// 原代码
Property CTOTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOT_OriginalCode");

/// 原描述
Property CTOTOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTOT_OriginalDesc");

/// 有效开始日期
Property CTOTStartDate As %Library.Date(XMLNAME = "CTOT_StartDate");

/// 有效结束日期
Property CTOTEndDate As %Library.Date(XMLNAME = "CTOT_EndDate");

/// 医院代码
Property CTOTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOT_HosCode");

/// 状态
Property CTOTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
