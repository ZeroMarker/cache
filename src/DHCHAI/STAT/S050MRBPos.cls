/// 名称: DHCHAI.STAT.S050MRBPos
/// 描述: 多重耐药菌感染检出率统计
/// 编写者：zhoubo
/// 编写日期: 2018-07-30
Class DHCHAI.STAT.S050MRBPos Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		zhoubo
/// CreateDate：	2018-07-30
/// Description:	多重耐药菌感染检出率统计,排除感染类型为污染
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S050MRBPos","QryMRBPos","1","2018-07-01","2018-08-08")
Query QryMRBPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocTypeDesc:%String,LocDr:%String,LocDesc:%String,WardDr:%String,WardDesc:%String,ResultID:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,MRBIDList:%String,MRB2ID:%String,MRB2Code:%String,MRB2Desc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	// 获取一段日期内在院及出院患者
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set EpisodeDr=ListArray.GetAt(index)	
		Continue:EpisodeDr=""
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
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
	   	
	   	Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			
			For xDate=aDateFrom:1:aDateTo {
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
					Quit:xID=""
				
					Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
					Continue:'$Isobject(objResult)
					Continue:objResult.CCIsActive'=1
					
					Set ActDate=objResult.CCActDate
					Set ActTime=objResult.CCActTime
					// 采集病区
				    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
					Set WardDr = $p(LocWardInfo,"^",2) // 病区
					Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
					Continue:'$IsObject(objLoc)
					If ($IsObject(objLoc.BTGroupDr)){
						Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
					}Else {
						Set LocTypeDesc="其他科"
					}
					Set LocDesc=objLoc.BTDesc2
					Set:LocDesc="" LocDesc=objLoc.BTDesc
					Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
					Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
					Continue:'$isobject(objWard)
					Set WardDesc=objWard.BTDesc2
					Set:WardDesc="" WardDesc=objWard.BTDesc
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
					Continue:WardDesc=""
					
					Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime)
					
					If ($IsObject(objResult.CCMRBTpDr)) {
						Set MRBID    = objResult.CCMRBTpDr.%Id()
						Set MRBDesc  = objResult.CCMRBTpDr.BTDesc
						Set MRBCode  = objResult.CCMRBTpDr.BTCode
					}Else {
						Set MRBID    = ""
						Set MRBDesc  = ""
						Set MRBCode  = ""
					}
					If ($IsObject(objResult.CCMRBTp2Dr)) {
						Set MRB2ID    = objResult.CCMRBTp2Dr.%Id()
						Set MRB2Desc  = objResult.CCMRBTp2Dr.BTDesc
						Set MRB2Code  = objResult.CCMRBTp2Dr.BTCode
					}Else {
						Set MRB2ID    = ""
						Set MRB2Desc  = ""
						Set MRB2Code  = ""
					}
					Set SCode    = objResult.CCSCode             //子系统代码
			        Set Specimen = objResult.CCSpecimen          //原始标本名称
			        Set SpeID="",SpeCode="",SpeDesc=""
			        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			        If $IsObject(objSpe) {
				        If $IsObject(objSpe.BTMapItemDr){
							Set SpeID=objSpe.BTMapItemDr.%Id()
							Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
							Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
						}
			        }
			        Set Bacteria = objResult.CCBacteria   //原始细菌名称
			        Continue:Bacteria=""
		            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
		            Continue:'$IsObject(objBactMap)
					Continue:'$IsObject(objBactMap.BTMapItemDr)
					Set BacID=objBactMap.BTMapItemDr.%Id()
					Set BacCode=objBactMap.BTMapItemDr.BTBacCode
					Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
					Set MRBFlg=0
					If $d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) {
						Set MRBFlg=1	
					}
					Continue:MRBFlg=0   // 非多重耐药菌对应的细菌不记录
					// 获取对应的多重耐药菌类型ID,一个细菌可能对应多个多重耐药菌类型
					Set MRBIDList=""
					Set xMrbId=""
					For {
						Set xMrbId=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,xMrbId)) 
						Quit:xMrbId=""
						Set MRBIDList=MRBIDList_"|"_xMrbId
					}
					Set:MRBIDList'="" MRBIDList=MRBIDList_"|"
					// 根据检验结果找检验报告ID
					Set ResultID = $p(objResult.CCParams,"=",2)  // 检验结果ID
					Set objLabRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
					Continue:'$IsObject(objLabRepRst)
					Continue:'$IsObject(objLabRepRst.LabReportDr)
					Set LabRepID=objLabRepRst.LabReportDr.%Id()
					Set BacCount=0
					Set xRepRstDr=""
					For {
						Set xRepRstDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",LabRepID,xRepRstDr))
						Quit:xRepRstDr=""
						Set objRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRepRstDr)
						Continue:'$IsObject(objRepRst)
						Set BacCount=BacCount+1
					}
					Continue:BacCount>3 // 同一份报告检出3种以上的病原体为污染
					
				   	Set Data=$lb(EpisodeDr,PapmiNo,MrNo,PatName,Sex,Age,LocTypeDesc,LocDr,LocDesc,WardDr,WardDesc,ResultID,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDate,ActTime,MRBIDList,MRB2ID,MRB2Code,MRB2Desc)
					Set ^CacheTemp(repid,ind)=$lb(ind)_Data
					Set ind=ind+1
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryMRBPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosExecute ]
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

/// Creator：		zhoubo
/// CreateDate：	2018-07-31
/// Description:	多重耐药菌感染检出明细,排除感染类型为污染
/// Input:          aHospIDs  : 多个医院用"|"连接
/// 				aDateFrom : 开始日期
/// 				aDateTo   : 结束日期
///                 aLocGroup : 科室分组
///                 aLocDesc  : 科室名称
///                 aWardDesc : 病区名称 
///                 aMRBDesc  : 多耐名称
///                 aMRBFlag  : 查询多耐菌
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S050MRBPos","QryMRBPosDtl","","2018-08-01","2018-08-08","","","","ESBL阳性产酸克雷伯菌","")
Query QryMRBPosDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String, aMRBDesc As %String, aMRBFlag As %String) As %Query(ROWSPEC = "EpisodeDr:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,ResultID:%String,LabEpisodeNo:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDateTime:%String,CCRepDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocGroup As %String, aLocDesc As %String, aWardDesc As %String, aMRBDesc As %String, aMRBFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	// 获取一段日期内在院及出院患者
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set EpisodeDr=ListArray.GetAt(index)	
		Continue:EpisodeDr=""
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
		Continue:'$Isobject(objAdm)
	   	
	   	Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			
			For xDate=aDateFrom:1:aDateTo {
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
					Quit:xID=""
				
					Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
					Continue:'$Isobject(objResult)
					Continue:objResult.CCIsActive'=1
					
					Set ActDate=objResult.CCActDate
					Set ActTime=objResult.CCActTime
					Set CCRepDate=objResult.CCRepDate
				    Set CCRepTime=objResult.CCRepTime
					// 采集病区
				    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
				   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
					Set WardDr = $p(LocWardInfo,"^",2) // 病区
					Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
					Continue:'$IsObject(objLoc)
					If ($IsObject(objLoc.BTGroupDr)){
						Set LocTypeDesc = objLoc.BTGroupDr.BTDesc  // 科室分类
					}Else {
						Set LocTypeDesc="其他科"
					}
					Continue:(aLocGroup'="")&&(aLocGroup'=LocTypeDesc) // 科室类型过滤
					Set LocDesc=objLoc.BTDesc2
					Set:LocDesc="" LocDesc=objLoc.BTDesc
					Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
					Continue:(aLocDesc'="")&&(aLocDesc'=LocDesc) // 科室过滤
					Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
					Continue:'$isobject(objWard)
					Set WardDesc=objWard.BTDesc2
					Set:WardDesc="" WardDesc=objWard.BTDesc
					Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
					Continue:WardDesc=""
					Continue:(aWardDesc'="")&&(aWardDesc'=WardDesc) // 病区过滤
					
					Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime)
					Set:CCRepDate'="" CCRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CCRepDate)
					Set:CCRepTime'="" CCRepTime=$zt(CCRepTime)
					Set ActDateTime=ActDate_" "_ActTime
					Set CCRepDateTime=CCRepDate_" "_CCRepTime
					
					If ($IsObject(objResult.CCMRBTpDr)) {
						Set MRBID    = objResult.CCMRBTpDr.%Id()
						Set MRBDesc  = objResult.CCMRBTpDr.BTDesc
						Set MRBCode  = objResult.CCMRBTpDr.BTCode
					}Else {
						Set MRBID    = ""
						Set MRBDesc  = ""
						Set MRBCode  = ""
					}
					If ($IsObject(objResult.CCMRBTp2Dr)) {
						Set MRB2ID    = objResult.CCMRBTp2Dr.%Id()
						Set MRB2Desc  = objResult.CCMRBTp2Dr.BTDesc
						Set MRB2Code  = objResult.CCMRBTp2Dr.BTCode
					}Else {
						Set MRB2ID    = ""
						Set MRB2Desc  = ""
						Set MRB2Code  = ""
					}
					Set SCode    = objResult.CCSCode             //子系统代码
			        Set Specimen = objResult.CCSpecimen          //原始标本名称
			        Set SpeID="",SpeCode="",SpeDesc=""
			        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			        If $IsObject(objSpe) {
				        If $IsObject(objSpe.BTMapItemDr){
							Set SpeID=objSpe.BTMapItemDr.%Id()
							Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
							Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
						}
			        }
			        Set Bacteria = objResult.CCBacteria   //原始细菌名称
			        Continue:Bacteria=""
		            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
		            Continue:'$IsObject(objBactMap)
					Continue:'$IsObject(objBactMap.BTMapItemDr)
					Set BacID=objBactMap.BTMapItemDr.%Id()
					Set BacCode=objBactMap.BTMapItemDr.BTBacCode
					Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
					Set MRBFlg=0
					If $d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) {
						Set MRBFlg=1	
					}
					Continue:MRBFlg=0   // 非多重耐药菌对应的细菌不记录
					// 获取对应的多重耐药菌类型ID,一个细菌可能对应多个多重耐药菌类型
					Set MRBIDList="",MRBDescList=""
					Set xMrbId=""
					For {
						Set xMrbId=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,xMrbId)) 
						Quit:xMrbId=""
						Set MRBIDList=MRBIDList_"|"_xMrbId
						Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(xMrbId)
						Set MRBDescList=MRBDescList_"|"_objMRB.BTDesc
					}
					Set:MRBIDList'="" MRBIDList=MRBIDList_"|"
					Set:MRBDescList'="" MRBDescList=MRBDescList_"|"
					
					If (aMRBFlag=1) {
						Continue:(aMRBDesc'="")&&(aMRBDesc'=MRBDesc)&&(aMRBDesc'=MRB2Desc)
					}Else {
						Continue:(aMRBDesc'="")&&(MRBDescList'[("|"_aMRBDesc_"|"))
					}
					// 根据检验结果找检验报告ID
					Set ResultID = $p(objResult.CCParams,"=",2)  // 检验结果ID
					Set objLabRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
					Continue:'$IsObject(objLabRepRst)
					Continue:'$IsObject(objLabRepRst.LabReportDr)
					Set LabRepID=objLabRepRst.LabReportDr.%Id()
					Continue:'$IsObject(objLabRepRst.LabReportDr.LabVisitNumberDr)
					Set LabEpisodeNo=objLabRepRst.LabReportDr.LabVisitNumberDr.LabEpisodeNo // 标本号
					
					Set BacCount=0
					Set xRepRstDr=""
					For {
						Set xRepRstDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",LabRepID,xRepRstDr))
						Quit:xRepRstDr=""
						Set objRepRst = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRepRstDr)
						Continue:'$IsObject(objRepRst)
						Set BacCount=BacCount+1
					}
					Continue:BacCount>3 // 同一份报告检出3种以上的病原体为污染
					
					// 患者基本信息
	   				Set PatData =##class(DHCHAI.STAT.S040MRBInf).BuildPaadmData(EpisodeDr)
					Continue:PatData=""
					
				   	Set Data=PatData_$lb(ResultID,LabEpisodeNo,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDateTime,CCRepDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryMRBPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
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
