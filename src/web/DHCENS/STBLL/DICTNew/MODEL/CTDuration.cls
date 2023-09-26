Class web.DHCENS.STBLL.DICTNew.MODEL.CTDuration Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Duration";

/// 代码
Property CTDCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Code");

/// 描述
Property CTDDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_Desc");

/// 原代码
Property CTDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_OriginalCode");

/// 原描述
Property CTDOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_OriginalDesc");

/// 代码表类型
Property CTDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTD_Status");

/// 最后更新人编码
Property CTDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_UpdateUserCode");

/// 最后更新日期
Property CTDUpdateDate As %Library.Date(XMLNAME = "CTD_UpdateDate");

/// 最后更新时间
Property CTDUpdateTime As %Library.Time(XMLNAME = "CTD_UpdateTime");

/// 创建日期
Property CTDCreatDate As %Library.Date(XMLNAME = "CTD_CreatDate");

/// 有效开始日期
Property CTDStartDate As %Library.Date(XMLNAME = "CTD_StartDate");

/// 有效结束日期
Property CTDEndDate As %Library.Date(XMLNAME = "CTD_EndDate");

/// 创建时间
Property CTDCreatTime As %Library.Time(XMLNAME = "CTD_CreatTime");

/// 备注
Property CTDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTD_Remarks");

/// 系数
Property CTDFactor As %Library.String(MAXLEN = 1000, XMLNAME = "CTD_Factor");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
