/// 名称: DHCHAI.IRS.INFOPSSrv
/// 描述: 感染报告- 病原学检验相关服务
/// 编写者：liyi
/// 编写日期: 2017-09-19
Class DHCHAI.IRS.INFLabSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-08-31
/// Description:  通过就诊号查询病原学送检信息（包括无结果的送检）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFLabSrv","QryLabVisitByEpsID","15")
Query QryLabVisitByEpsID(aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,LabRepID:%String,TSDesc:%String,TSDesc2:%String,SpecimenID:%String,Specimen:%String,SubmissDate:%String,SubmissLocID:%String,SubmissLoc:%String,AssayMethodID:%String,AssayMethod:%String,PathogenTestID:%String,PathogenTest:%String,BacteriaIDs:%String,Bacterias:%String,RuleMRBs:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,LABIsEPDID:%String,LABIsEPD:%String,TestSetID:%String,VisitNumberDr:%String") [ SqlProc ]
{
}

ClassMethod QryLabVisitByEpsIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="") $$$OK
 	
 	Set xVisitNumberDr = ""
	For {
		Set xVisitNumberDr = $o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber = ##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$IsObject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		Set VisitNumberDr=xVisitNumberDr
		Set SCode = objVisitNumber.LabSCode
		Set Specimen=objVisitNumber.LabSpecimen
		Set objSpecMap = ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
		Set SpecimenID=""
		If $IsObject(objSpecMap.BTMapItemDr)&&(objSpecMap.BTIsActive=1){
			if objSpecMap.BTMapItemDr.BTIsActive=1{
				Set SpecimenID = objSpecMap.BTMapItemDr.%Id()
				Set Specimen = objSpecMap.BTMapItemDr.BTSpecDesc
			}
		}
		Set CollDate=objVisitNumber.LabCollDate
		Set CollTime=objVisitNumber.LabCollTime
		if CollDate=""{		// 采集日期为空采用接收日期
			Set CollDate=objVisitNumber.LabRecDate
			Set:CollTime'="" CollTime=$zt(CollTime)
		}
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime)
		Set objLabLoc=objVisitNumber.LabLocDr
		Set (LabLocID,LabLoc)=""
		If $IsObject(objLabLoc){
			Set LabLocID = objLabLoc.%Id()
			Set LocDesc2 = objLabLoc.BTDesc2
			Set LocDesc = objLabLoc.BTDesc
			Set LabLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		}
		If ('$d(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr))){
			// 没有报告结果
			Set (xReportDr,TestSetID,TestSetDesc,TSDesc2,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,ResultIDs,Bacterias,RuleMRBs)=""
			
			Set OrdListDesc=""	//检验医嘱名称
			Set xTestSetDesc=""
			For {
				Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
				Quit:xTestSetDesc=""
				Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
				
				Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
				//对照后检验医嘱
				Set TestSetID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
				Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetID)
				Continue:'$isobject(objTestSetMap)
				Continue:'$isobject(objTestSetMap.BTMapItemDr)
				Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
				Set TestSetDesc = xTestSetDesc	
			}
			Set:OrdListDesc'="" OrdListDesc=$e(OrdListDesc,2,$l(OrdListDesc))
			Continue:TestSetID=""
			Set Data=$lb("",aEpisodeID,xReportDr,TestSetDesc,TSDesc2,SpecimenID,Specimen,CollDate,LabLocID,LabLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,ResultIDs,Bacterias,RuleMRBs,"","","","","","")
			Set ^CacheTemp(repid,ind)=Data_$lb(TestSetID,VisitNumberDr)
			Set ind=ind+1	
		}Else{
			Set xTestSetDr=""
			For {
				Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
				Quit:xTestSetDr=""
				
				//最新检验报告
				Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
				
				Set xReportDr=0
				For {
					Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xReportDr))
					Quit:xReportDr=""
					
					Set objLabReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xReportDr)
					Continue:'$IsObject(objLabReport)
					
					Set Status = objLabReport.LabStatus
					//Continue:Status=6	//作废
					Set IsActive = objLabReport.LabIsActive
					Continue:IsActive=0
					
					Set objTestSet=objLabReport.LabTestSetDr
					Continue:'$IsObject(objTestSet)
					
					Set TestSetDesc=objTestSet.LabTestSetDesc
					Continue:TestSetDesc=""
					Set objTestSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
					Continue:'$IsObject(objTestSetMap)
					Continue:objTestSetMap.BTIsActive=0 
					
					Set TestSetID=objTestSetMap.%Id()
						
					Set INFLabID = $o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",aEpisodeID,xReportDr,""))
					if INFLabID'=""{
						Set Data = ..BuildINFLabData(INFLabID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data_$lb(TestSetID,VisitNumberDr)
				    	Set ind=ind+1
					}else{
						
						Continue:'$IsObject(objTestSetMap.BTMapItemDr)
						Continue:objTestSetMap.BTMapItemDr.BTIsActive=0
						Continue:'$IsObject(objTestSetMap.BTMapItemDr.BTCatDr)
						//update 20211129  病毒支原体检测修改为生化免疫检测
						Continue:(objTestSetMap.BTMapItemDr.BTCatDr.BTDesc'="微生物送检")&&(objTestSetMap.BTMapItemDr.BTCatDr.BTDesc'="生化免疫检测")
						
						// 检验方法
						Set AssayMethodID = ""
						If (TestSetDesc["培养")||(TestSetDesc["尿沉渣") {
							Set AssayMethod="培养"
						} ElseIf (TestSetDesc["GS")||(TestSetDesc["涂片")  {
							Set AssayMethod="镜检"
						}ElseIf (TestSetDesc["抗体") ||(TestSetDesc["抗原") {
							Set AssayMethod="血清学"
						}  Else {
							Set AssayMethod=""
						}
						Set objAssayMethod = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("LABAssayMethod",AssayMethod)
						Set:$IsObject(objAssayMethod) AssayMethodID = objAssayMethod.%Id()
						
						Set PathogenTestID = "",PathogenTest = ""
						Set xResutlID="",ResultIDs="",Bacterias="",RuleMRBs=""
						For {
							Set xResutlID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xReportDr,xResutlID))
							Quit:xResutlID=""
							
							Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResutlID)
							Continue:'$IsObject(objResult)
							
							Set Result = objResult.LabResult
							Continue:Result=""
							Set RstFormat = objResult.LabRstFormat  
							Set:(RstFormat="S")&((Result["弱阳性")||(Result["+")) Result="阳性"  //处理核酸结果
							Set:(RstFormat="S")&(Result["-") Result="阴性"
							//add 2019-08-15 用于标记确诊的细菌	
							Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Result)
		                    If $Isobject(objBactMap) {
								Continue:objBactMap.BTIsActive=0
		                    	Set Bacteria = objBactMap.BTMapItemDr.BTBacDesc
		                    	Set Bacterias = Bacterias_","_Bacteria
							}
							// 病原学
							If (PathogenTest'="阳性")&(Result'="阳性") {
								If (RstFormat="M")&($IsObject(objBactMap)) {
									If $IsObject(objBactMap.BTMapItemDr)&(objBactMap.BTIsActive=1){
										Set PathogenTest = "阳性" 
									}Else{
										Set PathogenTest = "阴性"
									}
								}Else{
									Set PathogenTest = "阴性"
								}
							}
							Set ResultIDs = ResultIDs_","_xResutlID
							
							Set (RuleMRBID,RuleMRB)=""
							If (PathogenTest="阳性") {
								Set objRuleMRB = ##class(DHCHAI.IRS.CCResultSrv).GetMRBType(aEpisodeID,"",Result,xResutlID)
								If $IsObject(objRuleMRB){
									Set RuleMRBID = objRuleMRB.%Id()
									Set RuleMRB = objRuleMRB.BTDesc
								}
								Set:RuleMRB'="" RuleMRBs=RuleMRBs_","_Result_"("_RuleMRB_")"
							}
						}
						
						Set objPathogenTest = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("LABPathogenTest",PathogenTest)
						Set:$IsObject(objPathogenTest) PathogenTestID = objPathogenTest.%Id()
						Set:ResultIDs'="" ResultIDs=$e(ResultIDs,2,$length(ResultIDs))
						Set:Bacterias'="" Bacterias=$e(Bacterias,2,$length(Bacterias))
						Set:RuleMRBs'="" RuleMRBs=$e(RuleMRBs,2,$length(RuleMRBs))
						Set TSDesc2 = ""
						Set Data=$lb("",aEpisodeID,xReportDr,TestSetDesc,TSDesc2,SpecimenID,Specimen,CollDate,LabLocID,LabLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,ResultIDs,Bacterias,RuleMRBs,"","","","","","")
						Set ^CacheTemp(repid,ind)=Data_$lb(TestSetID,VisitNumberDr)
						Set ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLabVisitByEpsIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitByEpsIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabVisitByEpsIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitByEpsIDExecute ]
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
/// CreatDate：   2017-09-19
/// Description:  通过感染报告ID查询病原学检验信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFLabSrv","QryINFLabByRep","",22979)
Query QryINFLabByRep(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,LabRepID:%String,TSDesc:%String,TSDesc2:%String,SpecimenID:%String,Specimen:%String,SubmissDate:%String,SubmissTime:%String,SubmissLocID:%String,SubmissLoc:%String,AssayMethodID:%String,AssayMethod:%String,PathogenTestID:%String,PathogenTest:%String,BacteriaIDs:%String,Bacterias:%String,RuleMRBs:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,LABIsEPDID:%String,LABIsEPD:%String,TestSetID:%String,VisitNumberDr:%String") [ SqlProc ]
{
}

ClassMethod QryINFLabByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
 	
 	If aReportID'=""{
	 	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	 	Quit:'$isobject(objRep) $$$OK
	 	
	 	Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
	
	    Set LinkLabs=objRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
		Quit:LinkLabs="" $$$OK
	 	For indx = 1:1:$length(LinkLabs,","){
			Set ID = $p(LinkLabs,",",indx)
			Continue:ID=""
			
			Set Data = ..BuildINFLabData(ID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
	 	}
 	}else{
	 	Set xVisitNumberDr = ""
		For {
			Set xVisitNumberDr = $o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			
			Set objVisitNumber = ##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
			Continue:'$IsObject(objVisitNumber)
			Continue:objVisitNumber.LabIsActive'=1
			Set VisitNumberDr=xVisitNumberDr
			Set SCode = objVisitNumber.LabSCode
			Set Specimen=objVisitNumber.LabSpecimen
			Set objSpecMap = ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			Set SpecimenID=""
			If $IsObject(objSpecMap.BTMapItemDr)&&(objSpecMap.BTIsActive=1){
				if objSpecMap.BTMapItemDr.BTIsActive=1{
					Set SpecimenID = objSpecMap.BTMapItemDr.%Id()
					Set Specimen = objSpecMap.BTMapItemDr.BTSpecDesc
				}
			}
			Set CollDate=objVisitNumber.LabCollDate
			Set CollTime=objVisitNumber.LabCollTime
			if CollDate=""{		// 采集日期为空采用接收日期
				Set CollDate=objVisitNumber.LabRecDate
				Set CollTime=objVisitNumber.LabRecTime
			}
			Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
			Set:CollTime'="" CollTime= $zt(CollTime,2)
			Set objLabLoc=objVisitNumber.LabLocDr
			Set (LabLocID,LabLoc)=""
			If $IsObject(objLabLoc){
				Set LabLocID = objLabLoc.%Id()
				Set LocDesc2 = objLabLoc.BTDesc2
				Set LocDesc = objLabLoc.BTDesc
				Set LabLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			}
			Set xTestSetDr=""
			For {
				Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
				Quit:xTestSetDr=""
				
				//最新检验报告
				Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
				
				Set xReportDr=0
				For {
					Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xReportDr))
					Quit:xReportDr=""
					
					Set objLabReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xReportDr)
					Continue:'$IsObject(objLabReport)
					
					Set Status = objLabReport.LabStatus
					//Continue:Status=6	//作废
					Set IsActive = objLabReport.LabIsActive
					Continue:IsActive=0
					
					Set objTestSet=objLabReport.LabTestSetDr
					Continue:'$IsObject(objTestSet)
					//根据标本循环检验医嘱表处理合管医嘱显示问题
					Set TestSetDesc="",TestSetID=""
		            Set xTestSetDesc=""
		            For {
				        Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
				        Quit:xTestSetDesc=""
			            
			            Set TestSetDesc=TestSetDesc_"+"_xTestSetDesc
						//Set TestSetDesc=objTestSet.LabTestSetDesc
						//Continue:TestSetDesc=""
						Set objTestSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,xTestSetDesc)
						Continue:'$IsObject(objTestSetMap)
						Continue:objTestSetMap.BTIsActive=0 
						Set TestSetID=objTestSetMap.%Id()
						
		            }
		            Set:TestSetDesc'="" TestSetDesc=$e(TestSetDesc,2,$l(TestSetDesc))
						
					Set INFLabID = $o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",aEpisodeID,xReportDr,""))
					If INFLabID'=""{
						Set Data = ..BuildINFLabData(INFLabID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data_$lb(TestSetID,VisitNumberDr)
				    	Set ind=ind+1
					}Else{
						//update 20230425  需求3418236：院感报告病学送检允许关联检验医嘱、检验项目维护标准对照为送检项目的送检记录
						Set CheckFlg=0
						If $IsObject(objTestSetMap.BTMapItemDr) {	 //检查检验医嘱是否维护标准对照		
							Continue:objTestSetMap.BTMapItemDr.BTIsActive=0
							Set IsSubItem = objTestSetMap.BTMapItemDr.BTIsSubItem
							Set:IsSubItem=1 CheckFlg=1
							If (CheckFlg=0)&($IsObject(objTestSetMap.BTMapItemDr.BTCatDr)) {
								Set TestSetMapCat = objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
								Set:(TestSetMapCat="微生物送检")||(TestSetMapCat="生化免疫检测") CheckFlg=1
							}
						}
						If (CheckFlg=0) {  //检查检验项目是否维护标准对照						
							Set xTestCode=""
							For {
								Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xReportDr,xTestCode))
								Quit:xTestCode=""
								Quit:CheckFlg=1
							
								Set xMapItemDr=0
								For {
									Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
									Quit:xMapItemDr=""
									Set objTestSet=##class(DHCHAI.DP.LabTestSet).GetObjById(xMapItemDr)
									Continue:'$IsObject(objTestSet)
									Continue:objTestSet.BTIsActive=0
									Set IsSubItem = objTestSet.BTIsSubItem
									Set:IsSubItem=1 CheckFlg=1
									If (CheckFlg=0)&($IsObject(objTestSet.BTCatDr)) {
										Set TestSetMapCat = objTestSet.BTCatDr.BTDesc
										Set:(TestSetMapCat="微生物送检")||(TestSetMapCat="生化免疫检测") CheckFlg=1
									}
									Quit										
								}
							}
						}
						Continue:CheckFlg=0	//过滤非指定类型的送检
						
						// 检验方法
						Set AssayMethodID = ""
						If (TestSetDesc["培养")||(TestSetDesc["尿沉渣") {
							Set AssayMethod="培养"
						} ElseIf (TestSetDesc["GS")||(TestSetDesc["涂片")  {
							Set AssayMethod="镜检"
						}ElseIf (TestSetDesc["抗体") ||(TestSetDesc["抗原") {
							Set AssayMethod="血清学"
						}  Else {
							Set AssayMethod=""
						}
						Set objAssayMethod = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("LABAssayMethod",AssayMethod)
						Set:$IsObject(objAssayMethod) AssayMethodID = objAssayMethod.%Id()
						
						Set PathogenTestID = "",PathogenTest = ""
						Set xResutlID="",ResultIDs="",Bacterias="",RuleMRBs=""
						For {
							Set xResutlID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xReportDr,xResutlID))
							Quit:xResutlID=""
							
							Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResutlID)
							Continue:'$IsObject(objResult)
							
							Set Result = objResult.LabResult
							Continue:Result=""
							Set RstFormat = objResult.LabRstFormat  
							Set:(RstFormat="S")&((Result["弱阳性")||(Result["+")) Result="阳性"  //处理核酸结果
							Set:(RstFormat="S")&(Result["-") Result="阴性"
							
							//add 2019-08-15 用于标记确诊的细菌	
							Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Result)
		                    If $Isobject(objBactMap) {
								Continue:objBactMap.BTIsActive=0
		                    	Set Bacteria = objBactMap.BTMapItemDr.BTBacDesc
		                    	Set Bacterias = Bacterias_","_Bacteria
							}
							
							// 病原学
							Set:(RstFormat'="M")&(Result="阳性") PathogenTest=Result
							If (PathogenTest'="阳性") {
								If (RstFormat="M")&($IsObject(objBactMap)) {
									If $IsObject(objBactMap.BTMapItemDr)&(objBactMap.BTIsActive=1){
										Set PathogenTest = "阳性" 
									}Else{
										Set PathogenTest = "阴性"
									}
								}Else{
									Set PathogenTest = "阴性"
								}
							}
							Set ResultIDs = ResultIDs_","_xResutlID
							
							Set (RuleMRBID,RuleMRB)=""
							If (PathogenTest="阳性") {
								Set objRuleMRB = ##class(DHCHAI.IRS.CCResultSrv).GetMRBType(aEpisodeID,"",Result,xResutlID)  //原始细菌名称
								If $IsObject(objRuleMRB){
									Set RuleMRBID = objRuleMRB.%Id()
									Set RuleMRB = objRuleMRB.BTDesc
								}
								Set:RuleMRB'="" RuleMRBs=RuleMRBs_","_Result_"("_RuleMRB_")"
							}
						}
						//Continue:Bacterias=""   //支持细菌检测以外的送检填写
						
						Set objPathogenTest = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("LABPathogenTest",PathogenTest)
						Set:$IsObject(objPathogenTest) PathogenTestID = objPathogenTest.%Id()
						Set:ResultIDs'="" ResultIDs=$e(ResultIDs,2,$length(ResultIDs))
						Set:Bacterias'="" Bacterias=$e(Bacterias,2,$length(Bacterias))
						Set:RuleMRBs'="" RuleMRBs=$e(RuleMRBs,2,$length(RuleMRBs))
						Set TSDesc2 = ""
						Set Data=$lb("",aEpisodeID,xReportDr,TestSetDesc,TSDesc2,SpecimenID,Specimen,CollDate,CollTime,LabLocID,LabLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,ResultIDs,Bacterias,RuleMRBs,"","","","","","")
						Set ^CacheTemp(repid,ind)=Data_$lb(TestSetID,VisitNumberDr)
						Set ind=ind+1
					}
				}
			}
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryINFLabByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFLabByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFLabByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFLabByRepExecute ]
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

/// 取单个病原学检验信息
ClassMethod BuildINFLabData(aINFLabID As %String) As %String
{
	New (aINFLabID)
	Set return=""
	Quit:aINFLabID="" return
	
	Set objINFLab = ##class(DHCHAI.IR.INFLab).GetObjById(aINFLabID)
	Quit:'$IsObject(objINFLab) return
	Quit:'$IsObject(objINFLab.IREpisodeDr) return
	
	Set EpisodeID=objINFLab.IREpisodeDr.%Id()
	Set objLabRep=objINFLab.IRLabRepDr
	Set LabRepID="",SCode="",VisitNumberID="",TestSetID="",CollTime=""
	If $IsObject(objLabRep){
		Set LabRepID = objLabRep.%Id()
		Set SCode = objLabRep.LabSCode
		Set VisitNumberID = objLabRep.LabVisitNumberDr.%Id()
		Set CollTime=objLabRep.LabVisitNumberDr.LabCollTime
		If (CollTime="") {
			Set CollTime=objLabRep.LabVisitNumberDr.LabRecTime
		}
		Set:CollTime'="" CollTime= $zt(CollTime,2)
		Set objTestSet=objLabRep.LabTestSetDr
		If $IsObject(objTestSet) {
			Set TestSetDesc=objTestSet.LabTestSetDesc
			Set objTestSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
			If $IsObject(objTestSetMap) {
				Quit:objTestSetMap.BTIsActive=0 
				Set TestSetID=objTestSetMap.%Id()
			}
		}
	}
	Set TSDesc=objINFLab.IRTSDesc
	Set TSDesc2=objINFLab.IRTSDesc2
	Set objSpecimen=objINFLab.IRSpecimenDr
	Set (SpecimenID,Specimen)=""
	If $IsObject(objSpecimen){
		Set SpecimenID = objSpecimen.%Id()
		Set Specimen = objSpecimen.BTSpecDesc
	}
	Set SubmissDate=objINFLab.IRSubmissDate
	Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate)
	Set objSubmissLoc=objINFLab.IRSubmissLocDr
	Set (SubmissLocID,SubmissLoc)=""
	If $IsObject(objSubmissLoc){
		Set SubmissLocID = objSubmissLoc.%Id()
		Set LocDesc2 = objSubmissLoc.BTDesc2
		Set LocDesc = objSubmissLoc.BTDesc
		Set SubmissLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAssayMethod=objINFLab.IRAssayMethod
	Set (AssayMethodID,AssayMethod)=""
	If $IsObject(objAssayMethod){
		Set AssayMethodID = objAssayMethod.%Id()
		Set AssayMethod = objAssayMethod.BTDesc
	}
	Set objPathogenTest=objINFLab.IRPathogenTest
	Set (PathogenTestID,PathogenTest)=""
	If $IsObject(objPathogenTest){
		Set PathogenTestID = objPathogenTest.%Id()
		Set PathogenTest = objPathogenTest.BTDesc
	}
	Set objLABIsEPD=objINFLab.IRLABIsEPD
	Set (LABIsEPDID,LABIsEPD)=""
	If $IsObject(objLABIsEPD){
		Set LABIsEPDID = objLABIsEPD.%Id()
		Set LABIsEPD = objLABIsEPD.BTDesc
	}
	Set UpdateDate=objINFLab.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime=objINFLab.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser=objINFLab.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}	
	
	Set xSubID = "",Bacterias="",BacteriaIDs="",RuleMRBs=""
	For {
		Set xSubID = $o(^DHCHAI.IR.INFLabD(aINFLabID,"BACT",xSubID))
		Quit:xSubID=""
		
		Set objINFLabBact = ##class(DHCHAI.IR.INFLabBact).GetObjById(aINFLabID_"||"_xSubID)
		Continue:'$IsObject(objINFLabBact)
		Continue:'$IsObject(objINFLabBact.IRBactDicDr)
		Set Bacteria = objINFLabBact.IRBactDicDr.BTBacDesc
	
		Set Bacterias = Bacterias_","_Bacteria
		Set BacteriaIDs = BacteriaIDs_","_aINFLabID_"||"_xSubID
		
		If (LabRepID'="") {  //处理手工添加的信息
			Set xResutlID="" 
			For {
				Set xResutlID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",LabRepID,xResutlID))
				Quit:xResutlID=""
				
				Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResutlID)
				Continue:'$IsObject(objResult)			
				Set Result   = objResult.LabResult // 细菌
				
				Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Result)
			    Continue:'$Isobject(objBactMap)
				Continue:objBactMap.BTIsActive=0
			    Continue:(Bacteria'=objBactMap.BTMapItemDr.BTBacDesc)   //细菌过滤
									
				Set objRuleMRB = ##class(DHCHAI.IRS.CCResultSrv).GetMRBType(EpisodeID,"",Result,xResutlID)  //修改为原始细菌名称
				Continue:'$IsObject(objRuleMRB)
				Set RuleMRB = objRuleMRB.BTDesc
				Set:RuleMRB'="" RuleMRBs=RuleMRBs_","_Bacteria_"("_RuleMRB_")"
			}
		}
	}
	//Quit:BacteriaIDs="" return
	Set:BacteriaIDs'="" BacteriaIDs = $e(BacteriaIDs,2,$length(BacteriaIDs))
	Set:Bacterias'="" Bacterias = $e(Bacterias,2,$length(Bacterias))
	Set:RuleMRBs'="" RuleMRBs=$e(RuleMRBs,2,$length(RuleMRBs))
	Set return = $lb(aINFLabID,EpisodeID,LabRepID,TSDesc,TSDesc2,SpecimenID,Specimen,SubmissDate,CollTime2,SubmissLocID,SubmissLoc,AssayMethodID,AssayMethod,PathogenTestID,PathogenTest,BacteriaIDs,Bacterias,RuleMRBs,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,LABIsEPDID,LABIsEPD,TestSetID,VisitNumberID)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  通过报告病原学检验ID查询菌+药敏信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFLabSrv","QryLabBactSen","53")
Query QryLabBactSen(aINFLabID As %String, aLabRepID As %String) As %Query(ROWSPEC = "BacteriaID:%String,Bacteria:%String,AntID:%String,AntDesc:%String,SensitivityID:%String,Sensitivity:%String")
{
}

ClassMethod QryLabBactSenExecute(ByRef qHandle As %Binary, aINFLabID As %String, aLabRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aINFLabID="")&&(aLabRepID="") $$$OK
 	
 	If aINFLabID'=""{
	 	Quit:'$d(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",aINFLabID)) $$$OK
	 	Set xBactID = ""
	 	For {
	 		Set xBactID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",aINFLabID,xBactID))
	 		Quit:xBactID=""
	 		
	 		Set xSubID = ""
	 		For {
		 		Set xSubID = $o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",aINFLabID,xBactID,xSubID))
	 			Quit:xSubID=""
	 			
	 			Set xID = aINFLabID_"||"_xSubID
	 			Set objLabBact = ##Class(DHCHAI.IR.INFLabBact).GetObjById(xID)
	 			Continue:'$IsObject(objLabBact)
	 			
	 			Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(xBactID)
	 			Continue:'$IsObject(objBact)
	 			
	 			Set Bacteria = objBact.BTBacDesc
	 			Set DrugSens = objLabBact.IRDrugSens
	 		
	 			For indx = 1:1:DrugSens.Count(){
		 			Set LabSen = DrugSens.GetAt(indx)
		 			Set objAnti = LabSen.IRAntiDicDr
		 			Set objDrugSen = LabSen.IRDrugSenDr
		 			If ($IsObject(objAnti))&&($IsObject(objDrugSen)) {		 		
			 			Set AntID = objAnti.%Id()
			 			Set AntDesc = objAnti.BTAntDesc
			 			Set SensitivityID = objDrugSen.%Id()
			 			Set Sensitivity = objDrugSen.BTDesc
			 			Set Data=$lb(xBactID,Bacteria,AntID,AntDesc,SensitivityID,Sensitivity)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
		 			}Else {
			 			Set Data=$lb(xBactID,Bacteria,"","","","")
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
		 			}
		 		}
		 	}
	 	}
 	}else{
		Set objLabRep = ##class(DHCHAI.DP.LabVisitReport).GetReportByID(aLabRepID)
		Quit:'$IsObject(objLabRep) $$$OK
		
		Set SCode = objLabRep.LabSCode
		Set xReportID = objLabRep.%Id()
		Set xReusltID = ""
		For {
			Set xReusltID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xReportID,xReusltID))
			Quit:xReusltID=""
			
			Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xReusltID)
			Continue:'$IsObject(objResult)
			
			// 细菌
			Set Bacteria   = objResult.LabResult
			Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			Continue:'$isobject(objBactMap)
			Continue:objBactMap.BTIsActive=0
			Continue:'$isobject(objBactMap.BTMapItemDr)
			Set BacteriaID = objBactMap.BTMapItemDr.%Id()
			Set Bacteria = objBactMap.BTMapItemDr.BTBacDesc
			If ($d(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID))) {
				Set xAntDesc=""
				For {
					Set xAntDesc = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc))
					Quit:xAntDesc=""
					
					Set xSenID = ""
					For {
						Set xSenID = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc,xSenID))
						Quit:xSenID=""
					
						Set objRstSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
						Continue:'$isobject(objRstSen)
						
						Set AntCode 	= objRstSen.LabAntCode
						Set AntDesc 	= objRstSen.LabAntDesc
						Set objAntiMap = ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntDesc)
					
						Continue:'$isobject(objAntiMap)
						Continue:objAntiMap.BTIsActive=0
						Continue:'$isobject(objAntiMap.BTMapItemDr)
						Set AntID = objAntiMap.BTMapItemDr.%Id()
						Set AntDesc = objAntiMap.BTMapItemDr.BTAntDesc
						Set AntCode = objAntiMap.BTMapItemDr.BTAntCode
						
						Set Sensitivity = objRstSen.LabSensitivity
						Set SenPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
						Continue:SenPhraseMap=""
						
						Set SensitivityID = $p(SenPhraseMap,"^",1)
						Set Sensitivity = $p(SenPhraseMap,"^",3)
						
						Set Data=$lb(BacteriaID,Bacteria,AntID,AntDesc,SensitivityID,Sensitivity)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}Else {
				Set Data=$lb(BacteriaID,Bacteria,"","","","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}

	}
	Quit $$$OK
}

ClassMethod QryLabBactSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabBactSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactSenExecute ]
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
