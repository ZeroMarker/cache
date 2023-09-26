Class BILL.EINV.DTO.AXNHTA.OPInvoiceRecordHead Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 票据信息  
Property machinetaxnr As %String(CAPTION = "指定的开票机税号");

Property machinenr As %String(CAPTION = "指定的开票机号");

/// 0-专用发票、2 –普通发票、11-货运发票、41-卷票普通发票、51-电子普通发票
Property invkind As BILL.EINV.DTO.AXNHTA.OPInvoiceKind;

/// 1 -正常单据、2 -红冲单据、3 -折扣单据
Property doctype As BILL.EINV.DTO.AXNHTA.OPInvoiceDocType;

/// (确保单据号的唯一性)
Property docnr As %String(CAPTION = "业务系统单据号");

Property docdate As %String(CAPTION = "业务系统单据日期");

/// (可以为空,发票上不体现)
Property custnr As %String(CAPTION = "客户编号");

Property custname As %String(CAPTION = "客户名称");

/// （invkind=2/41/51时可以为空）
Property custtaxnr As %String(CAPTION = "客户税号");

/// （invkind=2/41/51时可以为空）
Property custaddrtel As %String(CAPTION = "客户地址电话");

/// （invkind=2/41/51时可以为空）
Property custbankacct As %String(CAPTION = "客户银行及帐号");

/// （可以为空，打印在发票备注位置）
Property memo As %String(CAPTION = "备注");

/// (不用于开票,发票上不体现)
Property memo2 As %String(CAPTION = "业务备注");

/// （仅用于invkind=2/41/51在开具红冲发票时需要）
Property refinvcode As %String(CAPTION = "对应正数发票代码");

/// （仅用于invkind=2/41/51在开具红冲发票时需要）
Property refinvnr As %String(CAPTION = "普通发票红票对应正数发票号码");

/// （仅用于invkind=0在开具红冲发票时需要）
Property rednoticenr As %String(CAPTION = "专用发票红票通知单号");

/// （如果为空，会调用客户端默认设置）
Property issuer As %String(CAPTION = "开票人");

/// （如果为空，会调用客户端默认设置）
Property checker As %String(CAPTION = "复核人");

/// （如果为空，会调用客户端默认设置）
Property payee As %String(CAPTION = "收款人");

/// （如果为空，会调用客户端默认设置）
Property sellerbankacct As %String(CAPTION = "销方银行及帐号");

/// （如果为空，会调用客户端默认设置）
Property selleraddresstel As %String(CAPTION = "销方地址电话");

/// (货运发票专属字段，invkind=11使用)
Property consignerName As %String(CAPTION = "收货人");

/// (货运发票专属字段，invkind=11使用)
Property consignerTaxNr As %String(CAPTION = "收货人纳税人识别号");

/// (货运发票专属字段，invkind=11情况使用)
Property shipperName As %String(CAPTION = "发货人");

/// (货运发票专属字段，invkind=11情况使用)
Property shipperTaxNr As %String(CAPTION = "发货人纳税人识别号");

/// 货运发票专属字段，invkind=11情况使用
Property originViaArrivalPlace As %String(CAPTION = "起运地经由到达地");

/// 货运发票专属字段，invkind=11情况使用
Property vehicleKindNo As %String(CAPTION = "车种车号");

/// vehicleTonnage 货运发票专属字段，invkind=11情况使用
Property vehicleTonnage As %String(CAPTION = "货运发票专属字段，invkind=11情况使用");

/// 货运发票专属字段，invkind=11情况使用
Property freightMemo As %String(CAPTION = "运输货物信息");

/// 仅在开具差额征收发票时使用
Property taxdeduction As %String(CAPTION = "扣除额");

Property listName As %String(CAPTION = "详见销货清单");

Property emails As %String(CAPTION = "电子发票发送邮件地址");

Storage Default
{
<Data name="OPInvoiceRecordHeadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV2530.OPInvoiceRe54CED</DataLocation>
<DefaultData>OPInvoiceRecordHeadDefaultData</DefaultData>
<IdLocation>^BILL.EINV2530.OPInvoiceRe54CED</IdLocation>
<IndexLocation>^BILL.EINV2530.OPInvoiceRe54CEI</IndexLocation>
<StreamLocation>^BILL.EINV2530.OPInvoiceRe54CES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
