Class BILL.EINV.DTO.BSB.EInvoiceMessageRes Extends %RegisteredObject
{

/// 当 result 返回结果为成功时，message 可能会包含接收失败的详情列表，列表中的数据需要处理后重新请求开
/// failList	接收失败详情列表	json	不限	否	票。
Property failList As list Of BILL.EINV.DTO.BSB.EInvoiceMessagefailListRes;

}
