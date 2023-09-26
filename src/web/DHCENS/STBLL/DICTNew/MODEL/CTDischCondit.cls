Class web.DHCENS.STBLL.DICTNew.MODEL.CTDischCondit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTDCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_Code");

/// 代码表类型
Property CTDCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_CodesystemCode");

/// 描述
Property CTDCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_Desc");

/// 备注
Property CTDCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_Remarks");

/// 状态（1启用0停用-1删除）
Property CTDCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDC_Status");

/// 最后更新日期
Property CTDCUpdateDate As %Library.Date(XMLNAME = "CTDC_UpdateDate");

/// 最后更新时间
Property CTDCUpdateTime As %Library.Time(XMLNAME = "CTDC_UpdateTime");

/// 最后更新人编码
Property CTDCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTDCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_OriginalCode");

/// 原描述
Property CTDCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_OriginalDesc");

/// 有效开始日期
Property CTDCStartDate As %Library.Date(XMLNAME = "CTDC_StartDate");

/// 有效结束日期
Property CTDCEndDate As %Library.Date(XMLNAME = "CTDC_EndDate");

/// 创建日期
Property CTDCCreatDate As %Library.Date(XMLNAME = "CTDC_CreatDate");

/// 创建时间
Property CTDCCreatTime As %Library.Time(XMLNAME = "CTDC_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLNAME = "CT_DischCondit";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

}
