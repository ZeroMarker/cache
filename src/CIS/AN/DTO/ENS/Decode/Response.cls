Class CIS.AN.DTO.ENS.Decode.Response Extends (CIS.AN.DTO.Abstract.Response, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Header As CIS.AN.DTO.ENS.Response.Header;

Property Body As CIS.AN.DTO.ENS.Decode.Body;

}
