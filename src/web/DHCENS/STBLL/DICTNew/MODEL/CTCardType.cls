/// 卡类型表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTCardType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_CardType";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTCTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_Code");

/// 代码表类型
Property CTCTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_CodesystemCode");

/// 描述
Property CTCTDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCT_Desc");

/// 备注
Property CTCTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCT_Remarks");

/// 最后更新人编码
Property CTCTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_UpdateUserCode");

/// 最后更新日期
Property CTCTUpdateDate As %Library.String(XMLNAME = "CTCT_UpdateDate");

/// 最后更新时间
Property CTCTUpdateTime As %Library.String(XMLNAME = "CTCT_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTCTCreatDate As %Library.Date(XMLNAME = "CTCT_CreatDate");

/// 创建时间
Property CTCTCreatTime As %Library.Time(XMLNAME = "CTCT_CreatTime");

/// 原代码
Property CTCTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_OriginalCode");

/// 原描述
Property CTCTOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCT_OriginalDesc");

/// 有效开始日期
Property CTCTStartDate As %Library.Date(XMLNAME = "CTCT_StartDate");

/// 有效结束日期
Property CTCTEndDate As %Library.Date(XMLNAME = "CTCT_EndDate");

/// 医院编号
Property CTCTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_HosCode");

/// 状态（1启用0停用-1删除）
Property CTCTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
