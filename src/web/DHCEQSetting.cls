Class web.DHCEQSetting Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEQSetting).InitApprove()
ClassMethod InitApprove()
{
		s ^DHCEQCApproveSet("ApproveType",3,"ApproveSet",0,"Role",7,"NeedField")="CountInLoc,CountNum,DepreLimitYear,AffectAnalyse,ClinicEffect"
		s ^DHCEQCApproveSet("ApproveType",3,"ApproveSet",0,"Role",17,"NeedField")="FeeOfEmployee,FeeOfDepre,CostFee,FeeOfMaterial,Income-5,Effect-5"
}

ClassMethod GetApproveNeedField(approvetype, approveset, role)
{
	new rtn
	if ((approvetype="")||(approveset="")||(role="")) q ""
	s rtn=$g(^DHCEQCApproveSet("ApproveType",approvetype,"ApproveSet",approveset,"Role",role,"NeedField"))
	if rtn=""  d
	.s rtn=$g(^DHCEQCApproveSet("ApproveType",approvetype,"ApproveSet",0,"Role",role,"NeedField"))
	q rtn
}

}
