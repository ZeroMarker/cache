Class BILL.EINV.DTO.HBA.PInvQueryComData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property sid As %String(CAPTION = "业务类型", XMLNAME = "sid");

Property ip As %String(CAPTION = "IP地址", XMLNAME = "ip");

Property port As %String(CAPTION = "端口", XMLNAME = "port");

Property data As BILL.EINV.DTO.HBA.PInvValidData(CAPTION = "端口", XMLNAME = "port");

}
