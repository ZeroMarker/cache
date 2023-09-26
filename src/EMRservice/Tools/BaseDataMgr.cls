Class EMRservice.Tools.BaseDataMgr Extends %RegisteredObject [ ProcedureBlock ]
{

/// d ##Class(EMRservice.Tools.BaseDataMgr).InitAction()
ClassMethod InitAction()
{
	w !, ..InitOneAction("pushSign","推送签名")
	w !, ..InitOneAction("revokePushSign","撤销推送签名")
	w !, ..InitOneAction("finishPushSign","完成推送签名")
	
	w !, ..InitOneAction("patPushSign","推送患者签名")
	w !, ..InitOneAction("revokePatPushSign","撤销推送患者签名")
	w !, ..InitOneAction("finishPatPushSign","完成推送患者签名")
}

ClassMethod InitOneAction(code, name) As %String
{
	s ID = ""
	&sql(select ID into :ID from EMRmeta.EMRAction where ActionCode = :code)
	if (ID = "")
	{
		&sql(insert into EMRmeta.EMRAction (ActionCode, ActionName) values (:code, :name))
	}
	else
	{
		&sql(update EMRmeta.EMRAction set ActionCode = :code, ActionName = :name where ID = :ID) 
	}
	
	q SQLCODE
}

/// d ##Class(EMRservice.Tools.BaseDataMgr).InitActStatusCfg()
ClassMethod InitActStatusCfg()
{
	/*
	finished	完成
	participantChecked	医师签名
	residentChecked	住院医师审核
	attendingChecked	主治医师审核
	viceChiefChecked	副主任签名
	chiefChecked	主任医师审核
	chairmanChecked	科主任签名
	chargeNurseChecked	责任护士签名
	qcdocChecked	质控医师签名
	qcnurseChecked	质控护士签名
	refresherChecked	进修医师签名
	coderChecked	编码员签名
	deleted	已删除
	archieved	已归档
	patientSigned	患者签字
	checkedRevision	签名修正
	internChecked	实习医师审核
	*/
	s scList = "finished^participantChecked^residentChecked^attendingChecked^viceChiefChecked^chiefChecked^chairmanChecked^chargeNurseChecked"
	s scList = scList_"^qcdocChecked^qcnurseChecked^refresherChecked^coderChecked^archieved^patientSigned^checkedRevision^internChecked"
	s count = $L(scList,"^")
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"pushSign",sc)
	}
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"revokePushSign",sc)
	}
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"finishPushSign",sc)
	}
	
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"patPushSign",sc)
	}
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"revokePatPushSign",sc)
	}
	for i = 1:1:count
	{
		s sc = $p(scList,"^",i)
		w !, sc, ":", ..InitOneActStatusCfg(sc,"finishPatPushSign",sc)
	}
}

ClassMethod InitOneActStatusCfg(preStatus, action, postStatus) As %String
{
	
	s ID = ""
	&sql(select ID into :ID from EMRmeta.EMRActStatusCfg where PreStatus = :preStatus and EMRAction = :action)
	if (ID = "")
	{
		&sql(insert into EMRmeta.EMRActStatusCfg (PreStatus, EMRAction, PostStatus) values (:preStatus, :action, :postStatus))
	}
	else
	{
		&sql(update EMRmeta.EMRActStatusCfg set PreStatus = :preStatus, EMRAction = :action, PostStatus = :postStatus where ID = :ID) 
	}
	
	q SQLCODE
}

}
