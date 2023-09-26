/// 发票打印参数
Class BILL.EINV.DTO.HBA.PInvPrintService Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "service";

Property sid As %String(CAPTION = "功能类别", XMLNAME = "sid");

Property ip As %String(CAPTION = "IP地址", XMLNAME = "ip");

Property port As %String(CAPTION = "端口", XMLNAME = "port");

Property data As BILL.EINV.DTO.HBA.PInvPrintData(CAPTION = "开票数据", XMLNAME = "data");

}
