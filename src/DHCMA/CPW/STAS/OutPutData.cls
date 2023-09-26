/// 名称: DHCMA.CPW.STAS.OutPutData
/// 描述: 临床路径 输出数据
/// 编写者：jiangpengpeng
/// 编写日期: 2019-03-21
Class DHCMA.CPW.STAS.OutPutData Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  按出院日期统计
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWByDate","2018-12","2019-01","","1")
Query QryCPWByDate(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String) As %Query(ROWSPEC = "ind:%String,InLocID:%String,InLocDesc:%String,PathTypeID:%Integer,PathTypeDesc:%String,PathID:%Integer,PathDesc:%String,PathSDID:%Integer,PathSDDesc:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,InHospDays:%Integer,Fees:%Float,ReAdmCount:%Integer,OutCP24hCount:%Integer,OprInHospDays:%Integer,HealingCount:%Integer,BetterCount:%Integer,DeadCount:%Integer,OprInfCount:%Integer,ReOperCount:%Integer,DrugCost:%Float,LabCost:%Float,MaterialCost:%Float,PreDrugCount:%Integer,TPharmacyCount:%Integer,PharmacyCount:%Integer,PharmacyDays:%Integer,PharmacyCost:%Float,ReAdmIn14Count:%Integer,ReAdmIn31Count:%Integer,ComplCount:%Integer,ComplCount2:%Integer,DischCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!1"
  	Set aDateFrom=$zdh(aDateFrom_"-01",3)
 	Set aDateTo=$zdh(aDateTo_"-01",3)
 	
 	Set xDate=aDateFrom-1
 	For {
 		Set xDate=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate))
 		Quit:xDate=""
 		Quit:xDate>aDateTo
 		
 		Set xHospID=""
 		For {
	 		Set xHospID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID))
 			Quit:xHospID=""
 			Continue:(aHospID'="")&((","_aHospID_",")'[(","_xHospID_","))
 			Set ListLocID=""
	 		Set xLocID=""
	 		For {
	 			Set xLocID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID))
	 			Quit:xLocID=""
	 			
	 			Continue:(aLocID'="")&&(aLocID'=xLocID)
	 			Set IsCount="Y"
	 			
	 			Set ListPath=""
	 			Set xPathID=""
	 			For {
	 				Set xPathID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID,xPathID))
	 				Quit:xPathID=""
	 				
	 				Set ListPath=ListPath_$lb(xPathID)
	 				Set xID=""
	 				For {
	 					Set xID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID,xPathID,xID))
	 					Quit:xID=""
	 					
	 					Set objData=##class(DHCMA.CPW.STA.DataResults).GetObjById(xID)
		 				Continue:'$IsObject(objData)
		 				
						Set InLocID=objData.STAInLocID
						
						Set InLocDesc=objData.STAInLocDesc
						Set PathTypeID=objData.STAPathTypeID
						Set PathTypeDesc=objData.STAPathTypeDesc
						Set PathID=objData.STAPathID
						Set PathDesc=objData.STAPathDesc
						Set PathSDID=objData.STAPathSDID
						Continue:(aSDID'="")&&(aSDID'=PathSDID)
						Set PathSDDesc=objData.STAPathSDDesc
						Set ForCPCount=+objData.STAForCPCount
						Set InCPCount=+objData.STAInCPCount
						Set OutCPCount=+objData.STAOutCPCount
						Set ClsCPCount=+objData.STAClsCPCount
						Set VarCPCount=+objData.STAVarCPCount
						Set HasHAICount=+objData.STAHAICount
						Set InHospDays=+objData.STAInHospDays
						Set Fees=objData.STAFees
						
						Set ReAdmCount=+objData.STAReAdmCount
						Set OutCP24hCount=+objData.STAOutCP24HCount
						Set OprInHospDays=+objData.STAOprInHospDays
						Set HealingCount=+objData.STAHealingCount
						Set BetterCount=+objData.STABetterCount
						Set DeadCount=+objData.STADeadCount
						Set OprInfCount=+objData.STAOprInfCount
						Set ReOperCount=+objData.STAReOperCount
						Set DrugCost=objData.STADrugCost
						Set LabCost=objData.STALabCost
						Set MaterialCost=objData.STAMaterialCost
						Set PreDrugCount=+objData.STAPreDrugCount
						Set TPharmacyCount=+objData.STA3PharmacyCount
						Set PharmacyCount=+objData.STAPharmacyCount
						Set PharmacyDays=+objData.STAPharmacyDays
						Set PharmacyCost=objData.STAPharmacyCost
						Set ReAdmIn14Count=+objData.STAReAdmIn14Count
						Set ReAdmIn31Count=+objData.STAReAdmIn31Count
						Set ComplCount=+objData.STAComplCount
						Set ComplCount2=+objData.STAComplCount2
						//因为出院人数（STADischCount）是指每个月科室总出院人数，在报表里不能累加，
						//只能计算一次
						Set DischCount=$Case(IsCount,"Y":+objData.STADischCount,:0)
						Set IsCount="N"
						Set Data=$lb(ind,InLocID,InLocDesc,PathTypeID,PathTypeDesc,PathID,PathDesc,PathSDID,PathSDDesc,
									 ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,InHospDays,Fees,
									 ReAdmCount,OutCP24hCount,OprInHospDays,HealingCount,BetterCount,DeadCount,OprInfCount,
									 ReOperCount,DrugCost,LabCost,MaterialCost,PreDrugCount,TPharmacyCount,PharmacyCount,
									 PharmacyDays,PharmacyCost,ReAdmIn14Count,ReAdmIn31Count,ComplCount,ComplCount2,DischCount
									)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
	 				}
	 			}
	 			Set xPathDr=""
			 	For {
				 	Set xPathDr = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr))
				 	Quit:xPathDr=""
					
					Continue:($listfind(ListPath,xPathDr)>0)
					Set xID = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr,0))
					
				 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathDr)
					Continue:'$IsObject(obj)
				 	Continue:+obj.BTIsActive'=1  
				 	
				 	Set Desc = obj.BTDesc
				 	Set TypeID="",TypeDesc=""
				 	If $IsObject(obj.BTTypeDr) { 
						Set TypeID  =obj.BTTypeDr.%Id()
				 		Set TypeDesc=obj.BTTypeDr.BTDesc
					}
					Set PathSDID="",PathSDDesc=""
					If $IsObject(obj.BTEntityDr) { 
						Set PathSDID  =obj.BTEntityDr.%Id()
				 		Set PathSDDesc=obj.BTEntityDr.BTDesc
					}
				 	Set Data=$lb(ind,InLocID,InLocDesc,TypeID,TypeDesc,xPathDr,Desc,PathSDID,PathSDDesc,0,0,0,0,0,0,0,0,
				 				 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				 				)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}	
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
/// CreatDate：   2018-11-27
/// Description:  查询明细信息
/// Table：       DHCMA.CPW.STA.DataDetails
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPat","2019-06","2019-06","F","47","","280!!1","1")
Query QryCPWPat(aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,PathSDID:%String,PathSDDesc:%String,PathID:%String,PathDesc:%String,CPWStatus:%String,InDate:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutUserDesc:%String,OutLocDesc:%String,ClsDate:%String,ClsUser:%String,ClsLocDesc:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,AdmDays:%String,AdmFees:%String,IsHAI:%String,DocName:%String,OutReason:%String,OutTxt:%String,NotReason:%String,NotTxt:%String,DischLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPatExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aStatus="")||(aHospID="") $$$OK
 	s ^tmpff=$lb(aDateFrom,aDateTo,aStatus,aSDID,aPathID,aLocID,aHospID)
 	Set aDateFrom=$zdh(aDateFrom_"-01",3)
 	Set aDateTo=$zdh(aDateTo_"-01",3)
 	Set xDate=aDateFrom-1
 	For {
 		Set xDate=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate))
 		Quit:xDate=""
 		Quit:xDate>aDateTo
 		
 		Set xHospID=""
 		For {
	 		Set xHospID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID))
 			Quit:xHospID=""
 			Continue:(aHospID'="")&((","_aHospID_",")'[(","_xHospID_","))
 			
	 		Set xLocID=""
	 		For {
	 			Set xLocID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID))
	 			Quit:xLocID=""
	 			
	 			Continue:(aLocID'="")&&(aLocID'=xLocID)
	 			
	 			Set xPathID=""
	 			For {
	 				Set xPathID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID,xPathID))
	 				Quit:xPathID=""
	 				
	 				Continue:(aPathID'="")&&(aPathID'=xPathID)
	 				
	 				Set xID=""
	 				For {
	 					Set xID=$o(^DHCMA.CPW.STA.DataResultsI("IdxofDate",xDate,xHospID,xLocID,xPathID,xID))
	 					Quit:xID=""
	 					
	 					Set objData=##class(DHCMA.CPW.STA.DataResults).GetObjById(xID)
		 				Continue:'$IsObject(objData)
		 				
						Set PathSDID=objData.STAPathSDID
						Continue:(aSDID'="")&&(aSDID'=PathSDID)
						
						Set PathSDDesc=objData.STAPathSDDesc
						Set PathID=objData.STAPathID
						Set PathDesc=objData.STAPathDesc
						
						Set ParrefID=xID
						Set xCPWID=""
						For {
							Set xCPWID=$o(^DHCMA.CPW.STA.DataResultsI("Child","IdxofType",ParrefID,aStatus,xCPWID))
							Quit:xCPWID=""
							
							Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
							Continue:'$IsObject(objPathway)
							
							Set EpisodeID=objPathway.CPEpisodeID
							set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
							Continue:'$IsObject(objPat)
							
							Set PatientID=objPat.PAPatientID
							Set PapmiNo=objPat.PAPapmiNo
							Set MrNo=objPat.PAMrNo
							Set PatName=objPat.PAPatName
							Set PatSex=objPat.PASex
							Set PatSex=$Case(PatSex,"M":"男","F":"女",:"")
							Set PatAge=objPat.PAAge
							Set DischDate=objPat.PADischDate
							Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
							Set AdmDays=objPat.PAAdmDays	//住院天数
							Set DocID=objPat.PAAdmDocID
							Set DocName=""
							Set objDoc=##class(DHCMA.Util.EP.CareProv).GetObjByOID(DocID)
							Set:$IsObject(objDoc) DocName=objDoc.BTDesc
							Set DischLocID=objPat.PAAdmLocID
							Set DischLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(DischLocID)
							Set:$IsObject(objLoc) DischLocDesc=objLoc.BTDesc
					
							Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
    						Set AdmFees=$p(FeeStr,"^",1)
    						Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)	//是否发生院感
    						Set IsHAI=$Case(IsHAI,"1":"是",:"否")
							Set CPWStatus=objPathway.CPStatus
							Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","T":"不入径","U":"作废","P":"预约","A":"申请",:"")
							
							Set (OutReason,OutTxt,NotReason,NotTxt)=""
							If (CPWStatus="不入径") {
								Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
								If ($IsObject(objDic)) {
									Set TypeID=objDic.%Id()
									Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
									If (xsubID'="") {
										Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
										If ($IsObject(objApp)) {
											Set NotReason=objApp.CPReasonDr.BTDesc
											Set NotTxt=objApp.CPApplyTxt
										}
									}
								}
							}
							If (CPWStatus="出径") {
								Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","出径原因")
								If ($IsObject(objDic)) {
									Set TypeID=objDic.%Id()
									Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
									If (xsubID'="") {
										Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
										If ($IsObject(objApp)) {
											Set OutReason=objApp.CPReasonDr.BTDesc
											Set OutTxt=objApp.CPApplyTxt
										}
									}
								}
							}
							Set InDate=objPathway.CPInDate
							Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
							Set InUserID=objPathway.CPInUserID
							Set InUserDesc=""
							Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
							Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
							Set InLocID=objPathway.CPInLocID
							Set InLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
							Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
							Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
							
							Set OutDate=objPathway.CPOutDate
							Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
							Set OutUserID=objPathway.CPOutUserID
							Set OutUserDesc=""
							Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
							Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
							Set OutLocID=objPathway.CPOutLocID
							Set OutLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
							Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
							Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
							
							Set (ClsDate,ClsUser,ClsLocDesc)=""
							If (CPWStatus="完成") {
								Set ClsDate=OutDate
								Set ClsUser=OutUserDesc
								Set ClsLocDesc=OutLocDesc
								Set OutDate=""
								Set OutUserDesc=""
								Set OutLocDesc=""
							}
						
							Set Data=$lb(ind,xCPWID,PathSDID,PathSDDesc,PathID,PathDesc,CPWStatus,InDate,InUserDesc,InLocDesc,OutDate,OutUserDesc,OutLocDesc,ClsDate,ClsUser,ClsLocDesc,
										EpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,AdmDays,AdmFees,IsHAI,DocName,OutReason,OutTxt,NotReason,NotTxt,DischLocDesc)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
	 				}
	 			}
	 		}
 		}
 	}
 	
	 			
 	
 	Quit $$$OK
}

ClassMethod QryCPWPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPatExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPatExecute ]
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
/// CreatDate：   2018-11-27
/// Description:  查询变异信息
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWVar","1")
Query QryCPWVar(aPathwayID As %String) As %Query(ROWSPEC = "ind:%String,PathwayID:%String,VarID:%String,VariatCat:%String,VariatTxt:%String,ActDate:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarExecute(ByRef qHandle As %Binary, aPathwayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="") $$$OK
 	
 	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"VAR",xVarID))
		Quit:xVarID=""
		
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
	 	
	 	Set VariatTxt=objVar.CPVariatTxt
 		Set VariatCat=objVar.CPVariatDr.BTDesc
 		Set ActDate=objVar.CPActDate
 		Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
 		Set ActUserID=objVar.CPActUserID
 		Set ActUserDesc=""
		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		Set:$IsObject(objUser) ActUserDesc=objUser.BTDesc
		
		Set Data=$lb(ind,aPathwayID,xVarID,VariatCat,VariatTxt,ActDate,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
						
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarExecute ]
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

/// Creator：    dengshaopeng
/// CreatDate：   2020-05-07
/// Description:  按出院日期统计每天数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWByDateOfDay","2019-01-01","2020-03-01","","2","")
Query QryCPWByDateOfDay(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,SDID:%String,SDDesc:%String,PathMastID:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String,PathwayVarTime:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWByDateOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmLocDesc = objEpisode.PAAdmLocDesc
    		
    		Continue:(aLocID'="")&&(aLocID'=AdmLocID)&&(aLocType="Adm")
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set EpisodeID=objEpisode.OID
    		
			Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
			
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Quit:xPathwayID=""
			
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			
			Continue:'$IsObject(objPathway)
	 		//Continue:objPathway.CPFormDr.FormIsActive'=1
	 		//Continue:objPathway.CPFormDr.FormIsOpen'=1
	 		//Continue:objPathway.CPFormDr.FormVerDate=""
	 		Set (SDID,SDDesc)=""
	 		Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
	 		Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
	 		Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=SDID)
	 		Set PathMastID = objPathway.CPFormDr.FormPathDr.%Id()
	 		Set InLocID =  objPathway.CPInLocID //$p(AdmLocID,"!!",1) 
	 		Continue:(aLocID'="")&&(aLocID'=InLocID)&&(aLocType="InP")
	 		Set AdmLocID = $p(AdmLocID,"!!",1) 
	 		
	 		If aLocType="InP"{
		 		Set AdmLocDesc = ""
		 		Set AdmLocID = ""
		 		Set:InLocID'="" AdmLocID = $p(InLocID,"!!",1)
		 		Set objAdmLoc=##class(DHCMA.Util.EP.Location).xGetByOID(InLocID)
		 		Set:$IsObject(objAdmLoc) AdmLocDesc=objAdmLoc.BTDesc	
		 	}
	 		
	 		Set Status=objPathway.CPStatus
	 		Set:Status'="" ForCPCount =ForCPCount+1
	 		Set:Status'="T" InCPCount =InCPCount+1
	 		Set:Status="O" OutCPCount =OutCPCount+1
	 		Set:Status="C" ClsCPCount =ClsCPCount+1
	 		
	 		Set PathwayVarflg=0
	 		Set PathwayVarTime=0 //每个路径的变异例次
	 		Set xPathwayVarId=""
	 		For{
		 		Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xPathwayVarId))
		 		Quit:xPathwayVarId=""
		 		//Quit:PathwayVarflg=1
		 		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xPathwayVarId)
		 		Continue:'$IsObject(objVar)
		 		Set:objVar.CPIsActive=1 PathwayVarflg=1,PathwayVarTime = PathwayVarTime+1
		 		}
	 		Set:PathwayVarflg=1 VarCPCount = VarCPCount+1
	 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
	 		
	 		Set EpisodeID=objPathway.CPEpisodeID
	 		
	 		Set PatData =  ..GetPatData(EpisodeID)
	 		Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)
	 		Set:IsHAI=1 HasHAICount=HasHAICount+1
	 		
	 		Set caps=1
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,10,caps:0)  //住院天数清零
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,11,caps:0)  //费用清空
	 		
	 		//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		Continue:DischDate=""
	 		//Set OrdData = ..GetOrdData(objPathway)
	 		
			Set Data=$lb(ind)_CPWData_PatData_$lb(ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,SDID,SDDesc,PathMastID,InLocID,AdmLocID,AdmLocDesc,PathwayVarTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
    	}
    }
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWByDateOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByDateOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByDateOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByDateOfDayExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2020-06-08
/// Description:  按天查询明细信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPatOfDay","2019-01-01","2020-06-01","F","","","","2")
Query QryCPWPatOfDay(aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,PathSDID:%String,PathSDDesc:%String,PathID:%String,PathDesc:%String,CPWStatus:%String,InDate:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutUserDesc:%String,OutLocDesc:%String,ClsDate:%String,ClsUser:%String,ClsLocDesc:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,AdmDays:%String,AdmFees:%String,IsHAI:%String,DocName:%String,OutReason:%String,OutTxt:%String,NotReason:%String,NotTxt:%String,DischLocDesc:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPatOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aStatus="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)	
		
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmLocDesc=objEpisode.PAAdmLocDesc
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		
    		Set EpisodeID=objEpisode.OID
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
		 	
		 
		 	Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
	 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
	 		Continue:xCPWID=""
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			Continue:'$IsObject(objPathway)
			Set (SDID,SDDesc)=""
	 		Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
	 		Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
	 		Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=SDID)
			Set PathID = objPathway.CPFormDr.FormPathDr.%Id()
			Continue:(aPathID'="")&&(aPathID'=PathID)
			Set PathDesc = objPathway.CPFormDr.FormPathDr.BTDesc
						
					
			Set EpisodeID=objPathway.CPEpisodeID
			set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
			Continue:'$IsObject(objPat)
								
			Set PatientID=objPat.PAPatientID
			Set PapmiNo=objPat.PAPapmiNo
			Set MrNo=objPat.PAMrNo
			Set PatName=objPat.PAPatName
			Set PatSex=objPat.PASex
			Set PatSex=$Case(PatSex,"M":"男","F":"女",:"")
			Set PatAge=objPat.PAAge
			Set DischDate=objPat.PADischDate
			Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Continue:DischDate=""
			Set AdmDays=objPat.PAAdmDays 	//住院天数
			Set DocID=objPat.PAAdmDocID
			Set DocName=""
			Set objDoc=##class(DHCMA.Util.EP.CareProv).GetObjByOID(DocID)
			Set:$IsObject(objDoc) DocName=objDoc.BTDesc
			Set DischLocID=objPat.PAAdmLocID
			Set DischLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(DischLocID)
			Set:$IsObject(objLoc) DischLocDesc=objLoc.BTDesc
			
			Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
	    	Set AdmFees=$p(FeeStr,"^",1)
	    	Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)	//是否发生院感
	    	Set IsHAI=$Case(IsHAI,"1":"是",:"否")
			Set CPWStatus=objPathway.CPStatus
			Continue:(aStatus="I")&&(CPWStatus="T")
			Continue:(aStatus="O")&&(CPWStatus'="O")
			Continue:(aStatus="C")&&(CPWStatus'="C")
			Set PathwayVarflg=0
	 		Set xPathwayVarId=""
	 		For{
		 		Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xPathwayVarId))
		 		Quit:xPathwayVarId=""
		 		Quit:PathwayVarflg=1
		 		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xPathwayVarId)
		 		Continue:'$IsObject(objVar)
		 		Set:objVar.CPIsActive=1 PathwayVarflg=1
		 	}
			Continue:(aStatus="V")&&(PathwayVarflg'=1)
			Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","T":"不入径","U":"作废","P":"预约","A":"申请",:"")
								
			Set (OutReason,OutTxt,NotReason,NotTxt)=""
			If (CPWStatus="不入径") {
				Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
				If ($IsObject(objDic)) {
					Set TypeID=objDic.%Id()
					Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
					If (xsubID'="") {
						Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
						If ($IsObject(objApp)) {
							Set NotReason=objApp.CPReasonDr.BTDesc
							Set NotTxt=objApp.CPApplyTxt
						}
					}
				}
			}
			If (CPWStatus="出径") {
				Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","出径原因")
				If ($IsObject(objDic)) {
					Set TypeID=objDic.%Id()
					Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
					If (xsubID'="") {
						Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
						If ($IsObject(objApp)) {
							Set OutReason=objApp.CPReasonDr.BTDesc
							Set OutTxt=objApp.CPApplyTxt
						}
					}
				}
			}
			Set InDate=objPathway.CPInDate
			Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
			Set InUserID=objPathway.CPInUserID
			Set InUserDesc=""
			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
			Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
			Set InLocID=objPathway.CPInLocID
			//Continue:(aLocID'="")&&(aLocID'=InLocID)
			Continue:(aLocID'="")&&(aLocID'=$p(InLocID,"!!",1))&&(aLocType="InP")
			
			Set:aLocType="InP" AdmLocID=$p(InLocID,"!!",1)
			
			Set InLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
			Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
			Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			
							
			Set OutDate=objPathway.CPOutDate
			Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
			Set OutUserID=objPathway.CPOutUserID
			Set OutUserDesc=""
			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
			Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
			Set OutLocID=objPathway.CPOutLocID
			Set OutLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
			Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
			Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
							
			Set (ClsDate,ClsUser,ClsLocDesc)=""
			If (CPWStatus="完成") {
				Set ClsDate=OutDate
				Set ClsUser=OutUserDesc
				Set ClsLocDesc=OutLocDesc
				Set OutDate=""
				Set OutUserDesc=""
				Set OutLocDesc=""
			}		
			Set Data=$lb(ind,xCPWID,PathSDID,PathSDDesc,PathID,PathDesc,CPWStatus,InDate,InUserDesc,InLocDesc,OutDate,OutUserDesc,OutLocDesc,ClsDate,ClsUser,ClsLocDesc,
						EpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,AdmDays,AdmFees,IsHAI,DocName,OutReason,OutTxt,NotReason,NotTxt,DischLocDesc,InLocID,AdmLocID,AdmLocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
							
			
		}
	}		 			
 	Quit $$$OK
}

ClassMethod QryCPWPatOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPatOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPatOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPatOfDayExecute ]
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

/// Creator：    dengshaopeng
/// CreatDate：   2021-10-28
/// Description:  按出院日期统计出径变异数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWVarAndOutDateOfDay","2019-01-01","2020-03-01","","2","")
Query QryCPWVarAndOutDateOfDay(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,SDID:%String,SDDesc:%String,PathMastID:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String,PathwayVarTime:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWVarAndOutDateOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmLocDesc = objEpisode.PAAdmLocDesc
    		
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set EpisodeID=objEpisode.OID
    		
 			
    		Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
			
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xPathwayID=""
			
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			
			Continue:'$IsObject(objPathway)
	 		//Continue:objPathway.CPFormDr.FormIsActive'=1
	 		//Continue:objPathway.CPFormDr.FormIsOpen'=1
	 		//Continue:objPathway.CPFormDr.FormVerDate=""
	 		Set (SDID,SDDesc)=""
	 		Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
	 		Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
	 		Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=SDID)
	 		Set PathMastID = objPathway.CPFormDr.FormPathDr.%Id()
	 		Set InLocID =  objPathway.CPInLocID //$p(AdmLocID,"!!",1) 
	 		Continue:(aLocID'="")&&(aLocID'=InLocID)&&(aLocType="InP")
	 		Set AdmLocID = $p(AdmLocID,"!!",1) 
	 		
	 		If aLocType="InP"{
		 		Set AdmLocDesc = ""
		 		Set AdmLocID = ""
		 		Set:InLocID'="" AdmLocID = $p(InLocID,"!!",1)
		 		Set objAdmLoc=##class(DHCMA.Util.EP.Location).xGetByOID(InLocID)
		 		Set:$IsObject(objAdmLoc) AdmLocDesc=objAdmLoc.BTDesc	
		 	}
	 		
	 		Set Status=objPathway.CPStatus
	 		Set:Status'="" ForCPCount =ForCPCount+1
	 		Set:Status'="T" InCPCount =InCPCount+1
	 		Set:Status="O" OutCPCount =OutCPCount+1
	 		Set:Status="C" ClsCPCount =ClsCPCount+1
	 		
	 		Set PathwayVarflg=0
	 		Set PathwayVarTime=0 //每个路径的变异例次
	 		Set xPathwayVarId=""
	 		For{
		 		Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xPathwayVarId))
		 		Quit:xPathwayVarId=""
		 		//Quit:PathwayVarflg=1
		 		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xPathwayVarId)
		 		Continue:'$IsObject(objVar)
				Set CPVarTypeDesc = objVar.CPVariatDr.BTTypeDr.BTDesc    //变异原因类型
				Continue:CPVarTypeDesc'["变异"
		 		Set:objVar.CPIsActive=1 PathwayVarflg=1,PathwayVarTime = PathwayVarTime+1
		 		}
	 		Set:PathwayVarflg=1 VarCPCount = VarCPCount+1
	 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
	 		
	 		Set EpisodeID=objPathway.CPEpisodeID
	 		
	 		Set PatData =  ..GetPatData(EpisodeID)
	 		Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)
	 		Set:IsHAI=1 HasHAICount=HasHAICount+1
	 		
	 		Set caps=1
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,10,caps:0)  //住院天数清零
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,11,caps:0)  //费用清空
	 		
	 		//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		//Continue:DischDate=""
	 		//Set OrdData = ..GetOrdData(objPathway)
	 		Continue:InCPCount=0	//add by zqy 过滤没有入经的数据
			Set Data=$lb(ind)_CPWData_PatData_$lb(ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,SDID,SDDesc,PathMastID,InLocID,AdmLocID,AdmLocDesc,PathwayVarTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	}
    }
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarAndOutDateOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarAndOutDateOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarAndOutDateOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarAndOutDateOfDayExecute ]
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

/// Description:  查询病人出入径及变异情况
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPathWayVar","2019-01-01","2020-06-01","","")
Query QryCPWPathWayVar(aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,CPVarID:%String,CPVariatDesc:%String,CPVarTypeDesc:%String,CPStatus:%String,xCPInLocId:%String,CPVarPathEpsiDesc:%String,CPVarUserDesc:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%String,PatCost:%String,PAAdmType:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPathWayVarExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Set:aLocID["所有" aLocID=""
	Set:aSDID["所有" aSDID=""
	
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'[$p(AdmHospID,"!!",1))
    		
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set AdmDays=objEpisode.PAAdmDays	//住院天数
    		Set EpisodeID=objEpisode.OID
		 	
	 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
	 		Continue:xCPWID=""
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			Continue:'$IsObject(objPathway)
			Set EpisodeID = objPathway.CPEpisodeID    
			Set CPStatus = objPathway.CPStatus 	     //路径状态
			Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
			Set PatData = ..GetPatData(EpisodeID)
			Set InLocID = objPathway.CPInLocID
			Continue:(aLocID'="")&&(aLocID'=$p(InLocID,"!!",1))&&(aLocType="InP")
			
			Set:aLocType="InP" AdmLocID=$p(InLocID,"!!",1)
			
			Set (SDID,SDDesc)=""
	 		Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
	 		Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
	 		Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
			Continue:(aSDID'="")&&(aSDID'=SDID)
			
			//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		//Continue:DischDate=""
			
			Set xPathWayVarId=""
			for {
				Set xPathWayVarId=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xPathWayVarId))
				Quit:xPathWayVarId=""
				Set objPathWayVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xPathWayVarId)
				Continue:'$IsObject(objPathWayVar)
				Set CPVariatDesc=objPathWayVar.CPVariatDr.BTDesc          //变异原因
				Set CPVarID = objPathWayVar.%Id()
				Set CPVarTypeDesc = objPathWayVar.CPVariatDr.BTTypeDr.BTDesc    //变异原因类型
				Continue:CPVarTypeDesc'["变异"
				Continue:objPathWayVar.CPIsActive'=1
				//Continue:CPStatus="O"
				Set CPStatus="Var"
				Set CPVarCatDesc = objPathWayVar.CPVariatDr.BTCatDr.BTDesc      //变异原因分类
				Set CPVarPathEpsiDesc = objPathWayVar.CPEpisDr.CPFormEpDr.EpDesc  //变异阶段
				Set CPVarUserId = objPathWayVar.CPActUserID
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(CPVarUserId)
				Set:$IsObject(objUser) CPVarUserDesc=objUser.BTDesc
				
				Set Data=$lb(ind,EpisodeID,CPVarID,CPVariatDesc,CPVarTypeDesc,CPStatus,xCPInLocId,CPVarPathEpsiDesc,CPVarUserDesc)_CPWData_PatData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
			Set xPathwayApplyId=""
			for{
				Set xPathwayApplyId=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"APPLY",xPathwayApplyId))
				Quit:xPathwayApplyId=""
				Set objPathwayApply = ##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xPathwayApplyId)
				Continue:'$IsObject(objPathwayApply)
				Set PathwayApplyID = objPathwayApply.%Id()
				Set ApplyTypeDesc = objPathwayApply.CPTypeDr.BTDesc  //申请类型
				Continue:objPathway.CPStatus'="O"					 //出径申请判断
				Set CPStatus="O"
				Set ApplyReasonDesc = objPathwayApply.CPReasonDr.BTDesc  //申请原因
				Set ApplyUserId = objPathwayApply.CPActUserID
				Set ApplyUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ApplyUserId)
				Set:$IsObject(ApplyUser) ApplyUserDesc=ApplyUser.BTDesc
				
				Set Data=$lb(ind,EpisodeID,PathwayApplyID,ApplyReasonDesc,ApplyTypeDesc,CPStatus,xCPInLocId,"",ApplyUserDesc)_CPWData_PatData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
		}
	}
	
 	Quit $$$OK
}

ClassMethod QryCPWPathWayVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPathWayVarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPathWayVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPathWayVarExecute ]
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

/// Creator：    dengshaopeng
/// CreatDate：   2021-10-28
/// Description:  按出院日期统计费用住院日数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWCostAndDaysDateOfDay","2019-01-01","2020-03-01","","2","")
Query QryCPWCostAndDaysDateOfDay(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%Integer,PatCost:%Integer,PAAdmType:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,SDID:%String,SDDesc:%String,PathMastID:%String,InLocID:%String,AdmLocID:%String,AdmLocDesc:%String,PathwayVarTime:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWCostAndDaysDateOfDayExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aSDID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmLocDesc = objEpisode.PAAdmLocDesc
    		
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))&&(aLocType="Adm")
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		//出院患者
    		//Set HospStatus=objEpisode.PAVisitStatus
    		//Continue:HospStatus'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		
    		Set EpisodeID=objEpisode.OID
    		
			Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
			
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xPathwayID=""
			
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			
			Continue:'$IsObject(objPathway)
	 		//Continue:objPathway.CPFormDr.FormIsActive'=1
	 		//Continue:objPathway.CPFormDr.FormIsOpen'=1
	 		//Continue:objPathway.CPFormDr.FormVerDate=""
	 		Set (SDID,SDDesc)=""
	 		Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
	 		Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
	 		Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
	 		Continue:(aSDID'="")&&(aSDID'=SDID)
	 		Set PathMastID = objPathway.CPFormDr.FormPathDr.%Id()
	 		Set InLocID =  objPathway.CPInLocID //$p(AdmLocID,"!!",1) 
	 		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(InLocID,"!!",1))&&(aLocType="InP")
	 		Set AdmLocID = $p(AdmLocID,"!!",1) 
	 		
	 		If aLocType="InP"{
		 		Set AdmLocDesc = ""
		 		Set AdmLocID = $p(InLocID,"!!",1)
		 		Set objAdmLoc=##class(DHCMA.Util.EP.Location).xGetByOID(InLocID)
		 		Set:$IsObject(objAdmLoc) AdmLocDesc=objAdmLoc.BTDesc	
		 	}
	 		
	 		Set Status=objPathway.CPStatus
	 		Set:Status'="" ForCPCount =ForCPCount+1
	 		Set:Status'="T" InCPCount =InCPCount+1
	 		Set:Status="O" OutCPCount =OutCPCount+1
	 		Set:Status="C" ClsCPCount =ClsCPCount+1
	 		
	 		Set PathwayVarflg=0
	 		Set PathwayVarTime=0 //每个路径的变异例次
	 		Set xPathwayVarId=""
	 		For{
		 		Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xPathwayVarId))
		 		Quit:xPathwayVarId=""
		 		//Quit:PathwayVarflg=1
		 		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xPathwayVarId)
		 		Continue:'$IsObject(objVar)
		 		Set:objVar.CPIsActive=1 PathwayVarflg=1,PathwayVarTime = PathwayVarTime+1
		 		}
	 		Set:PathwayVarflg=1 VarCPCount = VarCPCount+1
	 		Set CPWData =  ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData(objPathway)
	 		
	 		Set EpisodeID=objPathway.CPEpisodeID
	 		
	 		Set PatData =  ..GetPatData(EpisodeID)
	 		Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)
	 		Set:IsHAI=1 HasHAICount=HasHAICount+1
	 		
	 		Set caps=1
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,10,caps:0)  //住院天数清零
	 		Set:Status="T" PatData = $LISTUPDATE(PatData,11,caps:0)  //费用清空
	 		
	 		//过滤门诊
	 		Set PAAdmType=$lg(PatData,12)
	 		Continue:PAAdmType'["I"
	 		//过滤未出院信息
	 		Set DischDate=$lg(PatData,9)
	 		Continue:DischDate=""
	 		//Set OrdData = ..GetOrdData(objPathway)
	 		
			Set Data=$lb(ind)_CPWData_PatData_$lb(ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,SDID,SDDesc,PathMastID,InLocID,AdmLocID,AdmLocDesc,PathwayVarTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	  	}
    }
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWCostAndDaysDateOfDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWCostAndDaysDateOfDayExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWCostAndDaysDateOfDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWCostAndDaysDateOfDayExecute ]
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

/// 获取就诊信息
ClassMethod GetPatData(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=$Lb("")
	Quit:aEpisodeID="" return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID
	Set PapmiNo=objPat.PAPapmiNo
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmDate=objPat.PAAdmDate
	Set DischDate=objPat.PADischDate
	Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
	Set:InHospDate=0 InHospDate=1
	Set InHospDate=InHospDate
	Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	
	Set paadm=$p(aEpisodeID,"!!",1)
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(paadm)
	Set PatCost=$p(Feestr,"^",1)		//住院总费用。。。
	//增加过滤门诊
	Set PAAdmType=objPat.PAAdmType

	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost,PAAdmType)
	Set return=Data
	
	Quit return
}

/// CreatDate：   2020-05-07
/// Description:  按出院日期统计
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWVarOrdMXByDate","2020-06-01","2020-06-30","2")
Query QryCPWVarOrdMXByDate(aDateFrom As %String, aDateTo As %String, aPathFormId As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "ind:%String,Step:%Integer,oEpDesc:%String,oArcimDesc:%String,oArcNum:%Integer,FormDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarOrdMXByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aPathFormId As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	
 	Set xIndex="DHCMA.CPW.STAS.OutPutData"
 	Set yIndex="QryCPWVarOrdMXByDate"
 	k ^TEMP($j,$zn,xIndex,yIndex)
 	
 	Set xLocId=""
 	For {
		Set xLocId=$o(^DHCMA.CPW.CP.PathwayI("IdxofInLocDate",xLocId))
		Quit:xLocId=""
		Set AdmHospID=$p($g(^CTLOC($p(xLocId,"!!",1))),"^",22)
		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=$p(AdmHospID,"!!",1))
		For xDate=aDateFrom:1:aDateTo {
			Set xPathwayID=""
			For {
				Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofInLocDate",xLocId,xDate,xPathwayID))
				Quit:xPathwayID=""
				Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)    			
    			Continue:'$IsObject(objPathway)

		 		Set PathFormId = objPathway.CPFormDr.FormPathDr.%Id()
		 		Continue:(aPathFormId'="")&&(aPathFormId'=PathFormId)
		 		
		 		Set PWExecFlag=0
		 		Set xPWExecId=""
		 		For {
			 		Set xPWExecId=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"EXEC",xPWExecId))
			 		Quit:xPWExecId=""
			 		Set objPWExec=##class(DHCMA.CPW.CP.PathwayExec).GetObjById(xPathwayID_"||"_xPWExecId)
			 		Continue:'$IsObject(objPWExec)
			 		Continue:objPWExec.CPIsActive'=1
			 		Set PWExecFlag=1
			 	}
			 	Continue:PWExecFlag=1	//过滤掉切换路径的病人
		 		
		 		Set xPathwayEpiId=""
		 		For {
			 		Set xPathwayEpiId=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"EPIS",xPathwayEpiId))
			 		Quit:xPathwayEpiId=""
			 		Set objPathwayEpi=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(xPathwayID_"||"_xPathwayEpiId)
			 		Continue:'$IsObject(objPathwayEpi)
			 		Set PWVarInfo=##class(DHCMA.CPW.STAS.OutPutData).GetPathWayVarArc(xPathwayID,xPathwayID_"||"_xPathwayEpiId)
			 		Set VarArcDesc=$p(PWVarInfo,"$",1)
			 		Set VarArcNum=+$p(PWVarInfo,"$",2)
			 		Set FormEpId=objPathwayEpi.CPFormEpDr.%Id()
			 		;Set:VarArcDesc="" VarArcDesc="ZXXXL"
			 		;w objPathwayEpi.CPFormEpDr.EpDesc,!
			 		
					if (VarArcDesc=""){
						Set ^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId)=""
					}else{
						Set ^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId,VarArcDesc)=+$g(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId,VarArcDesc))+VarArcNum
					}
			 	}
			}
		}
		
	}
 	Set Step=0
 	Set oFormEpId=""
 	For {
	 	Set oFormEpId=$o(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",oFormEpId))
	 	Quit:oFormEpId=""
	 	Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(oFormEpId)
	 	Continue:'$IsObject(objFormEp)
	 	Set EpDesc=objFormEp.EpDesc
	 	Set EpIndNo = objFormEp.EpIndNo
	 	Set EpID = objFormEp.%Id()
	 	Set FormDesc = objFormEp.Parref.FormPathDr.BTDesc
	 	Set Step=Step+1
	 	if ($o(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",oFormEpId,""))=""){
		 	//Set Data=$lb(ind,Step,EpDesc,"","")
			//Set ^CacheTemp(repid,ind)=Data
			//Set ind=ind+1
		}else{
			Set oArcimDesc=""
		 	For {
				Set oArcimDesc=$o(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",oFormEpId,oArcimDesc))
				Quit:oArcimDesc=""
				
				Set oArcNum=+$g(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",oFormEpId,oArcimDesc))
				Set Data=$lb(ind,Step,EpDesc,oArcimDesc,oArcNum,FormDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				
			}
				
		}	
	}
 	
 	k ^TEMP($j,$zn,xIndex,yIndex)
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarOrdMXByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarOrdMXByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarOrdMXByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarOrdMXByDateExecute ]
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

/// w ##class(DHCMA.CPW.STAS.OutPutData).GetPathWayVarArc(1,"1||2")
ClassMethod GetPathWayVarArc(aPathWayId As %String, aPathWayEpiId As %String) As %String
{
	n (aPathWayId,aPathWayEpiId)
	Set return=""
	
	Q:(aPathWayId="")||(aPathWayEpiId="") return
	
	Set xPathwayVarId=""
	Set xPathwayVarId=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathWayId,aPathWayEpiId,xPathwayVarId))
	Q:xPathwayVarId="" return
	Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathWayId_"||"_xPathwayVarId)
	Q:'$IsObject(objVar) return
	Q:objVar.CPIsActive'=1 return
	Set EpisDr=objVar.CPEpisDr.%Id()
	Q:(aPathWayEpiId'=EpisDr) return
	Q:objVar.CPOrdDID="" return
 	Q:$IsObject(objVar.CPImplDr) return		//路径外医嘱没有项目指针
	
	Set xOrdDID=objVar.CPOrdDID
	Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
	Set OESubID=$p(xOrdDID,"||",2)
	Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
	Set ARCIMDesc=$p($g(^ARCIM(+OEItmMastID,1,1)),"^",2)
	Set ARCIMNum=$l(xOrdDID,"^")
	
	Set return=ARCIMDesc_"$"_ARCIMNum
	
	Q return
}

/// Creator：    dengshaopeng
/// CreatDate：   2021-11-09
/// Description:  按出院日期统计每天数据
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWByDateOfNew","2021-08-01","2021-11-11","","2","")
Query QryCPWByDateOfNew(aHospID As %String, aDateFrom As %String, aDateTo As %String, aStatTime As %String, aLocID As %String, aScreenType As %String, aSDID As %String) As %Query(ROWSPEC = "ind:%String,InLocID:%String,InLocDesc:%String,PathTypeID:%Integer,PathTypeDesc:%String,PathID:%Integer,PathDesc:%String,PathSDID:%Integer,PathSDDesc:%String,ForCPCount:%Integer,InCPCount:%Integer,OutCPCount:%Integer,ClsCPCount:%Integer,VarCPCount:%Integer,HasHAICount:%Integer,InHospDays:%Integer,Fees:%Float,ReAdmCount:%Integer,OutCP24hCount:%Integer,OprInHospDays:%Integer,HealingCount:%Integer,BetterCount:%Integer,DeadCount:%Integer,OprInfCount:%Integer,ReOperCount:%Integer,DrugCost:%Float,LabCost:%Float,MaterialCost:%Float,PreDrugCount:%Integer,TPharmacyCount:%Integer,PharmacyCount:%Integer,PharmacyDays:%Integer,PharmacyCost:%Float,ReAdmIn14Count:%Integer,ReAdmIn31Count:%Integer,ComplCount:%Integer,ComplCount2:%Integer,DischCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWByDateOfNewExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aStatTime As %String, aLocID As %String, aScreenType As %String, aSDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	Set ^zqyyyy=$lb(aHospID,aDateFrom,aDateTo,aStatTime,aLocID,aScreenType,aSDID)
 	// 获取日期范围内整月数据
	Set monthList = ##class(DHCMA.CPW.STAS.DateUtil).GetIntervalMonthList(aDateFrom,aDateTo)
	If monthList'=""{
		Set xDateFrom = $lg(monthList,1)
		Set xDateTo = $lg(monthList,-1)
		Do GetMonthData(xDateFrom,xDateTo,aLocID,aSDID,aHospID,aStatTime,aScreenType)
	}

	Set aFromFirstDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthFirstDay(aDateFrom)		//开始日期当月第一天
	Set aToFirstDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthFirstDay(aDateTo)			//结束日期当月第一天	
	If $lf(monthList,aFromFirstDay)<1{
		//按天查询起始月份数据
	 	If aFromFirstDay'=aToFirstDay{
		 	Set aLastDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthLastDay(aDateFrom)	
		}Else{
			Set aLastDay=aDateTo	
		}
	 	Do GetDaysData(aDateFrom,aLastDay,aLocID,aSDID,aHospID,aStatTime,aScreenType) 
	}
 	
	If (aFromFirstDay'=aToFirstDay)&&($lf(monthList,aToFirstDay)<1){
		//按天查询结束月份数据
	 	Do GetDaysData(aToFirstDay,aDateTo,aLocID,aSDID,aHospID,aStatTime,aScreenType)
	}
	 
	Quit $$$OK

GetDaysData(xDateFrom,xDateTo,aLocID,aSDID,aHospID,aStatTime,aScreenType)
	Set xDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDateFrom)
 	Set xDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDateTo)
 	
 	Set NIndex="GetDataByDay"
    Kill ^TMP($zn,$j,NIndex)
    Kill ^TMP($zn,$j,"DischCount")
    Set ^TMP($zn,$j,"DischCount",aHospID)=0
 	Set StatusList=$lb("T","I","O","C","U")		//新增作废状态 add by zqy20220428
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=xDateFrom-1
    For {
    	Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    	Quit:xDate=""
    	Quit:xDate>xDateTo
    	
    	Set xEpisodeID=""
    	For {
    		Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    		Quit:xEpisodeID=""
    		
    		Set AdmInfo=$g(^DHCMA.Util.EPx.EpisodeD(xEpisodeID))
    		Continue:AdmInfo=""
    		Set HospID=""
    		Set AdmDays=$Lg(AdmInfo,32)	//住院天数
    		Set EpisodeID=$Lg(AdmInfo,2)
    		Set AdmLocID=$P(^PAADM($p(EpisodeID,"!!",1)),"^",4)_"!!"_SYSDr
    		Set DischDate=$Lg(AdmInfo,30)
    		Continue:DischDate=""
    		Set MotherDr=$lg(AdmInfo,36)
    		Continue:MotherDr'=""			//过滤婴儿
    		
    		Set objLoc = ##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
    		Continue:'$IsObject(objLoc)
    		Set HospID=$p(objLoc.BTHospID,"!!",1)
    		Continue:HospID=""
    		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=HospID)
    		//Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,"DischCount"))	//出院人数
    		Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
    		Set AdmFees=$p(FeeStr,"^",1)
			Set DrugCost=$p(FeeStr,"^",2)
			Set LabCost=$p(FeeStr,"^",3)
			Set MaterialCost=$p(FeeStr,"^",5)
    		Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)	//是否发生院感
    		
    		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xPathwayID=""
			Set objCPW=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objCPW)
			Continue:'$IsObject(objCPW.CPFormDr)
			Continue:'$IsObject(objCPW.CPFormDr.FormPathDr)
			Set CPWStatus=objCPW.CPStatus
			Continue:$lf(StatusList,CPWStatus)<1
			Set InLocID=objCPW.CPInLocID
			Set PathID=objCPW.CPFormDr.FormPathDr.%Id()
			Set:InLocID="" InLocID=..GetApplyLoc(xPathwayID)	//获取不入径申请的科室
			Continue:InLocID=""
			
			// 按照入径科室统计或者按照出院科室统计 0就是出院科室（就是当前科室）
			Set:aStatTime=1 AdmLocID=InLocID
			Continue:(aStatTime=1 )&&(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))
			Continue:(aStatTime=0 )&&(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))
			//Continue:'$IsObject(objCPW.CPFormDr.FormPathDr.BTEntityDr)	//过滤没有单病种信息
			Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ForCP"))	//应入人数
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ForCPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ForCPWID"))_$lb(xPathwayID)
			
			//除应入人数，其他指标一律只统计进入路径的病例 add by yankai20210514	新增作废 add by zqy20220428
			Continue:((CPWStatus'="I")&&(CPWStatus'="O")&&(CPWStatus'="C")&&(CPWStatus'="U")) 
			Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"InCP"))	//入径人数
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"InCPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"InCPWID"))_$lb(xPathwayID)
			If (IsHAI=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"HAI"))	//发送院感人数
				Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"HAICPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"HAICPWID"))_$lb(xPathwayID)
			}
			//总住院日
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Day")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Day"))+AdmDays
			//总费用
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Fee")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Fee"))+AdmFees
			
			If (CPWStatus="O") {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"OutCP"))	//出径人数
				Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"OutCPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"OutCPWID"))_$lb(xPathwayID)
			}
			If (CPWStatus="C") {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ClsCP"))	//完成人数
				Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ClsCPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ClsCPWID"))_$lb(xPathwayID)
			}
			Set IsVar=0
			Set xVarID=""
			For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xVarID))
				Quit:xVarID=""
				
				Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xVarID)
		 		Continue:'$IsObject(objVar)
			 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
			 	//Set VarTimes = VarTimes+1
			 	Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarTimesCP"))  //变异例次
			 	Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarCPWTimes")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarCPWTimes"))_$lb(xPathwayID)
			 	Set:IsVar=0 IsVar=1
			}
			If (IsVar=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarCP"))	//发生变异人数
				Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarCPWID")=$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"VarCPWID"))_$lb(xPathwayID)
			}
			
			Set IsReAdm=##class(DHCMA.CPW.STAS.CommonSrv).CheckReByAdm(xEpisodeID)	//是否当天再入院
			If (+IsReAdm=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ReAdm"))  //当天再入院人数
			}
			
			Set ret=##class(DHCMA.CPW.STAS.CommonSrv).Check24hOutByAdm(xEpisodeID,xPathwayID)	//是否24小时内退出
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"24Out"))  //24小时内退出人数
			}
			
			Set DaysBeforeOpr=##class(DHCMA.CPW.STAS.CommonSrv).GetDaysBeforeOpr(xEpisodeID)	 //术前住院日
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"DaysBeforeOpr")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"DaysBeforeOpr"))+DaysBeforeOpr
			Set DischCond=##class(DHCMA.CPW.STAS.CommonSrv).GetDischCond(+EpisodeID)	//出院情况
			
			If (DischCond="治愈") {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Healing"))
			} ElseIf (DischCond="好转") {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Better"))
			} ElseIf (DischCond="死亡") {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Dead"))
			}Else{}
			
			Set ret=##class(DHCMA.CPW.STAS.CommonSrv).CheckOprInf(+EpisodeID)	//是否手术感染
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"OprInf"))
			}
			Set ret=##class(DHCMA.CPW.STAS.CommonSrv).CheckReOprPat(+EpisodeID)	//是否非计划重返手术
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ReOper"))
			}
			// 药费
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"DrugCost")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"DrugCost"))+DrugCost
			// 检验费
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"LabCost")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"LabCost"))+LabCost
			// 耗材费
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"MaterialCost")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"MaterialCost"))+MaterialCost
			
			Set ret=##class(DHCMA.CPW.STAS.CommonSrv).CheckPreDrug(+EpisodeID) //是否使用预防性抗菌药物
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"PreDrug"))
			}
			Set ret=##class(DHCMA.CPW.STAS.CommonSrv).Check3Pharmacy(+EpisodeID) // 是否使用三线抗菌药物
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"3Pharmacy"))
			}
			Set AntInfo=##class(DHCMA.CPW.STAS.CommonSrv).GetPatAntInfoById(+EpisodeID) //抗生素信息
			Set IsUsed=$p(AntInfo,"^",1)
			If (+IsUsed=1) {
				Set num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"Pharmacy"))
			}
			
			Set PhcCostDays=##class(DHCMA.CPW.STAS.CommonSrv).GetPhcCostDays(+EpisodeID) //抗生素费用、天数
			Set PhcCost=$p(PhcCostDays,"^",1)
			Set PhcDays=$p(PhcCostDays,"^",2)
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"PhcCost")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"PhcCost"))+PhcCost
			Set ^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"PhcDays")=+$g(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"PhcDays"))+PhcDays
			
			Set NextDays=##class(DHCMA.CPW.STAS.CommonSrv).GetTimesInHospDays(+EpisodeID) //再入院天数
			Set:(NextDays>=0)&&(NextDays<=14) num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ReAdmIn14"))
			Set:(NextDays>=0)&&(NextDays<=31) num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ReAdmIn31"))
			
			Set IsExistCompl=..IsExistCompl(xPathwayID)
			Set:IsExistCompl=1 num=$i(^TMP($zn,$j,NIndex,HospID,AdmLocID,PathID,"ExistCompl"))
		
    	}
    }
    
    Set TypeList=$lb("ForCPWID","InCPWID","OutCPWID","ClsCPWID","VarCPWID","HAICPWID")
	Set xHospID=""
	For	{
		Set xHospID=$o(^TMP($zn,$j,NIndex,xHospID))
		Quit:xHospID=""
		//遍历所有住院科室
		Set xMALocID=""
		For{
 			Set xMALocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID",xMALocID))
 			Quit:xMALocID=""
 			set xLocID=$tr(xMALocID," ","")
 			Continue:(aLocID'="")&&(aLocID'=xLocID)
 			Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
			Continue:(aHospID'="")&&(aHospID'[xHospID)
 			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(xLocID)
 			Continue:'$IsObject(objLoc)
 			Continue:objLoc.BTAdmType'="I"
 			Continue:objLoc.BTType'="E"
 			Set LocDesc=objLoc.BTDesc	//科室名称
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
 			if ($d(^TMP($zn,$j,NIndex,xHospID,xLocID))){
	 			Set DischCount=0
	 			Set IsCount="Y"
	 			Set xPathID=""
				For {
					Set xPathID=$o(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID))
					Quit:xPathID=""
					
					//Continue:xPathID="DischCount"
			    	Set objPath=##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathID)
			    	Continue:'$IsObject(objPath)
					
					Set PathID=xPathID
					Set PathDesc=objPath.BTDesc					//路径名称
					Set PathTypeID=objPath.BTTypeDr.%Id()
					Set PathTypeDesc=objPath.BTTypeDr.BTDesc		//路径类型
					Set SDID="" ,SDDesc=""
					If $IsObject(objPath.BTEntityDr) {
						Set SDID=objPath.BTEntityDr.%Id()
						Set SDDesc=objPath.BTEntityDr.BTDesc	 		//单病种名称
					}
					Continue:(aSDID'="")&&(aSDID'=SDID)
					Set ForCPCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ForCP"))	//应入人数
					Set InCPCount =+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"InCP"))		//入径人数
					Set HasHAICount  =+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"HAI"))		//感染人数
					Set OutCPCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"OutCP"))	//出径人数
					Set ClsCPCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ClsCP"))	//完成人数
					Set VarCPCount=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"VarCP"))	//发生变异人数
					Set InHospDays =+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Day"))		//总住院日
					Set Fees =+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Fee"))		//总费用
					Set VarTimesCount =+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"VarTimesCP"))
					Set ReAdmCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ReAdm"))
					Set OutCP24hCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"24Out"))
					Set OprInHospDays=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"DaysBeforeOpr"))
					Set HealingCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Healing"))
					Set BetterCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Better"))
					Set DeadCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Dead"))
					Set OprInfCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"OprInf"))
					Set ReOperCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ReOper"))
					Set DrugCost=+$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"DrugCost"))
					Set LabCost=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"LabCost"))
					Set MaterialCost=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"MaterialCost"))
					Set PreDrugCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"PreDrug"))
					Set TPharmacyCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"3Pharmacy"))
					Set PharmacyCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"Pharmacy"))
					Set PharmacyDays=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"PhcDays"))
					Set PharmacyCost=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"PhcCost"))
					Set ReAdmIn14Count=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ReAdmIn14"))
					Set ReAdmIn31Count=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ReAdmIn31"))
					Set ComplCount=$g(^TMP($zn,$j,NIndex,xHospID,xLocID,xPathID,"ExistCompl"))	//合并症
					Set ComplCount2=0	//并发症
					
					Set DischCount=+##class(DHCMA.CPW.IO.FromMRData).GetCYRSByLocDate(xDateFrom,xDateTo,xLocID)
					Set DischCount=$Case(IsCount,"Y":+DischCount,:0)
					Set IsCount="N"
					//Set Type ="Day"
					Set:DischCount'=0 ^TMP($zn,$j,"DischCount",aHospID,xLocID)=1
					Set Data=$lb(ind,xLocID,LocDesc,PathTypeID,PathTypeDesc,PathID,PathDesc,SDID,SDDesc,ForCPCount,
								InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,InHospDays,Fees,
								ReAdmCount,OutCP24hCount,OprInHospDays,HealingCount,BetterCount,DeadCount,OprInfCount,
								ReOperCount,DrugCost,LabCost,MaterialCost,PreDrugCount,TPharmacyCount,PharmacyCount,
								PharmacyDays,PharmacyCost,ReAdmIn14Count,ReAdmIn31Count,ComplCount,ComplCount2,DischCount)
		 			Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
		    	}
		    	Set CPWIsDisplayEmptyFlag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsDisplayEmptyFlag",aHospID)
		 		if (CPWIsDisplayEmptyFlag="1"){
		    		//显示符合人数为0的科室病种
		    		Set xPathDr="",xCount="Y"
				 	For {
					 	Set xPathDr = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr))
					 	Quit:xPathDr=""
						
						Continue:($listfind(ListPath,xPathDr)>0)
						Set xID = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr,0))
						
					 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathDr)
						Continue:'$IsObject(obj)
					 	Continue:+obj.BTIsActive'=1  
					 	
					 	Set Desc = obj.BTDesc
					 	Set TypeID="",TypeDesc=""
					 	If $IsObject(obj.BTTypeDr) { 
							Set TypeID  =obj.BTTypeDr.%Id()
					 		Set TypeDesc=obj.BTTypeDr.BTDesc
						}
						Set PathSDID="",PathSDDesc=""
						If $IsObject(obj.BTEntityDr) { 
							Set PathSDID  =obj.BTEntityDr.%Id()
					 		Set PathSDDesc=obj.BTEntityDr.BTDesc
						}
						Set flg=$g(^TMP($zn,$j,"DischCount",aHospID,xLocID))
						Set DischCount=0
						Set:(flg=0)&&(xCount="Y") DischCount=+##class(DHCMA.CPW.IO.FromMRData).GetCYRSByLocDate(xDateFrom,xDateTo,xLocID),xCount="N"
					 	Set Data=$lb(ind,xLocID,LocDesc,TypeID,TypeDesc,xPathDr,Desc,PathSDID,PathSDDesc,
										 0,0,0,0,0,0,0,0,
										 0,0,0,0,0,0,0,
										 0,0,0,0,0,0,0,
										 0,0,0,0,0,0,DischCount
					 				)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
				 	}
		 		}
	 		}elseif (aScreenType="1"){
		 		Set LocDesc=objLoc.BTDesc
				Set:LocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
				Set DischCount=+##class(DHCMA.CPW.IO.FromMRData).GetCYRSByLocDate(xDateFrom,xDateTo,xLocID)
			 	Set Data=$lb(ind,xLocID,LocDesc,"","","","","","",
								 0,0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,
								 0,0,0,0,0,0,DischCount
			 				)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 		
		 	}
		}
	}
    
GetMonthData(xDateFrom,xDateTo,aLocID,aSDID,aHospID,aStatTime,aScreenType)
	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!1"
	Set xDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDateFrom)
 	Set xDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDateTo)
	
	Set NIndex="GetDataByDaynew"
    Kill ^TMP($zn,$j,NIndex)
    Kill ^TMP($zn,$j,"DischMonCount")
	Set ^TMP($zn,$j,"DischMonCount",aHospID)=0
 	Set mDate=xDateFrom-1
 	For {
 		set mDate=$o(^DHCMA.CPW.STA.MonthDischDataI("IdxofMDDate",mDate))
 		Quit:mDate=""
 		Quit:mDate>xDateTo
 		
 		Set mHospID=""
 		For {
	 		set mHospID=$o(^DHCMA.CPW.STA.MonthDischDataI("IdxofMDDate",mDate,mHospID))
 			Quit:mHospID=""
 			set HospIDnew=$tr(mHospID," ","")
 			Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=HospIDnew)
	 		Set mLocID=""
	 		For {
	 			Set mLocID=$o(^DHCMA.CPW.STA.MonthDischDataI("IdxofMDDate",mDate,mHospID,mLocID))
	 			Quit:mLocID=""
	 			set LocIDnew=$tr(mLocID," ","")
	 			Set objMonthDisch="",DischCount=0
	 			Set xMonthDischID= $o(^DHCMA.CPW.STA.MonthDischDataI("IdxofMDDate",mDate,mHospID,mLocID,""),-1)
	 			Set:xMonthDischID'="" objMonthDisch= ##class(DHCMA.CPW.STA.MonthDischData).GetObjById(xMonthDischID)
	 			Set:$IsObject(objMonthDisch) DischCount=objMonthDisch.MDDischCount
	 			
	 			Set ^TMP($zn,$j,NIndex,HospIDnew,LocIDnew,"Inhospnum")=+$g(^TMP($zn,$j,NIndex,HospIDnew,LocIDnew,"Inhospnum"))+DischCount
	 		   
	 		}
 		}
 	}
	Set index=$s(aStatTime="0":"IdxofOutDate",aStatTime="1":"IdxofDate",1:"IdxofDate")
 	Set xDate=xDateFrom-1
 	For {
 		Set xDate=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate))
 		Quit:xDate=""
 		Quit:xDate>xDateTo
 		
 		Set xHospID=""
 		For {
	 		Set xHospID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID))
 			Quit:xHospID=""
 			Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=$p(xHospID,"!!",1))
 			Set ListLocID=""
 			//遍历所有住院科室
 			Set xMALocID=""
 			For{
	 			Set xMALocID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID",xMALocID))
	 			Quit:xMALocID=""
	 			set xLocID=$tr(xMALocID," ","")
	 			Continue:(aLocID'="")&&(aLocID'=xLocID)
	 			Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
 				Continue:(aHospID'="")&&(aHospID'[xHospID)
	 			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(xLocID)
	 			Continue:'$IsObject(objLoc)
	 			Continue:objLoc.BTAdmType'="I"
	 			Continue:objLoc.BTType'="E"
	 			Set IsCount="Y"
	 			Set ListPath=""
	 			if ($d(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID))){
		 			Set xPathID=""
		 			For {
		 				Set xPathID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID,xPathID))
		 				Quit:xPathID=""
		 				Set ListPath=ListPath_$lb(xPathID)
		 				Set xID=""
		 				For {
		 					Set xID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID,xPathID,xID))
		 					Quit:xID=""
		 					
		 					Set objData=##class(DHCMA.CPW.STA.DataResults).GetObjById(xID)
			 				Continue:'$IsObject(objData)
			 				
							Set InLocID=objData.STAInLocID
							Set InLocDesc=objData.STAInLocDesc
							Set OutLocID=objData.STAOutLocID
							Set OutLocDesc=objData.STAOutLocDesc
							Set:aStatTime="0" InLocID=OutLocID
							Set:aStatTime="0" InLocDesc=OutLocDesc
							Set PathTypeID=objData.STAPathTypeID
							Set PathTypeDesc=objData.STAPathTypeDesc
							Set PathID=objData.STAPathID
							Set PathDesc=objData.STAPathDesc
							Set PathSDID=objData.STAPathSDID
							Continue:(aSDID'="")&&(aSDID'=PathSDID)
							Set PathSDDesc=objData.STAPathSDDesc
							Set ForCPCount=+objData.STAForCPCount
							Set InCPCount=+objData.STAInCPCount
							Set OutCPCount=+objData.STAOutCPCount
							Set ClsCPCount=+objData.STAClsCPCount
							Set VarCPCount=+objData.STAVarCPCount
							Set HasHAICount=+objData.STAHAICount
							Set InHospDays=+objData.STAInHospDays
							Set Fees=objData.STAFees
							
							Set ReAdmCount=+objData.STAReAdmCount
							Set OutCP24hCount=+objData.STAOutCP24HCount
							Set OprInHospDays=+objData.STAOprInHospDays
							Set HealingCount=+objData.STAHealingCount
							Set BetterCount=+objData.STABetterCount
							Set DeadCount=+objData.STADeadCount
							Set OprInfCount=+objData.STAOprInfCount
							Set ReOperCount=+objData.STAReOperCount
							Set DrugCost=objData.STADrugCost
							Set LabCost=objData.STALabCost
							Set MaterialCost=objData.STAMaterialCost
							Set PreDrugCount=+objData.STAPreDrugCount
							Set TPharmacyCount=+objData.STA3PharmacyCount
							Set PharmacyCount=+objData.STAPharmacyCount
							Set PharmacyDays=+objData.STAPharmacyDays
							Set PharmacyCost=objData.STAPharmacyCost
							Set ReAdmIn14Count=+objData.STAReAdmIn14Count
							Set ReAdmIn31Count=+objData.STAReAdmIn31Count
							Set ComplCount=+objData.STAComplCount
							Set ComplCount2=+objData.STAComplCount2
							set DischCount=0
							Set:$d(^TMP($zn,$j,NIndex,xHospID,InLocID,"Inhospnum")) DischCount=+$g(^TMP($zn,$j,NIndex,xHospID,InLocID,"Inhospnum"))
							//Set Type ="Month"_$zdt(xDate,3)
							//因为出院人数（STADischCount）是指每个月科室总出院人数，在报表里不能累加，
							//只能计算一次
							if ($g(^TMP($zn,$j,"DischMonCount",aHospID,xLocID))=1){
			 					Set IsCount="N"
			 				}
							Set DischCount=$Case(IsCount,"Y":+DischCount,:0)
							Set:DischCount'=0 ^TMP($zn,$j,"DischMonCount",aHospID,InLocID)=1
							Set Data=$lb(ind,InLocID,InLocDesc,PathTypeID,PathTypeDesc,PathID,PathDesc,PathSDID,PathSDDesc,
										 ForCPCount,InCPCount,OutCPCount,ClsCPCount,VarCPCount,HasHAICount,InHospDays,Fees,
										 ReAdmCount,OutCP24hCount,OprInHospDays,HealingCount,BetterCount,DeadCount,OprInfCount,
										 ReOperCount,DrugCost,LabCost,MaterialCost,PreDrugCount,TPharmacyCount,PharmacyCount,
										 PharmacyDays,PharmacyCost,ReAdmIn14Count,ReAdmIn31Count,ComplCount,ComplCount2,DischCount
										)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
		 				}
		 			}
			 		Set CPWIsDisplayEmptyFlag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsDisplayEmptyFlag",aHospID)
		 			
		 			if (CPWIsDisplayEmptyFlag="1"){
			 			//显示符合人数为0的科室病种
			 			Set xPathDr="",MCount="Y"
					 	For {
						 	Set xPathDr = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr))
						 	Quit:xPathDr=""
							Continue:($listfind(ListPath,xPathDr)>0)
							Set xID = $o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(xLocID,"U"),xPathDr,0))
							
						 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathDr)
							Continue:'$IsObject(obj)
						 	Continue:+obj.BTIsActive'=1  
						 	
						 	Set Desc = obj.BTDesc
						 	Set TypeID="",TypeDesc=""
						 	If $IsObject(obj.BTTypeDr) { 
								Set TypeID  =obj.BTTypeDr.%Id()
						 		Set TypeDesc=obj.BTTypeDr.BTDesc
							}
							Set PathSDID="",PathSDDesc=""
							If $IsObject(obj.BTEntityDr) { 
								Set PathSDID  =obj.BTEntityDr.%Id()
						 		Set PathSDDesc=obj.BTEntityDr.BTDesc
							}
							Set flg=$g(^TMP($zn,$j,"DischMonCount",aHospID,xLocID))
							Set DischCount=0
							Set:(flg=0)&&(MCount="Y") DischCount=+$g(^TMP($zn,$j,NIndex,xHospID,aLocID,"Inhospnum")),MCount="N"
						 	Set LocDesc=objLoc.BTDesc
							Set:LocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
							
						 	Set Data=$lb(ind,xLocID,LocDesc,TypeID,TypeDesc,xPathDr,Desc,PathSDID,PathSDDesc,
											 0,0,0,0,0,0,0,0,
											 0,0,0,0,0,0,0,
											 0,0,0,0,0,0,0,
											 0,0,0,0,0,0,DischCount
						 				)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
					 	}
		 			}
		 			
		 		}elseif (aScreenType="1"){
			 		Set LocDesc=objLoc.BTDesc
					Set:LocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
					Set DischCount=+##class(DHCMA.CPW.IO.FromMRData).GetCYRSByLocDate(xDateFrom,xDateTo,xLocID)
				 	Set Data=$lb(ind,xLocID,LocDesc,"","","","","","",
									 0,0,0,0,0,0,0,0,
									 0,0,0,0,0,0,0,
									 0,0,0,0,0,0,0,
									 0,0,0,0,0,0,DischCount
				 				)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 		
			 	}
	 		}
 		}
 	}
 	Kill ^TMP($zn,$j,NIndex)
}

ClassMethod QryCPWByDateOfNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByDateOfNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByDateOfNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByDateOfNewExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2021-11-11
/// Description:  按天查询明细信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPatOfDayNew","2021-08-01","2021-11-11","F","1","","","2,9,10")
Query QryCPWPatOfDayNew(aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String, aStatTime As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,PathSDID:%String,PathSDDesc:%String,PathID:%String,PathDesc:%String,CPWStatus:%String,InDate:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutUserDesc:%String,OutLocDesc:%String,ClsDate:%String,ClsUser:%String,ClsLocDesc:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,AdmDays:%String,AdmFees:%String,IsHAI:%String,DocName:%String,OutReason:%String,OutTxt:%String,NotReason:%String,NotTxt:%String,DischLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPatOfDayNewExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aStatus As %String, aSDID As %String, aPathID As %String, aLocID As %String, aHospID As %String, aStatTime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aStatus="")||(aHospID="") $$$OK
 	// 获取日期范围内整月数据
	Set monthList = ##class(DHCMA.CPW.STAS.DateUtil).GetIntervalMonthList(aDateFrom,aDateTo)
	If monthList'=""{
		Set xDateFrom = $lg(monthList,1)
		Set xDateTo = $lg(monthList,-1)
		Do GetPatMonthData(xDateFrom,xDateTo,aLocID,aSDID,aHospID,aPathID,aStatus,aStatTime)
	}

	Set aFromFirstDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthFirstDay(aDateFrom)		//开始日期当月第一天
	Set aToFirstDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthFirstDay(aDateTo)			//结束日期当月第一天	
	If $lf(monthList,aFromFirstDay)<1{
		//按天查询起始月份数据
	 	If aFromFirstDay'=aToFirstDay{
		 	Set aLastDay=##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthLastDay(aDateFrom)	
		}Else{
			Set aLastDay=aDateTo	
		}
	 	Do GetPatDaysData(aDateFrom,aLastDay,aLocID,aSDID,aHospID,aPathID,aStatus,aStatTime) 
	}
 	
	If (aFromFirstDay'=aToFirstDay)&&($lf(monthList,aToFirstDay)<1){
		//按天查询结束月份数据
	 	Do GetPatDaysData(aToFirstDay,aDateTo,aLocID,aSDID,aHospID,aPathID,aStatus,aStatTime)
	}
 		 
	Quit $$$OK
 	
GetPatMonthData(aDateFrom,aDateTo,aLocID,aSDID,aHospID,aPathID,aStatus,aStatTime)
	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!1"
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)	
	Set index=$s(aStatTime="0":"IdxofOutDate",aStatTime="1":"IdxofDate",1:"IdxofDate")
 	Set xDate=aDateFrom-1
 	For {
 		Set xDate=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate))
 		Quit:xDate=""
 		Quit:xDate>aDateTo
 		
 		Set xHospID=""
 		For {
	 		Set xHospID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID))
 			Quit:xHospID=""
 			if ((aHospID'="")&&(aHospID[",")){
	 			Set aHospID=$replace(aHospID,"!!1","")
	 			Set xHospID=$p(xHospID,"!!",1)
	 			Continue:(","_aHospID_",")'[(","_xHospID_",")
	 		}else{
		 		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=$p(xHospID,"!!",1))
		 	}

	 		Set xLocID=""
	 		For {
	 			Set xLocID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID))
	 			Quit:xLocID=""
	 			
	 			Continue:(aLocID'="")&&(aLocID'=xLocID)
	 			
	 			Set xPathID=""
	 			For {
	 				Set xPathID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID,xPathID))
	 				Quit:xPathID=""
	 				
	 				Continue:(aPathID'="")&&(aPathID'=xPathID)
	 				
	 				Set xID=""
	 				For {
	 					Set xID=$o(^DHCMA.CPW.STA.DataResultsI(index,xDate,xHospID,xLocID,xPathID,xID))
	 					Quit:xID=""
	 					
	 					Set objData=##class(DHCMA.CPW.STA.DataResults).GetObjById(xID)
		 				Continue:'$IsObject(objData)
		 				
						Set PathSDID=objData.STAPathSDID
						Continue:(aSDID'="")&&(aSDID'=PathSDID)
						
						Set PathSDDesc=objData.STAPathSDDesc
						Set PathID=objData.STAPathID
						Set PathDesc=objData.STAPathDesc
						
						Set ParrefID=xID
						Set xCPWID=""
						For {
							Set xCPWID=$o(^DHCMA.CPW.STA.DataResultsI("Child","IdxofType",ParrefID,aStatus,xCPWID))
							Quit:xCPWID=""
							
							Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
							Continue:'$IsObject(objPathway)
							
							Set EpisodeID=objPathway.CPEpisodeID
							set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
							Continue:'$IsObject(objPat)
							
							Set PatientID=objPat.PAPatientID
							Set PapmiNo=objPat.PAPapmiNo
							Set MrNo=objPat.PAMrNo
							Set PatName=objPat.PAPatName
							Set PatSex=objPat.PASex
							Set PatSex=$Case(PatSex,"M":"男","F":"女",:"")
							Set PatAge=objPat.PAAge
							Set AdmDate=objPat.PAAdmDate
							Set DischDate=objPat.PADischDate
							Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
							Set AdmDays=objPat.PAAdmDays	//住院天数
							Set DocID=objPat.PAAdmDocID
							Set DocName=""
							Set objDoc=##class(DHCMA.Util.EP.CareProv).GetObjByOID(DocID)
							Set:$IsObject(objDoc) DocName=objDoc.BTDesc
							Set DischLocID=objPat.PAAdmLocID
							Set DischLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(DischLocID)
							Set:$IsObject(objLoc) DischLocDesc=objLoc.BTDesc
					
							Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
    						Set AdmFees=$p(FeeStr,"^",1)
    						Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)	//是否发生院感
    						Set IsHAI=$Case(IsHAI,"1":"是",:"否")
							Set CPWStatus=objPathway.CPStatus
							Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","T":"不入径","U":"作废","P":"预约","A":"申请",:"")
							
							Set (OutReason,OutTxt,NotReason,NotTxt)=""
							If (CPWStatus="不入径") {
								Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
								If ($IsObject(objDic)) {
									Set TypeID=objDic.%Id()
									Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
									If (xsubID'="") {
										Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
										If ($IsObject(objApp)) {
											Set NotReason=objApp.CPReasonDr.BTDesc
											Set NotTxt=objApp.CPApplyTxt
										}
									}
								}
							}
							If (CPWStatus="出径") {
								Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","出径原因")
								If ($IsObject(objDic)) {
									Set TypeID=objDic.%Id()
									Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
									If (xsubID'="") {
										Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
										If ($IsObject(objApp)) {
											Set OutReason=objApp.CPReasonDr.BTDesc
											Set OutTxt=objApp.CPApplyTxt
										}
									}
								}
							}
							Set InDate=objPathway.CPInDate
							Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
							Set InUserID=objPathway.CPInUserID
							Set InUserDesc=""
							Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
							Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
							Set InLocID=objPathway.CPInLocID
							Set InLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
							Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
							Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
							
							Set OutDate=objPathway.CPOutDate
							Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
							Set OutUserID=objPathway.CPOutUserID
							Set OutUserDesc=""
							Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
							Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
							Set OutLocID=objPathway.CPOutLocID
							Set OutLocDesc=""
							Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
							Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
							Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
							
							Set (ClsDate,ClsUser,ClsLocDesc)=""
							If (CPWStatus="完成") {
								Set ClsDate=OutDate
								Set ClsUser=OutUserDesc
								Set ClsLocDesc=OutLocDesc
								Set OutDate=""
								Set OutUserDesc=""
								Set OutLocDesc=""
							}
						
							Set Data=$lb(ind,xCPWID,PathSDID,PathSDDesc,PathID,PathDesc,CPWStatus,InDate,InUserDesc,InLocDesc,OutDate,OutUserDesc,OutLocDesc,ClsDate,ClsUser,ClsLocDesc,
										EpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,AdmDays,AdmFees,IsHAI,DocName,OutReason,OutTxt,NotReason,NotTxt,DischLocDesc)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
	 				}
	 			}
	 		}
 		}
 	}
 	
GetPatDaysData(aDateFrom,aDateTo,aLocID,aSDID,aHospID,aPathID,aStatus,aStatTime)
	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!1"
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)	
		
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//Continue:(aLocID'="")&&(aLocID'=$p(AdmLocID,"!!",1))
    		//Set Status = objEpisode.PAVisitStatus
    		//Continue:Status'="D"
    		Set DischDate=objEpisode.PADischDate
    		Continue:DischDate=""
    		Continue:objEpisode.PAMotherDr'=""
    		
    		Set EpisodeID=objEpisode.OID
		 	
			Set ForCPCount=0
			Set InCPCount=0
			Set OutCPCount=0
			Set ClsCPCount=0
			Set VarCPCount=0
			Set HasHAICount=0
			Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xCPWID=""
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			Continue:'$IsObject(objPathway)
			Continue:(objPathway.CPStatus'="T")&&(objPathway.CPStatus'="I")&&(objPathway.CPStatus'="O")&&(objPathway.CPStatus'="C")
			
		    if (aStatTime=0){
	    		// 按照入径科室统计或者按照出院科室统计 0就是出院科室（就是当前科室）
	    		Set AdmLocID=$P(^PAADM($p(objEpisode.OID,"!!",1)),"^",4)_"!!1"		//出院科室
	    		Set objAdmLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
	    		Set:$IsObject(objAdmLoc) AdmLocDesc=objAdmLoc.BTDesc
	    	}else{
		    	Set AdmLocID=objPathway.CPInLocID
		    	Set objInAdmLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
	    		Set:$IsObject(objInAdmLoc) AdmLocDesc=objInAdmLoc.BTDesc
		    }
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			//根据就诊科室获取院区过滤
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		//Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		
    		if ((aHospID'="")&&(aHospID[",")){
	 			Set aHospID=$replace(aHospID,"!!1","")
	 			Set AdmHospID=$p(AdmHospID,"!!",1)
	 			Continue:(","_aHospID_",")'[(","_AdmHospID_",")
	 		}else{
		 		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=$p(AdmHospID,"!!",1))
		 	}
    		
			
			Set (SDID,SDDesc)=""
			Set objBTQC = objPathway.CPFormDr.FormPathDr.BTEntityDr
			Set:$IsObject(objBTQC) SDID = objBTQC.%Id()
			Set:$IsObject(objBTQC) SDDesc = objBTQC.BTDesc
			Continue:(aSDID'="")&&(aSDID'=SDID)
			Set PathID = objPathway.CPFormDr.FormPathDr.%Id()
			Continue:(aPathID'="")&&(aPathID'=PathID)
			Set PathDesc = objPathway.CPFormDr.FormPathDr.BTDesc
						
					
			Set EpisodeID=objPathway.CPEpisodeID
			set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
			Continue:'$IsObject(objPat)
								
			Set PatientID=objPat.PAPatientID
			Set PapmiNo=objPat.PAPapmiNo
			Set MrNo=objPat.PAMrNo
			Set PatName=objPat.PAPatName
			Set PatSex=objPat.PASex
			Set PatSex=$Case(PatSex,"M":"男","F":"女",:"")
			Set PatAge=objPat.PAAge
			Set AdmDate=objPat.PAAdmDate
			Set DischDate=objPat.PADischDate
			Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Continue:DischDate=""
			Set AdmDays=objPat.PAAdmDays 	//住院天数
			Set DocID=objPat.PAAdmDocID
			Set DocName=""
			Set objDoc=##class(DHCMA.Util.EP.CareProv).GetObjByOID(DocID)
			Set:$IsObject(objDoc) DocName=objDoc.BTDesc
			Set DischLocID=objPat.PAAdmLocID
			Set DischLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(DischLocID)
			Set:$IsObject(objLoc) DischLocDesc=objLoc.BTDesc
			
			Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
			Set AdmFees=$p(FeeStr,"^",1)
			Set IsHAI=##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm(EpisodeID)	//是否发生院感
			Set IsHAI=$Case(IsHAI,"1":"是",:"否")
			Set CPWStatus=objPathway.CPStatus
			Continue:(aStatus="I")&&(CPWStatus="T")
			Continue:(aStatus="O")&&(CPWStatus'="O")
			Continue:(aStatus="C")&&(CPWStatus'="C")
			Set PathwayVarflg=0
			Set xPathwayVarId=""
			For{
				Set xPathwayVarId = $O(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xPathwayVarId))
				Quit:xPathwayVarId=""
				Quit:PathwayVarflg=1
				Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xPathwayVarId)
				Continue:'$IsObject(objVar)
				Set:objVar.CPIsActive=1 PathwayVarflg=1
			}
			Continue:(aStatus="V")&&(PathwayVarflg'=1)
			Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","T":"不入径","U":"作废","P":"预约","A":"申请",:"")
								
			Set (OutReason,OutTxt,NotReason,NotTxt)=""
			If (CPWStatus="不入径") {
				Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
				If ($IsObject(objDic)) {
					Set TypeID=objDic.%Id()
					Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
					If (xsubID'="") {
						Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
						If ($IsObject(objApp)) {
							Set NotReason=objApp.CPReasonDr.BTDesc
							Set NotTxt=objApp.CPApplyTxt
						}
					}
				}
			}
			If (CPWStatus="出径") {
				Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","出径原因")
				If ($IsObject(objDic)) {
					Set TypeID=objDic.%Id()
					Set xsubID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",xCPWID,TypeID,""))
					If (xsubID'="") {
						Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xCPWID_"||"_xsubID)
						If ($IsObject(objApp)) {
							Set OutReason=objApp.CPReasonDr.BTDesc
							Set OutTxt=objApp.CPApplyTxt
						}
					}
				}
			}
			Set InDate=objPathway.CPInDate
			Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
			Set InUserID=objPathway.CPInUserID
			Set InUserDesc=""
			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
			Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
			Set InLocID=objPathway.CPInLocID
			//Continue:(aLocID'="")&&(aLocID'=InLocID)
			//Continue:(aLocID'="")&&(aLocID'=$p(InLocID,"!!",1))
			Set:InLocID="" InLocID=..GetApplyLoc(xCPWID)
			
			
			Set InLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
			Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
			Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
			
							
			Set OutDate=objPathway.CPOutDate
			Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
			Set OutUserID=objPathway.CPOutUserID
			Set OutUserDesc=""
			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
			Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
			Set OutLocID=objPathway.CPOutLocID
			Set OutLocDesc=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
			Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
			Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
							
			Set (ClsDate,ClsUser,ClsLocDesc)=""
			If (CPWStatus="完成") {
				Set ClsDate=OutDate
				Set ClsUser=OutUserDesc
				Set ClsLocDesc=OutLocDesc
				Set OutDate=""
				Set OutUserDesc=""
				Set OutLocDesc=""
			}	
				
			Set Data=$lb(ind,xCPWID,PathSDID,PathSDDesc,PathID,PathDesc,CPWStatus,InDate,InUserDesc,InLocDesc,OutDate,OutUserDesc,OutLocDesc,ClsDate,ClsUser,ClsLocDesc,
						EpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,AdmDays,AdmFees,IsHAI,DocName,OutReason,OutTxt,NotReason,NotTxt,DischLocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
		}
	}
}

ClassMethod QryCPWPatOfDayNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPatOfDayNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPatOfDayNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPatOfDayNewExecute ]
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

/// Creator：    zhangqiyang
/// CreatDate：   2022-6-21
/// Description:  按出院日期统计临床路径项目执行情况
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPerform","2019-01-01","2020-03-01","","2","")
Query QryCPWPerform(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aMastID As %String) As %Query(ROWSPEC = "ind:%Integer,PathwayID:%String,PathMastID:%String,PathDesc:%String,AdmLocID:%String,AdmLocDesc:%String,CountPeo:%Integer,ReCount:%Integer,UnCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWPerformExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aMastID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=aDateFrom-1
    For {
    	Set xDate=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","C",xDate))
    	Quit:xDate=""
    	Quit:xDate>aDateTo
    	
 		Set xPathwayID=""
    	For {
    		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","C",xDate,xPathwayID))
    		Quit:xPathwayID=""
    		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objPathway)
    		//Set EpisodeID=objPathway.CPEpisodeID
    		//Set objEpisode=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
    		//Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objPathway.CPInLocID			//入经科室ID
    		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
    		Set AdmLocDesc=""
			Set:$IsObject(objLoc) AdmLocDesc=objLoc.BTDesc  //科室Desc
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		Continue:'$IsObject(objPathway.CPFormDr.FormPathDr)
			Set PathMastID=objPathway.CPFormDr.FormPathDr.%Id()		//路径ID
			Continue:(aMastID'="")&&(aMastID'=PathMastID)
			Set PathDesc=objPathway.CPFormDr.FormPathDr.BTDesc	//路径名称
	 		Set PathFromID=objPathway.CPFormDr.%Id()	//28
	 		//表单总项目
	 		Set xFormEPID="",Count=0
	 		For{
		 		Set xFormEPID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathFromID,xFormEPID))
		 		Quit:xFormEPID=""
		 		Set xItemCat=""
		 		For{
			 		Set xItemCat=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathFromID,xFormEPID,xItemCat))
			 		Quit:xItemCat=""
			 		Set xItemIndNo=""
			 		For{
				 		Set xItemIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathFromID,xFormEPID,xItemCat,xItemIndNo))
				 		Quit:xItemIndNo=""
				 		Set xFormItemID=""
				 		For{
					 		Set xFormItemID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathFromID,xFormEPID,xItemCat,xItemIndNo,xFormItemID))
					 		Quit:xFormItemID=""
					 		Set objFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(PathFromID_"||"_xFormEPID_"||"_xFormItemID)
					 		Continue:'$IsObject(objFormItem)
					 		Continue:objFormItem.ItemIsActive'=1
					 		Set Count=Count+1
					 	}
				 	}
			 	}
		 	}
		 	//执行项目
		 	Set xCPFormItem="",ReCount=0,UnCount=0
		 	For{
				Set xCPFormItem=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",xPathwayID,xCPFormItem))
			 	Quit:xCPFormItem=""	
			 	Set xPathwayImpl=""
			 	For{
				 	Set xPathwayImpl=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",xPathwayID,xCPFormItem,xPathwayImpl))
			 		Quit:xPathwayImpl=""
			 		Set objPathwayImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(xPathwayID_"||"_xPathwayImpl)
			 		Continue:'$IsObject(objPathwayImpl)
			 		Continue:objPathwayImpl.CPIsActive'=1
			 		Set objCPFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(objPathwayImpl.CPFormItemDr.%Id())
			 		Continue:'$IsObject(objCPFormItem)
			 		if (objPathwayImpl.CPIsImp=1){
				 		Set:objCPFormItem.ItemIsOption=1 UnCount=UnCount+1	//可选执行项目
						Set:objCPFormItem.ItemIsOption=0 ReCount=ReCount+1	//必选执行项目
				 	}
				}
			}
		 	Set Data=$lb(ind,xPathwayID,PathMastID,PathDesc,AdmLocID,AdmLocDesc,Count,ReCount,UnCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	}
    }	
 	Quit $$$OK
}

ClassMethod QryCPWPerformClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPerformExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPerformFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPerformExecute ]
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

/// Creator：    zhangqiyang
/// CreatDate：   2022-6-21
/// Description:  单项目按出院日期统计临床路径项目执行情况
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPerformDetails","2021-01-01","2022-07-01","","2","7")
Query QryCPWPerformDetails(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aMastID As %String, aLocDesc As %String) As %Query(ROWSPEC = "ind:%Integer,PathwayID:%String,PathMastID:%String,PathDesc:%String,AdmLocID:%String,AdmLocDesc:%String,EpDesc:%String,ItemDesc:%String,ReCount:%Integer,BTflag:%String") [ SqlProc ]
{
}

ClassMethod QryCPWPerformDetailsExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aMastID As %String, aLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=aDateFrom-1
    For {
    	Set xDate=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","C",xDate))
    	Quit:xDate=""
    	Quit:xDate>aDateTo
    	Set xPathwayID=""
    	For {
    		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofActDateStatus","C",xDate,xPathwayID))
    		Quit:xPathwayID=""
    		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objPathway)
    		//Set EpisodeID=objPathway.CPEpisodeID
    		//Set objEpisode=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
    		//Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objPathway.CPInLocID			//入经科室ID
    		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
    		Set AdmLocDesc=""
			Set:$IsObject(objLoc) AdmLocDesc=objLoc.BTDesc  //科室Desc
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aHospID'="")&&(aHospID'[AdmHospID)
    		Continue:'$IsObject(objPathway.CPFormDr.FormPathDr)
			Set PathMastID=objPathway.CPFormDr.FormPathDr.%Id()		//路径ID
			Continue:(aMastID'="")&&(aMastID'=PathMastID)
			Set PathDesc=objPathway.CPFormDr.FormPathDr.BTDesc	//路径名称
	 		Set PathFromID=objPathway.CPFormDr.%Id()	//28
		 	//执行项目
		 	Set xCPFormItem=""
		 	For{
				Set xCPFormItem=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",xPathwayID,xCPFormItem))
			 	Quit:xCPFormItem=""	
			 	Set xPathwayImpl="",ReCount=0
			 	For{
				 	Set xPathwayImpl=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",xPathwayID,xCPFormItem,xPathwayImpl))
			 		Quit:xPathwayImpl=""
			 		Set objPathwayImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(xPathwayID_"||"_xPathwayImpl)
			 		Continue:'$IsObject(objPathwayImpl)
			 		Continue:objPathwayImpl.CPIsActive'=1
			 		Continue:'$IsObject(objPathwayImpl.CPEpisDr.CPFormEpDr)
			 		Continue:'$IsObject(objPathwayImpl.CPFormItemDr)
			 		Set EpDesc=objPathwayImpl.CPEpisDr.CPFormEpDr.EpDesc		//阶段
			 		Set:EpDesc="" EpDesc=objPathwayImpl.CPEpisDr.CPFormEpDr.EpDesc2
			 		Set ItemDesc=objPathwayImpl.CPFormItemDr.ItemDesc		//项目名称
			 		Set:objPathwayImpl.CPIsImp=1 ReCount=1					//是否执行
			 		Set objCPFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(objPathwayImpl.CPFormItemDr.%Id())
			 		Continue:'$IsObject(objCPFormItem)
			 		Set flag=0		//可选
					Set:objCPFormItem.ItemIsOption=0 flag=1	//必选
					Set flag=$s(flag="0":"可选",flag="1":"必选",1:"")
					Set Data=$lb(ind,xPathwayID,PathMastID,PathDesc,AdmLocID,AdmLocDesc,EpDesc,ItemDesc,ReCount,flag)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		 	
    	}
    }	
 	Quit $$$OK
}

ClassMethod QryCPWPerformDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPerformDetailsExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPerformDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPerformDetailsExecute ]
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
/// CreatDate：   2019-03-21
/// Description:  2019年3月之前的程序，做不入径申请时，出入径记录里没有保存科室，
/// 				  所以这里取申请科室
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CreateData).GetApplyLoc("8")
ClassMethod GetApplyLoc(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=""
	Quit:aPathwayID="" return
	
	Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
	Quit:'$IsObject(objDic) return
	
	Set TypeID=objDic.%Id()
	Set xID=""
	Set xID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",aPathwayID,TypeID,""))
	Quit:xID="" return
	
	Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(aPathwayID_"||"_xID)
	Quit:'$IsObject(objApp) return
	
	Set LocID=objApp.CPLocID
	
	Set return=LocID
	Quit return
}

/// Creator:	yankai
/// CreatDate:	2021-06-24
/// Desc:		取入径患者是否有合并症
/// w ##class(DHCMA.CPW.STAS.CreateData).IsExistCompl()
ClassMethod IsExistCompl(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=0
	Quit:aPathwayID="" return
	
	Set xComplEtyID=""
	For {
		Set xComplEtyID=$o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofCompl",xComplEtyID))
		Quit:xComplEtyID=""
		Quit:return=1
		
		Set xSubPwComplID=""
		For {
			Set xSubPwComplID=$o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofCompl",xComplEtyID,aPathwayID,xSubPwComplID))
			Quit:xSubPwComplID=""
			Quit:return=1
			
			Set xPwComplID=aPathwayID_"||"_xSubPwComplID
			Set objPwCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(xPwComplID)
			Continue:'$IsObject(objPwCompl)
			Continue:'objPwCompl.CPIsActive
			Set return=1
		}
	}
	
	Quit return
}

/// Creator:	zqy
/// CreatDate:	2022-10-20
/// Desc:		根据科室取一段时间出院人数
/// w ##class(DHCMA.CPW.STAS.OutPutData).GetDischCount("124!!1","64680","64707")
ClassMethod GetDischCount(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aLocID,aDateFrom,aDateTo)
	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="") 0
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set return=0
	For xDate=aDateFrom:1:aDateTo {
		Quit:xDate>aDateTo
		Set xPaadm=""
		//查找合适的患者
		For {
			//这个是参考综合查询里科室出入转报表统计的出院患者
			Set xPaadm=$o(^PAADMi("EstDischExt",xDate,xPaadm))
			Quit:xPaadm=""
			Set xLoc=$P(^PAADM(xPaadm),"^",4)
			Continue:+aLocID'=xLoc
			
			//这个是参考paadm自带的索引进行查找
			//Set xPaadm=$o(^PAADMi("DisDateDep",+aLocID,xDate,xPaadm))
			//Quit:xPaadm=""
			//Continue:'$d(^DHCMA.Util.EPx.EpisodeI("IdxOfOID"," "_xPaadm_"!!"_SYSDr))
			Set objLoc = ##class(DHCMA.Util.EP.Location).GetObjByOID(aLocID)
    		Continue:'$IsObject(objLoc)
    		Set LocDesc=objLoc.BTDesc	//科室名称
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set MatherFlag=$p($g(^PAADM(xPaadm)),"^",75)
			Continue:(MatherFlag'="")&&(LocDesc["产科医疗单元")
			Set return=return+1
		}
	}
	Quit return
}

/// Description:  查询病人变异情况
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPutData","QryCPWPathVar","2019-01-01","2020-06-01","","")
Query QryCPWPathVar(aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aPathID As %String, aType As %String = "1") As %Query(ROWSPEC = "ind:%String,Desc:%String,DesCount:%Float,Total:%Float") [ SqlProc ]
{
}

ClassMethod QryCPWPathVarExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String, aPathID As %String, aType As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set NIndex="QryCPWPathVar"
    Kill ^TMP($zn,$j,NIndex)
	
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
    		
    		Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(xEpisodeID)
    		Continue:'$IsObject(objEpisode)
    		//根据就诊科室获取院区过滤
    		Set AdmLocID=objEpisode.PAAdmLocID
    		Set AdmHospID=$p($g(^CTLOC($p(AdmLocID,"!!",1))),"^",22)
    		Continue:(aLocID'="")&&($p(aLocID,"!!",1)'=$p(AdmLocID,"!!",1))
    		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'[$p(AdmHospID,"!!",1))
    		
    		Set EpisodeID=objEpisode.OID
	 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
	 		Continue:xCPWID=""
			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			Continue:'$IsObject(objPathway)
			
			Set EpisodeID = objPathway.CPEpisodeID    
			Set CPStatus = objPathway.CPStatus 	     //路径状态
			Continue:CPStatus="O"
			Set PathID = objPathway.CPFormDr.FormPathDr.%Id()
			Continue:(aPathID'="")&&(aPathID'=PathID)
			
			Set xPathWayVarId=""
			for {
				Set xPathWayVarId=$o(^DHCMA.CPW.CP.PathwayD(xCPWID,"VAR",xPathWayVarId))
				Quit:xPathWayVarId=""
				Set objPathWayVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xCPWID_"||"_xPathWayVarId)
				Continue:'$IsObject(objPathWayVar)
				Set CPVarID = objPathWayVar.%Id()
				Set CPVariatDesc=objPathWayVar.CPVariatDr.BTDesc          //变异原因
				Set CPVarTypeDesc = objPathWayVar.CPVariatDr.BTTypeDr.BTDesc    //变异原因类型
				Continue:CPVarTypeDesc'["变异"
				Continue:objPathWayVar.CPIsActive'=1
				//Set CPVarPathEpsiDesc = objPathWayVar.CPEpisDr.CPFormEpDr.EpDesc  //变异阶段
				if ($d(^TMP($zn,$j,NIndex,CPVariatDesc))){
					if (aType=1){
						Set ^TMP($zn,$j,NIndex,CPVariatDesc)=$g(^TMP($zn,$j,NIndex,CPVariatDesc))+1
						Set ^TMP($zn,$j,NIndex,"Count")=$g(^TMP($zn,$j,NIndex,"Count"))+1
					}
				}else{
					Set ^TMP($zn,$j,NIndex,CPVariatDesc)=1
					Set ^TMP($zn,$j,NIndex,"Count")=$g(^TMP($zn,$j,NIndex,"Count"))+1
				}
			}	
		}
	}
	Set Total=$g(^TMP($zn,$j,NIndex,"Count"))

	Set Desc=""
	For{
		Set Desc=$o(^TMP($zn,$j,NIndex,Desc))
		Continue:Desc="Count"
		Quit:Desc=""
		Set DescCount=$g(^TMP($zn,$j,NIndex,Desc))
		Set Data=$lb(ind,Desc,DescCount,Total)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
 	Quit $$$OK
}

ClassMethod QryCPWPathVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWPathVarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWPathVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWPathVarExecute ]
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
