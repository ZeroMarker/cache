Class web.DHCENS.STBLL.DICTNew.MODEL.CTSCCarrier Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_SCCarrier";

/// 配送商代码
Property CTSCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCC_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCC_CodesystemCode");

/// 产地名称
Property CTSCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTSCC_Desc");

/// 类型
Property CTSCCType As %Library.String(MAXLEN = 50, XMLNAME = "CTSCC_Type");

/// 备注
Property CTSCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCC_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCC_Status");

/// 最后更新日期
Property CTSCCUpdateDate As %Library.Date(XMLNAME = "CTSCC_UpdateDate");

/// 最后更新时间
Property CTSCCUpdateTime As %Library.Time(XMLNAME = "CTSCC_UpdateTime");

/// 最后更新人编码
Property CTSCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCC_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTSCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCC_OriginalCode");

/// 原描述
Property CTSCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTSCC_OriginalDesc");

/// 有效开始日期
Property CTSCCStartDate As %Library.Date(XMLNAME = "CTSCC_StartDate");

/// 有效结束日期
Property CTSCCEndDate As %Library.Date(XMLNAME = "CTSCC_EndDate");

/// 创建日期
Property CTSCCCreatDate As %Library.Date(XMLNAME = "CTSCC_CreatDate");

/// 创建时间
Property CTHCreatTime As %Library.Time(XMLNAME = "CTH_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
