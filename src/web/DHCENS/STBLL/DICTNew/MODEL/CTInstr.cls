Class web.DHCENS.STBLL.DICTNew.MODEL.CTInstr Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Instr";

/// 代码
Property CTICode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_Code");

/// 描述
Property CTIDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTI_Desc");

/// 原代码
Property CTIOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_OriginalCode");

/// 原描述
Property CTIOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTI_OriginalDesc");

/// 代码表类型
Property CTICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTIStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTI_Status");

/// 最后更新人编码
Property CTIUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_UpdateUserCode");

/// 创建日期
Property CTICreatDate As %Library.Date(XMLNAME = "CTI_CreatDate");

/// 创建时间
Property CTICreatTime As %Library.Time(XMLNAME = "CTI_CreatTime");

/// 有效开始日期
Property CTIStartDate As %Library.Date(XMLNAME = "CTI_StartDate");

/// 有效结束日期
Property CTIEndDate As %Library.Date(XMLNAME = "CTI_EndDate");

/// 最后更新日期
Property CTIUpdateDate As %Library.Date(XMLNAME = "CTI_UpdateDate");

/// 最后更新时间
Property CTIUpdateTime As %Library.Time(XMLNAME = "CTI_UpdateTime");

/// 备注
Property CTIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTI_Remarks");

/// 医院代码
Property CTIHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_HosCode");

/// 英文描述
Property CTIEngDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTI_EngDesc");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
