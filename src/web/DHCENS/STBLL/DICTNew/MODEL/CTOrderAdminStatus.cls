Class web.DHCENS.STBLL.DICTNew.MODEL.CTOrderAdminStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OrderAdminStatus";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOASCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOAS_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOASCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOAS_CodesystemCode");

/// 描述
Property CTOASDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOAS_Desc");

/// 备注
Property CTOASRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOAS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOASStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOAS_Status");

/// 最后更新日期
Property CTOASUpdateDate As %Library.Date(XMLNAME = "CTOAS_UpdateDate");

/// 最后更新时间
Property CTOASUpdateTime As %Library.Time(XMLNAME = "CTOAS_UpdateTime");

/// 最后更新人编码
Property CTOASUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOAS_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTOASOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOAS_OriginalCode");

/// 原描述
Property CTOASOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOAS_OriginalDesc");

/// 有效开始日期
Property CTOASStartDate As %Library.Date(XMLNAME = "CTOAS_StartDate");

/// 有效结束日期
Property CTOASEndDate As %Library.Date(XMLNAME = "CTOAS_EndDate");

/// 创建日期
Property CTOASCreatDate As %Library.Date(XMLNAME = "CTOAS_CreatDate");

/// 创建时间
Property CTOASCreatTime As %Library.Time(XMLNAME = "CTOAS_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
