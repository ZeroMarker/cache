Class DHCCPMWeb.CPMBL.SysFields.DHCSysUserCode Extends DHCCPMWeb.CPMBL.SysFields.DHCSysFields [ ClassType = "", Not ProcedureBlock ]
{

/// 获得字段
Method SetField1() As %String
{
	s ..RFCaption="医院代码"
	s ..RFDataType="String"
	s ..RFDefaultValue=""
	s ..RFDescription="提供给Net端的医院代码"
	s ..RFName="SCPM.HospID"
	q ""
}

}
