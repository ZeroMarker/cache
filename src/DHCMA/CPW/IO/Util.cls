/// 名称: DHCMA.CPW.IO.Util
/// 描述: 异常数据处理工具类
/// 编写者：yankai
/// 编写日期: 2021-07-15
Class DHCMA.CPW.IO.Util Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-07-15
/// Description:  批量完成已出院但仍为入径状态的路径记录
/// Table：       
/// Input：       入径日期
/// Return：
/// w ##Class(DHCMA.CPW.IO.Util).BatCloseCPWToDisch("2021-01-01","2021-02-01")
ClassMethod BatCloseCPWToDisch(aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aHospID As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLocID,aHospID)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

	Set $ZT="BatCloseCPWToDischError"	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set xDate=aDateFrom-1,Count=0
    For {
    	Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    	Quit:xDate=""
    	Quit:xDate>aDateTo
    	
    	Set xEpisodeID=""
    	For {
    		Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    		Quit:xEpisodeID=""
    		
    		Set AdmInfo=$g(^DHCMA.Util.EPx.EpisodeD(xEpisodeID))
    		Continue:AdmInfo=""
    		Set Status=$Lg(AdmInfo,5)
    		Continue:Status'="D"
    		
    		Set xEpisodeOID=$Lg(AdmInfo,2)
    		Set xEpisodeID=xEpisodeID_"!!"_SYSDr
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",xEpisodeOID,""),-1)
			Continue:xPathwayID=""
			
			Set obj=##Class(DHCMA.CPW.CP.Pathway).%OpenId(xPathwayID)
	 		Continue:'$IsObject(obj)
	 		Continue:obj.CPStatus'="I"
	 		
	 		Set DischDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(xEpisodeOID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
			Continue:DischDate=""
			
			Set LocID=obj.CPInLocID				//默认完成路径科室为入径科室
			Continue:(aLocID'="")&&($p(aLocID,"!!",1)=$p(LocID,"!!",1))
			Set HospID=+$p($g(^CTLOC(($p(LocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=HospID)
			Set WardID=obj.CPInWardID			//默认完成路径病区为入径病区
			
			Set obj.CPStatus="C"
			Set obj.CPActDate=DischDate
			Set obj.CPActTime=DischTime
			Set obj.CPActUserID="SYS"
			Set obj.CPOutDocID="SYS"
			Set obj.CPOutDate=DischDate
			Set obj.CPOutTime=DischTime
			Set obj.CPOutUserID="SYS"
			Set obj.CPOutLocID=LocID
			Set obj.CPOutWardID=WardID
			
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
				//Do $system.OBJ.DisplayError(sc)
			}Else{
				Set Count=Count+1
			}
			Do obj.%Close()
    	}
    	
    }
		
	/*
	Set xLocID="",Count=0
 	For {
	 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI("IdxofInLocDate",xLocID))
	 	Quit:xLocID=""
	 	
	 	Continue:(aLocID'="")&&(aLocID'=$p(xLocID,"!!",1))
	 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
	 	Continue:(aHospID'="")&&(aHospID'[xHospID)
	 	
	 	Set xDate=aDateFrom-1
	 	For {
		 	Set xDate=$o(^DHCMA.CPW.CP.PathwayI("IdxofInLocDate",xLocID,xDate))
		 	Quit:xDate=""
		 	Quit:xDate>aDateTo
		 	
		 	Set xCPWID="",EpisodeID=""
		 	For {
		 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofInLocDate",xLocID,xDate,xCPWID))
		 		Quit:xCPWID=""
		 		
		 		Continue:'##class(DHCMA.CPW.CP.Pathway).%ExistsId(xCPWID)
				Set obj=##Class(DHCMA.CPW.CP.Pathway).%OpenId(xCPWID)
		 		Continue:'$IsObject(obj)
		 		Continue:obj.CPStatus'="I"
		 		Set EpisodeID=obj.CPEpisodeID
		 		
		 		Set DischDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(EpisodeID)
				Set DischDate=$p(DischDateTime,"^",1)
				Set DischTime=$p(DischDateTime,"^",2)
				Continue:DischDate=""
				
				Set LocID=obj.CPInLocID				//默认完成路径科室为入径科室
				Set WardID=obj.CPInWardID			//默认完成路径病区为入径病区
				
				Set obj.CPStatus="C"
				Set obj.CPActDate=DischDate
				Set obj.CPActTime=DischTime
				Set obj.CPActUserID="SYS"
				Set obj.CPOutDocID="SYS"
				Set obj.CPOutDate=DischDate
				Set obj.CPOutTime=DischTime
				Set obj.CPOutUserID="SYS"
				Set obj.CPOutLocID=LocID
				Set obj.CPOutWardID=WardID
				
				Set sc=obj.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
					//Do $system.OBJ.DisplayError(sc)
				}Else{
					Set Count=Count+1
				}
				Do obj.%Close()
		 	}
	 	}
 	}
 	*/
 	Set return=Count
 	Quit return
 	
BatCloseCPWToDischError
	Quit "-999"_"^"_$ZE
}

/// Creator：     yankai
/// CreatDate：   2022-04-04
/// Description:  DHCMA.CPW.CP.PathwayEpis增加顺序号索引后，处理历史切换路径的阶段顺序号重复问题
/// Table：       
/// Input：       
/// Return：
/// w ##Class(DHCMA.CPW.IO.Util).BatHandleCPEpisIndNo()
ClassMethod BatHandleCPEpisIndNo() As %String
{
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID))
		Quit:xPathwayID=""
		
		Continue:'$d(^DHCMA.CPW.CP.PathwayI("EXEC","IdxofParRef",xPathwayID))
		//按阶段序号排序
		Set NIndex="BatHandleCPEpisIndNo"
		Kill ^TMP($zn,$j,NIndex)
		Set xEpisID="",IsExec=0,PreBTFormID=""
		For {
			Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"EPIS",xEpisID))
			Quit:xEpisID=""
				
			Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(xPathwayID_"||"_xEpisID)
			Continue:'$IsObject(objEpis)
			
			Set IndNo=objEpis.CPIndNo
			Set BTFormEpID=objEpis.CPFormEpDr.%Id()
			Set BTFormID=$p(BTFormEpID,"||",1)
			If (PreBTFormID'=BTFormID) {
				Set IsExec=IsExec+1			//切换次数/序号
				Set PreBTFormID=BTFormID
			}
			Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
		}
		
		Set xIsExec="",tmpIndNo=0
		For {
			Set xIsExec=$o(^TMP($zn,$j,NIndex,xIsExec))
			Quit:xIsExec=""
			
			Set xIndNo=""
			For {
				Set xIndNo=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo))
				Quit:xIndNo=""
				
				Set xEpisID=""
				For {
					Set xEpisID=$o(^TMP($zn,$j,NIndex,xIsExec,xIndNo,xEpisID))
					Quit:xEpisID=""
					
					Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).%OpenId(xPathwayID_"||"_xEpisID)
					Continue:'$IsObject(objEpis)
					Set tmpIndNo=tmpIndNo+1
					Set objEpis.CPIndNo=tmpIndNo
					Do objEpis.%Save()
				}
			}	
		}
	}
	
	Quit 1
}

}
