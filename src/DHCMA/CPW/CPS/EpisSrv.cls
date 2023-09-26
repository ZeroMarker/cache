/// 名称: DHCMA.CPW.CPS.ApplySrv
/// 描述: 临床路径阶段相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2018-09-15
Class DHCMA.CPW.CPS.EpisSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2020-12-32
/// Description:  按阶段序号取第一个阶段（序号相同的取ID最小的）
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.EpisSrv).GetFirstEpisID("2")
ClassMethod GetFirstEpisID(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=""
	Quit:aPathwayID="" return
	
	Set (minNo,minID,FirstEpisID)=0
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
		
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		Continue:'objEpis.CPIsActive
		
		Set IndNo=objEpis.CPIndNo
		If ((minNo=0)||(IndNo<minNo)){
			Set minNo=IndNo
			Set minID=xEpisID
		} ElseIf (IndNo=minNo) {
			Set:xEpisID<minID minID=xEpisID
		}  Else {
		}
	}
	
	Set return=minID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  入径后，将该路径的阶段同步到阶段执行表中（入径、切换路径时同步）
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.EpisSrv).SyncSteps("2","8","10209!!1","1")
ClassMethod SyncSteps(aPathwayID As %String, aFormID As %String, aUserID As %String, aFormEpID As %String = "") As %String
{
	New (aPathwayID,aFormID,aUserID,aFormEpID)
	Set return=""
	Quit:(aPathwayID="")||(aFormID="") return
	
	If (aFormEpID'="") {
		Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_aFormEpID)
		Quit:'$IsObject(objFormEp) return
		
		Set aEpIndNo=objFormEp.EpIndNo
	}
	
	Set $ZE="SyncStepsError"
	TStart
	
	Set xIndNo=""
	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo))
	 	Quit:xIndNo=""
	 	
	 	Set xFormEpID=""
	 	For {
		 	Set xFormEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo,xFormEpID))
		 	Quit:xFormEpID=""
		
			Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xFormEpID)
			Continue:'$IsObject(objFormEp)
			
			Set xEpIndNo=objFormEp.EpIndNo
			Continue:(aFormEpID'="")&&(xEpIndNo<aEpIndNo)
			
			Set IsActive=objFormEp.EpIsActive
			Continue:'IsActive
			
			Set MaxIndNo=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",aPathwayID,""),-1)	//阶段序号重新生成
			Set EpIndNo=+MaxIndNo+1
			Set EpDays=objFormEp.EpDays
			Set ChildID=""
			
			Set Inputs=aPathwayID_"^"_ChildID_"^"_aFormID_"||"_xFormEpID_"^"_EpIndNo_"^"_EpDays_"^"_aUserID
			Set ret=##class(DHCMA.CPW.CP.PathwayEpis).Update(Inputs,"^")
			Set return=ret
			If (ret<0) {
				TRollBack 1
				Set return=-997
				Quit
			} Else {
				Set aEpisID=ret
				Set ret=##class(DHCMA.CPW.CPS.ImplSrv).SyncImpl(aPathwayID,aEpisID,aUserID)
				Set return=ret
				If (ret<0) {
					TRollBack 1
					Set return=-998
					Quit
				}
			}
	 	}
	 	Quit:+return<0
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Quit return
	
SyncStepsError
	If $TLevel>0 TRollBack 1  	//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  通过FormID查找EpisID
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.EpisSrv).GetEpisByFormEpID(1)
ClassMethod GetEpisByFormEpID(aPathwayID As %String, aFormEpID As %String) As DHCMA.CPW.CP.PathwayEpis
{
	New (aPathwayID,aFormEpID)
	Set return=""
	Quit:(aPathwayID="")||(aFormEpID="") return
	
	Set SubID=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParRef",aPathwayID,aFormEpID,""),-1)
	Quit:SubID="" return
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_SubID)
	Quit:'$IsObject(objEpis) return
	
	Set return=objEpis
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-24
/// Description:  切换路径前作废掉未执行的阶段及阶段下项目
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.EpisSrv).DeleteUnCheckEpis(1)
ClassMethod DeleteUnCheckEpis(aPathwayID As %String, aUserID As %String = "") As DHCMA.CPW.CP.PathwayEpis
{
	New (aPathwayID,aUserID)
	Set return=""
	Quit:(aPathwayID="") return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set CurrEpisID=$p(objPathway.CPEpisDr.%Id(),"||",2)
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_CurrEpisID)
	Quit:'$IsObject(objEpis) return
	
	Set aCPIndNo=objEpis.CPIndNo
	
	Set $ZE="DeleteUnCheckEpisError"
	TStart
	
	Set xEpisID=""		//作废当前步骤之后的所有步骤
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
		
		Set xobjEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
		Continue:'$IsObject(xobjEpis)
		Set xCPIndNo=xobjEpis.CPIndNo
		Continue:(aCPIndNo>xCPIndNo)
		
		Set return=##class(DHCMA.CPW.CP.PathwayEpis).Invalid(aPathwayID_"||"_xEpisID)
		//作废阶段成功后，作废该阶段下所有已同步项目
		If +return>0{
			Set xSubImplID=""
			For	{
				Set xSubImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aPathwayID_"||"_xEpisID,xSubImplID))
				Quit:xSubImplID=""
				
				Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xSubImplID)
				Continue:'$IsObject(objImpl)
				Continue:'objImpl.CPIsActive
				Set retImpl=##class(DHCMA.CPW.CP.PathwayImpl).Invalid(aPathwayID_"||"_xSubImplID,aUserID)
				If +retImpl<0{
					TRollBack
					Set return=-998
					Quit	
				}
			}
			Quit:+return<0
		}Else{
			TRollBack
			Set return=-997
			Quit	
		}
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Quit return
	
DeleteUnCheckEpisError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-05-20
/// Description:  展现表单执行记录，输出所有内容
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.EpisSrv","QryEpis","1")
Query QryEpis(aPathwayID As %String) As %Query(ROWSPEC = "ind:%String,PathwayID:%String,EpisID:%String,EpisDesc:%String,SignDoc:%String,SignNur:%String,SttDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,EpisIndNo:%String")
{
}

ClassMethod QryEpisExecute(ByRef qHandle As %Binary, aPathwayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:aPathwayID="" $$$OK
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) $$$OK
		
	Set NIndex="QryEpis"
    Kill ^TMP($zn,$j,NIndex)
    
    Set IsExec=0
    Set PreBTFormID=""
	Set xEpisID=""
	For {
		Set xEpisID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"EPIS",xEpisID))
		Quit:xEpisID=""
			
		Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
		Continue:'$IsObject(objEpis)
		
		Set IsActive=objEpis.CPIsActive
		Continue:'IsActive
		
		Set IndNo=objEpis.CPIndNo
		Set BTFormEpID=objEpis.CPFormEpDr.%Id()
		Set BTFormID=$p(BTFormEpID,"||",1)
		If (PreBTFormID'=BTFormID) {
			Set IsExec=IsExec+1
			Set PreBTFormID=BTFormID
		}
		Set ^TMP($zn,$j,NIndex,IsExec,IndNo,xEpisID)=""
	}
	
	Set PreEndDate="",PreEndTime=""
	Set xIsExec=""
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
				
				Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
				Continue:'$IsObject(objEpis)
				
				Set IsActive=objEpis.CPIsActive
				Continue:'IsActive
				Set EpisDesc=objEpis.CPFormEpDr.EpDesc	//阶段描述
				
				Set SignStr=##class(DHCMA.CPW.CPS.ImplementSrv).GetStepSign(aPathwayID_"||"_xEpisID)
				Set SignDoc=$p(SignStr,"^",1)	//医生签名
				Set SignNur=$p(SignStr,"^",2)	//护士签名
				
				Set SttDate=objEpis.CPSttDate
				Set SttTime=objEpis.CPSttTime
				Set:(ind=1)&&(SttDate="") SttDate=objPathway.CPInDate	//第一阶段开始日期为入径日期
				Set:(ind=1)&&(SttTime="") SttTime=objPathway.CPInTime	//第一阶段开始时间为入径时间
				Set:(PreEndDate'="")&&(SttDate="") SttDate=PreEndDate	//下一阶段的开始日期为上一阶段结束日期
				Set:(PreEndTime'="")&&(SttTime="") SttTime=PreEndTime	//下一阶段的开始时间为上一阶段结束时间
				Set SttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set SttTime=##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat(SttTime,1)
				Set EndDate=objEpis.CPEndDate
				Set EndTime=objEpis.CPEndTime
				Set PreEndDate=EndDate
				Set PreEndTime=EndTime
				Set EndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set EndTime=##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat(EndTime,1)
				
				Set:EpisDesc'="" EpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",EpisDesc,LangID)
			 	Set Data=$lb(ind,aPathwayID,xEpisID,EpisDesc,SignDoc,SignNur,SttDate,SttTime,EndDate,EndTime,xIndNo)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEpisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpisExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator: 		yankai
/// CreateDate:		2023-05-05
/// Description: 	按顺序号获取某阶段的前一阶段
/// Inputs:			aCPEpisID:阶段ID，aIsActive:是否有效
/// Return:			
/// w ##class(DHCMA.CPW.CPS.EpisSrv).GetPreEpisID()
ClassMethod GetPreEpisID(aCPEpisID As %String, aIsActive As %String = 1) As %String
{
	New (aCPEpisID,aIsActive)
	Set return=""
	Quit:aCPEpisID="" return
	
	Set PathwayID=$p(aCPEpisID,"||",1)
	Set objCPEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aCPEpisID)
	Quit:'$IsObject(objCPEpis) return
	Set EpIndNo=objCPEpis.CPIndNo
	
	Set xEpIndNo=EpIndNo
	For {
		Set xEpIndNo=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xEpIndNo),-1)
		Quit:xEpIndNo=""
		Quit:return'=""
		
		Set xSubEpID=""
		For {
			Set xSubEpID=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xEpIndNo,xSubEpID))
			Quit:xSubEpID=""
			Quit:return'=""
			
			Set xPwEpID=PathwayID_"||"_xSubEpID
			Set xObjPwEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(xPwEpID)
			Continue:'$IsObject(xObjPwEp)
			Continue:aIsActive'=xObjPwEp.CPIsActive
			Set return=xPwEpID	
		}	
	}
	
	Quit return
}

/// Creator: 		yankai
/// CreateDate:		2023-05-05
/// Description: 	按顺序号获取某阶段的后一阶段
/// Inputs:			aCPEpisID:阶段ID，aIsActive:是否有效
/// Return:			
/// w ##class(DHCMA.CPW.CPS.EpisSrv).GetNextEpisID()
ClassMethod GetNextEpisID(aCPEpisID As %String, aIsActive As %String = 1) As %String
{
	New (aCPEpisID,aIsActive)
	Set return=""
	Quit:aCPEpisID="" return
	
	Set PathwayID=$p(aCPEpisID,"||",1)
	Set objCPEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aCPEpisID)
	Quit:'$IsObject(objCPEpis) return
	Set EpIndNo=objCPEpis.CPIndNo
	
	Set xEpIndNo=EpIndNo
	For {
		Set xEpIndNo=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xEpIndNo))
		Quit:xEpIndNo=""
		Quit:return'=""
		
		Set xSubEpID=""
		For {
			Set xSubEpID=$o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",PathwayID,xEpIndNo,xSubEpID))
			Quit:xSubEpID=""
			Quit:return'=""
			
			Set xPwEpID=PathwayID_"||"_xSubEpID
			Set xObjPwEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(xPwEpID)
			Continue:'$IsObject(xObjPwEp)
			Continue:aIsActive'=xObjPwEp.CPIsActive
			Set return=xPwEpID	
		}	
	}
	
	Quit return
}

}
