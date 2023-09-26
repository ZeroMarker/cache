/// 名称: DHCHAI.STATV2.S041MRBInf
/// 描述: 出院患者多重耐药菌感染发现率统计
/// 编写者: zzl
/// 编写日期: 2022-11-11
Class DHCHAI.STATV2.S041MRBInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		Zzlei
/// CreateDate：	2022-11-11
/// Description:	多重耐药菌感染发现率
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期
///                 aStaType : 统计类型E：科室W：病区 
/// 		 	    aQryCon  : 是否仅显示有数据的科室
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S041MRBInf","QryMRBInf","1|3|4","2020-05-01","2020-08-31","W","2")
Query QryMRBInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,M1Pat:%String,M1PatCase:%String,M1PatRatio:%String,M1CaseRatio:%String,M2Pat:%String,M2PatCase:%String,M2PatRatio:%String,M2CaseRatio:%String,M3Pat:%String,M3PatCase:%String,M3PatRatio:%String,M3CaseRatio:%String,M4Pat:%String,M4PatCase:%String,M4PatRatio:%String,M4CaseRatio:%String,M5Pat:%String,M5PatCase:%String,M5PatRatio:%String,M5CaseRatio:%String,M6Pat:%String,M6PatCase:%String,M6PatRatio:%String,M6CaseRatio:%String,M7Pat:%String,M7PatCase:%String,M7PatRatio:%String,M7CaseRatio:%String,M8Pat:%String,M8PatCase:%String,M8PatRatio:%String,M8CaseRatio:%String,M9Pat:%String,M9PatCase:%String,M9PatRatio:%String,M9CaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set NIndex="QryMRBInf"
	Kill ^TMP($zn,$j,NIndex)
	
	Set HospCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	
	// 接口-获取一段时间内的出院患者信息
    Set DischPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index1=1:1:DischPatArr.Count() {
	    Set DischPatInfo=DischPatArr.GetAt(index1)
		Continue:DischPatInfo=""
		
		Set Paadm		= $li(DischPatInfo,1)		//患者信息
	    Set DischHospID	= $li(DischPatInfo,2)		//出院院区
	    Set DischGroupID= $li(DischPatInfo,3)		//出院科室分组
	    //科室未指定分组，默认为"其他科"分组
	    Set:DischGroupID="" DischGroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
	    Set LocID	= $li(DischPatInfo,4)		//出院科室
	    Set DischWardID	= $li(DischPatInfo,5)		//出院病区
	    Set AdmDate		= $li(DischPatInfo,6)		//入院日期
	    Set DishDate	= $li(DischPatInfo,7)		//出院日期
		Set:StatType="W" LocID=DischWardID
		//过滤院区
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,DischHospID)<1)
		
		//患者多耐信息
	    Set ListMRBArray=..GetPatMRBInfo(Paadm,AdmDate,DishDate,"",HAType)
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
			Continue:IsInfMRBFlag'=1

			Continue:MRBCode=""			
			Set MIndex=MRBCode_"Pat"
			//同期检出导致医院感染的多耐人数
			If '$d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)){
				Set num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MIndex))
				Set ^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)=""
			}
			Set MCIndex=MRBCode_"PatCase"
			//同期检出导致医院感染的多耐例次数
			Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MCIndex))
			If (MRB2Code'=""){
				Set MIndex=MRB2Code_"Pat"
				If '$d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)){
					Set num=$i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MIndex))
					Set ^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm,MIndex)=""
				}
				Set MCIndex=MRB2Code_"PatCase"
				Set num = $i(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,MCIndex))
			}
		}
	    //统计维度
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,DischHospID,DischGroupID,LocID,DischWardID)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 出院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			
			Continue:'$d(^TMP($zn,$j,NIndex,"MRBPat",LocID,Paadm))
			// 检出菌
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)){
				Set ^TMP($zn,$j,NIndex,DimensKey,"LocPatAdm",LocID,Paadm)=""
				
				Set ^TMP($zn,$j,NIndex,DimensKey,"M1Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M1Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M2Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M2Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M3Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M3Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M4Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M4Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M5Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M5Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M6Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M6Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M7Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M7Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M8Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M8Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M9Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"M9Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9Pat"))
				
				Set ^TMP($zn,$j,NIndex,DimensKey,"M1PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M1PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M1PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M2PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M2PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M2PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M3PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M3PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M3PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M4PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M4PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M4PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M5PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M5PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M5PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M6PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M6PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M6PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M7PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M7PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M7PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M8PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M8PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M8PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"M9PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"M9PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"M9PatCase"))
			}
		}
	}	
	//zw ^TMP($zn,$j,NIndex,"MRB")
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
		Continue:(xDimensKey["A")&(HospCount="1")
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    //出院患者人数
		Set M1Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M1PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M1PatRatio="0.00%"
		Set:PatAdmCnt>0 M1PatRatio=$fn((M1Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M1CaseRatio="0.00%"
		Set:PatAdmCnt>0 M1CaseRatio=$fn((M1PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M2PatRatio="0.00%"
		Set:PatAdmCnt>0 M2PatRatio=$fn((M2Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M2CaseRatio="0.00%"
		Set:PatAdmCnt>0 M2CaseRatio=$fn((M2PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M3PatRatio="0.00%"
		Set:PatAdmCnt>0 M3PatRatio=$fn((M3Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M3CaseRatio="0.00%"
		Set:PatAdmCnt>0 M3CaseRatio=$fn((M3PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M4Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M4PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M4PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M4PatRatio="0.00%"
		Set:PatAdmCnt>0 M4PatRatio=$fn((M4Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M4CaseRatio="0.00%"
		Set:PatAdmCnt>0 M4CaseRatio=$fn((M4PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M5Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M5PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M5PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M5PatRatio="0.00%"
		Set:PatAdmCnt>0 M5PatRatio=$fn((M5Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M5CaseRatio="0.00%"
		Set:PatAdmCnt>0 M5CaseRatio=$fn((M5PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M6PatRatio="0.00%"
		Set:PatAdmCnt>0 M6PatRatio=$fn((M6Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M6CaseRatio="0.00%"
		Set:PatAdmCnt>0 M6CaseRatio=$fn((M6PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M7PatRatio="0.00%"
		Set:PatAdmCnt>0 M7PatRatio=$fn((M7Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M7CaseRatio="0.00%"
		Set:PatAdmCnt>0 M7CaseRatio=$fn((M7PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M8Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M8PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M8PatRatio="0.00%"
		Set:PatAdmCnt>0 M8PatRatio=$fn((M8Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M8CaseRatio="0.00%"
		Set:PatAdmCnt>0 M8CaseRatio=$fn((M8PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set M9Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9Pat"))     //同期检出导致医院感染的MRSA的人数
		Set M9PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set M9PatRatio="0.00%"
		Set:PatAdmCnt>0 M9PatRatio=$fn((M9Pat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set M9CaseRatio="0.00%"
		Set:PatAdmCnt>0 M9CaseRatio=$fn((M9PatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		
		Set MRBCount=M1Pat+M2Pat+M3Pat+M4Pat+M5Pat+M6Pat+M7Pat+M8Pat+M9Pat
		
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(PatAdmCnt=0)
		Continue:(aQryCon=2)&&(MRBCount=0)	
		
		Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
			
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,M1Pat,M1PatCase,M1PatRatio,M1CaseRatio,M2Pat,M2PatCase,M2PatRatio,M2CaseRatio,M3Pat,M3PatCase,M3PatRatio,M3CaseRatio,M4Pat,M4PatCase,M4PatRatio,M4CaseRatio,M5Pat,M5PatCase,M5PatRatio,M5CaseRatio,M6Pat,M6PatCase,M6PatRatio,M6CaseRatio,M7Pat,M7PatCase,M7PatRatio,M7CaseRatio,M8Pat,M8PatCase,M8PatRatio,M8CaseRatio,M9Pat,M9PatCase,M9PatRatio,M9CaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfExecute ]
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

/// Creator：		Zzlei
/// CreateDate：	2022-11-11
/// Description:	多重耐药菌感染发现率分子明细表
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:		    aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S041MRBInf","QryMRBInfDtl","2020-07-01","2021-07-31","0001-07-0178-W-4","M3","W")
Query QryMRBInfDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aStaType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,ActDateTime:%String,RepDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aStaType As %String) As %Status
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
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set:aMRBCode="M1" aMRBCode="M1"
	Set:aMRBCode="M2" aMRBCode="M2|M3"
	Set:aMRBCode="M3" aMRBCode="M6|M7"
	Set:aMRBCode="M4" aMRBCode="M8"
	Set:aMRBCode="M5" aMRBCode="M9"

	Set StatType=$p(aDimensKey,"-",$l(aDimensKey,"-"))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
   	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
	//取出院患者接口
    Set DischPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index1=1:1:DischPatArr.Count() {
	    Set DischPatInfo=DischPatArr.GetAt(index1)
		Continue:DischPatInfo=""
		
	    Set Paadm		= $li(DischPatInfo,1)		//患者信息
	    Set DischHospID	= $li(DischPatInfo,2)		//出院院区
	    Set DischGroupID= $li(DischPatInfo,3)		//出院科室分组
	    
	    //科室未指定分组，默认为"其他科"分组
	    Set:DischGroupID="" DischGroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		Set DischGroupDesc=$li($g(^DHCHAI.BT.LocGroupD(DischGroupID)),3)
	    Set DischLocID	= $li(DischPatInfo,4)		//出院科室
	    Set DischWardID	= $li(DischPatInfo,5)		//出院病区
	    Set AdmDate		= $li(DischPatInfo,6)		//入院日期
	    Set DischDate	= $li(DischPatInfo,7)		//出院日期
	    
		//过滤院区
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,DischHospID)<1)
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=DischGroupID)
		//患者多耐信息
	    Set ListMRBArray=..GetPatMRBInfo(Paadm,AdmDate,DischDate,"",HAType)
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
			Continue:IsInfMRBFlag'=1
			Continue:MRBCode=""
			Continue:((aMRBCode'="")&&((aMRBCode'=MRBCode)&&(aMRBCode'=MRB2Code)))
			
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
			
			Set PatData =..BuildPaadmData(Paadm)
		    Continue:PatData=""
		    Set:MRB2Desc'="" MRBDesc=MRBDesc_","_MRB2Desc
		    
			Set Data=PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,MRBDesc,SpeDesc,BacDesc,ActDateTime,RepDateTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryMRBInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBInfDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2019-12-04
/// Description:  获取患者多耐信息
/// Table：       DHCHAI.IR.CCResult
/// Input:        aEpisodeID：就诊ID
/// return:       多耐信息
/// w ##class(DHCHAI.STATV2.S041MRBInf).GetPatMRBInfo("558","65300","65590")
ClassMethod GetPatMRBInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aHAType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aLocID,aHAType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set Count=0
	// Add by zhaoyj 2022-06-15 Global方式
	Set AdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:AdmData="" return
	Set AdmDate   = $lg(AdmData,20)
	Set AdmTime   = $lg(AdmData,21)
	Set EpisodeDr = aEpisodeID
    Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
		Quit:xItemID=""
		Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
		Continue:ItemData=""
		Set ItemCode=$lg(ItemData,2)
		Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
		
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
				Quit:xID=""
			
				Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
				Continue:RstData=""
				Continue:$lg(RstData,14)'=1
				Set ActDate=$lg(RstData,8)
				Set ActTime=$lg(RstData,9)
				Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  
				Set IPHourFlag=0             // 排除CA入院小于48小时
				Set:IPHour<48 IPHourFlag=1   // CA标志
				
				Set CCRepDate =$lg(RstData,11)
				Set CCRepTime =$lg(RstData,12)
				
				// 采集病区
			    Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			   	Set LocDr  = $p(LocWardInfo,"^",1) // 科室
				Set WardDr = $p(LocWardInfo,"^",2) // 病区
				Continue:(aLocID'="")&&(aLocID'=LocDr)&&(aLocID'=WardDr)
								
				Set ActDateTime = ActDate_" "_ActTime
				Set RepDateTime=CCRepDate_" "_CCRepTime
			
				Set MRBFlag=0  // 多耐菌标志
				Set MRBTpDr=$lg(RstData,24)
				Set MRBTp2Dr=$lg(RstData,31)
				If (MRBTpDr) {
					Set MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
					Set MRBID    = MRBTpDr
					Set MRBDesc  = $lg(MRBInfo,3)
					Set MRBCode  = $lg(MRBInfo,2)
				}Else {
					Set MRBID    = ""
					Set MRBDesc  = ""
					Set MRBCode  = ""
				}
				If (MRBTp2Dr) {
					Set MRB2Info=$g(^DHCHAI.IR.CRuleMRBD(MRBTp2Dr))
					Set MRB2ID    = MRBTp2Dr
					Set MRB2Desc  = $lg(MRB2Info,3)
					Set MRB2Code  = $lg(MRB2Info,2)
				}Else {
					Set MRB2ID    = ""
					Set MRB2Desc  = ""
					Set MRB2Code  = ""
				}
				Set:MRBDesc'="" MRBFlag=1
				Set SCode    = $lg(RstData,17)             // 子系统代码
		        Set Specimen = $lg(RstData,22)             // 原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set SpeMapID = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
				If (SpeMapID'="") {
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpeMapID))
					Set MapItemDr = $lg(SpecMapData,3)
					If (MapItemDr'="") {
						Set SpeID=MapItemDr
						Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
						Set:SpecData'="" SpeCode = $lg(SpecData,2)
						Set:SpecData'="" SpeDesc = $lg(SpecData,3)
					}
				}
				Set:SpeDesc="" SpeDesc=Specimen
	
		        Set Bacteria = $lg(RstData,23)    //原始细菌名称
		        Continue:Bacteria=""
		     	Set BactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
				Continue:BactMapID=""
				Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
				Set BacID = $lg(BactMapData,3)
				Continue:BacID=""
				Set BactData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Continue:BactData=""
				Set BacCode = $lg(BactData,2)
				Set BacDesc = $lg(BactData,3)
				
				Continue:'$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) //非多重耐药菌对应的细菌不记录
				Set xMRBTypeID="",MRBType="",MRBTypeList=""
				For {
					Set xMRBTypeID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,xMRBTypeID))
					Quit:xMRBTypeID=""
					Set RuleMRBInfo=$g(^DHCHAI.IR.CRuleMRBD(xMRBTypeID))
					Continue:RuleMRBInfo=""
					Continue:$lg(RuleMRBInfo,4)'=1   //过滤非有效标记
					Set MRBType=$lg(RuleMRBInfo,2)
					Set MRBTypeList=MRBTypeList_","_MRBType
				}
				Set:MRBTypeList'="" MRBTypeList=$e(MRBTypeList,2,$l(MRBTypeList))
				
				// 判断HA
				Set ResultID=$p($lg(RstData,19),"=",2)  // 检验结果ID	
				Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
				Continue:RepRstData=""
				Set LabInfType       = $lg(RepRstData,13)   //感染类型标记
				Set LabReportDr      = $lg(RepRstData,2)
				Continue:LabReportDr=""
				Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
				Continue:LabReportData=""
				//判断污染
				Set IsPollute=0
				Set:LabInfType=4 IsPollute=1
				
				Set IsInfMRBFlag=0 , IsDZFlag=0   // 感染、定植标志
				If (aHAType=1) { //只取院感报告
					Set:LabInfType'="" LabInfType=""
				}Else {
					Set:LabInfType=1 IsInfMRBFlag=1    //aHAType: 1,只取院感报告，2,只取标记感染类型，其他或空,取所有
					Set:LabInfType=3 IsDZFlag=1  
				}
				
				If (aHAType'=2)&(LabInfType="") {		     // 感染判断院感报告病原学检验病原体信息
					Set xINFId=""            
					For{
						Set xINFId=$o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",EpisodeDr,LabReportDr,xINFId))
						Quit:xINFId=""
						Continue:IsInfMRBFlag=1
											
						Set xReport=""
						For{
							Set xReport=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," DHCHAI.IR.INFLAB"," "_xINFId,xReport))
							Quit:xReport=""
			
							Set ReportInfo=$g(^DHCHAI.IR.INFReportD(xReport))
							Continue:ReportInfo=""
							Set IRRepType=$lg(ReportInfo,3)
							Continue:(IRRepType'=1)
							Set IRStatusDr=$lg(ReportInfo,8)
							Set DictionaryInfo=$g(^DHCHAI.BT.DictionaryD(IRStatusDr))
							Continue:DictionaryInfo=""
							Set StatusCode=$lg(DictionaryInfo,2)
							Continue:StatusCode'=3		//增加过滤不是审核的报告
						
							Set xBactDicDr=""
							For{
								Set xBactDicDr=$o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",xINFId,xBactDicDr))
								Quit:xBactDicDr=""
						    	Continue:xBactDicDr'=BacID   //判断是否报告的细菌
						    	Set IsInfMRBFlag=1
						    	Quit
							}
						}	
					}
				}
				If (aHAType'=1)&(aHAType'=2)&(IsInfMRBFlag=0) {   // 判断确诊信息
					Set xItmScreenDr=""
					For {
						Set xItmScreenDr=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr))
						Quit:xItmScreenDr=""
						Continue:IsInfMRBFlag=1	
										
						Set xBactDesc=""
						For {
							Set xBactDesc=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr,xBactDesc))
							Quit:xBactDesc=""
							Continue:$p(xBactDesc," ",2)'=BacDesc
							
							Set xScreeningID=""
							For {
								Set xScreeningID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr,xBactDesc,xScreeningID))
								Quit:xScreeningID=""
								
								Set xScrDtlID=""
								For {
									Set xScrDtlID=$o(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
									Quit:xScrDtlID=""
									
									Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
									Continue:ScreenDtl=""
									Set Status=$lg(ScreenDtl,2)
									Continue:Status'=1
								
									Set InfRepPosDr=$lg(ScreenDtl,4)
									Continue:InfRepPosDr=""
								    Set InfDiagInfo=$g(^DHCHAI.IR.INFDiagnosI(InfRepPosDr))
								    Continue:InfDiagInfo=""
								    Set IsActive=$lg(InfDiagInfo,17)
								    Continue:IsActive'=1
								    Set InfType=$lg(InfDiagInfo,18)
								    Continue:InfType'=1
								    Set IsInfMRBFlag=1
								    Quit
								}
							}
						}													
					}
				}
				
				If (LabInfType="")&&(IsInfMRBFlag=0) {  //定植判断排除记录
				 
					Set xItmScreenDr=""
					For {
						Set xItmScreenDr=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr))
						Quit:xItmScreenDr=""
						Continue:IsDZFlag=1	
								
						Set xBactDesc=""
						For {
							Set xBactDesc=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr,xBactDesc))
							Quit:xBactDesc=""
							Continue:$p(xBactDesc," ",2)'=BacDesc
							
							Set xScreeningID=""
							For {
								Set xScreeningID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeDr,xItmScreenDr,xBactDesc,xScreeningID))
								Quit:xScreeningID=""
								
								Set xScrDtlID=""
								For {
									Set xScrDtlID=$o(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
									Quit:xScrDtlID=""
									
									Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xScrDtlID))
									Continue:ScreenDtl=""							
									Set Status=$lg(ScreenDtl,2)
									Continue:Status'=2     //排除为定植，未判断是否第一次排除
								    Set IsDZFlag=1
								    Quit
								}
							}
						}													
					}				
				}
								
			   	Set Data=$lb(xID,MRBCode,MRBDesc,MRB2Code,MRB2Desc,SpeDesc,BacDesc,IPHourFlag,MRBFlag,IsInfMRBFlag,ActDateTime,RepDateTime,LocDr,WardDr,MRBTypeList,IsDZFlag,IsPollute)
			   	Set Count=Count+1
				Do return.SetAt(Data,Count)
			}
		}
	}
	Quit return
}

/// Creator：     zzlei
/// CreatDate：   2022-12-05
/// Description:  出院患者明细表(分母)
/// Table：       DHCHAI.DP.PAAdm
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey:维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S041MRBInf","QryMRBOutPatDtl","2020-07-01","2021-07-31","0001-07-0178-W-4","W")
Query QryMRBOutPatDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBOutPatDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String) As %Status
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
	Set:+aHospIDs=0 aHospIDs=""
	Set aLocType="",aLocDr=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	
    Set NIndex="QryMRBOutPatDtl"
	Kill ^TMP($zn,$j,NIndex)
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
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set AdmData =$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:AdmData=""
					
					// 出院科室/病区
					Set DishLocID = $li(AdmData,28)
				    Set DishWardID = $li(AdmData,29)
				    Set LocDr=DishLocID
				    Set:aStaType="W" LocDr=DishWardID
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Set HospDr=$li(LocData,8)
					//  医院过滤
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
					Set GroupDr  = $li(LocData,7)
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
					Continue:(aLocType'="")&(LocDr'=aLocDr)
					
					Set PatData=..BuildPaadmData(xPaadm)
					Continue:PatData=""
					
					Set Data=PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
}
		}
    }
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryMRBOutPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBOutPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBOutPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBOutPatDtlExecute ]
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
