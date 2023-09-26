/// 手术详细信息类
Class DHCCL.DTO.AN.OperationList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 手术列表Id
Property RowId As %String;

/// 手术申请Id
Property OperSchedule As %String;

/// 手术Id
Property Operation As %String;

/// 手术名称
Property OperationDesc As %String(MAXLEN = 500);

/// 手术级别Id
Property OperClass As %String;

/// 手术级别描述
Property OperClassDesc As %String;

/// 手术切口类型Id
Property BladeType As %String;

/// 手术切口类型描述
Property BladeTypeDesc As %String;

/// 手术部位Id
Property BodySite As %String;

/// 手术部位描述
Property BodySiteDesc As %String;

/// 手术体位Id
Property OperPos As %String;

/// 手术体位描述
Property OperPosDesc As %String;

/// 主刀医生Id
Property Surgeon As %String;

/// 主刀医生描述
Property SurgeonDesc As %String;

/// 主刀医生医护人员描述
Property SurCareProvDesc As %String;

/// 主刀医生简称
Property SurgeonShortDesc As %String;

/// 外院专家主刀
Property SurgeonExpert As %String;

/// 手术助手Id
Property Assistant As %String;

/// 手术助手描述
Property AssistantDesc As %String;

/// 主刀医生所在科室Id
Property SurgeonDeptID As %String;

/// 主刀医生科室描述
Property SurgeonDeptDesc As %String;

/// 手术进修和实习医护人员
Property AddtionalStaff As %String;

/// 手术备注
Property OperNote As %String;

/// 手术信息
Property OperInfo As %String;

}
