Class web.DHCENS.STBLL.PIVAS.MODEL.OrdNurExeItemInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 接收科室代码
Property recLocCode As %Library.String(MAXLEN = 300, XMLNAME = "recLocCode");

/// 接收科室名称
Property recLocDesc As %Library.String(MAXLEN = 300, XMLNAME = "recLocDesc");

/// 执行记录生成时间
Property addDateTime As %Library.String(MAXLEN = 300, XMLNAME = "addDateTime");

/// 登记号
Property patNo As %Library.String(MAXLEN = 300, XMLNAME = "patNo");

/// 患者姓名
Property patName As %Library.String(MAXLEN = 300, XMLNAME = "patName");

/// 就诊Id
Property admId As %Library.String(MAXLEN = 300, XMLNAME = "admId");

/// 病区代码
Property wardLocCode As %Library.String(MAXLEN = 300, XMLNAME = "wardLocCode");

/// 病区描述
Property wardLocDesc As %Library.String(MAXLEN = 300, XMLNAME = "wardLocDesc");

/// 主执行记录
Property mainOeore As %Library.String(MAXLEN = 300, XMLNAME = "mainOeore");

/// 医嘱id
Property ordItmId As %Library.String(MAXLEN = 300, XMLNAME = "ordItmId");

/// 执行记录id
Property oeore As %Library.String(MAXLEN = 300, XMLNAME = "oeore");

/// 药品代码
Property inciCode As %Library.String(MAXLEN = 300, XMLNAME = "inciCode");

/// 药品名称
Property inciDesc As %Library.String(MAXLEN = 300, XMLNAME = "inciDesc");

/// 规格
Property spec As %Library.String(MAXLEN = 300, XMLNAME = "spec");

/// 厂家名称
Property manfName As %Library.String(MAXLEN = 300, XMLNAME = "manfName");

/// 发药数量
Property dspQty As %Library.String(MAXLEN = 300, XMLNAME = "dspQty");

/// 发药单位
Property dspUomDesc As %Library.String(MAXLEN = 300, XMLNAME = "dspUomDesc");

/// 用药时间
Property doseDateTime As %Library.String(MAXLEN = 300, XMLNAME = "doseDateTime");

/// 单价
Property price As %Library.String(MAXLEN = 300, XMLNAME = "price");

/// 主医嘱ID
Property mainOrdItmId As %Library.String(MAXLEN = 300, XMLNAME = "mainOrdItmId");

}
