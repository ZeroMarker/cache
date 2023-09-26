Class DHCExternalService.BillInterface.DHCEntity.PayListInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 就诊
Property Adm As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊科室
Property AdmDep As %String(TRUNCATE = 1);

/// 就诊科室名称
Property AdmDepName As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorId As %String(TRUNCATE = 1);

/// 医生名称
Property DoctorName As %String(TRUNCATE = 1);

/// 支付金额
Property PayAmout As %String(TRUNCATE = 1);

/// prt_rowid
Property ReceiptId As %String(TRUNCATE = 1);

/// 交费日期
Property ChargeDate As %String(TRUNCATE = 1);

Property OEOrdItems As list Of DHCExternalService.BillInterface.DHCEntity.OEOrdItem;

}
