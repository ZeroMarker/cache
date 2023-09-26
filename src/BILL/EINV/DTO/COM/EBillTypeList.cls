Class BILL.EINV.DTO.COM.EBillTypeList Extends %RegisteredObject
{

Property EBillCount As %String(CAPTION = "票据种类数量");

/// 票据种类列表
Property EBillTypeList As list Of BILL.EINV.DTO.COM.EBillTypeInfo(CAPTION = "票据种类列表");

}
