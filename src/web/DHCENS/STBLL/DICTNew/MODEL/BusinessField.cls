Class web.DHCENS.STBLL.DICTNew.MODEL.BusinessField Extends (%RegisteredObject, %XML.Adaptor)
{

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 10, XMLNAME = "BusinessFieldCode") [ InitialExpression = "00001" ];

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
