Class BILL.EINV.DTO.BWA.ESearchMsgInput Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 设备编号
Property JQBH As %String(XMLPROJECTION = "ELEMENT");

/// 接口参数
Property DIRECT As %String(XMLPROJECTION = "ELEMENT");

/// 销方税号
Property NSRSBH As %String(XMLPROJECTION = "ELEMENT");

/// 内层报文
Property FPXML As %String(XMLPROJECTION = "ELEMENT");

/// 开票机器类型
Property SKType As %String(XMLPROJECTION = "ELEMENT");

}
