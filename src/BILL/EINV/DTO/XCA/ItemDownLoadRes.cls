/// 7.1.1 项目信息下载响应对象
Class BILL.EINV.DTO.XCA.ItemDownLoadRes Extends %RegisteredObject
{

Property IvcAgcCode As %String(CAPTION = "单位编码");

Property RegionCode As %String(CAPTION = "财政区划编码");

Property Items As list Of BILL.EINV.DTO.XCA.ItemList(CAPTION = "项目列表");

}
