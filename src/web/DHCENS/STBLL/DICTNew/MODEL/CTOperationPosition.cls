Class web.DHCENS.STBLL.DICTNew.MODEL.CTOperationPosition Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OperationPosition";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALDTAG = 1;

/// 手术体位代码
Property CTOPCode As %String(MAXLEN = 50, XMLNAME = "CTOP_Code");

/// 手术体位名称
Property CTOPDesc As %String(MAXLEN = 100, XMLNAME = "CTOP_Desc");

/// 代码表类型
Property CTOPCodesystemCode As %String(MAXLEN = 50, XMLNAME = "CTOP_CodesystemCode");

/// 状态
Property CTOPStatus As %String(MAXLEN = 2, XMLNAME = "CTOP_Status");

/// 备注
Property CTOPRemarks As %String(MAXLEN = 100, XMLNAME = "CTOP_Remarks");

/// 最后更新日期
Property CTOPUpdateDate As %String(XMLNAME = "CTOP_UpdateDate");

/// 最后更新时间
Property CTOPUpdateTime As %String(XMLNAME = "CTOP_UpdateTime");

/// 最后更新人编码
Property CTOPUpdateUserCode As %String(MAXLEN = 50, XMLNAME = "CTOP_UpdateUserCode");

/// 原代码
Property CTOPOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOP_OriginalCode");

/// 原描述
Property CTOPOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOP_OriginalDesc");

/// 有效开始日期
Property CTOPStartDate As %Library.Date(XMLNAME = "CTOP_StartDate");

/// 有效结束日期
Property CTOPEndDate As %Library.Date(XMLNAME = "CTOP_EndDate");

/// 创建日期
Property CTOPCreatDate As %Library.Date(XMLNAME = "CTOP_CreatDate");

/// 创建时间
Property CTOPCreatTime As %Library.Time(XMLNAME = "CTOP_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
