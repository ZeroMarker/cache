Class BILL.EINV.DTO.JSC.EInvalidBodyReq Extends %RegisteredObject
{

Property APPID As %String(CAPTION = "业务服务的编码", XMLNAME = "APP_ID");

Property HOSID As %String(CAPTION = "医疗机构编码", XMLNAME = "HOS_ID");

Property RCPTLIST As BILL.EINV.DTO.JSC.EInvalidDataRes(CAPTION = "票据信息");

}
