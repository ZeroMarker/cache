/// 名称: DHCHAI.STATV2.S440SHCssOpInfo
/// 描述: 实时现患手术相关情况汇总表
/// 编写者：zhoubo
/// 编写日期: 2019-12-25
Class DHCHAI.STATV2.S440SHCssOpInfo Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-12-26
/// Description:  实时现患手术相关情况汇总表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aStaType ：科室/病区类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S440SHCssOpInfo","CssQryOpInfo","","2018-01-01","2019-11-21","W")
Query CssQryOpInfo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,SurPatAdm:%String,OperPatCnt:%String,Oper1Count:%String,Oper2Count:%String,Oper3Count:%String,Oper4Count:%String,Oper5Count:%String") [ SqlProc ]
{
}

ClassMethod CssQryOpInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="CssQryOpInfo"
	Kill ^TMP($zn,$j,NIndex)
    //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	
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
		}
		
		//获取手术信息
		Set OperFlag=""
		Set AntiDateFrom = $p(TransDates,",",1)
		Set AntiDateTo   = $p(TransDates,",",$l(TransDates,","))
		Set OperInfoArr =..GetOperInfo(Paadm,AntiDateFrom,AntiDateTo)
		Set:(OperInfoArr.Count()>0) OperFlag=1
		
		//计算手术例次数
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 调查人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm",Paadm)=""
			}
			//手术使用人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"OperPat",Paadm)) {
				//记录手术使用人数
				Set:OperFlag="1" num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperPat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"OperPat",Paadm)=""
				
				For indexx1=1:1:OperInfoArr.Count() {
					Set OperInfo=OperInfoArr.GetAt(indexx1)
					Continue:OperInfo=""
					
					Set IncDicDesc = $LIST(OperInfo,8)
					Set:IncDicDesc="Ⅰ类" num = $i(^TMP($zn,$j,NIndex,DimensKey,"Oper1Count"))
					Set:IncDicDesc="Ⅱ类" num = $i(^TMP($zn,$j,NIndex,DimensKey,"Oper2Count"))
					Set:IncDicDesc="Ⅲ类" num = $i(^TMP($zn,$j,NIndex,DimensKey,"Oper3Count"))
					Set:IncDicDesc="Ⅳ类" num = $i(^TMP($zn,$j,NIndex,DimensKey,"Oper4Count"))
					Set:IncDicDesc="无" num = $i(^TMP($zn,$j,NIndex,DimensKey,"Oper5Count"))
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
		Set SurPatAdm  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPatAdm"))  //调查人数
		Set OperPatCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPat"))    //手术使用人数
		
		Set Oper1Count =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Oper1Count"))
		Set Oper2Count =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Oper2Count"))
		Set Oper3Count =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Oper3Count"))
		Set Oper4Count =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Oper4Count"))
		Set Oper5Count =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Oper5Count"))
		
		Set Data=$lb(xDimensKey,DimensDesc,SurPatAdm,OperPatCnt,Oper1Count,Oper2Count,Oper3Count,Oper4Count,Oper5Count)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryOpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryOpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
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
/// CreatDate：   2019-12-26
/// Description:  实时现患手术使用情况病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDimensKey: 维度
///               aStaType : 1:统计手术患者信息
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S440SHCssOpInfo","CssQryOpInfoDtl","2018-01-01","2019-11-21","0001-01-0084-W-4","1")
Query CssQryOpInfoDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,GroupDesc:%String,LocDesc:%String,WardDesc:%String,TransDate:%String,OutLocDate:%String,OperID:%String,OperDesc:%String,OperHour:%String,OperDate:%String,ORSttTime:%String,OperLocDesc:%String,OperWardDesc:%String,MapIncDicDesc:%String") [ SqlProc ]
{
}

ClassMethod CssQryOpInfoDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	
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
		}
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&((LocDr'=aLocDr)&&(WardDr'=aLocDr))
		//获取手术信息
		Set TransDate = $p(TransDates,",",1)
		Set OutLocDate   = $p(TransDates,",",$l(TransDates,","))
		Set OperInfoArr =..GetOperInfo(Paadm,TransDate,OutLocDate)
		Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		Set PatData =..BuildPaadmData(Paadm)
		
	    Continue:PatData=""
		If (aStaType=1){   // 统计使用手术使用人数信息
			For indexx1=1:1:OperInfoArr.Count() {
				Set OperInfo=OperInfoArr.GetAt(indexx1)
				Continue:OperInfo=""
				Set Data = PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDate,OutLocDate)_OperInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}Else {
	    	Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDate,OutLocDate,"","","","","","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod CssQryOpInfoDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryOpInfoDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryOpInfoDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryOpInfoDtlExecute ]
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

/// add by zhoubo
/// 2019-12-26
/// 取病人给定时间段内手术记录
/// w ##class(DHCHAI.STATV2.S440SHCssOpInfo).GetOperInfo(3,"2017-07-13","2017-07-14")
ClassMethod GetOperInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "") As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	Set Count=0
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xID=""
		For {
 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aPaadm,xDate,xID))
			Quit:xID=""
			Set OperID=xID
			Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
		 	Continue:AnaesData=""
		 	Set ORIsActive=$li(AnaesData,31)
		 	Continue:ORIsActive'=1
			// 手术信息
			Set OperICD   = $li(AnaesData,3)         // 手术ICD
			Set OperDesc  = $li(AnaesData,4)         // 手术名称
			Set OperHour  = +$li(AnaesData,10)       // 手术时长
			Set OperDate  = $li(AnaesData,6)
			Set ORSttTime = $li(AnaesData,7)
			// 患者手术时所在的科室病区
			Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aPaadm,OperDate,ORSttTime)
			Continue:OperLocWard=""
			Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
			Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
			Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
			Set OperLocDesc  = $li(LocData,4)
			If (OperWardDr'=""){
				Set LocData = $g(^DHCHAI.BT.LocationD(OperWardDr))
			}
			Set OperWardDesc = $li(LocData,4)
			Set Incision = $li(AnaesData,16)        // 切口等级
			Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
			If (IncisionInfo'="") {
				Set MapIncDicDR   = $p(IncisionInfo,"^",1)
				Set MapIncDicCode = $p(IncisionInfo,"^",2)
				Set MapIncDicDesc = $p(IncisionInfo,"^",3)
			}Else {
				Set MapIncDicDR   = ""
				Set MapIncDicCode = ""
				Set MapIncDicDesc = Incision
			}
					
			Set OrdItemInfo=$lb(OperID,OperDesc,OperHour,OperDate,ORSttTime,OperLocDesc,OperWardDesc,MapIncDicDesc)
			Set Count=Count+1
			Do return.SetAt(OrdItemInfo,Count)
		}
	}
	Quit return
}

}
