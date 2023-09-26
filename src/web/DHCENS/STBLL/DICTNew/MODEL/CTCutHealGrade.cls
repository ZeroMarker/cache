Class web.DHCENS.STBLL.DICTNew.MODEL.CTCutHealGrade Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_CutHealGrade";

/// 代码
Property CTCHGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHG_Code");

/// 代码表类型
Property CTCHGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHG_CodesystemCode");

/// 描述
Property CTCHGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCHG_Desc");

/// 备注
Property CTCHGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCHG_Remarks");

/// 最后更新日期
Property CTCHGUpdateDate As %Library.Date(XMLNAME = "CTCHG_UpdateDate");

/// 最后更新时间
Property CTCHGUpdateTime As %Library.Time(XMLNAME = "CTCHG_UpdateTime");

/// 最后更新人编码
Property CTCHGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHG_UpdateUserCode");

/// 创建日期
Property CTCHGCreatDate As %Library.Date(XMLNAME = "CTCHG_CreatDate");

/// 创建时间
Property CTCHGCreatTime As %Library.Time(XMLNAME = "CTCHG_CreatTime");

/// 原代码
Property CTCHGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHG_OriginalCode");

/// 原描述
Property CTCHGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCHG_OriginalDesc");

/// 有效开始日期
Property CTCHGStartDate As %Library.Date(XMLNAME = "CTCHG_StartDate");

/// 有效结束日期
Property CTCHGEndDate As %Library.Date(XMLNAME = "CTCHG_EndDate");

/// 医院代码
Property CTCHGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHG_HosCode");

/// 状态
Property CTCHGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCHG_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
