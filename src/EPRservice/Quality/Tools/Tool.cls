Class EPRservice.Quality.Tools.Tool Extends %RegisteredObject
{

/// d ##class(EPRservice.Quality.Tools.Tool).KillQualityDataGlobal()
ClassMethod KillQualityDataGlobal()
{
	w "删除电子病历质控产品组业务数据 DHCEPRQ*",!
	w "注意:确认操作的数据库是否是 正式环境！",!
	r "是否继续: 是(y) 否(n) ",flag
	if ($zcvt(flag,"U")= "Y")
	{
			
		//EPRinstance.EPRSingleMessage 质控消息数据
		k ^DHCEPRQ.EPRSingleMessageD
	 	k ^DHCEPRQ.EPRSingleMessageI
	 	k ^DHCEPRQ.EPRSingleMessageS
	 	
	 	//EPRinstance.Quality.QualityResult 质控结果大类
	 	k ^DHCEPRQ.QualityResultD
	 	k ^DHCEPRQ.QualityResultI
	 	k ^DHCEPRQ.QualityResultS
	 	
	 	//EPRinstance.Quality.QualityResultDetail 质控结果明细
	 	k ^DHCEPRQ.QualityResultDetailI
	 	k ^DHCEPRQ.QualityResultDetailS
	 	
	 	k ^DHCEPRQ.QualityResultDetailHisI
        k ^DHCEPRQ.QualityResultDetailHisS
	 	
	 	//EPRinstance.Quality.QualityResultEnd 质控终末得分
	 	k ^DHCEPRQ.QualityResultEndD
	 	k ^DHCEPRQ.QualityResultEndI
	 	k ^DHCEPRQ.QualityResultEndS
	 	
	 	//EPRinstance.Quality.QualityResultPeople 质控结果责任对象
	 	k ^DHCEPRQ.QualityResultPeopleD
	    k ^DHCEPRQ.QualityResultPeopleI
	    k ^DHCEPRQ.QualityResultPeopleS
	 	
	 	//EPRinstance.Quality.QualityResultDailyDetail 质控日结果表
	 	k ^DHCEPRQ.QualityRetDailyDetD
	 	k ^DHCEPRQ.QualityRetDailyDetI
	 	k ^DHCEPRQ.QualityRetDailyDetS
	 	
	 	//EPRinstance.Quality.QualitySpotCheck 手工评分结果表
	 	k ^DHCEPRQ.QualitySpotCheckD
	 	k ^DHCEPRQ.QualitySpotCheckI
	 	k ^DHCEPRQ.QualitySpotCheckS
	 	
	 	//EPRinstance.Quality.QualitySpotCheckDetail 手工评分结果明细表
	 	k ^DHCEPRQ.QualitySpotCheckDetailD
	 	k ^DHCEPRQ.QualitySpotCheckDetailI
	 	k ^DHCEPRQ.QualitySpotCheckDetailS
	 	
	 	//清除交叉质控测试数据，分配数据、抽查表数据
	 	kill ^DHCEPRQ.AssignInfoD
	    kill ^DHCEPRQ.AssignInfoI
	    kill ^DHCEPRQ.AssignInfoS
	
		kill ^DHCEPRQ.ExtractInfoD
		kill ^DHCEPRQ.ExtractInfoI
		kill ^DHCEPRQ.ExtractInfoS
		
		//清除交叉质控、门诊质控质控员维护数据
		kill ^DHCEPRQ.MedDoctorI
		kill ^DHCEPRQ.MedDoctorD
		
		//清除门诊质控数据
		kill ^DHCEPRQ.OutPatAssignInfoD
		kill ^DHCEPRQ.OutPatAssignInfoI

		kill ^DHCEPRQ.OutPatDiscussInfoD
		kill ^DHCEPRQ.OutPatDiscussInfoI

		kill ^DHCEPRQ.OutPatSpotCheckDateD
		kill ^DHCEPRQ.OutPatSpotCheckDateI

		kill ^DHCEPRQ.OutPatSummaryInfoD
		kill ^DHCEPRQ.OutPatSummaryInfoI
		
		//清除复制粘贴权限里禁用数据
		k ^DHCEPRM.UserCopyPastePowerD
		k ^DHCEPRM.UserCopyPastePowerI
		k ^DHCEPRM.UserCopyPastePowerS
		
 	
 		W !, "数据 DHCEPRQ* 清除完成！"
	}
	else
	{
		W !, "取消操作！"
	}
}

/// 删除内涵质控相关实例数据
/// d ##class(EPRservice.Quality.Tools.Tool).KillQualityAiDataGlobal()
ClassMethod KillQualityAiDataGlobal()
{
	w "删除电子病历质控产品组-内涵质控业务数据",!
	w "注意:确认操作的数据库是否是 正式环境！",!
	r "是否继续: 是(y) 否(n) ",flag
	if ($zcvt(flag,"U")= "Y")
	{
			
		//EPRinstance.Quality.AiResult 内涵质控错误反馈明细
		k ^DHCEPRQ.AiResultD
	 	k ^DHCEPRQ.AiResultI
	 	k ^DHCEPRQ.AiResultS
	 	
	 	//EPRinstance.Quality.QualityAiLog 内涵质控触犯日志汇总
	 	k ^DHCEPRQ.QualityAiLogD
	 	k ^DHCEPRQ.QualityAiLogI
	 	k ^DHCEPRQ.QualityAiLogS
	 	
	 	//EPRinstance.Quality.QualityAiLogDetail 内涵质控触犯日志明细
	 	k ^DHCEPRQ.QualityAiLogDetailI
	 	k ^DHCEPRQ.QualityAiLogDetailS
 	
 		W !, "内涵质控业务数据 清除完成！"
	}
	else
	{
		W !, "取消操作！"
	}
}

}
