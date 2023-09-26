/// 名称: DHCHAI.STATV2.S230OpRiskCut
/// 描述: 不同感染风险指数（手术切口）手术部位感染发病率统计表
/// 编写者：zhoubo
/// 编写日期: 2018-07-06
Class DHCHAI.STATV2.S230OpRiskCut Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-13
/// Description:  不同感染风险指数（手术切口）手术部位感染发病率
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S230OpRiskCut","QryOpRiskCut","3","2022-09-15","2022-09-17","W","1","","AHW","475")
Query QryOpRiskCut(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,OperInc0Count:%Integer,OperInc1Count:%Integer,OperInc2Count:%Integer,OperInc3Count:%Integer,OperInc4Count:%Integer,OperIncInf0Count:%Integer,OperIncInf1Count:%String,OperIncInf2Count:%Integer,OperIncInf3Count:%Integer,OperIncInf4Count:%Integer,OperInc0Ratio:%String,OperInc1Ratio:%String,OperInc2Ratio:%String,OperInc3Ratio:%String,OperInc4Ratio:%String,OperCount:%String,OperIncInfCount:%String") [ SqlProc ]
{
}

ClassMethod QryOpRiskCutExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	Set NIndex="QryOpRiskCut"
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
				 	//过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         // 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
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
					// 切口等级
					Set Incision = $li(AnaesData,16)       
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Set:(MapIncDicDesc="")||(MapIncDicDesc="-") MapIncDicDesc="无手术切口"
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
					
					//手术相关感染[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					if ('$d(^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr))){	//过滤重复患者
						Set ^TMP($zn,$j,NIndex,"HospInfPat",EpisodeDr)=""
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
									//记录患者感染相关手术例次
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
						Set:(MapIncDicDesc["无")||(MapIncDicDesc["0类")||(MapIncDicDesc["-") num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc0Count")) 
						Set:MapIncDicDesc["Ⅰ" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc1Count"))
						Set:MapIncDicDesc["Ⅱ" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc2Count"))
						Set:MapIncDicDesc["Ⅲ" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc3Count"))
						Set:MapIncDicDesc["III" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc3Count"))
						Set:MapIncDicDesc["Ⅳ" num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperInc4Count"))
			            						// 循环手术感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							
							// 手术感染例次数
							Set:(MapIncDicDesc["无")||(MapIncDicDesc["0类")||(MapIncDicDesc["-") ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf0Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf0Count"))+InfSum // 0级手术部位感染例次数 
							Set:MapIncDicDesc["Ⅰ" ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf1Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf1Count"))+InfSum // 1级手术部位感染例次数
							Set:MapIncDicDesc["Ⅱ" ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf2Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf2Count"))+InfSum  // 2级手术部位感染例次数
							Set:MapIncDicDesc["Ⅲ" ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf3Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf3Count"))+InfSum  // 3级手术部位感染例次数
							Set:MapIncDicDesc["III" ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf3Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf3Count"))+InfSum  // 3级手术部位感染例次数
							Set:MapIncDicDesc["Ⅳ" ^TMP($zn,$j,NIndex,DimensKey,"OperIncInf4Count") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperIncInf4Count"))+InfSum  // 3级手术部位感染例次数
	
						}

					}
					If (LocCount>1) {
						Set:(MapIncDicDesc["无")||(MapIncDicDesc["0类")||(MapIncDicDesc["-") num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc0Count")) 
						Set:MapIncDicDesc["Ⅰ" num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc1Count"))
						Set:MapIncDicDesc["Ⅱ" num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc2Count"))
						Set:MapIncDicDesc["Ⅲ" num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc3Count"))
						Set:MapIncDicDesc["III" num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc3Count"))
						Set:MapIncDicDesc["Ⅳ" num = $i(^TMP($zn,$j,NIndex,"Sum","OperInc4Count"))
			            						// 循环手术感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							// 手术感染例次数
							Set:(MapIncDicDesc["无")||(MapIncDicDesc["0类")||(MapIncDicDesc["-") ^TMP($zn,$j,NIndex,"Sum","OperIncInf0Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf0Count"))+InfSum // 0级手术部位感染例次数 
							Set:MapIncDicDesc["Ⅰ" ^TMP($zn,$j,NIndex,"Sum","OperIncInf1Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf1Count"))+InfSum // 1级手术部位感染例次数
							Set:MapIncDicDesc["Ⅱ" ^TMP($zn,$j,NIndex,"Sum","OperIncInf2Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf2Count"))+InfSum  // 2级手术部位感染例次数
							Set:MapIncDicDesc["Ⅲ" ^TMP($zn,$j,NIndex,"Sum","OperIncInf3Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf3Count"))+InfSum  // 3级手术部位感染例次数
							Set:MapIncDicDesc["III" ^TMP($zn,$j,NIndex,"Sum","OperIncInf3Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf3Count"))+InfSum  // 3级手术部位感染例次数
							Set:MapIncDicDesc["Ⅳ" ^TMP($zn,$j,NIndex,"Sum","OperIncInf4Count") = $g(^TMP($zn,$j,NIndex,"Sum","OperIncInf4Count"))+InfSum  // 3级手术部位感染例次数
	
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
		
		Set (OperCount,OperIncInfCount)=0
		Set OperInc0Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInc0Count"))
		Set OperInc1Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInc1Count"))
		Set OperInc2Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInc2Count"))
		Set OperInc3Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInc3Count"))
		Set OperInc4Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperInc4Count"))
		
		Set OperCount = OperInc0Count+OperInc1Count+OperInc2Count+OperInc3Count+OperInc4Count
		
		Set OperIncInf0Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperIncInf0Count"))
		Set OperIncInf1Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperIncInf1Count"))
		Set OperIncInf2Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperIncInf2Count"))
		Set OperIncInf3Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperIncInf3Count"))
		Set OperIncInf4Count  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperIncInf4Count"))
		Set OperIncInfCount = OperIncInf0Count+OperIncInf1Count+OperIncInf2Count+OperIncInf3Count+OperIncInf4Count
		
		Set OperInc0Ratio="0.00%"
		Set:OperInc0Count>0 OperInc0Ratio=$fn((OperIncInf0Count/OperInc0Count)*100,"",2)_"%"
		Set OperInc1Ratio="0.00%"
		Set:OperInc1Count>0 OperInc1Ratio=$fn((OperIncInf1Count/OperInc1Count)*100,"",2)_"%"
		Set OperInc2Ratio="0.00%"
		Set:OperInc2Count>0 OperInc2Ratio=$fn((OperIncInf2Count/OperInc2Count)*100,"",2)_"%" 
		Set OperInc3Ratio="0.00%"
		Set:OperInc3Count>0 OperInc3Ratio=$fn((OperIncInf3Count/OperInc3Count)*100,"",2)_"%" 
		Set OperInc4Ratio="0.00%"
		Set:OperInc4Count>0 OperInc4Ratio=$fn((OperIncInf4Count/OperInc4Count)*100,"",2)_"%" 

			
		Continue:(IsActive="0")&&(OperCount=0)	
		Continue:(aQryCon="2")&&(OperIncInfCount=0)
		Continue:(aQryCon="3")&&(OperCount=0)
		Set Data=$lb(xDimensKey,DimensDesc,OperInc0Count,OperInc1Count,OperInc2Count,OperInc3Count,OperInc4Count,OperIncInf0Count,OperIncInf1Count,OperIncInf2Count,OperIncInf3Count,OperIncInf4Count,OperInc0Ratio,OperInc1Ratio,OperInc2Ratio,OperInc3Ratio,OperInc4Ratio,OperCount,OperIncInfCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1

	}
	If (LocCount>1) {
		Set (OperCount,OperIncInfCount)=0
		Set OperInc0Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperInc0Count"))
		Set OperInc1Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperInc1Count"))
		Set OperInc2Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperInc2Count"))
		Set OperInc3Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperInc3Count"))
		Set OperInc4Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperInc4Count"))
		
		Set OperCount = OperInc0Count+OperInc1Count+OperInc2Count+OperInc3Count+OperInc4Count
		
		Set OperIncInf0Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperIncInf0Count"))
		Set OperIncInf1Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperIncInf1Count"))
		Set OperIncInf2Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperIncInf2Count"))
		Set OperIncInf3Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperIncInf3Count"))
		Set OperIncInf4Count  =+$g(^TMP($zn,$j,NIndex,"Sum","OperIncInf4Count"))
		Set OperIncInfCount = OperIncInf0Count+OperIncInf1Count+OperIncInf2Count+OperIncInf3Count+OperIncInf4Count
		
		Set OperInc0Ratio="0.00%"
		Set:OperInc0Count>0 OperInc0Ratio=$fn((OperIncInf0Count/OperInc0Count)*100,"",2)_"%"
		Set OperInc1Ratio="0.00%"
		Set:OperInc1Count>0 OperInc1Ratio=$fn((OperIncInf1Count/OperInc1Count)*100,"",2)_"%"
		Set OperInc2Ratio="0.00%"
		Set:OperInc2Count>0 OperInc2Ratio=$fn((OperIncInf2Count/OperInc2Count)*100,"",2)_"%" 
		Set OperInc3Ratio="0.00%"
		Set:OperInc3Count>0 OperInc3Ratio=$fn((OperIncInf3Count/OperInc3Count)*100,"",2)_"%" 
		Set OperInc4Ratio="0.00%"
		Set:OperInc4Count>0 OperInc4Ratio=$fn((OperIncInf4Count/OperInc4Count)*100,"",2)_"%" 

		Set Data=$lb("","全部",OperInc0Count,OperInc1Count,OperInc2Count,OperInc3Count,OperInc4Count,OperIncInf0Count,OperIncInf1Count,OperIncInf2Count,OperIncInf3Count,OperIncInf4Count,OperInc0Ratio,OperInc1Ratio,OperInc2Ratio,OperInc3Ratio,OperInc4Ratio,OperCount,OperIncInfCount)
		Set ^CacheTemp(repid,ind)=Data


}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOpRiskCutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpRiskCutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpRiskCutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpRiskCutExecute ]
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
/// Description:  不同感染风险指数（手术切口）手术部位感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom： 开始日期
/// 			  aDateTo：   结束日期 
/// 			  aDimensKey: 维度
/// 			  aDimensType: 统计类型
///               aCutType :  切口类型
///               aINFFlag  : 是否感染 1:感染
/// Return：      返回ROWSPEC
/// aHospIDs=1&aDateFrom=2022-12-01&aDateTo=2022-12-31&aDimensKey=0001-00-0000-H-2&aDimensType=W&aCutType=1&aINFFlag=&aOperCat=&aLocIDs=
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S230OpRiskCut","QryOpRiskCutDtl","3","2022-09-15","2022-09-17","0003-07-0475-W-3","W","3","","","475")
Query QryOpRiskCutDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String, aCutType As %String, aINFFlag As %String, aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType") [ SqlProc ]
{
}

ClassMethod QryOpRiskCutDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String, aCutType As %String, aINFFlag As %String, aOperCat As %String = "", aLocIDs As %String = "") As %Status
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
 	//维度处理
	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aDimensType="" aDimensType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)	
										//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
    
	//临时Gloabl
    Set NIndex="QryOpRiskCutDtl"
	Kill ^TMP($zn,$j,NIndex)
	//循环手麻表
	
	Set:aCutType'="" aCutType=$S(aCutType=0:"无",aCutType=1:"Ⅰ",aCutType=2:"Ⅱ",aCutType=3:"Ⅲ",aCutType=4:"Ⅳ")

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
				 	//过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	// 过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         //手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
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
					Set OperHour    = +$li(AnaesData,10)       // 手术时长
					Set OperDate  = $li(AnaesData,6)
					Set ORSttTime = $li(AnaesData,7)
					// 切口等级
					Set Incision = $li(AnaesData,16)       
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					Set:(MapIncDicDesc="")||(MapIncDicDesc="-") MapIncDicDesc="无手术切口"
					
					If (aCutType'=""){
						//Set:aCutType="无" aCutType="0类"  //自贡三院
						Set:MapIncDicDesc="III类" MapIncDicDesc="Ⅲ类"
						Continue:MapIncDicDesc'[aCutType
						}
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) 	// 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) 	// 手术病区
					If (aDimensType="E"){
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
						
					//统计感染相关[感染报告关联手术区分][维度为手术日期,感染时间不一定在统计范围内]
					Set InfPosInfo=""
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)
					if (aINFFlag=1){
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
									
									Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
								}
							}

						}
					}Else{
						Set Data=PatData_OPSData_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,"","","","","")
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

ClassMethod QryOpRiskCutDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpRiskCutDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpRiskCutDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpRiskCutDtlExecute ]
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
