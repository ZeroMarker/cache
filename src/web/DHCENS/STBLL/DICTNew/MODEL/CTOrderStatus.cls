Class web.DHCENS.STBLL.DICTNew.MODEL.CTOrderStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OrderStatus";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOSCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOS_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOS_CodesystemCode");

/// 描述
Property CTOSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOS_Desc");

/// 备注
Property CTOSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOS_Status");

/// 最后更新日期
Property CTOSUpdateDate As %Library.Date(XMLNAME = "CTOS_UpdateDate");

/// 最后更新时间
Property CTOSUpdateTime As %Library.Time(XMLNAME = "CTOS_UpdateTime");

/// 最后更新人编码
Property CTOSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOS_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTOSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOS_OriginalCode");

/// 原描述
Property CTOSOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOS_OriginalDesc");

/// 有效开始日期
Property CTOSStartDate As %Library.Date(XMLNAME = "CTOS_StartDate");

/// 有效结束日期
Property CTOSEndDate As %Library.Date(XMLNAME = "CTOS_EndDate");

/// 创建日期
Property CTOSCreatDate As %Library.Date(XMLNAME = "CTOS_CreatDate");

/// 创建时间
Property CTOSCreatTime As %Library.Time(XMLNAME = "CTOS_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
