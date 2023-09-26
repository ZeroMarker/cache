Class DHCCPMWeb.CPMBL.SysFields.DHCSysTime Extends DHCCPMWeb.CPMBL.SysFields.DHCSysFields [ ClassType = "", Not ProcedureBlock ]
{

/// 获得字段
Method SetField1() As %String [ GenerateAfter = SetField ]
{
	s ..RFCaption="系统时间"
	s ..RFDataType="Time"
	s ..RFDefaultValue=$p($h,",",2)
	s ..RFDescription="提供客户端系统的时间"
	s ..RFName="SCPM.Time"
	q ""
}

}
