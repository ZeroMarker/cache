Class web.DHCENS.STBLL.DICT.MODEL.CTHospital Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Hospital";

/// 代码
Property CTHCode As %Library.String(MAXLEN = 10, XMLNAME = "CTH_Code");

/// 描述
Property CTHDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTH_Desc");

/// 组织机构代码 CT_Organization.CTOCode
Property CTHOrganizationCode As %Library.String(MAXLEN = 10, XMLNAME = "CTH_OrganizationCode");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTHCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTH_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTHStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTH_Status");

/// 最后更新人编码
Property CTHUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTH_UpdateUserCode");

/// 最后更新日期
Property CTHUpdateDate As %Library.Date(XMLNAME = "CTH_UpdateDate");

/// 最后更新时间
Property CTHUpdateTime As %Library.Time(XMLNAME = "CTH_UpdateTime");

/// 备注
Property CTHRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTH_Remarks");

}
