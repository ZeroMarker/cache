/// 名称: DHCHAI.STATV2.S240AIncInf
/// 描述: Ⅰ类切口手术部位感染率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-14
Class DHCHAI.STATV2.S240AIncInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-14
/// Description:  Ⅰ类切口手术部位感染率统计表
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S240AIncInf","QryAIncInf","1|2|3","2022-02-16","2022-02-16","W","1","","AHW","")
Query QryAIncInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,OperPatAdm:%Integer,OperCaseCount:%Integer,OperCaseInfCount:%Integer,SuperIncRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAIncInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
 	Set NIndex="QryAIncInf"
	Kill ^TMP($zn,$j,NIndex)
	Set IsLc = 0
 	Set xLocID = ""
 	Set xLcDimensKey = ""
 	if (aQryCon="9999")&(aHospIDs'="")
 	{
	 	//如果是临床打开报表进行特殊处理,借用aHospIDs传入科室ID
	 	Set IsLc =1
	 	Set aQryCon =1
	 	Set xLocID = aHospIDs
	 	Set xLocData = $g(^DHCHAI.BT.LocationD(xLocID))
	 	Set BTTypeDr=$lg(xLocData,5)
	 	Set:BTTypeDr'="" aLocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	 	Set BTHospDr=$lg(xLocData,8)
	 	Set:BTHospDr'="" aHospIDs=BTHospDr
	 	Set xLcDimensKey=$e("0000"_xLocID,*-3,*)_"-"_aLocType        	//科室ID	 	
	}
	
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
			 		Set OperStatus = $li(AnaesData,34)	//手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
				 	// 手术信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperDate    = $li(AnaesData,6)			// 手术开始日期
					Set ORSttTime   = $li(AnaesData,7)			// 手术开始时间
					Set OREndDate   = $li(AnaesData,8)			// 手术结束日期
					Set OREndTime   = $li(AnaesData,9)			// 手术结束时间
					Set SCode       = $li(AnaesData,22)
					
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_aOperCat_",")'[(","_OperCatDrs_","))

				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					
					//过滤切口等级(非I类切口)
					Set Incision = $li(AnaesData,16)       		// 切口等级
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
								//记录患者感染相关手术例次
								Set num = $i(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xID))
							
								Set ^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xID)=""
							}
						}
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
						// Ⅰ类切口手术例次数
						Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount")) 
						//SET ^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount")=$g(^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount"))+1
						// Ⅰ类切口手术部位感染例次数
						// 感染
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							
							Set ^TMP($zn,$j,NIndex,DimensKey,"OperCaseInfCount") = $g(^TMP($zn,$j,NIndex,DimensKey,"OperCaseInfCount")) +InfSum
						}
						

					}
					If (LocCount>1) {
						// Ⅰ类切口手术人数
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",EpisodeDr)) {
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","OperPatAdm")) 
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",EpisodeDr)=""
						}
						// Ⅰ类切口手术例次数
						Set num = $i(^TMP($zn,$j,NIndex,"Sum","OperCaseCount")) 
						// Ⅰ类切口手术部位感染例次数
						Set xOpsID=""
						For{
							Set xOpsID=$o(^TMP($zn,$j,NIndex,"HospInfFlg",EpisodeDr,xOpsID))
							Quit:xOpsID=""
							Continue:xOpsID'=xID	//过滤非当前手术例次感染
							Set InfSum=$g(^TMP($zn,$j,NIndex,"HospInfFlgSum",EpisodeDr,xOpsID))
							
							Set ^TMP($zn,$j,NIndex,"Sum","OperCaseInfCount") = $g(^TMP($zn,$j,NIndex,"Sum","OperCaseInfCount")) +InfSum
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
		//限制临床科室查看内容
		Continue:(IsLc=1)&(xLcDimensKey'="")&(xDimensKey'[xLcDimensKey) 
		Set OperPatAdm       =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseCount    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseCount"))      //Ⅰ类切口手术例次数
		Set OperCaseInfCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseInfCount"))   //Ⅰ类切口手术部位感染例次数
		
		Set SuperIncRatio="0.00%"
		Set:OperCaseCount>0 SuperIncRatio=$fn((OperCaseInfCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口手术部位感染率
		
		Continue:(IsActive="0")&&(OperCaseCount=0)	
		Continue:(aQryCon="2")&&(OperCaseInfCount=0)
		Continue:(aQryCon="3")&&(OperCaseCount=0)	
			
		Set Data=$lb(xDimensKey,DimensDesc,OperPatAdm,OperCaseCount,OperCaseInfCount,SuperIncRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set OperPatAdm       =+$g(^TMP($zn,$j,NIndex,"Sum","OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseCount    =+$g(^TMP($zn,$j,NIndex,"Sum","OperCaseCount"))      //Ⅰ类切口手术例次数
		Set OperCaseInfCount =+$g(^TMP($zn,$j,NIndex,"Sum","OperCaseInfCount"))   //Ⅰ类切口手术部位感染例次数
		
		Set SuperIncRatio="0.00%"
		Set:OperCaseCount>0 SuperIncRatio=$fn((OperCaseInfCount/OperCaseCount)*100,"",2)_"%"   //Ⅰ类切口手术部位感染率
		
			
		Set Data=$lb("","全部",OperPatAdm,OperCaseCount,OperCaseInfCount,SuperIncRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncInfExecute ]
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
/// Description:  I类切口手术部位感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aInfFlag:  感染标记  1:查询感染人数
/// 			  aStaType : 统计类型E：科室W：病区      //科室组需要额外判断科室病区
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S240AIncInf","QryAIncInfDtl","1","2021-12-01","202-12-31","0001-00-0000-H-2","0","W","","")
Query QryAIncInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType") [ SqlProc ]
{
}

ClassMethod QryAIncInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %String = "") As %Status
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
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1						//过滤无效数据
			 		Set OperStatus = $li(AnaesData,34)         	// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
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
					// 手术基本信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperDate  = $li(AnaesData,6)			//手术日期
					Set ORSttTime = $li(AnaesData,7)			//手术时间
					Set Incision = $li(AnaesData,16)       		// 切口等级
					Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
					If (IncisionInfo'="") {
						Set MapIncDicCode = $p(IncisionInfo,"^",2)
						Set MapIncDicDesc = $p(IncisionInfo,"^",3)
					}Else {
						Set MapIncDicCode = ""
						Set MapIncDicDesc = Incision
					}
					//过滤非I类手术
					Continue:MapIncDicDesc'["Ⅰ"
					
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
					
	           	    Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
	           	     Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)
					if (aInfFlag=1){	
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

ClassMethod QryAIncInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncInfDtlExecute ]
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

/// Creator：     liutao
/// CreatDate：   2022-05-22
/// Description:  Ⅰ类切口手术部位感染率统计表(新)
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S240AIncInf","QryAIncInfN","1|2|3|4","2022-01-27","2022-05-27","W")
Query QryAIncInfN(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,OperPatAdm:%String,OperCaseInfCount:%String,SuperIncRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAIncInfNExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期处理
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
	 	Set xLocObj = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
	 	Set:$IsObject(xLocObj.BTTypeDr) aLocType=xLocObj.BTTypeDr.BTCode
	 	Set:$IsObject(xLocObj.BTHospDr) aHospIDs=xLocObj.BTHospDr.%Id()
	 	Set xLcDimensKey=$e("0000"_xLocID,*-3,*)_"-"_aLocType        	//科室ID	 	
	}
 	//临时global
 	Set NIndex="QryAIncInfN"
	Kill ^TMP($zn,$j,NIndex)
	//院区转换
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//统计维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   // 根据配置过滤手术状态
	
	Set EMROperHealingGrade=##class(DHCHAI.BT.Config).GetValByCode("EMROperHealingGrade")   //根据配置取首页愈合等级
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				//取就诊号
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水 
					Set InfPosInfo =..GetInfPosOperInfo(xPaadm,aDateFrom,aDateTo)
					Set OPSIDs=$p(InfPosInfo,"#",2)
					If (OPSIDs'=""){
						
						Set ^TMP($zn,$j,NIndex,"HospInfFlg",xPaadm,OPSIDs)=""
						Set InfPosInfo=$p(InfPosInfo,"#",1)
					
						If (InfPosInfo'="") {
							For InfNo=1:1:$L(InfPosInfo,"|") {
							Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
							Continue:InfPosMsg=""
							Set PosDesc     = $p(InfPosMsg,"^",2)
							Set InfDate     = $p(InfPosMsg,"^",3)
							//记录感染信息
							Set InfOperID=	$p(OPSIDs,"^",InfNo)
							Set ^TMP($zn,$j,NIndex,"HospInfPos",xPaadm,InfOperID)=PosDesc
					
							
								}
							}
						}
						
					//取手术相关信息
					Set xAnaesDr=""
					For {
						Set xAnaesDr = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xPaadm,xAnaesDr))
						Quit:xAnaesDr=""
						Set AnaesData = $g(^DHCHAI.DP.OROperAnaesD(xAnaesDr))
						continue:AnaesData=""
						Set ORIsActive=$li(AnaesData,31)
				 		Continue:ORIsActive'=1						//过滤无效数据
			 			Set OperStatus = $li(AnaesData,34)         	// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
						Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
						Set:tOperStatus'="" OperStatus=tOperStatus
				 		  // 过滤手术状态
				 		//Continue:ExclStatus[OperStatus   // 根据配置过滤手术状态
				 		//add 20210926 增加手术分类条件过滤
				   		 Set OperCatDrs = $lg(AnaesData,36)
						Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
				 
						//手术日期
						Set OperDate  = $li(AnaesData,6)
						
						//根据配置从首页或者手麻表取值
						Set MapHealDicDesc=""
						Set MapIncDicDesc=""
						If (EMROperHealingGrade=1){
							Set xOperID =""
							For {
								Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",xPaadm,OperDate,xOperID))
								Quit:xOperID=""
		
								Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
								Continue:OperData=""
								Set OROperSource=$li(OperData,22)
								Continue:OROperSource'="E"
								Set Healing = $li(OperData,17)	
								Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
									If (HealingInfo'="") {
										Set MapHealDicCode = $p(HealingInfo,"^",2)
										Set MapHealDicDesc = $p(HealingInfo,"^",3)
									}Else {
										Set MapHealDicCode = ""
										Set MapHealDicDesc = HealingInfo
									}
								//手术切口等级
								Set Incision = $li(OperData,16)       
								Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
								If (IncisionInfo'="") {
										Set MapIncDicCode = $p(IncisionInfo,"^",2)
										Set MapIncDicDesc = $p(IncisionInfo,"^",3)
									}Else {
										Set MapIncDicCode = ""
										Set MapIncDicDesc = Incision
									}	
									
								}
						}elseIf (EMROperHealingGrade=2){
							Set xOperID =""
							For {
								Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",xPaadm,OperDate,xOperID))
								Quit:xOperID=""
		
								Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
								Continue:OperData=""
								Set OROperSource=$li(OperData,22)
								Continue:OROperSource'="F"
								Set Healing = $li(OperData,17)	
								Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
									If (HealingInfo'="") {
										Set MapHealDicCode = $p(HealingInfo,"^",2)
										Set MapHealDicDesc = $p(HealingInfo,"^",3)
									}Else {
										Set MapHealDicCode = ""
										Set MapHealDicDesc = HealingInfo
									}
								//手术切口等级
								Set Incision = $li(OperData,16)       
								Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
								If (IncisionInfo'="") {
										Set MapIncDicCode = $p(IncisionInfo,"^",2)
										Set MapIncDicDesc = $p(IncisionInfo,"^",3)
									}Else {
										Set MapIncDicCode = ""
										Set MapIncDicDesc = Incision
									}	
									
								}
							
						
						}else {
							//手术愈合等级
							Set Healing = $li(AnaesData,17)	
							Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
							If (HealingInfo'="") {
								Set MapHealDicCode = $p(HealingInfo,"^",2)
								Set MapHealDicDesc = $p(HealingInfo,"^",3)
							}Else {
								Set MapHealDicCode = ""
								Set MapHealDicDesc = HealingInfo
							}
							//手术切口等级
							Set Incision = $li(AnaesData,16)       
							Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
							If (IncisionInfo'="") {
								Set MapIncDicCode = $p(IncisionInfo,"^",2)
								Set MapIncDicDesc = $p(IncisionInfo,"^",3)
							}Else {
								Set MapIncDicCode = ""
								Set MapIncDicDesc = Incision
							}
							
							
						}
						//感染诊断
						Set InfPosDescs=$g(^TMP($zn,$j,NIndex,"HospInfPos",xPaadm,xAnaesDr))
						
						//过滤非I类手术
						Continue:MapIncDicDesc'["Ⅰ"
						
						Set ORSttTime   = $li(AnaesData,7)			//手术时间
						Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xPaadm,OperDate,ORSttTime)	//所在科室病区
						Continue:OperLocWard=""
					
						Set OperLocDr  = $p(OperLocWard,"^",1) 		// 手术科室[患者]
						Set OperWardDr = $p(OperLocWard,"^",2) 		// 手术病区[患者]
						
						Set LocData = $g(^DHCHAI.BT.LocationD(OperLocDr))
						If (OperWardDr'=""){
							Set LocData = $g(^DHCHAI.BT.LocationD(OperWardDr))
						}
						Set HospDr=$li(LocData,8)					//手术院区[患者]
						Set GroupDr  = $li(LocData,7)				//手术科室组[患者]
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
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OperPatAdm"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",xPaadm)=""
						} 
						
						// Ⅰ类切口手术愈合等级为丙级
						If (MapHealDicDesc="丙") {
							//I类切口手术感染人数
							if ('$d(^TMP($zn,$j,NIndex,"InfPat",xPaadm))){	//过滤重复患者
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPatAdm"))
								Set ^TMP($zn,$j,NIndex,"InfPat",xPaadm)=""
								}
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
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
		//限制临床科室查看内容
		Continue:(IsLc=1)&(xLcDimensKey'="")&(xDimensKey'[xLcDimensKey)
		Set OperPatAdm       =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperPatAdm"))         //Ⅰ类切口手术人数
		Set OperCaseInfCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPatAdm"))   //Ⅰ类切口手术部位感染人数
		
		Set SuperIncRatio="0.00%"
		Set:OperCaseInfCount>0 SuperIncRatio=$fn((OperCaseInfCount/OperPatAdm)*100,"",2)_"%"   //Ⅰ类切口手术部位感染率
		
		Continue:(IsActive'=1)&&(OperPatAdm=0)
		Continue:(aQryCon=2)&&(OperPatAdm=0)	
			
		Set Data=$lb(xDimensKey,DimensDesc,OperPatAdm,OperCaseInfCount,SuperIncRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncInfNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncInfNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncInfDtlExecute ]
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

/// Creator：     liutao
/// CreatDate：   2022-05-22
/// Description:  Ⅰ类切口手术部位感染率统计明细表(新)
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S240AIncInf","QryAIncInfNDtl","2022-01-27","2022-05-31","0000-00-0000-A-1-1","","W")
Query QryAIncInfNDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aFindFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,InfPosDescs:%String,OperCatLists:%String") [ SqlProc ]
{
}

ClassMethod QryAIncInfNDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aFindFlag As %String) As %Status
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
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs="0" aHospIDs=""
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aLocDr=""
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set StatType=aLocType
    Set:aStaType'="" StatType=aStaType 
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    
	Set NIndex="QrySDayInfNDtl"
	Kill ^TMP($zn,$j,NIndex)
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   // 根据配置过滤手术状态
	Set EMROperHealingGrade=##class(DHCHAI.BT.Config).GetValByCode("EMROperHealingGrade")   //根据配置取愈合等级
	// 查询出院患者
	Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:xAdmType'="I"
		
		For xDishDate = aDateFrom:1:aDateTo {
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				//取就诊号
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
				
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					Set InfPosInfo =..GetInfPosOperInfo(xPaadm,aDateFrom,aDateTo)
					Set OPSIDs=$p(InfPosInfo,"#",2)
					If (OPSIDs'=""){
						
						Set ^TMP($zn,$j,NIndex,"HospInfFlg",xPaadm,OPSIDs)=""
						Set InfPosInfo=$p(InfPosInfo,"#",1)
					
						If (InfPosInfo'="") {
							For InfNo=1:1:$L(InfPosInfo,"|") {
							Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
							Continue:InfPosMsg=""
							Set PosDesc     = $p(InfPosMsg,"^",2)
							Set InfDate     = $p(InfPosMsg,"^",3)
							//记录感染信息
							Set InfOperID=	$p(OPSIDs,"^",InfNo)
							Set ^TMP($zn,$j,NIndex,"HospInfPos",xPaadm,InfOperID)=PosDesc
					
							
								}
							}
						}
						
					
	
					//取手术相关信息
					Set xAnaesDr=""
					For {
					
						Set xAnaesDr = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xPaadm,xAnaesDr))
						Quit:xAnaesDr=""
					    
						Set AnaesData = $g(^DHCHAI.DP.OROperAnaesD(xAnaesDr))
						continue:AnaesData=""
					
						Set ORIsActive=$li(AnaesData,31)
				 		Continue:ORIsActive'=1						//过滤无效数据
			 			Set OperStatus = $li(AnaesData,34)         	// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
						Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
						Set:tOperStatus'="" OperStatus=tOperStatus
				 		  // 过滤手术状态
				 		//Continue:ExclStatus[OperStatus   // 根据配置过滤手术状态
				 		
					
						//手术日期
						Set OperDate  = $li(AnaesData,6)
						
							//根据配置从首页或者手麻表取值
						Set MapHealDicDesc=""
						Set MapIncDicDesc=""
						If (EMROperHealingGrade=1){
							Set xOperID =""
							For {
								Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",xPaadm,OperDate,xOperID))
								Quit:xOperID=""
		
								Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
								Continue:OperData=""
								Set OROperSource=$li(OperData,22)
								Continue:OROperSource'="E"
								Set Healing = $li(OperData,17)	
								Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
									If (HealingInfo'="") {
										Set MapHealDicCode = $p(HealingInfo,"^",2)
										Set MapHealDicDesc = $p(HealingInfo,"^",3)
									}Else {
										Set MapHealDicCode = ""
										Set MapHealDicDesc = HealingInfo
									}
								//手术切口等级
								Set Incision = $li(OperData,16)       
								Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
								If (IncisionInfo'="") {
										Set MapIncDicCode = $p(IncisionInfo,"^",2)
										Set MapIncDicDesc = $p(IncisionInfo,"^",3)
									}Else {
										Set MapIncDicCode = ""
										Set MapIncDicDesc = Incision
									}	
									
								}
						}elseIf (EMROperHealingGrade=2){
							Set xOperID =""
							For {
								Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",xPaadm,OperDate,xOperID))
								Quit:xOperID=""
		
								Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
								Continue:OperData=""
								Set OROperSource=$li(OperData,22)
								Continue:OROperSource'="F"
								Set Healing = $li(OperData,17)	
								Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
									If (HealingInfo'="") {
										Set MapHealDicCode = $p(HealingInfo,"^",2)
										Set MapHealDicDesc = $p(HealingInfo,"^",3)
									}Else {
										Set MapHealDicCode = ""
										Set MapHealDicDesc = HealingInfo
									}
								//手术切口等级
								Set Incision = $li(OperData,16)       
								Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
								If (IncisionInfo'="") {
										Set MapIncDicCode = $p(IncisionInfo,"^",2)
										Set MapIncDicDesc = $p(IncisionInfo,"^",3)
									}Else {
										Set MapIncDicCode = ""
										Set MapIncDicDesc = Incision
									}	
									
								}
							
						
						}else {
							//手术愈合等级
							Set Healing = $li(AnaesData,17)	
							Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
							If (HealingInfo'="") {
								Set MapHealDicCode = $p(HealingInfo,"^",2)
								Set MapHealDicDesc = $p(HealingInfo,"^",3)
							}Else {
								Set MapHealDicCode = ""
								Set MapHealDicDesc = HealingInfo
							}
							//手术切口等级
							Set Incision = $li(AnaesData,16)       
							Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
							If (IncisionInfo'="") {
								Set MapIncDicCode = $p(IncisionInfo,"^",2)
								Set MapIncDicDesc = $p(IncisionInfo,"^",3)
							}Else {
								Set MapIncDicCode = ""
								Set MapIncDicDesc = Incision
							}
							
							
							}
						//感染诊断
						Set InfPosDescs=$g(^TMP($zn,$j,NIndex,"HospInfPos",xPaadm,xAnaesDr))
						
						//过滤非I类手术
						Continue:MapIncDicDesc'["Ⅰ"
						
						Set ORSttTime = $li(AnaesData,7)
						// 患者手术时所在的科室病区
						Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xPaadm,OperDate,ORSttTime)
						Continue:OperLocWard=""
						Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室
						Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区
						If (StatType="E"){
							Set LocID = OperLocDr
						}Else{
					
							Set LocID = OperWardDr
						}
						Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
						Set GroupDr  = $li(LocData,7)
						If GroupDr="" {
							Set GroupDesc="其他科"
							Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
						}
						//按科室组、科室/病区过滤
						Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
						Continue:(aLocDr'="")&&(LocID'=aLocDr)
						
						Set OperCatDrs = $lg(AnaesData,36)
						Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
				
						Set OperCatList=""
						For indC=1:1:$L(OperCatDrs,",") {
							Set OperCatDr=$p(OperCatDrs,",",indC)
							Continue:OperCatDr=""
						
							Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
							Continue:'$IsObject(objCat)
							Set OperCat =objCat.BTOperCat
							If $listfind(OperCatList,OperCat)<1 {
								Set OperCatList=OperCatList_$lb(OperCat)
							}
						}
						
							
							Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
							//感染诊断
							Set InfPosDescs=$g(^TMP($zn,$j,NIndex,"HospInfPos",xPaadm,xAnaesDr))
							//患者基本信息
							Set PatData =..BuildPaadmData(xPaadm)
					    	Continue:PatData=""
					    	//手术基本信息[患者]
							Set OPSData=..GetOPSDataByAnaesDr(xPaadm,xAnaesDr)
							Continue:OPSData=""
							
							
							If (aFindFlag=1){
								//I类切口手术 
								Set Data=PatData_OPSData_$lb(InfPosDescs)_$lb(OperCatLists)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}else{
									// Ⅰ类切口手术愈合等级为丙级
								If (MapHealDicDesc="丙") {
									Set Data=PatData_OPSData_$lb(InfPosDescs)_$lb(OperCatLists)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
									
									}
								
								
								}

					}	
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAIncInfNDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIncInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAIncInfNDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIncInfDtlExecute ]
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
