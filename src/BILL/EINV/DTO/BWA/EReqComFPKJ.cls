/// 电子票据 发票开具节点定义
Class BILL.EINV.DTO.BWA.EReqComFPKJ Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票金额的概要总括信息
Property ComFPKJFPT As BILL.EINV.DTO.BWA.EComFPKJFPT(XMLNAME = "COMMON_FPKJ_FPT", XMLPROJECTION = "ELEMENT");

/// 项目明细信息
Property ComFPKJXMMXS As BILL.EINV.DTO.BWA.EComFPKJXMXXS(XMLNAME = "COMMON_FPKJ_XMXXS", XMLPROJECTION = "ELEMENT");

}
