Class web.DHCEQ.Plat.CTCApproveSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取审批设置的工作流串
/// 返回值格式：step1,role1,roledesc1^step2,role2,roledesc2^....
/// w ##Class(web.DHCEQ.Plat.CTCApproveSet).GetApproveFlow(30)
ClassMethod GetApproveFlow(ApproveSet)
{
	s workflows=""
	s rowid=0
	s step=0
	f  s step=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,step))  q:step=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,step,rowid))  q:rowid=""  d
	..s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
    ..s defaultopinion=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",21)	//czf 2022-10-12
	..s ApproveButtonName=$p(^DHCEQCCode("DHCEQCApproveRole",role),"^",2)
	..//modified by ZY0301 20220523
	..//根据Action修改界面审核按钮的名称
	..s ActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",9)
	..i ActionDR'="" s ApproveButtonName=$p(^DHCEQCCode("DHCEQCAction",ActionDR),"^",2)
	..;s ApproveTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",1)
	..;s ApproveTypeCode=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",1)
	..;i ApproveTypeCode="25"  d
	..;.s ActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",9)
	..;.s ApproveButtonName=$p(^DHCEQCCode("DHCEQCAction",ActionDR),"^",2)
	..//end by ZY0301 20220523
	..s workflows=workflows_"^"_step_","_role_","_ApproveButtonName_","_rowid_","_defaultopinion
	i workflows'="" s workflows=$e(workflows,2,$l(workflows))
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,workflows)
}

}
