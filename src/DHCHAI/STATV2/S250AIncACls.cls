/// 名称: DHCHAI.STATV2.S250AIncACls
/// 描述: Ⅰ类切口手术甲级愈合率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-14
Class DHCHAI.STATV2.S250AIncACls Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-14
/// Description:  Ⅰ类切口手术甲级愈合率统计表
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S250AIncACls","QryAIncACls","3","2022-02-01","2022-02-28","W","1","","AHW","")
Query QryAIncACls(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,OperPatAdm:%Integer,OperCaseCount:%Integer,OperJCaseCount:%Integer,SuperIncRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAIncAClsExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set NIndex="QryAIncACls"
	Kill ^TMP($zn,$j,NIndex)
	
	//院区转换
 	Set:aStaType'="W" aStaType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数

	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
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
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
					
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					//Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					Continue:(aOperCat'="")&&((","_aOperCat_",")'[(","_OperCatDrs_","))
					
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
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
					Set ORHealing = $li(AnaesData,17)        // 愈合情况
					
					Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
					If (HealingInfo'="") {
						Set MapHealDicCode = $p(HealingInfo,"^",2)
						Set MapHealDicDesc = $p(HealingInfo,"^",3)
					}Else {
						Set MapHealDicCode = ""
						Set MapHealDicDesc = ORHealing
					}
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室[患者]
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区[患者]
					
					If (aStaType="E"){
						Set LocDr = OperLocDr
					}Else{
						Set LocDr = OperWardDr
					}
					Continue:LocDr=""
					Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
					
					Set OperLocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Continue:OperLocData=""
					Set HospDr = $li(OperLocData,8)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
					Set GroupDr = $li(OperLocData,7)			//手术科室组[患者]
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
						
						Set:MapHealDicDesc="甲" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperJCaseCount")) // Ⅰ类切口甲级愈合手术例次数
						

					}
					If (LocCount>1) {
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",EpisodeDr)) {
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","OperPatAdm")) 
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",EpisodeDr)=""
						}
						Set num = $i(^TMP($zn,$j,NIndex,"Sum","OperCaseCount")) // Ⅰ类切口手术例次数
						Set:MapHealDicDesc="甲" num = $i(^TMP($zn,$j,NIndex,"Sum","OperJCaseCount")) // Ⅰ类切口甲级愈合手术例次数
						
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
		Set xDimensKey	= $lg(DimList,1)
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		
		Set OperPatAdm     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseCount"))      //Ⅰ类切口手术例次数
		Set OperJCaseCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperJCaseCount"))     //Ⅰ类切口甲级愈合例次数
		
		Set SuperIncRatio="0.00%"
		Set:OperCaseCount>0 SuperIncRatio=$fn((OperJCaseCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口甲级愈合率
		
		Continue:(IsActive="0")&&(OperCaseCount=0)	
		Continue:(aQryCon="2")&&(OperJCaseCount=0)
		Continue:(aQryCon="3")&&(OperCaseCount=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,OperPatAdm,OperCaseCount,OperJCaseCount,SuperIncRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set OperPatAdm     =+$g(^TMP($zn,$j,NIndex,"Sum","OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseCount  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCaseCount"))      //Ⅰ类切口手术例次数
		Set OperJCaseCount =+$g(^TMP($zn,$j,NIndex,"Sum","OperJCaseCount"))     //Ⅰ类切口甲级愈合例次数
		
		Set SuperIncRatio="0.00%"
		Set:OperCaseCount>0 SuperIncRatio=$fn((OperJCaseCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口甲级愈合率
		
		
		Set Data=$lb("","全部",OperPatAdm,OperCaseCount,OperJCaseCount,SuperIncRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncAClsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAClsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAClsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAClsExecute ]
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
/// Description:  I类切口手术甲级愈合感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aHealFlag: 1:查询甲级愈合患者明细
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S250AIncACls","QryAIncAClsDtl","3","2022-02-01","2022-02-28","0003-00-0000-H-2","1","W","","")
Query QryAIncAClsDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aHealFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType") [ SqlProc ]
{
}

ClassMethod QryAIncAClsDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aHealFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	//Set ^temphp22("QryAIncAClsDtl")=$lb(aHospIDs, aDateFrom, aDateTo, aDimensKey, aHealFlag, aStaType, aOperCat, aLocIDs)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	//维度处理
	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType="" aStaType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	//临时Gloabl
    Set NIndex="QrySDayInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
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
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态

					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					//Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					
					Continue:(aOperCat'="")&&((","_aOperCat_",")'[(","_OperCatDrs_","))
					Set OperCatList=""
					
					For indC=1:1:$L(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indC)
						
						Continue:OperCatDr=""
						
						// Add by zhaoyj 2022-06-16 Global方式
						Set CatData =$g(^CF.MA.HAI.IR.CRuleOperCatD(OperCatDr))
						Continue:CatData=""
						Set OperCat =$lg(CatData,2)
						If $listfind(OperCatList,OperCat)<1 {
							Set OperCatList=OperCatList_$lb(OperCat)
						}
					}	
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
					
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
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
					
					Continue:(aHealFlag="1")&&(MapHealDicDesc'="甲")
					
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) 	// 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) 	// 手术病区
					If (aStaType="E"){
						Set LocID = OperLocDr
					}Else{
					
						Set LocID = OperWardDr
					}
					Continue:LocID=""
					Continue:(aLocDr'="")&(aLocDr'=LocID)
					Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
			        
					Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)				//手术院区
					
					Continue:HospDr=""
					Set HospInfo="",HospGroupDr="",HospGrpInfo=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5)
					Continue:HospGroupDr="" 
					Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
					Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
					//院区过滤
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					
					Set GroupDr  = $lg(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}	
					Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
					Set GroupDesc=$lg(GroupData,3)
					//按科室组、科室/病区过滤
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
					//取统计维度
					Set DimensDesc =""
					Set:DimensMark="" DimensDesc="全部"
					Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
					Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
					Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
					Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
					//手术基本信息[患者]
					Set OPSData=..GetOPSDataByAnaesDr(EpisodeDr,xID)
					Continue:OPSData=""
					//患者基本信息
					Set PatData =..BuildPaadmData(EpisodeDr)
				    Continue:PatData=""
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
	           	    Set AdmTimes = $lg(AdmData,38)   //就诊次数
	           	    Set PAAdmDate = $lg(AdmData,20)  //入院日期
					Set PAAdmTime= $lg(AdmData,21)  //入院时间
					
	           	   	Set TransInfo=..GetTransInfoByDateTime(EpisodeDr,OperDate,ORSttTime) //取转科信息
					Set TransDr=$p(TransInfo,"^",1)
					Set TransLocDr=$p(TransInfo,"^",2)
					Set TransLocDesc=$p(TransInfo,"^",3)
					Set TransDateTime=$p(TransInfo,"^",4)
					Set OutLocDateTime=$p(TransInfo,"^",5)
					Set TransDate=$p(TransDateTime," ",1)
					Set TransTime=$p(TransDateTime," ",2)
					Set OutLocDate=$p(OutLocDateTime," ",1)
					Set OutLocTime=$p(OutLocDateTime," ",2)
					
					Set InfPosInfo=""
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					
					Set InfPosInfo =..GetInfPosOperInfo(EpisodeDr,aDateFrom,aDateTo)
					Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)	
					Set OPSIDs=$p(InfPosInfo,"#",2)
					If (aHealFlag=1){
						If (OPSIDs'=""){
						Set InfPosInfo=$p(InfPosInfo,"#",1)
						If ((InfPosInfo'="")){
							For InfNo=1:1:$L(InfPosInfo,"|") {
									Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
									Continue:InfPosMsg=""
									Set PosDesc = $p(InfPosMsg,"^",2) //手术部位感染
									Set:($p(InfPosMsg,"^",3))'="" InfDate     = $zd($p(InfPosMsg,"^",3),3) //感染日期
									Set:($p(InfPosMsg,"^",4))'="" InfxDate    = $zd($p(InfPosMsg,"^",4),3) //感染转归日期
									Set InfDesc = $p(InfPosMsg,"^",5) //感染转归情况
									Set InfType = $p(InfPosMsg,"^",6) //感染类型
									//记录感染信息
									Set TMPOPSIDs="^"_OPSIDs_"^"
									Set TMPxID="^"_xID_"^"
									Continue:TMPOPSIDs'[TMPxID		//非关联报告手术
									
									Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						
						}Else{
							
							  Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
							  Set ^CacheTemp(repid,ind)=Data
							  Set ind=ind+1
						}
					}Else{
							  Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
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

ClassMethod QryAIncAClsDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAClsDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAClsDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAClsDtlExecute ]
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
