Class web.DHCENS.STBLL.DICT.MODEL.CTInstr Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Instr";

/// 代码
Property CTICode As %Library.String(MAXLEN = 20, XMLNAME = "CTI_Code");

/// 描述
Property CTIDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTI_Desc");

/// 代码表类型
Property CTICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTI_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTIStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTI_Status");

/// 最后更新人编码
Property CTIUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTI_UpdateUserCode");

/// 最后更新日期
Property CTIUpdateDate As %Library.Date(XMLNAME = "CTI_UpdateDate");

/// 最后更新时间
Property CTIUpdateTime As %Library.Time(XMLNAME = "CTI_UpdateTime");

/// 备注
Property CTIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTI_Remarks");

}
