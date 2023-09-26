Class BILL.EINV.DTO.COM.InvBuyApplyCtl Extends %RegisteredObject
{

Property RowId As %Date(CAPTION = "购入申请表ID");

Property IBAUsr As %String(CAPTION = "申请人");

Property IBABusNo As %String(CAPTION = "申请唯一流水号");

Property IBATypeCode As %String(CAPTION = "电子票据种类代码");

Property IBATypeName As %String(CAPTION = "电子票据种类名称");

Property IBATypeCount As %String(CAPTION = "电子票据种类数量");

/// 申请标志 Y:申请成功，N:申请失败   //取消掉  在后边的状态标志中加一个 已申请 状态
Property IBAApplyFlag As %String(CAPTION = "电子票据申请标志");

Property IBAResultCode As %String(CAPTION = "返回申请结果代码");

Property IBAResultMeg As %String(CAPTION = "返回申请结果描述");

Property IBAApplyNo As %String(CAPTION = "申请单号");

Property IBAInvoiceCode As %String(CAPTION = "电子票据代码");

Property IBAInvoiceName As %String(CAPTION = "电子票据名称");

/// 申请状态 (0:所有类型,1:已审核,2:未审核,3.作废)     修改为我们东华自己的状态标志 0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
Property IBAApplyStatus As %String(CAPTION = "申请状态");

Property IBAApplyCount As %String(CAPTION = "返回申请单数量");

Property IBAApplyList As %String(CAPTION = "返回申请单列表");

Property IBAApplyDate As %Date(CAPTION = "申请成功日期");

Property IBAApplyTime As %Time(CAPTION = "申请成功时间");

Property IBAStartNo As %Date(CAPTION = "票据开始号码");

Property IBAEndNo As %Time(CAPTION = "票据结束号码");

/// IBAStockStatus  (1.待入库,2.已入库,9.已撤销)  不知道含义，需要了解下是什么含义？？？？？？？？？？？？？？？
Property IBAStockStatus As %String(CAPTION = "票据库存状态");

Property StockDate As %Date(CAPTION = "入库日期");

Property StockTime As %Time(CAPTION = "入库时间");

Property ApplyCommon As %String(CAPTION = "申请备注", MAXLEN = 500);

Property UpdateDate As %Date(CAPTION = "最近一次更新日期");

Property UpdateTime As %Time(CAPTION = "最近一次更新时间");

}
