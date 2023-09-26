/// 名称: 药品业务表 2用药频率维护
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCPHDiseaseFreq Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseFreq";

Property PDFRowId As %String;

Property PDFInstDr As %String;

Property PDFFreqDR As %String;

Property PDFExcludeFlag As %String;

/// PINL_AlertMsg  2016/10/13
Property PDFAlertMsg As %String;

}
