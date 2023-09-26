/// 名称: DHCMA.CPW.OPCPS.PathwayEpisSrv
/// 描述: 门诊临床路径阶段服务类
/// 编写者：yankai
/// 编写日期: 2019-09-03
Class DHCMA.CPW.OPCPS.PathwayEpisSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  入径后，将该路径的阶段同步到阶段执行表中（入径、切换路径时同步）
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).SyncSteps("2","8","10209!!1","1")
ClassMethod SyncSteps(aPathwayID As %String, aFormID As %String, aUserID As %String, aFormEpID As %String = "") As %String
{
	New (aPathwayID,aFormID,aUserID,aFormEpID)
	Set return=""
	Quit:(aPathwayID="")||(aFormID="") return
	
	Set $ZT="OPSyncStepsError"
	TStart
	
	Set xFormEpID=""
	For {
		Set xFormEpID=$o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xFormEpID))
		Quit:xFormEpID=""
		COntinue:(aFormEpID'="")&&(xFormEpID<aFormEpID)
		
		Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xFormEpID)
		Continue:'$IsObject(objFormEp)
		
		Set IsActive=objFormEp.EpIsActive
		Continue:'IsActive
		Set EpIndNo=objFormEp.EpIndNo
		Set EpDays=objFormEp.EpDays
		Set ChildID=""
		
		Set Inputs=aPathwayID_"^"_ChildID_"^"_aFormID_"||"_xFormEpID_"^"_EpIndNo_"^"_EpDays_"^"_aUserID
		Set ret=##class(DHCMA.CPW.CP.PathwayEpis).Update(Inputs,"^")
		Set return=ret
		If (ret<0) {
			TRollBack 1
			Quit
		} Else {
			Set aEpisID=ret
			Set ret=##class(DHCMA.CPW.CPS.ImplSrv).SyncImpl(aPathwayID,aEpisID,aUserID)
			Set return=ret
			If (ret<0) {
				TRollBack 1
				Quit
			}
		}
	}
	
	If $TLevel>0 TCommit
	Quit return
	
OPSyncStepsError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2019-06-30
/// Desc:		  获取路径中当前阶段的下一阶段
/// Input:		  aVisit
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).GetNextStepID("")
ClassMethod GetNextStepID(aVisitID As %String) As %String
{
	New (aVisitID)
	Set return=""
	Quit:aVisitID="" return
	
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
	Quit:'$IsObject(objVisit) return
	Quit:'$IsObject(objVisit.CPPathwayDr) return
	Quit:'$IsObject(objVisit.CPEpisDr) return
	Set PathwayID=objVisit.CPPathwayDr.%Id()
	Set CurStepIndNo=objVisit.CPEpisDr.CPIndNo 
	
	//循环当前阶段之后阶段中第一个有效阶段视为下一阶段
	For xIndNo=CurStepIndNo+1:1:99{
		Quit:return'=""
		
		Set xCPEpID=""
		For {
			Set xCPEpID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"EPIS",xCPEpID))
			Quit:return'=""
			Quit:xCPEpID=""
			
			Set xObjCPEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(PathwayID_"||"_xCPEpID)
			Continue:'$IsObject(xObjCPEp)
			Continue:'$IsObject(xObjCPEp.CPFormEpDr)
			Continue:xObjCPEp.CPIsActive'=1
			Continue:xObjCPEp.CPIndNo'=xIndNo
			Set return=xObjCPEp.%Id()
		}
	}

	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-11-20
/// Desc:		  获取路径中最后一个阶段的ID
/// Input:		  aPathwayID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).GetLastStepID("")
ClassMethod GetLastStepID(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=""
	Quit:aPathwayID="" return
	
	//循环遍历顺序号最大的一个阶段视为最后一个阶段
	Set xCPEpID="",IndNo=0,LastCPEpID=""
	For {
		Set xCPEpID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xCPEpID))
		Quit:xCPEpID=""
			
		Set xObjCPEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xCPEpID)
		Continue:'$IsObject(xObjCPEp)
		Continue:'$IsObject(xObjCPEp.CPFormEpDr)
		Continue:xObjCPEp.CPIsActive'=1
		Set:IndNo=0 IndNo=+xObjCPEp.CPIndNo
		Set:(+xObjCPEp.CPIndNo)>=IndNo return=xObjCPEp.%Id()
	}

	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-9-6
/// Description:  新就诊入径系统自动确认上一阶段
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).AutoConfirmPathEpis(24)
ClassMethod AutoConfirmPathEpis(aVisitID As %String, aUserID As %String = "") As %String
{
	New (aVisitID,aUserID)
	Set return=""
	Quit:aVisitID="" return
	
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
	Quit:'$IsObject(objVisit) return
	Quit:'$IsObject(objVisit.CPPathwayDr) return
	Quit:'$IsObject(objVisit.CPEpisDr) return
	
	Set PathwayID=objVisit.CPPathwayDr.%Id()
	Set CurEpisID=objVisit.CPEpisDr.%Id()
	Set:aUserID="" aUserID=objVisit.CPInUserID
	Set EpisSttDate=$zdt(+objVisit.CPInDate,3)
	Set NextEpisID=..GetNextStepID(aVisitID)
	Set EpisEndDate=$zdt(+$h,3)
	
	Set return=##class(DHCMA.CPW.OPCPS.ImplementSrv).ConfirmStep(CurEpisID,EpisSttDate,EpisEndDate,aUserID,NextEpisID)
	Quit return
}

}
