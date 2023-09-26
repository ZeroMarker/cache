Class web.DHCENS.STBLL.CDRJSONV2.RIS.Model.BusinessField Extends (%RegisteredObject, %XML.Adaptor)
{

/// 业务域
Property businessfieldcode As %Library.String(MAXLEN = 10, XMLNAME = "businessfieldcode") [ InitialExpression = "00001" ];

/// 请求参数
Property requestparamter As %Library.String(MAXLEN = 10, XMLNAME = "requestparamter");

/// 有效标志(是否删除)
Property validsign As %Library.String(MAXLEN = 10, XMLNAME = "validsign");

/// 删除依据
Property deletebasis As %Library.String(MAXLEN = 10, XMLNAME = "deletebasis");

}
