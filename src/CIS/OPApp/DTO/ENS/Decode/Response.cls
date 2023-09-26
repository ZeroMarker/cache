Class CIS.OPApp.DTO.ENS.Decode.Response Extends (CIS.OPApp.DTO.Abstract.Response, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Header As CIS.OPApp.DTO.ENS.Response.Header;

Property Body As CIS.OPApp.DTO.ENS.Decode.Body;

}
