Class CIS.AN.DTO.ENS.Decode.Body Extends (CIS.AN.DTO.Abstract.Response, %XML.Adaptor)
{

Parameter XMLTYPE = "Body";

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String;

Property ResultContent As %String;

}
