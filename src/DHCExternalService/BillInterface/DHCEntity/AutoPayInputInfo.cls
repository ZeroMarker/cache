/// Creator:Lid
/// CreatDate:2011-11-17
/// Description:用于临时存储自助接接的入参
Class DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

//=0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// SecrityNo	校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// Userid	操作员编码
Property Userid As %String(TRUNCATE = 1);

/// StartDate	开始日期
Property StartDate As %String(TRUNCATE = 1);

/// EndDate	结束日期
Property EndDate As %String(TRUNCATE = 1);

/// PatAmt	病人费用总额(自付总额)
Property PatAmt As %String(TRUNCATE = 1);

/// BankTradeInfo	银行返回的交易明细
Property BankTradeInfo As %String(TRUNCATE = 1);

/// AdmInfo	就诊RowID串,多个时以"^"分割
Property AdmInfo As %String(TRUNCATE = 1);

/// InsuTypeDR	结算费别
Property InsuTypeDR As %String(TRUNCATE = 1);

/// PayModeCode	结算支付方式(1：现金，2：直接支付，3：POS，4：院内预交金)
Property PayModeCode As %String(TRUNCATE = 1);

/// TransactionId	HIS交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// InvoiceNO	HIS发票表RowID
Property InvoiceNO As %String(TRUNCATE = 1);

/// YBChargeData	医保分解数据
Property YBChargeData As %String(TRUNCATE = 1);

Property ReceiptId As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property HospitalId As %String(TRUNCATE = 1);

/// 第三方订单号
Property OriHisOrderNo As %String(TRUNCATE = 1);

/// ExpStr	扩展信息(卡类型^^^^^^^)
Property ExpStr As %String(TRUNCATE = 1);

}
