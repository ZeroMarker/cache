/// 患者身份字典
Class web.DHCENS.STBLL.DICTNew.MODEL.CTPatientPosition Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PatientPosition";

/// 代码
Property CTPPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_Code");

/// 描述
Property CTPPDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPP_Desc");

/// 代码表类型
Property CTPPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTPPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPP_Status");

/// 最后更新人编码
Property CTPPUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_UpdateUserCode");

/// 最后更新日期
Property CTPPUpdateDate As %Library.Date(XMLNAME = "CTPP_UpdateDate");

/// 最后更新时间
Property CTPPUpdateTime As %Library.Time(XMLNAME = "CTPP_UpdateTime");

/// 备注
Property CTPPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPP_Remarks");

/// 医院编号
Property CTPPHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_HosCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTPPOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_OriginalCode");

/// 原描述
Property CTPPOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPP_OriginalDesc");

/// 有效开始日期
Property CTPPStartDate As %Library.Date(XMLNAME = "CTPP_StartDate");

/// 有效结束日期
Property CTPPEndDate As %Library.Date(XMLNAME = "CTPP_EndDate");

/// 创建日期
Property CTPPCreatDate As %Library.Date(XMLNAME = "CTPP_CreatDate");

/// 创建时间
Property CTPPCreatTime As %Library.Time(XMLNAME = "CTPP_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
