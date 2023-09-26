/// 名称: DHCHAI.IRS.INFHDMSrv
/// 描述: 横断面调查统计相关服务
/// 编写者：zhoubo
/// 编写日期: 2019-06-14
Class DHCHAI.IRS.INFHDMSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-06-20
/// Description:  横断面疾病统计
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFHDMSrv","QryForDiaKind","3")
Query QryForDiaKind(aSurNumID As %String) As %Query(ROWSPEC = "ind:%String,LocDesc:%String,DiagnosDesc:%String,IsInfFlag:%String") [ SqlProc ]
{
}

ClassMethod QryForDiaKindExecute(ByRef qHandle As %Binary, aSurNumID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aSurNumID="") $$$OK
 	
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber   = objSExec.SESurvNumber
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
    Set NIndex="QryForDiaKind"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"W","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)	
		Set LocID   = objLoc.%Id()
		Set LocDesc = objLoc.BTDesc
		//横断面调查信息
		Set xRepID = ""
		Set (DiagnosDesc,RepID,IsInfFlag)=""
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",Paadm,"7",xRepID))			
		if (xRepID'=""){
			//取报告里的信息
			Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			if $Isobject(xObjRep) {
				Set RepID = xRepID				
				Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
				Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
				if $IsObject(xObj) {
					If $IsObject(xObj.IRInfectionDr) {
						Set InfectID   = xObj.IRInfectionDr.%Id()
						Set InfectDesc = xObj.IRInfectionDr.BTDesc
					}
					Set:InfectDesc="存在" IsInfFlag=1
					If ($IsObject(xObj.IRCSSDiagnosDr)){
						Set DiagnosDesc=xObj.IRCSSDiagnosDr.BTDesc
					}					
				}
			}
		}
		Set Data=$lb(ind,LocDesc,DiagnosDesc,IsInfFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryForDiaKindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForDiaKindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryForDiaKindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForDiaKindExecute ]
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
/// CreatDate：   2018-12-24
/// Description:  横断面细菌耐药性统计
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFHDMSrv","QryForDrugsen","3","E")
Query QryForDrugsen(aSurNumID As %String, aLocType As %String) As %Query(ROWSPEC = "LocDesc:%String,Obj1BZ:%String,Obj1TB:%String,Obj2BZ:%String,Obj2TB:%String,Obj3AP:%String,Obj3WG:%String,Obj4AP:%String,Obj4WG:%String,Obj5QM:%String,Obj6TB:%String,Obj6YA:%String,Obj6ZY:%String,Obj7TB:%String,Obj7YA:%String,Obj7ZY:%String,Obj8HB:%String,Obj8PA:%String,Obj8YA:%String,Obj8TBT:%String,Obj8TBP:%String,Obj8AM:%String,Obj9YA:%String,Obj9TB:%String") [ SqlProc ]
{
}

ClassMethod QryForDrugsenExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aSurNumID="") $$$OK
 	
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber   = objSExec.SESurvNumber
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
    Set NIndex="QryForLocInf"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)	
		Set LocID   = objLoc.%Id()
		Set LocDesc = objLoc.BTDesc
		//横断面调查信息
		Set xRepID = ""
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",Paadm,"7",xRepID))			
		if (xRepID'=""){
			//取报告里的信息
			Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			if $Isobject(xObjRep) {
				Set RepID = xRepID				
				Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
				Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
				if $IsObject(xObj) {
					Set BugsAntiSens = xObj.IRBugsAntiSen
					
					For xi=1:1:$l(BugsAntiSens,"#"){
						Set BugsAntis=$p(BugsAntiSens,"#",xi)
						Set Bugs=$p(BugsAntis,"||",1)
						If (Bugs="金黄色葡萄球菌"){
							Set Obj1BZ=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj1BZ)
							Set:$IsObject(objDic) Obj1BZ=objDic.BTDesc
							Set Obj1TB=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj1TB)
							Set:$IsObject(objDic) Obj1TB=objDic.BTDesc
						}
						If (Bugs="凝固酶阴性葡萄球菌"){
							Set Obj2BZ=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj2BZ)
							Set:$IsObject(objDic) Obj2BZ=objDic.BTDesc
							Set Obj2TB=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj2TB)
							Set:$IsObject(objDic) Obj2TB=objDic.BTDesc
						}
						If (Bugs="粪肠球菌"){
							Set Obj3AP=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj3AP)
							Set:$IsObject(objDic) Obj3AP=objDic.BTDesc
							Set Obj3WG=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj3WG)
							Set:$IsObject(objDic) Obj3WG=objDic.BTDesc
						}
						If (Bugs="屎肠球菌"){
							Set Obj4AP=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj4AP)
							Set:$IsObject(objDic) Obj4AP=objDic.BTDesc
							Set Obj4WG=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj4WG)
							Set:$IsObject(objDic) Obj4WG=objDic.BTDesc
						}
						If (Bugs="肺炎链球菌"){
							Set Obj5QM=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj5QM)
							Set:$IsObject(objDic) Obj5QM=objDic.BTDesc
						}
						If (Bugs="大肠埃希菌"){
							Set Obj6TB=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj6TB)
							Set:$IsObject(objDic) Obj6TB=objDic.BTDesc
							Set Obj6YA=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj6YA)
							Set:$IsObject(objDic) Obj6YA=objDic.BTDesc
							Set Obj6ZY=$p(BugsAntis,"||",4)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj6ZY)
							Set:$IsObject(objDic) Obj6ZY=objDic.BTDesc
						}
						If (Bugs="肺炎克雷伯菌"){
							Set Obj7TB=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj7TB)
							Set:$IsObject(objDic) Obj7TB=objDic.BTDesc
							Set Obj7YA=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj7YA)
							Set:$IsObject(objDic) Obj7YA=objDic.BTDesc
							Set Obj7ZY=$p(BugsAntis,"||",4)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj7ZY)
							Set:$IsObject(objDic) Obj7ZY=objDic.BTDesc
						}
						If (Bugs="铜绿假单胞菌"){
							Set Obj8HB=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8HB)
							Set:$IsObject(objDic) Obj8HB=objDic.BTDesc
							Set Obj8PA=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8PA)
							Set:$IsObject(objDic) Obj8PA=objDic.BTDesc
							Set Obj8YA=$p(BugsAntis,"||",4)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8YA)
							Set:$IsObject(objDic) Obj8YA=objDic.BTDesc
							Set Obj8TBT=$p(BugsAntis,"||",5)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8TBT)
							Set:$IsObject(objDic) Obj8TBT=objDic.BTDesc
							Set Obj8TBP=$p(BugsAntis,"||",6)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8TBP)
							Set:$IsObject(objDic) Obj8TBT=objDic.BTDesc
							Set Obj8AM=$p(BugsAntis,"||",7)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj8AM)
							Set:$IsObject(objDic) Obj8AM=objDic.BTDesc
						}
						If (Bugs="鲍曼不动杆菌"){
							Set Obj9YA=$p(BugsAntis,"||",2)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj9YA)
							Set:$IsObject(objDic) Obj9YA=objDic.BTDesc
							Set Obj9TB=$p(BugsAntis,"||",3)
							Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Obj9TB)
							Set:$IsObject(objDic) Obj9TB=objDic.BTDesc
						}
					}
					s Data=$lb(LocDesc,Obj1BZ,Obj1TB,Obj2BZ,Obj2TB,Obj3AP,Obj3WG,Obj4AP,Obj4WG,Obj5QM,Obj6TB,Obj6YA,Obj6ZY,Obj7TB,Obj7YA,Obj7ZY,Obj8HB,Obj8PA,Obj8YA,Obj8TBT,Obj8TBP,Obj8AM,Obj9YA,Obj9TB)
					s ^CacheTemp(repid,ind)=Data
					s ind=ind+1						
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryForDrugsenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForDrugsenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryForDrugsenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForDrugsenExecute ]
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
/// CreatDate：   2018-12-24
/// Description:  横断面病原体-部位汇总统计
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFHDMSrv","QryForDrugs","3","医院感染","","")
Query QryForDrugs(aSurNumID As %String, aInfTypeStr As %String, aLocType As %String, aLocDr As %String) As %Query(ROWSPEC = "ind:%String,InfPosDesc:%String,BacteriaDesc:%String") [ SqlProc ]
{
}

ClassMethod QryForDrugsExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfTypeStr As %String, aLocType As %String, aLocDr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    Quit:(aSurNumID="") $$$OK
 	Set:aLocType="" aLocType="W"
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber   = objSExec.SESurvNumber
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
    Set NIndex="QryForLocInf"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count(){
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		Continue:(aLocDr'="")&&(aLocDr'=LocID)
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)	
		Set LocID   = objLoc.%Id()
		Set LocDesc = objLoc.BTDesc
		//横断面调查信息
		Set xRepID = ""
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",Paadm,"7",xRepID))			
		if (xRepID'=""){
			//取报告里的信息
			Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			if $Isobject(xObjRep) {
				Set RepID = xRepID				
				Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
				Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
				if $IsObject(xObj) {
					If $IsObject(xObj.IRInfectionDr) {
						Set InfectID   = xObj.IRInfectionDr.%Id()
						Set InfectDesc = xObj.IRInfectionDr.BTDesc
					}
					If (aInfTypeStr="医院感染"){  // 医院感染
						Set IRInfPathogen1=xObj.IRInfPathogen1
						If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
							Set InfPosDr = $p(IRInfPathogen1,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen1,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen2=xObj.IRInfPathogen2
						If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
							Set InfPosDr = $p(IRInfPathogen2,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen2,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen3=xObj.IRInfPathogen3
						If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
							Set InfPosDr = $p(IRInfPathogen3,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen3,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
					}ElseIf (aInfTypeStr="社区感染"){  //社区感染
						Set IRInfPathogen1=xObj.IRComInfPathogen1
						If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
							Set InfPosDr = $p(IRInfPathogen1,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen1,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen2=xObj.IRComInfPathogen2
						If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
							Set InfPosDr = $p(IRInfPathogen2,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen2,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen3=xObj.IRComInfPathogen3
						If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
							Set InfPosDr = $p(IRInfPathogen3,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen3,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
					}Else{ // 社区+医院感染
						Set IRInfPathogen1=xObj.IRInfPathogen1
						If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
							Set InfPosDr = $p(IRInfPathogen1,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen1,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen2=xObj.IRInfPathogen2
						If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
							Set InfPosDr = $p(IRInfPathogen2,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen2,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen3=xObj.IRInfPathogen3
						If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
							Set InfPosDr = $p(IRInfPathogen3,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen3,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen1=xObj.IRComInfPathogen1
						If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
							Set InfPosDr = $p(IRInfPathogen1,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen1,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen1,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen2=xObj.IRComInfPathogen2
						If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
							Set InfPosDr = $p(IRInfPathogen2,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen2,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen2,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
						Set IRInfPathogen3=xObj.IRComInfPathogen3
						If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
							Set InfPosDr = $p(IRInfPathogen3,"#",1)
							Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
							If ($IsObject(objInfPos)) {
								Set InfPosDesc = objInfPos.BTDesc
								Set BacteriaDr = $p(IRInfPathogen3,"#",2)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",4)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
								Set BacteriaDr = $p(IRInfPathogen3,"#",6)
								Set objBacteria = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
								If ($IsObject(objBacteria)){
									Set BacteriaDesc = objBacteria.BTBacDesc
									Set Data = $lb(ind,InfPosDesc,BacteriaDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						}
					}						
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryForDrugsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForDrugsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryForDrugsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForDrugsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2018-12-24 
/// Description:  横断面科室感染率统计
/// Return：      返回ROWSPEC 
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFHDMSrv","QryForLocInf","3","医院感染","W")
Query QryForLocInf(aSurNumID As %String, aInfTypeStr As %String, aLocType As %String) As %Query(ROWSPEC = "ind:%String,LocID:%String,LocDesc:%String,Paadm:%String,RepID:%String,InfectID:%String,InfectDesc:%String,InfCateID:%String,InfCateDesc:%String,IsInfFlag:%String,IsOperFlag:%String,CuteTypeID:%String,CuteTypeDesc:%String,IsAntiFlag:%String,IsAntiSenFlag:%String,PurposeDr:%String,PurposeDesc:%String,CombinDr:%String,CombinDesc:%String,InfPosList:%String,InfTimes:%String") [ SqlProc ]
{
}

ClassMethod QryForLocInfExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfTypeStr As %String, aLocType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	Quit:(aSurNumID="") $$$OK
 	
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber   = objSExec.SESurvNumber
 	Set SEHospID	= objSExec.SEHospDr.%Id()
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
    Set NIndex="QryForLocInf"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set BTHospDr = objLoc.BTHospDr.%Id()
		Continue:SEHospID'=BTHospDr
		Set LocID   = objLoc.%Id()
		Set LocDesc = objLoc.BTDesc
		//横断面调查信息
		Set xRepID = ""
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",Paadm,"7",xRepID))			
		Set (RepID,InfectID,InfectDesc,InfCateID,InfCateDesc,IsInfFlag,IsOperFlag,CuteTypeID,CuteTypeDesc,IsAntiFlag,PurposeDr,PurposeDesc,CombinDr,CombinDesc,InfPosList)=""
		Set InfTimes=0 //感染例次数
		if (xRepID'=""){
			//取报告里的信息
			Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			if $Isobject(xObjRep) {
				Set RepID = xRepID				
				Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
				Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
				if $IsObject(xObj) {
					If $IsObject(xObj.IRInfectionDr) {
						Set InfectID   = xObj.IRInfectionDr.%Id()
						Set InfectDesc = xObj.IRInfectionDr.BTDesc
					}
					Set:InfectDesc="存在" IsInfFlag=1
					If $IsObject(xObj.IRInfCategoryDr) {
						Set InfCateID   = xObj.IRInfCategoryDr.%Id()
						Set InfCateDesc = xObj.IRInfCategoryDr.BTDesc
					}
					Set IsOperFlag = xObj.IROperFlag
					If $IsObject(xObj.IROperCuteTypeDr) {
						Set CuteTypeID   = xObj.IROperCuteTypeDr.%Id()
						Set CuteTypeDesc = xObj.IROperCuteTypeDr.BTDesc
					}
					Set IsAntiFlag = xObj.IRAntiFlag      //是否抗菌药物
					Set IsAntiSenFlag = xObj.IRAntiSenFlag
					If $IsObject(xObj.IRAntiUsePurposeDr) {
						Set PurposeDr   = xObj.IRAntiUsePurposeDr.%Id()
						Set PurposeDesc = xObj.IRAntiUsePurposeDr.BTDesc
					}
					If $IsObject(xObj.IRAntiCombinedMedDr) {
						Set CombinDr   = xObj.IRAntiCombinedMedDr.%Id()
						Set CombinDesc = xObj.IRAntiCombinedMedDr.BTDesc
					}
					If (aInfTypeStr="医院感染"){  // 医院感染
						If (aInfTypeStr'=InfCateDesc){
							Set (IsAntiFlag,IsAntiSenFlag,PurposeDr,PurposeDesc,CombinDr,CombinDesc)=""
						}
					}ElseIf (aInfTypeStr="社区感染"){  //社区感染
						If (aInfTypeStr'=InfCateDesc){
							Set (IsAntiFlag,IsAntiSenFlag,PurposeDr,PurposeDesc,CombinDr,CombinDesc)=""
						}
					}Else{ // 社区+医院感染
						
					}
					Set IRInfPathogen1=xObj.IRInfPathogen1
					Set YYInfPosList=""
					If ((IRInfPathogen1'="")&&(IRInfPathogen1'="######")){
						Set YYInfPosDr = $p(IRInfPathogen1,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:YYInfPosList'[YYInfPosDesc YYInfPosList=YYInfPosList_"#"_YYInfPosDesc
						}
					}
					Set IRInfPathogen2=xObj.IRInfPathogen2
					If ((IRInfPathogen2'="")&&(IRInfPathogen2'="######")){
						Set YYInfPosDr = $p(IRInfPathogen2,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:YYInfPosList'[YYInfPosDesc YYInfPosList=YYInfPosList_"#"_YYInfPosDesc
						}
					}
					Set IRInfPathogen3=xObj.IRInfPathogen3
					If ((IRInfPathogen3'="")&&(IRInfPathogen3'="######")){
						Set YYInfPosDr = $p(IRInfPathogen3,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:YYInfPosList'[YYInfPosDesc YYInfPosList=YYInfPosList_"#"_YYInfPosDesc
						}
					}
					Set SQInfPosList=""
					Set IRComInfPathogen1=xObj.IRComInfPathogen1
					If ((IRComInfPathogen1'="")&&(IRComInfPathogen1'="######")){
						Set YYInfPosDr = $p(IRComInfPathogen1,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:SQInfPosList'[YYInfPosDesc SQInfPosList=SQInfPosList_"#"_YYInfPosDesc
						}
					}
					Set IRComInfPathogen2=xObj.IRComInfPathogen2
					If ((IRComInfPathogen2'="")&&(IRComInfPathogen2'="######")){
						Set YYInfPosDr = $p(IRComInfPathogen2,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:SQInfPosList'[YYInfPosDesc SQInfPosList=SQInfPosList_"#"_YYInfPosDesc
						}
					}
					Set IRComInfPathogen3=xObj.IRComInfPathogen3
					If ((IRComInfPathogen3'="")&&(IRComInfPathogen3'="######")){
						Set YYInfPosDr = $p(IRComInfPathogen3,"#",1)
						Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(YYInfPosDr)
						If ($IsObject(objInfPos)){ 
							Set YYInfPosDesc = objInfPos.BTDesc
							Set:SQInfPosList'[YYInfPosDesc SQInfPosList=SQInfPosList_"#"_YYInfPosDesc
						}
					}
					Set InfPosList=""
					If (aInfTypeStr="医院感染"){  // 医院感染
						Set InfPosList=YYInfPosList
					}ElseIf (aInfTypeStr="社区感染"){  //社区感染
						Set InfPosList=SQInfPosList
					}Else{ // 社区+医院感染
						Set InfPosList=YYInfPosList_SQInfPosList
					}
					
					Set InfTimes = $l(InfPosList,"#")-1							
				}
			}
		}
		Set Data = $lb(ind,LocID,LocDesc,Paadm,RepID,InfectID,InfectDesc,InfCateID,InfCateDesc,IsInfFlag,IsOperFlag,CuteTypeID,CuteTypeDesc,IsAntiFlag,IsAntiSenFlag,PurposeDr,PurposeDesc,CombinDr,CombinDesc,InfPosList,InfTimes)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryForLocInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForLocInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryForLocInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForLocInfExecute ]
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
