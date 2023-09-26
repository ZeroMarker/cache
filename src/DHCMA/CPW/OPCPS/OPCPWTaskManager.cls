/// ClassName：		DHCMA.CPW.OPCPS.OPCPWTaskManager
/// Description：	门诊路径任务管理类
/// Creator:		yankai
/// CreateDate:		2019-11-20
Class DHCMA.CPW.OPCPS.OPCPWTaskManager Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-11-01
/// Description:  路径状态自动处理任务-超时自动出径;满足条件自动完成
/// Table：       DHCMA.CPW.CP.Pathway,DHCMA.CPW.CP.PathwayVisit     
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.OPCPWTaskManager).AutoHandlePathStatusTask()
ClassMethod AutoHandlePathStatusTask() As %String
{
	
	Set $ZT="AutoHandlePathStatusError"

	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=$p(Date,"-",3)
	;Set ^DHCMA.OPCPW.HandlePathStatusTask("OutPathErr",YY_"-"_MM,DD,Time)=""
	;Set ^DHCMA.OPCPW.HandlePathStatusTask("CompPathErr",YY_"-"_MM,DD,Time)=""
	
	Set xActDate="",IsNeedOut=0,IsNeedComplete=0
	
	For {
		Set xActDate=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","I",xActDate))						//遍历路径状态为入径的所有入径记录
		Quit:xActDate=""
		
		Set xPathwayID=""
		For {
			Set IsNeedOut=""
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","I",xActDate,xPathwayID))
			Quit:xPathwayID=""
			
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objPathway)
			Continue:objPathway.CPStatus'="I"															//过滤不需要处理的路径
			Continue:objPathway.CPFormDr.FormPathDr.BTAdmType'["O"										//过滤非门诊路径
			
			Set AdmID=$p(objPathway.CPEpisodeID,"!!",1)
			Set AdmType=$p($g(^PAADM(AdmID)),"^",2)  									
 			
 			Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(AdmID)
 			Set CfgAdmType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetInAdmType",AdmHospID)						//门诊路径准入就诊类型
			Set CfgSysOutPathRsnId=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPSysOutPathRsn",AdmHospID)				//系统出径默认出径原因
			Set CfgIsNeedSysCompPath=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPIsNeedSysCompPath",AdmHospID)		//是否需要系统进行完成路径操作
 			Continue:CfgAdmType'[AdmType																					//过滤非法就诊类型路径
			
			Set InDate=objPathway.CPInDate
			Continue:InDate=""
			
			Set FormDays=objPathway.CPFormDr.FormDays													//关联表单标准执行天数
			Continue:FormDays=""
			Set:FormDays["-" FormDays=$p(FormDays,"-",2)
			Set:FormDays<(+$h-InDate) IsNeedOut=1
			
			If IsNeedOut=1{
				Set OutPathStr=xPathwayID
				Set OutPathStr=OutPathStr_"^"_""
				Set OutPathStr=OutPathStr_"^"_objPathway.CPInLocID
				Set OutPathStr=OutPathStr_"^"_objPathway.CPInWardID
				Set OutPathStr=OutPathStr_"^"_$tr(CfgSysOutPathRsnId," ")
				Set OutPathStr=OutPathStr_"^"_""
				
				Set flg=##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOutOPCPW(OutPathStr,"^")
				If flg<0{
					Set ^DHCMA.OPCPW.HandlePathStatusTask("OutPathErr",YY_"-"_MM,DD,Time)=$g(^DHCMA.OPCPW.HandlePathStatusTask("OutPathErr",YY_"-"_MM,DD,Time))_$lb(xPathwayID)	
				}
				
			}
					
			If (CfgIsNeedSysCompPath=1)||(CfgIsNeedSysCompPath="Y") {
				Set PatIDAndIDCardCode=##class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(AdmID)
				Set PatientID=$p(PatIDAndIDCardCode,"^",1)
				
				Set ret=..CheckIsNeedCompPath(PatientID,xPathwayID)							//检查是否满足路径完成条件
				Set IsNeedComplete=$p(ret,"^",1)
				Set CurrEpisodeID=$p(ret,"^",2)
				
				If IsNeedComplete=1{
					Set CompPathStr=xPathwayID
					Set CompPathStr=CompPathStr_"^"_""
					Set CompPathStr=CompPathStr_"^"_objPathway.CPInLocID
					Set CompPathStr=CompPathStr_"^"_objPathway.CPInWardID
					Set flg=##class(DHCMA.CPW.OPCPS.InterfaceSrv).CloseOPCPW(CurrEpisodeID,CompPathStr)
					If ret<0{
						Set ^DHCMA.OPCPW.HandlePathStatusTask("CompPathErr",YY_"-"_MM,DD,Time)=$g(^DHCMA.OPCPW.HandlePathStatusTask("CompPathErr",YY_"-"_MM,DD,Time))_$lb(xPathwayID)
					}	
				}
			}
		}	
	}
	
	Quit "OK"
	
AutoHandlePathStatusError
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2019-11-20
/// Desc:		  检查路径是否需要完成
/// Input:		  aPathwayID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.OPCPWTaskManager).CheckIsNeedCompPath(385731,13)
ClassMethod CheckIsNeedCompPath(aPatID As %String, aPathwayID As %String) As %String
{
	New (aPatID,aPathwayID)
	Set return=0
	Quit:aPatID=""||aPathwayID="" return
	
	Set objPathway=##Class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	Quit:objPathway.CPStatus'="I" return
	
	//取路径维护的最后阶段
	Set LastEpisID=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).GetLastStepID(aPathwayID)	
	Quit:LastEpisID="" return
	
	Set IsNeedComp=0,EpisodeID=""
	Set xVisitID=""
	For {
		Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPathwayDr",aPathwayID,xVisitID),-1)
		Quit:IsNeedComp=1
		Quit:xVisitID=""
		
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
		Continue:'$IsObject(objVisit)
		Continue:objVisit.CPStatus'="I"
		Continue:LastEpisID'=objVisit.CPEpisDr.%Id()
		Continue:objVisit.CPInDate'=+$h						//只检查当天就诊入径
		Set IsNeedComp=1
		Set EpisodeID=objVisit.CPEpisodeID			
	}
	
	Set return=IsNeedComp_"^"_EpisodeID
	Quit return
}

}
