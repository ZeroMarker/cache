/// 名称: DHCHAI.STAT.S350BWPICCInf
/// 描述: 出生体重分组新生儿中央血管导管相关血流感染发病率统计表
/// 编写者: mayanpeng
/// 编写日期: 2018-10-18
Class DHCHAI.STAT.S350BWPICCInf Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-10-19
/// Description:  新生儿中央血管导管相关血流感染发病率
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S350BWPICCInf","QrySDayInf","","2018-01-01","2018-04-10")
Query QrySDayInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,WtCat:%String,WtCatDesc:%String,InDays:%Integer,PatNum:%Integer,InfCase:%Integer,PICCDays:%Integer,PICCAdmNum:%Integer") [ SqlProc ]
{
}

ClassMethod QrySDayInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QrySDayInf"
	Kill ^TMP($zn,$j,NIndex)
    
    //同期在科:某段时间的在科人数
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Continue:(Status="I")                 // 当天转入不算在内
		//Continue:(Status="A2")              // 当天转入当天转出不算在内
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Set LocDesc	    = objLoc.BTDesc
		Set LocDesc2	= objLoc.BTDesc2
		Set:LocDesc2="" LocDesc2 = LocDesc
		Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
		
		//科室名称
		Set ^TMP($zn,$j,NIndex,"Loc",LocID,"LocDesc")=LocDesc2
		
		// 医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$Isobject(objPaadm)
		Set IsNewBaby=objPaadm.PAIsNewBaby
		Continue:IsNewBaby'=1   // 过滤非新生儿
		Set Weigth=objPaadm.PAAdmitWeight
		Set Weigth=+Weigth
		Set WtCat=1   //默认体重第一类型
		
		// 全院住院患者人数
		If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm))
		{
			Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
			
			if (Weigth<=1000) 
			{
				Set WtCat=1
				Set WtCatDesc="BW ≤1000g"
			}
			elseif (Weigth>1000)&(Weigth<=1500) 
			{
				Set WtCat=2
				Set WtCatDesc="BW 1001g~1500g"
			}
			elseif (Weigth>1500)&(Weigth<=2500)
			{
				Set WtCat=3
				Set WtCatDesc="BW 1501g~2500g"
			}
			elseif (Weigth>2500)
			{
				Set WtCat=4
				Set WtCatDesc="BW >2500g"
			}
			Set ^TMP($zn,$j,NIndex,"WtCat",WtCat,"WtCatDesc")=WtCatDesc
			
			Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"PatNum"))
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"PatNum")=num+1 //同期住院患者人数
		}
		// 避免重复获取感染部位
		Set InfPosDescs=""
		If '$d(^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm))
		{
			Set InfPosDescs =##class(DHCHAI.STAT.S390InfPos).GetInfPosInfo(Paadm,aDateFrom,aDateTo)
		}
		Set ^TMP($zn,$j,NIndex,"Hosp","InfFlg",Paadm)=""
		If (InfPosDescs'="") {
			// 全院感染例次数
			If '$d(^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm))
			{
				Set ^TMP($zn,$j,NIndex,"Hosp","InfCase",Paadm)=""
				
				//感染例次
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCase"))
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCase")=num+$l(InfPosDescs,"|")
			}
			
		}
		Set InDays=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InDays")) // 同期在科天数
	}
	//科室，体重类别，住院天数，住院人数，感染例次
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		Set LocDesc=$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"LocDesc"))
		
		Set xWtCat=""
		For {
			Set xWtCat=$o(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat))
			Quit:xWtCat=""
			Set WtCatDesc=^TMP($zn,$j,NIndex,"WtCat",xWtCat,"WtCatDesc")
			
			Set InDays=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InDays"))
			Set PatNum=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"PatNum"))
			Set InfCase=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfCase"))
			//icu是按病区记录的			
			Set (APICCDays,APICCAdmNum) =0
			Set xSubID = ""
		 	For {
				Set xSubID = $o(^DHCHAI.BT.LocationD(xLocID,"Link",xSubID))
				Quit:xSubID=""
				
				Set xID = xLocID_"||"_xSubID
				Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
				Continue:'$IsObject(objLocLink)
				Continue:'$IsObject(objLocLink.BTLinkLocDr)
				Continue:(+objLocLink.BTIsActive)'=1
				
				Set LinkWardID = objLocLink.BTLinkLocDr.%Id()
			
				//三管使用日数
				Set ICUDays=##class(DHCHAI.IRS.ICULogSrv).GetICUDates(LinkWardID,aDateFrom,aDateTo,xWtCat)
				Set:ICUDays'="" PICCDays=$p(ICUDays,"^",2) //中心静脉置管使用日数
				//三管使用人数
				Set ICUAdmNum=##class(DHCHAI.IRS.ICULogSrv).GetICUAdmNum(LinkWardID,aDateFrom,aDateTo,xWtCat)
				Set:ICUAdmNum'="" PICCAdmNum=$p(ICUAdmNum,"^",2) //中心静脉置管使用人数
				Set APICCDays   =APICCDays+PICCDays
				Set APICCAdmNum =APICCAdmNum+PICCAdmNum
		 	}
			Set Data=$lb(ind,xLocID,LocDesc,xWtCat,WtCatDesc,InDays,PatNum,InfCase,APICCDays,APICCAdmNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrySDayInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfExecute ]
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
