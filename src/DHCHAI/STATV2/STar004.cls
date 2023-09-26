/// 名称: DHCHAI.STATV2.STar004
/// 描述: 2015十三项指标(4)->多重耐药菌感染发现率
/// 编写者: ShenC
/// 编写日期: 2021-02-04
Class DHCHAI.STATV2.STar004 Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：		ShenC
/// CreateDate：	2022-06-17
/// Description:	多重耐药菌感染发现率
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期
///                 aStaType : 统计类型E：科室W：病区 
/// 		 	    aQryCon  : 是否仅显示有数据的科室
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.STar004","QryMRBInf","1","2020-05-01","2020-08-31","W","2")
Query QryMRBInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,MRSAPat:%String,MRSAPatCase:%String,MRSAPatRatio:%String,MRSACaseRatio:%String,VREPat:%String,VREPatCase:%String,VREPatRatio:%String,VRECaseRatio:%String,CREPat:%String,CREPatCase:%String,CREPatRatio:%String,CRECaseRatio:%String,CRABPat:%String,CRABPatCase:%String,CRABPatRatio:%String,CRABCaseRatio:%String,CEPAPat:%String,CEPAPatCase:%String,CEPAPatRatio:%String,CEPACaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	//转换日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")
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
 	Set NIndex="QryMRBInf"
	Kill ^TMP($zn,$j,NIndex)
	
	Set HospCount = $l(aHospIDs,"|")
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
	    Set ListMRBArray=..GetPatMRBInfo(Paadm,TransDate,EndDate,LocID,HAType)
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
		
			Set MRBLocID=$LIST(MRBInfo,13)
			Set MRBWardID=$LIST(MRBInfo,14)
			If TransType="E" {					//过滤转科导致的重复数据
				Continue:LocID'=MRBLocID
			} Else {
				Continue:LocID'=MRBWardID
			}
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
				
				//add 20211129 新增多耐分类
				Set ^TMP($zn,$j,NIndex,DimensKey,"P3Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"P3Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"P3Pat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"P4Pat")=$g(^TMP($zn,$j,NIndex,DimensKey,"P4Pat"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"P4Pat"))			
				Set ^TMP($zn,$j,NIndex,DimensKey,"P3PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"P3PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"P3PatCase"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"P4PatCase")=$g(^TMP($zn,$j,NIndex,DimensKey,"P4PatCase"))+$g(^TMP($zn,$j,NIndex,"MRB",LocID,Paadm,"P4PatCase"))
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
		Continue:(xDimensKey["A")&(HospCount="1")
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))    //住院患者人数
		
		//MRSA
		Set MRSAPat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1Pat"))     //同期检出导致医院感染的MRSA的人数
		Set MRSAPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M1PatCase")) //同期检出导致医院感染的MRSA的例次数
		Set MRSAPatRatio="0.00%"
		Set:PatAdmCnt>0 MRSAPatRatio=$fn((MRSAPat/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染发生率
		Set MRSACaseRatio="0.00%"
		Set:PatAdmCnt>0 MRSACaseRatio=$fn((MRSAPatCase/PatAdmCnt)*100,"",2)_"%" //MRSA医院感染例次发生率
		//VRE
		Set M2Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2Pat"))     //同期检出导致医院感染的VRE的人数
		Set M3Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3Pat"))     //同期检出导致医院感染的VRE的人数
		Set P3Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P3Pat"))     //同期检出导致医院感染的VRE的人数
		Set VREPat=M2Pat+M3Pat+P3Pat
		
		Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M2PatCase")) //同期检出导致医院感染的VRE的例次数
		Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M3PatCase")) //同期检出导致医院感染的VRE的例次数
		Set P3PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P3PatCase"))
		Set VREPatCase=M2PatCase+M3PatCase+P3PatCase
		
		Set VREPatRatio="0.00%"
		Set:PatAdmCnt>0 VREPatRatio=$fn((VREPat/PatAdmCnt)*100,"",2)_"%" ////VRE医院感染发生率
		Set VRECaseRatio="0.00%"
		Set:PatAdmCnt>0 VRECaseRatio=$fn((VREPatCase/PatAdmCnt)*100,"",2)_"%" //VRE医院感染例次发生率

		//CRE
		Set M6Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6Pat"))     //同期检出导致医院感染的CRE的人数
		Set M7Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7Pat"))     //同期检出导致医院感染的CRE的人数
		Set P4Pat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P4Pat"))
		Set CREPat=M6Pat+M7Pat+P4Pat
		
		Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M6PatCase")) //同期检出导致医院感染的CRE的例次数
		Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M7PatCase")) //同期检出导致医院感染的CRE的例次数
		Set P4PatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"P4PatCase"))
		Set CREPatCase=M6PatCase+M7PatCase+P4PatCase
		
		Set CREPatRatio="0.00%"
		Set:PatAdmCnt>0 CREPatRatio=$fn((CREPat/PatAdmCnt)*100,"",2)_"%" //CRE医院感染发生率
		Set CRECaseRatio="0.00%"
		Set:PatAdmCnt>0 CRECaseRatio=$fn((CREPatCase/PatAdmCnt)*100,"",2)_"%" //CRE医院感染例次发生率
		//CRAB
		Set CRABPat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8Pat"))     //同期检出导致医院感染的CR-AB的人数
		Set CRABPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M8PatCase")) //同期检出导致医院感染的CR-AB的例次数
		Set CRABPatRatio="0.00%"
		Set:PatAdmCnt>0 CRABPatRatio=$fn((CRABPat/PatAdmCnt)*100,"",2)_"%" //CRAB医院感染发生率
		Set CRABCaseRatio="0.00%"
		Set:PatAdmCnt>0 CRABCaseRatio=$fn((CRABPatCase/PatAdmCnt)*100,"",2)_"%" //CRAB医院感染例次发生率
		//CEPA
		Set CEPAPat      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9Pat"))     //同期检出导致医院感染的CEPA的人数
		Set CEPAPatCase  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"M9PatCase")) //同期检出导致医院感染的CEPA的例次数
		Set CEPAPatRatio="0.00%"
		Set:PatAdmCnt>0 CEPAPatRatio=$fn((CEPAPat/PatAdmCnt)*100,"",2)_"%" //CEPA医院感染发生率
		Set CEPACaseRatio="0.00%"
		Set:PatAdmCnt>0 CEPACaseRatio=$fn((CEPAPatCase/PatAdmCnt)*100,"",2)_"%" //CEPA医院感染例次发生率
	
		Set MRBCount=MRSAPat+VREPat+CREPat+CRABPat+CEPAPat		
		//Continue:(IsActive'=1)&&(PatAdmCnt=0)
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(PatAdmCnt=0)
		Continue:(aQryCon=2)&&(MRBCount=0)		
		Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
        
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,MRSAPat,MRSAPatCase,MRSAPatRatio,MRSACaseRatio,VREPat,VREPatCase,VREPatRatio,VRECaseRatio,CREPat,CREPatCase,CREPatRatio,CRECaseRatio,CRABPat,CRABPatCase,CRABPatRatio,CRABCaseRatio,CEPAPat,CEPAPatCase,CEPAPatRatio,CEPACaseRatio)
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

/// Creator：		zhoubo
/// CreateDate：	2019-12-03
/// Description:	多重耐药菌感染发现率分子明细表
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:		    aDateFrom：开始日期
/// 			    aDateTo：  结束日期 
/// 			    aDimensKey: 维度
/// 			    aMRBCode : 多耐分类代码
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.STar004","QryMRBInfDtl","2020-05-01","2020-08-31","0001-07-0000-G-3-W","M3")
Query QryMRBInfDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aStatType As %String = "W") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,ActDateTime:%String,RepDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryMRBInfDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aMRBCode As %String, aStatType As %String = "W") As %Status
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
	Set:aMRBCode="M1" aMRBCode="M1"
	Set:aMRBCode="M2" aMRBCode="M2|M3"
	Set:aMRBCode="M3" aMRBCode="M6|M7"
	Set:aMRBCode="M4" aMRBCode="M8"
	Set:aMRBCode="M5" aMRBCode="M9"
	
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)

	Set StatType=aLocType
	Set:StatType="" StatType=$p(aDimensKey,"-",$l(aDimensKey,"-"))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	Set HAType=##class(DHCHAI.BT.Config).GetValByCode("MDROInfRatioHAType")

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
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc",GroupDesc,0))
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&(LocDr'=aLocDr)
		
		Set TransDate = $p(TransDates,",",1)
		Set EndDate   = $p(TransDates,",",$l(TransDates,","))
		Set:(TransDate>aDateFrom)&&(TransDate<aDateTo) TransDate=TransDate-1
		//患者7.4入普外科，7.17上午10转入ICU，7.20转入普外科，转科记录普外科(7.5,……,7.17，7.21……),ICU(7.18,7.19,7.20),ICU科室7.17晚上23点送检并检出多耐，17号的送检会漏
		//患者多耐信息
	    Set ListMRBArray=..GetPatMRBInfo(Paadm,TransDate,EndDate,LocID,HAType)
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
			Continue:(aMRBCode'="")&&(((aMRBCode'[MRBCode)&&(MRB2Code=""))||((aMRBCode'[MRB2Code)&&(MRB2Code'="")))
		
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
/// CreatDate：   2022-06-17
/// Description:  获取患者多耐信息
/// Table：       DHCHAI.IR.CCResult
/// Input:        aEpisodeID：就诊ID
/// return:       多耐信息
/// w ##class(DHCHAI.STATV2.S040MRBInf).GetPatMRBInfo("3764","65300","65590")
ClassMethod GetPatMRBInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aHAType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aLocID,aHAType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set Count=0
	// Add by zhaoyj 2022-06-17 Global方式
	Set AdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:AdmData="" return
	Set AdmDate   = $lg(AdmData,20)
	Set AdmTime   = $lg(AdmData,21)
	Set EpisodeDr = aEpisodeID
    Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID))
		Quit:xItemID=""
		Set ItemData = $g(^DHCHAI.IR.CCItmMastD(xItemID))
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
		        Set Specimen = $lg(RstData,22)          // 原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set SpeMapID = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
				If (SpeMapID'="") {
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpeMapID))
					Set MapItemDr = $lg(SpecMapData,3)
					If (MapItemDr'="") {
						Set SpeID=MapItemDr
						Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
						Set:SpecData'="" SpeCode = $lg(SpecData,2)
						Set:SpecData'="" SpecDesc = $lg(SpecData,3)
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
				
				Set IsInfMRBFlag=0   // 感染标志
				If (aHAType=1) { //只取院感报告
					Set:LabInfType'="" LabInfType=""
				}Else {
					Set:LabInfType=1 IsInfMRBFlag=1    //aHAType: 1,只取院感报告，2,只取标记感染类型，其他或空,取所有
				}
				
				If (aHAType'=2)&(LabInfType="") {		 // 判断院感报告病原学检验病原体信息
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
									Set xScrDtlID=$o(^DHCHAI.IR.CCScreeningI(xScreeningID,"Dtl",xScrDtlID))
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
			   	Set Data=$lb(xID,MRBCode,MRBDesc,MRB2Code,MRB2Desc,SpeDesc,BacDesc,IPHourFlag,MRBFlag,IsInfMRBFlag,ActDateTime,RepDateTime,LocDr,WardDr,MRBTypeList)
			   	Set Count=Count+1
				Do return.SetAt(Data,Count)
			}
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-12-10
/// Description:  住院患者明细表(分母)
/// Table：       DHCHAI.DP.PAAdm
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// 			  aDimensKey:维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S040MRBInf","QryMRBInfPatDtl","2019-03-01","2019-03-01","0000-00-0000-A-1")
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
	//同期在科、在病区
	Set StatType=aLocType
	Set:StatType="" StatType=$p(aDimensKey,"-",$l(aDimensKey,"-"))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
	//同期在科/病区:某段时间的在科人数
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
		Set LocDesc	= $lg(LocData,3)
		Set HospDr	= $lg(LocData,8)
		//医院分组过滤
		Continue:HospDr=""
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5)
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)      
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
		Continue:(aLocType'="")&&(LocDr'=aLocDr)
		
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    For xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $lg(TranData,7)
		    Set OutLocDate	= $lg(TranData,10)
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
			Set TransTime 	= $lg(TranData,8)
		    Set:TransTime'="" TransTime=$zt(TransTime)
		    Set OutLocTime 	= $lg(TranData,11)
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
