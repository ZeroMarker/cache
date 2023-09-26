Class BILL.EINV.DTO.BSA.GetBillByBusDateReq Extends %RegisteredObject
{

Property busBgnDate As %String(CAPTION = "业务起始日期");

Property busEndDate As %String(CAPTION = "业务截止日期");

Property placeCode As %String(CAPTION = "开票点编码");

/// 数据类型-1 正常电子、2 电子红票、3 换开纸质、4 换开纸质红票、5空白纸质
Property dataType As %String(CAPTION = "数据类型");

Property pageNo As %String(CAPTION = "页码");

Property pageSize As %String(CAPTION = "每页条数");

}
