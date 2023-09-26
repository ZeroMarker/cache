Class web.DHCENS.STBLL.DICTNew.MODEL.CTDoseUnit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DoseUnit";

/// 代码
Property CTDUCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDU_Code");

/// 描述
Property CTDUDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDU_Desc");

/// 代码表类型
Property CTDUCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDU_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDUStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDU_Status");

/// 最后更新人编码
Property CTDUUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDU_UpdateUserCode");

/// 最后更新日期
Property CTDUUpdateDate As %Library.Date(XMLNAME = "CTDU_UpdateDate");

/// 最后更新时间
Property CTDUUpdateTime As %Library.Time(XMLNAME = "CTDU_UpdateTime");

/// 备注
Property CTDURemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDU_Remarks");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTDUOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDU_OriginalCode");

/// 原描述
Property CTDUOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDU_OriginalDesc");

/// 有效开始日期
Property CTDUStartDate As %Library.Date(XMLNAME = "CTDU_StartDate");

/// 有效结束日期
Property CTDUEndDate As %Library.Date(XMLNAME = "CTDU_EndDate");

/// 创建日期
Property CTDUCreatDate As %Library.Date(XMLNAME = "CTDU_CreatDate");

/// 创建时间
Property CTDUCreatTime As %Library.Time(XMLNAME = "CTDU_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
