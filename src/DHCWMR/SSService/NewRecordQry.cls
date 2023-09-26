/// 名称: DHCWMR.SSService.NewRecordQry
/// 描述: 病案建档相关查询服务
/// 编写者：liyi
/// 编写日期: 2015-11-10
Class DHCWMR.SSService.NewRecordQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-10-10
/// Description:  建档费查询
/// Table：       
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.NewRecordQry","QryNewRecord","3",6,"2015-10-10","2015-11-19","")
Query QryNewRecord(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Query(ROWSPEC = "MainID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Price:%String,BillNum:%String,BuildUser:%String,DateTime:%String")
{
}

ClassMethod QryNewRecordExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Quit:(aHospID="")||(aMrTypeID="")||(aDateFrom="")||(aDateTo="") $$$OK

	Kill ^TMP($zn,$j,"QryNewRecord")
	
	For xDate = aDateFrom:1:aDateTo{
		Set xMainID=""
		For {
			Set xMainID = $o(^DHCWMR.SS.MainI("IndexTypeBuildDateAct",aMrTypeID,xDate,1,xMainID))
			Quit:xMainID=""
			
			Set objMain = ##class(DHCWMR.SS.Main).GetObjById(xMainID)
			Continue:'$IsObject(objMain)
			
			Set FirstHosp = objMain.SMFirstHosp
			Continue:(aHospID'="")&&(aHospID'=FirstHosp)
			
			Set FirstLoc = objMain.SMFirstLoc
			Continue:(aLocID'="")&&(aLocID'=FirstLoc)
			
			Set BuildUser = objMain.SMBuildUser
			Continue:BuildUser=""
			Set ^TMP($zn,$j,"QryNewRecord",BuildUser,xMainID)=""
		}
	}

	Set xUser=""
	For {
		Set xUser=$o(^TMP($zn,$j,"QryNewRecord",xUser))
		Quit:xUser=""
		Set xMainID =""
		For {
			Set xMainID = $o(^TMP($zn,$j,"QryNewRecord",xUser,xMainID))
			Quit:xMainID=""
			Set objMain = ##class(DHCWMR.SS.Main).GetObjById(xMainID)
			Set MrNo = objMain.SMMrNo
			Set BuildUser = objMain.SMBuildUser
			Set BuildDate = objMain.SMBuildDate
			Set BuildTime = objMain.SMBuildTime
			Set:BuildUser'="" BuildUser = $p($g(^SSU("SSUSR",xUser)),"^",2) 
			Set DateTime = ""
			iF (+BuildDate'=0)&&(+BuildTime'=0)
			{
				;Set DateTime = $ZD(BuildDate,3)_" "_$ZT(BuildTime)
				Set DateTime = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BuildDate)_" "_$ZT(BuildTime)
			}
			
			Set Papmi = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,aMrTypeID)
			Continue:Papmi=""
			
			Set objPat = ##class(DHCWMR.Base.Patient).GetObjById(Papmi)
			Continue:'$IsObject(objPat)
			
			Set PapmiNo = objPat.PapmiNo
			Set PatName = objPat.PatientName
			
			Set MainIDStr=##class(DHCWMR.SS.Main).GetHisMainByID(xMainID)
			Set MainIDStr=MainIDStr_","_xMainID
			Set Price=0
			For indMain=1:1:$l(MainIDStr,",") {
				Set tmpMainID=$p(MainIDStr,",",indMain)
				Continue:tmpMainID=""
				Set objMainFee = ##class(DHCWMR.SS.MainFee).GetObjById(tmpMainID_"||"_1)
				If $IsObject(objMainFee)
				{
					continue:objMainFee.MFRecordDr.FRFeeItemDr.FICode'="JD"
					Set Price = objMainFee.MFRecordDr.FRMoney
				}
				Quit:Price>0
			}
			Set Price = $fn(Price,"",2)
			Set BillNum=1
			Set Data = $lb(xMainID,MrNo,PapmiNo,PatName,Price,BillNum,BuildUser,DateTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,"QryNewRecord")
	
	Quit $$$OK
}

ClassMethod QryNewRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNewRecordExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNewRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNewRecordExecute ]
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
