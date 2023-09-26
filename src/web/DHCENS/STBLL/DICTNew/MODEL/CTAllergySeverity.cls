Class web.DHCENS.STBLL.DICTNew.MODEL.CTAllergySeverity Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_AllergySeverity";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTASCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_Code");

/// 代码表类型
Property CTASCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_CodesystemCode");

/// 描述
Property CTASDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAS_Desc");

/// 备注
Property CTASRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTASStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAS_Status");

/// 最后更新日期
Property CTASUpdateDate As %Library.Date(XMLNAME = "CTAS_UpdateDate");

/// 最后更新时间
Property CTASUpdateTime As %Library.Time(XMLNAME = "CTAS_UpdateTime");

/// 最后更新人编码
Property CTASUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_UpdateUserCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
