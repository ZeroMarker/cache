Class web.DHCENS.STBLL.Method.Model.LISRptInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "LISReportInfo";

/// 报告ID
Property LISRRReportID As %Library.String(MAXLEN = 30);

/// 患者ID
Property LISRRPatientID As %Library.String(MAXLEN = 30);

/// 就诊类型
Property LISRREncounterTypeCode As %Library.String(MAXLEN = 20);

/// 就诊号
Property LISRRVisitNumber As %Library.String(MAXLEN = 30);

/// 采集日期
Property LISRRCollectDate As %Library.Date;

/// 采集时间
Property LISRRCollectTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 采集者代码
Property LISRRCollectUserCode As %Library.String(MAXLEN = 50);

/// 采集者描述
Property LISRRCollectUserDesc As %Library.String(MAXLEN = 50);

/// 运送日期
Property LISRRCarryDate As %Library.Date;

/// 运送时间
Property LISRRCarryTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 运送者代码
Property LISRRCarryUserCode As %Library.String(MAXLEN = 50);

/// 运送者描述
Property LISRRCarryUserDesc As %Library.String(MAXLEN = 50);

/// 接收日期
Property LISRRReceiveDate As %Library.Date;

/// 接收时间
Property LISRRReceiveTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 接收者代码
Property LISRRReceiveUserCode As %Library.String(MAXLEN = 50);

/// 接收者描述 
Property LISRRReceiveUserDesc As %Library.String(MAXLEN = 50);

/// 接收时标本质量
Property LISRRSpecimenQuality As %Library.String(MAXLEN = 50);

/// 接收说明
Property LISRRReceiveNotes As %Library.String(MAXLEN = 50);

/// 入库日期
Property LISRRInStorageDate As %Library.Date;

/// 入库时间
Property LISRRInStorageTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 入库者代码
Property LISRRInStorageUserCode As %Library.String(MAXLEN = 50);

/// 入库者描述
Property LISRRInStorageUserDesc As %Library.String(MAXLEN = 50);

/// 出库日期
Property LISRROutStorageDate As %Library.Date;

/// 出库时间
Property LISRROutStorageTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 出库者代码
Property LISRROutStorageUserCode As %Library.String(MAXLEN = 50);

/// 出库者描述
Property LISRROutStorageUserDesc As %Library.String(MAXLEN = 50);

/// 出库类型
Property LISRROutStorageType As %Library.String(MAXLEN = 50);

/// 创建日期
Property LISRRAddDate As %Library.Date;

/// 创建时间
Property LISRRAddTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 创建者代码
Property LISRRAddUserCode As %Library.String(MAXLEN = 50);

/// 创建者描述
Property LISRRAddUserDesc As %Library.String(MAXLEN = 50);

/// 创建类型
Property LISRRAddType As %Library.String(MAXLEN = 50);

/// 送达日期
Property LISRRArriveDate As %Library.Date;

/// 送达时间
Property LISRRArriveTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 送达者代码
Property LISRRArriveUserCode As %Library.String(MAXLEN = 50);

/// 送达者描述
Property LISRRArriveUserDesc As %Library.String(MAXLEN = 50);

/// 送达位置
Property LISRRArriveWorkGroup As %Library.String(MAXLEN = 50);

/// 上机日期
Property LISRRMachineDate As %Library.Date;

/// 上机时间
Property LISRRMachineTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 检测日期
Property LISRRTestDate As %Library.Date;

/// 检测时间
Property LISRRTestTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 作废日期
Property LISRRCancelDate As %Library.Date;

/// 作废时间
Property LISRRCancelTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 作废医生代码
Property LISRRCancelUserCode As %String(MAXLEN = 50);

/// 作废医生姓名
Property LISRRCancelUserDesc As %String(MAXLEN = 50);

/// 作废原因
Property LISRRCancelReason As %String(MAXLEN = 100);

/// 报告类型
Property LISRRReprotType As %String(MAXLEN = 4);

/// 备注
Property LISRRRemarks As %String(MAXLEN = 512);

/// 是否微生物报告
Property LISRRISMcroorganism As %String(MAXLEN = 1);

/// 鉴定结果
Property LISRRIdentifition As %String(MAXLEN = 100);

/// 审核日期
Property LISRRCheckDate As %Library.Date;

/// 审核时间
Property LISRRCheckTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 审核医生代码
Property LISRRCheckUserCode As %String(MAXLEN = 50);

/// 审核医生姓名
Property LISRRCheckUserDesc As %String(MAXLEN = 50);

/// 初审日期
Property LISRRFirstCheckDate As %Library.Date;

/// 初审时间
Property LISRRFirstCheckTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 初审医生代码
Property LISRRFirstCheckUserCode As %String(MAXLEN = 50);

/// 初审医生姓名
Property LISRRFirstCheckUserDesc As %String(MAXLEN = 50);

/// 医嘱描述
Property LISRROrderItemDesc As %String(MAXLEN = 100);

/// 异常标识代码
Property LISRRWarnCode As %String(MAXLEN = 100);

/// 报告状态
Property LISRRStatus As %String(MAXLEN = 10);

/// 审核方式
Property LISRRAuthType As %String(MAXLEN = 10);

/// 传输日期
Property LISRRTransmitDate As %Library.Date;

/// 工作小组代码
Property LISRRWorkGroupCode As %String(MAXLEN = 50);

/// 工作小组名称
Property LISRRWorkGroupDesc As %String(MAXLEN = 50);

/// 标本报告序号
Property LISRROrder As %String(MAXLEN = 50);

/// 标本代码
Property LISRRSpecimenID As %String(MAXLEN = 50);

/// 标本名称
Property LISRRSpecimenDesc As %String(MAXLEN = 50);

/// 核收日期
Property LISRRAcceptDate As %Library.Date;

/// 核收时间
Property LISRRAcceptTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 核收者代码
Property LISRRAcceptUserCode As %String(MAXLEN = 50);

/// 核收者姓名
Property LISRRAcceptUserDesc As %String(MAXLEN = 50);

/// 报告主评价
Property LISRRMainConclusion As %String(MAXLEN = 200);

/// 报告次评价
Property LISRRMinorConclusion As %String(MAXLEN = 200);

Property LISItemResultList As list Of web.DHCENS.STBLL.Method.Model.LISRItemResult(XMLNAME = "LISRItemResult", XMLPROJECTION = "ELEMENT");

}
