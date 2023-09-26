Class web.DHCENS.STBLL.DICTNew.MODEL.SSMDAApply Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "SS_MainDataApply";

/// 表格代码
Property SSMDATableCode As %String(XMLNAME = "SSMDA_TableCode");

/// 申请内容
Property SSMDAContent As %String(XMLNAME = "SSMDA_Content");

/// 申请来源系统
Property SSMDASourceSys As %String(XMLNAME = "SSMDA_SourceSys");

/// 申请人代码
Property SSMDAUserCode As %String(XMLNAME = "SSMDA_UserCode");

/// 申请人姓名
Property SSMDAUserName As %String(XMLNAME = "SSMDA_UserName");

/// 申请日期
Property SSMDADate As %String(XMLNAME = "SSMDA_Date");

/// 申请时间
Property SSMDATime As %String(XMLNAME = "SSMDA_Time");

/// 申请备注
Property SSMDARemarks As %String(XMLNAME = "SSMDA_Remarks");

}
