Class web.DHCENS.STBLL.DICTNew.MODEL.CTTitleOfTech Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_TitleOfTech";

/// 代码
Property CTTTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTT_Code");

/// 描述
Property CTTTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTTT_Desc");

/// 代码表类型
Property CTTTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTT_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTTTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTTT_Status");

/// 最后更新人编码
Property CTTTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTT_UpdateUserCode");

/// 最后更新日期
Property CTTTUpdateDate As %Library.Date(XMLNAME = "CTTT_UpdateDate");

/// 最后更新时间
Property CTTTUpdateTime As %Library.Time(XMLNAME = "CTTT_UpdateTime");

/// 备注
Property CTTTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTTT_Remarks");

/// 医院编号
Property CTTTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTT_HosCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTTTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTT_OriginalCode");

/// 原描述
Property CTTTOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTTT_OriginalDesc");

/// 有效开始日期
Property CTTTStartDate As %Library.Date(XMLNAME = "CTTT_StartDate");

/// 有效结束日期
Property CTTTEndDate As %Library.Date(XMLNAME = "CTTT_EndDate");

/// 创建日期
Property CTTTCreatDate As %Library.Date(XMLNAME = "CTTT_CreatDate");

/// 创建时间
Property CTTTCreatTime As %Library.Time(XMLNAME = "CTTT_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
