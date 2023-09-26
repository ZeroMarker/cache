/// Creator: 	qqa
/// CreateDate: 2021-08-16
/// Descript:   药品知识消息提醒
Class web.DHCCKBMessage Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:qqa
/// CreatDate:2021-08-31
/// Descript:需弹出消息提醒
/// Input:Params:入参,LgParams:当前登录信息(医院^科室^安全组^人员)
ClassMethod ListMessageData(Params, LgParams)
{
	n (Params,LgParams,%session)
	s LgUserId=$p(LgParams,"^",4)
	i $d(%session) d
	.s LgUserId=%session.Data("LOGON.USERID")
	
	q "[]"
}

}
