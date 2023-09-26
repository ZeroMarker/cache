/// 名称: DHCHAI.STATV2.OperDocRate
/// 描述: 外科医师专率统计表
/// 编写者: zhoubo
/// 编写日期: 2021-03-10
Class DHCHAI.STATV2.OperDocRate Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-06-15
/// Description:  外科医师专率统计表
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aCutType : 切口等级 
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.OperDocRate","QryOpDocRate","1","2022-01-01","2022-01-31","","")
Query QryOpDocRate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCutType As %String, aOperCat As %String = "") As %Query(ROWSPEC = "Opertor:%String,OperCaseCount:%Integer,OperInfCaseCount:%Integer,OperInfRatio:%String,NNISCase0Count:%Integer,NNISCaseInf0Count:%Integer,NNISInf0Ratio:%String,NNISCase1Count:%Integer,NNISCaseInf1Count:%Integer,NNISInf1Ratio:%String,NNISCase2Count:%Integer,NNISCaseInf2Count:%Integer,NNISInf2Ratio:%String,NNISCase3Count:%Integer,NNISCaseInf3Count:%Integer,NNISInf3Ratio:%String,AvgInfSum:%Integer,AdjInfRatio:%String") [ SqlProc ]
{
}

ClassMethod QryOpDocRateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCutType As %String, aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//临时global
 	Set NIndex="QryOpDocRate"
	Kill ^TMP($zn,$j,NIndex)
	//院区转换
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20220817 根据配置过滤手术状态

	//切口类型I汉字符号传入会有问题，改为ID值在后台取值
	// Add by zhaoyj 2022-06-15 Global方式
	Set:aCutType'="" aCutType=$lg($g(^DHCHAI.BT.DictionaryD(aCutType)),3)
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	//循环手麻表
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
				
				//手术科室
#;				Set OperLocData = $g(^DHCHAI.BT.LocationD(xOperLocDr))
#;				Continue:OperLocData=""
#;				Set HospDr=$li(OperLocData,8)
#;				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	//过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	//过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
					//Continue:"ADC"[OperStatus 
					//Continue:ExclStatus[OperStatus   //20220817 根据配置过滤手术状态
				 	
				 	//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
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
				 	//过滤退院+非住院病人
				 	Set EpisodeDr  = $li(AnaesData,2)
				 	
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					//过滤切口等级
				 	Set ORIncision = $li(AnaesData,16)
				 	Set tORIncision=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",ORIncision)
					Set:tORIncision'="" ORIncision=tORIncision
					
				 	Continue:(aCutType'="")&&(ORIncision'[aCutType) //因为有的后面带有“切口”，有的没有带
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperDate    = $li(AnaesData,6)			// 手术开始日期
					Set ORSttTime   = $li(AnaesData,7)			// 手术开始时间
					Set OREndDate   = $li(AnaesData,8)			// 手术结束日期
					Set OREndTime   = $li(AnaesData,9)			// 手术结束时间
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:((OperLocWard="")||(OperLocWard="^^^^^^"))
					
					Set OperLocDr  = $p(OperLocWard,"^",1) 	// 手术科室[患者]
					Set OperWardDr = $p(OperLocWard,"^",2) 	// 手术病区[患者]
					Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
					If (OperWardDr'=""){
						Set LocData = $g(^DHCHAI.BT.LocationD(OperWardDr))
					}
					Set HospDr=$li(LocData,8)				//手术院区[患者]
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)			//手术科室组[患者]
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//手术医生(ID|Code|Desc)
					Set OROpertor = $li(AnaesData,13)
					Set:OROpertor="||" OROpertor="未填医生"
					
					Set OROpertorCode=""
					If (OROpertor["|") {
						Set OROpertorCode=$p(OROpertor,"|",2)
						Set OROpertor=$p(OROpertor,"|",3)
					}
					Continue:OROpertor=""
					Set:OROpertorCode'="" OROpertor=OROpertor_"("_OROpertorCode_")"
					
					//NNIS计算--1:手术时长
					If OperHour=""{
						Set OperHour=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,ORSttTime,OREndDate,OREndTime)
					}
					//NNIS计算--2:手术切口
					Set Incision = $li(AnaesData,16)
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					//NNIS计算--3:ASA评分
					Set ASAScore = $li(AnaesData,20)
					Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
					If (ASAScoreInfo'="") {
						Set MapASADicCode = $p(ASAScoreInfo,"^",2)
						Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
					}Else {
						Set MapASADicCode = ""
						Set MapASADicDesc = ASAScore
					}
					// 接口抓取NNIS等级
					Set NNISGrade = $li(AnaesData,21)
					Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
					If (NNISGradeInfo'="") {
						Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
						Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
					}Else {
						Set MapNNISDicCode = ""
						Set MapNNISDicDesc = NNISGrade
					}
					// 如果接口获取NNIS为空则根据公式自动计算
					If (MapNNISDicDesc="") {
						Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1				//时长超过3小时
						Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1		//切口等级Ⅲ,Ⅳ
						Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1		//ASA评分超过2
					}
					Set MapNNISDicDesc=+MapNNISDicDesc
					Set ORNNISGrade = MapNNISDicDesc  
					//手术相关感染[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					Set DischDate=$li(AdmData,26)	//出院日期
					Set:DischDate="" DischDate=+$h
					
					Set InfPosDescs=""
					Set InfPosInfo =..GetInfPosOperInfo(EpisodeDr,aDateFrom,aDateTo)	// 手术日期到出院日期之间的感染
					If (InfPosInfo'="") {
						Set OPSIDs=$p(InfPosInfo,"#",2)			//感染关联手术ID
						Set TMPOPSIDs="^"_OPSIDs_"^"
						Set TMPxID="^"_xID_"^"
						if ((OPSIDs'="")&&(TMPOPSIDs[TMPxID)){
							For InfNo=1:1:$L(InfPosInfo,"|") {
								Set InfPosInfo=$p(InfPosInfo,"#",1)	//感染信息
							
								Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
								Continue:InfPosMsg=""
								//记录感染信息
								Set InfOperID =	$p(OPSIDs,"^",InfNo)
								//Continue:InfOperID=""
								Continue:InfOperID'=xID
								//记录患者感染相关手术例次
							
								Set num=$i(^TMP($zn,$j,NIndex,OROpertor,"OperInfCaseCount"))               
								Set num=$i(^TMP($zn,$j,NIndex,OROpertor,ORNNISGrade,"OperNNISInfCaseCount")) 
							}
						}
					}
					// 手术例次数
					Set num=$i(^TMP($zn,$j,NIndex,OROpertor,"OperCaseCount"))    
					// NNIS手术例次数             
					Set num=$i(^TMP($zn,$j,NIndex,OROpertor,ORNNISGrade,"OperNNISCaseCount")) 
					
				}
			}
		}
	}
	// 输出Data
	Set xOpertor = ""
	
	For {
		Set xOpertor = $o(^TMP($zn,$j,NIndex,xOpertor))
		Quit:xOpertor=""
		Continue:xOpertor=""
		Continue:xOpertor="HospInfPat"
		Set Opertor = xOpertor
		Set OperCaseCount     =+$g(^TMP($zn,$j,NIndex,xOpertor,"OperCaseCount"))            //手术例次数
		Set OperInfCaseCount  =+$g(^TMP($zn,$j,NIndex,xOpertor,"OperInfCaseCount"))         //手术部位感染例次数
		
		Set NNISCase0Count    =+$g(^TMP($zn,$j,NIndex,xOpertor,"0","OperNNISCaseCount"))    //0级手术例次数
		Set NNISCaseInf0Count =+$g(^TMP($zn,$j,NIndex,xOpertor,"0","OperNNISInfCaseCount")) //0级手术部位感染例次数
		
		Set NNISCase1Count    =+$g(^TMP($zn,$j,NIndex,xOpertor,"1","OperNNISCaseCount"))    //1级手术例次数
		Set NNISCaseInf1Count =+$g(^TMP($zn,$j,NIndex,xOpertor,"1","OperNNISInfCaseCount")) //1级手术部位感染例次数
		
		Set NNISCase2Count    =+$g(^TMP($zn,$j,NIndex,xOpertor,"2","OperNNISCaseCount"))    //2级手术例次数
		Set NNISCaseInf2Count =+$g(^TMP($zn,$j,NIndex,xOpertor,"2","OperNNISInfCaseCount")) //2级手术部位感染例次数
		
		Set NNISCase3Count    =+$g(^TMP($zn,$j,NIndex,xOpertor,"3","OperNNISCaseCount"))    //3级手术例次数
		Set NNISCaseInf3Count =+$g(^TMP($zn,$j,NIndex,xOpertor,"3","OperNNISInfCaseCount")) //3级手术部位感染例次数
		
		//平均危险指数： ∑(危险指数等级x手术例数）/手术例数总和
		Set AvgInfSum=0
		Set:OperCaseCount>0 AvgInfSum=((NNISCase1Count*1)+(NNISCase2Count*2)+(NNISCase3Count*3))/OperCaseCount
		Set:AvgInfSum'=0 AvgInfSum=$fn(AvgInfSum,"",2)
		//感染发病专率：手术部位感染例数/手术例数*100%
		Set OperInfRatio="0.00%"
		Set:OperCaseCount>0 OperInfRatio=$fn((OperInfCaseCount/OperCaseCount)*100,"",2)_"%"
		//调整感染发病专率：感染发病专率/平均危险指数*100%
		Set AdjInfRatio="-"
		If (AvgInfSum>0){
			Set:OperCaseCount>0 AdjInfRatio=$fn(((OperInfCaseCount/OperCaseCount)/AvgInfSum)*100,"",2)_"%"
		}
		// 0级手术感染发病专率
		Set NNISInf0Ratio="0.00%"
		Set:NNISCase0Count>0 NNISInf0Ratio=$fn((NNISCaseInf0Count/NNISCase0Count)*100,"",2)_"%" 
		// 1级手术感染发病专率
		Set NNISInf1Ratio="0.00%"
		Set:NNISCase1Count>0 NNISInf1Ratio=$fn((NNISCaseInf1Count/NNISCase1Count)*100,"",2)_"%"
		// 2级手术感染发病专率
		Set NNISInf2Ratio="0.00%"
		Set:NNISCase2Count>0 NNISInf2Ratio=$fn((NNISCaseInf2Count/NNISCase2Count)*100,"",2)_"%"
		// 3级手术感染发病专率
		Set NNISInf3Ratio="0.00%"
		Set:NNISCase3Count>0 NNISInf3Ratio=$fn((NNISCaseInf3Count/NNISCase3Count)*100,"",2)_"%"
		
		Set Data=$lb(Opertor,OperCaseCount,OperInfCaseCount,OperInfRatio,NNISCase0Count,NNISCaseInf0Count,NNISInf0Ratio,NNISCase1Count,NNISCaseInf1Count,NNISInf1Ratio,NNISCase2Count,NNISCaseInf2Count,NNISInf2Ratio,NNISCase3Count,NNISCaseInf3Count,NNISInf3Ratio,AvgInfSum,AdjInfRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOpDocRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpDocRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpDocRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpDocRateExecute ]
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
/// CreatDate：   2021-03-12
/// Description:  外科医师专率统计表,手术明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs : 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aCutType : 切口等级 
///               aNNIS    : NNIS分级
///               aIsInf   : 是否手术部位感染
///               aDoctor  : 医生
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.OperDocRate","QryOpDocRateDtl","1","2022-01-01","2022-01-31","","","1","","")
Query QryOpDocRateDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCutType As %String, aNNIS As %String, aIsInf As %String, aDoctor As %String, aOperCat As %String = "") As %Query(ROWSPEC = "EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,OperICD,OperType,OperDesc,NNISGrade,OROpertor,ORIncision,OperDate,OREndDate,ORHealing,ORASAScore,ORAnesMethod,InfPosDescs,OperCatLists:%String,MapNNISDicDesc,SttTime,EndTime") [ SqlProc ]
{
}

ClassMethod QryOpDocRateDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCutType As %String, aNNIS As %String, aIsInf As %String, aDoctor As %String, aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期处理
 	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20229817 根据配置过滤手术状态
	//临时Gloabl
	//切口类型I汉字符号传入会有问题，改为ID值在后台取值
	// Add by zhaoyj 2022-06-15 Global方式
	Set:aCutType'="" aCutType=$lg($g(^DHCHAI.BT.DictionaryD(aCutType)),3)
    Set NIndex="QryOpDocRateDtl"
	Kill ^TMP($zn,$j,NIndex)
	//循环手麻表
	Set SCode="OPS01"
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
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
				 	// 过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	// 过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
					//Continue:"ADC"[OperStatus 
					//Continue:ExclStatus[OperStatus   //20220817 根据配置过滤手术状态
				 					 	
				 	//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					Set OperCatList=""
					For indC=1:1:$L(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indC)
						Continue:OperCatDr=""
						
						Set CatData =$g(^CF.MA.HAI.IR.CRuleOperCatD(OperCatDr))
						Continue:CatData=""
						Set OperCat =$li(CatData, 2)
						If $listfind(OperCatList,OperCat)<1 {
							Set OperCatList=OperCatList_$lb(OperCat)
						}
					}	
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
				 	// 过滤手术切口
				 	Set ORIncision = $li(AnaesData,16)
				 	Set tORIncision=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",ORIncision)
					Set:tORIncision'="" ORIncision=tORIncision
				 	Continue:(aCutType'="")&&(ORIncision'[aCutType) //因为有的后面带有“切口”，有的没有带
				 	//过滤退院+非住院病人
				 	Set EpisodeDr  = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
	           	    Set AdmTimes = $lg(AdmData,38)   //就诊次数
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					Set OperDate=""
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperType    = $li(AnaesData,5)			// 手术类型（急诊、择期）
					Set OperDate    = $li(AnaesData,6)			// 手术开始日期
					Set ORSttTime   = $li(AnaesData,7)			// 手术开始时间
					Set OREndDate   = $li(AnaesData,8)			// 手术结束日期
					Set OREndTime   = $li(AnaesData,9)			// 手术结束时间
					Set SttTime=""
					Set EndTime=""
					Set:ORSttTime'="" SttTime = $zt(ORSttTime,1)
					Set:OREndTime'="" EndTime = $zt(OREndTime,1)
				
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:((OperLocWard="")||(OperLocWard="^^^^^^"))
					
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
					Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
					If (OperWardDr'=""){
						Set LocData = $g(^DHCHAI.BT.LocationD(OperWardDr))
					}
					Set HospDr=$li(LocData,8)				//手术院区
					Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)			//手术科室组
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					
					//手术医生(ID|Code|Desc)
					Set OROpertor = $li(AnaesData,13)
					Continue:OROpertor=""
					Set OROpertorCode=""
					If (OROpertor["|") {
						Set OROpertorCode=$p(OROpertor,"|",2)
						Set OROpertor=$p(OROpertor,"|",3)
					}
					//Continue:OROpertor=""
					Set:OROpertorCode'="" OROpertor=OROpertor_"("_OROpertorCode_")"
					Continue:(aDoctor'="")&&(aDoctor'=OROpertor)
					//NNIS计算--1:手术时长
					If OperHour=""{
						Set OperHour=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,ORSttTime,OREndDate,OREndTime)
					}
					
					//NNIS计算--2:手术切口
					Set Incision = $li(AnaesData,16)
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
						Set ORIncision    = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					//NNIS计算--3:ASA评分
					Set ASAScore = $li(AnaesData,20)
					Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
					If (ASAScoreInfo'="") {
						Set MapASADicCode = $p(ASAScoreInfo,"^",2)
						Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
					}Else {
						Set MapASADicCode = ""
						Set MapASADicDesc = ASAScore
					}
					// 接口抓取NNIS等级
					Set NNISGrade = $li(AnaesData,21)
					Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
					If (NNISGradeInfo'="") {
						Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
						Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
					}Else {
						Set MapNNISDicCode = ""
						Set MapNNISDicDesc = NNISGrade
					}
					// 如果接口获取NNIS为空则根据公式自动计算
					If (MapNNISDicDesc="") {
						Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1				//时长超过3小时
						Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1		//切口等级Ⅲ,Ⅳ
						Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
						Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1		//ASA评分超过2
					}
					Set MapNNISDicDesc=+MapNNISDicDesc
					// NNIS 分级
					
					Continue:(aNNIS'="")&&(aNNIS'=MapNNISDicDesc)
					Set:MapNNISDicDesc'["级" MapNNISDicDesc=MapNNISDicDesc_"级"
					//手术相关感染[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					Set DischDate=$li(AdmData,26)	//出院日期
					Set:DischDate="" DischDate=+$h


					//手术信息[**]
		
					Set:OREndDate'="" OREndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OREndDate)
					Set ORHealing = $li(AnaesData,17)
					Set ORASAScore = MapASADicDesc
					Set ORAnesMethod = $li(AnaesData,18)
					
					//患者转科基本信息

					Set PatData =..BuildPaadmData(EpisodeDr)
					Continue:PatData=""
					//患者基本信息
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
						

					Set:OperDate'="" OperDate=$zd(OperDate,3)
					Set InfPosInfo=""
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					if (aIsInf'=""){
							Set InfPosInfo =..GetInfPosOperInfo(EpisodeDr,aDateFrom,aDateTo)
							Set OPSIDs=$p(InfPosInfo,"#",2)
							If (OPSIDs'=""){
							Set InfPosInfo=$p(InfPosInfo,"#",1)
							If (InfPosInfo'="") {
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

									Continue:InfType'="医院感染"
						
									
									Set Data=PatData_$Lb(TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,OperICD,OperType,OperDesc,NNISGrade,OROpertor,ORIncision,OperDate,OREndDate,ORHealing,ORASAScore,ORAnesMethod,InfPosDescs,OperCatLists,MapNNISDicDesc,SttTime,EndTime)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
			
						}
				
					}else{
							
							Set Data=PatData_$Lb(TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,OperICD,OperType,OperDesc,NNISGrade,OROpertor,ORIncision,OperDate,OREndDate,ORHealing,ORASAScore,ORAnesMethod,InfPosDescs,OperCatLists,MapNNISDicDesc,SttTime,EndTime)
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

ClassMethod QryOpDocRateDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpDocRateDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpDocRateDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpDocRateDtlExecute ]
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

/// 取手术患者转科科室病区相关信息
/// w ##class(DHCHAI.STATV2.OperDocRate).GetOPTransLoc("W","89","66291","66474")
ClassMethod GetOPTransLoc(aStatType As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aStatType,aEpisodeDr,aDateFrom,aDateTo)
	Set return=""
	Quit:(aStatType="")||(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Kill arrAdmTrans
	Set xTransID=0
	For {
		Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xTransID))
		Quit:xTransID=""
		
		// Add by zhaoyj 2022-06-17 Global方式
		Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
		Continue:TransData=""
		Set TransType=$lg(TransData,4)
		Continue:(TransType'=aStatType)
		Continue:$lg(TransData,5)=""
		Set TransLocDr=$lg(TransData, 5)              //科室或病区
		Set LinkLocDr=""
		If ($lg(TransData,14)'=""){
			Set LinkLocDr=$lg(TransData,14)          //关联科室
		}
		Continue:(TransType="W")&(LinkLocDr="")
		Set TransDate=$lg(TransData,7)
		Continue:TransDate>aDateTo
		Set TransTime=$lg(TransData,8)
		Set TransTime=+TransTime
		Set:TransTime=0 TransTime=1
		Set OutLocDate=$lg(TransData,10)
		Set OutLocTime=$lg(TransData, 11)
		Continue:(OutLocDate'="")&&(OutLocDate<aDateFrom)
		//Continue:(OutLocDate'="")&&(OutLocDate=aDateFrom)
		//剔除当天入科
		//Continue:TransDate=aDateFrom
		
		Set arrAdmTrans(TransDate,TransTime)=$lb(xTransID,TransLocDr,LinkLocDr,TransDate,TransTime,OutLocDate,OutLocTime)
	}
	
	Set xTransDate=$o(arrAdmTrans(""))
	Set xTransTime=$o(arrAdmTrans(+xTransDate,""))
	Set TransInfo=$g(arrAdmTrans(+xTransDate,+xTransTime))
	Kill arrAdmTrans
	Set return=return_$lb(TransInfo)
	Quit return
}

}
