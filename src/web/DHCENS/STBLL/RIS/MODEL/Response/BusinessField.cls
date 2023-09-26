Class web.DHCENS.STBLL.RIS.MODEL.Response.BusinessField Extends %RegisteredObject
{

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 10, XMLNAME = "BusinessFieldCode") [ InitialExpression = "00001" ];

/// 院区
Property HospitalCode As %Library.String(MAXLEN = 50, XMLNAME = "HospitalCode");

}
