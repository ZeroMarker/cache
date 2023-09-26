Class web.DHCENS.STBLL.DICT.MODEL.CTBodyArea Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_BodyArea";

/// 代码
Property CTBACode As %Library.String(MAXLEN = 50, XMLNAME = "CTBA_Code");

/// 代码表类型
Property CTBACodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_CodesystemCode");

/// 名称
Property CTBADesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_Desc");

/// 备注
Property CTBARemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTBA_Remarks");

/// 状态（1启用0停用-1删除）
Property CTBAStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTBA_Status");

/// 最后更新日期
Property CTBAUpdateDate As %Library.String(XMLNAME = "CTBA_UpdateDate");

/// 最后更新时间
Property CTBAUpdateTime As %Library.String(XMLNAME = "CTBA_UpdateTime");

/// 最后更新人编码
Property CTBAUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBA_UpdateUserCode");

}
