Class web.DHCENS.STBLL.DICTNew.MODEL.CTOccupation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Occupation";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_CodesystemCode");

/// 描述
Property CTODesc As %Library.String(MAXLEN = 100, XMLNAME = "CTO_Desc");

/// 备注
Property CTORemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTO_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTO_Status");

/// 最后更新日期
Property CTOUpdateDate As %Library.Date(XMLNAME = "CTO_UpdateDate");

/// 最后更新时间
Property CTOUpdateTime As %Library.Time(XMLNAME = "CTO_UpdateTime");

/// 最后更新人编码
Property CTOUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTOOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_OriginalCode");

/// 原描述
Property CTOOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTO_OriginalDesc");

/// 有效开始日期
Property CTOStartDate As %Library.Date(XMLNAME = "CTO_StartDate");

/// 有效结束日期
Property CTOEndDate As %Library.Date(XMLNAME = "CTO_EndDate");

/// 创建日期
Property CTOCreatDate As %Library.Date(XMLNAME = "CTO_CreatDate");

/// 创建时间
Property CTOCreatTime As %Library.Time(XMLNAME = "CTO_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
