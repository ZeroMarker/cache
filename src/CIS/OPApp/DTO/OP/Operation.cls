Class CIS.OPApp.DTO.OP.Operation Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Operation";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 手术申请Id
Property ApplicationID As %String(TRUNCATE = 1);

/// 手术名称Id
Property OperNameID As %String(TRUNCATE = 1);

/// 手术名称
Property OperName As %String(TRUNCATE = 1);

/// 手术名称ICD10码
Property OperNameStandardCode As %String(TRUNCATE = 1);

/// 手术分类ID
Property OperCategoryID As %String;

/// 手术分类：一级手术，二级手术，三级手术，四级手术
Property OperCategory As %String;

/// 切口类型Id
Property BladeTypeID As %String(TRUNCATE = 1);

/// 切口类型
Property BladeType As %String(TRUNCATE = 1);

/// 切口类型国家标准码
Property BladeTypeStandardCode As %String(TRUNCATE = 1);

/// 手术部位Id
Property BodySiteID As %String(TRUNCATE = 1);

/// 手术部位
Property BodySite As %String(TRUNCATE = 1);

/// 手术科室ID
Property SurgicalDepartmentID As %String(TRUNCATE = 1);

/// 手术科室
Property SurgicalDepartment As %String(TRUNCATE = 1);

/// 手术医师
Property Surgeon As CIS.OPApp.DTO.Base.CareProvider;

/// 手术助手
Property Assistants As list Of CIS.OPApp.DTO.Base.CareProvider;

/// 外院专家
Property ExternalExpert As %String;

/// 备注
Property Note As %String;

}
