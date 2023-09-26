Class web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 发药数量
Property OrderDispDrugQuantity As %Library.String(MAXLEN = 10, XMLNAME = "OrderDispDrugQuantity");

/// 发药单位
Property OrderDispDrugUnit As %Library.String(MAXLEN = 30, XMLNAME = "OrderDispDrugUnit");

/// 医嘱执行记录ID
Property OrderExecuteID As %Library.String(MAXLEN = 30, XMLNAME = "OrderExecuteID");

/// 医嘱顺序组号
Property OrderSeqNo As %Library.String(MAXLEN = 30, XMLNAME = "OrderSeqNo");

/// 医嘱执行状态
Property OrderExecuteStatus As %Library.String(MAXLEN = 30, XMLNAME = "OrderExecuteStatus");

/// 要求执行日期
Property OrderRequredExDate As %Library.String(MAXLEN = 30, XMLNAME = "OrderRequredExDate");

/// 要求执行时间
Property OrderRequredExTime As %Library.String(MAXLEN = 30, XMLNAME = "OrderRequredExTime");

/// 医嘱执行人代码
Property OrderExUserCode As %Library.String(MAXLEN = 30, XMLNAME = "OrderExUserCode");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 30, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 30, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 30, XMLNAME = "UpdateTime");

/// 审核or撤销
Property IsDrugAudit As %Library.String(MAXLEN = 30, XMLNAME = "IsDrugAudit");

/// 接受科室
Property RecDeptCode As %Library.String(MAXLEN = 30, XMLNAME = "RecDeptCode");

/// 父医嘱RowId
Property OEORIParentOrderID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIParentOrderID");

}
