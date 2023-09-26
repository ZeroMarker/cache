/// 名称: DHCMed.NINFService.Rep.HandHyProducts
/// 描述: 手卫生用品消耗量
/// 编写者：zhufei
/// 编写日期: 2013-07-22
Class DHCMed.NINFService.Rep.HandHyProducts Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-07-22
/// Description:  保存手卫生用品消耗量信息
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.HandHyProducts).SaveRepRec("^117^2013-07^1^100^117^9^1^","^")
ClassMethod SaveRepRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	//Set $ZT="SaveRepRecErr"
	
	Quit:aSeparate="" return
	
	Set ReportID=$p(aInput,aSeparate,1)
	Set ExamLoc=$p(aInput,aSeparate,2)
	Set ExamDate=$p(aInput,aSeparate,3)
	If ExamDate["-" {
		If $l(ExamDate,"-")=2 {
			Set ExamDate=ExamDate_"-01"
			Set ExamDate=$zdh(ExamDate,3)
			Set ExamDate=ExamDate+32
			Set ExamDate=$zd(ExamDate,3)
			Set ExamDate=$p(ExamDate,"-",1)_"-"_$p(ExamDate,"-",2)_"-01"
			Set ExamDate=$zdh(ExamDate,3)
			Set ExamDate=ExamDate-1
		} Else {
			Set ExamDate=$zdh(ExamDate,3)
		}
	}
	Set Product=$p(aInput,aSeparate,4)
	Set Consumption=$p(aInput,aSeparate,5)
	Set RepLoc=$p(aInput,aSeparate,6)
	Set RepUser=$p(aInput,aSeparate,7)
	Set RepStatus=$p(aInput,aSeparate,8)
	Set RepStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"NINFHandHyReportStatus")
	Set Resume=$p(aInput,aSeparate,9)
	
	Set $p(aInput,aSeparate,3)=ExamDate
	Set $p(aInput,aSeparate,8)=RepStatusID
	
	Set return=##Class(DHCMed.NINF.Rep.HandHyProducts).Update(aInput,aSeparate)
	Quit return
	
SaveRepRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2013-07-22
/// Description:  保存手卫生用品消耗量信息(只更新报告状态)
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.HandHyProducts).SaveRepStatus("4^117^9^0^","^")
ClassMethod SaveRepStatus(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepStatusErr"
	
	Set RepordID=$p(aInput,aSeparate,1)
	Set LogLoc=$p(aInput,aSeparate,2)
	Set LogUser=$p(aInput,aSeparate,3)
	Set RepStatus=$p(aInput,aSeparate,4)
	Set RepStatus=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"NINFHandHyReportStatus")
	Set LogResume=$p(aInput,aSeparate,5)
	
	Set obj=##class(DHCMed.NINF.Rep.HandHyProducts).%OpenId(RepordID)
	Quit:'$IsObject(obj) return
	Set obj.HHPRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatus)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set flg=##Class(DHCMed.NINF.Rep.HandHyProductsLog).Update(aInput,aSeparate)
	}
	Do obj.%Close()
	
	Quit return
	
SaveRepStatusErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2013-07-22
/// Description:  查询手卫生用品消耗量信息
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.HandHyProducts","QryHandHyProducts","2012-08-27","2012-08-27","","")
Query QryHandHyProducts(aDateFrom As %String, aDateTo As %String, aLoc As %String, aRepStatus As %String) As %Query(ROWSPEC = "ReportID:%String,ExamLocID:%String,ExamLocDesc:%String,ExamDate:%String,ExamYYMM:%String,ProductID:%String,ProductDesc:%String,ProductSpec:%String,ProductUnit:%String,Consumption:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,RepResume:%String")
{
}

ClassMethod QryHandHyProductsExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLoc As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aDateFrom["-" {
		If $l(aDateFrom,"-")=2 {
			Set aDateFrom=aDateFrom_"-01"
			Set aDateFrom=$zdh(aDateFrom,3)
		} Else {
			Set aDateFrom=$zdh(aDateFrom,3)
		}
	}
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	If aDateTo["-" {
		If $l(aDateTo,"-")=2 {
			Set aDateTo=aDateTo_"-01"
			Set aDateTo=$zdh(aDateTo,3)
			Set aDateTo=aDateTo+32
			Set aDateTo=$zd(aDateTo,3)
			Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
			Set aDateTo=$zdh(aDateTo,3)
			Set aDateTo=aDateTo-1
		} Else {
			Set aDateTo=$zdh(aDateTo,3)
		}
	}
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Continue:(aLoc'="")&&(xLoc'=aLoc)
			
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				
				Set obj=##class(DHCMed.NINF.Rep.HandHyProducts).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Set (ReportID,ExamLocID,ExamLocDesc,ExamDate,ExamYYMM,ProductID,ProductDesc,ProductSpec,ProductUnit,Consumption)=""
				Set (RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepStatusID,RepStatusCode,RepStatusDesc,RepResume)=""
				
				Set ReportID=obj.%Id()
				If $IsObject(obj.HHPRepStatus) {
					Set RepStatusID=obj.HHPRepStatus.%Id()
					Set RepStatusCode=obj.HHPRepStatus.Code
					//Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.HHPRepStatus.Description
					Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusCode)
				}
				
				Set ExamLocID=obj.HHPExamLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(ExamLocID)
				If $IsObject(objLoc) {
					Set ExamLocID=objLoc.Rowid
					Set ExamLocDesc=objLoc.Descs
				}
				Set ExamDate=obj.HHPExamDate
				Set:ExamDate'="" ExamDate=$zd(ExamDate,3)
				Set:ExamDate'="" ExamYYMM=$p(ExamDate,"-",1)_"-"_$p(ExamDate,"-",2)
				If $IsObject(obj.HHPProduct) {
					Set ProductID=obj.HHPProduct.%Id()
					Set ProductDesc=obj.HHPProduct.HHPDesc
					Set ProductSpec=obj.HHPProduct.HHPSpec
					Set ProductUnit=obj.HHPProduct.HHPUnit
				}
				Set Consumption=obj.HHPConsumption
				
				Set RepDate=obj.HHPRepDate
				;Set:RepDate'="" RepDate=$zd(RepDate,3)
				Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
				Set RepTime=obj.HHPRepTime
				Set:RepTime'="" RepTime=$zt(RepTime,2)
				Set RepLocID=obj.HHPRepLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objLoc) {
					Set RepLocID=objLoc.Rowid
					Set RepLocDesc=objLoc.Descs
				}
				Set RepUserID=obj.HHPRepUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objUser) {
					Set RepUserID=objUser.Rowid
					Set RepUserDesc=objUser.Name
				}
				Set RepResume=obj.HHPResume
				
				Set Data=$lb(ReportID,ExamLocID,ExamLocDesc,ExamDate,ExamYYMM,ProductID,ProductDesc,ProductSpec,ProductUnit,Consumption)
				Set Data=Data_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
				Set Data=Data_$lb(RepStatusID,RepStatusCode,RepStatusDesc,RepResume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHandHyProductsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyProductsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyProductsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyProductsExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2013-07-22
/// Description:  手卫生用品消耗量统计
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.HandHyProducts","QryHandHyProToStat","2013-06","2013-07","")
Query QryHandHyProToStat(aDateFrom As %String, aDateTo As %String, aLoc As %String) As %Query(ROWSPEC = "ReportID:%String,ExamLocID:%String,ExamLocDesc:%String,ExamDate:%String,ExamYYMM:%String,ProductID:%String,ProductDesc:%String,ProductSpec:%String,ProductUnit,Consumption:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,RepResume:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyProToStatExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aDateFrom["-" {
		If $l(aDateFrom,"-")=2 {
			Set aDateFrom=aDateFrom_"-01"
			Set aDateFrom=$zdh(aDateFrom,3)
		} Else {
			Set aDateFrom=$zdh(aDateFrom,3)
		}
	}
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	If aDateTo["-" {
		If $l(aDateTo,"-")=2 {
			Set aDateTo=aDateTo_"-01"
			Set aDateTo=$zdh(aDateTo,3)
			Set aDateTo=aDateTo+32
			Set aDateTo=$zd(aDateTo,3)
			Set aDateTo=$p(aDateTo,"-",1)_"-"_$p(aDateTo,"-",2)_"-01"
			Set aDateTo=$zdh(aDateTo,3)
			Set aDateTo=aDateTo-1
		} Else {
			Set aDateTo=$zdh(aDateTo,3)
		}
	}
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Continue:(aLoc'="")&&(xLoc'=aLoc)
			
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("HHP",0,"IndexExamDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				
				Set obj=##class(DHCMed.NINF.Rep.HandHyProducts).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Set (ReportID,ExamLocID,ExamLocDesc,ExamDate,ExamYYMM,ProductID,ProductDesc,ProductSpec,ProductUnit,Consumption)=""
				Set (RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepStatusID,RepStatusCode,RepStatusDesc,RepResume)=""
				
				Set ReportID=obj.%Id()
				If $IsObject(obj.HHPRepStatus) {
					Set RepStatusID=obj.HHPRepStatus.%Id()
					Set RepStatusCode=obj.HHPRepStatus.Code
					Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.HHPRepStatus.Description
				}
				
				Set ExamLocID=obj.HHPExamLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(ExamLocID)
				If $IsObject(objLoc) {
					Set ExamLocID=objLoc.Rowid
					Set ExamLocDesc=objLoc.Descs
				}
				Set ExamDate=obj.HHPExamDate
				Set:ExamDate'="" ExamDate=$zd(ExamDate,3)
				Set:ExamDate'="" ExamYYMM=$p(ExamDate,"-",1)_"-"_$p(ExamDate,"-",2)
				If $IsObject(obj.HHPProduct) {
					Set ProductID=obj.HHPProduct.%Id()
					Set ProductDesc=obj.HHPProduct.HHPDesc
					Set ProductSpec=obj.HHPProduct.HHPSpec
					Set ProductUnit=obj.HHPProduct.HHPUnit
				}
				Set Consumption=obj.HHPConsumption
				
				Set RepDate=obj.HHPRepDate
				Set:RepDate'="" RepDate=$zd(RepDate,3)
				Set RepTime=obj.HHPRepTime
				Set:RepTime'="" RepTime=$zt(RepTime,2)
				Set RepLocID=obj.HHPRepLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objLoc) {
					Set RepLocID=objLoc.Rowid
					Set RepLocDesc=objLoc.Descs
				}
				Set RepUserID=obj.HHPRepUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objUser) {
					Set RepUserID=objUser.Rowid
					Set RepUserDesc=objUser.Name
				}
				Set RepResume=obj.HHPResume
				
				Set Data=$lb(ReportID,ExamLocID,ExamLocDesc,ExamDate,ExamYYMM,ProductID,ProductDesc,ProductSpec,ProductUnit,Consumption)
				Set Data=Data_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
				Set Data=Data_$lb(RepStatusID,RepStatusCode,RepStatusDesc,RepResume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHandHyProToStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyProToStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyProToStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyProToStatExecute ]
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
