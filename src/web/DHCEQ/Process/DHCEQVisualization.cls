Class web.DHCEQ.Process.DHCEQVisualization Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zx 2017-05-30  BUG ZX0049
/// 大屏系统登录菜单权限验证
/// 返回0表示有权限  其他表示无权限
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).CheckFunction("1","153","85")
ClassMethod CheckFunction(UserID, LocID, GroupID, Type As %Library.String = "1")
{
	n ReturnFlag,GroupLocDR,UserGroup,chl,SysGroupMenuID,MenusID,MenusType
	//首先判断用户科室及安全组权限
	s ReturnFlag="1"
	s GroupLocDR=$p($g(^SSU("SSUSR",UserID)),"^",4)
	s UserGroup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	i (GroupLocDR=LocID)&&(UserGroup=GroupID) s ReturnFlag="0"
	
	i ReturnFlag'="0" d
	.s chl=0
	.f  s chl=$O(^SSU("SSUSR",UserID,"OTHLL",chl)) q:(chl="")||(ReturnFlag="0")  d
	..s GroupLocDR=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",1)
	..s UserGroup=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",2)
	..i (GroupLocDR=LocID)&&(UserGroup=GroupID) s ReturnFlag="0"
	i ReturnFlag'="0" q "1"
	
	//接着判断安全组访问菜单权限
	s ReturnFlag="1"
	s SysGroupMenuID=0
	f  s SysGroupMenuID=$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMGroupDR",GroupID,SysGroupMenuID)) q:(SysGroupMenuID="")||(ReturnFlag="0")  d
	.s MenusID=$p($g(^DHCEQCCode("DHCEQCSysGroupMenu",SysGroupMenuID)),"^",2)
	.i MenusID'="" d
	..s MenusType=$p($g(^DHCEQCCode("DHCEQCSysMenus",MenusID)),"^",5)
	..i MenusType="Visualization" s ReturnFlag="0"
	i ReturnFlag'="0" q "1"
	
	i Type="1" s ReturnFlag=##Class(web.DHCEQ.Process.DHCEQVisualizationTocken).SaveSession(UserID, LocID, GroupID)
	
	q "0"
}

/// add by zx 2017-05-31
/// 获取资产故障占比
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintStatistics()
ClassMethod GetMaintStatistics()
{
	n EquipDR,THold8,WholeNum,MaintNum,EquipTypeDR
	s (EquipDR,THold8)=""
	s (WholeNum,MaintNum)=0
	s GroupID=%session.Get("LOGON.EQDPGROUPID")
	
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQEquip(EquipDR))  q:EquipDR=""  d
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y" //无效标识
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",38)>2   //状态
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",60)'=1  //库房状态
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	.s THold8=$p($g(^DHCEQEquip(EquipDR)),"^",93) //报修设备
	.i THold8="3" d
	..s MaintNum=MaintNum+1  //维修合计
	.e  d 
	..s WholeNum=WholeNum+1  //完好合计
	
	q WholeNum_"^"_MaintNum
}

/// add by zx 2017-05-31
/// 获取未完成维修单列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQVisualization","GetMaintRequestDetail","1")
Query GetMaintRequestDetail(Flag As %Library.String = "", ActionDesc As %Library.String = "") As %Query(ROWSPEC = "TMaintRequestDR:%String,TExObj:%String,TExObjLoc:%String,TRequestUser:%String,TAcceptUser:%String,TRequestDate:%String,TAcceptDate:%String,TActionDesc:%String,TActionCode:%String,TDate:%String")
{
}

ClassMethod GetMaintRequestDetailExecute(ByRef qHandle As %Binary, Flag As %Library.String = "", ActionDesc As %Library.String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(0,"Status","1",TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.d ResetVariablesGetMaintRequestDetail
	.s TExObjDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",5)
	.i TExObjDR'="" s TExObj=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
	.s TExObjLocDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",6)
	.i TExObjLocDR '="" s TExObjLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TExObjLocDR)
	.s TRequestUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",20)
	.i TRequestUserDR '="" s TRequestUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRequestUserDR)
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:(Flag="0")&&(TAcceptUserDR'="") //待受理时过滤受理过的单据
	.q:(Flag="1")&&(TAcceptUserDR="")  //待维修时过滤未受理单据
	.i TAcceptUserDR '="" s TAcceptUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAcceptUserDR)
	.s TRequestDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",18)
	.i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
	.s TAcceptDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",24)
	.i TAcceptDate'="" s TAcceptDate=$zd(TAcceptDate,3)
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",TMaintRequestDR,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.i TActionID'="" d
	..s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	..s TActionDesc=$e(TActionDesc,1,4) //取前四位
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	.i TActionDesc="" s TActionDesc="报修申请"
	.q:(ActionDesc'="")&&(ActionDesc'=TActionDesc)
	.i $l(TActionDesc)="2" s TActionDesc=" "_TActionDesc_" "
	.s TWaringFlag=##Class(web.DHCEQPrescription).GetPrescriptionInfo("25",TMaintRequestDR)
	.i +TWaringFlag>0 d
	..s TDate=$fn($p($p(TWaringFlag,"^",3),",",1)/86400,"",0)
	.s TWaringFlag=+TWaringFlag
	.d OutputRowGetMaintRequestDetail
	
	Quit $$$OK
OutputRowGetMaintRequestDetail
	Set Data=$lb(TMaintRequestDR,TExObj,TExObjLoc,TRequestUser,TAcceptUser,TRequestDate,TAcceptDate,TActionDesc,TActionCode,TDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintRequestDetail
	Set (TExObjDR,TExObj,TExObjLocDR,TExObjLoc,TRequestUserDR,TRequestUser,TAcceptUserDR,TAcceptUser,TRequestDate,TAcceptDate,TApproveListID,TActionID,TActionDesc,TActionCode,TWaringFlag,TDate)=""
	Quit
}

ClassMethod GetMaintRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-05-31
/// 获取组内近一个月维修工作量
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintGroupWorkNum()
ClassMethod GetMaintGroupWorkNum()
{
	n Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TMaintGroupDR,TMaintGroupListDR,TDate,TStatus,MaintNumList,FinishNumList,MaintGroupList,MaintNum,FinishNum
	s (Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TMaintGroupDR,TMaintGroupListDR,TDate,TStatus,MaintNumList,FinishNumList,MaintGroupList)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	s Date=+$H
	s TempNode="Vis.MaintGroupWorkNum"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s BeginDate=+$h-30 //按三十天算
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:TAcceptUserDR=""
	.//从维修组长查找
	.s TMaintGroupDR=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader","1",TAcceptUserDR,0))
	.//从维修工程师查找
	.i TMaintGroupDR="" d
	..s TMaintGroupListDR=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",TAcceptUserDR,0))
	..i TMaintGroupListDR'="" s TMaintGroupDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",TMaintGroupListDR)),"^",1)
	.q:TMaintGroupDR=""
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s Flag=0
	.i TStatus="2" d
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..i TDate<BeginDate s Flag=1
	.q:Flag=1
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TMaintGroupDR,TStatus))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TMaintGroupDR,TStatus)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TMaintGroupDR,TStatus))+1
	.e  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TMaintGroupDR,TStatus)=1
	
	s MaintGroupDR=0
	f  s MaintGroupDR=$o(^DHCEQTemp(TempNode,Date,UserID,Job,MaintGroupDR)) q:MaintGroupDR=""  d
	.s MaintGroup=""
	.s (MaintNum,FinishNum)=0
	.s Status=0
	.f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,MaintGroupDR,Status)) q:Status=""  d
	..i Status="1" s MaintNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,MaintGroupDR,Status))
	..i Status="2" s FinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,MaintGroupDR,Status))
	..s MaintGroup=$e($p($g(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",2),1,2)
	.i MaintGroupList'="" d
	..s MaintNumList=MaintNumList_","
	..s FinishNumList=FinishNumList_","
	..s MaintGroupList=MaintGroupList_","
	.s MaintNumList=MaintNumList_MaintNum
	.s FinishNumList=FinishNumList_FinishNum
	.s MaintGroupList=MaintGroupList_MaintGroup
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q MaintGroupList_"^"_MaintNumList_"^"_FinishNumList
}

/// add by zx 2017-05-31
/// 获取维修工程师近一个月维修工作量
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetEngineerWorkNum()
ClassMethod GetEngineerWorkNum()
{
	n Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TDate,TStatus,MaintNumList,FinishNumList,AcceptUserList,MaintNum,FinishNum,TotalNum,i
	s (Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TDate,TStatus,MaintNumList,FinishNumList,MaintGroupList)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	k ^DHCEQTemp("Vis.EngineerWorkNum")
	k ^DHCEQTemp("Vis.MaintGroupWorkNumTotal")
	s Date=+$H
	s TempNode="EngineerWorkNum"
	s TempNodeOther="MaintGroupWorkNumTotal"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNodeOther)
	
	s BeginDate=+$h-30 //按三十天算
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s Flag=0
	.i TStatus="2" d 
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..i TDate<BeginDate s Flag=1
	.q:Flag=1
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:TAcceptUserDR=""
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))+1
	.e  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=1
	
	s AcceptUserDR=0
	f  s AcceptUserDR=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR)) q:AcceptUserDR=""  d
	.s TotalNum=0
	.s Status=0
	.f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status)) q:Status=""  d
	..s TotalNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))+TotalNum
	.s ^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum,AcceptUserDR)=AcceptUserDR
	
	s (MaintNumList,FinishNumList,AcceptUserList)=""
	s TotalNum=""
	s i=1
	f  s TotalNum=$o(^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum),-1) q:(i>7)||(TotalNum="")  d
	.s AcceptUserDR=0
	.f  s AcceptUserDR=$o(^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum,AcceptUserDR)) q:(i>7)||(AcceptUserDR="")  d
	..s i=i+1
	..s AcceptUser=""
	..s (MaintNum,FinishNum)=0
	..s Status=0
	..f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status)) q:Status=""  d
	...i Status="1" s MaintNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	...i Status="2" s FinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	...s AcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", AcceptUserDR)
	..i MaintNumList'="" d
	...s MaintNumList=MaintNumList_","
	...s FinishNumList=FinishNumList_","
	...s AcceptUserList=AcceptUserList_","
	..s MaintNumList=MaintNumList_MaintNum
	..s FinishNumList=FinishNumList_FinishNum
	..s AcceptUserList=AcceptUserList_AcceptUser
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	k ^DHCEQTemp(TempNodeOther,Date,UserID,Job)
	q AcceptUserList_"^"_MaintNumList_"^"_FinishNumList
}

/// add by zx 2017-05-31
/// 获取进半年维修单据申请和处理情况
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintAnaly()
ClassMethod GetMaintAnaly()
{
	n Job,UserID,Date,YearStr,MonthStr,BeginDate,EndDate,BeginMonthStr,TMaintRequestDR,TRequestDate,TRequestMonth,TEndDate,TEndMonth
	n MonthList,RequestNumList,FinishNumList,Month,RequestNum,FinishNum
	s (Job,UserID,Date,YearStr,MonthStr,BeginDate,EndDate,BeginMonthStr,TMaintRequestDR,TRequestDate,TRequestMonth,TEndDate,TEndMonth)=""
	s (MonthList,RequestNumList,FinishNumList,Month)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	s Date=+$H
	s TempNode="Vis.MaintAnaly"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s Date=$zd(+$h,3) //获取当前日期
	//取得半年内第一个月所在月份
	s YearStr=$p(Date,"-",1)
	s MonthStr=$p(Date,"-",2)
	s BeginDate=""
	s EndDate=Date
	i (+MonthStr>5) //
	{ 
		s BeginMonthStr=+MonthStr-5
		s BeginDate=YearStr_"-0"_BeginMonthStr_"-01"
	}
	else
	{
		s YearStr=YearStr-1
		s BeginMonthStr=+MonthStr+7 //通过12-5计算获得
		i BeginMonthStr<10 s BeginMonthStr="0"_BeginMonthStr
		s BeginDate=YearStr_"-"_BeginMonthStr_"-01"
	}
	s BeginDate=$zdh(BeginDate,3)
	s EndDate=$zdh(EndDate,3)
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.q:+($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41))="0"
	.s TRequestDate=+$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",18)
	.s TRequestMonth=$p($zd(TRequestDate,3),"-",1,2)
	.s TEndDate=+$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",16)
	.s TEndMonth=$p($zd(TEndDate,3),"-",1,2)
	.i (TRequestDate<=EndDate)&&(TRequestDate>=BeginDate) d
	..// 1表示申请  2表示完成
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TRequestMonth,"1"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TRequestMonth,"1")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TRequestMonth,"1"))+1
	..e  d 
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TRequestMonth,"1")=1
	.i (TEndDate<=EndDate)&&(TEndDate>=BeginDate) d
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2"))+1
	..e  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2")=1
	
	s Month=""
	f  s Month=$o(^DHCEQTemp(TempNode,Date,UserID,Job,Month)) q:Month=""  d
	.s Type=0
	.s (RequestNum,FinishNum)=0
	.f  s Type=$o(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type)) q:Type=""  d
	..i Type=1 s RequestNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type))
	..i Type=2 s FinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type))
	.i MonthList'="" d
	..s MonthList=MonthList_","
	..s RequestNumList=RequestNumList_","
	..s FinishNumList=FinishNumList_","
	.s MonthList=MonthList_Month
	.s RequestNumList=RequestNumList_RequestNum
	.s FinishNumList=FinishNumList_FinishNum
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q MonthList_"^"_RequestNumList_"^"_FinishNumList
}

/// add by zx 2017-05-31
/// 获取未完成单据动作分布
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintAction()
ClassMethod GetMaintAction()
{
	new Job,TMaintRequestDR,TStatus,TApproveInfoID,TActionID,ActionID,TActionCode,TActionDesc,TActionNum,TActionList,TActionNumList
	s (Job,TMaintRequestDR,TStatus,TApproveInfoID,TActionID,ActionID,TActionCode,TActionDesc,TActionNum,TActionList,TActionNumList)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	
	s Date=+$H
	s TempNode="Vis.MaintAction"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus'="1"
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",TMaintRequestDR,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.i TActionID="" s TActionID=0
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TActionID))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TActionID)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TActionID))+1
	.e  d 
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TActionID)=1
	
	s ActionID=""
	f  s ActionID=$o(^DHCEQTemp(TempNode,Date,UserID,Job,ActionID)) q:ActionID=""  d
	.i ActionID=0 d
	..s TActionCode="submit"
	..s TActionDesc="报修申请"
	.e  d 
	..s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	..s TActionDesc=$e(TActionDesc,1,4) //取前四位
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",1)
	.s TActionNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,ActionID))
	.i TActionNumList'="" d
	..s TActionList=TActionList_","
	..s TActionNumList=TActionNumList_","
	.s TActionList=TActionList_TActionDesc
	.s TActionNumList=TActionNumList_TActionNum
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q TActionList_"^"_TActionNumList
}

/// add by zx 2017-06-08
/// 获取echarts图表点击弹出列表信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQVisualization","GetMaintRequestList","2017-04")
Query GetMaintRequestList(Month As %Library.String = "", MaintGroup As %Library.String = "", AcceptUser As %Library.String = "", FinishFlag As %Library.String = "") As %Query(ROWSPEC = "TMaintRequestDR:%String,TExObj:%String,TExObjLoc:%String,TAcceptUser:%String,TAcceptDate:%String,TActionDesc:%String,TActionCode:%String,TDateNum:%String")
{
}

ClassMethod GetMaintRequestListExecute(ByRef qHandle As %Binary, Month As %Library.String = "", MaintGroup As %Library.String = "", AcceptUser As %Library.String = "", FinishFlag As %Library.String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	// 是否是月统计 不是时则是当前日期开始推算前一个月
	i Month'="" d
	.s StartDate=##Class(web.DHCEQReport).GetReportDate(Month,"1","")
	.s EndDate=##Class(web.DHCEQReport).GetReportDate(Month,"2","")
	e  d
	.s StartDate=+$h-30
	.s EndDate=+$h
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.d ResetVariablesGetMaintRequestList
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s Flag=0
	.i (TStatus="2")&&(Month="") d
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..i (TDate<StartDate)||(TDate>EndDate) s Flag=1
	.i (Month'="") d
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",18)  //当为按月统计的时候 比较申请日期
	..i (TDate<StartDate)||(TDate>EndDate) s Flag=1
	.q:Flag=1
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:TAcceptUserDR=""
	.s TAcceptUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAcceptUserDR)
	.q:(AcceptUser'="")&&(AcceptUser'=TAcceptUser)
	.//维修组不为空时 获取维修工程师所在组
	.s TMaintGroupDesc=##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintGroup(TAcceptUserDR)
	.q:(MaintGroup'="")&&($e(TMaintGroupDesc,1,2)'=MaintGroup)
	.s TExObjDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",5)
	.i TExObjDR'="" s TExObj=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
	.s TExObjLocDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",6)
	.i TExObjLocDR '="" s TExObjLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TExObjLocDR)
	.s TAcceptDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",24)
	.i TAcceptDate'="" s TAcceptDate=$zd(TAcceptDate,3)
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",TMaintRequestDR,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.i TActionID'="" d
	..s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	..s TActionDesc=$e(TActionDesc,1,4) //取前四位
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	.i TActionDesc="" s TActionDesc="报修申请"
	.i $l(TActionDesc)="2" s TActionDesc=" "_TActionDesc_" "
	.s TWaringFlag=##Class(web.DHCEQPrescription).GetPrescriptionInfo("25",TMaintRequestDR)
	.i +TWaringFlag>0 d
	..s TDateNum=$fn($p($p(TWaringFlag,"^",3),",",1)/86400,"",0)
	.s TWaringFlag=+TWaringFlag
	.d OutputRowGetMaintRequestList
	
	Quit $$$OK
OutputRowGetMaintRequestList
	Set Data=$lb(TMaintRequestDR,TExObj,TExObjLoc,TAcceptUser,TAcceptDate,TActionDesc,TActionCode,TDateNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintRequestList
	Set (TExObjDR,TExObj,TExObjLocDR,TExObjLoc,TAcceptUserDR,TAcceptUser,TAcceptDate,TApproveListID,TActionID,TActionDesc,TActionCode,TWaringFlag,TDateNum)=""
	Quit
}

ClassMethod GetMaintRequestListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-06-08
/// 获取工程师所在组
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintGroup("3807")
ClassMethod GetMaintGroup(AcceptUserID)
{
	n MaintGroupDR,MaintGroupListDR,MaintGroupDesc
	s (MaintGroupDR,MaintGroupListDR,MaintGroupDesc)=""
	i AcceptUserID="" q ""
	//是否是维修组长
	s MaintGroupDR=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader","1",AcceptUserID,0))
	//是否是维修工程师
	i MaintGroupDR="" d
	.s MaintGroupListDR=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",AcceptUserID,0))
	.i MaintGroupListDR'="" d
	..s MaintGroupDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MaintGroupListDR)),"^",1)
	
	i MaintGroupDR="" q ""
	s MaintGroupDesc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",2)
	
	q MaintGroupDesc
}

/// add by zx 2017-06-12
/// 大屏急救设备在库统计
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).EmergencyControl()
ClassMethod EmergencyControl()
{
	n Job,UserID,GroupID,EquipID,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,MasterItem,RentFlag,TempDate,RentTotal,RentToLoc,UnusualRent
	n RentStatus,MasterItemList,RentList,UnusualList,StockList,MasterItemQty,MasterItemDesc
	s (EQStatus,EQStockStatus,StoreLocID,EquipTypeID,MasterItem,RentFlag,TempDate,RentTotal,RentToLoc,UnusualRent,MasterItemQty,MasterItemDesc)=""
	s Job=$J
	s UserID=%session.Get("LOGON.EQDPUSERID")
	s GroupID=%session.Get("LOGON.EQDPGROUPID")
	
	s Date=+$H
	s TempNode="Vis.EmergencyControl"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s TLocGroupTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i TLocGroupTypeDR'="" d
	.s LocDR=0
	.f  s LocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",TLocGroupTypeDR,LocDR)) q:LocDR=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreLoc",LocDR,EquipID)) quit:EquipID=""  d
	...q:$p($g(^DHCEQEquip(EquipID)),"^",59)="Y" 			  //无效标识
	...s EQStatus=$p($g(^DHCEQEquip(EquipID)),"^",38) 	  //状态
	...q:EQStatus>2
	...s EQStockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)  //库房状态
	...q:EQStockStatus'=1
	...s StoreLocID=$p($g(^DHCEQEquip(EquipID)),"^",67) 	  //科室
	...s EquipTypeID=$p($g(^DHCEQEquip(EquipID)),"^",63) 	  //设备类组
	...q:(EquipTypeID'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeID,GroupID))
	...s MasterItem=$p($g(^DHCEQEquip(EquipID)),"^",7)
	...s RentFlag=##Class(web.DHCEQEquipRent).CheckEquipIsInRent(EquipID)
	...i RentFlag=0  d
	....s TempDate=$g(^DHCEQTemp(TempNode,Date,UserID,Job,MasterItem))
	....s RentTotal=+$p(TempDate,"-",1)
	....s RentToLoc=+$p(TempDate,"-",2)
	....s UnusualRent=+$p(TempDate,"-",3)
	....s RentTotal=RentTotal+1
	....s RentStatus=$p($g(^DHCEQEquip(EquipID)),"^",87)
	....i RentStatus=1 d
	.....s RentToLoc=RentToLoc+1
	....s UnusualStatus=+$p($g(^DHCEQEquip(EquipID)),"^",93)
	....i UnusualStatus>0 d
	.....s UnusualRent=UnusualRent+1
	....s ^DHCEQTemp(TempNode,Date,UserID,Job,MasterItem)=RentTotal_"-"_RentToLoc_"-"_UnusualRent
	
	s (MasterItemList,RentList,UnusualList,StockList)=""
	s MasterItem=0
	f  s MasterItem=$o(^DHCEQTemp(TempNode,Date,UserID,Job,MasterItem)) quit:MasterItem=""  d
	.s MasterItemQty=$g(^DHCEQTemp(TempNode,Date,UserID,Job,MasterItem))
	.s MasterItemDesc=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItem)),"^",1)
	.i MasterItemList'="" d
	..s MasterItemList=MasterItemList_","
	..s RentList=RentList_","
	..s UnusualList=UnusualList_","
	..s StockList=StockList_","
	.s StockRent=$p(MasterItemQty,"-",1)-$p(MasterItemQty,"-",2)-$p(MasterItemQty,"-",3)
	.i +StockRent<1 s StockRent=0
	.s RentList=RentList_$p(MasterItemQty,"-",2)
	.s UnusualList=UnusualList_$p(MasterItemQty,"-",3)
	.s StockList=StockList_StockRent
	.s MasterItemList=MasterItemList_MasterItemDesc
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q MasterItemList_"^"_RentList_"^"_UnusualList_"^"_StockList
}

/// add by zx 2017-06-12
/// 大屏设备配送统计折线图
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).MoveControl()
ClassMethod MoveControl()
{
	n Job,UserID,Date,YearStr,MonthStr,BeginDate,EndDate,BeginMonthStr,TMaintRequestDR,TSubmitDate,TSubmitMonth,TEndDate,TEndMonth
	n MonthList,RequestNumList,FinishNumList,Month,RequestNum,FinishNum
	s (Job,UserID,Date,YearStr,MonthStr,BeginDate,EndDate,BeginMonthStr,TMaintRequestDR,TSubmitDate,TSubmitMonth,TEndDate,TEndMonth)=""
	s (MonthList,RequestNumList,FinishNumList,Month)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	
	s Date=+$H
	s TempNode="Vis.MoveControl"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	
	s Date=$zd(+$h,3) //获取当前日期
	//取得半年内第一个月所在月份
	s YearStr=$p(Date,"-",1)
	s MonthStr=$p(Date,"-",2)
	s BeginDate=""
	s EndDate=Date
	i (+MonthStr>5)
	{
		s BeginMonthStr=+MonthStr-5
		s BeginDate=YearStr_"-0"_BeginMonthStr_"-01"
	}
	else
	{
		s YearStr=YearStr-1
		s BeginMonthStr=+MonthStr+7 //通过12-5计算获得
		i BeginMonthStr<10 s BeginMonthStr="0"_BeginMonthStr
		s BeginDate=YearStr_"-"_BeginMonthStr_"-01"
	}
	s BeginDate=$zdh(BeginDate,3)
	s EndDate=$zdh(EndDate,3)
	
	s TMoveDR=0
	f  s TMoveDR=$o(^DHCEQMove(TMoveDR)) q:TMoveDR=""  d
	.q:$p($g(^DHCEQMove(TMoveDR)),"^",30)="0"
	.q:$p($g(^DHCEQMove(TMoveDR)),"^",31)="Y"
	.s TEndDate=+$p($g(^DHCEQMove(TMoveDR)),"^",16)
	.s TEndMonth=$p($zd(TEndDate,3),"-",1,2)
	.s TSubmitDate=+$p($g(^DHCEQMove(TMoveDR)),"^",24)
	.s TSubmitMonth=$p($zd(TSubmitDate,3),"-",1,2)
	.i (TSubmitDate<=EndDate)&&(TSubmitDate>=BeginDate) d
	..// 1表示申请  2表示完成
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TSubmitMonth,"1"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TSubmitMonth,"1")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TSubmitMonth,"1"))+1
	..e  d 
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TSubmitMonth,"1")=1
	.i (TEndDate<=EndDate)&&(TEndDate>=BeginDate) d
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2"))+1
	..e  d 
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,TEndMonth,"2")=1
	
	s Month=""
	f  s Month=$o(^DHCEQTemp(TempNode,Date,UserID,Job,Month)) q:Month=""  d
	.s Type=0
	.s (RequestNum,FinishNum)=0
	.f  s Type=$o(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type)) q:Type=""  d
	..i Type=1 s RequestNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type))
	..i Type=2 s FinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,Month,Type))
	.i MonthList'="" d
	..s MonthList=MonthList_","
	..s RequestNumList=RequestNumList_","
	..s FinishNumList=FinishNumList_","
	.s MonthList=MonthList_Month
	.s RequestNumList=RequestNumList_RequestNum
	.s FinishNumList=FinishNumList_FinishNum
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q MonthList_"^"_RequestNumList_"^"_FinishNumList
}

/// add by zx 2017-06-13
/// 获取大屏租赁待办单据
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQVisualization","GetRentList")
Query GetRentList() As %Query(ROWSPEC = "TItem:%String,TRequestLoc:%String,TStartDate:%String,TRecieveUser:%String,TActionCode:%String,TActionDesc:%String")
{
}

ClassMethod GetRentListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s TStatus=""
	f  s TStatus=$o(^DHCEQRent(0,"Status",TStatus)) q:TStatus=""  d
	.q:(TStatus'="1")&&(TStatus'="2")
	.s TRentDR=0
	.f  s TRentDR=$o(^DHCEQRent(0,"Status",TStatus,TRentDR)) q:(TRentDR="")  d
	..d ResetGetRentList
	..s TItemDR=$p($g(^DHCEQRent(TRentDR)),"^",7)
	..i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..s TRequestLocDR=$p($g(^DHCEQRent(TRentDR)),"^",2)
	..i TRequestLocDR '="" s TRequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLocDR)
	..s TStartDate=$p($g(^DHCEQRent(TRentDR)),"^",10)
	..i TStartDate'="" s TStartDate=$zd(TStartDate,3)
	..s TRecieveUserDR=$p($g(^DHCEQRent(TRentDR)),"^",15)
	..i TRecieveUserDR'="" s TRecieveUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRecieveUserDR)
	..s TApproveListID=$o(^DHCEQApproveList(0,"Source","30",TRentDR,""),-1)
	..q:TApproveListID=""
	..s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	..i TActionID'="" d
	...s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	...s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	..i TActionDesc="" s TActionDesc="租赁申请"
	..i $l(TActionDesc)="2" s TActionDesc=" "_TActionDesc_" "
	..d OutputRowGetRentList
	
	Quit $$$OK
OutputRowGetRentList
	Set Data=$lb(TItem,TRequestLoc,TStartDate,TRecieveUser,TActionCode,TActionDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetRentList
	Set (TItemDR,TItem,TRequestLocDR,TRequestLoc,TStartDate,TRecieveUserDR,TRecieveUser,TApproveListID,TActionID,TActionCode,TActionDesc)=""
	Quit
}

ClassMethod GetRentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-06-13
/// 获取大屏配送列表数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQVisualization","GetMoveList")
Query GetMoveList() As %Query(ROWSPEC = "TEquip:%String,TToDept:%String,TSendUser:%String,TStartDate:%String,TCreateUser:%String,TCreateDate:%String,TActionCode:%String,TActionDesc:%String")
{
}

ClassMethod GetMoveListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s TMoveDR=0
	f  s TMoveDR=$o(^DHCEQMove(TMoveDR)) q:TMoveDR=""  d
	.q:($p($g(^DHCEQMove(TMoveDR)),"^",30))'="1"
	.q:($p($g(^DHCEQMove(TMoveDR)),"^",31))="Y"
	.d ResetMoveList
	.s TEquipDR=$p($g(^DHCEQMove(TMoveDR)),"^",3)
	.i TEquipDR'="" s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TToDeptDR=$p($g(^DHCEQMove(TMoveDR)),"^",15)
	.i TToDeptDR '="" s TToDept = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToDeptDR)
	.s TSendUserDR=$p($g(^DHCEQMove(TMoveDR)),"^",18)
	.i TSendUserDR '="" s TSendUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TSendUserDR)
	.s TStartDate=$p($g(^DHCEQMove(TMoveDR)),"^",11)
	.i TStartDate'="" s TStartDate=$zd(TStartDate,3)
	.s TCreateUserDR=$p($g(^DHCEQMove(TMoveDR)),"^",20)
	.i TCreateUserDR '="" s TCreateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TCreateUserDR)
	.s TCreateDate=$p($g(^DHCEQMove(TMoveDR)),"^",21)
	.i TCreateDate'="" s TCreateDate=$zd(TCreateDate,3)
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","31",TMoveDR,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.i (TActionID'="")&&(TActionID'="0") d
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	..s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	.i TActionDesc="" s TActionDesc="配送申请"
	.i $l(TActionDesc)="2" s TActionDesc=" "_TActionDesc_" "
	.d OutputRowMoveList
	
	Quit $$$OK
OutputRowMoveList
	Set Data=$lb(TEquip,TToDept,TSendUser,TStartDate,TCreateUser,TCreateDate,TActionCode,TActionDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetMoveList
	Set (TEquipDR,TEquip,TToDeptDR,TToDept,TSendUserDR,TSendUser,TStartDate,TCreateUserDR,TCreateUser,TCreateDate,TApproveListID,TActionID,TActionCode,TActionDesc)=""
	Quit
}

ClassMethod GetMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-08-22
/// 汇总工程师近一个月工作量
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQVisualization","GetEngineerWorkDetail")
Query GetEngineerWorkDetail() As %Query(ROWSPEC = "TAcceptUser:%String,TAcceptNum:%String,TFinishNum:%String,TotalNum:%String")
{
}

ClassMethod GetEngineerWorkDetailExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	k ^DHCEQTemp("Vis.EngineerWorkDetail")
	s Date=+$H
	s TempNode="Vis.EngineerWorkDetail"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s BeginDate=+$h-30 //按三十天算
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s Flag=0
	.i TStatus="2" d 
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..i TDate<BeginDate s Flag=1
	.q:Flag=1
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:TAcceptUserDR=""
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))+1
	.e  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=1
	
	s AcceptUserDR=0
	f  s AcceptUserDR=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR)) q:AcceptUserDR=""  d
	.d ResetVariablesGetEngineerWorkDetail
	.s (TAcceptNum,TFinishNum,TotalNum)=0
	.s Status=0
	.f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status)) q:Status=""  d
	..i Status=1 s TAcceptNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	..i Status=2 s TFinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	..s TotalNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))+TotalNum
	.s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", AcceptUserDR)
	.d OutputRowGetEngineerWorkDetail
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	Quit $$$OK
OutputRowGetEngineerWorkDetail
	Set Data=$lb(TAcceptUser,TAcceptNum,TFinishNum,TotalNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEngineerWorkDetail
	Set (TAcceptUser,TAcceptNum,TFinishNum,TotalNum)=""
	Quit
}

ClassMethod GetEngineerWorkDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEngineerWorkDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEngineerWorkDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEngineerWorkDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-08-23
/// 获取全部维修工程师近一个月维修工作量
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetEngineerMaintWorkNum()
ClassMethod GetEngineerMaintWorkNum()
{
	n Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TDate,TStatus,MaintNumList,FinishNumList,AcceptUserList,MaintNum,FinishNum,TotalNum,MemberDR,i
	s (Job,UserID,BeginDate,TMaintRequestDR,TAcceptUserDR,TDate,TStatus,MaintNumList,FinishNumList,MaintGroupList)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	k ^DHCEQTemp("Vis.EngineerWorkNum")
	k ^DHCEQTemp("Vis.MaintGroupWorkNumTotal")
	s Date=+$H
	s TempNode="EngineerMaintWorkNum"
	s TempNodeOther="EngineerMaintGroupWorkNumTotal"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNodeOther)
	
	s BeginDate=+$h-30 //按三十天算
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s Flag=0
	.i TStatus="2" d 
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..i TDate<BeginDate s Flag=1
	.q:Flag=1
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.q:TAcceptUserDR=""
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus))+1
	.e  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,TAcceptUserDR,TStatus)=1
	
	s MemberDR=0
	f  s MemberDR=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",MemberDR)) q:MemberDR=""  d
	.i '$d(^DHCEQTemp(TempNode,Date,UserID,Job,MemberDR)) d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,MemberDR,"1")=0
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,MemberDR,"2")=0
	
	s AcceptUserDR=0
	f  s AcceptUserDR=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR)) q:AcceptUserDR=""  d
	.s TotalNum=0
	.s Status=0
	.f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status)) q:Status=""  d
	..s TotalNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))+TotalNum
	.s ^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum,AcceptUserDR)=AcceptUserDR
	
	s (MaintNumList,FinishNumList,AcceptUserList)=""
	s TotalNum=""
	f  s TotalNum=$o(^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum),-1) q:TotalNum=""  d
	.s AcceptUserDR=0
	.f  s AcceptUserDR=$o(^DHCEQTemp(TempNodeOther,Date,UserID,Job,TotalNum,AcceptUserDR)) q:AcceptUserDR=""  d
	..s AcceptUser=""
	..s (MaintNum,FinishNum)=0
	..s Status=0
	..f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status)) q:Status=""  d
	...i Status="1" s MaintNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	...i Status="2" s FinishNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,AcceptUserDR,Status))
	...s AcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", AcceptUserDR)
	..i MaintNumList'="" d
	...s MaintNumList=MaintNumList_","
	...s FinishNumList=FinishNumList_","
	...s AcceptUserList=AcceptUserList_","
	..s MaintNumList=MaintNumList_MaintNum
	..s FinishNumList=FinishNumList_FinishNum
	..s AcceptUserList=AcceptUserList_AcceptUser
	
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	k ^DHCEQTemp(TempNodeOther,Date,UserID,Job)
	q AcceptUserList_"^"_MaintNumList_"^"_FinishNumList
}

/// add by wy 2022-6-20
/// 获取设备的相关信息和维修信息
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetEquipInfo()
/// 输出：EquipNum全部设备数，TotalOriginalFee总值，AddNum月新增设备数，DisuseNum本月报废设备台数，MaintNum报修中设备数量，RepairNum维修中设备数量
/// OpencheckNum待验收设备数量,FirstAidtNumper生命支持类设备完好率,WholeNumper设备正常数使用率,BenefitAnalyNumper大型设备完好数完好率,AveWorkHour平均维修工时
ClassMethod GetEquipInfo()
{
	//n EquipDR,THold8,EquipNum,WholeNum,MaintNum,AddNum,FirstAidNum,OpencheckNum,BenefitAnalyNum,RepairNum,DisuseNum,EquipTypeDR,TotalOriginalFee,AveWorkHour,TatolWorkHour
	//s (EquipDR,THold8)=""
	s (EquipNum,WholeNum,MaintNum,AddNum,FirstAidtNum,OpencheckNum,BenefitAnalyNum,RepairNum,DisuseNum,TotalOriginalFee,Num,AveWorkHour,TatolWorkHour,WholeNumper,FirstAidtNumper,BenefitAnalyNumper)=0
	s (TatolFirstAidtNum,TatolBenefitAnalyNum)=0
	s Date=+$H
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s StartDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
	s EndDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,2)
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s GroupID=85  //%session.Get("LOGON.EQDPGROUPID")
	//取设备相关信息
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQEquip(EquipDR))  q:EquipDR=""  d
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y" //无效标识
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",38)>2    //状态
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",60)'=1  //库房状态
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","0")) 
	.s THold8=$p($g(^DHCEQEquip(EquipDR)),"^",93) //报修设备
	.s count=##class(web.DHCEQStat).StatisticalAnalysisByType(EquipDR,"Availability","","","")
	.s TNum=$p(count,"^",1)   //0维修中，1正常
	.i (THold8="")&&(TNum=1)  d 
	..s WholeNum=WholeNum+1  //完好合计数量
	
	.i (##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",EquipDR,"21")=1) d
	..s TatolFirstAidtNum=TatolFirstAidtNum+1   //生命支持类设备总数
	..i (THold8="")&&(TNum=1)  d 
	...s FirstAidtNum=FirstAidtNum+1  //生命支持类设备完好数量
	.i (##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",EquipDR,"41")=1) d
	..s TatolBenefitAnalyNum=TatolBenefitAnalyNum+1   //大型设备总数
	..i (THold8="")&&(TNum=1)  d 
	...s BenefitAnalyNum=BenefitAnalyNum+1  //大型设备完好数量
	.s EquipNum=EquipNum+1        //总设备数量
	.s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	.s TotalOriginalFee=TotalOriginalFee+OriginalFee
	.s TransAssetDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
	.i (TransAssetDate>=StartDate)&&(TransAssetDate<=EndDate) d
	..s AddNum=AddNum+1  //本月新增设备
	//验收
	s rowid=0
	f  s rowid=$Order(^DHCEQOpenCheckRequest(rowid))  q:rowid=""  d
	.q:$p($g(^DHCEQOpenCheckRequest(rowid)),"^",45)="Y"
	.s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",2)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","0")) 
	.s OpenCheckList=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0)) //设备批量申请明细单ID
	.s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20)
	.q:Status'=1 //过滤新增的验收单
	.s TQuantityNum = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",16) //数量
	.s OpencheckNum=OpencheckNum+TQuantityNum
	//维修
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s EquipTypeDR=+$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2"))
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:TStatus=3 //过滤作废维修单
    .i TStatus=1 d 
    ..s RepairNum=RepairNum+1
    .i TStatus=2 d
    ..s Num=Num+1
    ..s TatolWorkHour=TatolWorkHour+$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",39)
    .i TStatus<2 d 
    ..s MaintNum=MaintNum+1  //维修合计数量

	//报废
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR)) q:(EquipTypeDR="")  d
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","0"))
	.s BillAuditDate=StartDate-1
	.f  s BillAuditDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,BillAuditDate)) q:(BillAuditDate="")||(BillAuditDate>EndDate)  d
	..s DRRowID=0		//入库单rowID
	..f  s DRRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,BillAuditDate,DRRowID)) q:DRRowID=""  d
	...q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)'=2
	...q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)'="N"
	...s DRLRowID=0
	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:DRLRowID=""  d
	....s TQuantity=1
	....s DisuseNum=DisuseNum+TQuantity
	s TotalOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TotalOriginalFee/10000,"",2) //Modify by zx 2022-07-01 BUG 2762075
	
	i Num'=0 d
	.s AveWorkHour=##Class(web.DHCEQCommon).FormatNumber((TatolWorkHour/Num),"",2)
    e  d
    .s AveWorkHour=0
	s WholeNumper=##Class(web.DHCEQCommon).FormatNumber((WholeNum/EquipNum),"",2)
	i TatolFirstAidtNum'=0 d
	.s FirstAidtNumper=##Class(web.DHCEQCommon).FormatNumber((FirstAidtNum/TatolFirstAidtNum),"",2)
    e  d
    .s FirstAidtNumper=0
    i TatolBenefitAnalyNum'=0  d
	.s BenefitAnalyNumper=##Class(web.DHCEQCommon).FormatNumber((BenefitAnalyNum/TatolBenefitAnalyNum),"",2)
	e  d
	.s BenefitAnalyNumper=0
	
	q EquipNum_"^"_TotalOriginalFee_"^"_AddNum_"^"_DisuseNum_"^"_MaintNum_"^"_RepairNum_"^"_OpencheckNum_"^"_FirstAidtNumper_"^"_WholeNumper_"^"_BenefitAnalyNumper_"^"_AveWorkHour
}

/// add by WY 2022-6-21
/// 获取全部维修的月维修费用和月平均响应时间
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetMaintInfo()
/// 返回：MonthStrList月份时间串，TTotalFeeList月维修费用串，ResponseHourList月平均响应时间串
ClassMethod GetMaintInfo()
{
	n Job,UserID,TMaintRequestDR,TDate,TStatus,MaintNumList,MaintNum,i,MonthStr
	s (Job,UserID,TMaintRequestDR,TDate,TStatus,MaintNumList,MonthStr)=""
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	s GroupID=%session.Get("LOGON.EQDPGROUPID")
	s Date=+$H
	s TempNode="Vis.MaintTotalFee"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.s TStatus=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)
	.q:+TStatus=0
	.s EquipTypeDR=+$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2"))
	.i TStatus="2" d 
	..s TDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",52)
	..s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(TDate)
	..s TotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",60),"")
	..s SubmitDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",49)
	..s SubmitTime=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",50)
	..s AcceptDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",24)
	..s AcceptTime=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",25)
	..s ResponseHour=##Class(web.DHCEQ.RM.BUSRent).GetDiffHour(SubmitDate,SubmitTime,AcceptDate,AcceptTime)
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Fee"))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Fee")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Fee"))+TotalFee
	..e  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Fee")=TotalFee
	
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Count"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Count")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Count"))+1
	..e  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Count")=1
	..i $d(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Hours"))  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Hours")=$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Hours"))+ResponseHour
	..e  d
	...s ^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Hours")=ResponseHour
	
	s (MonthStrList,TTotalFeeList,ResponseHourList)=""	
	s MonthStr=0
	f  s MonthStr=$o(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr)) q:MonthStr=""  d
	.s (TTotalFee,MaintNum,TotalHours)=""	
	.s Type=""
	.f  s Type=$o(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,Type)) q:Type=""  d
	..if Type="Fee" s TTotalFee=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Fee"))+TTotalFee
	..if Type="Count" s MaintNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Count"))+MaintNum
	..if Type="Hours" s TotalHours=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,MonthStr,"Hours"))+TotalHours
	.s TotalHours=##Class(web.DHCEQCommon).FormatNumber((TotalHours/MaintNum),"")
	.i MonthStrList'=""  d
	..s MonthStrList=MonthStrList_","
	..s TTotalFeeList=TTotalFeeList_","
	..s ResponseHourList=ResponseHourList_","
	
	.s MonthStrList=MonthStrList_MonthStr
	.s TTotalFeeList=TTotalFeeList_TTotalFee
	.s ResponseHourList=ResponseHourList_TotalHours
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q MonthStrList_"^"_TTotalFeeList_"^"_ResponseHourList
}

/// add by WY 2022-6-21
/// 获取全院生命支持图类设备科室分布
/// w ##Class(web.DHCEQ.Process.DHCEQVisualization).GetFirstAidInfo()
/// 返回：UseLocList科室ID串，EnableNumList启用状态急救设备数，ResponseHourList停用状态急救设备数
ClassMethod GetFirstAidInfo()
{
	n Job,UserID,TDate,i,EquipDR
	s (Job,UserID,TDate,MaintNumList)=""
	s FirstAidtNum=0
	s Job=$j
	s UserID=%session.Get("LOGON.EQDPUSERID")
	s GroupID=%session.Get("LOGON.EQDPGROUPID")
	s Date=+$H
	s TempNode="Vis.EQFirstAid"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
	
	//取设备相关信息^DHCEQTemp("Vis.EQFirstAid")
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQEquip(EquipDR))  q:EquipDR=""  d
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y" //无效标识
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",38)>2    //状态
	.q:$p($g(^DHCEQEquip(EquipDR)),"^",60)'=1  //库房状态
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","0"))
	.s UseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	.q:(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",EquipDR,"21")'=1)
	.s Status=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.i $d(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status))  d
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status)=$g(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status))+1
	.e  d 
	..s ^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status)=1
	s (UseLocDRList,DisableNumList,EnableNumList)=""	
	s UseLocDR=0
	f  s UseLocDR=$o(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR)) q:UseLocDR=""  d
	.i UseLocDR'="" s UseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.s (DisableNum,EnableNum)=""	
	.s Status=""
	.f  s Status=$o(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status)) q:Status=""  d
	..i Status=1 s EnableNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status))
	..i Status=2 s DisableNum=+$g(^DHCEQTemp(TempNode,Date,UserID,Job,UseLocDR,Status))
	.i UseLocDRList'=""  d
	..s UseLocDRList=UseLocDRList_","
	..s EnableNumList=EnableNumList_","
	..s DisableNumList=DisableNumList_","
	
	.s UseLocDRList=UseLocDRList_UseLocDR
	.s EnableNumList=EnableNumList_EnableNum
	.s DisableNumList=DisableNumList_DisableNum
	k ^DHCEQTemp(TempNode,Date,UserID,Job)
	q UseLocDRList_"^"_EnableNumList_"^"_DisableNumList
}

}
