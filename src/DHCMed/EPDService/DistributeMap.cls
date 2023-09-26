Class DHCMed.EPDService.DistributeMap Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		chenrui
/// CreateDate:		2021-09-16
/// Description:  	传染病报告统计
/// Table：       	DHCMed.EPD.Infection、DHCMed.EPD.Epidemic
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
/// Return：      	返回ROWSPEC
/// 疾病列表：d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryInfection","","")
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.DistributeMap","QryDisMap","2","2021-09-07","2021-09-07")
Query QryDisMap(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aRepStatus As %String) As %Query(ROWSPEC = "BTDecs:%String,DiseaseNum:%String") [ SqlProc ]
{
}

ClassMethod QryDisMapExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Quit:(DateFrom>DateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    Set:aRepStatus'="" aRepStatus=","_aRepStatus_","
    
	Set NIndex="QryDisMap"
	k ^TMP($zn,$j,NIndex)
	
	For xDate=DateFrom:1:DateTo{
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
				Continue:(Status'="")&&(aRepStatus'[(","_Status_","))
				
				
				
				Set BTDecs=objRep.MEPDICDDR.MIFDisease
				Set ^TMP($zn,$j,NIndex,"Loc","Doc",BTDecs,"Rep",RepID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,"Loc","Doc",BTDecs,"Rep"))
				Set ^TMP($zn,$j,NIndex,"Loc","Doc",BTDecs,"Rep")=Num+1
			}
		}
	}

	Set xBTDecs=""
	For{
		Set xBTDecs=$o(^TMP($zn,$j,NIndex,"Loc","Doc",xBTDecs))
		Quit:xBTDecs=""

		Set DiseaseNum=+$g(^TMP($zn,$j,NIndex,"Loc","Doc",xBTDecs,"Rep"))
			
		Set Data=$lb(xBTDecs,DiseaseNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	

	Quit $$$OK
}

ClassMethod QryDisMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDisMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisMapExecute ]
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

/// 根据字典描述与代码，找到ID
/// w ##class(DHCMed.EPDService.DistributeMap).GetIDByDesc("已审,订正,被订","EpidemicReportStatus")
ClassMethod GetIDByDesc(aDesc As %String, aCode As %String) As %String
{
	new (aDesc,aCode)
	Quit:aDesc="" 0
	Quit:aCode="" -2
	set return=""
	Set Length = $l(aDesc,",")
	For i=1:1:Length{
		Set Desc = $p(aDesc,",",i)
		Set obj = ##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc(aCode,Desc)
		Set xCode = obj.Code
		Set return = return_","_xCode
	}
	
	Set return = $p(return,",",2,Length+1)
	
	
	Quit return
}

}
