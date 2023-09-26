Class BILL.EINV.DTO.HBA.EInvReturnReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property returnCode As %String(CAPTION = "返回代码", XMLNAME = "returnCode");

Property returnMessage As %String(CAPTION = "base64返回描述", XMLNAME = "returnMessage");

}
