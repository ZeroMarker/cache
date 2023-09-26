Class BILL.EINV.DTO.BWA.EResComFPKJ Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

/// 发票请求流水号	
Property FPQQLSH As %String(XMLNAME = "FPQQLSH", XMLPROJECTION = "ELEMENT");

/// 税控设备编号	
Property JQBH As %String(XMLNAME = "JQBH", XMLPROJECTION = "ELEMENT");

/// 发票代码	
Property FPDM As %String(XMLNAME = "FP_DM", XMLPROJECTION = "ELEMENT");

/// 发票号码	
Property FPHM As %String(XMLNAME = "FP_HM", XMLPROJECTION = "ELEMENT");

/// 开票日期	
Property KPRQ As %String(XMLNAME = "KPRQ", XMLPROJECTION = "ELEMENT");

/// 发票密文	
Property FPMW As %String(XMLNAME = "FP_MW", XMLPROJECTION = "ELEMENT");

/// 发票校验码	
Property JYM As %String(XMLNAME = "JYM", XMLPROJECTION = "ELEMENT");

/// 二维码	
Property EWM As %String(MAXLEN = 1000, XMLNAME = "EWM", XMLPROJECTION = "ELEMENT");

/// 备注	
Property BZ As %String(MAXLEN = 200, XMLNAME = "BZ", XMLPROJECTION = "ELEMENT");

/// 返回代码
Property RETURNCODE As %String(MAXLEN = 200, XMLNAME = "RETURNCODE", XMLPROJECTION = "ELEMENT");

/// 返回信息
Property RETURNMSG As %String(MAXLEN = 200, XMLNAME = "RETURNMSG", XMLPROJECTION = "ELEMENT");

}
