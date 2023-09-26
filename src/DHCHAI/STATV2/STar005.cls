/// 名称: DHCHAI.STATV2.STar005
/// 描述: 2015十三项指标(5)->多重耐药菌检出率统计
/// 编写者：ShenC
/// 编写日期: 2021-02-05
Class DHCHAI.STATV2.STar005 Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		ShenC
/// CreateDate：	2022-06-17
/// Description:	多重耐药菌检出率
///                 多重耐药菌检出率统计,排除感染类型为污染
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期
///                 aStaType : 统计类型E：科室W：病区 
/// 		 	    aQryCon  : 是否仅显示有数据的科室
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.STar005","QryMRBPos","1","2018-07-01","2019-11-08","W","2")
Query QryMRBPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,MRSAMRBCase:%String,MRSAPatCase:%String,MRSAPatRatio:%String,VREMRBCase:%String,VREPatCase:%String,VREPatRatio:%String,CREMRBCase:%String,CREPatCase:%String,CREPatRatio:%String,CRABMRBCase:%String,CRABPatCase:%String,CRABPatRatio:%String,CEPAMRBCase:%String,CEPAPatCase:%String,CEPAPatRatio:%String,MRBCount:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
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
 	Set NIndex="QryMRBPos"
	Kill ^TMP($zn,$j,NIndex)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	 //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	
	//同期在科/病区:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,xLocID,"I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If '$d(^TMP($zn,$j,NIndex,"AdmPat",Paadm)) {// 避免重复获取患者信息
			Set ^TMP($zn,$j,NIndex,"AdmPat",Paadm)=""
		}
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $lg(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		Set TransDate = $p(TransDates,",",1)
		Set EndDate   = $p(TransDates,",",$l(TransDates,","))
		Set:(TransDate>aDateFrom)&&(TransDate<aDateTo) TransDate=TransDate-1

		//患者多耐信息
	    Set ListMRBArray=##class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,TransDate,EndDate,LocID)
	    //统计维度
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			For index2=1:1:ListMRBArray.Count() {
				Set MRBInfo=ListMRBArray.GetAt(index2)	
				Continue:MRBInfo=""
				Set MRBCode    = $LIST(MRBInfo,2)
				Set MRBDesc    = $LIST(MRBInfo,3)
				Set MRB2Code   = $LIST(MRBInfo,4)
				Set MRB2Desc   = $LIST(MRBInfo,5)
				Set BacDesc    = $LIST(MRBInfo,7)
				Set IPHourFlag = $LIST(MRBInfo,8)
				Set MRBFlag    = $LIST(MRBInfo,9)
				Set IsInfMRBFlag = $LIST(MRBInfo,10)
				Continue:BacDesc=""
				//过滤污染细菌(Add 2021-12-14)
				Set IsPollute=$LIST(MRBInfo,17)
				Continue:IsPollute="1"
				
				Set MRBType=$LIST(MRBInfo,15)
				If (MRBType["M1"){	    //金黄色葡萄球菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"JHSPTQJ"))
				}elseif(MRBType["M2"){  //粪肠球菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"FCQJ"))
				}elseif(MRBType["M3"){  //屎肠球菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"SCQJ"))
				}elseif((MRBType["M4")||(MRBType["M6")){  //大肠埃希菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"DCAXJ"))
				}elseif((MRBType["M5")||(MRBType["M7")){  //肺炎克雷伯菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"FYKLBJ"))
				}elseif(MRBType["M8"){   //鲍曼不动杆菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"BMBDGJ"))
				}elseif(MRBType["M9"){   //铜绿假单胞菌
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"TLJDBJ"))
				}elseif(MRBType'="")&&(MRBType["P"){
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MRBType))
				}

				Continue:MRBCode=""
				Set MCIndex=MRBCode_"PatCase"    
				//同期检出多耐菌的例次数
				Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MCIndex))
				Set MCIndex=MRB2Code_"PatCase"
				Set num = $i(^TMP($zn,$j,NIndex,DimensKey,MCIndex))
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
		Set HospCount = $l(aHospIDs,"|")
		Continue:(xDimensKey["A")&(HospCount="1")		//单院区不显示"全院"
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    //住院患者人数
		
		//MRSA
		Set MRSAMRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JHSPTQJ")) 	//同期检出金黄色葡萄球菌的例次数
		Set MRSAPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1PatCase")) //同期检出耐甲氧西林的金黄色葡萄球菌例次数
		Set MRSAPatRatio="0.00%"
		Set:MRSAMRBCase>0 MRSAPatRatio=$fn((MRSAPatCase/MRSAMRBCase)*100,"",2)_"%" //耐甲氧西林的金黄色葡萄球菌检出率
	
		//VRE
		Set M2MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"FCQJ")) 		//粪肠球菌
		Set M3MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SCQJ")) 		//屎肠球菌
		Set P3MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P3"))
		Set VREMRBCase=M2MRBCase+M3MRBCase+P3MRBCase
		
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2PatCase")) //耐万古霉素的粪肠球菌
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3PatCase")) //耐万古霉素的屎肠球菌
		Set P3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P3PatCase")) //耐万古霉素肠球菌(除粪肠球菌、屎肠球菌)
		Set VREPatCase =M2PatCase+M3PatCase+P3PatCase
		Set VREPatRatio="0.00%"
		Set:VREMRBCase>0 VREPatRatio=$fn((VREPatCase/VREMRBCase)*100,"",2)_"%" //检出率
	
		//CRE
		Set M6MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"DCAXJ")) 	//大肠埃希菌
		Set M7MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"FYKLBJ")) 	//肺炎克雷伯菌
		Set P4MRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P4")) 	    //耐碳青霉烯类的肠杆菌科细菌(除大肠埃希菌、肺炎克雷伯菌)		
		Set CREMRBCase=M6MRBCase+M7MRBCase+P4MRBCase
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6PatCase")) //大肠埃希菌
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7PatCase")) //耐碳青霉烯类的肺炎克雷伯菌
		Set P4PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P4PatCase")) //耐碳青霉烯类的肺炎克雷伯菌
		Set CREPatCase=M6PatCase+M7PatCase+P4PatCase
		Set CREPatRatio="0.00%"
		Set:CREMRBCase>0 CREPatRatio=$fn((CREPatCase/CREMRBCase)*100,"",2)_"%" //检出率
		//CRAB
		Set CRABMRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"BMBDGJ")) 	//鲍曼不动杆菌
		Set CRABPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8PatCase")) //耐碳青霉烯类的鲍曼不动杆菌
		Set CRABPatRatio="0.00%"
		Set:CRABMRBCase>0 CRABPatRatio=$fn((CRABPatCase/CRABMRBCase)*100,"",2)_"%" //检出率
		//CEPA
		Set CEPAMRBCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"TLJDBJ")) 	//铜绿假单胞菌
		Set CEPAPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9PatCase")) //耐碳青霉烯类的铜绿假单胞菌
		Set CEPAPatRatio="0.00%"
		Set:CEPAMRBCase>0 CEPAPatRatio=$fn((CEPAPatCase/CEPAMRBCase)*100,"",2)_"%" //检出率
		
		Set MRBCount=MRSAMRBCase+VREMRBCase+CREMRBCase+CRABMRBCase+CEPAMRBCase
		//Update:2021-08-05 科室组+院区 区分科室/病区,解决明细数据不一致问题
		Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
		
		//Continue:(IsActive'=1)&&(PatAdmCnt=0)
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(PatAdmCnt=0)
		Continue:(aQryCon=2)&&(MRBCount=0)		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,MRSAMRBCase,MRSAPatCase,MRSAPatRatio,VREMRBCase,VREPatCase,VREPatRatio,CREMRBCase,CREPatCase,CREPatRatio,CRABMRBCase,CRABPatCase,CRABPatRatio,CEPAMRBCase,CEPAPatCase,CEPAPatRatio,MRBCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosExecute ]
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

/// Creator：		ShenC
/// CreateDate：	2021-02-05
/// Description:	多重耐药菌感染发现率分子明细表
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:		    aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.STar005","QryMRBPosDtl","2020-07-01","2020-07-31","0001-07-0000-G-3-W","","3")
Query QryMRBPosDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,ActDateTime:%String,RepDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aFlag As %String) As %Status
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
	Set:+aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)

	Set StatType=$p(aDimensKey,"-",$l(aDimensKey,"-"))			//1.统计类型(W|E)-aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	//同期在科/病区:某段时间的在科人数
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
		Set:LocDr="" LocDr=WardDr
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
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&(LocDr'=aLocDr)
		
		Set TransDate = $p(TransDates,",",1)
		Set EndDate   = $p(TransDates,",",$l(TransDates,","))
		Set:(TransDate>aDateFrom)&&(TransDate<aDateTo) TransDate=TransDate-1
		//患者多耐信息
	    Set ListMRBArray=##class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo(Paadm,TransDate,EndDate,LocID)
		For index2=1:1:ListMRBArray.Count() {
			Set MRBInfo=ListMRBArray.GetAt(index2)	
			Continue:MRBInfo=""
			Set MRBCode    = $LIST(MRBInfo,2)
			Set MRBDesc    = $LIST(MRBInfo,3)
			Set MRB2Code   = $LIST(MRBInfo,4)
			Set MRB2Desc   = $LIST(MRBInfo,5)
			Set SpeDesc    = $LIST(MRBInfo,6)
			Set BacDesc    = $LIST(MRBInfo,7)
			Set IPHourFlag = $LIST(MRBInfo,8)
			Set MRBFlag    = $LIST(MRBInfo,9)
			Set IsInfMRBFlag = $LIST(MRBInfo,10)
			Set MRBType=$LIST(MRBInfo,15)
			Set ActDate = $p($LIST(MRBInfo,11)," ",1)    // 采样时间
			Set ActTime = $p($LIST(MRBInfo,11)," ",2)    // 采样时间
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime=$zt(ActTime,2)
			Set ActDateTime=ActDate_" "_ActTime
			Set RepDate = $p($LIST(MRBInfo,12)," ",1)   // 报告时间
			Set RepTime = $p($LIST(MRBInfo,12)," ",2)    // 报告时间
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set RepTime=$zt(RepTime,2)
			Set RepDateTime=RepDate_" "_RepTime
			//过滤污染细菌(Add 2021-12-14)
			Set IsPollute=$LIST(MRBInfo,17)
			Continue:IsPollute="1"
			
			If (aFlag="0"){
				Continue:MRBCode=""
				//合并处理--MRSA[M1],VRE[M2,M3],CRE[M6,M7],CRAB[M8],CRPA[M9]
				Set:aMRBCode="M1" aMRBCode="M1"
				Set:aMRBCode="M2" aMRBCode="M2,M3"
				Set:aMRBCode="M3" aMRBCode="M6,M7"
				Set:aMRBCode="M4" aMRBCode="M8"
				Set:aMRBCode="M5" aMRBCode="M9"
				
				Set:MRB2Code="" MRB2Code=MRBCode
				Continue:( (aMRBCode'[MRBCode)&&(aMRBCode'[MRB2Code) )
				Set PatData =..BuildPaadmData(Paadm)
		   		Continue:PatData=""
			    Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc
			    
				Set Data=PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,MRBDesc,SpeDesc,BacDesc,ActDateTime,RepDateTime)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}else{
				Continue:BacDesc=""
				Continue:(aFlag="1")&&(MRBType'["M1")   //金黄色葡萄球菌
				Continue:(aFlag="2")&&(MRBType'["M2")&&(MRBType'["M3")   //粪肠球菌、屎肠球菌
				Continue:(aFlag="3")&&((MRBType'["M6")&&(MRBType'["M7"))   //大肠埃希菌、肺炎克雷伯菌
				Continue:(aFlag="4")&&(MRBType'["M8")   //鲍曼不动杆菌
				Continue:(aFlag="5")&&(MRBType'["M9")   //铜绿假单胞菌

				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				
				Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc
				
				Set Data=PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,MRBDesc,SpeDesc,BacDesc,ActDateTime,RepDateTime)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryMRBPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosDtlExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2021-02-05
/// Description:  住院患者明细表(分母)
/// Table：       DHCHAI.DP.PAAdm
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey:维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.STar005","QryMRBInfPatDtl","2018-08-01","2019-08-10","0001-01-0092-W-4")
Query QryMRBInfPatDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,InLocWardDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryMRBInfPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set Count=0
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
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)

    Set NIndex="QryMRBInfPatDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set StatType=aLocType
	Set:StatType="" StatType=$p(aDimensKey,"-",$l(aDimensKey,"-"))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set ListArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
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
		Set:LocDr="" LocDr=WardDr
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
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&(LocDr'=aLocDr)
		
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    //当前未转出，截止为查询结束日期
			Set EndDate = OutLocDate
			Set:EndDate="" EndDate = aDateTo
			Set:OutLocDate>aDateTo EndDate = aDateTo
			Set:EndDate>(+$h) EndDate=+$h
			Set FormDate = aDateFrom
			Set:TransDate>=aDateFrom FormDate=TransDate  //查询开始日期大于转科日期时
			Set:TransDate<aDateFrom FormDate=FormDate-1  //如果是提前入科的头一天就算		
			Set InLocWardDays = EndDate-FormDate+1
			Set:InLocWardDays=0 InLocWardDays=1   //当天入当天出算一天
					
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set TransTime 	= $li(TranData,8)
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime 	= $li(TranData,11)
		    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
				  
			Set Data=PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,TransDateTime,OutLocDateTime,InLocWardDays)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	    } 
		
	}	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMRBInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfPatDtlExecute ]
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
