Class BILL.EINV.DTO.HBA.PInvStockComData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "service";

Property sid As %String(CAPTION = "业务类型", XMLNAME = "sid");

Property ip As %String(CAPTION = "IP地址", XMLNAME = "ip");

Property port As %String(CAPTION = "端口", XMLNAME = "port");

Property data As BILL.EINV.DTO.HBA.PInvStockData(CAPTION = "端口", XMLNAME = "data");

}
