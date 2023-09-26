Class BILL.EINV.DTO.TBTCA.PaperBillNoInitReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 窗口类型(mzpj门诊票据、zypj 住院票据、zzpj 自助票据、zcpj 诊查票据 zyyjj 住院预交金、zyzz 住 院自助)
Property BillType As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据编码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 票据名称
Property BillName As %String(XMLPROJECTION = "ELEMENT");

/// 开始号码
Property StartBillNo As %String(XMLPROJECTION = "ELEMENT");

/// 数量
Property Quantity As %String(XMLPROJECTION = "ELEMENT");

/// 结束号码
Property EndBillNo As %String(XMLPROJECTION = "ELEMENT");

/// 当前号码
Property CurrentBillNo As %String(XMLPROJECTION = "ELEMENT");

}
