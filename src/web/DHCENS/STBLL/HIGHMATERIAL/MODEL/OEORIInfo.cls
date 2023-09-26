Class web.DHCENS.STBLL.HIGHMATERIAL.MODEL.OEORIInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OEORIInfo";

/// 条形码
Property BarCode As %Library.String(MAXLEN = 100, XMLNAME = "BarCode");

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 100, XMLNAME = "OEORIOrderItemID");

/// 医嘱组号
Property OEORIOEORIDR As %Library.String(MAXLEN = 100, XMLNAME = "OEORIOEORIDR");

/// 医嘱项目代码
Property OEORIARCItmMastCode As %Library.String(MAXLEN = 100, XMLNAME = "OEORIARCItmMastCode");

/// 医嘱项目描述
Property OEORIARCItmMastDesc As %Library.String(MAXLEN = 100, XMLNAME = "OEORIARCItmMastDesc");

/// 材料单价
Property Price As %Library.String(MAXLEN = 100, XMLNAME = "Price");

/// 材料数量
Property Amount As %Library.String(MAXLEN = 100, XMLNAME = "Amount");

/// 收费状态
Property BillCode As %Library.String(MAXLEN = 100, XMLNAME = "BillCode");

/// 审核日期
Property VerifyDate As %Library.String(MAXLEN = 100, XMLNAME = "VerifyDate");

/// 审核时间
Property VerifyTime As %Library.String(MAXLEN = 100, XMLNAME = "VerifyTime");

/// 申请科室代码
Property AppDeptCode As %Library.String(MAXLEN = 100, XMLNAME = "AppDeptCode");

/// 申请科室名称
Property AppDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "AppDeptDesc");

/// 接收科室代码
Property RecDeptCode As %Library.String(MAXLEN = 100, XMLNAME = "RecDeptCode");

/// 接收科室名称
Property RecDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "RecDeptDesc");

/// 医生代码
Property DocCode As %Library.String(MAXLEN = 100, XMLNAME = "DocCode");

/// 医生姓名
Property DocDesc As %Library.String(MAXLEN = 100, XMLNAME = "DocDesc");

/// 备注
Property Remarks As %Library.String(MAXLEN = 100, XMLNAME = "Remarks");

}
