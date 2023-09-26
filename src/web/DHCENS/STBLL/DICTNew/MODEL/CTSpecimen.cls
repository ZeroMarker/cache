Class web.DHCENS.STBLL.DICTNew.MODEL.CTSpecimen Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Specimen";

/// 标本代码
Property CTSCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_CodesystemCode");

/// 标本名称
Property CTSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTS_Desc");

/// 备注
Property CTSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTS_Status");

/// 最后更新日期
Property CTSUpdateDate As %Library.Date(XMLNAME = "CTS_UpdateDate");

/// 最后更新时间
Property CTSUpdateTime As %Library.Time(XMLNAME = "CTS_UpdateTime");

/// 最后更新人编码
Property CTSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_OriginalCode");

/// 原描述
Property CTSOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTS_OriginalDesc");

/// 有效开始日期
Property CTSStartDate As %Library.Date(XMLNAME = "CTS_StartDate");

/// 有效结束日期
Property CTSEndDate As %Library.Date(XMLNAME = "CTS_EndDate");

/// 创建日期
Property CTSCreatDate As %Library.Date(XMLNAME = "CTS_CreatDate");

/// 创建时间
Property CTSCreatTime As %Library.Time(XMLNAME = "CTS_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
