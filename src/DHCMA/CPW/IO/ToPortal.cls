/// 名称: DHCMA.CPW.IO.ToPortal
/// 描述: 给Portal组接口
/// 编写者：jiangpengpeng
/// 编写日期: 2018-11-30
Class DHCMA.CPW.IO.ToPortal Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-03
/// Description:  判断当前路径是否处于某状态
/// Input：       aEpisodeID : 就诊ID
/// 			  aStatus : 路径状态
/// 			  aIsVar : 1检查变异，0不检查变异	
/// Return:		  返回String: 路径名称^当前步骤
/// w ##class(DHCMA.CPW.IO.ToPortal).CheckCPWStatus("6","I",0)
ClassMethod CheckCPWStatus(aEpisodeID As %String, aStatus As %String, aIsVar As %String) As %String
{
	New (aEpisodeID,aStatus,aIsVar)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="CheckCPWStatusErr"
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Quit:'$IsObject(objPathway)
		
		Set CPWStatus=objPathway.CPStatus
		Continue:(CPWStatus="U")&&((CPWStatus="T"))	//作废和不入径的不算
		Quit:(aStatus'="")&&(CPWStatus'=aStatus)		//只检查当前路径，所以退出
		Quit:(aStatus="")&&(CPWStatus="T")			//aStatus为空时，查入径、完成、出径
		
		Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
		Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
		
		Set VarReason=""
		//If (aIsVar=1) {
			Set CPWIsVar=0	//是否发生变异标志
			Set xVarID=""
			For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xVarID))
				Quit:xVarID=""
				
				Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xVarID)
 				Continue:'$IsObject(objVar)
 				Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
 				
 				Set VariatCat=objVar.CPVariatDr.BTDesc
 				Set VariatTxt=objVar.CPVariatTxt
 				Set VarReason=VariatCat
 				Set:VariatTxt'="" VarReason=VarReason_"-"_VariatTxt
 				Set CPWIsVar=1	//发生变异
 				Quit
			}
			Quit:(aIsVar=1)&&(CPWIsVar=0)	//未发生变异退出
		//}
		
		Set return=CPWDesc_"^"_CurrEpisDesc_"^"_VarReason
		Quit
	}
	
	Quit return
	
CheckCPWStatusErr
	Quit "-999"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-03
/// Description:  判断有无不入径申请，即应入（未入）患者
/// Input：       aEpisodeID : 就诊ID
/// Return:		  返回String: 路径名称^为入径理由(备注)^未入经日期^未入经时间^未入经医生
/// w ##class(DHCMA.CPW.IO.ToPortal).CheckIsApply("41")
ClassMethod CheckIsApply(aEpisodeID As %String) As %String
{
	New (aEpisodeID,aStatus,aIsVar)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="CheckIsApplyErr"
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Quit:'$IsObject(objPathway)
		
		Set CPWStatus=objPathway.CPStatus
		Continue:(CPWStatus="U")		//作废的不算
		Quit:(CPWStatus'="T")		//不入径申请的路径状态为T
		
		Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
		
		Set xTypeID=""
		For {
			Set xTypeID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xPathwayID,xTypeID))
			Quit:xTypeID=""
			
			Set objType= ##class(DHCMA.Util.BT.Dictionary).GetObjById(xTypeID)
		 	Continue:'$IsObject(objType)
			Continue:objType.BTDesc'="未入径原因"
			
			Set xApplyID=""
			For {
				Set xApplyID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xPathwayID,xTypeID,xApplyID))
				Quit:xApplyID=""
				
				Set objApply=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xPathwayID_"||"_xApplyID)
				Continue:'$IsObject(objApply)
				Continue:'objApply.CPIsActive
				
				Set Reason=objApply.CPReasonDr.BTDesc
				Set ApplyTxt=objApply.CPApplyTxt
				//add by liuzhenhe->路径名称^为入径理由(备注)^未入经日期^未入经时间^未入经医生
				Set AppDate=objApply.CPActDate
				Set AppTime=objApply.CPActTime
				Set AppUser=objApply.CPActUserID

				Set:AppUser'="" objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(AppUser)
				Set AppUserDesc=""
				Set:$IsObject(objUser) AppUserDesc=objUser.BTDesc

				Set Reason=Reason_"("_ApplyTxt_")"
				Set return=CPWDesc_"^"_Reason_"^"_AppDate_"^"_AppTime_"^"_AppUserDesc
				
				Quit
			}
		}
	}
	
	Quit return
CheckIsApplyErr
	Quit "-999"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-03
/// Description:  根据日期查询路径信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.IO.ToPortal","QryCPWByDate","2018-09-01","2018-09-21","I","")
Query QryCPWByDate(aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,CPWDesc:%String,Date:%String,CPWIsVar:%String")
{
}

ClassMethod QryCPWByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aStatus="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=$zdh(aDateFrom,3)
 	Set aDateTo=$zdh(aDateTo,3)
 	
 	Set IndexName=$Case(aStatus,"I":"IdxofInLocDate","C":"IdxofOutLocDate",:"I")
 	
 	Set xLocID=""
 	For {
	 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
	 	Quit:xLocID=""
	 	
	 	Continue:(aLocID'="")&&(aLocID'=($p(xLocID,"!!",1)))
	 	
	 	Set xDate=aDateFrom-1
	 	For {
		 	Set xDate=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate))
		 	Quit:xDate=""
		 	Quit:xDate>aDateTo
		 	
		 	Set xCPWID=""
		 	For {
		 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate,xCPWID))
		 		Quit:xCPWID=""
		 		
		 		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
		 		Continue:'$IsObject(objPathway)
		 		
		 		Set Status=objPathway.CPStatus
		 		Continue:(aStatus'="")&&(aStatus'=Status)
		 		
		 		Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc		//当前路径名称
		 		Set InDate=objPathway.CPInDate
		 		Set OutDate=objPathway.CPOutDate
		 		Set ActDate=objPathway.CPActDate
		 		If (Status="I") {
		 			Set Date=$zd(InDate,3)
		 		} ElseIf ((Status="O")||(Status="C")) {
			 		Set Date=$zd(OutDate,3)
		 		} Else {
		 			Set Date=$zd(ActDate,3)
		 		}
		 		
		 		Set EpisodeID=objPathway.CPEpisodeID
		 		Set:EpisodeID["!!" EpisodeID=$p(EpisodeID,"!!",1)
		 		
		 		Set CPWIsVar=0	//是否发生变异标志
				Set xVarID=""
				For {
					Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xVarID))
					Quit:xVarID=""
					
					Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xVarID)
	 				Continue:'$IsObject(objVar)
	 				Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
	 				
	 				Set CPWIsVar=1	//发生变异
	 				Quit
				}
				
				Set Data=$lb(ind,EpisodeID,CPWDesc,Date,CPWIsVar)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
	 	}
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     jiangpengpeng
/// CreatDate：   2020-01-09
/// Description:  根据日期统计路径信息
/// Table：       
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.IO.ToPortal","QrySTAByDate","2018-12-01","2019-01-31","2","","")
Query QrySTAByDate(aDateFrom As %String, aDateTo As %String, aHospID As %String, aStatus As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ind:%String,HospID:%String,LocID:%String,LocDesc:%String,DischCount:%String,ForCPCount:%String,InCPCount:%String,OutCPCount:%String,ClsCPCount:%String,VarCPCount:%String,InCPRatio:%String,ClsRatio:%String,VarRatio:%String")
{
}

ClassMethod QrySTAByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String, aStatus As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set NIndex="QrySTAByDate"
 	Kill ^TMP($zn,$j,NIndex)
 	 
 	Set StatusList=$lb("T","I","O","C")		//需要统计的路径状态列表
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=aDateFrom-1
    For {
    	Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    	Quit:xDate=""
    	Quit:xDate>aDateTo
    	
    	Set xEpisodeID=""
    	For {
    		Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    		Quit:xEpisodeID=""
    		
    		Set AdmData=$g(^DHCMA.Util.EPx.EpisodeD(xEpisodeID))
    		Set AdmLocID=$lg(AdmData,25)
    		Set EpisodeID=$lg(AdmData,2)
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'=AdmHospID)
    		Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"Disch"))	//出院人数
    		
    		Set xPathwayID=""
    		For {
    			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,xPathwayID))
    			Quit:xPathwayID=""
    			
    			Set objCPW=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
    			Continue:'$IsObject(objCPW)
    			Set CPWStatus=objCPW.CPStatus
    			Continue:$lf(StatusList,CPWStatus)<1
    			
    			Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"ForCP"))	//应入人数
    			If ((CPWStatus="I")||(CPWStatus="O")||(CPWStatus="C")) {
    				Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"InCP"))	//入径人数
    			}
    			If (CPWStatus="O") {
    				Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"OutCP"))	//出径人数
    			}
    			If (CPWStatus="C") {
    				Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"ClsCP"))	//完成人数
    			}
    			
    			Set IsVar=0
				Set xVarID=""
				For {
					Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xVarID))
					Quit:xVarID=""
					
					Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xVarID)
			 		Continue:'$IsObject(objVar)
				 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
				 	
				 	Set IsVar=1
				 	Quit
				}
				If (IsVar=1) {
					Set num=$i(^TMP($zn,$j,NIndex,AdmHospID,AdmLocID,"VarCP"))	//发生变异人数
				}
    		}
    	}
    }
    Set xHospID=""
    For {
    	Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
    	Quit:xHospID=""
    	
    	Set xLocID=""
	 	For {
			Set xLocID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID))
			Quit:xLocID=""

			Set LocDesc=$p($g(^CTLOC($p(xLocID,"!!",1))),"^",2)
			
			Set DischCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"Disch"))
			Set ForCPCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"ForCP"))
			Set InCPCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"InCP"))
			Set OutCPCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"OutCP"))
			Set ClsCPCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"ClsCP"))
			Set VarCPCount=$g(^TMP($zn,$j,NIndex,xHospID,AdmLocID,"VarCP"))
			
			Set (InCPRatio,ClsRatio,VarRatio)="0.00%"
			Set:DischCount>0 InCPRatio=$fn((InCPCount/DischCount)*100,"",2)_"%"
			Set:InCPCount>0 ClsRatio=$fn((ClsCPCount/InCPCount)*100,"",2)_"%"
			Set:InCPCount>0 VarRatio=$fn((VarCPCount/InCPCount)*100,"",2)_"%"
			
			Set Data=$lb(ind,xHospID,xLocID,LocDesc,DischCount,ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,InCPRatio,ClsRatio,VarRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
    }
    
 	Quit $$$OK
}

ClassMethod QrySTAByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySTAByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySTAByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySTAByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
