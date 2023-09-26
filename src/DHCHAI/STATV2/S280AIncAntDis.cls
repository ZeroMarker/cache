/// 名称: DHCHAI.STATV2.S280AIncAntDis
/// 描述: Ⅰ类切口手术术后24小时内抗菌药物停药率统计
/// 编写者：zhoubo
/// 编写日期: 2019-11-18
Class DHCHAI.STATV2.S280AIncAntDis Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-18
/// Description:  Ⅰ类切口手术术后24小时内抗菌药物停药率统计
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S280AIncAntDis","QryAIncAntDis","1","2022-01-01","2022-01-31","W")
Query QryAIncAntDis(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,OperCaseCount:%Integer,OperAntiEndCount:%Integer,EndAntiRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAIncAntDisExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set NIndex="QryAIncAntDis"
	Kill ^TMP($zn,$j,NIndex)
	
	 //新增加维度
 	Set:aStaType'="W" aStaType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
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
					Set OREndDate = $li(AnaesData,8)
					Set OREndTime = $li(AnaesData,9)
					Continue:OREndDate=""
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
					// 判断Ⅰ类切口手术术后（结束时间~~~~结束时间后24H）是否预防性应用抗菌药物
				
					Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OREndDate,+OREndTime,AfterPeriOpr,1)
					Set Date1 = $p(ChangeDateInfo1," ",1)
					Set Time1 = $p(ChangeDateInfo1," ",2)
					Set UseAntiFlag=..CheckUesAnti(EpisodeDr,OREndDate,+OREndTime,Date1,Time1)
					Continue:UseAntiFlag'=1  // 术后未使用预防性抗菌药物
					
					// 判断Ⅰ类切口手术术后24小时内是否有抗菌药物停药,两种方式根据医院情况进行修改
					Set EndAntiFlag=0
					// 第一种：判断术后使用预防抗菌药物且24H内全部停药
					Set EndAntiFlag=..GetEndAntiFlag(EpisodeDr,OREndDate,+OREndTime,Date1,Time1)
					// 第二种：判断术后使用预防抗菌药物且24H后所在那天的后一天内未使用预防用药
					//Set EndAntiFlag=..GetEndAntiFlag2(EpisodeDr,OREndDate,+OREndTime)
					
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) 		// 手术科室[患者]
					Set OperWardDr = $p(OperLocWard,"^",2)	 	// 手术病区[患者]
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
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount")) // Ⅰ类切口手术术后预防性应用抗菌药物的例次数
						// 同期Ⅰ类切口手术术后预防性应用抗菌药物的手术例次中24小时内停药的手术例次数
						Set:EndAntiFlag=1 num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperAntiEndCount"))
						
					}
					If (LocCount>1) {
						Set num = $i(^TMP($zn,$j,NIndex,"Sum","OperCaseCount")) // Ⅰ类切口手术术后预防性应用抗菌药物的例次数
						// 同期Ⅰ类切口手术术后预防性应用抗菌药物的手术例次中24小时内停药的手术例次数
						Set:EndAntiFlag=1 num = $i(^TMP($zn,$j,NIndex,"Sum","OperAntiEndCount"))
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
		
		
		Set OperCaseCount    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseCount"))      //Ⅰ类切口手术术后预防性应用抗菌药物的例次数
		Set OperAntiEndCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperAntiEndCount"))   //同期Ⅰ类切口手术术后预防性应用抗菌药物的手术例次中24小时内停药的手术例次数
		
		Set EndAntiRatio="0.00%"
		Set:OperCaseCount>0 EndAntiRatio=$fn((OperAntiEndCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口手术术后24小时内停药率
		
		Continue:(IsActive="0")&&(OperCaseCount=0)	
		Continue:(aQryCon="2")&&(OperAntiEndCount=0)
		Continue:(aQryCon="3")&&(OperCaseCount=0)	
			
		Set Data=$lb(xDimensKey,DimensDesc,OperCaseCount,OperAntiEndCount,EndAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set OperCaseCount    =+$g(^TMP($zn,$j,NIndex,"Sum","OperCaseCount"))      //Ⅰ类切口手术术后预防性应用抗菌药物的例次数
		Set OperAntiEndCount =+$g(^TMP($zn,$j,NIndex,"Sum","OperAntiEndCount"))   //同期Ⅰ类切口手术术后预防性应用抗菌药物的手术例次中24小时内停药的手术例次数
		
		Set EndAntiRatio="0.00%"
		Set:OperCaseCount>0 EndAntiRatio=$fn((OperAntiEndCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口手术术后24小时内停药率
		

		Set Data=$lb("","全部",OperCaseCount,OperAntiEndCount,EndAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncAntDisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntDisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntDisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntDisExecute ]
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
/// Description:  Ⅰ类切口手术术后预防性应用抗菌药物患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
///               aStopAntiFlag : 1：停药标志
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S280AIncAntDis","QryAIncAntDisDtl","2020-01-01","2020-03-13","0000-00-0000-A-1",1)
Query QryAIncAntDisDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStopAntiFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "OperID,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OEItemDr:%String,OEOrdDesc:%String,OESttDateTime:%String,OEXDateTime:%String,OEAntPoison:%String,OEAntPurpose:%String,OEInstruc:%String,OEDoctor:%String,OperDateTime:%String,OREndDateTime:%String,UseOperPreFlag:%String,OperCatLists:%String,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,OperICD,OperType,OEOrdCode,OEGeneric,OEOrdDateTime,OEOrdLoc,OEPriority,DimensDesc,InfPosDescs,CarPrvTpDesc") [ SqlProc ]
{
}

ClassMethod QryAIncAntDisDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStopAntiFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
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
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
    Set NIndex="QryAIncAntDisDtl"
	Kill ^TMP($zn,$j,NIndex)


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
					Set OperDate    = $li(AnaesData,6)
					Set ORSttTime   = $li(AnaesData,7)
					Set OREndDate   = $li(AnaesData,8)
					Set OREndTime   = $li(AnaesData,9)
					Continue:OREndDate=""
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
					
					// 判断Ⅰ类切口手术术后（结束时间~~~~结束时间后24H）是否预防性应用抗菌药物
					Set ChangeDateInfo1 = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OREndDate,+OREndTime,AfterPeriOpr,1)
					Set Date1 = $p(ChangeDateInfo1," ",1)
					Set Time1 = $p(ChangeDateInfo1," ",2)
					Set AntiOEDrList =..GetAntiOEDrList(EpisodeDr,OREndDate,+OREndTime,Date1,Time1)
					Continue:AntiOEDrList=""  // 无预防使用抗菌药物
					//Set UseAntiFlag=..CheckUesAnti(EpisodeDr,OREndDate,+OREndTime,Date1,Time1)
					//Continue:UseAntiFlag'=1  // 术后未使用预防性抗菌药物
					
					// 判断Ⅰ类切口手术术后24小时内是否有抗菌药物停药,两种方式根据医院情况进行修改
					Set EndAntiFlag=0
					// 第一种：判断术后使用预防抗菌药物且24H内全部停药
					Set EndAntiFlag=..GetEndAntiFlag(EpisodeDr,OREndDate,+OREndTime,Date1,Time1)
					// 第二种：判断术后使用预防抗菌药物且24H后所在那天的后一天内未使用预防用药
					//Set EndAntiFlag=..GetEndAntiFlag2(EpisodeDr,OREndDate,+OREndTime)
					Continue:(aStopAntiFlag=1)&&(EndAntiFlag'=1)  // 24小时停药过滤
					
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
					
					Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)
					 // 预防使用抗菌药物信息
				    Continue:AntiOEDrList=""	//$l("",",")=1
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
						
						Set OEOrdCode    =$li(OEOrdItemData,3)         //医嘱代码
						Set OEGeneric    =$li(OEOrdItemData,19)		   //药品通用名
						Set OEOrdDate	 =$li(OEOrdItemData,10)      //开医嘱日期
						Set OEOrdTime	 =$li(OEOrdItemData,11)      //开医嘱时间
						Set:OEOrdDate'="" OEOrdDate=$zd(OEOrdDate,3)
						Set:OEOrdTime'="" OEOrdTime=$zt(OEOrdTime,1)
						Set OEOrdDateTime  = OEOrdDate_" "_OEOrdTime 
						Set OEOrdLocDr	 =$li(OEOrdItemData,13) 
						Set OEOrdLoc=""     
						Set OEPriority  =$li(OEOrdItemData,8) 
						Set OEOrdLoc =$p(OEOrdLocDr,"|",3)
						Set OrdDocDesc =$li(OEOrdItemData,14)  //ID|Code|Desc
						Set OEDocDr=""
						Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
						Set CarPrvTpId="",CarPrvTpDesc=""
						Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
						Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
						Set Data=PatData_OPSData
						Set OperID=xID
						Set Data=$lb(OperID)_PatData_OPSData_$lb(OEItemDr,OEOrdDesc,OESttDateTime,OEXDateTime,OEAntPoison,OEAntPurpose,OEInstruc,OEDoctor,OperDateTime,OREndDateTime,UseOperPreFlag,OperCatLists,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,OperICD,OperType,OEOrdCode,OEGeneric,OEOrdDateTime,OEOrdLoc,OEPriority,DimensDesc,InfPosDescs,CarPrvTpDesc)
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

ClassMethod QryAIncAntDisDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncAntDisDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncAntDisDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncAntDisDtlExecute ]
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
