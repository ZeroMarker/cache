Class web.DHCENS.STBLL.DICTNew.MODEL.CTCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Category";

/// 代码
Property CTCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_Code");

/// 描述
Property CTCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Desc");

/// 代码表类型
Property CTCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTC_Status");

/// 医院编号
Property CTCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCHosCode");

/// 最后更新人编码
Property CTCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_UpdateUserCode");

/// 最后更新日期
Property CTCUpdateDate As %Library.Date(XMLNAME = "CTC_UpdateDate");

/// 最后更新时间
Property CTCUpdateTime As %Library.Time(XMLNAME = "CTC_UpdateTime");

/// 备注
Property CTCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Remarks");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_OriginalCode");

/// 原描述
Property CTCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTC_OriginalDesc");

/// 有效开始日期
Property CTCStartDate As %Library.Date(XMLNAME = "CTC_StartDate");

/// 有效结束日期
Property CTCEndDate As %Library.Date(XMLNAME = "CTC_EndDate");

/// 创建日期
Property CTCCreatDate As %Library.Date(XMLNAME = "CTC_CreatDate");

/// 创建时间
Property CTCCreatTime As %Library.Time(XMLNAME = "CTC_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
