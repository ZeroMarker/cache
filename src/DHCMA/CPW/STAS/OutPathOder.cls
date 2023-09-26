/// 名称: DHCMA.CPW.STAS.OutPathOder
/// 描述: 临床路径路径外医嘱报表服务类
/// 编写者：zqy
/// 编写日期: 2022-11-16
Class DHCMA.CPW.STAS.OutPathOder Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// CreatDate：   2022-22-17
/// Description:  按出院日期统计
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：                   
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.STAS.OutPathOder","QryCPWVarOrdMXByDate","2018-06-01","2020-06-30","2")
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
			 		Continue:'$IsObject(objPathwayEpi.CPFormEpDr)
			 		Set PWVarInfo=..GetPathWayVarArc(xPathwayID,xPathwayID_"||"_xPathwayEpiId)
			 		Set FormEpId=objPathwayEpi.CPFormEpDr.%Id()
			 		Set len=$l(PWVarInfo,"^")
			 		For index=1:1:len{
				 		Set xPWVarInfo=$p(PWVarInfo,"^",index)
				 		Continue:xPWVarInfo=""
				 		Set VarArcDesc=$p(xPWVarInfo,"$",1)
			 			Set VarArcNum=+$p(xPWVarInfo,"$",2)
			 			if (VarArcDesc=""){
							Set ^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId)=""
						}else{
							Set ^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId,VarArcDesc)=+$g(^TEMP($j,$zn,xIndex,yIndex,"FormEpId",FormEpId,VarArcDesc))+VarArcNum
						}
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

/// Description:  获取变异医嘱内容和次数
/// w ##class(DHCMA.CPW.STAS.OutPathOder).GetPathWayVarArc(1,"1||1")
ClassMethod GetPathWayVarArc(aPathWayId As %String, aPathWayEpiId As %String) As %String
{
	n (aPathWayId,aPathWayEpiId)
	Set return=""
	
	Q:(aPathWayId="")||(aPathWayEpiId="") return
	Set xPathwayVarId=""
	For{
		Set xPathwayVarId=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathWayId,aPathWayEpiId,xPathwayVarId))
		Quit:xPathwayVarId=""
		Set objVar = ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathWayId_"||"_xPathwayVarId)
		Continue:'$IsObject(objVar)
		Continue:objVar.CPIsActive'=1
		Set EpisDr=objVar.CPEpisDr.%Id()
		Continue:(aPathWayEpiId'=EpisDr)
		Continue:objVar.CPOrdDID=""
	 	Continue:$IsObject(objVar.CPImplDr)		//路径外医嘱没有项目指针
		
		Set xOrdDID=objVar.CPOrdDID
		Set ARCIMNum=$l(xOrdDID,"^")
		Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
		Set OESubID=$p(xOrdDID,"||",2)
		Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
		Set ARCIMDesc=$p($g(^ARCIM(+OEItmMastID,1,1)),"^",2)
		if (return=""){
			Set return=ARCIMDesc_"$"_ARCIMNum
		}else{
			Set return=return_"^"_ARCIMDesc_"$"_ARCIMNum
		}
	}
	
	
	Q return
}

}
