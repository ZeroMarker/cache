Class BILL.EINV.DTO.BWA.DLComFPXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 发票代码	
Property FPDM As %String(XMLNAME = "FP_DM", XMLPROJECTION = "ELEMENT");

/// 发票号码
Property FPHM As %String(XMLNAME = "FP_HM", XMLPROJECTION = "ELEMENT");

/// 价税合计
Property JSHJ As %String(XMLPROJECTION = "ELEMENT");

/// 开票日期
Property KPRQ As %String(XMLPROJECTION = "ELEMENT");

}
