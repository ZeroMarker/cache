Class web.DHCENS.STBLL.DICT.MODEL.CTTarItem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ChargeItem";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 收费子类代码
Property CTCIChargeChildCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_ChargeChildCode");

/// 收费项目代码
Property CTCICode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_Code");

/// 收费项目描述
Property CTCIDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCI_Desc");

/// 代码表类型
Property CTCICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCI_CodesystemCode");

/// 备注
Property CTCIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCI_Remarks");

/// 状态
Property CTCIStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCI_Status");

/// 最后更新人编码
Property CTCIUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTCI_UpdateUserCode");

/// 最后更新日期
Property CTCIUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCI_UpdateDate");

/// 最后更新时间
Property CTCIUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTCI_UpdateTime");

}
