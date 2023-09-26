Class web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnoseType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DiagnoseType";

/// 代码
Property CTDTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDT_Code");

/// 描述
Property CTDTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDT_Desc");

/// 代码表类型
Property CTDTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDT_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDT_Status");

/// 最后更新人编码
Property CTDTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDT_UpdateUserCode");

/// 最后更新日期
Property CTDTUpdateDate As %Library.Date(XMLNAME = "CTDT_UpdateDate");

/// 最后更新时间
Property CTDTUpdateTime As %Library.Time(XMLNAME = "CTDT_UpdateTime");

/// 备注
Property CTDTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDT_Remarks");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTDTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDT_OriginalCode");

/// 原描述
Property CTDTOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDT_OriginalDesc");

/// 有效开始日期
Property CTDTStartDate As %Library.Date(XMLNAME = "CTDT_StartDate");

/// 有效结束日期
Property CTDTEndDate As %Library.Date(XMLNAME = "CTDT_EndDate");

/// 创建日期
Property CTDTCreatDate As %Library.Date(XMLNAME = "CTDT_CreatDate");

/// 创建时间
Property CTDTCreatTime As %Library.Time(XMLNAME = "CTDT_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
