Class web.DHCENS.STBLL.DICTNew.MODEL.CTChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ChildCategory";

/// 代码
Property CTCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Code");

/// 描述
Property CTCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Desc");

/// 医嘱大类代码
Property CTCCCategory As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Category");

/// 代码表类型
Property CTCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCC_Status");

/// 最后更新人编码
Property CTCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_UpdateUserCode");

/// 最后更新日期
Property CTCCUpdateDate As %Library.Date(XMLNAME = "CTCC_UpdateDate");

/// 最后更新时间
Property CTCCUpdateTime As %Library.Time(XMLNAME = "CTCC_UpdateTime");

/// 备注
Property CTCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Remarks");

/// 医嘱类型
Property CTCCOrderType As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_OrderType");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_OriginalCode");

/// 原描述
Property CTCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_OriginalDesc");

/// 有效开始日期
Property CTCCStartDate As %Library.String(XMLNAME = "CTCC_StartDate");

/// 有效结束日期
Property CTCCEndDate As %Library.String(XMLNAME = "CTCC_EndDate");

/// 创建日期
Property CTCCCreatDate As %Library.Date(XMLNAME = "CTCC_CreatDate");

/// 创建时间
Property CTCCCreatTime As %Library.Time(XMLNAME = "CTCC_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
