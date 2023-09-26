Class web.DHCENS.STBLL.DICTNew.MODEL.CTResultStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ResultStatus";

/// 代码
Property CTRSCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRS_Code");

/// 描述
Property CTRSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTRS_Desc");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTRSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRS_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTRSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRS_Status");

/// 最后更新人编码
Property CTRSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRS_UpdateUserCode");

/// 最后更新日期
Property CTRSUpdateDate As %Library.Date(XMLNAME = "CTRS_UpdateDate");

/// 最后更新时间
Property CTRSUpdateTime As %Library.Time(XMLNAME = "CTRS_UpdateTime");

/// 备注
Property CTRSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRS_Remarks");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTRSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRS_OriginalCode");

/// 原描述
Property CTRSOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTRS_OriginalDesc");

/// 有效开始日期
Property CTRSStartDate As %Library.Date(XMLNAME = "CTRS_StartDate");

/// 有效结束日期
Property CTRSEndDate As %Library.Date(XMLNAME = "CTRS_EndDate");

/// 创建日期
Property CTRSCreatDate As %Library.Date(XMLNAME = "CTRS_CreatDate");

/// 创建时间
Property CTRSCreatTime As %Library.Time(XMLNAME = "CTRS_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
