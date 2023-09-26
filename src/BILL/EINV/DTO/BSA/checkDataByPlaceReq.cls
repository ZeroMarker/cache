/// 4.6.2.2	开票点数据核对接口
Class BILL.EINV.DTO.BSA.checkDataByPlaceReq Extends %RegisteredObject
{

Property busDate As %String(CAPTION = "业务日期");

Property placeCode As %String(CAPTION = "开票点编码");

Property isReturnList As %String(CAPTION = "是否返回列表");

Property pageNo As %String(CAPTION = "页码");

Property pageSize As %String(CAPTION = "每页条数");

Property busType As %String(CAPTION = "业务标识");

}
