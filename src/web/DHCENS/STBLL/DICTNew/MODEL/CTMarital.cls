Class web.DHCENS.STBLL.DICTNew.MODEL.CTMarital Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTM_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTM_CodesystemCode");

/// 描述
Property CTMDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Desc");

/// 备注
Property CTMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTM_Status");

/// 最后更新日期
Property CTMUpdateDate As %Library.Date(XMLNAME = "CTM_UpdateDate");

/// 最后更新时间
Property CTMUpdateTime As %Library.Time(XMLNAME = "CTM_UpdateTime");

/// 最后更新人编码
Property CTMUpdateUserCode As %Library.String(MAXLEN = 500, XMLNAME = "CTM_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTM_OriginalCode");

/// 原描述
Property CTMOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTM_OriginalDesc");

/// 有效开始日期
Property CTMStartDate As %Library.Date(XMLNAME = "CTM_StartDate");

/// 有效结束日期
Property CTMEndDate As %Library.Date(XMLNAME = "CTM_EndDate");

/// 创建日期
Property CTMCreatDate As %Library.Date(XMLNAME = "CTM_CreatDate");

/// 创建时间
Property CTMCreatTime As %Library.Time(XMLNAME = "CTM_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Marital";

}
