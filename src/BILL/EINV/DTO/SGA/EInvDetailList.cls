/// 明细信息
Class BILL.EINV.DTO.SGA.EInvDetailList Extends %RegisteredObject
{

Property itemName As %String(CAPTION = "项目名称");

/// 项目编码(分组合计时：***)(住院票据可以使用收费类别)
Property itemCode As %String(CAPTION = "项目编码");

Property itemAmount As %String(CAPTION = "项目金额");

Property itemUnit As %String(CAPTION = "项目单位");

/// 药品分类编码01，有则填写
Property itemQuantity As %String(CAPTION = "项目数量");

Property itemStd As %String(CAPTION = "项目标准（规格）");

Property itemType As %String(CAPTION = "项目种类");

Property itemAmountSelf As %String(CAPTION = "自费金额");

Property itemAmountPercent As %String(CAPTION = "自费比例");

Property specification As %String(CAPTION = "收费类别");

Property itemPrice As %String(CAPTION = "项目单价");

Property itemGrp As %String(CAPTION = "明细分组标识");

}
