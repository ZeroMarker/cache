/// 名称: DHCHAI.STATV2.S220OpNNISInf
/// 描述: NNIS分级手术部位感染发病率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-13
Class DHCHAI.STATV2.S220OpNNISInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-13
/// Description:  NNIS分级手术部位感染发病率
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S220OpNNISInf","QryOpNNISInf","3","2022-02-01","2022-02-28","W","1","","AHW","485")
Query QryOpNNISInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,OperCase0Count:%Integer,OperCase1Count:%Integer,OperCase2Count:%Integer,OperCase3Count:%Integer,OperCase0InfCount:%Integer,OperCase1InfCount:%Integer,OperCase2InfCount:%Integer,OperCase3InfCount:%Integer,Oper0Ratio:%String,Oper1Ratio:%String,Oper2Ratio:%String,Oper3Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryOpNNISInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	Set NIndex="QryOpNNISInf"
	Kill ^TMP($zn,$j,NIndex)
	
 	Set:aStaType'="W" aStaType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数

	//循环手麻表
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态	Set SCode="OPS01"
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
				 	//过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	//过滤手术状态
			 		Set OperStatus = $li(AnaesData,34) 	// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
			
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))

				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperDate    = $li(AnaesData,6)			// 手术开始日期
					Set ORSttTime   = $li(AnaesData,7)			// 手术开始时间
					Set OREndDate   = $li(AnaesData,8)			// 手术结束日期
					Set OREndTime   = $li(AnaesData,9)			// 手术结束时间
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
					
					//手术相关感染[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					if ('$d(^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr))){	//过滤重复患者
						Set ^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr)=""
					
						Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
						Set InfPosDescs=""
						Set InfPosInfo =..GetInfPosOperInfo(EpisodeDr,aDateFrom,aDateTo)
						If (InfPosInfo'="") {
							Set OPSIDs=$p(InfPosInfo,"#",2)			//感染关联手术ID
							Set TMPOPSIDs="^"_OPSIDs_"^"
							Set TMPxID="^"_xID_"^"
							If (TMPOPSIDs[TMPxID){
								For InfNo=1:1:$L(InfPosInfo,"|") {
									Set InfPosInfo=$p(InfPosInfo,"#",1)	//感染信息
							
									Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
									Continue:InfPosMsg=""
									//记录患者感染相关手术例次
									Set OPSID=$p(OPSIDs,"^",InfNo)
									Set PosDesc=$p(InfPosMsg,"^",2)
									Set num = $i(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,OPSID))
									
									Set ^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,OPSID)=""
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
						
						Set:MapNNISDicDesc="0" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCase0Count")) // 0级手术例次数
						Set:MapNNISDicDesc="1" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCase1Count")) // 1级手术例次数
						Set:MapNNISDicDesc="2" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCase2Count")) // 2级手术例次数
						Set:MapNNISDicDesc="3" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCase3Count")) // 3级手术例次数
						
						// 循环手术感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							// 手术感染例次数
							Set:MapNNISDicDesc="0" ^TMP($zn,$j,NIndex,DimensKey,"OperCase0InfCount") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperCase0InfCount"))+InfSum // 0级手术部位感染例次数
							Set:MapNNISDicDesc="1" ^TMP($zn,$j,NIndex,DimensKey,"OperCase1InfCount") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperCase1InfCount"))+InfSum // 1级手术部位感染例次数
							Set:MapNNISDicDesc="2" ^TMP($zn,$j,NIndex,DimensKey,"OperCase2InfCount") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperCase2InfCount"))+InfSum  // 2级手术部位感染例次数
							Set:MapNNISDicDesc="3" ^TMP($zn,$j,NIndex,DimensKey,"OperCase3InfCount") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperCase3InfCount"))+InfSum  // 3级手术部位感染例次数
						}		

					}
					If (LocCount>1) {
						Set:MapNNISDicDesc="0" num = $i(^TMP($zn,$j,NIndex,"Sum","OperCase0Count")) // 0级手术例次数
						Set:MapNNISDicDesc="1" num = $i(^TMP($zn,$j,NIndex,"Sum","OperCase1Count")) // 1级手术例次数
						Set:MapNNISDicDesc="2" num = $i(^TMP($zn,$j,NIndex,"Sum","OperCase2Count")) // 2级手术例次数
						Set:MapNNISDicDesc="3" num = $i(^TMP($zn,$j,NIndex,"Sum","OperCase3Count")) // 3级手术例次数
						
						// 循环手术感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							// 手术感染例次数
							Set:MapNNISDicDesc="0" ^TMP($zn,$j,NIndex,"Sum","OperCase0InfCount") = $g(^TMP($zn,$j,NIndex,"Sum","OperCase0InfCount"))+InfSum // 0级手术部位感染例次数
							Set:MapNNISDicDesc="1" ^TMP($zn,$j,NIndex,"Sum","OperCase1InfCount") = $g(^TMP($zn,$j,NIndex,"Sum","OperCase1InfCount"))+InfSum // 1级手术部位感染例次数
							Set:MapNNISDicDesc="2" ^TMP($zn,$j,NIndex,"Sum","OperCase2InfCount") = $g(^TMP($zn,$j,NIndex,"Sum","OperCase2InfCount"))+InfSum  // 2级手术部位感染例次数
							Set:MapNNISDicDesc="3" ^TMP($zn,$j,NIndex,"Sum","OperCase3InfCount") = $g(^TMP($zn,$j,NIndex,"Sum","OperCase3InfCount"))+InfSum  // 3级手术部位感染例次数
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
		
		Set OperCase0Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase0Count"))  // 0级手术例次数
		Set OperCase1Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase1Count"))  // 1级手术例次数
		Set OperCase2Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase2Count"))  // 2级手术例次数
		Set OperCase3Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase3Count"))  // 3级手术例次数
		Set OperCount = OperCase0Count+OperCase1Count+OperCase2Count+OperCase3Count
		Set OperCase0InfCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase0InfCount"))  // 0级手术部位感染例次数
		Set OperCase1InfCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase1InfCount"))  // 1级手术部位感染例次数
		Set OperCase2InfCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase2InfCount"))  // 2级手术部位感染例次数
		Set OperCase3InfCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCase3InfCount"))  // 3级手术部位感染例次数
		

		
		Set Oper0Ratio="0.00%"
		Set:OperCase0Count>0 Oper0Ratio=$fn((OperCase0InfCount/OperCase0Count)*100,"",2)_"%"   //0级手术部位感染发病率
		Set Oper1Ratio="0.00%"
		Set:OperCase1Count>0 Oper1Ratio=$fn((OperCase1InfCount/OperCase1Count)*100,"",2)_"%"   //1级手术部位感染发病率
		Set Oper2Ratio="0.00%"
		Set:OperCase2Count>0 Oper2Ratio=$fn((OperCase2InfCount/OperCase2Count)*100,"",2)_"%"   //2级手术部位感染发病率
		Set Oper3Ratio="0.00%"
		Set:OperCase3Count>0 Oper3Ratio=$fn((OperCase3InfCount/OperCase3Count)*100,"",2)_"%"   //3级手术部位感染发病率
		
		Continue:(IsActive="0")&&(OperCount=0)	
		Continue:(aQryCon="2")&&(OperCase0InfCount=0)&&(OperCase1InfCount=0)&&(OperCase2InfCount=0)&&(OperCase3InfCount=0)
		Continue:(aQryCon="3")&&(OperCount=0)
			
		Set Data=$lb(xDimensKey,DimensDesc,OperCase0Count,OperCase1Count,OperCase2Count,OperCase3Count,OperCase0InfCount,OperCase1InfCount,OperCase2InfCount,OperCase3InfCount,Oper0Ratio,Oper1Ratio,Oper2Ratio,Oper3Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1

	}
	If (LocCount>1) {
		Set OperCase0Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase0Count"))  // 0级手术例次数
		Set OperCase1Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase1Count"))  // 1级手术例次数
		Set OperCase2Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase2Count"))  // 2级手术例次数
		Set OperCase3Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase3Count"))  // 3级手术例次数
		Set OperCount = OperCase0Count+OperCase1Count+OperCase2Count+OperCase3Count
		Set OperCase0InfCount  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase0InfCount"))  // 0级手术部位感染例次数
		Set OperCase1InfCount  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase1InfCount"))  // 1级手术部位感染例次数
		Set OperCase2InfCount  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase2InfCount"))  // 2级手术部位感染例次数
		Set OperCase3InfCount  =+$g(^TMP($zn,$j,NIndex,"Sum","OperCase3InfCount"))  // 3级手术部位感染例次数
		

		
		Set Oper0Ratio="0.00%"
		Set:OperCase0Count>0 Oper0Ratio=$fn((OperCase0InfCount/OperCase0Count)*100,"",2)_"%"   //0级手术部位感染发病率
		Set Oper1Ratio="0.00%"
		Set:OperCase1Count>0 Oper1Ratio=$fn((OperCase1InfCount/OperCase1Count)*100,"",2)_"%"   //1级手术部位感染发病率
		Set Oper2Ratio="0.00%"
		Set:OperCase2Count>0 Oper2Ratio=$fn((OperCase2InfCount/OperCase2Count)*100,"",2)_"%"   //2级手术部位感染发病率
		Set Oper3Ratio="0.00%"
		Set:OperCase3Count>0 Oper3Ratio=$fn((OperCase3InfCount/OperCase3Count)*100,"",2)_"%"   //3级手术部位感染发病率
		

		Set Data=$lb("","全部",OperCase0Count,OperCase1Count,OperCase2Count,OperCase3Count,OperCase0InfCount,OperCase1InfCount,OperCase2InfCount,OperCase3InfCount,Oper0Ratio,Oper1Ratio,Oper2Ratio,Oper3Ratio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOpNNISInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpNNISInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpNNISInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpNNISInfExecute ]
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
/// CreatDate：   2019-11-13
/// Description:  手术NNIS分级部位感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
///               aNNISDesc : NNIS分级
///               aINFFlag  : 是否感染 1:感染
/// Return：      返回ROWSPEC
/// aHospIDs=1%7C3%7C4&aDateFrom=2022-10-01&aDateTo=2022-12-31&aDimensKey=0000-00-0000-A-1&aNNISDesc=1&aINFFlag=&aStaType=W&aOperCat=&aLocIDs=&aPath=
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S220OpNNISInf","QryOpPosInfDtl","3","2022-02-01","2022-02-28","0003-06-0485-W-3","1","","W","","485")
Query QryOpPosInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aNNISDesc As %String, aINFFlag As %String = "", aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "MapNNISDicDesc:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType") [ SqlProc ]
{
}

ClassMethod QryOpPosInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aNNISDesc As %String, aINFFlag As %String = "", aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Status
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
	
    //临时Gloabl
    Set NIndex="QrySDayInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
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
		
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""

					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	//过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	// 过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
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
					Set OperHour    = $li(AnaesData,10)       // 手术时长
					Set OperDate    = $li(AnaesData,6)
					Set ORSttTime   = $li(AnaesData,7)
					Set OREndDate   = $li(AnaesData,8)
					Set EndTime   = $li(AnaesData,9)
					//NNIS计算--1:手术时长
					If OperHour=""{
						Set OperHour=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,ORSttTime,OREndDate,OREndTime)
					}
					//NNIS计算--2:手术切口等级
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
					Continue:(aNNISDesc'="")&&(aNNISDesc'=MapNNISDicDesc)
					Set:MapNNISDicDesc'["级" MapNNISDicDesc=MapNNISDicDesc_"级"
					
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
					Set InfPosInfo =..GetInfPosInfo(EpisodeDr,aDateFrom,aDateTo)
					
						//统计感染相关[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
						Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""	
						Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)
										
						if (aINFFlag'=""){
								
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
										
										Set Data=$lb(MapNNISDicDesc)_PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
										Set ^CacheTemp(repid,ind)=Data
										Set ind=ind+1
										}
									}
								
							}
					
						}Else{
								Set Data=$lb(MapNNISDicDesc)_PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
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
