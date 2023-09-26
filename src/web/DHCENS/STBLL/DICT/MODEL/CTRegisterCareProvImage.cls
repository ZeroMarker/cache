Class web.DHCENS.STBLL.DICT.MODEL.CTRegisterCareProvImage Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RegisterCareProvImageRt";

/// 医护人员RowId
Property CTCPRowId As %Library.String(MAXLEN = 50, XMLNAME = "CTCP_RowId");

/// 医护人员
Property CTCPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCP_Code");

/// 图片信息
Property ImageContent As %Library.GlobalCharacterStream(XMLNAME = "ImageContent");

}
