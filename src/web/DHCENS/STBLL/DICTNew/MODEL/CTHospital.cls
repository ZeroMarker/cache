Class web.DHCENS.STBLL.DICTNew.MODEL.CTHospital Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Hospital";

/// 代码
Property CTHCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_Code");

/// 主索引命名规则
Property CTHNationalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_NationalCode");

/// 描述
Property CTHDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTH_Desc");

/// 组织机构代码 CT_Organization.CTOCode
Property CTHOrganizationCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_OrganizationCode");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTHCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTHStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTH_Status");

/// 最后更新人编码
Property CTHUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_UpdateUserCode");

/// 最后更新日期
Property CTHUpdateDate As %Library.Date(XMLNAME = "CTH_UpdateDate");

/// 最后更新时间
Property CTHUpdateTime As %Library.Time(XMLNAME = "CTH_UpdateTime");

/// 备注
Property CTHRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTH_Remarks");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTHOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_OriginalCode");

/// 原描述
Property CTHOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTH_OriginalDesc");

/// 有效开始日期
Property CTHStartDate As %Library.Date(XMLNAME = "CTH_StartDate");

/// 有效结束日期
Property CTHEndDate As %Library.Date(XMLNAME = "CTH_EndDate");

/// 创建日期
Property CTHCreatDate As %Library.Date(XMLNAME = "CTH_CreatDate");

/// 创建时间
Property CTHCreatTime As %Library.Time(XMLNAME = "CTH_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(XMLNAME = "businessrowid");

/// 流水码
Property CTHRowId As %Library.String(XMLNAME = "CTH_RowId");

}
