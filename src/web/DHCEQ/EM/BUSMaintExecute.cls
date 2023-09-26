Class web.DHCEQ.EM.BUSMaintExecute Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-11-02
/// 描述：根据维护记录更新执行计划数据
/// 入参：PERowID 计划执行id
///      MaintRowID  保养id
///      EquipID  设备id
///      BussType 维护类型  1 保养 2 巡检
/// modified by csj 20190213 说明:web.DHCEQ.EM.BUSMaint中SubmitData事务调用了此方法发生事务嵌套报错,去掉此方法事务(其他地方未调用)
ClassMethod ExecutePlanByMaint(PERowID, MaintRowID, EquipID, BussType)
{
	n PELID,Result
	s Result="已执行"
	//更新DHC_EQPlanExecute表已执行数量
	s ExecuteNum=$p(^DHCEQPlanExecute(PERowID),"^",5)+1
	&SQL(update sqluser.DHC_EQPlanExecute Set PE_ExecutedNum=:ExecuteNum where PE_RowID=:PERowID)
	i SQLCODE
	{
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQPlanExecuteList Set PEL_ExecuteFlag='Y',PEL_ExecuteResult=:Result,PEL_MaintDR=:MaintRowID where PEL_PlanExecuteDR=:PERowID and PEL_EquipDR=:EquipID)
	i SQLCODE=100 s SQLCODE=0  //add by csj 20190401 生成计划执行主表时可能没有生成对应计划执行明细(范围限定没有设备)
	s PELID=$G(%ROWID)
	
	i SQLCODE
	{
		q SQLCODE
	}
		
		
		//modify by lmm 2020-03-05 LMM0062
	s PlanID=$p(^DHCEQPlanExecute(PERowID),"^",2)
	if (PlanID'="")
	{
		s MaintTypeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)	
		if (BussType=1)
		{
			s SourceType="71"
		}
		elseif (BussType=2)&&(MaintTypeDR=4)
		{
			s SourceType="72-2"
		}
		elseif (BussType=2)&&(MaintTypeDR=5)
		{
			s SourceType="72-1"
		}
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s OperateInfo="^"_SourceType_"^"_PELID_"^"_User_"^^0"

	 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
		i SQLCODE
		{
			q SQLCODE
		}
		
		//modify by lmm 2020-03-05 LMM0062		
	}

 	q SQLCODE
}

/*
ClassMethod SavaOperateInfo(SourceType, SourceID)
{
	n valList,TSourceType,TSourceID
	k PLIST
	i SourceType=""||SourceID="" q -1
	s Date=+$H
	s Time=$p($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Flag=0
	
	s PLIST(2)=SourceType
	s PLIST(3)=SourceID
	s PLIST(4)=Date
	s PLIST(5)=Time
	s PLIST(6)=User
	s PLIST(9)="N"

	&SQL(Insert Into SQLUSER.DHC_EQOperateInfo Values :PLIST())
	s OIRowID=$G(%ROWID)
	
	i SQLCODE s Flag=SQLCODE

	q Flag
}*/

/// add by lmm 2018-11-02
/// 描述：保存执行计划明细操作人信息
/// 入参：SourceType 来源类型
///       SourceID  来源id
/// modify by lmm 2020-03-06 LMM0062方法不用了

}
