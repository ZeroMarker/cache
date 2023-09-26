Class DHCExternalService.RegInterface.Entity.ImportApptToHISRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// Result	交易结果：0：成功 非0：错误
Property Result As %String(TRUNCATE = 1);

/// ErrorMsg	对错误/异常的详细描述信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// SeqCode	挂号序号
Property SeqCode As %String(TRUNCATE = 1);

/// ApptId	预约挂号记录标识
Property ApptId As %String(TRUNCATE = 1);

/// AdmitRange	就诊时间段
Property AdmitRange As %String(TRUNCATE = 1);

/// RegFee	挂号费
Property RegFee As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// AdmitAddress	就诊地址
Property AdmitAddress As %String(TRUNCATE = 1);

/// ActiveFlag	卡激活标志
Property ActiveFlag As %String(TRUNCATE = 1);

}
