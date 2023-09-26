Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHCGeneric Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PHCGeneric";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTPHCGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCG_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTPHCGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCG_CodesystemCode");

/// 描述
Property CTPHCGDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCG_Desc");

/// 备注
Property CTPHCGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCG_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTPHCGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHCG_Status");

/// 最后更新日期
Property CTPHCGUpdateDate As %Library.Date(XMLNAME = "CTPHCG_UpdateDate");

/// 最后更新时间
Property CTPHCGUpdateTime As %Library.Time(XMLNAME = "CTPHCG_UpdateTime");

/// 最后更新人编码
Property CTPHCGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCG_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTPHCGCreatDate As %Library.Date(XMLNAME = "CTPHCG_CreatDate");

/// 创建时间
Property CTPHCGCreatTime As %Library.Time(XMLNAME = "CTPHCG_CreatTime");

/// 原代码
Property CTPHCGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCG_OriginalCode");

/// 原描述
Property CTPHCGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPHCG_OriginalDesc");

/// 有效开始日期
Property CTPHCGStartDate As %Library.Date(XMLNAME = "CTPHCG_StartDate");

/// 有效结束日期
Property CTPHCGEndDate As %Library.Date(XMLNAME = "CTPHCG_EndDate");

/// 医院代码
Property CTPHCGHosCode As %Library.String(XMLNAME = "CTPHCG_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
