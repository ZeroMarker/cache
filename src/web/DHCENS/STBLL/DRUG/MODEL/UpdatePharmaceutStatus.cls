Class web.DHCENS.STBLL.DRUG.MODEL.UpdatePharmaceutStatus Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "UpdatePharmaceutStatus";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 药房ID
Property pharmacyid As %String(MAXLEN = 30, TRUNCATE = 1);

/// 患者编号
Property patientid As %String(MAXLEN = 30, TRUNCATE = 1);

/// 处方号
Property presno As %String(MAXLEN = 30, TRUNCATE = 1);

/// 窗口号
Property winno As %String(MAXLEN = 30, TRUNCATE = 1);

/// 时间
Property datetime As %String(MAXLEN = 30, TRUNCATE = 1);

/// 操作人员代码
Property UserCode As %String(TRUNCATE = 1);

/// 消息ID
Property MessageID As %String(MAXLEN = 30, TRUNCATE = 1);

Property OrugOrdStatus As list Of web.DHCENS.STBLL.DRUG.MODEL.UpdateOPDrugStatus(XMLNAME = "UpdateOPDrugStatus", XMLPROJECTION = "ELEMENT");

}
