Class DHCMA.CPW.SDS.QCMrListSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zgz
/// CreatDate：   2019-01-28
/// Description:  进入质控病种
/// Table：       DHCMA.CPW.SD.QCMrList   
/// Input: 		  EpisodeID^PCEntityDr^QCEntityDr^QCInDocID^QCInLocID^QCInWardID^QCInDate^QCInTime
/// 入参说明: 	  就诊ID^付费病种ID^质控病种ID^入单病种医生ID^入单科室^入单病区
/// d ##class(DHCMA.CPW.SDS.QCMrListSrv).InQCEntity()
ClassMethod InQCEntity(aInputStr As %String, aSeparete As %String = "^")
{
	new (aInputStr,aSeparete)
	Set QCEpisodeID     = $p(aInputStr,aSeparete,1)
	Set PCEntityDr		= $p(aInputStr,aSeparete,2)
	Set QCEntityDr      = $p(aInputStr,aSeparete,3)
	Set QCInDocID       = $p(aInputStr,aSeparete,4)
	Set QCInLocID       = $p(aInputStr,aSeparete,5)
	Set QCInWardID      = $p(aInputStr,aSeparete,6)
	Set RCPID      		= $p(aInputStr,aSeparete,7) //关联路径
	Set QCInDate		= +$h
	Set QCInTime		= $p($h,",",2)
	Set return=-1
	Quit:(QCEpisodeID="")||(QCEntityDr="") return
	Set QCEpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(QCEpisodeID)
	Set QCInDocID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(QCInDocID)
	Set QCInLocID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(QCInLocID)
	Set QCInWardID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(QCInWardID)
	Set InputStr="^"_QCEpisodeID_"^"_PCEntityDr_"^"_QCEntityDr_"^"_QCInDocID_"^"_QCInLocID
	_"^"_QCInWardID_"^"_QCInDate_"^"_QCInTime_"^^^^^^^I^"_RCPID  //I 入单病种状态
	Set return=##class(DHCMA.CPW.SD.QCMrList).Update(InputStr)
	d ##class(DHCMA.CPW.SDS.QCItemExecSrv).refreshForm(return)
	d ..InitMrListALL(return)
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2019-01-28
/// Description:  退出质控病种
/// Table：       DHCMA.CPW.SD.QCMrList 
/// Input:        就诊ID^出单医生ID^出单UserID^出单科室ID^出单病区ID        
/// d ##class(DHCMA.CPW.SDS.QCMrListSrv).OutQCEntity()
ClassMethod OutQCEntity(aInputStr As %String)
{
	Set return=-1
	Set EpisodeID			= $p(aInputStr,"^",1)
	Set QCOutDocID    		= $p(aInputStr,"^",2)
	Set QCOutUserID  		= $p(aInputStr,"^",3)
	Set QCOutLocID			= $p(aInputStr,"^",4)
	Set QCOutWardID			= $p(aInputStr,"^",5)
	Set QCOutDate     		= +$h
	Set QCOutTime			= $p($h,",",2)
	Quit:(EpisodeID="") return
	Set MrListID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
	Quit:MrListID="" return
	Set obj=##class(DHCMA.CPW.SD.QCMrList).%OpenId(MrListID)
	Quit:obj.QCState'="I" return
	Set obj.QCOutDocID  		= QCOutDocID
	Set obj.QCOutDate     		= QCOutDate
	Set obj.QCOutTime			= QCOutTime
	Set obj.QCOutUserID  		= QCOutUserID
	Set obj.QCOutLocID			= QCOutLocID
	Set obj.QCOutWardID			= QCOutWardID
	Set obj.QCState="O"
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2019-01-28
/// Description:  完成质控病种
/// Table：       DHCMA.CPW.SD.QCMrList 
/// Input:        就诊ID^出单医生ID^出单UserID^出单科室ID^出单病区ID  
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).CompleteQCEntity("177^1^2^3^4")
ClassMethod CompleteQCEntity(aInputStr As %String)
{
	Set return=-1
	Set paadm				= $p(aInputStr,"^",1)
	Set QCOutDocID    		= $p(aInputStr,"^",2)
	Set QCOutUserID  		= $p(aInputStr,"^",3)
	Set QCOutLocID			= $p(aInputStr,"^",4)
	Set QCOutWardID			= $p(aInputStr,"^",5)
	Set QCOutDate     		= +$h
	Set QCOutTime			= $p($h,",",2)
	Quit:(paadm="") return
	Set MrListID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",paadm,""),-1)
	Quit:MrListID="" return
	Set obj=##class(DHCMA.CPW.SD.QCMrList).%OpenId(MrListID)
	Quit:(obj.QCState'="I")&&(obj.QCState'="") return
	Set obj.QCOutDocID  		= QCOutDocID
	Set obj.QCOutDate     		= QCOutDate
	Set obj.QCOutTime			= QCOutTime
	Set obj.QCOutUserID  		= QCOutUserID
	Set obj.QCOutLocID			= QCOutLocID
	Set obj.QCOutWardID			= QCOutWardID
	Set obj.QCState="C"
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// 更新病种状态
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).UpdateMrStatus("Check","3")
ClassMethod UpdateMrStatus(aStatusCode As %String, aMrListID As %String) As %String
{
	Set return=0
	Quit:(aStatusCode="")||(aMrListID="") ret
	Set obj=##class(DHCMA.CPW.SD.QCMrList).%OpenId(aMrListID)
	Quit:'$IsObject(obj) return
	Set obj.QCState = aStatusCode
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCMrList")
Query QryQCMrList(aLocID As %String = "", aDocID As %String = "") As %Query(ROWSPEC = "RowID:%String,QCEntityID:%String,QCEntityDesc:%String,QCCurrStatus:%String,MrNo:%String,PatName:%String,DisDate:%String,QCInDateT:%String,EpisodeID:%String,QCEntityMsg:%String")
{
}

ClassMethod QryQCMrListExecute(ByRef qHandle As %Binary, aLocID As %String = "", aDocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xLocID=0
 	For {
	 	Set xLocID=$o(^DHCMA.CPW.SD.QCMrListI("IndexLocID",xLocID))
	 	Quit:xLocID=""
	 	Continue:(aLocID'="")&&(aLocID'=xLocID)
	 	
	 	Set xRowID=""
		For {
			Set xRowID=$o(^DHCMA.CPW.SD.QCMrListI("IndexLocID",xLocID,xRowID))
			Quit:xRowID=""
			
			Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
			Continue:'$IsObject(MrListObj)
			
			Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
			Set InQCDocID=MrListObj.QCInDocID
			Continue:(aDocID'="")&&(aDocID'=InQCDocID)
			Set EpisodeID=MrListObj.QCEpisodeID
			Set QCEntityID=MrListObj.QCEntityDr.%Id()
			Set QCEntityDesc=MrListObj.QCEntityDr.BTDesc
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xRowID,""),-1)
			Set QCCurrStatusID=xRowID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set QCCurrStatus=""			
			Set:$IsObject(StatusObj) QCCurrStatus=StatusObj.StateCode.BTDesc
			
			Set Paadm=$p(EpisodeID,"!!",1)
			Set objEpisode=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Continue:'$IsObject(objEpisode)
			Set MrNo=objEpisode.PAMrNo
			Set PatID=objEpisode.PAPatientID
			Set PatName=objEpisode.PAPatName
			Set DisDate=objEpisode.PADischDate
			Set:DisDate'="" DisDate=$zd(DisDate,3)
			Set QCInDateT=$zd(MrListObj.QCInDate,3)_" "_$zt(MrListObj.QCInTime)
			Set QCEntityMsg="["_QCEntityDesc_"] <b>姓名:</b>"_PatName_"  <b>病案号:</b>"_MrNo_"  <b>入单日期:</b>"_QCInDateT

			Set Data=$lb(xRowID,QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID,QCEntityMsg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	Quit $$$OK
}

ClassMethod QryQCMrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCMrListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCMrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCMrListExecute ]
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

/// 住院单病种病种查询
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCMrListByDate","UpQC","2020-02-22","2022-03-01","","2!!1","","","","")
Query QryQCMrListByDate(aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aMrNo As %String = "") As %Query(ROWSPEC = "RowID:%String,QCEntityID:%String,QCEntityDesc:%String,QCCurrStatus:%String,QCCurrStatusDesc:%String,MrNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,QCInDateT:%String,EpisodeID:%String,ExcludeInfo:%String,DocName:%String,PatID:%String,LocDesc:%String,ECount:%Integer,ACount:%Integer,NCount:%Integer,QCAbbrev:%String")
{
}

ClassMethod QryQCMrListByDateExecute(ByRef qHandle As %Binary, aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aMrNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz126=$lb(aDateType,aDateFrom,aDateTo, aStatus,aHospID, aLocID  , aDocID  , aQCEntity,aMrNo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	If (aMrNo'="") {
	 	Set aMrNo=$zcvt(aMrNo,"U")
		Quit:aMrNo="" $$$OK
		Set PatientID=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(aMrNo,"I",$P(aHospID,"!!",1))
		Quit:PatientID="" $$$OK
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
			Quit:xPaadm=""
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xRowID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xRowID=""
			Set Data=..BuildMrListInfo(xRowID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}elseif(aDateType="InEntiy"){
		//按入组日期查询
	 	Set xInDate=aDateFrom-1
	 	For
	 	{
		 	Set xInDate = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate))
		 	Quit:xInDate=""
		 	Quit:xInDate>aDateTo
		 	Set xRowID=""
			for {
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate,xRowID))
				Quit:xRowID=""
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				Set Data=..BuildMrListInfo(xRowID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
	 	}
	}elseif(aDateType="UpQC"){
		//按上报日期查询
	 	Set xUpDate=aDateFrom-1
	 	For
	 	{
		 	Set xUpDate = $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate))
		 	Quit:xUpDate=""
		 	Quit:xUpDate>aDateTo
		 	Set StateDr=""
		 	For {
			 	Set StateDr=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr))
			 	Quit:StateDr=""
			 	Set StateObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(StateDr)
			 	//包含测试上报和正式上报病例
			 	Continue:StateObj.BTDesc'["上报"
			 	Set xRowID=""	
			 	For {
				 	Set xRowID	= $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr,xRowID),-1)
				 	Quit:xRowID=""
					Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
					Set Data=..BuildMrListInfo(xRowID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}
		 	}
	 	}
	}else{
		//按出院日期查询
		Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //取出院时间索引
    	For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				Set Data=..BuildMrListInfo(xRowID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
    	}
	}
	Quit $$$OK
}

ClassMethod QryQCMrListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCMrListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCMrListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCMrListByDateExecute ]
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

/// 单病种上报情况监测
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCMrListCC","InHosp","2021-05-16","2021-05-20","","","","")
Query QryQCMrListCC(aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aMrNo As %String = "") As %Query(ROWSPEC = "RowID:%String,QCEntityID:%String,QCEntityDesc:%String,QCCurrStateCode:%String,QCCurrStateDesc:%String,MrNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,QCInDateT:%String,EpisodeID:%String,ExcludeInfo:%String,DocName:%String,PatID:%String,LocDesc:%String,UpLoad:%String,UpLoadYN:%String,UpLastDays:%String,OperDesc:%String,GroupInfo:%String")
{
}

ClassMethod QryQCMrListCCExecute(ByRef qHandle As %Binary, aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aMrNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz126=$lb(aDateType,aDateFrom,aDateTo, aStatus,aHospID, aLocID  , aDocID  , aQCEntity,aMrNo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	k TMPMrListCC
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	if (aDateType="InEntiy"){
		//按入组日期查询
	 	Set xInDate=aDateFrom-1
	 	For
	 	{
		 	Set xInDate = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate))
		 	Quit:xInDate=""
		 	Quit:xInDate>aDateTo
		 	Set xRowID=""
			for {
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate,xRowID))
				Quit:xRowID=""
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				d BuildMrListCC
				}	
	 	}
	}else{
		//按出院日期查询
		Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //取出院时间索引
    	For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				d BuildMrListCC
			}
    	}
	}
	Set xIdxCode=""
	For {
		Set xIdxCode=$o(TMPMrListCC(xIdxCode))
		Quit:xIdxCode=""
		Set xIdxParam=""
		For {
			Set xIdxParam=$o(TMPMrListCC(xIdxCode,xIdxParam))
			Quit:xIdxParam=""
			Set GroupInfo=""
			Set tCount=""
			Set tCount=+$g(TMPMrListCC(IndexCode,xIdxParam,"tCount"))
			Set tUpLoad=+$g(TMPMrListCC(IndexCode,xIdxParam,"tUpLoad"))
			Set tNoUpCnt=tCount-tUpLoad
			Set tUpLoadYN=+$g(TMPMrListCC(IndexCode,xIdxParam,"tUpLoadYN"))
			Set UpLast5=+$g(TMPMrListCC(IndexCode,xIdxParam,"UpLast5"))
			Set UpLast7=+$g(TMPMrListCC(IndexCode,xIdxParam,"UpLast7"))
			Set UpLast9=+$g(TMPMrListCC(IndexCode,xIdxParam,"UpLast9"))
			Set (UpRate,UpYNRate,UpL5Rate,UpL7Rate,UpL9Rate)="0%"
			Set UpRate=$fn((tUpLoad/tCount),"",2)*100_"%"				//上报率
			Set NoUpRate=$fn((tNoUpCnt/tCount),"",2)*100_"%"				//漏报率
			Set:tUpLoad>0 UpYNRate=$fn((tUpLoadYN/tUpLoad),"",2)*100_"%"			//及时率
			Set:tNoUpCnt>0 UpL5Rate=$fn((UpLast5/tNoUpCnt),"",2)*100_"%"			//5日未报
			Set:tNoUpCnt>0 UpL7Rate=$fn((UpLast7/tNoUpCnt),"",2)*100_"%"			//7日未报
			Set:tNoUpCnt>0 UpL9Rate=$fn((UpLast9/tNoUpCnt),"",2)*100_"%"			//9日未报
			Set xID=$o(TMPMrListCC(xIdxCode,xIdxParam,0))
			Continue:+xID=0
			Set rec=$g(TMPMrListCC(xIdxCode,xIdxParam,xID))
			If (xIdxCode="Doc") {
				Set name="医师-"_$lg(rec,13)	
			}elseIf(xIdxCode="Loc"){
				Set name="科室-"_$lg(rec,15)
			}elseIf(xIdxCode="QC"){
				Set name="病种-"_$lg(rec,3)
			}
			Set GroupInfo=name_"[总例数:"_tCount_"例 | 已报:"_tUpLoad_"例 | 未报:"_tNoUpCnt_"例 | 上报率:"_UpRate_"]"
			Set xMrID=""
			For {
				Set xMrID=$o(TMPMrListCC(xIdxCode,xIdxParam,xMrID))
				Quit:xMrID=""
				Continue:+xMrID<1
				Set Data=$g(TMPMrListCC(xIdxCode,xIdxParam,xMrID))
				Set ^CacheTemp(repid,ind)=Data_$lb(GroupInfo)
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK	
BuildMrListCC
	Set MrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
	Quit:'$IsObject(MrListObj) ""
	Set EpisodeID=MrListObj.QCEpisodeID
	Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set ReNo	=ObjPaadm.PAPapmiNo
	Set MrNo	=ObjPaadm.PAMrNo
	Set PatName	=ObjPaadm.PAPatName
	Set DisDate	=ObjPaadm.PADischDate
	Set AdmLoc	=ObjPaadm.PAAdmLocID
	Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
	Set LocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(AdmLoc,"U"),0))
	Quit:(LocID="") ""
	Set objLoc=##class(DHCMA.Util.EPx.Location).%OpenId(LocID)
	Set HospID=objLoc.BTHospID
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set HospOID=objHosp.OID
	Quit:(aHospID'="")&&(aHospID'=HospOID) ""
	Set InQCDocID=MrListObj.QCInDocID
	Set EpisodeID=MrListObj.QCEpisodeID
	Quit:'$IsObject(MrListObj.QCEntityDr) ""
	Set QCEntityID=MrListObj.QCEntityDr.%Id()
	Quit:(aQCEntity'="")&&(aQCEntity'=QCEntityID) ""
	Quit:(aLocID'="")&&(AdmLoc'=aLocID) ""
	Set QCEntityDesc=MrListObj.QCEntityDr.BTDesc
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xRowID,""),-1)
	Set QCCurrStatusID=xRowID_"||"_QCCurrStatusSubID
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
	Set QCCurrStateCode="I"
	Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode,QCCurrStateDesc=StatusObj.StateCode.BTDesc
	Quit:((aStatus="")&&(QCCurrStateCode="O"))
	Quit:((aStatus'["O")&&(QCCurrStateCode="O"))								//解决状态改变总例数也会改
	Set UpDate=""
	Set UpLoad=$Select(",I,Save,Submit,Check,"[(","_QCCurrStateCode_","):0,QCCurrStateCode="Up":1,1:"")
	Set:UpLoad=1 UpDate=StatusObj.StateDate
	Set ExcludeInfo="",OperResume=""
	If $d(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID)){
		Set AliasID=$o(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID,QCCurrStatusSubID,""),-1)
		Set objAlias=##class(DHCMA.CPW.SD.QCMrStateAlias).GetObjById(xRowID_"||"_QCCurrStatusSubID_"||"_AliasID)
		If ($IsObject(objAlias)){
			Set OperRule=objAlias.OperRule
			For idx=1:1:OperRule.Count(){
				Set RuleObj=OperRule.GetAt(idx)
				Continue:'$IsObject(RuleObj)
				Set Exclude=RuleObj.RuleDesc
				Continue:Exclude=""
				Set ExcludeInfo=ExcludeInfo_","_Exclude
				
			}
			Set OperResume=objAlias.OperResume
			Set:OperResume'="" ExcludeInfo=ExcludeInfo_","_OperResume
		}
		Set:ExcludeInfo'="" ExcludeInfo=$e(ExcludeInfo,2,$l(ExcludeInfo))
	}
	Set AdmObj=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set DocName=AdmObj.PAAdmDocName
	Set DocOID=AdmObj.PAAdmDocID
	Quit:(aDocID'="")&&(aDocID'=DocOID) ""
	Set MrNo=AdmObj.PAMrNo
	Set PatID=AdmObj.PAPatientID
	Set PatName=AdmObj.PAPatName
	Set DisDate=AdmObj.PADischDate
	Set AdmDate=AdmObj.PAAdmDate
	Set xDisDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(DisDate)
	Set:DisDate="" xDisDate=+$h
	//上报是否及时
	Set UpLoadYN=""
	Set:(UpLoad=1) UpLoadYN="N"
	Set:(UpLoad=1)&&((UpDate-xDisDate)<=10) UpLoadYN="Y"
	//迟报率天数
	Set UpLastDays=0
	Set:(UpLoad=0) xEndDate=+$h
	Set:(UpLoad=1) xEndDate=UpDate
	Set Holidays=##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateNum(xDisDate,xEndDate,"")
	Set UpLastDays=xEndDate-xDisDate-Holidays
	Set InDate=MrListObj.QCInDate
	Set QCInDateT=$zd(MrListObj.QCInDate,3)_" "_$zt(MrListObj.QCInTime)
	Set QCCurrStatus=QCCurrStateCode
	Set IndexCode=$s(aDocID'="":"Doc",aLocID'="":"Loc",aQCEntity'="":"QC",1:"Loc")
	Set IndexParam=$s(aDocID'="":DocOID,aLocID'="":AdmLoc,aQCEntity'="":QCEntityID,1:AdmLoc)
	Set QCEntityDesc=##class(DHCMA.CPW.SD.QCEntity).GetTranByDesc("BTDesc",QCEntityDesc)
	//Set TMPMrListCC(IndexCode,IndexParam,xRowID)=$lb(xRowID,QCEntityID,QCEntityDesc,QCCurrStateCode,QCCurrStateDesc,MrNo,PatName,AdmDate,DisDate,QCInDateT,EpisodeID,ExcludeInfo,DocName,PatID,AdmLocDesc,UpLoad,UpLoadYN,UpLastDays)
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"tCount")) TMPMrListCC(IndexCode,IndexParam,"tCount")=0
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"tUpLoad")) TMPMrListCC(IndexCode,IndexParam,"tUpLoad")=0
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"tUpLoadYN")) TMPMrListCC(IndexCode,IndexParam,"tUpLoadYN")=0
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"UpLast5")) TMPMrListCC(IndexCode,IndexParam,"UpLast5")=0
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"UpLast7")) TMPMrListCC(IndexCode,IndexParam,"UpLast7")=0
	Set:'$d(TMPMrListCC(IndexCode,IndexParam,"UpLast9")) TMPMrListCC(IndexCode,IndexParam,"UpLast9")=0
	Set TMPMrListCC(IndexCode,IndexParam,"tCount")=TMPMrListCC(IndexCode,IndexParam,"tCount")+1
	If (UpLoad=1) {
		Set TMPMrListCC(IndexCode,IndexParam,"tUpLoad")=TMPMrListCC(IndexCode,IndexParam,"tUpLoad")+1
		Set:UpLoadYN="Y" TMPMrListCC(IndexCode,IndexParam,"tUpLoadYN")=TMPMrListCC(IndexCode,IndexParam,"tUpLoadYN")+1
	}else{
		If (UpLastDays>=5)&&(UpLastDays<7) {
			Set TMPMrListCC(IndexCode,IndexParam,"UpLast5")=TMPMrListCC(IndexCode,IndexParam,"UpLast5")+1
		}elseIf (UpLastDays>=7)&&(UpLastDays<9) {
			Set TMPMrListCC(IndexCode,IndexParam,"UpLast7")=TMPMrListCC(IndexCode,IndexParam,"UpLast7")+1
		}elseIf (UpLastDays>=9) {
			Set TMPMrListCC(IndexCode,IndexParam,"UpLast9")=TMPMrListCC(IndexCode,IndexParam,"UpLast9")+1
		}
	}
	Quit:(aStatus'="")&&((","_aStatus_",")'[(","_QCCurrStateCode_",")) ""		//解决状态改变总例数也会改
	//输出填报病历的手术描述CM-0-1-4-1
	Set xItemID="",ESubID="",OperDesc=""
	Set xItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2",QCEntityID,"CM-0-1-4-1")
	Set:$IsObject(xItemObj) xItemID=xItemObj.%Id()
	Set:xItemID'="" ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",xRowID,xItemID,""),-1)
 	If (ESubID'="") { //转换显示值
 		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(xRowID_"||"_ESubID)
 		Set ExecResult=ItemExecObj.ExecResult
	 	Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCEntityID,2,"CM-0-1-4-1",$p(ExecResult,",",1))
	 	Set:$IsObject(DicItemObj) OperDesc=DicItemObj.BTDesc
	}
	Set TMPMrListCC(IndexCode,IndexParam,xRowID)=$lb(xRowID,QCEntityID,QCEntityDesc,QCCurrStateCode,QCCurrStateDesc,MrNo,PatName,AdmDate,DisDate,QCInDateT,EpisodeID,ExcludeInfo,DocName,PatID,AdmLocDesc,UpLoad,UpLoadYN,UpLastDays,OperDesc) 	//解决状态改变总例数也会改
}

ClassMethod QryQCMrListCCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCMrListCCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCMrListCCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCMrListCCExecute ]
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

/// 门诊单病种病例查询
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCOPMrListByDate","AdmDate","2010-02-22","2022-03-01","","2!!1","","","","0000003978")
Query QryQCOPMrListByDate(aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "RowID:%String,QCEntityID:%String,QCEntityDesc:%String,QCCurrStatus:%String,QCCurrStatusDesc:%String,MrNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,QCInDate:%String,EpisodeID:%String,ExcludeInfo:%String,DocName:%String,PatID:%String,LocID:%String,LocDesc:%String,ECount:%Integer,ACount:%Integer,NCount:%Integer,QCAbbrev:%String,RegNo:%String")
{
}

ClassMethod QryQCOPMrListByDateExecute(ByRef qHandle As %Binary, aDateType As %String = "", aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aDocID As %String, aQCEntity As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz126=$lb(aDateType,aDateFrom,aDateTo, aStatus,aHospID, aLocID  , aDocID  , aQCEntity,aRegNo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	k tmpAdmArr
 	If (aRegNo'="") {
	 	Set aRegNo=..RegNoCon(aRegNo)
		Quit:aRegNo="" $$$OK
		Set PatientID=$o(^PAPERi("PAPMI_PatNo",aRegNo,0))
		Quit:PatientID="" $$$OK
		Set xPaadm=""
		for {
			Set xPaadm=$o(^PAPERdr(PatientID,"ADM","O",xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="O"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set Data=$$BuildOPMrListInfo(xPaadm)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Quit $$$OK
	}elseif(aDateType="InEntiy"){
		//按入组日期查询
	 	Set xInDate=aDateFrom-1
	 	For
	 	{
		 	Set xInDate = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate))
		 	Quit:xInDate=""
		 	Quit:xInDate>aDateTo
		 	Set xMrID=""
			for {
				Set xMrID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate,xMrID))
				Quit:xMrID=""
				Set xMrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrID)
				Continue:'$IsObject(xMrListObj)
				Set xPaadm=$p(xMrListObj.QCEpisodeID,"!!",1)
				continue:$d(tmpAdmArr(xPaadm))
				Set tmpAdmArr(xPaadm)="" //一次就诊输出一条记录即可
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="O"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				Set Data=$$BuildOPMrListInfo(xPaadm)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
	 	}
	}elseif(aDateType="UpQC"){
		//按上报日期查询
	 	Set xUpDate=aDateFrom-1
	 	For
	 	{
		 	Set xUpDate = $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate))
		 	Quit:xUpDate=""
		 	Quit:xUpDate>aDateTo
		 	Set StateDr=""
		 	For {
			 	Set StateDr=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr))
			 	Quit:StateDr=""
			 	Set StateObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(StateDr)
			 	//包含测试上报和正式上报病例
			 	Continue:StateObj.BTDesc'["上报"
			 	Set xRowID	= $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr,""),-1)
			 	Continue:xRowID=""
			 	Set xMrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
				Continue:'$IsObject(xMrListObj)
				Set xPaadm=$p(xMrListObj.QCEpisodeID,"!!",1)
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="O"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID)=""
				Set Data=$$BuildOPMrListInfo(xPaadm)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				Quit
		 	}
	 	}
	}else{
		//按就诊日期查询
    	For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
			For {
				
				Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="O"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				//Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
				Set (QCEntityID,QCEntityDesc,QCCurrStatus,MrNo,PatName,DisDate,QCInDateT,EpisodeID,RegNo)=""
				Set Data=$$BuildOPMrListInfo(xPaadm)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
    	}
	}
	Quit $$$OK
BuildOPMrListInfo(xPaadm)
	Set (xRowID,QCEntityID,QCEntityDesc,QCCurrStateCode,QCCurrStateDesc,MrNo,PatName,AdmDate,DisDate,QCInDate,EpisodeID,ExcludeInfo,DocName,PatID,AdmLoc,AdmLocDesc,ECount,ACount,NCount,QCAbbrev,RegNo)=""
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
	Set xRowID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
	Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set RegNo	= ObjPaadm.PAPapmiNo
	Set MrNo	= ObjPaadm.PAMrNo
	Set PatName	= ObjPaadm.PAPatName
	Set PatID	= ObjPaadm.PAPatientID
	Set AdmDate	= ObjPaadm.PAAdmDate
	Set DisDate	= ObjPaadm.PADischDate
	Set AdmLoc	= ObjPaadm.PAAdmLocID
	Set AdmLocDesc = ObjPaadm.PAAdmLocDesc
	Set DocName=ObjPaadm.PAAdmDocName
	Set DocOID=ObjPaadm.PAAdmDocID
	Quit:(aDocID'="")&&(aDocID'=DocOID) ""
	Set LocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(AdmLoc,"U"),0))
	Quit:(LocID="") ""
	Set objLoc=##class(DHCMA.Util.EPx.Location).%OpenId(LocID)
	Set HospID=objLoc.BTHospID
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set HospOID=objHosp.OID
	Set aHospID=$g(aHospID)
	Set aLocID=$g(aLocID)
	Set aQCEntity=$g(aQCEntity)
	Set aStatus=$g(aStatus)
	Set aDocID=$g(aDocID)
	Quit:(aHospID'="")&&(aHospID'=HospOID) ""
	Quit:(aLocID'="")&&(AdmLoc'=aLocID) ""
	If (xRowID'="") {
		Set MrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
		Quit:'$IsObject(MrListObj) ""
		Set InQCDocID=MrListObj.QCInDocID
		Set EpisodeID=MrListObj.QCEpisodeID
		Quit:'$IsObject(MrListObj.QCEntityDr) ""
		Set QCEntityID=MrListObj.QCEntityDr.%Id()
		Quit:(aQCEntity'="")&&((","_aQCEntity_",")'[(","_QCEntityID_",")) ""
		Set QCEntityDesc=MrListObj.QCEntityDr.BTDesc
		Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xRowID,""),-1)
		Set QCCurrStatusID=xRowID_"||"_QCCurrStatusSubID
		Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
		Set QCCurrStateCode="I",QCCurrStateDesc="已确认"
		Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode,QCCurrStateDesc=StatusObj.StateCode.BTDesc
		Quit:(aStatus'="")&&((","_aStatus_",")'[(","_QCCurrStateCode_",")) ""
		Set ExcludeInfo="",OperResume=""
		If $d(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID)){
			Set AliasID=$o(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID,QCCurrStatusSubID,""),-1)
			Set objAlias=##class(DHCMA.CPW.SD.QCMrStateAlias).GetObjById(xRowID_"||"_QCCurrStatusSubID_"||"_AliasID)
			If ($IsObject(objAlias)){
				Set OperRule=objAlias.OperRule
				For idx=1:1:OperRule.Count(){
					Set RuleObj=OperRule.GetAt(idx)
					Continue:'$IsObject(RuleObj)
					Set Exclude=RuleObj.RuleDesc
					Continue:Exclude=""
					Set ExcludeInfo=ExcludeInfo_","_Exclude
					
				}
				Set OperResume=objAlias.OperResume
				Set:OperResume'="" ExcludeInfo=ExcludeInfo_","_OperResume
			}
			Set:ExcludeInfo'="" ExcludeInfo=$e(ExcludeInfo,2,$l(ExcludeInfo))
			Set QCInDate=$zd(MrListObj.QCInDate,3)
			Set QCCurrStatus=QCCurrStateCode
			//增加自动采集率和填报率
			Set ECount=MrListObj.ECount
			Set ACount=MrListObj.ACount
			Set NCount=MrListObj.NCount
			Set QCAbbrev=MrListObj.QCEntityDr.BTAbbrev
		}
	}
	Set ExcludeInfo=$tr(ExcludeInfo," ","")
	Set Data=$lb(xRowID,QCEntityID,QCEntityDesc,QCCurrStateCode,QCCurrStateDesc,MrNo,PatName,AdmDate,DisDate,QCInDate,EpisodeID,ExcludeInfo,DocName,PatID,AdmLoc,AdmLocDesc,ECount,ACount,NCount,QCAbbrev,RegNo)
	Quit Data
	quit ""
}

ClassMethod QryQCOPMrListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCOPMrListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCOPMrListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCOPMrListByDateExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryPatientByDate","","","","1004881","","")
Query QryPatientByDate(aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLoc As %String = "", aMrNo As %String = "", aRegNo As %String = "", aPatName As %String = "", StaType As %String = "C") As %Query(ROWSPEC = "EpisodeID:%String,MrNo:%String,ReNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,FPMDiag:%String,ClinMDiag:%String,MrListID:%String,QCEntityDesc:%String,QCCurrStatus:%String,AdmLocDesc:%String,AdmLoc:%String,PatientID:%String")
{
}

ClassMethod QryPatientByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String = "", aLoc As %String = "", aMrNo As %String = "", aRegNo As %String = "", aPatName As %String = "", StaType As %String = "C") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz319=$lb(aDateFrom,aDateTo, aLoc,aMrNo, aRegNo  , aPatName ,StaType)
 	//Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	If aMrNo'="" {
			Set aMrNo=$zcvt(aMrNo,"U")
			Quit:aMrNo="" $$$OK
			Set PatientIDStr=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(aMrNo,"I","2")
			Quit:PatientIDStr="" $$$OK
			For xPatInd=1:1:$l(PatientIDStr,",") {
				Set PatientID=$p(PatientIDStr,",",xPatInd)
				Continue:PatientID=""
				Set xPaadm=""
				for {
					Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
					Quit:xPaadm=""
					
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					Set Data=$$BuildAdmInfo(xPaadm)
					Continue:Data="" 
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	} ElseIf aRegNo'="" {
			Set aRegNo=..RegNoCon(aRegNo)
			Quit:aRegNo="" 
			Set PatientID=$o(^PAPERi("PAPMI_PatNo",aRegNo,0))
			Quit:PatientID="" 
			Set xPaadm=""
			for {
				Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set Data=$$BuildAdmInfo(xPaadm)
				Continue:Data="" 
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
	} ElseIf aPatName'="" {		
		Set PatientID=""
		for {
			Set PatientID=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(aPatName),PatientID))
			Quit:PatientID=""
			Set xPaadm=""
			for {
				Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Set Data=$$BuildAdmInfo(xPaadm)
				Continue:Data="" 
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}				
		}
		Set PatName=aPatName
		for {
			Set PatName=$o(^PAPERi("PAPER_PatName",PatName))
			q:(PatName="")
			continue:PatName'[aPatName
			Set PatientID=""
			for {
				Set PatientID=$o(^PAPERi("PAPER_PatName",PatName,PatientID))
				Quit:PatientID=""
				Set xPaadm=""
				for {
					Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					Set Data=$$BuildAdmInfo(xPaadm)
					Continue:Data="" 
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}				
				}
		}
	}else{
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		if (StaType="C") {
			Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	    	For xDate=aDateFrom:1:aDateTo {
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					Set Data=$$BuildAdmInfo(xPaadm)
					Continue:Data="" 
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
	    	}
		}elseif(StaType="A"){
			For xDate=aDateFrom:1:aDateTo {
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					//Continue:$p(AdmInfo,"^",17)'=""           //出院日期过滤
					
					Set Data=$$BuildAdmInfo(xPaadm)
					Continue:Data="" 
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
	    	}
		}	
	}
	Quit $$$OK
BuildAdmInfo(xPaadm)
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
	Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set ReNo	=ObjPaadm.PAPapmiNo
	Set MrNo	=ObjPaadm.PAMrNo
	Set PatName	=ObjPaadm.PAPatName
	Set AdmDate=ObjPaadm.PAAdmDate
	Set DisDate	=ObjPaadm.PADischDate
	i ((StaType="A") && (DisDate'="")) Quit ""
	i ((StaType="C") && (DisDate="")) Quit ""
	Set AdmLoc	=ObjPaadm.PAAdmLocID
	Set LocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(AdmLoc,"U"),0))
	Quit:(LocID="") ""
	Set objLoc=##class(DHCMA.Util.EPx.Location).%OpenId(LocID)
	Set HospID=objLoc.BTHospID
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set HospOID=objHosp.OID
	Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
	Quit:(aHospID'="")&&(aHospID'=HospOID) ""
	Quit:(aLoc'="")&&(aLoc'=AdmLoc) ""
	Quit:(aMrNo'="")&&(aMrNo'=MrNo) ""
	Quit:(aRegNo'="")&&(aRegNo'=ReNo) ""
	Quit:(aPatName'="")&&(aPatName'=PatName) ""
	if AdmLocDesc="" {
		Set LocID=$p(AdmLoc,"!!",1)
		Set AdmLocDesc=$p($g(^CTLOC(LocID)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	}
	Quit:(aLoc'="")&&(aLoc'=AdmLoc) ""
	//取编目主诊断
	Set MDiagStr=##class(DHCMA.CPW.SDS.IO.GetDataSrv).GetFrontPageICD(xPaadm,"D/1",1)
	Set FPMDiag	=$p(MDiagStr,$c(2),2)
	Set FPMDiag=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",FPMDiag)
	//取临床主诊断
	Set (ClinMDiag,OutDiag)=""
	Set MRAdm=$p($g(^PAADM(+xPaadm)),"^",61)
	Set xDiagnosID=0
	For {
		Set xDiagnosID=$o(^MR(MRAdm,"DIA",xDiagnosID))
		Quit:xDiagnosID=""
		Set tmpDiagnos=$g(^MR(MRAdm,"DIA",xDiagnosID))
		Set ICDDxID=$p(tmpDiagnos,"^",1)
		Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
		Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
		Set ICDDesc=$tr(ICDDesc," ","")
		Set DesID=$o(^MR(MRAdm,"DIA",xDiagnosID,"DES",0))
		Set:DesID="" DesID=1
		Set ICDDHC=$g(^MR(MRAdm,"DIA",xDiagnosID,"DHC",DesID))
		Set ICDDES=$g(^MR(MRAdm,"DIA",xDiagnosID,"DES",DesID))
		Set MRDiagType=$o(^MR(MRAdm,"DIA",xDiagnosID,"TYP",0))
		Set TypeDesc=""
		If MRDiagType'="" {
			Set TypeDicID=$g(^MR(MRAdm,"DIA",xDiagnosID,"TYP",MRDiagType))
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 			//诊断类型
		}
		If (TypeDesc["主要")||($p($g(^MR(MRAdm,"DIA",xDiagnosID,1)),"^",20)="Y") {
			Set ClinMDiag=ICDDesc
			Set:ClinMDiag="" ClinMDiag=ICDDHC_" "_ICDDES
			Set ClinMDiag=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ClinMDiag)
			Quit
		}elseIf (TypeDesc["出院") {
			Set OutDiag=ICDDesc
			Set:OutDiag="" OutDiag=ICDDHC_" "_ICDDES
			Set OutDiag=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",OutDiag)
		}
	}
	//如果临床录入主诊断为空，向后取出院诊断
	Set:ClinMDiag="" ClinMDiag=OutDiag	
	Set QCEntityDesc="",QCCurrStatus=""
	Set MrListID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
	if (MrListID'=""){
		Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
		Set QCEntityDesc=MrListObj.QCEntityDr.BTDesc
		Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrListID,""),-1)
		Set QCCurrStatusID=MrListID_"||"_QCCurrStatusSubID
		Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
		Set QCCurrStatus="已确认"			
		Set:$IsObject(StatusObj) QCCurrStatus=StatusObj.StateCode.BTDesc
		}
	//新增病人id
	Set PatientID = ObjPaadm.PAPatientID
	Set AdmLocDesc=$tr(AdmLocDesc," ","")
	Set AdmLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLocDesc)
	Set QCEntityDesc=##class(DHCMA.CPW.SD.QCEntity).GetTranByDesc("BTDesc",QCEntityDesc)
	Set data=$lb(EpisodeID,MrNo,ReNo,PatName,AdmDate,DisDate,FPMDiag,ClinMDiag,MrListID,QCEntityDesc,QCCurrStatus,AdmLocDesc,AdmLoc,PatientID)
	Quit data
}

ClassMethod QryPatientByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatientByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatientByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatientByDateExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCSumByDate","","","","","","","","","Month","last12month","")
Query QryQCSumByDate(aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aHospID As %String = "", aLocID As %String = "", aDocID As %String = "", aQCEntity As %String = "", aTypeDimens As %String = "", aTimeDimens As %String = "", aMrlistIDs As %String = "") As %Query(ROWSPEC = "DimensCode:%String,DimensDesc:%String,Count:%Integer,List:%String")
{
}

ClassMethod QryQCSumByDateExecute(ByRef qHandle As %Binary, aDateType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aStatus As %String = "", aHospID As %String = "", aLocID As %String = "", aDocID As %String = "", aQCEntity As %String = "", aTypeDimens As %String = "", aTimeDimens As %String = "", aMrlistIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s ^tmpzgz126=$lb(aDateType,aDateFrom,aDateTo, aStatus,aHospID, aLocID,aDocID,aQCEntity,aTypeDimens,aTimeDimens,aMrlistIDs)
 	If (aTimeDimens'="") {
	 	Set aDateType="UpQC"  //上报数据，时间类型默认为上报日期
	 	Set aDateFromTo=##class(DHCMA.Util.IO.CommonSrv).GetCurDimSEDate(aTimeDimens)
	 	Set aDateFrom=$p(aDateFromTo,"^",1)
	 	Set aDateTo=$p(aDateFromTo,"^",2)
 	}
 	Quit:((aDateFrom="")||(aDateTo=""))&&(aMrlistIDs="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	k tmpQryQCSumArr
	if (aMrlistIDs'="") {
		For i=1:1:$l(aMrlistIDs,",") {
			Set xRowID=$p(aMrlistIDs,",",i)
			Continue:xRowID=""
			d BuildQCSumData
		}
	}elseif (aDateType="InEntity"){
		//按入组日期查询
	 	Set xInDate=aDateFrom-1
	 	For
	 	{
		 	Set xInDate = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate))
		 	Quit:xInDate=""
		 	Quit:xInDate>aDateTo
		 	Set xRowID=""
			for {
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexInDate",xInDate,xRowID))
				Quit:xRowID=""
				d BuildQCSumData
			}	
	 	}
	}elseif(aDateType="UpQC"){
		//按上报日期查询
	 	Set xUpDate=aDateFrom-1
	 	For
	 	{
		 	Set xUpDate = $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate))
		 	Quit:xUpDate=""
		 	Quit:xUpDate>aDateTo
		 	Set StateDr=""
		 	For {
			 	Set StateDr=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr))
			 	Quit:StateDr=""
			 	Set StateObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(StateDr)
			 	//包含测试上报和正式上报病例
			 	Continue:StateObj.BTDesc'["上报"
			 	Set xRowID	= $o(^DHCMA.CPW.SD.QCMrListStateI("IndexDateState",xUpDate,StateDr,""),-1)
			 	Continue:xRowID=""
				d BuildQCSumData
				Quit
			}
	 	}
	}else{
		//按出院日期查询
		Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //取出院时间索引
    	For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
				Set xRowID = $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
				d BuildQCSumData
				
			}
    	}
	}
	//输出上报数量各统计维度数据
	Set xDimensCode=""
	For {
		Set xDimensCode	= $o(tmpQryQCSumArr(xDimensCode))
		Quit:xDimensCode=""
		Set AliasList	= $g(tmpQryQCSumArr(xDimensCode,"alias"))
		Set DimensDesc	= $g(tmpQryQCSumArr(xDimensCode,"Desc"))
		Set AliasCount	= $ll(AliasList)
		Set AliasList	= $lts(AliasList,",")
		Set Data=$lb(xDimensCode,DimensDesc,AliasCount,AliasList)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
BuildQCSumData
	Set MrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
	Quit:'$IsObject(MrListObj)
	Set EpisodeID=MrListObj.QCEpisodeID
	Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set aHospID=$g(aHospID)
	Set aLocID=$g(aLocID)
	Set aQCEntity=$g(aQCEntity)
	Set aStatus=$g(aStatus)
	Set aDocID=$g(aDocID)
	Set AdmLoc	=ObjPaadm.PAAdmLocID
	Set LocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(AdmLoc,"U"),0))
	Quit:(LocID="") ""
	Set objLoc=##class(DHCMA.Util.EPx.Location).%OpenId(LocID)
	Set HospID=objLoc.BTHospID
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set HospOID=objHosp.OID
	Quit:(aHospID'="")&&(aHospID'=HospOID) ""
	Quit:(aLocID'="")&&(AdmLoc'=aLocID) ""
	Set DocOID=ObjPaadm.PAAdmDocID
	Quit:(aDocID'="")&&(aDocID'=DocOID) ""
	Quit:'$IsObject(MrListObj.QCEntityDr) ""
	Set QCEntityID=MrListObj.QCEntityDr.%Id()
	Quit:(aQCEntity'="")&&(aQCEntity'=QCEntityID) ""
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xRowID,""),-1)
	Set QCCurrStatusID=xRowID_"||"_QCCurrStatusSubID
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
	Set QCCurrStateCode="I"
	If $IsObject(StatusObj) {
		Set QCCurrStateCode=StatusObj.StateCode.BTCode
		Set QCCurrStateDesc=StatusObj.StateCode.BTDesc
		Set StateDate=StatusObj.StateDate
	}
	Quit:(aStatus'="")&&((","_aStatus_",")'[(","_QCCurrStateCode_",")) ""
	
	Set QCAbbrev=MrListObj.QCEntityDr.BTAbbrev
	//根据查询条件维度，决定展现列内容
	
	If (aTypeDimens="Loc") {
		Set DimensCode=AdmLoc
		Set DimensDesc=ObjPaadm.PAAdmLocDesc
	}elseif(aTypeDimens="Doc"){
		Set DimensCode=DocOID
		Set DimensDesc=ObjPaadm.PAAdmDocName
	}elseif(aTypeDimens="Month"){
		//根据上报日期  确定所属月份维度
		Set FormatDate=$zd(StateDate,3)
		Set Month=$p(FormatDate,"-",2)
		Set DimensCode=$p(FormatDate,"-",1)_Month
		Set DimensDesc=$p(FormatDate,"-",1)_"年"_+Month_"月"
	}else{
		Set DimensCode=QCAbbrev
		Set DimensDesc=MrListObj.QCEntityDr.BTDesc
	}
	Set:DimensCode="" DimensCode=999
	Set:DimensDesc="" DimensDesc="未知"
	Set tmpQryQCSumArr(DimensCode,"Desc")=DimensDesc
	if ($lf($g(tmpQryQCSumArr(DimensCode,"alias")),xRowID)<1) {
		Set tmpQryQCSumArr(DimensCode,"alias")=$g(tmpQryQCSumArr(DimensCode,"alias"))_$lb(xRowID)
	}
	Quit $$$OK
}

ClassMethod QryQCSumByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCSumByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCSumByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCSumByDateExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryMrInfoByIDs","12,13")
Query QryMrInfoByIDs(aMrIDStr As %String) As %Query(ROWSPEC = "RowID:%String,QCEntityID:%String,QCEntityDesc:%String,QCCurrStatus:%String,QCCurrStatusDesc:%String,MrNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,QCInDateT:%String,EpisodeID:%String,ExcludeInfo:%String,DocName:%String,PatID:%String,LocDesc:%String,ECount:%Integer,ACount:%Integer,NCount:%Integer,QCAbbrev:%String")
{
}

ClassMethod QryMrInfoByIDsExecute(ByRef qHandle As %Binary, aMrIDStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aMrIDStr="" $$$OK
	Set IDLength=$l(aMrIDStr,",")
	For i=1:1:IDLength {
		Set MrID=$p(aMrIDStr,",",i)
		Continue:MrID=""
		Set Data=..BuildMrListInfo(MrID)	
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMrInfoByIDsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMrInfoByIDsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMrInfoByIDsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMrInfoByIDsExecute ]
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

/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).BuildMrListInfo(13)
ClassMethod BuildMrListInfo(xRowID) As %Library.List
{
	Set MrListObj= ##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
	Quit:'$IsObject(MrListObj) ""
	Set EpisodeID=MrListObj.QCEpisodeID
	Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Quit:ObjPaadm.PAAdmType'="I" "" //只输出住院单病种病例
	Set ReNo		= ObjPaadm.PAPapmiNo
	Set MrNo		= ObjPaadm.PAMrNo
	Set PatID		= ObjPaadm.PAPatientID
	Set PatName		= ObjPaadm.PAPatName
	Set AdmDate 	= ObjPaadm.PAAdmDate
	Set DisDate		= ObjPaadm.PADischDate
	Set AdmLoc		= ObjPaadm.PAAdmLocID
	Set AdmLocDesc	= ObjPaadm.PAAdmLocDesc
	Set DocName		= ObjPaadm.PAAdmDocName
	Set DocOID		= ObjPaadm.PAAdmDocID
	Quit:(aDocID'="")&&(aDocID'=DocOID) ""
	Set LocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(AdmLoc,"U"),0))
	Quit:(LocID="") ""
	Set objLoc=##class(DHCMA.Util.EPx.Location).%OpenId(LocID)
	Set HospID=objLoc.BTHospID
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
	Set HospOID=objHosp.OID
	Set aHospID=$g(aHospID)
	Set aLocID=$g(aLocID)
	Set aQCEntity=$g(aQCEntity)
	Set aStatus=$g(aStatus)
	Set aDocID=$g(aDocID)
	Quit:(aHospID'="")&&(aHospID'=HospOID) ""
	Quit:(aLocID'="")&&(AdmLoc'=aLocID) ""
	Set InQCDocID=MrListObj.QCInDocID
	Set EpisodeID=MrListObj.QCEpisodeID
	Quit:'$IsObject(MrListObj.QCEntityDr) ""
	Set QCEntityID=MrListObj.QCEntityDr.%Id()
	Quit:(aQCEntity'="")&&((","_aQCEntity_",")'[(","_QCEntityID_",")) ""
	Set QCEntityDesc=MrListObj.QCEntityDr.BTDesc
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xRowID,""),-1)
	Set QCCurrStatusID=xRowID_"||"_QCCurrStatusSubID
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
	Set QCCurrStateCode="I",QCCurrStateDesc="已确认"
	Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode,QCCurrStateDesc=StatusObj.StateCode.BTDesc
	Quit:((aStatus="")&&(QCCurrStateCode="O")) ""
	Quit:(aStatus'="")&&((","_aStatus_",")'[(","_QCCurrStateCode_",")) ""
	Set ExcludeInfo="",OperResume=""
	If $d(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID)){
		Set AliasID=$o(^DHCMA.CPW.SD.QCMrStateAliasI("IndexParref",xRowID,QCCurrStatusSubID,""),-1)
		Set objAlias=##class(DHCMA.CPW.SD.QCMrStateAlias).GetObjById(xRowID_"||"_QCCurrStatusSubID_"||"_AliasID)
		If ($IsObject(objAlias)){
			Set OperRule=objAlias.OperRule
			For idx=1:1:OperRule.Count(){
				Set RuleObj=OperRule.GetAt(idx)
				Continue:'$IsObject(RuleObj)
				Set Exclude=RuleObj.RuleDesc
				Continue:Exclude=""
				Set ExcludeInfo=ExcludeInfo_","_Exclude
				
			}
			Set OperResume=objAlias.OperResume
			Set OperResume=$p(OperResume,":",1)
			Set:OperResume'="" ExcludeInfo=ExcludeInfo_","_OperResume
		}
		Set:ExcludeInfo'="" ExcludeInfo=$e(ExcludeInfo,2,$l(ExcludeInfo))
	}
	Set InDate=MrListObj.QCInDate
	Set QCInDateT=$zd(MrListObj.QCInDate,3)_" "_$zt(MrListObj.QCInTime)
	Set QCCurrStatus=QCCurrStateCode
	//增加自动采集率和填报率
	Set ECount=MrListObj.ECount
	Set ACount=MrListObj.ACount
	Set NCount=MrListObj.NCount
	Set QCAbbrev=MrListObj.QCEntityDr.BTAbbrev
	Set Data=$lb(xRowID,QCEntityID,QCEntityDesc,QCCurrStateCode,QCCurrStateDesc,MrNo,PatName,AdmDate,DisDate,QCInDateT,EpisodeID,ExcludeInfo,DocName,PatID,AdmLocDesc,ECount,ACount,NCount,QCAbbrev)
	Quit Data
}

ClassMethod RegNoCon(aPapmiNo As %String) As %String
{
	New (aPapmiNo)
	Set return=""
	Quit:aPapmiNo="" return
	
	Set len=8
	Set PATCFid=$o(^CF("PATCF",""))
	Set:PATCFid'="" len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	Set $p(return,"0",len-$l(aPapmiNo)+1)=aPapmiNo
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetMrListInfoByCPID(526)
ClassMethod GetMrListInfoByCPID(CPID As %String) As %String
{
	new (CPID)
	Set return=""
	Quit:'$d(^DHCMA.CPW.SD.QCMrListI("IndexCPID",CPID)) return
	Set MrListID=$o(^DHCMA.CPW.SD.QCMrListI("IndexCPID",CPID,""),-1)
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
	Set QCEntiyDesc=MrListObj.QCEntityDr.BTDesc
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrListID,""),-1)
	Set QCCurrStatusID=MrListID_"||"_QCCurrStatusSubID
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
	Set QCCurrStateDesc=""
	Set:$IsObject(StatusObj) QCCurrStateDesc=StatusObj.StateCode.BTDesc
	Set EpisodeID=MrListObj.QCEpisodeID
	Set AdmObj=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
	Set MrNO=AdmObj.PAMrNo
	Set PatName=AdmObj.PAPatName
	Set DishDate=AdmObj.PADischDate
	Set:DishDate'="" DishDate=$zd(DishDate,3)
	Set sum="病种名称："_QCEntiyDesc_" /病案号："_MrNO_" /姓名："_PatName_" /出院日期："_DishDate_" /报告状态："_QCCurrStateDesc
	Set return=MrListID_"^"_sum
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetQCIDByMrListID(19)
ClassMethod GetQCIDByMrListID(aMrListID As %String) As %String
{
	n (aMrListID)
	Set return=0
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrListObj) return
	Set return=MrListObj.QCEntityDr.%Id()
	Quit return
}

/// 获取病例表单ID以及表单当前版本
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetQCInfoByMrListID(41)
ClassMethod GetQCInfoByMrListID(aMrListID As %String) As %String
{
	n (aMrListID)
	Set return=0
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrListObj) return
	Set QCID=MrListObj.QCEntityDr.%Id()
	Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
	Set return=QCID_"^"_VerID
	Quit return
}

/// 获取病例表单当前状态
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetStatusByMrListID(14)
ClassMethod GetStatusByMrListID(aMrListID As %String) As %String
{
	n (aMrListID)
	Set (QCCurrStatusCode,QCCurrStatus)=""
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrListObj) return
	Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",aMrListID,""),-1)
	Set QCCurrStatusID=aMrListID_"||"_QCCurrStatusSubID
	Set QCCurrStatusCode="I",QCCurrStatus="已确认"
	Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)			
	Set:$IsObject(StatusObj) QCCurrStatusCode=StatusObj.StateCode.BTCode,QCCurrStatus=StatusObj.StateCode.BTDesc
	Set return=QCCurrStatusCode_"^"_QCCurrStatus
	Quit return
}

/// 获取病例历史版本（一份病例最多一份历史表单）
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetOldFormVer(41)
ClassMethod GetOldFormVer(aMrListID As %String, aVerID As %String) As %String
{
	n (aMrListID,aVerID)
	Set return=0
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrListObj) return
	Set QCID=MrListObj.QCEntityDr.%Id()
	Set:aVerID="" aVerID=MrListObj.QCEntityDr.BTVersion.%Id()
	Set xVerID="",OldVerID=""
	For {
		Set xVerID	= $o(^DHCMA.CPW.SD.QCEntityVersionD(xVerID))
	 	Quit:xVerID=""
	 	Continue:xVerID>=aVerID
	 	Quit:OldVerID'=""
	 	//获取填写项目
	 	Set xItemCode=""
	 	For {
	 		Set xItemCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",xVerID,xItemCode))
	 		Quit:(xItemCode="")||(OldVerID'="")
			Set xSub=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",xVerID,xItemCode,QCID,0))
			Set ItemID=QCID_"||"_xSub
			Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,ItemID,""),-1)
	 		Continue:ESubID=""
	 		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
	 		Set OldVerID=ItemObj.BTVersion.%Id()
	 	}
	}
	Quit OldVerID
}

/// 获取患者基本信息
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetAdmInfoByMrListID(14)
ClassMethod GetAdmInfoByMrListID(aMrListID As %String) As %String
{
	n (aMrListID)
	Set return=0
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrListObj) return
	Set AdmOID=MrListObj.QCEpisodeID
	Set AdmObj=##class(DHCMA.Util.EP.Episode).xGetByOID(AdmOID)
	Set paadm=$p(AdmObj.OID,"!!",1)
	Set PatID=AdmObj.PAPatientID
	Set return=paadm_"^"_PatID
	Quit return
}

/// 导入、记录已上报单病种患者病案号
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).ImportUpMrNo(14)
ClassMethod ImportUpMrNo(aMrNo As %String, aDishDate As %String, aQCCode As %String) As %String
{
	n (aMrNo,aDishDate,aQCCode)
	Set return=0
	Quit:$d(^tmpUpMrNo(aMrNo,aDishDate,aQCCode)) return
	Set ^tmpUpMrNo(aMrNo,aDishDate,aQCCode)=""
	Quit 9
}

/// 自动识别已筛选病例，匹配已上报的 将其排除
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).SynUpByMrNo("")
ClassMethod SynUpByMrNo(aMrNo) As %String
{
	n (aMrNo)
	Set return=0,aHospID="",Count=0
	Quit:(aMrNo'="")&&('$d(^tmpUpMrNo(aMrNo))) return
	Set xMrNo=""
	For {
		Set xMrNo=$o(^tmpUpMrNo(xMrNo))	
		Quit:xMrNo=""
		Set MrNo=$zcvt(xMrNo,"U")
		Continue:(aMrNo'="")&&(aMrNo'=MrNo)
		If ($l(MrNo="7")) {
			Set PatientID=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,"I","")
			
		}else {
			Set aRegNo=..RegNoCon(MrNo)
			Quit:aRegNo="" 
			Set PatientID=$o(^PAPERi("PAPMI_PatNo",aRegNo,0))
		}
		Continue:PatientID=""
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAPERdr(PatientID,"ADM","I",xPaadm))
			Quit:xPaadm=""
			Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Set xRowID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:xRowID=""
			Set xMrObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xRowID)
			Continue:'$IsObject(xMrObj)
			Continue:xMrObj.QCState'="I"
			Set QCEpisodeID=xMrObj.QCEpisodeID
			Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(QCEpisodeID)
			Continue:'$IsObject(objPaadm)
			Set DishDate=objPaadm.PADischDate
			Continue:DishDate=""
			Set DishDate=$zd(DishDate,3)
			//判定当前病案号 出院日期 病种节点下是否有国网上报信息
			Continue:'$d(^tmpUpMrNo(xMrNo,DishDate,QCAbbrev))
			Set xStr=xRowID_"^Up^9^^匹配国家网上报数据成功"
			Set ret=##class(DHCMA.CPW.SDS.QCMrListStateSrv).ChangeMrlistSatus(xStr)
			Set Count=Count+1
			w xMrNo_":更新上报状态成功",!
		}
	}
	Quit Count
}

/// 初始化单病种填报项目值以及填报情况汇总
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).InitMrListALL(58)
ClassMethod InitMrListALL(aMrListID As %String) As %String
{
	n (aMrListID)
	Set return=0
	//通过查询Query 初始化项目值以及更新项目填报情况
	d ##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMA.CPW.SDS.QCItemExecSrv","QryQCItemExec",aMrListID)
	Quit $$$OK
}

/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).BuildRepInfo()
/// todayRep 当日上报   monthRep 本月上报  quarterRep 季度上报  yearRep 本年上报  totalRep 累积上报
/// readyRep 待填报		readyCheck 待审核	readyUp 待上传	back 退回报告
/// donotRep7 7日未报	donotRep10 十日未报 donotRep30 30日未报  donotRep90 90日未报 
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).BuildRepInfo()
ClassMethod BuildRepInfo() As %Library.List
{
	;上报 Up
	;待填报 I Save
	;待审核 Submit
	;待上传 Check tUp
	;退回 Back
	//计算本年 本季度 本月 本周 当日的起始日期
	Set curDate=+$h
	Set curWeekDate=""
	Set curMonthDate=""
	Set curQuarterDate=""
	Set curYearDate=""
	Set return=""
	Set (todayRep,monthRep,quarterRep,yearRep,totalRep)=0
	Set (readyRep,readyCheck,readyUp,back)=0
	Set (donotRep7,donotRep10,donotRep30,donotRep90)=0
	Set (todayRepLi,monthRepLi,quarterRepLi,yearRepLi,totalRepLi)=""
	Set (readyRepLi,readyCheckLi,readyUpLi,backLi)=""
	Set (donotRep7Li,donotRep10Li,donotRep30Li,donotRep90Li)=""
	Set monthSEDate=##class(DHCMA.Util.IO.CommonSrv).GetCurDimSEDate("month")
	Set monthstart=$p(monthSEDate,"^",1)
	Set monthend=$p(monthSEDate,"^",2)
	Set quarterSEDate=##class(DHCMA.Util.IO.CommonSrv).GetCurDimSEDate("quarter")
	Set quarterstart=$p(quarterSEDate,"^",1)
	Set quarterend=$p(quarterSEDate,"^",2)
	Set yearSEDate=##class(DHCMA.Util.IO.CommonSrv).GetCurDimSEDate("year")
	Set yearstart=$p(yearSEDate,"^",2)
	Set yearend=$p(yearSEDate,"^",2)
	Set SCodeList=$lb("Up","I","Save","Submit","Check","tUp","Back")
	For i=1:1:$ll(SCodeList) {
		Set code=$lg(SCodeList,i)
		Set xID=""
		For {
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexSCode",code,xID))
			Quit:xID=""
			Set EpisodeID=$lg($g(^DHCMA.CPW.SD.QCMrListD(xID)),2)
			//获取出院日期 用以计算迟报天数
			Set DischDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set:DischDate="" DischDate=+$h
			//上报病例获取上报日期，用以获取上报统计维度
			Set Update=""
			Set SubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",xID,""),-1)
			//获取最新状态操作日期
			Continue:(SubID="")&&(code'="I")
			Set operdate=$lg($g(^DHCMA.CPW.SD.QCMrListD(xID)),7) //默认入组日期			
			Set:SubID'="" operdate=$lg($g(^DHCMA.CPW.SD.QCMrListD(xID,"ChildState",SubID)),3)
			If (code="Up") {
				Set:operdate=+$h todayRep=todayRep+1,todayRepLi=todayRepLi_$lb(xID)
				Set:(operdate<monthend)&&(operdate>monthstart) monthRep=monthRep+1,monthRepLi=monthRepLi_$lb(xID)
				Set:(operdate<quarterend)&&(operdate>quarterstart) quarterRep=quarterRep+1,quarterRepLi=quarterRepLi_$lb(xID)
				Set:(operdate<yearend)&&(operdate>yearstart) yearRep=yearRep+1,yearRepLi=yearRepLi_$lb(xID)
				Set totalRep=totalRep+1
			}else{
				if ("I,Save"[code) {
					Set readyRep=readyRep+1,readyRepLi=readyRepLi_$lb(xID)
				}elseif("Check,tUp"[code) {
					Set readyUp=readyUp+1,readyUpLi=readyUpLi_$lb(xID)
				}elseif(code="Submit") {
					Set readyCheck=readyCheck+1,readyCheckLi=readyCheckLi_$lb(xID)
				}elseif(code="Back") {
					Set back=back+1,backLi=backLi_$lb(xID)
				}
				Set delaydays=+$h-DischDate
				if (delaydays>=7)&&(delaydays<10) {
					Set donotRep7=donotRep7+1,donotRep7Li=donotRep7Li_$lb(xID)
				}elseif(delaydays>=10)&&(delaydays<30) {
					Set donotRep10=donotRep10+1,donotRep10Li=donotRep10Li_$lb(xID)
				}elseif(delaydays>=30)&&(delaydays<90) {
					Set donotRep30=donotRep30+1,donotRep30Li=donotRep30_$lb(xID)
				}elseif(delaydays>=90) {
					Set donotRep90=donotRep90+1,donotRep90Li=donotRep90Li_$lb(xID)
				}
			}
		}	
	}
	Set ret1=$lts($lb(todayRep_"^"_$lts(todayRepLi),monthRep_"^"_$lts(monthRepLi),quarterRep_"^"_$lts(quarterRepLi),yearRep_"^"_$lts(yearRepLi),totalRep),"#")
	Set ret2=$lts($lb(readyRep_"^"_$lts(readyRepLi),readyCheck_"^"_$lts(readyCheckLi),readyUp_"^"_$lts(readyUpLi),back_"^"_$lts(backLi)),"#")
	Set ret3=$lts($lb(donotRep7_"^"_$lts(donotRep7Li),donotRep10_"^"_$lts(donotRep10Li),donotRep30_"^"_$lts(donotRep30Li),donotRep90_"^"_$lts(donotRep90Li)),"#")
	Set return=ret1_"#"_ret2_"#"_ret3
	Quit return
}

/// 获取病种自动填报率
/// 获取每个病种最新的自动填报率
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCARatio")
Query QryQCARatio(aqryAll As %String = "") As %Query(ROWSPEC = "QCDesc:%String,QCAbbrev:%String,ratio:%Float,mrlistID:%String")
{
}

ClassMethod QryQCARatioExecute(ByRef qHandle As %Binary, aqryAll As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xQCID=""
 	for {
	 	Set xQCID=$o(^DHCMA.CPW.SD.QCEntityD(xQCID))
	 	Quit:xQCID=""
	 	Set mrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexQCID",xQCID,""),-1)
	 	Continue:mrlistID=""
	 	Set objMrlist=##class(DHCMA.CPW.SD.QCMrList).GetObjById(mrlistID)	
	 	Set ACount=objMrlist.ACount
	 	Continue:(aqryAll="")&&(ACount=0)  								//过滤没有配置或入组的病种
	 	Set tCount=objMrlist.ECount+objMrlist.NCount
	 	Set ratio=$fn(ACount*100/tCount,"",2)
	 	Set QCDesc=objMrlist.QCEntityDr.BTDesc
	 	Set QCAbbrev=objMrlist.QCEntityDr.BTAbbrev
	 	Set ^CacheTemp(repid,ind)=$lb(QCDesc,QCAbbrev,ratio,mrlistID)
		Set ind=ind+1
	 }
	Quit $$$OK
}

ClassMethod QryQCARatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCARatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCARatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCARatioExecute ]
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

/// 获取每个病种的填报用时
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCUseTime")
Query QryQCUseTime() As %Query(ROWSPEC = "QCDesc:%String,QCAbbrev:%String,useTime:%Float,mridStr:%String,usetimeStr:%String")
{
}

ClassMethod QryQCUseTimeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xQCID=""
 	for {
	 	Set xQCID=$o(^DHCMA.CPW.SD.QCEntityD(xQCID))
	 	Quit:xQCID=""
	 	Set mrlistID="",mrlistIDs="",usetimeStr="",count=0,totalusetime=0
	 	for {
		 	Set mrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexQCID",xQCID,mrlistID),-1)
		 	Quit:mrlistID=""
		 	Set usetime=..GetMrUseTime(mrlistID)
		 	Continue:usetime=""
		 	Set count=count+1
		 	Quit:count>10  //统计病种近10份有效报告的填报用时
			Set:usetime=0 usetime=10			//	如果没记录操作用时，默认10分钟（测试阶段用）
		 	Set mrlistIDs=mrlistIDs_","_mrlistID
		 	Set usetimeStr=usetimeStr_","_usetime
		 	Set totalusetime=totalusetime+usetime
	 	}
	 	Continue:count=0
	 	Set:usetimeStr'="" usetimeStr=$e(usetimeStr,2,$l(usetimeStr))
	 	Set:mrlistIDs'="" mrlistIDs=$e(mrlistIDs,2,$l(mrlistIDs))
	 	Set avgUseTime=totalusetime\count
	 	Set objQC=##class(DHCMA.CPW.SD.QCEntity).GetObjById(xQCID)
	 	Set QCDesc=objQC.BTDesc
	 	Set QCAbbrev=objQC.BTAbbrev
	 	Set ^CacheTemp(repid,ind)=$lb(QCDesc,QCAbbrev,avgUseTime,mrlistIDs,usetimeStr)
		Set ind=ind+1
	 }
	Quit $$$OK
}

ClassMethod QryQCUseTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCUseTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCUseTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCUseTimeExecute ]
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

/// 获取报告填报总计用时
ClassMethod GetMrUseTime(aMrListID) As %String
{
	new (aMrListID)
	Set return=""
	Set objMrlist=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:"Submit,Check,tUp,Up"'[objMrlist.QCState return
 	Set subId="",usetime=0
 	for {
		Set subId=$o(^DHCMA.CPW.SD.QCMrListD(aMrListID,"ChildState",subId))
		Quit:subId=""
		Set objState=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(aMrListID_"||"_subId)
		Continue:"Save,Submit"'[objState.StateCode.BTCode  //只取保存和提交操作所用时间
		Set startdate=objState.StartDate
		Set starttime=objState.StartTime
		Continue:startdate=""			//	没有记录操作开始日期，不计算用时
		Set enddate=objState.StateDate
		Set endtime=objState.StateTime
		Set xusetime=(enddate-startdate)*24*60+(endtime-starttime)\60
		Continue:xusetime>60 			//	单次 用时超过一小时，不计为有效数据
		Set usetime=usetime+xusetime
	}
	Quit usetime
}

/// 获取表单自动填报相关数据
/// w ##class(DHCMA.CPW.SDS.QCMrListSrv).GetAutoAlias(50)
ClassMethod GetAutoAlias(aMrListID) As %String
{
	new (aMrListID)
	Set return=""
	Set objMrlist=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Set ACount=objMrlist.ACount
	Set ECount=objMrlist.ECount
	Set NCount=objMrlist.NCount
	Set tCount=ECount+NCount
	Set return=ACount_"^"_tCount_"^"_$fn(ACount*100/tCount,"",2)_"%"
	Quit return
}

/// 获取系统疾病平均费用与住院日
/// 统计病例数 aStaCnt
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCMrListSrv","QryQCSYSInfo")
Query QryQCSYSInfo(aStaCnt As %String = "10") As %Query(ROWSPEC = "QCSYSDesc:%String,AvgFee:%String,AvgDay:%String")
{
}

ClassMethod QryQCSYSInfoExecute(ByRef qHandle As %Binary, aStaCnt As %String = "10") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xQCID=""
 	for {
	 	Set xQCID=$o(^DHCMA.CPW.SD.QCEntityD(xQCID))
	 	Quit:xQCID=""
	 	Set mrlistID="",count=0
	 	for {
		 	Set mrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexQCID",xQCID,mrlistID),-1)
		 	Quit:mrlistID=""
		 	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(mrlistID)
		 	Continue:MrListObj.QCState="O"
		 	Set count=count+1
		 	Quit:count>aStaCnt  								//默认统计病种近10份有效报告的平均费用与住院日
		 	Set EpisodeID=MrListObj.QCEpisodeID
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
		 	Set QCSys=MrListObj.QCEntityDr.BTEntityCat.BTDesc
			Set:QCSys="" QCSys="未分类疾病"
			Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ObjPaadm.PADischDate)
			Set PAAdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ObjPaadm.PAAdmDate)
			Set:DischDate="" DischDate=+$h
			Set HospDays=DischDate-PAAdmDate
			Set:HospDays<1 HospDays=1
			//获取单病种表单上的住院总费用
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			Set QCID=MrListObj.QCEntityDr.%Id()
			Set tSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," CM-6-1",QCID,0))
			Set ItemID=QCID_"||"_tSubID
			Set ItemInfo=##class(DHCMA.CPW.SDS.QCItemExecSrv).GetItemInfo(mrlistID,ItemID)
			Set HospCost=$p(ItemInfo,"^",3)
			Set tmpQryQCSYSInfo(QCSys,"Fee")=$g(tmpQryQCSYSInfo(QCSys,"Fee"))+HospCost
			Set tmpQryQCSYSInfo(QCSys,"Days")=$g(tmpQryQCSYSInfo(QCSys,"Days"))+HospDays
			Set tmpQryQCSYSInfo(QCSys,"Cnt")=$g(tmpQryQCSYSInfo(QCSys,"Cnt"))+1
	 	}
 	}
	//输出相关系统疾病的费用与住院日
	Set xSDSYSDesc=""
	For {
		Set xSDSYSDesc	= $o(tmpQryQCSYSInfo(xSDSYSDesc))
		Quit:xSDSYSDesc=""
		Set totalFee	= $g(tmpQryQCSYSInfo(xSDSYSDesc,"Fee"))
		Set totalDays	= $g(tmpQryQCSYSInfo(xSDSYSDesc,"Days"))
		Set totalCnt	= $g(tmpQryQCSYSInfo(xSDSYSDesc,"Cnt"))
		Set AvgFee=$fn(totalFee/totalCnt,"",2)
		Set AvgDay=$fn(totalDays/totalCnt,"",2)
		Set Data=$lb(xSDSYSDesc,AvgFee,AvgDay)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryQCSYSInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCSYSInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCSYSInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCSYSInfoExecute ]
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
