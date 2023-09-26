/// 电子票据外部报文Input节点定义
Class BILL.EINV.DTO.BWA.EMsgInput Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 设备编号
Property JQBH As %String(XMLPROJECTION = "ELEMENT");

/// 接口参数
Property DIRECT As %String(XMLPROJECTION = "ELEMENT");

/// 销售方联系方式
Property XSFLXFS As %String(MAXLEN = 100, XMLNAME = "XSF_LXFS", XMLPROJECTION = "ELEMENT");

/// 购买方联系方式
Property GMFLXFS As %String(MAXLEN = 100, XMLNAME = "GMF_LXFS", XMLPROJECTION = "ELEMENT");

/// 内层报文
Property FPXML As %String(MAXLEN = 1000, XMLPROJECTION = "ELEMENT");

/// 开票机器类型
Property SKType As %String(XMLPROJECTION = "ELEMENT");

/// 业务类型
Property BussinessID As %String(XMLPROJECTION = "ELEMENT");

}
