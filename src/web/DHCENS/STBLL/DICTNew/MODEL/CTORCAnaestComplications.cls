/// 麻醉方式
Class web.DHCENS.STBLL.DICTNew.MODEL.CTORCAnaestComplications Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ORCAnaestComplications";

Parameter XMLIGNAMEINVALIDTAG = 1;

Parameter XMLIGNAMENULL = 1;

/// 代码
Property CTORCACCode As %Library.String(MAXLEN = 50, XMLNAME = "CTORCAC_Code");

/// 代码表类型
Property CTORCACCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTORCAC_CodesystemCode");

/// 描述
Property CTORCACDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTORCAC_Desc");

/// 备注
Property CTORCACRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTORCAC_Remarks");

/// 最后更新人编码
Property CTORCACUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTORCAC_UpdateUserCode");

/// 最后更新日期
Property CTORCACUpdateDate As %Library.Date(XMLNAME = "CTORCAC_UpdateDate");

/// 最后更新时间
Property CTORCACUpdateTime As %Library.Time(XMLNAME = "CTORCAC_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTORCACCreatDate As %Library.Date(XMLNAME = "CTORCAC_CreatDate");

/// 创建时间
Property CTORCACCreatTime As %Library.Time(XMLNAME = "CTORCAC_CreatTime");

/// 原代码
Property CTORCACOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTORCAC_OriginalCode");

/// 原描述
Property CTORCACOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTORCAC_OriginalDesc");

/// 有效开始日期
Property CTORCACStartDate As %Library.Date(XMLNAME = "CTORCAC_StartDate");

/// 有效结束日期
Property CTORCACEndDate As %Library.Date(XMLNAME = "CTORCAC_EndDate");

/// 医院编号
Property CTORCACHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTORCAC_HosCode");

/// 状态（1启用0停用-1删除）
Property CTORCACStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTORCAC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
