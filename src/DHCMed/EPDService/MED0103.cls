Class DHCMed.EPDService.MED0103 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:fujingwei
/// CreateDate:2018-10-12
/// Description:  传染病报告统计
/// Table：       DHCMed.EPD.Infection、DHCMed.EPD.Epidemic
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Return：      返回ROWSPEC
/// 疾病列表：d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryInfection","","")
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.MED0103","QryWorkLoad","1","2018-10-12","2018-10-12")
Query QryWorkLoad(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,AdmLoc:%String,UserID:%String,RepUserName:%String,UserNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryWorkLoadExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    
	Set NIndex="QryWorkLoad"
	k ^TMP($zn,$j,NIndex)
	
	For xDate=aDateFrom:1:aDateTo{
		Set xLocID=""
		For{
			Set xLocID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			Set HospID=$p(^CTLOC(xLocID),"^",22)
			Continue:(aHospIDs'="")&&(aHospIDs'[(","_HospID_","))
			Set RepID=""
			For{
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID,RepID))
				Quit:RepID=""
				
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Set Status=objRep.MEPDStatus
				Continue:Status=4      //被订      
				Continue:Status=6      //草稿
				Continue:Status=7      //删除
				
				//Continue:Status'=2    //已审
				
				Set RepUser=objRep.MEPDRepUsrDR
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"Doc",RepUser,"Rep",RepID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"Doc",RepUser,"Rep"))
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"Doc",RepUser,"Rep")=Num+1
			}
		}
	}
	Set tLocID=""
	For{
		Set tLocID=$o(^TMP($zn,$j,NIndex,"Loc",tLocID))
		Quit:tLocID=""
		
		Set AdmLoc=$p(^CTLOC(tLocID),"^",2)
		Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)

		Set xUser=""
		For{
			Set xUser=$o(^TMP($zn,$j,NIndex,"Loc",tLocID,"Doc",xUser))
			Quit:xUser=""
			
			Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(xUser)
			If $IsObject(objRepUser){
				Set RepUserName=objRepUser.Name
			}
			Set UserNum=+$g(^TMP($zn,$j,NIndex,"Loc",tLocID,"Doc",xUser,"Rep"))
			
			Set Data=$lb(tLocID,AdmLoc,xUser,RepUserName,UserNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}

	Quit $$$OK
}

ClassMethod QryWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkLoadExecute ]
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
