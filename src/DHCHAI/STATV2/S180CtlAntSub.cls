/// 名称: DHCHAI.STATV2.S180CtlAntSub
/// 描述: 住院患者限制/特殊使用级抗菌药物治疗前病原学送检率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S180CtlAntSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-21
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S180CtlAntSub","QryCtlAntSub","1","2020-04-01","2020-04-29")
Query QryCtlAntSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,KSS2CureCnt:%String,KSS3CureCnt:%String,BfKSS2CureSubCnt:%String,BfKSS3CureSubCnt:%String,BfKSS2CureSubRatio:%String,BfKSS3CureSubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryCtlAntSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
   	Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set NIndex="QryAntTheSub"
	Kill ^TMP($zn,$j,NIndex)
    
    //同期在科
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		Set TransIDs   = $LIST(TransInfo,6)
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
		//获取抗菌药物使用信息
		Set (IsKSS2CureUse,IsKSS3CureUse)=0,(IsBfKSS2CureSubmiss,IsBfKSS3CureSubmiss)=0
		Set IsAntUse=0,IsCureUse=0,IsBfCureSubmiss=0,FirstCureDate=99999
		For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)
			//如果转科起止日期大于统计日期，以统计日期计算
			Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
			Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""

			//获取抗菌药物使用信息
			Set IsAntUse=0
			Set FirstKSS2CureDate=99999,FirstKSS2CureTime=99999,FirstKSS3CureDate=99999,FirstKSS3CureTime=99999
			Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
			Set:AntUseArr.Count()>0 IsAntUse=1
			for AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose 	= $li(OrderInfo,11)
				Set KSS			= $li(OrderInfo,13)
				Set SttDate=$p($li(OrderInfo,7)," ",1)
				Set SttTime=$p($li(OrderInfo,7)," ",2)
				Set SttDate=##Class(DHCHAI.IO.FromHisSrv).GetDateHtmlToLogical(SttDate)
				Set SttTime=##Class(DHCHAI.IO.FromHisSrv).GetTimeHtmlToLogical(SttTime)	
				if (KSS="KSS2")&&(UsePurpose["治疗") {
					Set IsKSS2CureUse=1
					if ((FirstKSS2CureDate>SttDate)||((FirstKSS2CureDate=SttDate)&(FirstKSS2CureTime>SttTime))) {
						Set FirstKSS2CureDate=SttDate
						Set FirstKSS2CureTime=SttTime
					}
				}elseif (KSS="KSS3")&&(UsePurpose["治疗") {
					Set IsKSS3CureUse=1
					if ((FirstKSS3CureDate>SttDate)||((FirstKSS3CureDate=SttDate)&(FirstKSS3CureTime>SttTime))) {
						Set FirstKSS3CureDate=SttDate
						Set FirstKSS3CureTime=SttTime
					}
				}	
			}
			//获取微生物送检记录
			if (IsKSS2CureUse=1)||(IsKSS3CureUse=1) {
				Set LabInfoArr=..GetLabInfo(Paadm,DateFrom,DateTo)
				for LabInd=1:1:LabInfoArr.Count(){
					Set LabInfo=LabInfoArr.GetAt(LabInd)
					Set CollDate = $li(LabInfo,2)
					Set CollTime = $li(LabInfo,6)
					IF ((CollDate<FirstKSS2CureDate)||((CollDate=FirstKSS2CureDate)&(CollTime<FirstKSS2CureTime))) {
						Set:IsKSS2CureUse=1 IsBfKSS2CureSubmiss=1  //采集日期在治疗之前，算作治疗前送检
					}
					IF ((CollDate<FirstKSS3CureDate)||((CollDate=FirstKSS3CureDate)&(CollTime<FirstKSS3CureTime))) {
						Set:IsKSS3CureUse=1 IsBfKSS3CureSubmiss=1  //采集日期在治疗之前，算作治疗前送检
					}
				}
			}
		}
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//使用限制抗菌药物人数
			If (IsKSS2CureUse=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsKSS2CureUse",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsKSS2CureUse"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"IsKSS2CureUse",Paadm)=""
					}
			}
			//使用特殊使用抗菌药物
			If (IsKSS3CureUse=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsKSS3CureUse",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsKSS3CureUse"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"IsKSS3CureUse",Paadm)=""
					}
			}
			//限制抗菌药治疗前送检
			If (IsBfKSS2CureSubmiss=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS2CureSubmiss",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS2CureSubmiss"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS2CureSubmiss",Paadm)=""
					}
			}
			//特殊抗菌药治疗前送检
			If (IsBfKSS3CureSubmiss=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS3CureSubmiss",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS3CureSubmiss"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"IsBfKSS3CureSubmiss",Paadm)=""
					}
			}
		}
    }
	// 输出Data
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	= $lg(DimList,1)
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		Set PatAdmCnt  			=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  				//在院患者数
		Set KSS2CureCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsKSS2CureUse"))  		//限制级抗感染药使用人数
		Set KSS3CureCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsKSS3CureUse"))		//特殊级抗感染药治疗使用人数
		Set BfKSS2CureSubCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfKSS2CureSubmiss"))  //限制治疗前送检
		Set BfKSS3CureSubCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfKSS3CureSubmiss"))  //特殊治疗前送检
		Set (BfKSS3CureSubRatio,BfKSS2CureSubRatio)="0.00%"
		Set:KSS2CureCnt>0 BfKSS2CureSubRatio=$fn((BfKSS2CureSubCnt/KSS2CureCnt)*100,"",2)_"%" 			//限制治疗前送检率
		Set:KSS3CureCnt>0 BfKSS3CureSubRatio=$fn((BfKSS3CureSubCnt/KSS3CureCnt)*100,"",2)_"%" 			//特殊治疗前送检率
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(KSS2CureCnt=0)&&(KSS3CureCnt=0)
		
		//Update:2021-08-13 科室组+院区 区分科室/病区,解决明细数据不一致问题
		Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aLocType

		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,KSS2CureCnt,KSS3CureCnt,BfKSS2CureSubCnt,BfKSS3CureSubCnt,BfKSS2CureSubRatio,BfKSS3CureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCtlAntSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntSubExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-21
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前病原学送检率统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey：统计维度 
/// 			aIsKSS:KSS2限制使用级;KSS3特殊使用级
/// 			aAntiUse：是否使用病原学送检：
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S180CtlAntSub","QryCtlAntSubDtl","2020-02-01","2020-04-29","0000-00-0000-A-1","KSS3","是")
Query QryCtlAntSubDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aIsKSS As %String = "", aAntiUse As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntiKSS:%String,AntiCureSub:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,xVisitNumberDr:%String,CollDate:%String,Specimen:%String,SCode:%String,EpisodeNo:%String,CollTime:%String,TestSet:%String,CollDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryCtlAntSubDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aIsKSS As %String = "", aAntiUse As %String = "") As %Status
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
	Set aLocDr=""    //add 2020-05-18
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set StatType =$p(aDimensKey,"-",$l(aDimensKey,"-"))	
    
    //同期在科
   	Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		Set TransIDs   = $LIST(TransInfo,6)
		
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set LocDesc	= $li(LocData,3)
		Set HospDr	= $li(LocData,8)
		
	    //医院分组过滤
		Continue:HospDr=""
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5)
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)     
		//院区过滤
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set GroupDr  = $li(LocData,7)
		
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		If (aLocType'="")&(aLocType="E"){
			Continue:(aLocDr'="")&&(LocDr'=aLocDr)
		}
	
		If (aLocType'="")&(aLocType="W"){
			Continue:(aLocDr'="")&&(WardDr'=aLocDr)
		}
		
		//获取病人基本信息
		Set PatData =..BuildPaadmData(Paadm)
		Continue:PatData=""
		
		//组织输出转科明细以及限制、特殊抗菌药物情况
		For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)
			//如果转科起止日期大于统计日期，以统计日期计算
			Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
			//Set:OutLocDate>aDateTo DateTo = aDateTo,TimeTo=""
			Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
			//转换转科日期格式
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	        Set:TransTime'="" TransTime=$zt(TransTime)
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    	Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
			Set TransInfo=$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
			
			//获取抗菌药物使用信息
			Set AntUseInfo="",KSS2AntUseInfo="",KSS3AntUseInfo=""
			Set AntiKSS="",AntiCureSub="",(IsKSS2CureUse,IsKSS3CureUse)=0,(IsBfKSS2CureSubmiss,IsBfKSS3CureSubmiss)="",FirstKSS2CureDate=99999,FirstKSS3CureDate=99999
			Set (LabInfo,OrderInfo)=""
			Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
			for AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose 	= $li(OrderInfo,11)
				Set KSS			= $li(OrderInfo,13)
				Set SttDate=$p($li(OrderInfo,7)," ",1)
				Set SttTime=$p($li(OrderInfo,7)," ",2)
				Set SttDate=##Class(DHCHAI.IO.FromHisSrv).GetDateHtmlToLogical(SttDate)
				Set SttTime=##Class(DHCHAI.IO.FromHisSrv).GetTimeHtmlToLogical(SttTime)
				//保存转科期间抗菌用药信息
				if (AntUseInfo=""){
					Set AntUseInfo=OrderInfo
				}
				else{
					Set AntUseInfo=AntUseInfo_$lb("#")_OrderInfo
				}
			
				if (KSS="KSS2")&&(UsePurpose["治疗") {
					Set IsKSS2CureUse=1
					//保存转科期间KSS2使用信息
					if (KSS2AntUseInfo=""){
						Set KSS2AntUseInfo=OrderInfo
					}
					else{
						Set KSS2AntUseInfo=KSS2AntUseInfo_$lb("#")_OrderInfo
					}
					if ((FirstKSS2CureDate>SttDate)||((FirstKSS2CureDate=SttDate)&(FirstKSS2CureTime>SttTime))) {
						Set FirstKSS2CureDate=SttDate
						Set FirstKSS2CureTime=SttTime
					}
				}elseif (KSS="KSS3")&&(UsePurpose["治疗") {
					Set IsKSS3CureUse=1
					//保存转科期间KSS3使用信息
					if (KSS3AntUseInfo=""){
						Set KSS3AntUseInfo=OrderInfo
					}
					else{
						Set KSS3AntUseInfo=KSS3AntUseInfo_$lb("#")_OrderInfo
					}
					if ((FirstKSS3CureDate>SttDate)||((FirstKSS3CureDate=SttDate)&(FirstKSS3CureTime>SttTime))) {
						Set FirstKSS3CureDate=SttDate
						Set FirstKSS3CureTime=SttTime
					}
				}		
				//Set OrderInfo=$lb(OrdItemID,Generic,SttDateTime,EndDateTime,DrgPoison,UsePurpose,Instruc,OrdDocDesc)		
			}
			//获取微生物送检记录
			Set (CollDate,CollTime)=""
			if (IsKSS2CureUse=1)||(IsKSS3CureUse=1) {
				Set LabInfoArr=..GetLabInfo(Paadm,DateFrom,DateTo)
				for LabInd=1:1:LabInfoArr.Count(){
					Set LabInfo=LabInfoArr.GetAt(LabInd)
					Set CollDate = $li(LabInfo,2)
					Set:CollDate'="" $li(LabInfo,2) =$zd(CollDate,3)
					Set CollTime = $li(LabInfo,6)
					IF ((CollDate<FirstKSS2CureDate)||((CollDate=FirstKSS2CureDate)&(CollTime<FirstKSS2CureTime))) {
						Set:IsKSS2CureUse=1 IsBfKSS2CureSubmiss="是"  //采集日期在治疗之前，算作治疗前送检
					}
					IF ((CollDate<FirstKSS3CureDate)||((CollDate=FirstKSS3CureDate)&(CollTime<FirstKSS3CureTime))) {
						Set:IsKSS3CureUse=1 IsBfKSS3CureSubmiss="是"  //采集日期在治疗之前，算作治疗前送检
					}
					//Set LabInfo=$lb(xVisitNumberDr,CollDate,Specimen,SCode,EpisodeNo)	
				}
			}
			//Set:IsKSS2CureUse=1 AntiKSS="KSS2",AntiCureSub=IsBfKSS2CureSubmiss
			if (IsKSS2CureUse=1)&(IsKSS3CureUse=0){
				Set AntiKSS="KSS2"
				Set AntiCureSub=IsBfKSS2CureSubmiss
			}elseif((IsKSS2CureUse=0)&(IsKSS3CureUse=1)){
				Set AntiKSS="KSS3"
				Set AntiCureSub=IsBfKSS3CureSubmiss
			}elseif((IsKSS2CureUse=1)&(IsKSS3CureUse=1)){
				Set AntiKSS="KSS2^KSS3"
				Set AntiCureSub=IsBfKSS2CureSubmiss_"^"_IsBfKSS3CureSubmiss
				Set:AntiCureSub="^" AntiCureSub=""
			}
			//Set:IsKSS3CureUse=1 AntiKSS="KSS3",AntiCureSub=IsBfKSS3CureSubmiss
			
			//Continue:AntiKSS=""
			Continue:(aIsKSS'="")&&(AntiKSS'[aIsKSS)
			Continue:(aIsKSS="KSS2")&&(aAntiUse'="")&&(IsBfKSS2CureSubmiss'[aAntiUse)
			Continue:(aIsKSS="KSS3")&&(aAntiUse'="")&&(IsBfKSS3CureSubmiss'[aAntiUse)
			
			Set:CollDate'="" CollDate=$zd(CollDate,3)
			Set:CollTime'="" CollTime=$zt(CollTime,1)
			Set CollDateTime=CollDate_" "_CollTime
			
			if (aIsKSS="KSS2"){
				Set KSS2AntUseStr=$LTS(KSS2AntUseInfo,"^")
				for xKSS2Id=1:1:$l(KSS2AntUseStr,"#"){
					Set KSS2OrderInfo=$p(KSS2AntUseStr,"^#^",xKSS2Id)
					
					Set:KSS2OrderInfo'="" KSS2OrderInfo=$LFS(KSS2OrderInfo,"^") 
					Set:KSS2OrderInfo="" KSS2OrderInfo=$lb("","","","","","","","","","","","","")
					Set:LabInfo="" LabInfo=$lb("","","","","","","")
					Set Data = PatData_TransInfo_$lb(AntiKSS,AntiCureSub)_KSS2OrderInfo_LabInfo_$lb(CollDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			elseif(aIsKSS="KSS3"){
				Set KSS3AntUseStr=$LTS(KSS3AntUseInfo,"^")
				for xKSS3Id=1:1:$l(KSS3AntUseStr,"#"){
					Set KSS3OrderInfo=$p(KSS3AntUseStr,"^#^",xKSS3Id)
					
					Set:KSS3OrderInfo'="" KSS3OrderInfo=$LFS(KSS3OrderInfo,"^") 
					Set:KSS3OrderInfo="" KSS3OrderInfo=$lb("","","","","","","","","","","","","")
					Set:LabInfo="" LabInfo=$lb("","","","","","","")
					Set Data = PatData_TransInfo_$lb(AntiKSS,AntiCureSub)_KSS3OrderInfo_LabInfo_$lb(CollDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			else{
				Set AntUseStr=$LTS(AntUseInfo,"^")
				for xKSSId=1:1:$l(AntUseStr,"#"){
					Set KSSOrderInfo=$p(AntUseStr,"^#^",xKSSId)
					
					Set KSSOrderInfo=$LFS(KSSOrderInfo,"^") 
					Set:KSSOrderInfo="" KSSOrderInfo=$lb("","","","","","","","","","","","","")
					Set:LabInfo="" LabInfo=$lb("","","","","","","")
				
					Set Data = PatData_TransInfo_$lb(AntiKSS,AntiCureSub)_KSSOrderInfo_LabInfo_$lb(CollDateTime)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
    }
	Quit $$$OK
}

ClassMethod QryCtlAntSubDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntSubDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntSubDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntSubDtlExecute ]
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
