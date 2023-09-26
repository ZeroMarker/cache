/// 名称: DHCHAI.STATV2.S245OpPosInfSum
/// 描述: 手术部位医院感染例数汇总表
/// 编写者：liuzhenhe
/// 编写日期: 2020-10-20
Class DHCHAI.STATV2.S245OpPosInfSum Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2020-10-20
/// Description:  手术部位医院感染例数汇总
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S245OpPosInfSum","QryOpPosInf","3","2022-02-01","2022-02-31","W","1","","AHW","")
Query QryOpPosInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,OperCaseCount0:%Integer,OperInfCount0:%Integer,OperInfRatio0:%String,SuperIncCount0:%Integer,DeepIncCount0:%Integer,OrganCount0:%Integer,OperCaseCount1:%Integer,OperInfCount1:%Integer,OperInfRatio1:%String,SuperIncCount1:%Integer,DeepIncCount1:%Integer,OrganCount1:%Integer,OperCaseCount2:%Integer,OperInfCount2:%Integer,OperInfRatio2:%String,SuperIncCount2:%Integer,DeepIncCount2:%Integer,OrganCount2:%Integer,OperCaseCount3:%Integer,OperInfCount3:%Integer,OperInfRatio3:%String,SuperIncCount3:%Integer,DeepIncCount3:%Integer,OrganCount3:%Integer,OperCaseCount4:%Integer,OperInfCount4:%Integer,OperInfRatio4:%String,SuperIncCount4:%Integer,DeepIncCount4:%Integer,OrganCount4:%Integer,sumOperCase:%Integer,sumOperInf:%Integer,sumOperInfRatio:%String,sumSuperInc:%Integer,sumDeepInc:%Integer,sumOrgan:%Integer") [ SqlProc ]
{
}

ClassMethod QryOpPosInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期处理
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK

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
	Set NIndex="QryOpPosInf"
	Kill ^TMP($zn,$j,NIndex)
	//循环手麻表
	Set SCode="OPS01",num=0
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""

				
				Set xOperID=""
				For {
		 			Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xOperID))
					Quit:xOperID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xOperID))
				 	Continue:AnaesData=""
				 	//过滤无效数据
				 	Set ORIsActive=$lg(AnaesData,31)
				 	Continue:ORIsActive'=1
					//过滤手术状态
			 		Set OperStatus = $lg(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态

					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))

				 	//过滤退院+非住院病人
				 	Set EpisodeDr   = $lg(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$lg(AdmData,19)="C"
					Set TAdmType=$lg(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 切口等级
					Set Incision 	= $lg(AnaesData,16)       
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Set:(MapIncDicDesc="")||(MapIncDicDesc="-") MapIncDicDesc="无手术切口"
					Set:MapIncDicDesc["无"||(MapIncDicDesc["0类") MapIncDicDesc="无"
					Set:MapIncDicDesc["Ⅰ" MapIncDicDesc="Ⅰ类"
					Set:MapIncDicDesc["Ⅱ" MapIncDicDesc="Ⅱ类"
					Set:MapIncDicDesc["Ⅲ" MapIncDicDesc="Ⅲ类"
					Set:MapIncDicDesc["III" MapIncDicDesc="Ⅲ类"
					Set:MapIncDicDesc["Ⅳ" MapIncDicDesc="Ⅳ类"

					// 患者手术时所在的科室病区
					Set OperDate    = $li(AnaesData,6)			//手术日期
					Set ORSttTime   = $li(AnaesData,7)			//手术时间
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
					
					// 手术类型
					Set OperType    = $li(AnaesData,5)  
					Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
					Set:PhraseMap'="" OperType = $p(PhraseMap,"^",3)
										
					//手术相关感染[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					if ('$d(^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr))){	//过滤重复患者
						Set ^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr)=""
						
						Set InfPosDescs=""
						Set InfPosInfo =..GetInfPosOperInfo(EpisodeDr,aDateFrom,aDateTo)
						If (InfPosInfo'="") {
							Set OPSIDs=$p(InfPosInfo,"#",2)			//感染关联手术ID
							Set TMPOPSIDs="^"_OPSIDs_"^"
							Set TMPxOperID="^"_xOperID_"^"
							If (TMPOPSIDs[TMPxOperID){
							For InfNo=1:1:$L(InfPosInfo,"|") {
								Set InfPosInfo=$p(InfPosInfo,"#",1)	//感染信息
							
								Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
								Continue:InfPosMsg=""
								
								//记录患者感染相关手术例次
								Set OPSID=$p(OPSIDs,"^",InfNo)
								Set PosDesc=$p(InfPosMsg,"^",2)
								Set ^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,OPSID,PosDesc)=""

								}
							}
						}
					}

					//统计维度
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,OperLocDr,OperWardDr)
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
						Set DimensKey=$p(StatDimensInfo,"^",indDimens)
						Continue:DimensKey=""
						// 手术例次数	
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"OperCaseCount")) 
						// 循环手术感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xOperID	//过滤非当前手术例次感染
							// 手术感染例次数
							//Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"OperCaseInfCount")) 
														// 手术感染例次数
							Set PosDesc=""
							For{
								Set PosDesc=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID,PosDesc))
								Quit:PosDesc=""
								Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"OperCaseInfCount")) 
								
								//表浅
								Set:PosDesc["表浅" num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"SuperIncCount"))
								//深部
								Set:PosDesc["深部" num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"DeepIncCount"))
								//器械
								Set:PosDesc["器官" num = $i(^TMP($zn,$j,NIndex,DimensKey,MapIncDicDesc,"OrganCount"))
							}
						}

					}
					If (LocCount>1) {
						// 循环手术感染
						// 手术例次数	
						Set num = $i(^TMP($zn,$j,NIndex,"Sum",MapIncDicDesc,"OperCaseCount")) 
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xOperID	//过滤非当前手术例次感染
							// 手术感染例次数
							Set num = $i(^TMP($zn,$j,NIndex,"Sum",MapIncDicDesc,"OperCaseInfCount")) 
							
							Set PosDesc=""
							For{
								Set PosDesc=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID,PosDesc))
								Quit:PosDesc=""
								//表浅
								Set:PosDesc["表浅" num = $i(^TMP($zn,$j,NIndex,"Sum",MapIncDicDesc,"SuperIncCount"))
								//深部
								Set:PosDesc["深部" num = $i(^TMP($zn,$j,NIndex,"Sum",MapIncDicDesc,"DeepIncCount"))
								//器械
								Set:PosDesc["器官" num = $i(^TMP($zn,$j,NIndex,"Sum",MapIncDicDesc,"OrganCount"))
							}
						}
					
					}	
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
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		
		Set (sumOperCase,sumOperInf,sumSuperInc,sumDeepInc,sumOrgan)=0
		Set (IncData0,IncData1,IncData2,IncData3,IncData4,sumData)=$lb(0,0,"0.00%",0,0,0)
		Set xIncDesc=""
		for {
			Set xIncDesc=$o(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc))
			Quit:xIncDesc=""
			Continue:"无Ⅰ类Ⅱ类Ⅲ类Ⅳ类"'[xIncDesc		//只统计无,I,Ⅱ,Ⅲ,Ⅳ类手术
			
			//手术例次数[不同切口]
			Set OperCaseCount	=+$g(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc,"OperCaseCount"))
			//手术感染例次数[不同切口]
			Set OperInfCount  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc,"OperCaseInfCount"))  
			//手术感染例次率[不同切口]
			Set OperInfRatio="0.00%"
			Set:OperCaseCount>0 OperInfRatio=$fn((OperInfCount/OperCaseCount)*100,"",2)_"%" 
			//手术感染例数(表浅切口)[不同切口]
			Set SuperIncCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc,"SuperIncCount")) 
			//手术感染例数(深部切口)[不同切口]
			Set DeepIncCount   =+$g(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc,"DeepIncCount"))
			//手术感染例数(器官腔隙)[不同切口]
			Set OrganCount     =+$g(^TMP($zn,$j,NIndex,xDimensKey,xIncDesc,"OrganCount"))
			//记录不同类别手术感染信息
			Set:xIncDesc="无" IncData0=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
			Set:xIncDesc="Ⅰ类" IncData1=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
			Set:xIncDesc="Ⅱ类" IncData2=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
			Set:xIncDesc="Ⅲ类" IncData3=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
			Set:xIncDesc="Ⅳ类" IncData4=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
			//记录手术信息(汇总)
			Set sumOperCase=sumOperCase+ OperCaseCount
			Set sumOperInf =sumOperInf + OperInfCount
			Set sumSuperInc=sumSuperInc+ SuperIncCount
			Set sumDeepInc =sumDeepInc + DeepIncCount
			Set sumOrgan   =sumOrgan + OrganCount
		}
		//手术感染例次率
		Set sumOperInfRatio="0.00%"
		Set:sumOperCase>0 sumOperInfRatio=$fn((sumOperInf/sumOperCase)*100,"",2)_"%"
		Continue:(IsActive="0")&&(sumOperCase=0)	
		Continue:(aQryCon="2")&&(sumOperInf=0)
		Continue:(aQryCon="3")&&(sumOperCase=0)
		
		//Update:2021-08-05 科室组+院区 区分科室/病区,解决明细数据不一致问题
		Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
		
		Set sumData=$lb(sumOperCase,sumOperInf,sumOperInfRatio,sumSuperInc,sumDeepInc,sumOrgan)
		Set Data=$lb(xDimensKey,DimensDesc)_IncData0_IncData1_IncData2_IncData3_IncData4_sumData
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1

	}
	If (LocCount>1) {
	Set (sumOperCase,sumOperInf,sumSuperInc,sumDeepInc,sumOrgan)=0
	Set (IncData0,IncData1,IncData2,IncData3,IncData4,sumData)=$lb(0,0,"0.00%",0,0,0)
	Set xIncDesc=""
	for {
		Set xIncDesc=$o(^TMP($zn,$j,NIndex,"Sum",xIncDesc))
		Quit:xIncDesc=""
		Continue:"无Ⅰ类Ⅱ类Ⅲ类Ⅳ类"'[xIncDesc		//只统计无,I,Ⅱ,Ⅲ,Ⅳ类手术
		
		//手术例次数[不同切口]
		Set OperCaseCount	=+$g(^TMP($zn,$j,NIndex,"Sum",xIncDesc,"OperCaseCount"))
		//手术感染例次数[不同切口]
		Set OperInfCount  	=+$g(^TMP($zn,$j,NIndex,"Sum",xIncDesc,"OperCaseInfCount"))  
		//手术感染例次率[不同切口]
		Set OperInfRatio="0.00%"
		Set:OperCaseCount>0 OperInfRatio=$fn((OperInfCount/OperCaseCount)*100,"",2)_"%" 
		//手术感染例数(表浅切口)[不同切口]
		Set SuperIncCount  =+$g(^TMP($zn,$j,NIndex,"Sum",xIncDesc,"SuperIncCount")) 
		//手术感染例数(深部切口)[不同切口]
		Set DeepIncCount   =+$g(^TMP($zn,$j,NIndex,"Sum",xIncDesc,"DeepIncCount"))
		//手术感染例数(器官腔隙)[不同切口]
		Set OrganCount     =+$g(^TMP($zn,$j,NIndex,"Sum",xIncDesc,"OrganCount"))
		//记录不同类别手术感染信息
		Set:xIncDesc="无" IncData0=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
		Set:xIncDesc="Ⅰ类" IncData1=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
		Set:xIncDesc="Ⅱ类" IncData2=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
		Set:xIncDesc="Ⅲ类" IncData3=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
		Set:xIncDesc="Ⅳ类" IncData4=$lb(OperCaseCount,OperInfCount,OperInfRatio,SuperIncCount,DeepIncCount,OrganCount)
		//记录手术信息(汇总)
		Set sumOperCase=sumOperCase+ OperCaseCount
		Set sumOperInf =sumOperInf + OperInfCount
		Set sumSuperInc=sumSuperInc+ SuperIncCount
		Set sumDeepInc =sumDeepInc + DeepIncCount
		Set sumOrgan   =sumOrgan + OrganCount
	}
	//手术感染例次率
	Set sumOperInfRatio="0.00%"
	Set:sumOperCase>0 sumOperInfRatio=$fn((sumOperInf/sumOperCase)*100,"",2)_"%"


	Set sumData=$lb(sumOperCase,sumOperInf,sumOperInfRatio,sumSuperInc,sumDeepInc,sumOrgan)
	Set Data=$lb("","全部")_IncData0_IncData1_IncData2_IncData3_IncData4_sumData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}
	Kill ^TMP($zn,$j,NIndex)
 	Quit $$$OK
}

ClassMethod QryOpPulInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpPulInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpPosInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpPosInfExecute ]
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
/// CreatDate：   2018-11-11
/// Description:  手术、感染、感染部位例次明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aInfPos:  感染部位
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S245OpPosInfSum","QryOpPosInfDtl","1","2021-01-01","2023-03-18","0001-00-0000-H-2-W","Ⅱ类","",0,"W","","")
Query QryOpPosInfDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aIncision As %String, aInfPos As %String, aOperFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType") [ SqlProc ]
{
}

ClassMethod QryOpPosInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aIncision As %String, aInfPos As %String, aOperFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
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
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
    //入参处理
    Set:aIncision="无" aIncision="无"
    Set:aIncision="1" aIncision="Ⅰ类"
 	Set:aIncision="2" aIncision="Ⅱ类"
 	Set:aIncision="3" aIncision="Ⅲ类"
    Set:aIncision="4" aIncision="Ⅳ类"
    Set:aIncision="" aIncision="无Ⅰ类Ⅱ类Ⅲ类Ⅳ类"
	Set:aInfPos[1 aInfPos="表浅手术切口感染"
	Set:aInfPos[2 aInfPos="深部手术切口感染"
	Set:aInfPos[3 aInfPos="器官和腔隙感染"
	//临时Gloabl
    Set NIndex="QryOpPosInfDtl"
	Kill ^TMP($zn,$j,NIndex)
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
				
				Set xOperID=""
				For {
		 			Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xOperID))
					Quit:xOperID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xOperID))
				 	Continue:AnaesData=""
				 	//过滤无效数据
				 	Set ORIsActive=$lg(AnaesData,31)
				 	Continue:ORIsActive'=1
					// 过滤手术状态
			 		Set OperStatus = $lg(AnaesData,34)         //状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
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
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
					
				 	//过滤退院+非住院病人
				 	Set xEpisodeID   = $lg(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xEpisodeID,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
					Continue:AdmData=""
					Continue:$lg(AdmData,19)="C"
					Set TAdmType=$lg(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术基本信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)      	// 手术时长
					Set OperDate  = $li(AnaesData,6)			// 手术日期
					Set ORSttTime = $li(AnaesData,7)			// 手术时间
					Set OperType    = $li(AnaesData,5)  		// 手术类型
					Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
					Set:PhraseMap'="" OperType = $p(PhraseMap,"^",3)
					// 切口等级
					Set Incision 	= $lg(AnaesData,16)       
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision) 
					 
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					
					Set:(MapIncDicDesc="")||(MapIncDicDesc="-")||(MapIncDicDesc["0") MapIncDicDesc="无"
					Set:MapIncDicDesc="III类" MapIncDicDesc="Ⅲ类"
				
					
					If (aIncision'=""){
						Continue:aIncision'[MapIncDicDesc
					}
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,OperDate,ORSttTime)
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
					Set TMPMapIncDicDesc=MapIncDicDesc
					Set:((MapIncDicDesc["0")||(MapIncDicDesc["无")) TMPMapIncDicDesc="无"
					Continue:((aIncision'="")&&(aIncision'[TMPMapIncDicDesc))
					//aOperFlag:0->感染,1->非院感
					
					
					//手术基本信息[患者]
					Set OPSData=..GetOPSDataByAnaesDr(xEpisodeID,xOperID)
					Continue:OPSData=""
					//患者基本信息
					Set PatData =..BuildPaadmData(xEpisodeID)
					
				    Continue:PatData=""
				    
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
	           	    Set AdmTimes = $lg(AdmData,38)   //就诊次数
	           	    Set PAAdmDate = $lg(AdmData,20)  //入院日期
					Set PAAdmTime= $lg(AdmData,21)  //入院时间
	           	  	Set TransInfo=..GetTransInfoByDateTime(xEpisodeID,OperDate,ORSttTime) //取转科信息
					Set TransDr=$p(TransInfo,"^",1)
					Set TransLocDr=$p(TransInfo,"^",2)
					Set TransLocDesc=$p(TransInfo,"^",3)
					Set TransDateTime=$p(TransInfo,"^",4)
					Set OutLocDateTime=$p(TransInfo,"^",5)
					Set TransDate=$p(TransDateTime," ",1)
					Set TransTime=$p(TransDateTime," ",2)
					Set OutLocDate=$p(OutLocDateTime," ",1)
					Set OutLocTime=$p(OutLocDateTime," ",2)
					
					//统计感染相关[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					if (aOperFlag="0"){	
						Set InfPosInfo =..GetInfPosOperInfo(xEpisodeID,aDateFrom,aDateTo)
						Set InfPosDescs=..GetOperPosInf(xEpisodeID,xOperID)
						Set OPSIDs=$p(InfPosInfo,"#",2)
						If (OPSIDs'=""){
							Set InfPosInfo=$p(InfPosInfo,"#",1)
							If (InfPosInfo'="") {
								For InfNo=1:1:$L(InfPosInfo,"|") {
									Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
									Continue:InfPosMsg=""
									Set PosDesc = $p(InfPosMsg,"^",2) //手术部位感染
									If (aInfPos'=""){
										Continue:aInfPos'[PosDesc
									}
									
									Set:($p(InfPosMsg,"^",3))'="" InfDate     = $zd($p(InfPosMsg,"^",3),3) //感染日期
									Set:($p(InfPosMsg,"^",4))'="" InfxDate    = $zd($p(InfPosMsg,"^",4),3) //感染转归日期
									Set InfDesc = $p(InfPosMsg,"^",5) //感染转归情况
									Set InfType = $p(InfPosMsg,"^",6) //感染类型
									//记录感染信息
									Set TMPOPSIDs="^"_OPSIDs_"^"
									Set TMPxOperID="^"_xOperID_"^"
									Continue:TMPOPSIDs'[TMPxOperID		//非关联报告手术
									
									Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}
						
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
	
BuildDtlData    
	Set OPSData=..GetOPSDataByAnaesDr(xEpisodeID,xOperID)
	Quit:OPSData=""

	Set PatData =..BuildPaadmData(xEpisodeID)
	Quit:PatData=""
	
	Set Data=PatData_OPSData_$lb(OperCatLists)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryOpPosInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpPosInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpPosInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpPosInfDtlExecute ]
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
