Class DHCBILL.SelfPay.Entity.IPRegister.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg
Property ResultMsg As %String(TRUNCATE = 1);

/// EpisodeID
Property EpisodeID As %String(TRUNCATE = 1);

/// MedicareNo
Property MedicareNo As %String(TRUNCATE = 1);

/// InsuFlag
Property InsuFlag As %String(TRUNCATE = 1);

/// AdmReasonID
Property AdmReasonID As %String(TRUNCATE = 1);

/// AdmReaNationCode
Property AdmReaNationCode As %String(TRUNCATE = 1);

/// InsuExpString
Property InsuExpString As %String(TRUNCATE = 1);

}
