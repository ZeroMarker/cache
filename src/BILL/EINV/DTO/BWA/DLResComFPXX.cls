/// 发票下载明细信息
Class BILL.EINV.DTO.BWA.DLResComFPXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 发票状态
Property FPZT As %String(XMLPROJECTION = "ELEMENT");

/// 发票代码	
Property FPDM As %String(XMLNAME = "FP_DM", XMLPROJECTION = "ELEMENT");

/// 发票号码
Property FPHM As %String(XMLNAME = "FP_HM", XMLPROJECTION = "ELEMENT");

/// 价税合计
Property JSHJ As %String(XMLPROJECTION = "ELEMENT");

/// 开票日期
Property KPRQ As %String(XMLPROJECTION = "ELEMENT");

/// 发票下载地址
Property FPURL As %String(MAXLEN = 1000, XMLNAME = "FP_URL", XMLPROJECTION = "ELEMENT");

}
