Class web.DHCENS.STBLL.DICTNew.MODEL.CTCutType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_CutType";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTCTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_Code");

/// 代码表类型
Property CTCTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_CodesystemCode");

/// 描述
Property CTCTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCT_Desc");

/// 备注
Property CTCTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCT_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTCTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCT_Status");

/// 最后更新日期
Property CTCTUpdateDate As %Library.Date(XMLNAME = "CTCT_UpdateDate");

/// 最后更新时间
Property CTCTUpdateTime As %Library.Time(XMLNAME = "CTCT_UpdateTime");

/// 最后更新人编码
Property CTCTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCT_UpdateUserCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
