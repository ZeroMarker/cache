Class web.DHCENS.STBLL.DICTNew.MODEL.CTSCOrigin Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_SCOrigin";

/// 产地代码
Property CTSCOCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCOCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_CodesystemCode");

/// 产地名称
Property CTSCODesc As %Library.String(MAXLEN = 100, XMLNAME = "CTSCO_Desc");

/// 别名
Property CTSCOAlias As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_Alias");

/// 类型
Property CTSCOType As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_Type");

/// 备注
Property CTSCORemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCO_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSCOStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCO_Status");

/// 最后更新日期
Property CTSCOUpdateDate As %Library.Date(XMLNAME = "CTSCO_UpdateDate");

/// 最后更新时间
Property CTSCOUpdateTime As %Library.Time(XMLNAME = "CTSCO_UpdateTime");

/// 最后更新人编码
Property CTSCOUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTSCOOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCO_OriginalCode");

/// 原描述
Property CTSCOOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTSCO_OriginalDesc");

/// 有效开始日期
Property CTSCOStartDate As %Library.Date(XMLNAME = "CTSCO_StartDate");

/// 有效结束日期
Property CTSCOEndDate As %Library.Date(XMLNAME = "CTSCO_EndDate");

/// 创建日期
Property CTSCOCreatDate As %Library.Date(XMLNAME = "CTSCO_CreatDate");

/// 创建时间
Property CTSCOCreatTime As %Library.Time(XMLNAME = "CTSCO_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
