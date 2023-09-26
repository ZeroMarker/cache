Class DHCCPMWeb.CPMSevice.entity.DHCERepFields Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 对于组件来说需要显示类型来取值
Property RFDisplayType As %String(TRUNCATE = 1);

Property ParRef As %String(TRUNCATE = 1);

Property RFCaption As %String(TRUNCATE = 1);

Property RFDataType As %String(TRUNCATE = 1);

Property RFDefaultValue As %String(TRUNCATE = 1);

Property RFDescription As %String(TRUNCATE = 1);

Property RFName As %String(TRUNCATE = 1);

/// 字段类型
/// 分为: 系统    System||S
/// 	  查询    Query||Q
///       自定义  Custom||C
Property RFType As %String(TRUNCATE = 1) [ InitialExpression = "S" ];

Property RowID As %String(TRUNCATE = 1);

Method SetField(RFCaption As %String, RFDataType As %String, RFDefaultValue As %String, RFDescription As %String, RFName As %String) As %String
{
	s ..RFCaption=RFCaption
	s ..RFDataType=RFDataType
	s ..RFDefaultValue=RFDefaultValue
	s ..RFDescription=RFDescription
	s ..RFName=RFName
}

}
