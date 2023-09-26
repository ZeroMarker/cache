Class DHCCPMWeb.CPMBL.SysFields.DHCSysDate Extends DHCCPMWeb.CPMBL.SysFields.DHCSysFields [ ClassType = "", Not ProcedureBlock ]
{

/// 获得字段
Method SetField1() As %String
{
	s ..RFCaption="系统日期"
	s ..RFDataType="Date"
	s ..RFDefaultValue=+$h
	s ..RFDescription="提供客户端系统的日期"
	s ..RFName="SCPM.Date"
	
	q ""
}

}
