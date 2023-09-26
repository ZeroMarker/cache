/// 名称: DHCHAI.IRS.OutLabReportSrv
/// 描述: 外部检验结果录入服务类
/// 编写者: zhoubo
/// 编写日期: 2022-08-12
Class DHCHAI.IRS.OutLabReportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-08-15
/// Description:  作废检验报告对应的相关信息
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       
/// Return：      返回String
/// w ##class(DHCHAI.IRS.OutLabReportSrv).CancelOutLabRep(300)
ClassMethod CancelOutLabRep(aLabReportDr) As %String
{
	New (aLabReportDr)
	Set return = ""
	Quit:(aLabReportDr="") return
	Set ObjRep = ##class(DHCHAI.DP.LabVisitReport).GetObjById(aLabReportDr)
	Quit:'$Isobject(ObjRep) return
	Quit:'$Isobject(ObjRep.LabVisitNumberDr) return
	Set LabVisitNumberDr = ObjRep.LabVisitNumberDr.%Id()
	Quit:'$Isobject(ObjRep.LabVisitNumberDr.LabEpisodeDr) return
	Set LabEpisodeDr = ObjRep.LabVisitNumberDr.LabEpisodeDr.%Id()
	Set LabReportID  = ObjRep.LabReportID
	Set LabSCode     = ObjRep.LabSCode
	
	Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
	//作废监控结果表多耐信息
	Quit:(LabReportID="") return
	Set xRstID = 0
	For {
		Set xRstID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",aLabReportDr,xRstID))
		Quit:xRstID=""
		Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
		Continue:('$IsObject(objRst))
		Set LabTestCode=objRst.LabTestCode
		Continue:LabTestCode=""
		Set ObjectID = LabReportID_"&"_LabTestCode
		Set ID=$o(^DHCHAI.IR.CCResultI("IndexObjectID",LabEpisodeDr,ItmMastID,LabSCode,ObjectID,0))
		Set return = ##class(DHCHAI.IR.CCResult).CancelById(ID)
	}
	//删除报告对应的结果信息
	Set Flag = ##class(DHCHAI.DP.LabVisitRepResult).CancelResult(aLabReportDr)
	//删除检验报告
	Set return = ##class(DHCHAI.DP.LabVisitReport).DeleteById(aLabReportDr)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-08-12
/// Description:  查询外部检验送检信息
/// Table：       DHCHAI.IR.OutLabReport
/// Input:        aEpisodeID : 就诊ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.OutLabReportSrv","QryOutLabRep","1")
Query QryOutLabRep(aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,ID:%String,LocID:%String,LocDesc:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,DischDate:%String,BTTestSet:%String,Specimen:%String,Bacteria:%String,RuleMRB:%String,Bacteria2:%String,RuleMRB2:%String,SubmissLoc:%String,SubmissDate:%String,LabAuthDate:%String,MRBOutLabType:%String,MRBOutLabTypeID:%String,BTTestSetID:%String,SpecimenID:%String,BacteriaID:%String,RuleMRBID:%String,BacteriaID2:%String,RuleMRBID2:%String,VisitNumberDr:%String") [ SqlProc ]
{
}

ClassMethod QryOutLabRepExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
 	Quit:(aEpisodeID="") $$$OK
    
    Set NIndex="QryOutLabRep"
	Kill ^TMP($zn,$j,NIndex)
	
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" $$$OK
	Set LocID=$li(PAAdmData,23)
	Quit:LocID="" $$$OK
	Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
	Quit:(AdmLocData="") $$$OK
	Set LocDesc=$li(AdmLocData,3)
	Set LocDesc2=$li(AdmLocData,4)
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set PapmiNo=$li(PAAdmData,4)     //登记号
	Set MrNo=$li(PAAdmData,5)        //病案号
	Set PatName=$li(PAAdmData,6)     //姓名
	Set Sex=$li(PAAdmData,7)             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=$li(PAAdmData,9)   //出生日期
	Set Age=$li(PAAdmData,37)             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=$li(PAAdmData,20)     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=$li(PAAdmData,21)     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=$li(PAAdmData,26) //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=$li(PAAdmData,27) //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
		
	//外院携带多耐信息
	Set xID=""
   	For {
	   	Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexEpisodeDr",aEpisodeID,xID))
	   	Quit:xID=""
	   	Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
		Continue:'$IsObject(objOut)
		Set LabIsActive = +objOut.LabIsActive
		Continue:(LabIsActive'=1)
		
		Set BTTestSet="",BTTestSetID=""
		Set ObjTestSet = objOut.TestSetDr
		If ($IsObject(ObjTestSet)){
			Set BTTestSetID = ObjTestSet.%Id()
			Set BTTestSet   = ObjTestSet.BTTestSet
		}
		Set Specimen="",SpecimenID=""
		Set ObjSpec = objOut.SpecimenDr
		If ($IsObject(ObjSpec)){
			Set SpecimenID = ObjSpec.%Id()
			Set Specimen   = ObjSpec.BTSpecDesc
		}
		Set Bacteria="",BacteriaID=""
		Set ObjBacteria = objOut.BacteriaDr
		If ($IsObject(ObjBacteria)){
			Set BacteriaID = ObjBacteria.%Id()
			Set Bacteria   = ObjBacteria.BTBacDesc
		}
		Set RuleMRB="",RuleMRBID=""
		Set ObjRuleMRB = objOut.RuleMRBDr
		If ($IsObject(ObjRuleMRB)){
			Set RuleMRBID = ObjRuleMRB.%Id()
			Set RuleMRB   = ObjRuleMRB.BTDesc
		}
		Set Bacteria2="",BacteriaID2=""
		Set ObjBacteria = objOut.BacteriaDr2
		If ($IsObject(ObjBacteria)){
			Set BacteriaID2 = ObjBacteria.%Id()
			Set Bacteria2   = ObjBacteria.BTBacDesc
		}
		Set RuleMRB2="",RuleMRBID2=""
		Set ObjRuleMRB = objOut.RuleMRBDr2
		If ($IsObject(ObjRuleMRB)){
			Set RuleMRBID2 = ObjRuleMRB.%Id()
			Set RuleMRB2   = ObjRuleMRB.BTDesc
		}
		Set SubmissLoc=""
		Set ObjLoc = objOut.LabLocDr
		If ($IsObject(ObjLoc)){
			Set SubmissLoc = ObjLoc.BTDesc
		}
		
		Set SubmissDate= objOut.SubmissDate
		Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate)
		Set LabAuthDate= objOut.LabAuthDate
		Set:LabAuthDate'="" LabAuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabAuthDate)
		Set MRBOutLabType="外院携带"
		Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
		Set VisitNumberDr=""
		Set Data=$lb(aEpisodeID,xID,LocID,LocDesc,PapmiNo,PatName,Sex,Age,AdmDate,DischDate,BTTestSet,Specimen,Bacteria,RuleMRB,Bacteria2,RuleMRB2,SubmissLoc,SubmissDate,LabAuthDate,MRBOutLabType,MRBOutLabTypeID,BTTestSetID,SpecimenID,BacteriaID,RuleMRBID,BacteriaID2,RuleMRBID2,VisitNumberDr)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
   	}
   	
   	Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
	//本院外送多耐信息
	Set xVisitNumberDr = ""
	For {
		Set xVisitNumberDr = $o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		Set VisitNumberDr = xVisitNumberDr
		Set objVisitNumber = ##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$IsObject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		Set VisitNumberDr=xVisitNumberDr
		Set LabEpisodeNo = objVisitNumber.LabEpisodeNo
		Set SCode        = objVisitNumber.LabSCode
		Set Specimen     = objVisitNumber.LabSpecimen
		Set CollDate     = objVisitNumber.LabCollDate
		Set CollTime     = objVisitNumber.LabCollTime
		if CollDate=""{		// 采集日期为空采用接收日期
			Set CollDate=objVisitNumber.LabRecDate
			Set:CollTime'="" CollTime=$zt(CollTime)
		}
		Set objSpecMap = ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
		Set SpecimenID=""
		If $IsObject(objSpecMap.BTMapItemDr)&&(objSpecMap.BTIsActive=1){
			if objSpecMap.BTMapItemDr.BTIsActive=1{
				Set SpecimenID = objSpecMap.BTMapItemDr.%Id()
				Set Specimen = objSpecMap.BTMapItemDr.BTSpecDesc
			}
		}
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime)
		Set SubmissDate = CollDate
		Set objLabLoc=objVisitNumber.LabLocDr
		Set (LabLocID,LabLoc)=""
		If $IsObject(objLabLoc){
			Set LabLocID = objLabLoc.%Id()
			Set LocDesc2 = objLabLoc.BTDesc2
			Set LocDesc  = objLabLoc.BTDesc
			Set LabLoc   = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		}
		// 检验报告规则:就诊号+标本号
		Set LabReportID=aEpisodeID_"||"_LabEpisodeNo
		Set LabReportDr = $o(^DHCHAI.DP.LabVisitReportI("IndexLabReportID",LabReportID,0))
		Set objLabReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(LabReportDr)
		Continue:'$IsObject(objLabReport)
		
		Set Status = objLabReport.LabStatus
		//Continue:Status=6	//作废
		Set IsActive = objLabReport.LabIsActive
		Continue:IsActive=0
		Set objTestSet=objLabReport.LabTestSetDr
		Continue:'$IsObject(objTestSet)
		Set LabAuthDate = objLabReport.LabAuthDate
		Set:LabAuthDate'="" LabAuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabAuthDate)
		Set TestSetDesc=objTestSet.LabTestSetDesc
		Continue:TestSetDesc=""
		Set objTestSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
		Continue:'$IsObject(objTestSetMap)
		Continue:objTestSetMap.BTIsActive=0 
		
		Set BTTestSetID = objTestSetMap.%Id()
		Set TestSetID=objTestSetMap.%Id()
		Set PathogenTestID = "",PathogenTest = ""
		Set (xResutlID,BacteriaID,Bacteria,RuleMRB,RuleMRBID,BacteriaID2,Bacteria2,RuleMRBID2,RuleMRB2,SumFlag)=""
		For {
			Set xResutlID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",LabReportDr,xResutlID))
			Quit:xResutlID=""
			Set ResutlID = xResutlID
			Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResutlID)
			Continue:'$IsObject(objResult)
			
			Set Result = objResult.LabResult
			Continue:Result=""
			Set tBacteria   = Result
			Set tBacteriaID = ""
			Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjByCodeDesc("",tBacteria)
			Set:$IsObject(objBacteria) tBacteriaID=objBacteria.%Id()
			Set tRuleMRB  ="",tRuleMRBID=""
			Set xCCRstID=""
			For {
				Set xCCRstID = $o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,ItmMastID," "_tBacteria,xCCRstID))
				Quit:xCCRstID=""
				Set CCRstID = xCCRstID
				Set objRst=##class(DHCHAI.IR.CCResult).GetObjById(CCRstID)
				Continue:'$IsObject(objRst)
				If $IsObject(objRst.CCMRBTpDr){
					Set tRuleMRBID = objRst.CCMRBTpDr.%Id()
					Set tRuleMRB   = objRst.CCMRBTpDr.BTDesc
					Quit
				}
			}
			If (SumFlag=1) {
				Set Bacteria2   = tBacteria
				Set RuleMRB2    = tRuleMRB
				Set RuleMRBID2  = tRuleMRBID
				Set BacteriaID2 = tBacteriaID
			}
			If (SumFlag=""){
				Set Bacteria    = tBacteria
				Set RuleMRB     = tRuleMRB
				Set RuleMRBID   = tRuleMRBID
				Set BacteriaID  = tBacteriaID
			}
			Set SumFlag=1
		}
		Continue:((Bacteria="")&&(Bacteria2=""))
		Set MRBOutLabType="本院外送"
		Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
        
		Set Data=$lb(aEpisodeID,LabReportDr,LabLocID,LabLoc,PapmiNo,PatName,Sex,Age,AdmDate,DischDate,TestSetDesc,Specimen,Bacteria,RuleMRB,Bacteria2,RuleMRB2,LabLoc,SubmissDate,LabAuthDate,MRBOutLabType,MRBOutLabTypeID,BTTestSetID,SpecimenID,BacteriaID,RuleMRBID,BacteriaID2,RuleMRBID2,VisitNumberDr)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
   	Quit $$$OK
}

ClassMethod QryOutLabRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutLabRepExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOutLabRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutLabRepExecute ]
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
