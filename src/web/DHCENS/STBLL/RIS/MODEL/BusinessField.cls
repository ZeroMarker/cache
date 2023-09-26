Class web.DHCENS.STBLL.RIS.MODEL.BusinessField Extends %RegisteredObject
{

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 10, XMLNAME = "BusinessFieldCode") [ InitialExpression = "00001" ];

/// 院区
Property HospitalCode As %Library.String(MAXLEN = 20, XMLNAME = "HospitalCode");

}
