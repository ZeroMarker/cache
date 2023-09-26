Class web.DHCEQ.EM.BUSEvaluate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetEvaluateInfo(vEvaluationDR As %String = "")
{
	i vEvaluationDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9030)
	s result=""
	s ELRowID=0
	f  s ELRowID=$o(^DHCEQCEvaluationList(0,"Evaluation",vEvaluationDR,ELRowID))  q:ELRowID=""  d
	.s ELTypeDR=$p($g(^DHCEQCEvaluationList(ELRowID)),"^",2)
	.s (ELType,ELScore,ELHold1,ELGroup)=""
	.i ELTypeDR'=""  d
	..s ELType=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",2)
	..s ELScore=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",5)
	..s ELHold1=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",6)
	.s ELGroupDR=$p($g(^DHCEQCEvaluationList(ELRowID)),"^",4)
	.i ELGroupDR'="" s ELGroup=$P($G(^DHCEQCCode("DHCEQCEvaluateGroup",ELGroupDR)),"^",2)
	.i result'="" s result=result_"@"
	.s result=result_"^"_ELTypeDR_"^"_ELType_"^"_ELScore_"^"_ELHold1_"^"_ELGroupDR_"^0^"_ELGroup_"^"
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"&"_result)
}

ClassMethod GetUserEvaluateInfo(vERowID As %String = "")
{
	i vERowID=""  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9030)
	
	s result=""
	s ELRowID=0
	f  s ELRowID=$o(^DHCEQEvaluateList(0,"Evaluate",vERowID,ELRowID))  q:ELRowID=""  d
	.s ELTypeDR=$p($g(^DHCEQEvaluateList(ELRowID)),"^",2)
	.s (ELType,ELScore,ELHold1,ELGroup)=""
	.i ELTypeDR'=""  d
	..s ELType=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",2)
	..s ELScore=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",5)
	..s ELHold1=$P($G(^DHCEQCCode("DHCEQCEvaluateType",ELTypeDR)),"^",6)
	.s ELGroupDR=$p($g(^DHCEQEvaluateList(ELRowID)),"^",5)
	.i ELGroupDR'="" s ELGroup=$P($G(^DHCEQCCode("DHCEQCEvaluateGroup",ELGroupDR)),"^",2)
	.s EScore=$p($g(^DHCEQEvaluateList(ELRowID)),"^",3)
	.s ELContent=$p($g(^DHCEQEvaluateList(ELRowID)),"^",4)
	.i result'="" s result=result_"@"
	.s result=result_ELRowID_"^"_ELTypeDR_"^"_ELType_"^"_ELScore_"^"_ELHold1_"^"_ELGroupDR_"^"_EScore_"^"_ELGroup_"^"_ELContent
	s EvaluateUser=$p($g(^DHCEQEvaluate(vERowID)),"^",5)
	i EvaluateUser'="" s EvaluateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",EvaluateUser)
	s EvaluateDate=$p($g(^DHCEQEvaluate(vERowID)),"^",6)
	i EvaluateDate'="" s EvaluateDate=##Class(web.DHCEQCommon).TransValueToPage(EvaluateDate,"date")
	s EvaluateTime=$p($g(^DHCEQEvaluate(vERowID)),"^",7)
	i EvaluateTime'="" s EvaluateTime=##Class(web.DHCEQCommon).TransValueToPage(EvaluateTime,"time")
	s Remark=$p($g(^DHCEQEvaluate(vERowID)),"^",8)
	s Content=$p($g(^DHCEQEvaluate(vERowID)),"^",3)
	s EvaluateInfo=EvaluateUser_"^"_EvaluateDate_"^"_EvaluateTime_"^"_Remark_"^"_Content
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EvaluateInfo_"&"_result)
}

/// 描述:是否可以评价判断
/// w ##Class(web.DHCEQEvaluate).CheckEvaluateFlag(21,1,21,"02","N")
ClassMethod CheckEvaluateFlag(SourceType, SourceID, CurRole, EvaluateGroup As %Library.String = "", AuditFlag, EUser As %Library.String = "", Action As %String = "")
{
	i EUser=""	s EUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	n (SourceType,SourceID,CurRole,EvaluateGroup,AuditFlag,EUser,Action)
	i ((SourceType="")||(SourceID="")||(CurRole=""))	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9003)
	s EquipTypeDR=""
	i SourceType="21"  d
	.s EquipTypeDR=$p($g(^DHCEQInStock(SourceID)),"^",20)
	.s LocDR=$p($g(^DHCEQInStock(SourceID)),"^",2)
	.s Status=$p($g(^DHCEQInStock(SourceID)),"^",10)
	i SourceType="31"  d
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
	.s LocDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",7)
	.s Status=$p($g(^DHCEQMMaintRequest(SourceID)),"^",41)
	i Status<=0 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-900799)
	
	;s HospitalDR=+$p($g(^CTLOC(LocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)     //modify by jyp 2019-10-18 CTLOC调整
	s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","N",+HospitalDR,SourceType,+EquipTypeDR,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","N",+HospitalDR,SourceType,0,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","N",0,SourceType,+EquipTypeDR,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","N",0,SourceType,0,CurRole,0))
	i ERowID'=""
	{
		s EActionCode=""
		s EActionDR=$p($g(^DHCEQCEvaluation(ERowID)),"^",16)
		i EActionDR'="" s EActionCode=$p($g(^DHCEQCCode("DHCEQCAction",EActionDR)),"^",1)
		i (Action'="")&&(EActionCode'=Action) s ERowID=""
	}
	i ERowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9030)		//未设置该业务评价内容
	//独立评价,检测单据是否审批至操作动作
	s EIndependentFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",9)
	if (EIndependentFlag="Y")
	{
		//独立评价,最终审核时点
		s ETimePoint=$p($g(^DHCEQCEvaluation(ERowID)),"^",5)
		i (ETimePoint=0)&&(Status'=2)
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9031)	//"单据[最终审核时点]之后才可评价"
		}
		i (ETimePoint=1)
		{
			//独立评价,指定动作时点评价
			s ApproveTypeDR=##Class(web.DHCEQMessages).GetApproveTypeByBussType(SourceType)
			s ALFind=""
			s ALRowID=""
			f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,SourceID,ALRowID),-1)  q:(ALRowID="")||(ALFind'="")  d
			.s ALInvalidFlag=$p($g(^DHCEQApproveList(ALRowID)),"^",10)
			.q:ALInvalidFlag="Y"
			.s ALAction=$p($g(^DHCEQApproveList(ALRowID)),"^",11)
			.i ALAction=EActionDR s ALFind=ALRowID
			i (ALFind="")&&(Action="")
			{
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9031)	//"单据指定动作还未处理"
			}
		}
		//判断是否前面的人都已评价
		s CurSort=$p($g(^DHCEQCEvaluation(ERowID)),"^",7)
		s PreEvaluateID=0
		s SortID=CurSort
		f  s SortID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","N",SourceType,SortID),-1)  q:(SortID="")||(PreEvaluateID'=0)  d
		.s PreRowID=0
		.f  s PreRowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","N",SourceType,SortID,PreRowID))  q:(PreRowID="")||(PreEvaluateID'=0)  d
		..s PreHospital=$p($g(^DHCEQCEvaluation(PreRowID)),"^",3)
		..s PreEquipType=$p($g(^DHCEQCEvaluation(PreRowID)),"^",4)
		..i ((+PreEquipType=EquipTypeDR)||(+PreHospital=+HospitalDR)) s PreEvaluateID=PreRowID
		..i ((PreHospital="")&&(PreEquipType="")) s PreEvaluateID=PreRowID
		..q:PreEvaluateID=0
		..s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
		..s IndependentFlag=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",9)
		..i $D(^DHCEQEvaluate(0,"SERoleUser",SourceType,SourceID,PreEvaluateID,PreRole))  s PreEvaluateID=0
	
		i PreEvaluateID'=0
		{
			s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
			i PreRole'="" s PreRoleDesc=##Class(web.DHCEQCommon).GetTrakNameByID("role",PreRole)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9031,PreRoleDesc)	//PreRoleDesc_"角色还未评价!"
		}
	}
	s Evaluate=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	d Evaluate.%Set("EIndependentFlag",EIndependentFlag)
	d Evaluate.%Set("EvaluationID",ERowID)
	//可以进行评价(未评价,已评价,无查看权限)
	s EvaluateRowID=$o(^DHCEQEvaluate(0,"SERoleUser",SourceType, SourceID, ERowID, CurRole,0))
	i EvaluateRowID=""
	{
		//非独立评价不能在独立评价界面操作
		i ((EIndependentFlag'="Y")&&(Action=""))
		{
			d Evaluate.%Set("EvaluateStatus",-1)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Evaluate)
		}
		else
		{
			d Evaluate.%Set("EvaluateStatus",0)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Evaluate)
		}
	}
	//已评价(自己评价，他人评价)
	s EvaluateRowID=$o(^DHCEQEvaluate(0,"SERoleUser",SourceType, SourceID, ERowID, CurRole,EUser,0))
	i EvaluateRowID'=""
	{
		//自己评价
		d Evaluate.%Set("EvaluateStatus",1)
		d Evaluate.%Set("EvaluationID",EvaluateRowID)
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Evaluate)
	}
	else
	{
		//他人评价
		s MPEvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",8)
		i MPEvaluationFlag="Y"
		{
			//多人评价
			d Evaluate.%Set("EvaluateStatus",0)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Evaluate)
		}
		else
		{
			//单人评价
			d Evaluate.%Set("EvaluateStatus",-2)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Evaluate)
		}
	}
	//旧版判断
#;	i AuditFlag="Y"
#;	{         
#;		i EUser=""        //Modified by HHM 2016-04-20 处理移动端取session值
#;			{ s EUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	} //Modify DJ 2015-09-14 DJ0164
#;	}
#;	n (SourceType,SourceID,CurRole,EvaluateGroup,AuditFlag,EUser)
#;	s EvaluateGroupDR=##Class(web.DHCEQCEvaluateGroup).GetIDOrDescByCode(EvaluateGroup,1)
#;	i EvaluateGroupDR=""  q "-1018^评价组不存在!"
#;	i ((SourceType="")||(SourceID="")||(CurRole="")||(EvaluateGroup=""))	q "-1019^单据不存在!"
#;	s EquipTypeDR=""
#;	i SourceType="21"  d
#;	.s EquipTypeDR=$p($g(^DHCEQInStock(SourceID)),"^",20)
#;	.s LocDR=$p($g(^DHCEQInStock(SourceID)),"^",2)
#;	i SourceType="31"  d		//SourceType对照:web.DHCEQFind的GetBussTypeDesc
#;	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
#;	.s LocDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",7)
#;	
#;	s HospitalDR=+$p($g(^CTLOC(LocDR)),"^",22)
#;	s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,SourceType,+EquipTypeDR,CurRole,0))
#;	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,SourceType,0,CurRole,0))
#;	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",0,SourceType,+EquipTypeDR,CurRole,0))
#;	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",0,SourceType,0,CurRole,0))
#;	i ERowID="" q "-1010^未设置该业务评价"		//未设置该业务评价内容
#;	s EvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",5)
#;	i EvaluationFlag="N"	q "0^"_ERowID		//该评价内容未启用
#;	//审核单据时判断,非独立评价,即审批之前必须评价
#;	s EIndependentFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",9)
#;	i ((AuditFlag="Y")&&(EIndependentFlag="N")&&('$D(^DHCEQEvaluate(0,"GetScoreID",SourceType,SourceID,ERowID,CurRole,EvaluateGroupDR,EUser))))	q "-1016^本次审核前请先评价!"
#;	
#;	//判断是否前面的人都已评价
#;	s CurSort=$p($g(^DHCEQCEvaluation(ERowID)),"^",7)
#;	s PreEvaluateID=0
#;	s SortID=CurSort
#;	f  s SortID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",SourceType,SortID),-1)  q:(SortID="")||(PreEvaluateID'=0)  d
#;	.s PreRowID=0
#;	.f  s PreRowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",SourceType,SortID,PreRowID))  q:(PreRowID="")||(PreEvaluateID'=0)  d
#;	..s PreHospital=$p($g(^DHCEQCEvaluation(PreRowID)),"^",3)
#;	..s PreEquipType=$p($g(^DHCEQCEvaluation(PreRowID)),"^",4)
#;	..i ((PreEquipType=EquipTypeDR)||(+PreHospital=+HospitalDR)) s PreEvaluateID=PreRowID
#;	..i ((PreHospital="")&&(PreEquipType="")) s PreEvaluateID=PreRowID
#;	..q:PreEvaluateID=0
#;	..s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
#;	..s IndependentFlag=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",9)
#;	..i $D(^DHCEQEvaluate(0,"GetScoreID",SourceType,SourceID,PreEvaluateID,PreRole))  s PreEvaluateID=0
#;	..q:PreEvaluateID=0
#;	..i ((IndependentFlag="Y")&&(AuditFlag="Y")) s PreEvaluateID=0	
#;	
#;	i PreEvaluateID'=0
#;	{
#;		s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
#;		i PreRole'="" s PreRoleDesc=##Class(web.DHCEQCommon).GetTrakNameByID("role",PreRole)
#;		q "-1017^"_PreRoleDesc_"角色还未评价!"
#;	}
#;	
#;	i $g(^DHCEQEvaluate(0,"FinishFlag",SourceType,SourceID))="Y"		q "0^"_ERowID		//当前单据已经评价结束
#;	
#;	q "1^"_ERowID
}

}
