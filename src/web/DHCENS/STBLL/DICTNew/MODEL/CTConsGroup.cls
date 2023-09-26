Class web.DHCENS.STBLL.DICTNew.MODEL.CTConsGroup Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ConsGroup";

/// 代码
Property CTCGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCG_Code");

/// 代码表类型
Property CTCGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCG_CodesystemCode");

/// 描述
Property CTCGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCG_Desc");

/// 备注
Property CTCGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCG_Remarks");

/// 最后更新日期
Property CTCGUpdateDate As %Library.Date(XMLNAME = "CTCG_UpdateDate");

/// 最后更新时间
Property CTCGUpdateTime As %Library.Time(XMLNAME = "CTCG_UpdateTime");

/// 最后更新人编码
Property CTCGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCG_UpdateUserCode");

/// 创建日期
Property CTCGCreatDate As %Library.Date(XMLNAME = "CTCG_CreatDate");

/// 创建时间
Property CTCGCreatTime As %Library.Time(XMLNAME = "CTCG_CreatTime");

/// 原代码
Property CTCGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCG_OriginalCode");

/// 原描述
Property CTCGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCG_OriginalDesc");

/// 有效开始日期
Property CTCGStartDate As %Library.Date(XMLNAME = "CTCG_StartDate");

/// 有效结束日期
Property CTCGEndDate As %Library.Date(XMLNAME = "CTCG_EndDate");

/// 医院代码
Property CTCGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCG_HosCode");

/// 状态
Property CTCGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCG_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
