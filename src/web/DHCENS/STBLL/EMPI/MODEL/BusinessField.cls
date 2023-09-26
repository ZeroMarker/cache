Class web.DHCENS.STBLL.EMPI.MODEL.BusinessField Extends %RegisteredObject
{

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 10, XMLNAME = "BusinessFieldCode") [ InitialExpression = "00002" ];

/// 院区
Property HospitalCode As %Library.String(MAXLEN = 20, XMLNAME = "HospitalCode");

}
