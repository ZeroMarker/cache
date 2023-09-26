/// 名称: DHCHAI.STAT.S120MRBBacSen
/// 描述: IIHAI-31多重耐药医院感染病原体对抗菌药物的耐药率
/// 编写者: mayanpeng
/// 编写日期: 2018-07-31
Class DHCHAI.STAT.S120MRBBacSen Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询监控结果多重耐药菌药敏(多重耐药医院感染病原体对抗菌药物的耐药率)
///                 统计病原体感染类型为HA，HA例次与医院感染例次一致
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRstMRBSen","2|1","W","","2018-01-01","2018-04-10")
Query QryRstMRBSen(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,ResultID:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,SenID:%String,AntDesc:%String,MapTestSen:%String") [ SqlProc ]
{
}

ClassMethod QryRstMRBSenExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
    //Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")	 	

    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
     /*
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""	 
   */
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))	
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
	
	    Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set xDate=aDateFrom-1,ResultList=""
		For {
	 		Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate))
			Quit:xDate=""
	    	Quit:(xDate>aDateTo)   //日期控制？
	    	
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate,xID))
				Quit:xID=""
			
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Continue:'$Isobject(objResult.CCMRBTpDr)
				Set ActDate=objResult.CCActDate
				Set ActTime=objResult.CCActTime
				Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA?
				Continue:IPHour<48
			    
			    //采集病区
			    Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,ActDate,ActTime)
			    Set LocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
				Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
			   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
				Continue:'$IsObject(objRecLoc)
			    Set LocDesc=objRecLoc.BTDesc2
			    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
				//Continue:'$IsObject(objRecLoc.BTHospDr)
				//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	

				Set MRBID=objResult.CCMRBTpDr.%Id()
				Set MRBDesc = objResult.CCMRBTpDr.BTDesc
				Set MRBCode = objResult.CCMRBTpDr.BTCode
				Set LocID="", LocCode="", LocDesc=""
				If $IsObject(objResult.CCActLocDr){
					Set LocID =  objResult.CCActLocDr.%Id()
					Set LocCode = objResult.CCActLocDr.BTCode
					Set LocDesc = objResult.CCActLocDr.BTDesc2
				}
				Set SCode    = objResult.CCSCode      //子系统代码
		        Set Specimen = objResult.CCSpecimen   //原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
		        If $IsObject(objSpe) {
			        If $IsObject(objSpe.BTMapItemDr){
						Set SpeID=objSpe.BTMapItemDr.%Id()
						Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
						Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
					}
		        }
		     
				Set Bacteria  = objResult.CCBacteria 
				Continue:Bacteria=""
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1                     
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/
		
				Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
			    Set xSenID = ""
				For {
			    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
			    	Quit:xSenID=""
					
					Set objSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
					Continue:'$Isobject(objSen)
					Set AntCode = objSen.LabAntCode
					Set AntDesc = objSen.LabAntDesc
                    Continue:AntDesc=""
					Set TestSen = objSen.LabSensitivity
					Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
			
					Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,ResultID,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDate,ActTime,xSenID,AntDesc,MapTestSen)
					Set ^CacheTemp(repid,ind)=$lb(ind)_Data
					Set ind=ind+1
					
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryRstMRBSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRstMRBSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRstMRBSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRstMRBSenExecute ]
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
