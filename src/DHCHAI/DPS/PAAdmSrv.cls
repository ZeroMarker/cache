/// 名称: DHCHAI.DPS.PAAdmSrv
/// 描述: 就诊相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.DPS.PAAdmSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   
/// Description:  
/// Table：DHCHAI.DP.PAAdm
/// Input：       
/// Return：      
/// w ##class(DHCHAI.DPS.PAAdmSrv).UpdateApgar(574,123)
ClassMethod UpdateApgar(aEpisodeID As %String, aPatApgar As %String)
{
	New (aEpisodeID,aPatApgar)
	Set ret = "0"
	Quit:aEpisodeID="" ret
	Set:aPatApgar'="" aPatApgar=aPatApgar_"H"
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$Isobject(objPaadm) ret
	Set objPaadm.PAApgar =aPatApgar
	
	Set sc=objPaadm.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set ret="0"
	}Else{
		Set ret="1"
	}
	Quit ret
}

/// Creator：     chenjb
/// CreatDate：   2017-08-14
/// Description:  
/// Table：       DHCHAI.DP.PAAdm
/// Input：       aEpisodeID : 就诊ID
///               ILDate : 体重
/// Return：      返回%String  1 成功 0 失败
/// w ##class(DHCHAI.DPS.PAAdmSrv).UpdateWeight("191","2500")
ClassMethod UpdateWeight(aEpisodeID As %String, aPatWeight As %String) As %String
{
	New (aEpisodeID,aPatWeight)
	Set ret = "0"
	Quit:aEpisodeID="" ret
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$Isobject(objPaadm) ret
	Set objPaadm.PAAdmitWeight =+aPatWeight
	
	Set sc=objPaadm.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set ret="0"
	}Else{
		Set ret="1"
	}
	Quit ret
}

/// Creator：     liyi
/// CreatDate：   2017-08-24
/// Description:  查询病人就诊记录
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryPatAdm","",362)
Query QryPatAdm(aPatientID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String") [ SqlProc ]
{
}

ClassMethod QryPatAdmExecute(ByRef qHandle As %Binary, aPatientID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPatientID="")&&(aEpisodeID="") $$$OK
 	
 	If (aEpisodeID'=""){
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
		Quit:'$isobject(objPaadm) $$$OK
		
		Set PatientIDx = objPaadm.PAPatientIDx 
		Quit:(aPatientID'="")&&(aPatientID'=PatientIDx)
		
		Set aPatientID=PatientIDx
	}
	Set xEpisodeID=""
	For {
		Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",aPatientID,xEpisodeID))
		Quit:xEpisodeID=""
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$isobject(objPaadm)
		Set EpisodeIDx=objPaadm.PAEpisodeIDx
		Set SCode = $p(EpisodeIDx,"||",1)
		Set VisitStatus = objPaadm.PAVisitStatus
		Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
		If VisitStatusInfo'="" {
			Set VisitStatus=$p(VisitStatusInfo,"^",2)
		}
		Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")
		
		Set Data=..BuildPaadmData(xEpisodeID)
		Continue:Data=""
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPatAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatAdmExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-08-28
/// Description:  病历查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryAdm","1^1^2021-09-01^2021-09-29^^^^^^14^1^","")
Query QryAdm(aIntputs As %String, aPatInfo As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%Float,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String,ZY:%String") [ SqlProc ]
{
}

ClassMethod QryAdmExecute(ByRef qHandle As %Binary, aIntputs As %String, aPatInfo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	
 	Set aHospIDs 	= $p(aIntputs,"^",1)
 	Set aDateType	= $p(aIntputs,"^",2)
 	Set aDateFrom 	= $p(aIntputs,"^",3)
 	Set aDateTo 	= $p(aIntputs,"^",4)
 	Set aLocationID = $p(aIntputs,"^",5)
 	Set aWardID 	= $p(aIntputs,"^",6)
 	Set aPatName 	= $p(aIntputs,"^",7)
 	Set aPapmiNo 	= $p(aIntputs,"^",8)
 	Set aMrNo 		= $p(aIntputs,"^",9)
 	Set aItemIDs    = $p(aIntputs,"^",10)
 	Set aRelation   = $p(aIntputs,"^",11)
 	Set aIsDeath    = $p(aIntputs,"^",12)
 	Quit:(aHospIDs="") $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocationID=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocationID,",")
 	Set aWardID=##class(DHCHAI.Utils.CommonSrv).ListFromString(aWardID,",")
 	
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set NIndex = "QryAdm"
 	kill ^TMP($zn,$j,NIndex)
 	// Add by zhaoyj 2022-06-15 Global方式
	Set ItemID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-TestAb",0))
	Set ItemData=$g(^DHCHAI.IR.CCItmMastD(ItemID))
	Quit:ItemData="" $$$OK
	Set CCIsActive=$lg(ItemData,4)
	Quit:CCIsActive'=1 $$$OK
	Set ItemDr=ItemID
	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set ItemCount=$l(aItemIDs,",")
	For xDate=aDateFrom:1:aDateTo {
		For indItem=1:1:ItemCount {
			Set xItemID=$p(aItemIDs,",",indItem)
			Continue:xItemID=""
			
			Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItmMast)
			Set ItemCode = objItmMast.CCCode
			If (ItemCode="LAB-SpecialBact"){
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
					Quit:xTime=""
					Set xReportDr=""
					For {
						Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xReportDr))
						Quit:xReportDr=""
						Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xReportDr))
						Continue:LabReportData=""
						Set VisitNumberDr = $lg(LabReportData,2)
						Set LabIsActive	  = $lg(LabReportData,18)
						Continue:LabIsActive'=1
						Set IsAbFlag=..GetSubmitIsAb(VisitNumberDr,ItemDr)
						Continue:IsAbFlag'=1
						
						Set VisitNumData  = $g(^DHCHAI.DP.LabVisitNumberD(VisitNumberDr))
						Continue:VisitNumData=""
						Set EpisodeDr =$lg(VisitNumData,2)
	
						Continue:$d(^TMP($zn,$j,NIndex,"IsExist",EpisodeDr,ItemDr))
						Set ^TMP($zn,$j,NIndex,"IsExist",EpisodeDr,ItemDr)=""
						Set num=$i(^TMP($zn,$j,NIndex,"ItemPat",EpisodeDr))  //计算符合条件类型
						Set ^TMP($zn,$j,NIndex,EpisodeDr)=""
					}
				}
			}Else{
				Set xResultID=""
				For {
					Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xResultID))
					Quit:xResultID=""
					
					Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
					Continue:'$IsObject(objResult) 
					Continue:objResult.CCIsActive'=1
					Set EpisodeID=objResult.CCEpisodeDr.%Id()
					
					Continue:$d(^TMP($zn,$j,NIndex,"IsExist",EpisodeID,xItemID))
					Set ^TMP($zn,$j,NIndex,"IsExist",EpisodeID,xItemID)=""
					Set num=$i(^TMP($zn,$j,NIndex,"ItemPat",EpisodeID))  //计算符合条件类型
					Set ^TMP($zn,$j,NIndex,EpisodeID)="" 
					
				}
			}	
		}
	}
	
 	If aDateType=1 {
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xPaadmId))
						Quit:xPaadmId=""
						Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
						Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
						
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
						
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}elseIf aDateType=2 {
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xPaadmId))
						Quit:xPaadmId=""
						Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
						Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}elseIf aDateType=3 {   //在院
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			
			Set xAdmDays = ""
			For {
				Set xAdmDays = $o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
				Quit:xAdmDays=""
			   
				Set xAdmDate=""
				//xAdmDays>0 表示出院病人
				Set:xAdmDays>=0 xAdmDate=aDateFrom-xAdmDays-1
				For {
					Set xAdmDate = $o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xAdmDate))
					Quit:xAdmDate=""
					Quit:xAdmDate>aDateTo 
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xAdmDate,xPaadmId))
						Quit:xPaadmId=""
							
						Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadmId))
						Continue:(PAAdmData="")
	               		Set DischDate = $lg(PAAdmData,26)
	                	Continue:(DischDate'="")&(DischDate<aDateFrom)   //update 20220613 当天入当天出及当天入第二天出的患者xAdmDays为1，前一天当天入当天出院的患者会被计入统计
	
						Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
						Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
						
						
						Set Data =..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}elseIf aDateType=""{
		if (aPatName'=""){
			Set Count=0
			Set xPatName = ""
			For {
				Set xPatName=$o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName))
				Quit:xPatName=""
				
				Continue:'(xPatName[aPatName)
				
				Set xPaadmId = ""
				For {
					Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName,xPaadmId))
					Quit:xPaadmId=""
					Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
					Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
					Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
					Continue:Data=""
					
					Set Count=Count+1
					Quit:Count>200 //超过200条不在输出
					
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}elseif (aPapmiNo'=""){
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPapmiNo",aPapmiNo,xPaadmId))
				Quit:xPaadmId=""
				Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
				Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
				Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}elseif (aMrNo'=""){
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexMrNo",aMrNo,xPaadmId))
				Quit:xPaadmId=""
				Continue:(aRelation=2)&(aItemIDs'="")&(($g(^TMP($zn,$j,NIndex,"ItemPat",xPaadmId)))'=ItemCount)  //且逻辑关系
				Continue:('$d(^TMP($zn,$j,NIndex,xPaadmId)))&&(aItemIDs'="")
				Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID,aPatInfo)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmExecute ]
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

/// Creator: zhoubo
/// CreatDate：2023-03-08   
/// Description:  判断是否检出特殊病原体
/// Table：DHCHAI.DP.PAAdm
/// Input：       
/// Return： 1 检出     
/// w ##class(DHCHAI.DPS.PAAdmSrv).GetSubmitIsAb(574,123)
ClassMethod GetSubmitIsAb(aVisitNumberDr As %String, aItemID As %String)
{
	New (aVisitNumberDr,aItemID)
	Set return = 0
	Quit:aVisitNumberDr="" return
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(aVisitNumberDr))
	Quit:VisitNumberData="" return
	Set EpisodeDr =$lg(VisitNumberData,2)
	
	Set VirusFlg =0          //生化免疫检测标志
	Set VirusItem=""
	Set xTestSetDesc = ""
	For {
		Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",aVisitNumberDr,xTestSetDesc))
		Quit:xTestSetDesc=""
		Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet","LIS01",xTestSetDesc,0))
		if (TestSetMapID'=""){
			Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
			Continue:TestSetMapData=""
			Continue:'$lg(TestSetMapData,7) 		//无效判断
			Set TSMapItemDr=$lg(TestSetMapData,4)
			Set TSMapItemData=""
			Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))		
			If (TSMapItemData'="") {    //检验医嘱对照
				Continue:'$lg(TSMapItemData,5)	//无效判断
				Set MapTSCode=$lg(TSMapItemData,2)
				Set MapTSDesc = $lg(TSMapItemData,3)
				
				Set TestSetCatDr = $lg(TSMapItemData,4)
				Set LabTestSetCatData=""
				Set:TestSetCatDr'="" LabTestSetCatData = $g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))
				If (LabTestSetCatData'="") {
					Set MapTSCatDesc=$lg(LabTestSetCatData,3)
					Set:MapTSCatDesc="生化免疫检测" VirusFlg =1  	//update 20211129  病毒支原体检测修改为生化免疫检测
					Set VirusItem = MapTSDesc
					Quit
				}	
			}				
		}
	}
	If (VirusFlg=0) {  //检查检验项目是否存在于检验结果中
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			Quit:VirusFlg=1
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumberDr,xTestSetDr,""),-1)
			Quit:xOrder=""
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				Quit:VirusFlg=1
				Set xTestCode=""
				For {
					Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
					Quit:xTestCode=""
					Quit:VirusFlg=1
					Set xMapItemDr=0
					For {
						Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
						Quit:xMapItemDr=""
						Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
						Continue:TSMapItemData=""	  //检验医嘱对照
						Continue:'$lg(TSMapItemData,5)	//无效判断
						Set TestSet	= $lg(TSMapItemData,3)					
						Set VirusItem = TestSet				
						Set MapTSCode=$lg(TSMapItemData,2)				
						Set TestSetCatDr=$lg(TSMapItemData,4)
						Continue:TestSetCatDr=""
						Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
						Continue:TestSetCatData=""
						Set MapTSCatDesc = $lg(TestSetCatData,3)
						Set:(MapTSCatDesc="生化免疫检测") VirusFlg=1   	//update 20211129  病毒支原体检测修改为生化免疫检测
						Quit														
					}
				}
			}
		}
	}
	Quit:VirusFlg=0 return	  //过滤非指定类型的送检
	Set IsAbFlag =0    //是否异常结果
	Set AbTestDescList=""
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,aItemID,xActDate))
		Quit:xActDate=""
		Quit:IsAbFlag=1

		Set xRstID=0
		For {
			Set xRstID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,aItemID,xActDate,xRstID))
			Quit:xRstID=""
			Set RstData = $g(^DHCHAI.IR.CCResultD(xRstID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Continue:$lg(RstData,21)'=1
			Set LabResultID=$p($lg(RstData,19),"=",2)
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr      = $lg(RepRstData,2)
			Set TestDesc         = $lg(RepRstData,3)
			Continue:LabReportDr=""
			Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
			Set:LabVisitNumberDr=aVisitNumberDr IsAbFlag=1
			Quit	
		}
	}
	Quit:IsAbFlag'=1 return
	Quit IsAbFlag
}

/// Creator：     zhoubo
/// CreatDate：   2022-08-30
/// Description:  查询就诊信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryAdmInfoByName","100019")
Query QryAdmInfoByName(aIntputs As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String,PAAdmDoc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInfoByNameExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	Set aPatName1  = $p(aIntputs,"^",1)
 	Set aPapmiNo1  = $p(aIntputs,"^",1)
 	Set aMrNo1 	   = $p(aIntputs,"^",1)
 	
 	if (aPatName1'="")&&(ind=1){
		Set Count=0
		Set xPatName = ""
		For {
			Set xPatName=$o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName))
			Quit:xPatName=""
			
			Continue:'(xPatName[aPatName1)
			
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName,xPaadmId))
				Quit:xPaadmId=""
				Set Data = ..BuildPaadmData(xPaadmId)
			 	Continue:Data=""
			 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadmId)
				Continue:'$isobject(objPaadm)
				Set PAAdmDoc = objPaadm.PAAdmDoc
				Set:PAAdmDoc'="" PAAdmDoc=$p(PAAdmDoc,"|",3)
				Set Data=Data_$lb(PAAdmDoc)
				
			 	Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			Set Count=Count+1
	    	Quit:Count>10 //超过10条不在输出
		}
	}
	If (aPapmiNo1'="")&&(ind=1){
		Set xPaadmId = ""
		For {
			Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPapmiNo",aPapmiNo1,xPaadmId))
			Quit:xPaadmId=""
			Set Data = ..BuildPaadmData(xPaadmId)
		 	Continue:Data=""
		 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadmId)
			Continue:'$isobject(objPaadm)
			Set PAAdmDoc = objPaadm.PAAdmDoc
			Set:PAAdmDoc'="" PAAdmDoc=$p(PAAdmDoc,"|",3)
			Set Data=Data_$lb(PAAdmDoc)
			
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (aMrNo1'="")&&(ind=1){
		Set xPaadmId = ""
		For {
			Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexMrNo",aMrNo1,xPaadmId))
			Quit:xPaadmId=""
			Set Data = ..BuildPaadmData(xPaadmId)
		 	Continue:Data=""
		 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadmId)
			Continue:'$isobject(objPaadm)
			Set PAAdmDoc = objPaadm.PAAdmDoc
			Set:PAAdmDoc'="" PAAdmDoc=$p(PAAdmDoc,"|",3)
			Set Data=Data_$lb(PAAdmDoc)
			
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryAdmInfoByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInfoByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInfoByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInfoByNameExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-10-12
/// Description:  查询就诊信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryAdmInfo","48")
Query QryAdmInfo(aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String,PAAdmDoc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 	
 	Set Data = ..BuildPaadmData(aEpisodeID)
 	Quit:Data="" $$$OK
 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) $$$OK
	Set PAAdmDoc = objPaadm.PAAdmDoc
	Set:PAAdmDoc'="" PAAdmDoc=$p(PAAdmDoc,"|",3)
	Set PAAdmDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set Data=Data_$lb(PAAdmDoc)
 	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInfoExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID As %String, aHospIDs As %String = "", aLocationID As %String = "", aWardID As %String = "", aPatInfo As %String = "") As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院P、在院A、出院D、退院C、作废U
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") return
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) return
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) return

	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	//多语言处理
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set Nation = objPaadm.PANation
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	Set IdentityCode = objPaadm.PAIdentityCode
	Set HomeAddress = objPaadm.PAHomeAddress
	Set Company = objPaadm.PACompany
	Set RelativeName = objPaadm.PARelativeName
	Set RelativeTel = objPaadm.PARelativeTel
	Set IsDeath = objPaadm.PAIsDeath
	Quit:($g(aIsDeath)'="")&&(IsDeath'=aIsDeath) return
	Set IsDeath = $s(IsDeath="1":"是",1:"否")
	Set DeathDate = objPaadm.PADeathDate
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType
	Set AdmType = $s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="EP":"急诊留观",AdmType="I":"住院",1:"")
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmTimes = objPaadm.PAAdmTimes
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		Set HospGroupID=""
		If $isobject(objPaadm.PAAdmLocDr.BTHospDr){
			Set HospID=objPaadm.PAAdmLocDr.BTHospDr.%Id()
			Quit:($g(aHospIDs)'="")&($listfind($g(aHospIDs),HospID)<1) return	//医院过滤
		}
		Quit:($g(aLocationID)'="")&&($listfind($g(aLocationID),objAdmLoc.%Id())<1) return  //科室过滤
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set AdmWardID = objAdmWard.%Id()
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Quit:($g(aWardID)'="")&&($listfind($g(aWardID),AdmWardID)<1) return  //病区过滤
	
	Set AdmRoom = objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmDays = objPaadm.PAAdmDays
	if AdmDays=-1{
		//Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
		Set AdmDays = (+$h)-objPaadm.PAAdmDate //修复bug:557856统一住院天数计算
		if (DischDate) {  //如果已经下出院医嘱，取其中最小的住院时间
			/*if (DischDate["/"){
				Set DischDate=$p(DischDate,"/",3)_"-"_$p(DischDate,"/",2)_"-"_$p(DischDate,"/",1)
			}*/
			if (DischDate["-"){
				Set AdmDays1 = $zdh(DischDate,3) - objPaadm.PAAdmDate
			} elseif(DischDate["/"){
				Set AdmDays1 = $zdh(DischDate,4) - objPaadm.PAAdmDate
			}
			
			
			if (AdmDays1<AdmDays) Set AdmDays=AdmDays1
		}
	}
	Set IsNewBaby = objPaadm.PAIsNewBaby
	Set BirthWeight = objPaadm.PABirthWeight
	Set AdmitWeight = objPaadm.PAAdmitWeight
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set ICD10  	   = objDiagnos.MRDiagICD10
		Set DiagDesc   = objDiagnos.MRDiagDesc
		//多语言处理
		//Set DiagDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc","EN","伤寒")
		Set DiagDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("MRCIDDesc",DiagDesc,"User.MRCICDDx")
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
		If DiagTpDesc="入院诊断"{
			Set AdmitDiag = AdmitDiag_","_DiagDesc
		}elseif DiagTpDesc="主要诊断"{
			Set MainDiag = MainDiag_","_DiagDesc
		}elseif DiagTpDesc="出院诊断"{
			Set DischDiag = DischDiag_","_DiagDesc
		}else {
			Set OtherDiag = OtherDiag_","_DiagDesc
		}
	}
	Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
	Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
	Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
	Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
	//add 20211112 处理临床不填写入院诊断，入院诊断显示框内容空白问题
	If (AdmitDiag=""){
		If (OtherDiag'="") {
		 	Set AdmitDiag=OtherDiag   //入院诊断中显示其他诊断
		}Else{
			Set AdmitDiag=MainDiag   //入院诊断中显示主要诊断
		}
	}
    If (OtherDiag="") {
	    Set OtherDiag=DischDiag   //出院诊断显示在其他诊断中
    }Else {
	   Set:DischDiag'="" OtherDiag=DischDiag_","_OtherDiag   //出院诊断显示在其他诊断中
    }
    Set ZY="摘要"
    //搜索框
    Set PatInfo=aEpisodeID_EpisodeIDx_PatientIDx_PapmiNo_MrNo_PatName_Sex_Nation_Birthday_Age_IdentityCode_HomeAddress_Company_RelativeName_RelativeTel_IsDeath_DeathDate_DeathTime_AdmType_VisitStatus_AdmDate_AdmTime_AdmLocDesc_AdmWardDesc_AdmRoom_AdmBed_DischDate_DischTime_DischLocDesc_DischWardDesc_IsNewBaby_BirthWeight_AdmitWeight_AdmTimes_AdmDays_MainDiag_AdmitDiag_OtherDiag_DischDiag_ZY
	Quit:((aPatInfo'="")&(PatInfo'[aPatInfo)) ""
	//多语言
	Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
	Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
	Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
	Set return = $lb(aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Nation,Birthday,Age,IdentityCode,HomeAddress,Company,RelativeName,RelativeTel,IsDeath,DeathDate,DeathTime,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc,IsNewBaby,BirthWeight,AdmitWeight,AdmTimes,AdmDays,MainDiag,AdmitDiag,OtherDiag,DischDiag,ZY)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-22
/// Description:  取某时间段在院病人
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// Return：      返回%ArrayOfDataTypes (DHCHAI.DP.PAAdm.ID)
/// s aa=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate("2018-04-11","2018-04-11","","638","I")
ClassMethod GetEpisodeDrByDate(aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aLocIDs As %String, aAdmType As %String) As %ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aHospIDs,aLocIDs,aAdmType)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetEpisodeDrByDateErr"
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set xAdmType="",Count=0
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		Continue:(aAdmType'="")&(aAdmType'[("|"_xAdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=""  //xAdmDays<0 表示住院病人
			Set:xAdmDays>0 xDate=aDateFrom-xAdmDays  //xAdmDays>0 表示出院病人
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				//Quit:(xDate>aDateTo)  //xAdmDays<0 表示住院病人
				//如果计算凌晨0点在院病人，应用下面方式过滤
				Quit:(xDate>aDateTo)                              //入院当天不算
				Quit:(xAdmDays=1)                                  //当天就诊当天出院不算
				
				Set xPAAdmID = ""
				For {
					Set xPAAdmID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate,xPAAdmID))
					Quit:xPAAdmID=""
					
					Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPAAdmID)
					Continue:'$IsObject(objAdm)
					Continue:objAdm.PAVisitStatus="P"  //等待状态患者不计入
					Set AdmLocDr=""
					If $IsObject(objAdm.PAAdmLocDr) {
						Set AdmLocDr=objAdm.PAAdmLocDr.%Id()
					}
					Set AdmWardDr=""
					If $IsObject(objAdm.PAAdmWardDr) {
						Set AdmWardDr=objAdm.PAAdmWardDr.%Id()
					}
					Continue:(aLocIDs'="")&(($listfind(aLocIDs,AdmLocDr)<1)&&($listfind(aLocIDs,AdmWardDr)<1))  //按就诊科室过滤
					Continue:'$IsObject(objAdm.PAAdmLocDr.BTHospDr)
					Set HospDr=objAdm.PAAdmLocDr.BTHospDr.%Id()
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按就诊科室院区过滤
					
					Set EpisodeDr=objAdm.%Id()
					Set Count=Count+1
					Do return.SetAt(EpisodeDr,Count)
				}	
			}
		}
	}
	Quit return
	
GetEpisodeDrByDateErr
	Do return.Clear()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-10-10
/// Description:  查询病人住院周数
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryAdmWeeks",322)
Query QryAdmWeeks(aEpisodeID As %String) As %Query(ROWSPEC = "weekShow:%String,weekValue:%String,weekInd:%String")
{
}

ClassMethod QryAdmWeeksExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryAdmWeeks")
	
 	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
 	Quit:'$IsObject(objAdm) $$$OK
 	
 	Set AdmDate = objAdm.PAAdmDate
 	Set DischDate = objAdm.PADischDate
 	Set:DischDate="" DischDate = +$h   //未出院
 	
 	Set (weekStt,weekEnd) = AdmDate
 	Set weekInd = 0
 	For indx = AdmDate:7:DischDate{
	 	Continue:indx=AdmDate
	 	
	 	Set weekEnd = indx-1
	 	Do BuildData
	 	Set weekStt = indx
	}
 	If ((DischDate-AdmDate+1)#7)>0{
		Set remainder = (DischDate-AdmDate+1)#7
		Set weekStt = DischDate-remainder+1
		Set weekEnd = DischDate
		Do BuildData
	}
		
	If ((DischDate-AdmDate+1)#7)=0 {
		Set indy=(DischDate-AdmDate+1)\7
		Set weekStt = AdmDate + (7*(indy-1))
		Set weekEnd = AdmDate + (7*indy)-1
		Do BuildData	
	}
	
	Set xWeekInd = ""
	For{
		Set xWeekInd = $o(^TMP(ZIndex,JIndex,"QryAdmWeeks",xWeekInd),-1)
		Quit:xWeekInd=""
		
		Set Data=$g(^TMP(ZIndex,JIndex,"QryAdmWeeks",xWeekInd))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,"QryAdmWeeks")
	Quit $$$OK
	
BuildData
	Set weekInd = weekInd + 1
	Set weekDesc = "第"_weekInd_"周"
	Set weekSttTmp = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(weekStt)
 	Set weekEndTmp = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(weekEnd)
 	Set weekShow = weekDesc_"（"_weekSttTmp_" ~ "_weekEndTmp_"）"
 	Set weekValue = weekStt_"-"_weekEnd
    Set ^TMP(ZIndex,JIndex,"QryAdmWeeks",weekInd)=$lb(weekDesc,weekValue,weekInd)
}

ClassMethod QryAdmWeeksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmWeeksExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmWeeksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmWeeksExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-12-15
/// Description:  取某时间段在院病人的床位信息
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryBedDrByDate","2017-08-01","2017-08-01","","")
Query QryBedDrByDate(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,BedDr:%String,BedDesc:%String")
{
}

ClassMethod QryBedDrByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	
	Set xAdmType="",Count=0
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=""  //xAdmDays<0 表示住院病人
			Set:xAdmDays>0 xDate=aDateFrom-xAdmDays  //xAdmDays>0 表示出院病人
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)  //xAdmDays<0 表示住院病人
				//如果计算凌晨0点在院病人，应用下面方式过滤
				//Quit:(xDate>=aDateTo)                              //入院当天不算
				//Quit:(xAdmDays=1)                                  //当天就诊当天出院不算
				Set xPAAdmID = ""
				For {
					Set xPAAdmID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate,xPAAdmID))
					Quit:xPAAdmID=""
					
					Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPAAdmID)
					Continue:'$IsObject(objAdm)
					Set AdmLocDr="",HospDr=""
					If $IsObject(objAdm.PAAdmLocDr){
						Set AdmLocDr=objAdm.PAAdmLocDr.%Id()
						Continue:'$IsObject(objAdm.PAAdmLocDr.BTHospDr)
						Set HospDr=objAdm.PAAdmLocDr.BTHospDr.%Id()
					}
					Set AdmWardDr=""
					If $IsObject(objAdm.PAAdmWardDr) {
						Set AdmWardDr=objAdm.PAAdmWardDr.%Id()
					}
					
					Set EpisodeDr=objAdm.%Id()
					//根据时间点取科室、病区、床位信息
					Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,aDateFrom)
					Continue:TransInfo=""
					Set BedDr=$p(TransInfo,"^",3)
					Set BedDesc=""
					Set objBed=##class(DHCHAI.BT.PACBed).GetObjById(BedDr)
					If $IsObject(objBed) {
						Set BedDr=objBed.%Id()
						Set BedDesc=objBed.BTDesc
						
						//虚拟病区 mayanpeng 2018-12-19
						If $IsObject(objBed.BTXLocDr){
							Set AdmWardDr=objBed.BTXLocDr.%Id() //虚拟病区床位关联到病区上
						}
					}
					Continue:BedDr=""
					Continue:(aLocIDs'="")&(($listfind(aLocIDs,AdmLocDr)<1)&&($listfind(aLocIDs,AdmWardDr)<1))  //按就诊科室过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按就诊科室院区过滤
					
					Set Data=$lb(ind,EpisodeDr,BedDr,BedDesc)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryBedDrByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBedDrByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBedDrByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBedDrByDateExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-04-08
/// Description:  取HIS下的就诊号和PatID
/// Table：       DHCHAI.DP.PAAdm
/// Input：       aEpisodeID : 就诊ID
///               
/// Return：      返回%String  1 成功 0 失败
/// w ##class(DHCHAI.DPS.PAAdmSrv).GetPaAdmHISx(11199)
ClassMethod GetPaAdmHISx(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set ret = ""
	Quit:aEpisodeID="" ret
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$Isobject(objPaadm) ret
	Set ret = $p(objPaadm.PAEpisodeIDx,"||",2)_"^"_objPaadm.PAPatientIDx
	Quit ret
}

/// Creator：     ShenC
/// CreatDate：   2021-05-31
/// Description:  取日期内符合条件的患者(1:新入,2:,住在,3:发热,4:PICC,5:VAP,6:UC,7:抗菌药,8:手术,9:出院,10:死亡)
/// Table：       DHCHAI.DP.PAAdm
/// Input：       院区aHospID、选择日期aDate
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryPatByType","1","2021-05-20",2)
Query QryPatByType(aHospIDs As %String, aLocDesc As %String = "", aDate As %String = "", aTypeID = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,AdmDiags:%String,ItemDesc1:%String,ItemDesc2:%String,ItemDesc3:%String,ItemDesc4:%String,ItemDesc5:%String,ItemDesc6:%String,ItemDesc7:%String,ZY:%String,DZBL:%String") [ SqlProc ]
{
}

ClassMethod QryPatByTypeExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocDesc As %String = "", aDate As %String = "", aTypeID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aHospIDs="")||(aTypeID="") $$$OK
	Set:aDate="" aDate=+$h-1	//首页默认查询前一天
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Quit:aDate="" $$$OK
	
	Set NIndex="QryPatByType"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某天的入科/在科/当天入当天出/出科人数
    Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(aDate,aDate,"E","","I","I|A|A2|O")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		//过滤院区
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&(aHospIDs'[HospDr)	
		//过滤科室
		Set LocDesc=$li(LocData,3)
		Continue:LocDesc=""
		Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc)
		
		//患者基本信息
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Quit:'$isobject(objPaadm)
		//入院科室
		Set objAdmLoc = objPaadm.PAAdmLocDr		
		Set AdmLocDesc=""
		Set:$isobject(objAdmLoc) AdmLocDesc = $s(objAdmLoc.BTDesc2'="":objAdmLoc.BTDesc2,1:objAdmLoc.BTDesc)
		//出院科室
		Set objDischLoc = objPaadm.PADischLocDr		
		Set DischLocDesc=""
		Set:$isobject(objDischLoc) DischLocDesc = $s(objDischLoc.BTDesc2'="":objDischLoc.BTDesc2,1:objDischLoc.BTDesc)
			
		Set (ItemDesc1,ItemDesc2,ItemDesc3,ItemDesc4,ItemDesc5,ItemDesc6,ItemDesc7)=""		//扩展信息
		
		Continue:$d(^TMP($zn,$j,NIndex,"PatCnt",Paadm))
		Set ^TMP($zn,$j,NIndex,"PatCnt",Paadm)=""
		//新入人数
		if (aTypeID=1){
			Set AdmDate=$li(^DHCHAI.DP.PAAdmD(Paadm),20)
			Continue:AdmDate=""
			Continue:AdmDate'=aDate		//过滤非新入
			
			Set ItemDesc1=AdmLocDesc				//1->入院科室
			Set ItemDesc2=$zd(AdmDate,3)			//2->入院日期
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)	
			Set ItemDesc3=AdmTime					//3->入院时间
			Set ItemDesc4=DischLocDesc				//4->出院科室
			Set DischDate = objPaadm.PADischDate	
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set ItemDesc5=DischDate					//5->出院日期
			Set DischTime = objPaadm.PADischTime
			Set:DischTime'="" DischTime=$zt(DischTime)	
			Set ItemDesc6=DischTime					//6->出院时间
		}
		//住在人数
		if (aTypeID=2){
			Set IsAdmPat=1
			Continue:IsAdmPat'=1
			
			Set ItemDesc1=LocDesc					//1->入院科室
			Set ItemDesc2=$zd(objPaadm.PAAdmDate,3)			//2->入院日期
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)	
			Set ItemDesc3=AdmTime					//3->入院时间
			Set ItemDesc4=DischLocDesc				//4->出院科室
			Set DischDate = objPaadm.PADischDate	
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set ItemDesc5=DischDate					//5->出院日期
			Set DischTime = objPaadm.PADischTime
			Set:DischTime'="" DischTime=$zt(DischTime)	
			Set ItemDesc6=DischTime					//6->出院时间
		}
		//统计发热人数(取当天第一次数据)
		if (aTypeID=3){
			Set Abno=0
			Set AbnoArr=##class(DHCHAI.STATV2.AbstractComm).GetFeverAbno(Paadm,aDate,aDate)
			Set:AbnoArr.Count()>0 Abno=1 
			Continue:Abno='1		//过滤非发热
			
			//抗菌药物使用信息输出
			for AbnoInd=1:1:AbnoArr.Count(){
				Set AbnoInfo=AbnoArr.GetAt(AbnoInd)
				
				Set AbnoItem=$li(AbnoInfo,1)
				Set AbnoDate=$li(AbnoInfo,2)
				Set AbnoTime=$li(AbnoInfo,3)
				
				Set ItemDesc1=AbnoItem					//1->体温
				Set ItemDesc2=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AbnoDate)	//2->异常日期
				Set ItemDesc3=$zt(AbnoTime,1)			//3->异常时间
				Quit
			}
		}
		Set (IsPICC,IsVAP,IsUC)=0
		Set ICULogID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",aDate,Paadm,0))
		if (ICULogID'=""){
			Set IsPICC=$li(^DHCHAI.IR.ICULogDtlD(ICULogID),6)
			Set IsVAP=$li(^DHCHAI.IR.ICULogDtlD(ICULogID),5)
			Set IsUC=$li(^DHCHAI.IR.ICULogDtlD(ICULogID),7)
			Set IsCVC  =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),10)
			Set IsCRRT =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),11)
			Set IsPORT =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),12)
			Set:((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)) IsPICC=1
		}
		//中心静脉插管人数
		//取当次最早医嘱信息-(即为aDate这天使用插管的最早开立医嘱)
		if (aTypeID=4){
			Continue:IsPICC'=1
			
			Set FirstOEDesc="",OrderEDate="",FirstOEStaDate="99999",FirstOEEndDate=""
			Set TubeOrderArr=##class(DHCHAI.STATV2.ICUResultStat).GetTubeOrderItemNew(Paadm,aDate,aDate,"PICC")
			For TInd=1:1:TubeOrderArr.Count(){
				Set OrderInfo=TubeOrderArr.GetAt(TInd)
				Set OrderDesc=$p(OrderInfo,",",1)
				Set OrderSDate=$p(OrderInfo,",",2)
				Continue:OrderSDate=""
				Set OrderSDate=$zdh(OrderSDate,3)
				Set OrderEDate=$p(OrderInfo,",",3)
				
				//取最早时间
				if (OrderSDate<FirstOEStaDate){
					Set FirstOEDesc=OrderDesc
					Set FirstOEStaDate=OrderSDate
					Set FirstOEEndDate=OrderEDate
				}
			}
			Set ItemDesc1=FirstOEDesc
			Set:FirstOEStaDate'="99999" ItemDesc2=$zd(FirstOEStaDate,3)
			Set ItemDesc3=OrderEDate
		}
		//呼吸机插管人数
		if (aTypeID=5){
			Continue:IsVAP'=1
			
			Set FirstOEDesc="",OrderEDate="",FirstOEStaDate="99999",FirstOEEndDate=""
			Set TubeOrderArr=##class(DHCHAI.STATV2.ICUResultStat).GetTubeOrderItemNew(Paadm,aDate,aDate,"VAP")
			For TInd=1:1:TubeOrderArr.Count(){
				Set OrderInfo=TubeOrderArr.GetAt(TInd)
				Set OrderDesc=$p(OrderInfo,",",1)
				Set OrderSDate=$p(OrderInfo,",",2)
				Continue:OrderSDate=""
				Set OrderSDate=$zdh(OrderSDate,3)
				Set OrderEDate=$p(OrderInfo,",",3)
				
				//取最早时间
				if (OrderSDate<FirstOEStaDate){
					Set FirstOEDesc=OrderDesc
					Set FirstOEStaDate=OrderSDate
					Set FirstOEEndDate=OrderEDate
				}
			}
			Set ItemDesc1=FirstOEDesc
			Set:FirstOEStaDate'="99999" ItemDesc2=$zd(FirstOEStaDate,3)
			Set ItemDesc3=OrderEDate
		}
		//泌尿道插管人数
		if (aTypeID=6){
			Continue:IsUC'=1
			Set FirstOEDesc="",OrderEDate="",FirstOEStaDate="99999",FirstOEEndDate=""
			Set TubeOrderArr=##class(DHCHAI.STATV2.ICUResultStat).GetTubeOrderItemNew(Paadm,aDate,aDate,"UC")
			For TInd=1:1:TubeOrderArr.Count(){
				Set OrderInfo=TubeOrderArr.GetAt(TInd)
				Set OrderDesc=$p(OrderInfo,",",1)
				Set OrderSDate=$p(OrderInfo,",",2)
				Continue:OrderSDate=""
				Set OrderSDate=$zdh(OrderSDate,3)
				Set OrderEDate=$p(OrderInfo,",",3)
				//取最早时间
				if (OrderSDate<FirstOEStaDate){
					Set FirstOEDesc=OrderDesc
					Set FirstOEStaDate=OrderSDate
					Set FirstOEEndDate=OrderEDate
				}
			}
			Set ItemDesc1=FirstOEDesc
			Set:FirstOEStaDate'="99999" ItemDesc2=$zd(FirstOEStaDate,3)
			Set ItemDesc3=FirstOEEndDate
		}
		//统计抗菌用药人数
		if (aTypeID=7){
			Set AntUseFlg=0
			Set AntUseArr =##class(DHCHAI.STATV2.AbstractComm).GetAntUseInfo(Paadm,aDate,aDate,"","")	
			Set:AntUseArr.Count()>0 AntUseFlg=1
			Continue:AntUseFlg'=1
			
			//抗菌药物使用信息输出
			for AntUseInd=1:1:AntUseArr.Count(){
				Set AntUseInfo=AntUseArr.GetAt(AntUseInd)
				Set SttDateTime = $li(AntUseInfo,7)
				Set EndDateTime = $li(AntUseInfo,10)
				
				Set SttDate=$p(SttDateTime," ",1)
				Set SttTime=$p(SttDateTime," ",2)
				Set EndDate=$p(EndDateTime," ",1)
				Set EndTime=$p(EndDateTime," ",2)
				Set:SttDate'="" SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		        Set:SttTime'="" SttTime=$zt(SttTime)
			    Set:EndTime'="" EndTime=$zt(EndTime)
		    	Set SttDateTime =SttDate_" "_SttTime
				Set EndDateTime =EndDate_" "_EndTime
				Set ItemDesc1=ItemDesc1_"<br>"_$li(AntUseInfo,4)					//1->抗菌药名称
				Set ItemDesc2=ItemDesc2_"<br>"_SttDateTime					//2->开始日期
				Set ItemDesc3=ItemDesc3_"<br>"_EndDateTime					//3->结束日期
				Set ItemDesc4=ItemDesc4_"<br>"_$li(AntUseInfo,13)					//4->等级
				Set:ItemDesc4["KSS1" ItemDesc4=$replace(ItemDesc4,"KSS1","非限制类")
				Set:ItemDesc4["KSS2" ItemDesc4=$replace(ItemDesc4,"KSS2","限制类")
				Set:ItemDesc4["KSS3" ItemDesc4=$replace(ItemDesc4,"KSS3","特殊类")
				Set ItemDesc5=ItemDesc5_"<br>"_$li(AntUseInfo,11)					//5->用药目的
				Set ItemDesc6=ItemDesc6_"<br>"_$li(AntUseInfo,12)					//6->途径
				Set ItemDesc7=ItemDesc7_"<br>"_$li(AntUseInfo,9)					//7->医生
			}
			Set ItemDesc1=$e(ItemDesc1,5,$l(ItemDesc1))
			Set ItemDesc2=$e(ItemDesc2,5,$l(ItemDesc2))
			Set ItemDesc3=$e(ItemDesc3,5,$l(ItemDesc3))
			Set ItemDesc4=$e(ItemDesc4,5,$l(ItemDesc4))
			Set ItemDesc5=$e(ItemDesc5,5,$l(ItemDesc5))
			Set ItemDesc6=$e(ItemDesc6,5,$l(ItemDesc6))
			Set ItemDesc7=$e(ItemDesc7,5,$l(ItemDesc7))
		}
		//统计手术人数(一天多次手术？)
		if (aTypeID=8){
			Set IsOper=0
			Set xOperID=""
			For{
				Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",Paadm,aDate,xOperID))
				Quit:xOperID=""
				Quit:IsOper=1
				
				Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xOperID))
				Continue:AnaesData=""
				
				//过滤无效数据
				Set ORIsActive=$li(AnaesData,31)
				Continue:ORIsActive'=1
				//过滤手术状态
				//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
				//Set:ExclStatus="" ExclStatus="ADC"
				Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
				Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
				Set:tOperStatus'="" OperStatus=tOperStatus
				//Continue:ExclStatus[OperStatus 
				
				Set IsOper=1
			}
			Continue:IsOper'=1
			Set ItemDesc1   = $li(AnaesData,4)
			Set OperDate   = $li(AnaesData,6)
			Set SttTime    = $li(AnaesData,7)
			Set ItemDesc2=$zd(OperDate,3)_" "_$zt(SttTime,1)
			Set EndDate    = $li(AnaesData,8)
			Set EndTime    = $li(AnaesData,9)
			Set ItemDesc3=""
			Set:EndDate'="" ItemDesc3=$zd(EndDate,3)_" "_$zt(EndTime,1)
			
		    //取常用短语对照中的标准字段
		    Set ItemDesc4= $li(AnaesData,16)
		    Set CuteTypeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",ItemDesc4)
			If (CuteTypeInfo'=""){
			    Set ItemDesc4=$P(CuteTypeInfo,"^",3)
			}
			Set ItemDesc5    = $li(AnaesData,17)
			Set ItemDesc6   = $li(AnaesData,20)
			Set ItemDesc7  = $li(AnaesData,21)	
		}
		//出院人数
		if (aTypeID=9){
			Set IsDischPat=1
			Continue:IsDischPat'=1
			
			Set ItemDesc1=LocDesc					//1->入院科室
			Set ItemDesc2=$zd(objPaadm.PAAdmDate,3)	//2->入院日期
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)	
			Set ItemDesc3=AdmTime					//3->入院时间
			Set ItemDesc4=DischLocDesc				//4->出院科室
			Set DischDate = objPaadm.PADischDate	
			Continue:DischDate'=aDate
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set ItemDesc5=DischDate					//5->出院日期
			Set DischTime = objPaadm.PADischTime
			Set:DischTime'="" DischTime=$zt(DischTime)	
			Set ItemDesc6=DischTime					//6->出院时间
			Set IsDeath=objPaadm.PAIsDeath			//7->是否死亡
			if (IsDeath=1){
				Set ItemDesc7="是"
			}
			else{
				Set ItemDesc7="否"
			}
		}
		//死亡人数
		if (aTypeID=10){
			Set IsDeath=objPaadm.PAIsDeath			//7->是否死亡
			Continue:IsDeath'=1
			
			Set ItemDesc1=LocDesc					//1->入院科室
			Set ItemDesc2=$zd(objPaadm.PAAdmDate,3)	//2->入院日期
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)	
			Set ItemDesc3=AdmTime					//3->入院时间
			Set ItemDesc4=DischLocDesc				//4->出院科室
			Set DischDate = objPaadm.PADischDate	
			Continue:DischDate'=aDate
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set ItemDesc5=DischDate					//5->出院日期
			Set DischTime = objPaadm.PADischTime
			Set:DischTime'="" DischTime=$zt(DischTime)	
			Set ItemDesc6=DischTime					//6->出院时间
			
			if (IsDeath=1){
				Set ItemDesc7="是"
			}
			else{
				Set ItemDesc7="否"
			}
		}
		Set PatData =##class(DHCHAI.STATV2.AbstractComm).BuildPaadmData(Paadm)
	    Continue:PatData=""
	    //入院诊断
	    Set AdmDiags=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(Paadm,"C008")
		Set ^CacheTemp(repid,ind)=PatData_$lb(AdmDiags,ItemDesc1,ItemDesc2,ItemDesc3,ItemDesc4,ItemDesc5,ItemDesc6,ItemDesc7,"","")
		Set ind=ind+1
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryPatByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatByTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPatByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBReportExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
