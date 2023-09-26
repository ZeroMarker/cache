Class web.INSUOEORDTarInfoSub Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TarDetails";

//此对象节点名称,可根据实际实际情况修改

//注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

//医嘱明细ID

Property TarDr As %String(CONTENT = "收费项ID", XMLNAME = "TarRowid", XMLPROJECTION = "ELEMENT");

//收费代码

Property TARICode As %String(CONTENT = "收费代码");

//收费名称

Property TARIDesc As %String(CONTENT = "收费名称");

//医保代码

Property INSUCode As %String(CONTENT = "医保代码");

//医保名称

Property INSUDesc As %String(CONTENT = "医保名称");

//单价

Property Pricce As %String(CONTENT = "单价");

//数量

Property Qty As %String(CONTENT = "数量");

//金额

Property Amount As %String(CONTENT = "金额");

//单位

Property UOMDesc As %String(CONTENT = "单位");

}
