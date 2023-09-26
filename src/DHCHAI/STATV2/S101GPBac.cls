/// 名称: DHCHAI.STATV2.S091GPBac
/// 描述: HAI0091革兰阴性细菌构成比统计表
/// 编写者: mayanpeng
/// 编写日期: 2019-12-05
Class DHCHAI.STATV2.S101GPBac Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		mayanpeng
/// CreateDate：	2018-07-31
/// Description:	革兰阴性细菌构成比
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
/// 			  	aStaType:  统计类型 E：科室 W：病区
/// 		 	  	aQryCon:	是否仅显示有数据的科室
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S091GPBac","QryPathogeny","2|1","2018-04-01","2018-04-10","W","")
Query QryPathogeny(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "ind:%String,DimensKey:%String,DimensDesc:%String,BacDesc:%String,BacCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryPathogenyExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set HospCount = $l(aHospIDs,"|")
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	 //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	
	Set NIndex="QryPathogeny"
	Kill ^TMP($zn,$j,NIndex)

	Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}Else {
			Set GroupInfo=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Continue:GroupInfo=""
			Set GroupDesc=$List(GroupInfo,3)
		}
		Set LocDesc = $List(LocData,4)
		Set:LocDesc="" LocDesc=$List(LocData,3)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set TransDate = $p(TransDates,",",1)
		Set EndDate   = $p(TransDates,",",$l(TransDates,","))
		Set:(TransDate>aDateFrom)&&(TransDate<aDateTo) TransDate=TransDate-1
		
		//统计维度
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}

			If '$d(^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)) {
				Set ^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)=""
				
				//患者细菌信息
			    Set ListBacArray=##class(DHCHAI.STATV2.S080InfBac).GetBacteriaInfo(Paadm,TransDate,EndDate,LocID)
			    For index2=1:1:ListBacArray.Count() {
					Set BacInfo=ListBacArray.GetAt(index2)	
					Continue:BacInfo=""
					
					Set VisitNumberDr = $LIST(BacInfo,2)
					Set LabReportDr   = $LIST(BacInfo,3)
					Set ResultID    = $LIST(BacInfo,4)
					Set Specimen    = $LIST(BacInfo,5)
					Set BacDesc     = $LIST(BacInfo,6)
					Set BacTypeCode = $LIST(BacInfo,7)
					Set IsInfFlag   = $LIST(BacInfo,10)
					Set ActDateTime = $LIST(BacInfo,11)
					Set RepDateTime = $LIST(BacInfo,12)
					Set LocDr       = $LIST(BacInfo,13)
					Set WardDr      = $LIST(BacInfo,14)
					Continue:BacDesc=""
					Continue:BacTypeCode'="-"	//革兰阴性细菌
				
					If TransType="E" {					//过滤转科导致的重复数据
						Continue:LocID'=LocDr
					} Else {
						Continue:LocID'=WardDr
					}
					
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"BacPat",Paadm)){
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"BacPat"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"BacPat",Paadm)=""
					}
					
					Set ^TMP($zn,$j,NIndex,DimensKey,"BacDesc",BacDesc)=""
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"BacCnt",BacDesc))
				}
			}
				
		}
    }
  
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	// 输出Data
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
		Continue:(xDimensKey["A")&(HospCount="1")
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    //住院患者人数
		Set BacPat    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"BacPat"))  
		
		Continue:(IsActive'=1)&&(PatAdmCnt=0)
		Continue:(aQryCon=2)&&(BacPat=0)
		
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,"BacDesc",xBacDesc))
			Quit:xBacDesc=""
			
			Set BacCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"BacCnt",xBacDesc))
				
			Set Data=$lb(xDimensKey,DimensDesc,xBacDesc,BacCnt)
			Set ^CacheTemp(repid,ind)=$lb(ind)_Data
			Set ind=ind+1			

		}				
	}
	Kill ^TMP($zn,$j,NIndex)

	Quit $$$OK
}

ClassMethod QryPathogenyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyExecute ]
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
