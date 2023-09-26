/// 名称: DHCHAI.STATV2.ThirteenInd.S260AIncAntUse
/// 描述: Ⅰ类切口手术抗菌药物预防使用率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-14
Class DHCHAI.STATV2.ThirteenInd.S260AIncAntUse Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-14
/// Description:  Ⅰ类切口手术抗菌药物预防使用率统计表
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.S260AIncAntUse","QryAIncAntUse","","2018-01-01","2019-11-13","W")
Query QryAIncAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,OperPatAdm:%String,OperCaseCount:%String,OperPreAntiCount:%String,SuperAntiRatio:%String,OperCombCount1:%String,OperCombCount2:%String,OperCombCount3:%String,OperCombCount4:%String") [ SqlProc ]
{
}

ClassMethod QryAIncAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set IsLc = 0
 	Set xLocID =""
 	Set xLcDimensKey = ""
 	if (aQryCon="9999")&(aHospIDs'="")
 	{
	 	//如果是临床打开报表进行特殊处理,借用aHospIDs传入科室ID
	 	Set IsLc =1
	 	Set aQryCon =1
	 	Set xLocID = aHospIDs
	 	// Add by zhaoyj 2022-06-16 Global方式
	 	Set xLocData = $g(^DHCHAI.BT.LocationD(xLocID))
	 	Set BTTypeDr=$lg(xLocData,5)
	 	Set:BTTypeDr'="" aLocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	 	Set BTHospDr=$lg(xLocData,8)
	 	Set:BTHospDr'="" aHospIDs=BTHospDr
	 	Set xLcDimensKey=$e("0000"_xLocID,*-3,*)_"-"_aLocType        	//科室ID	 	
	}
 	Set NIndex="QryAIncAntUse"
	Kill ^TMP($zn,$j,NIndex)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	 //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set PeriOprPeriod = ##class(DHCHAI.BT.Config).GetValByCode("PeriOprPeriod")
	Set BeforePeriOpr = $p(PeriOprPeriod,"#",1)
	Set AfterPeriOpr  = $p(PeriOprPeriod,"#",2)

	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set OperLocData = $g(^DHCHAI.BT.LocationD(xOperLocDr))
				Continue:OperLocData=""
				If (OperLocData'=""){
					Set HospDr=$lg(OperLocData,8)
				}
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	Set ORIsActive=$lg(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	/// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
			 		Set OperStatus = $lg(AnaesData,34)         // 手术状态
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态

					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))

				 	Set EpisodeDr   = $lg(AnaesData,2)
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         // 手术ICD
					Set OperDesc    = $li(AnaesData,4)         // 手术名称
					Set OperHour    = +$li(AnaesData,10)       // 手术时长
					//Set OperLocDr   = $li(AnaesData,11)        // 手术科室ID
					//Continue:OperLocDr=""
					Set OperDate  = $li(AnaesData,6)
					Set ORSttTime = $li(AnaesData,7)
					Set Incision = $li(AnaesData,16)       // 切口等级
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Continue:MapIncDicDesc'["Ⅰ"
					// 判断是否使用抗菌药物
					// 围术期用药[术前36小时,术后24小时]
					Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,BeforePeriOpr,1)
					Set Date1 = $p(ChangeDateInfo1," ",1)
					Set Time1 = $p(ChangeDateInfo1," ",2)
					Set ChangeDateInfo2 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,AfterPeriOpr,1)
					Set Date2 = $p(ChangeDateInfo2," ",1)
					Set Time2 = $p(ChangeDateInfo2," ",2)
					Set UseAntiFlag=..CheckUesAnti(EpisodeDr,Date1,Time1,Date2,Time2)
					//判断预防用药联用等级
					Set CombCount=""
					Set:UseAntiFlag=1 CombCount=##class(DHCHAI.STATV2.S132AntComb).GetAntComb(EpisodeDr,aDateFrom,aDateTo)
					
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
					Set TransID    = $p(OperLocWard,"^",6) // 手术病区
					Continue:(TransID="")
					// 获取转科日期，感染诊断归属
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TransDate = $li(TranData,7)
					Set OutLocDate= $li(TranData,10)
					Set:TransDate<aDateFrom TransDate = aDateFrom
					Set:OutLocDate>aDateTo OutLocDate = aDateTo
					//当前未转出，截止为查询结束日期
					Set EndDate = OutLocDate
					Set:EndDate="" EndDate = aDateTo
					
					Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
					If (OperWardDr'=""){
						Set LocData = $g(^DHCHAI.BT.LocationD(OperWardDr))
					}
					Set HospDr=$li(LocData,8)
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,OperLocDr,OperWardDr)
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// Ⅰ类切口手术人数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",EpisodeDr)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperPatAdm")) 
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",EpisodeDr)=""
						}
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount")) // Ⅰ类切口手术例次数
						// Ⅰ类切口手术中预防性应用抗菌药物的例次数
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"OperPreAntiPatAdmCount",EpisodeDr)) {
							Set:UseAntiFlag=1 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperPreAntiCount"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"OperPreAntiPatAdmCount",EpisodeDr)=""
							}
						
						// 联合用药
						Set:CombCount=1 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCombCount1"))
						Set:CombCount=2 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCombCount2"))
						Set:CombCount=3 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCombCount3"))
						Set:CombCount>=4 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCombCount4"))
					}
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
		//限制临床科室查看内容
		Continue:(IsLc=1)&(xLcDimensKey'="")&(xDimensKey'[xLcDimensKey)
		Set OperPatAdm       =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseCount    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseCount"))      //Ⅰ类切口手术例次数
		Set OperPreAntiCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPreAntiCount"))   //Ⅰ类切口手术中预防性应用抗菌药物的例次数
		
		Set SuperAntiRatio="0.00%"
		Set:OperCaseCount>0 SuperAntiRatio=$fn((OperPreAntiCount/OperPatAdm)*100,"",2)_"%"   //Ⅰ类切口手术抗菌药物预防使用率
		
		//联用情况
		Set OperCombCount1=+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCombCount1"))
		Set OperCombCount2=+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCombCount2"))
		Set OperCombCount3=+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCombCount3"))
		Set OperCombCount4=+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCombCount4"))
		
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(OperPatAdm=0)
		Continue:(aQryCon=2)&&(OperPatAdm=0)	
			
		Set Data=$lb(xDimensKey,DimensDesc,OperPatAdm,OperCaseCount,OperPreAntiCount,SuperAntiRatio,OperCombCount1,OperCombCount2,OperCombCount3,OperCombCount4)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntUseExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-11-14
/// Description:  I类切口手术患者明细(分母)
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.S260AIncAntUse","QryAIncAntUseDtl","2018-07-12","2019-11-13","0001-01-0084-W-4")
Query QryAIncAntUseDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aOperCat As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperICD:%String,OperDesc:%String,OperHour:%String,OperLocDr:%String,OperLocDesc:%String,OperWardDr:%String,OperWardDesc:%String,MapIncDicDesc:%String,MapASADicDesc:%String,MapNNISDicDesc:%String,MapHealDicDesc:%String,InfPosDescs:%String,OperType:%String,OperDateTime:%String,OREndDateTime:%String,OperCatLists:%String") [ SqlProc ]
{
}

ClassMethod QryAIncAntUseDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	
    Set NIndex="QryAIncAntUseDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:aStaType'="" StatType=aStaType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	
	Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set OperLocData = $g(^DHCHAI.BT.LocationD(xOperLocDr))
				Continue:OperLocData=""
				If (OperLocData'=""){
					Set HospDr=$li(OperLocData,8)
				}
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	/// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
				 	
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					Set OperCatList=""
					For indC=1:1:$L(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indC)
						Continue:OperCatDr=""
						
						// Add by zhaoyj 2022-06-16 Global方式
						Set CatData =$g(^DHCHAI.IR.CRuleOperCatD(OperCatDr))
						Continue:CatData=""
						Set OperCat =$lg(CatData,2)
						If $listfind(OperCatList,OperCat)<1 {
							Set OperCatList=OperCatList_$lb(OperCat)
						}
					}	
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
					
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         // 手术ICD
					Set OperDesc    = $li(AnaesData,4)         // 手术名称
					Set OperHour    = +$li(AnaesData,10)       // 手术时长
					Set OperDate  = $li(AnaesData,6)
					Set ORSttTime = $li(AnaesData,7)
					Set Incision = $li(AnaesData,16)       // 切口等级
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Continue:MapIncDicDesc'["Ⅰ"
					
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
					Set TransID    = $p(OperLocWard,"^",6) // 手术病区
					Continue:(TransID="")
					
					// 获取转科日期，感染诊断归属
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TransDate = $li(TranData,7)
					Set OutLocDate= $li(TranData,10)
					Set:TransDate<aDateFrom TransDate = aDateFrom
					Set:OutLocDate>aDateTo OutLocDate = aDateTo
					//当前未转出，截止为查询结束日期
					Set EndDate = OutLocDate
					Set:EndDate="" EndDate = aDateTo
					
					if (StatType="E"){
						Set LocID = OperLocDr
					}else{
					
						Set LocID = OperWardDr
					}
					Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
					
					Set OperLocDesc  = $li(LocData,4)
					Set OperWardDesc = $li(LocData,4)
					Set HospDr=$li(LocData,8)
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
					Continue:(aLocDr'="")&&(LocID'=aLocDr)
					
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
					Set ASAScore = $li(AnaesData,20)   // ASA评分
					Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
					If (ASAScoreInfo'="") {
						Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
						Set MapASADicCode = $p(ASAScoreInfo,"^",2)
						Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
					}Else {
						Set MapASADicDR   = ""
						Set MapASADicCode = ""
						Set MapASADicDesc = ASAScore
					}
					Set NNISGrade   = $li(AnaesData,21)        // NNIS分级
					Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
					If (NNISGradeInfo'="") {
						Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
						Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
						Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
					}Else {
						Set MapNNISDicDR   = ""
						Set MapNNISDicCode = ""
						Set MapNNISDicDesc = NNISGrade
					}
					Set ORHealing = $li(AnaesData,17)        // 愈合情况
					Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
					If (HealingInfo'="") {
						Set MapHealDicDR   = $p(HealingInfo,"^",1)
						Set MapHealDicCode = $p(HealingInfo,"^",2)
						Set MapHealDicDesc = $p(HealingInfo,"^",3)
					}Else {
						Set MapHealDicDR   = ""
						Set MapHealDicCode = ""
						Set MapHealDicDesc = ORHealing
					}
					Set IsImplants = $li(AnaesData,27)    // 是否植入物
					Set OperType   = $li(AnaesData,5)     // 手术类型
					Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
					Set:PhraseMap'="" OperType = $p(PhraseMap,"^",3)
					Set OREndDate  = $li(AnaesData,8)
					Set OREndTime  = $li(AnaesData,9)
					Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
					Set:ORSttTime'="" ORSttTime = $zt(ORSttTime,1)
					Set OperDateTime=OperDate_" "_ORSttTime
					Set:OREndDate'="" OREndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OREndDate)
					Set:OREndTime'="" OREndTime = $zt(OREndTime,1)
					Set OREndDateTime=OREndDate_" "_OREndTime
					// 计算NNIS分级
					If (MapNNISDicDesc="") {
						Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1
					}
					Set MapNNISDicDesc=+MapNNISDicDesc
					
					Set PatData =..BuildPaadmData(EpisodeDr)
				    Continue:PatData=""
				    
					Set Data=PatData_$lb(OperICD,OperDesc,OperHour,OperLocDr,OperLocDesc,OperWardDr,OperWardDesc,MapIncDicDesc,MapASADicDesc,MapNNISDicDesc,MapHealDicDesc,InfPosDescs,OperType,OperDateTime,OREndDateTime,OperCatLists)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntUseDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-11-14
/// Description:  Ⅰ类切口手术中预防性应用抗菌药物的例次数(分子)
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.ThirteenInd.S260AIncAntUse","QryAPreAntUseDtl","2018-07-12","2019-11-13","0001-01-0084-W-4")
Query QryAPreAntUseDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aOperCat As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperICD:%String,OperDesc:%String,OperHour:%String,OperLocDr:%String,OperLocDesc:%String,OperWardDr:%String,OperWardDesc:%String,MapIncDicDesc:%String,MapASADicDesc:%String,MapNNISDicDesc:%String,MapHealDicDesc:%String,InfPosDescs:%String,OperType:%String,OperDateTime:%String,OREndDateTime:%String,OEItemDr:%String,OEOrdDesc:%String,OESttDateTime:%String,OEXDateTime:%String,OEAntPoison:%String,OEAntPurpose:%String,OEInstruc:%String,OEDoctor:%String,OperDateTime:%String,OREndDateTime:%String,OperCatLists:%String,OperID:%String") [ SqlProc ]
{
}

ClassMethod QryAPreAntUseDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	
    Set NIndex="QryAPreAntUseDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:aStaType'="" StatType=aStaType 
    Set:StatType'="W" StatType="E"  //不是病区就是科室

	Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set PeriOprPeriod = ##class(DHCHAI.BT.Config).GetValByCode("PeriOprPeriod")
	Set BeforePeriOpr = $p(PeriOprPeriod,"#",1)
	Set AfterPeriOpr  = $p(PeriOprPeriod,"#",2)
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set OperLocData = $g(^DHCHAI.BT.LocationD(xOperLocDr))
				Continue:OperLocData=""
				Set HospDr=$li(OperLocData,8)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	/// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
				 
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					Set OperCatList=""
					For indC=1:1:$L(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indC)
						Continue:OperCatDr=""
						
						// Add by zhaoyj 2022-06-16 Global方式
						Set CatData =$g(^DHCHAI.IR.CRuleOperCatD(OperCatDr))
						Continue:CatData=""
						Set OperCat =$lg(CatData,2)
						If $listfind(OperCatList,OperCat)<1 {
							Set OperCatList=OperCatList_$lb(OperCat)
						}
					}	
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
					
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         // 手术ICD
					Set OperDesc    = $li(AnaesData,4)         // 手术名称
					Set OperHour    = +$li(AnaesData,10)       // 手术时长
					Set OperDate  = $li(AnaesData,6)
					Set ORSttTime = $li(AnaesData,7)
					Set Incision = $li(AnaesData,16)       // 切口等级
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Continue:MapIncDicDesc'["Ⅰ"
					// 获取预防应用抗菌药物医嘱ID
					// 围术期用药[术前36小时,术后24小时]
					Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,BeforePeriOpr,1)
					Set Date1 = $p(ChangeDateInfo1," ",1)
					Set Time1 = $p(ChangeDateInfo1," ",2)
					Set ChangeDateInfo2 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OperDate,+ORSttTime,AfterPeriOpr,1)
					Set Date2 = $p(ChangeDateInfo2," ",1)
					Set Time2 = $p(ChangeDateInfo2," ",2)
					Set AntiOEDrList =..GetAntiOEDrList(EpisodeDr,Date1,Time1,Date2,Time2)
					Continue:AntiOEDrList=""  // 无预防使用抗菌药物
					
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
					Set TransID    = $p(OperLocWard,"^",6) // 手术病区
					Continue:(TransID="")
					
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set TransDate = $li(TranData,7)
					Set OutLocDate= $li(TranData,10)
					Set:TransDate<aDateFrom TransDate = aDateFrom
					Set:OutLocDate>aDateTo OutLocDate = aDateTo
					//当前未转出，截止为查询结束日期
					Set EndDate = OutLocDate
					Set:EndDate="" EndDate = aDateTo
					
					If (StatType="E"){
						Set LocID = OperLocDr
					}Else{
						Set LocID = OperWardDr
					}
					Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
					
					Set OperLocDesc  = $li(LocData,4)
					Set OperWardDesc = $li(LocData,4)
					Set HospDr=$li(LocData,8)
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
					Continue:(aLocDr'="")&&(LocID'=aLocDr)
					
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
					Set ASAScore = $li(AnaesData,20)   // ASA评分
					Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
					If (ASAScoreInfo'="") {
						Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
						Set MapASADicCode = $p(ASAScoreInfo,"^",2)
						Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
					}Else {
						Set MapASADicDR   = ""
						Set MapASADicCode = ""
						Set MapASADicDesc = ASAScore
					}
					Set NNISGrade   = $li(AnaesData,21)        // NNIS分级
					Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
					If (NNISGradeInfo'="") {
						Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
						Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
						Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
					}Else {
						Set MapNNISDicDR   = ""
						Set MapNNISDicCode = ""
						Set MapNNISDicDesc = NNISGrade
					}
					Set ORHealing = $li(AnaesData,17)        // 愈合情况
					Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
					If (HealingInfo'="") {
						Set MapHealDicDR   = $p(HealingInfo,"^",1)
						Set MapHealDicCode = $p(HealingInfo,"^",2)
						Set MapHealDicDesc = $p(HealingInfo,"^",3)
					}Else {
						Set MapHealDicDR   = ""
						Set MapHealDicCode = ""
						Set MapHealDicDesc = ORHealing
					}
					Set IsImplants = $li(AnaesData,27)    // 是否植入物
					Set OperType   = $li(AnaesData,5)     // 手术类型
					Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
					Set:PhraseMap'="" OperType = $p(PhraseMap,"^",3)
					Set OREndDate  = $li(AnaesData,8)
					Set OREndTime  = $li(AnaesData,9)
					Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
					Set:ORSttTime'="" ORSttTime = $zt(ORSttTime,1)
					Set OperDateTime=OperDate_" "_ORSttTime
					Set:OREndDate'="" OREndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OREndDate)
					Set:OREndTime'="" OREndTime = $zt(OREndTime,1)
					Set OREndDateTime=OREndDate_" "_OREndTime
					// 计算NNIS分级
					If (MapNNISDicDesc="") {
						Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1
					}
					Set MapNNISDicDesc=+MapNNISDicDesc
					
					Set PatData =..BuildPaadmData(EpisodeDr)
				    Continue:PatData=""
				    
				    // 预防使用抗菌药物信息
					For xList=1:1:$l(AntiOEDrList,","){
						Set OEItemDr =$p(AntiOEDrList,",",xList)
						Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OEItemDr))
						Set OEOrdDesc    = $li(OEOrdItemData,4)        // 医嘱名称
						Set OESttDate    = $li(OEOrdItemData,15)       // 医嘱开始日期
						Set OESttTime    = $li(OEOrdItemData,16)       // 医嘱开始时间
						Set:OESttDate'="" OESttDate=$zd(OESttDate,3)
						Set:OESttTime'="" OESttTime=$zt(OESttTime,1)
						Set OESttDateTime=OESttDate_" "_OESttTime
						Set OEXDate      = $li(OEOrdItemData,17)         // 医嘱结束日期
						Set OEXTime      = $li(OEOrdItemData,18)         // 医嘱结束时间
						Set:OEXDate'="" OEXDate=$zd(OEXDate,3)
						Set:OEXTime'="" OEXTime=$zt(OEXTime,1)
						Set OEXDateTime  = OEXDate_" "_OEXTime
						Set OEAntPoison  = $li(OEOrdItemData,29)        // 医嘱管制分类
						Set OEAntPurpose = $li(OEOrdItemData,30)        // 医嘱使用目的
						Set OEInstruc    = $li(OEOrdItemData,20)        // 医嘱给药途径
						Set OEDoctor     = $li(OEOrdItemData,14)        // 开医嘱医生
						Set:OEDoctor["|" OEDoctor=$p(OEDoctor,"|",3)
						
						Set Data=PatData_$lb(OperICD,OperDesc,OperHour,OperLocDr,OperLocDesc,OperWardDr,OperWardDesc,MapIncDicDesc,MapASADicDesc,MapNNISDicDesc,MapHealDicDesc,InfPosDescs,OperType,OperDateTime,OREndDateTime)
						Set Data=Data_$lb(OEItemDr,OEOrdDesc,OESttDateTime,OEXDateTime,OEAntPoison,OEAntPurpose,OEInstruc,OEDoctor,OperDateTime,OREndDateTime,OperCatLists,xID)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
	
					
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAPreAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAPreAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAPreAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAPreAntUseDtlExecute ]
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
