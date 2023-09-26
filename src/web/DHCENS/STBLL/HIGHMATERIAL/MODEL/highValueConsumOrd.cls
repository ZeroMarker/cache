Class web.DHCENS.STBLL.HIGHMATERIAL.MODEL.highValueConsumOrd Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetHighValueConsumOrdCode";

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 100, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 100, XMLNAME = "PAADMVisitNumber");

/// 患者姓名
Property PATName As %Library.String(MAXLEN = 100, XMLNAME = "PATName");

/// 患者类型
Property PATType As %Library.String(MAXLEN = 100, XMLNAME = "PATType");

/// 就诊科室代码
Property PATDeptCode As %Library.String(MAXLEN = 100, XMLNAME = "PATDeptCode");

/// 就诊科室描述
Property PATDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "PATDeptDesc");

/// 患者所在病区代码
Property PATWardCode As %Library.String(MAXLEN = 100, XMLNAME = "PATWardCode");

/// 患者所在病区描述
Property PATWardDesc As %Library.String(MAXLEN = 100, XMLNAME = "PATWardDesc");

/// 患者病房
Property PATRoom As %Library.String(MAXLEN = 100, XMLNAME = "PATRoom");

/// 患者病床
Property PATBed As %Library.String(MAXLEN = 100, XMLNAME = "PATBed");

Property OEORIInfos As list Of web.DHCENS.STBLL.HIGHMATERIAL.MODEL.OEORIInfo(XMLNAME = "OEORIInfo", XMLPROJECTION = "ELEMENT");

}
