Class DHCExternalService.RegInterface.Entity.SynVisitSchedule Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 医院名称
Property HospitalName As %String(TRUNCATE = 1);

/// HIS厂商:(代码和预约机构中的HIS厂商代码保持一致)
Property HIS As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 排班记录信息集
Property RBAS As list Of RBASRec;

/// RBASId	门诊排班标识
Property RBASId As %String(TRUNCATE = 1);

/// RegCount	预约总数
Property RegCount As %String(TRUNCATE = 1);

/// RBASREASON	停替诊原因
Property RBASREASON As %String(TRUNCATE = 1);

/// RBASRec	替诊门诊排班
Property RBASRec As RBASRec;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 门诊类型代码
Property OPTypeCode As %String(TRUNCATE = 1);

/// 门诊类型名称
Property OPTypeName As %String(TRUNCATE = 1);

/// 排班列表的记录数量
Property RBASCount As %String(TRUNCATE = 1);

}
