/// 名称: DHCHAI.STATV2.S3TubeAdjInf
/// 描述: 三管相关调整感染率统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-12-02
Class DHCHAI.STATV2.S3TubeAdjInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-14
/// Description:  三管相关感染发病率统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeAdjInf","QryTubeInf","","2020-07-01","2020-07-31","W","1","UC","","")
Query QryTubeInf(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aTubeType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocDesc:%String,InCount:%Integer,InDays:%Integer,TubeCount:%Integer,TubeDays:%Integer,TubeRatio:%String,INFCount:%Integer,INFRatio:%String,PatCount:%Integer,ScoreSum:%String,AdvScore:%Float,AdjINFRatio:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aTubeType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	
	Set TubeType=aTubeType
	If (TubeType="PICC") {
		Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")
		Set:ICUPatLogSplit=1 TubeType="PICCs"
	}
	Set NIndex="QryTubeInf"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aLocType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
				
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}	
		
	    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I")
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
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
			}
			//计算插管人数+插管天数
			Set InDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
	    	Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",TubeType,aLocType)
	    	// 科室患者插管感染(不判断是否插管患者)
			Set InfPosInfo=##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,aTubeType,aDateFrom,aDateTo,LocDr,WardDr)
			
			Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
			For indDimens=1:1:$l(StatDimensInfo,"^") {
				Set DimensKey=$p(StatDimensInfo,"^",indDimens)
				Continue:DimensKey=""
				
				// 全院住院患者
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
					//同期在科人数
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
				}
				//同期在科天数
				Set:InDays>0 ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+InDays 
				If (LocCount>1) {
					// 合计住院患者
					If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
						//合计同期在科人数
						Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
						Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
					}
				}
		
				// 全院科室患者
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
					// 科室患者插管
					Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)=""	
					If (Days'=0){
						If ('$d(^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm))) {
							Set ^TMP($zn,$j,NIndex,DimensKey,"TubePat",Paadm)=""												
							Set Num=$i(^TMP($zn,$j,NIndex,DimensKey,"TubeCount"))
						}
						Set ^TMP($zn,$j,NIndex,DimensKey,"TubeDays")=$g(^TMP($zn,$j,NIndex,DimensKey,"TubeDays"))+Days
						
					    If $d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)) {
							    If ('$d(^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm))) {
								Set ^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm)=""												
								Set Num=$i(^TMP($zn,$j,NIndex,"Sum","TubeCount"))
							}
					    }
					}	
					// 科室患者插管感染(不判断是否插管患者)
					If (InfPosInfo'="") {
						Set InfCount=$Length(InfPosInfo,"|")
						Set ^TMP($zn,$j,NIndex,DimensKey,"InfCount")=$g(^TMP($zn,$j,NIndex,DimensKey,"InfCount"))+InfCount
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
		Continue:xDimensKey=""

		Set InCount  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set InDays		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InDays"))			//在科天数
		Set TubeCount	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeCount"))		//插管人数
		Set TubeDays	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"TubeDays"))			//插管天数
		Set INFCount	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCount"))			//感染例次数
		
		Continue:(IsActive=0)&&(InCount=0)	
		Continue:(aQryCon=2)&&(TubeDays=0)&&(INFCount=0)
		Continue:(aQryCon=3)&&(InDays=0)
 		
		Set TubeRatio="0.00%",INFRatio="0.000‰"
		Set:InDays>0 TubeRatio=$fn((TubeDays/InDays)*100,"",2)_"%"
		Set:TubeDays>0 INFRatio=$fn((INFCount/TubeDays)*1000,"",3)_"‰"
		
		If (LocCount>1) {  //科室合计
			Set InDaysSum=InDaysSum+InDays
			Set TubeDaysSum=TubeDaysSum+TubeDays
			Set TubeInfCntSum=TubeInfCntSum+INFCount
		}
		
		//调整发病率
		Set AdjINFRatio = "-"
		Set ICULevelArr = ..GetRiskLevel(LocDr,$zd(aDateFrom,3),$zd(aDateTo,3))	
		Set ScoreSum = $p(ICULevelArr,"^",1)			//总得分
		Set PatCount = $p(ICULevelArr,"^",2)			//评定人数
		Set AdvScore = $p(ICULevelArr,"^",3)			//平均危险等级系数
		If (AdvScore'=0) {
			Set:AdvScore>0 AdjINFRatio=$fn((INFRatio/AdvScore),"",3)_"‰"
		}
		Set Data=$lb(ind,xDimensKey,DimensDesc,InCount,InDays,TubeCount,TubeDays,TubeRatio,INFCount,INFRatio,PatCount,ScoreSum,AdvScore,AdjINFRatio)	

		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If (LocCount>1) {
		Set InCount  	=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set InDays		=InDaysSum											//在科天数
		Set TubeCount	=+$g(^TMP($zn,$j,NIndex,"Sum","TubeCount"))		    //插管人数
		Set TubeDays	=TubeDaysSum										//插管天数
		Set INFCount	=TubeInfCntSum										//感染例次数

		Set TubeRatio="0.00%",INFRatio="0.000‰"
		Set:InDays>0 TubeRatio=$fn((TubeDays/InDays)*100,"",2)_"%"
		Set:TubeDays>0 INFRatio=$fn((INFCount/TubeDays)*1000,"",3)_"‰"
	    
		Set Data=$lb(ind,"","全部",InCount,InDays,TubeCount,TubeDays,TubeRatio,INFCount,INFRatio,"-","-","-","-")	
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1

	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubeInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeInfExecute ]
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

/// Creator：     chenr
/// CreatDate：   2020-08-25
/// Title：ICU调整感染率统计表获取平均危险等级，评定人数，总评分
/// Input：       aLocID : 科室，aYYMM：月份  )
/// Return：      
/// w ##class(DHCHAI.STATV2.ICUAdOfInfect).GetRiskLevel("43","2020-07","2020-07")
ClassMethod GetRiskLevel(aLocID As %String, aSYYMM As %String, aEYYMM As %String) As %String
{
	New (aLocID,aSYYMM,aEYYMM)
	Set Return = ""
	
	Quit:(aSYYMM="")||(aEYYMM="")||(aLocID="") $$$OK
	
	Set xSYear=+$p(aSYYMM,"-",1)
	Set xSMonth=+$p(aSYYMM,"-",2)
	Set xEYear=+$p(aEYYMM,"-",1)
	Set xEMonth=+$p(aEYYMM,"-",2)
	Quit:(xSYear=0)||(xSMonth=0)||(xEYear=0)||(xEMonth=0) $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetRiskLevel"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set (TempPeopleNum,TempScore,APeopleNum,AScore,BPeopleNum,BScore) = 0
	If (xSYear=xEYear){
		Set xYear = xSYear
		For xMonth = xSMonth:1:xEMonth{
			Do BulidData
			Set TempPeopleNum =TempPeopleNum + TPeopleNum
			Set TempScore = TempScore + TScore
		}
	} Else {
		Set xYear = xSYear
		For xMonth = xSMonth:1:12{
			Do BulidData
			Set BPeopleNum =BPeopleNum + TPeopleNum
			Set BScore = BScore + TScore
		}
		If (xMonth=12){
			Set xYear = xEYear
			For xMonth = 1:1:xEMonth{
				Do BulidData
				Set APeopleNum =APeopleNum + TPeopleNum
				Set AScore = AScore + TScore
			}	
		}
		Set TempPeopleNum = APeopleNum + BPeopleNum
		Set TempScore = AScore + BScore
	}
	If TempPeopleNum'=0  Do
	.Set AvgICUGrade=$fn(TempScore/TempPeopleNum,"",2)
	.Set str=TempScore_"^"_TempPeopleNum_"^"_AvgICUGrade
	.Set Return = str
		
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit Return
	
BulidData
	For xWeek=1:1:5 {   //新版ICU危险等级评定可能出现5周的情况
		Set IGCountA=0,IGCountB=0,IGCountC=0,IGCountD=0,IGCountE=0
		Set xPaaId=0
		For {
			Set xPaaId=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,xYear,xMonth,xWeek,xPaaId))
			Quit:xPaaId=""
			
			Set xIGId=0
			For {
				Set xIGId=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,xYear,xMonth,xWeek,xPaaId,xIGId))
				Quit:xIGId=""
				
				Set ICUGradeData=$g(^DHCHAI.IR.ICUGradeD(xIGId))
				Continue:ICUGradeData=""
				Set IGItem1 = $lg(ICUGradeData,7)
				Set IGItem2 = $lg(ICUGradeData,8)
				Set IGItem3 = $lg(ICUGradeData,9)
				Set IGItem4 = $lg(ICUGradeData,10)
				Set IGItem5 = $lg(ICUGradeData,11)
				
				Set:IGItem1=1 IGCountA=IGCountA+1
				Set:IGItem2=1 IGCountB=IGCountB+1
				Set:IGItem3=1 IGCountC=IGCountC+1
				Set:IGItem4=1 IGCountD=IGCountD+1
				Set:IGItem5=1 IGCountE=IGCountE+1
				
			}
		}
		Set ^TMP(ZIndex,JIndex,NIndex,"A",xWeek)=IGCountA
		Set ^TMP(ZIndex,JIndex,NIndex,"B",xWeek)=IGCountB
		Set ^TMP(ZIndex,JIndex,NIndex,"C",xWeek)=IGCountC
		Set ^TMP(ZIndex,JIndex,NIndex,"D",xWeek)=IGCountD
		Set ^TMP(ZIndex,JIndex,NIndex,"E",xWeek)=IGCountE
	}
	
	Set ItemGradeList=$lb("A","B","C","D","E")
	Set ItemScoreList=$lb(1,2,3,4,5)
	Set (TPeopleNum,AvgICUGrade,TScore)=0
	For indGrade=1:1:5 {
		Set ItemGrade=$lg(ItemGradeList,indGrade)
		//危险等级ItemGrade每周人数
		Set IGCount1=$g(^TMP(ZIndex,JIndex,NIndex,ItemGrade,1))
		Set IGCount2=$g(^TMP(ZIndex,JIndex,NIndex,ItemGrade,2))
		Set IGCount3=$g(^TMP(ZIndex,JIndex,NIndex,ItemGrade,3))
		Set IGCount4=$g(^TMP(ZIndex,JIndex,NIndex,ItemGrade,4))
		Set IGCount5=$g(^TMP(ZIndex,JIndex,NIndex,ItemGrade,5))
		
		Set TPeopleNum =TPeopleNum+IGCount1 + IGCount2 + IGCount3 + IGCount4 +IGCount5
		Set TScore = TScore + ((IGCount1 + IGCount2 + IGCount3+ IGCount4+ IGCount5)*indGrade)
	}
	Quit
}

}
