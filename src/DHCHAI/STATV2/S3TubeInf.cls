/// 名称: DHCHAI.STATV2.S3TubeInf
/// 描述: 三管相关感染发病率统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-12-02
Class DHCHAI.STATV2.S3TubeInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
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
///               aStatDimens:  展示维度    //add 20221018 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeInf","QryTubeInf","","2022-05-01","2022-05-31","W","1","PICC","","")
Query QryTubeInf(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aLocType As %String = "E", aQryCon As %String = "1", aTubeType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocDesc:%String,InCount:%Integer,InDays:%Integer,TubeCount:%Integer,TubeDays:%Integer,TubeRatio:%String,INFCount:%Integer,INFRatio:%String") [ SqlProc ]
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

	Set NIndex="QryTubeInf"
	Kill ^TMP($zn,$j,NIndex)
	
    //同期在科
    Set (InDaysSum,TubeDaysSum,TubeInfCntSum)=0
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
	    	Set Days=..GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aLocType)
	    
	    	// 科室患者插管感染(不判断是否插管患者)
			Set InfPosInfo=..GetTubeInf(Paadm,aTubeType,aDateFrom,aDateTo,LocDr,WardDr)
	       
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
						If (LocCount>1) {
						    If $d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)) {
								    If ('$d(^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm))) {
									Set ^TMP($zn,$j,NIndex,"Sum","TubePat",Paadm)=""												
									Set Num=$i(^TMP($zn,$j,NIndex,"Sum","TubeCount"))
								}
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

	//zw ^TMP($zn,$j,NIndex,"0001-00-0000-H-2","TubePat")
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
		
		Set Data=$lb(ind,xDimensKey,DimensDesc,InCount,InDays,TubeCount,TubeDays,TubeRatio,INFCount,INFRatio)
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
	
		Set Data=$lb(ind,"","全部",InCount,InDays,TubeCount,TubeDays,TubeRatio,INFCount,INFRatio)
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

/// 获取插管感染信息
/// 返回插管相关感染日期
/// w ##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf("615","VAP",$zdh("2020-05-01",3),$zdh("2020-05-31",3),43)
ClassMethod GetTubeInf(aPaadm As %String, aTubeType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aWardID As %String = "") As %String
{
	new (aPaadm,aTubeType,aDateFrom,aDateTo,aLocID,aWardID)
	//数据来源1 院感报告 
	//血管导管相关血流感染 判断规则：诊断子分类为 导管相关血流感染
	//导尿管相关泌尿道感染 判断规则：诊断子分类为 导尿管相关泌尿系感染
	//呼吸机相关肺炎       判断规则：诊断子分类为 呼吸机相关性肺炎
	Set return=""
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate))
		Quit:xDate=""
		Continue:xDate>aDateTo
		
		Set xRowID=""
		For {
			Set xRowID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aPaadm,xDate,xRowID))
			Quit:xRowID=""
			
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xRowID,xRepID))
				Quit:xRepID=""
		
				Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
				Continue:RepData=""

				Set IRStatusDr=$lg(RepData,8)
				Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
				Continue:(RepStatus'=3) ;审核
				Set InfPos=$g(^DHCHAI.IR.INFDiagnosD(xRowID))
				Set IRInfSubDr=$lg(InfPos,4)
				Continue:IRInfSubDr=""
				Set InfSubDiag=$lg($g(^DHCHAI.BT.InfSubD(IRInfSubDr)),3)
				Set InfType=$lg(InfPos,18)
				Continue:InfType=0
		
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aPaadm,xDate,"00:00:01")
				If (aWardID'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardID)				
				}
				If (aLocID'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocID)
				}
			
				Set IRInfPosDr=$lg(InfPos,3)
				Set IRInfPos=""
				If (IRInfPosDr'=""){
					Set IRInfPosData=$g(^DHCHAI.BT.InfPosD(IRInfPosDr))
					Set:IRInfPosData'="" IRInfPos = $lg(IRInfPosData,3)
				}
				Set IRInfEffectDr=$lg(InfPos,8)
				Set IRInfEffect=""
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" IRInfEffect = $lg(IRInfEffectData,3)
				}
			
				Set IRInfXDate=$lg(InfPos,7)
				If (aTubeType="PICC")&&(InfSubDiag["CLABSI") { 
					Set return=return_"|"_xDate_"^"_IRInfPos_"^"_IRInfEffect_"^"_IRInfXDate_"^"_xRowID
				}ElseIf (aTubeType="UC")&&(InfSubDiag["CA-UTI") { 
					Set return=return_"|"_xDate_"^"_IRInfPos_"^"_IRInfEffect_"^"_IRInfXDate_"^"_xRowID
				}ElseIf (aTubeType="VAP")&&(InfSubDiag["VAP") { 
					Set return=return_"|"_xDate_"^"_IRInfPos_"^"_IRInfEffect_"^"_IRInfXDate_"^"_xRowID
				}ElseIf ((aTubeType="")||(aTubeType="ALL"))&&(((InfSubDiag["CLABSI"))||(InfSubDiag["CA-UTI")||(InfSubDiag["VAP") ) {
					Set return=return_"|"_xDate_"^"_IRInfPos_"^"_IRInfEffect_"^"_IRInfXDate_"^"_xRowID
				}
			}
		}
	}

	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-05-18
/// Description:  三管统计住院患者明细
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20221026 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aStaType :  科室类型 add20210715 防止科室、病区分组不一致时导致汇总与明细数据不一致
/// 			  aTubeType :  三管类型
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeInf","QryTubePatDtl","","2022-05-01","2022-05-31","0001-00-0000-H-2","W","PICC")
Query QryTubePatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryTubePatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 
    Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")	
	
    Set NIndex="QryTubePatDtl"
	Kill ^TMP($zn,$j,NIndex)
    		
	//同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aLocDr'="")&(aLocDr'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))

		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set LocDesc	= $lg(LocData,3)
		Set LocDesc2= $lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set HospDr=$lg(LocData,8)
		Continue:HospDr=""
		//医院过滤
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		//医院分组过滤
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5) 
		Continue:HospGroupDr="" 
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
		Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
		
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

		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I")
	    For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2=$lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
            //插管过滤
			Set Days=..GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)

			For xTransInd=1:1:$l(TransIDs,",") {
			    Set TransID=$p(TransIDs,",",xTransInd)
			    Continue:TransID=""
			    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			    Set TransDate	= $li(TranData,7)
			    Set OutLocDate	= $li(TranData,10)
			    Set TransTime	= $li(TranData,8)
				Set OutLocTime	= $li(TranData,11)
				//如果转科起止日期大于统计日期，以统计日期计算
				Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
				Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
				Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
				
				//转换转科日期格式
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		        Set:TransTime'="" TransTime=$zt(TransTime)
			    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    	Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
									
				Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime,Days)	
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubePatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubePatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubePatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubePatDtlExecute ]
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
/// CreatDate：   2020-05-18
/// Description:  发生三管感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeInf","QryTubeInfDtl","1|2","2022-05-01","2022-10-31","0000-00-0000-A-1","W","UC","")
Query QryTubeInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,EffectDesc:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryTubeInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 
    Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")	
	
	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QryTubeInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aLocDr'="")&(aLocDr'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
		
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set LocDesc	= $lg(LocData,3)
		Set LocDesc2= $lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set HospDr=$lg(LocData,8)
		Continue:HospDr=""
		//医院过滤
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		//医院分组过滤
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5) 
		Continue:HospGroupDr="" 
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
		Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
		
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

		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I")
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
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmDate = $lg(AdmData,20)    //就诊日期 
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
            //插管过滤  与汇总报表一致，不判断是否插管患者
			Set Days=..GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)		         	
			For xTransInd=1:1:$l(TransIDs,",") {
			    Set TransID=$p(TransIDs,",",xTransInd)
			    Continue:TransID=""
			    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			    Set TransDate	= $li(TranData,7)
			    Set OutLocDate	= $li(TranData,10)
			    Set TransTime	= $li(TranData,8)
				Set OutLocTime	= $li(TranData,11)
				//如果转科起止日期大于统计日期，以统计日期计算
				Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
				Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
				Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
		
              	Set (InfDatas,InfData,TubeInfos,TubeInfo)=""
	            Set TubeInfInfo =##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,aTubeType,DateFrom,DateTo,LocDr,WardDr)
	            Continue:TubeInfInfo=""		
				For InfNo=1:1:$L(TubeInfInfo,"|") {
					Set InfPosMsg=$p(TubeInfInfo,"|",InfNo)
					Continue:InfPosMsg=""
					Set InfDate	= $p(InfPosMsg,"^",1)
					Set DiagID= $p(InfPosMsg,"^",5)
					//记录感染信息,加入转科记录，防止转回原科室后，仍显示感染信息
					Continue:$d(^TMP($zn,$j,NIndex,"InfPat",LocID,Paadm,DiagID))   
					Set ^TMP($zn,$j,NIndex,"InfPat",LocID,Paadm,DiagID)=""
			
					Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
				    Continue:DiagData=""
				    Set InfPosDr = $lg(DiagData,3)
				    Continue:InfPosDr=""
				    Set InfPosDic=$g(^DHCHAI.BT.InfPosD(InfPosDr))
					Set InfPosDesc=$lg(InfPosDic,3)
				    Set InfDate	= $lg(DiagData,5)
				    Set EffectDr = $lg(DiagData,8)
				    Set EffectDesc=""
				    If (EffectDr'="") {
				    	Set EffectDic=$g(^DHCHAI.BT.DictionaryD(EffectDr))
						Set EffectDesc=$lg(EffectDic,3)
					}
					Set InfXDate	= $lg(DiagData,7)
					Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
					Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
						
					Set InfType="医院感染"
					Set InfTypeCode=$lg(DiagData,18)
					if (InfTypeCode'=""){
						Set:InfTypeCode=0 InfType="社区感染"
					}else{
				   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
					}
				    Set InfData=$lb(DiagID,InfPosDesc,InfDate,InfType,EffectDesc,InfXDate)
				    Set InfDatas=InfDatas_$lb(InfData)
				}
				Continue:($ll(InfDatas)=0) 
				
				//转换转科日期格式
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		        Set:TransTime'="" TransTime=$zt(TransTime)
			    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    	Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
				Set TransInfo=$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
				Set TubeArr=..GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
				For ArrInd=1:1:TubeArr.Count(){
					Set TubeInfo=TubeArr.GetAt(ArrInd)
					Set TubeInfos=TubeInfos_$lb(TubeInfo)
				}
				Set Len=$ll(InfDatas)
				Set:($ll(TubeInfos)>Len) Len=$ll(TubeInfos)
				
				For LenInd=1:1:Len {
					Set InfData=$lg(InfDatas,LenInd)
					Set:InfData="" InfData=$lb("","","","","","")
					Set TubeInfo=$lg(TubeInfos,LenInd)
					Set:TubeInfo="" TubeInfo=$lb("","","","","","","","","")
			
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days)_TubeInfo_InfData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	    }
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTubeInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeInfDtlExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-03-15
/// Description:  三管使用明细
/// Table：       DHCHAI.IR.ICULogDtl
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC			// 0001-07-0099-W-4,0000-00-0000-A-1
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeInf","QryTubeDayDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","W","PICCs")
Query QryTubeDayDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TranLocID:%String,TranLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTubeDayDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aTubeType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="")||(aTubeType="") $$$OK

	//处理日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 
    Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")	

	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QryTubeDayDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	//同期在科
    Set TypeDr=$o(^DHCHAI.BT.DicTypeI("IdxofCode","LocType",0))
    Quit:TypeDr="" $$$OK
    Set LocTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aStaType,0))
    Quit:LocTypeDr="" $$$OK
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",LocTypeDr,xLocID))
		Quit:xLocID=""
		Continue:(aLocDr'="")&(aLocDr'=xLocID)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
					
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Set LocDesc	= $lg(LocData,3)
		Set LocDesc2= $lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set HospDr=$lg(LocData,8)
		Continue:HospDr=""
		//医院过滤
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		//医院分组过滤
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5) 
		Continue:HospGroupDr="" 
		Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr) 
		Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(HospGroupDr))     
		
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

		Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aStaType,xLocID,"I")
	    For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set PatData =..BuildPaadmData(Paadm)
   			Continue:PatData=""
            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
            Set AdmTimes = $lg(AdmData,38)   //就诊次数
			Set Days=..GetICUDays(LocID,Paadm,aDateFrom,aDateTo,"",aTubeType,aStaType)
			Continue:Days=0    
		  
			For xTransInd=1:1:$l(TransIDs,",") {
			    Set TransID=$p(TransIDs,",",xTransInd)
			    Continue:TransID=""
			    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			    Set TransDate	= $li(TranData,7)
			    Set OutLocDate	= $li(TranData,10)
			    Set TransTime	= $li(TranData,8)
				Set OutLocTime	= $li(TranData,11)
				//如果转科起止日期大于统计日期，以统计日期计算
				Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
				Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
				Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""

				//转换转科日期格式
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		        Set:TransTime'="" TransTime=$zt(TransTime)
			    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    	Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
				Set TransInfo=$lb(TransID,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
				//取三管医嘱信息
				Set TubeArr=..GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,aTubeType,ICUPatLogSplit)
				If (TubeArr.Count()>0) {
					For ArrInd=1:1:TubeArr.Count(){
						Set TubeInfo=TubeArr.GetAt(ArrInd)
					
					   	Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days)_TubeInfo
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}Else {   //有插管记录但无插管医嘱
					Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(Days,"","","","","","","","","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
	}
	Quit $$$OK
}

ClassMethod QryTubeDayDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeDayDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeDayDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeDayDtlExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-11-01
/// Description:  患者三管医嘱明细
/// Table：       DHCHAI.IR.ICULogDtl
/// Input:		  aEpisodeID: 就诊ID
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 		  
/// 			  aTubeType :  三管类型
/// Return：      返回ROWSPEC			
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S3TubeInf","QryTubeOrdItem","3921","2020-10-01","2020-12-31","VAP")
Query QryTubeOrdItem(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTubeType As %String) As %Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTubeOrdItemExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTubeType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="")||(aTubeType="") $$$OK

	//处理日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK

	// ICUPatLogSplit ICU患者日志中心静脉置管是否需要拆分
	Set ICUPatLogSplit = ##class(DHCHAI.BT.Config).GetValByCode("ICUPatLogSplit")

    Set NIndex="QryTubeOrdItem"
	Kill ^TMP($zn,$j,NIndex)
	
	Set PatData =..BuildPaadmData(aEpisodeID)
	Quit:PatData="" $$$OK
	
	//取三管医嘱信息
	Set TubeArr=..GetTubeOrderItem(aEpisodeID,aDateFrom,aDateTo,"","",aTubeType,ICUPatLogSplit)
	Quit:(TubeArr.Count()=0) $$$OK
	For ArrInd=1:1:TubeArr.Count(){
		Set TubeInfo=TubeArr.GetAt(ArrInd)
	
	   	Set Data =PatData_TubeInfo
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
			 
	Quit $$$OK
}

ClassMethod QryTubeOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTubeOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeOrdItemExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-09-28
/// Description:  科室患者插管天数
/// Table：       
/// Input：       aLocID:科室ID,aEpisodeID:患者ID,aDateFrom:开始日期,aDateTo"结束日期,aWtCat:体重分类(0:成人,1/2/3/4新生儿体重分类),aTubeType(置管类型)
/// Return：      返回 Count
/// w ##class(DHCHAI.STATV2.S3TubeInf).GetICUDays("",2333,$zdh("2020-05-01",3),$zdh("2020-05-31",3),"","ALL","W")
ClassMethod GetICUDays(aLocID As %String, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aWtCat As %String = "", aTubeType As %String, aLocType As %String = "")
{
	New (aLocID,aEpisodeID,aDateFrom,aDateTo,aWtCat,aTubeType,aLocType)
	Set Days=0  //变量初始化
	Set return=0 
	Quit:(aEpisodeID="")||(aTubeType="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Set NIndex="GetICUDays"
	Kill ^TMP($zn,$j,NIndex)
		
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	//过滤体重分类
	Set WtCat=5   //初始未分组为5
	Set IsNewBaby=$lg(PAAdmData,32)
	Set Weigth=+$lg(PAAdmData,34)
	Set:(Weigth<=1000)&&(Weigth>0) WtCat=1
	Set:(Weigth>1000)&(Weigth<=1500) WtCat=2
	Set:(Weigth>1500)&(Weigth<=2500) WtCat=3
	Set:(Weigth>2500) WtCat=4	
	Quit:(aWtCat'="")&&(aWtCat'=WtCat) return	
	
	//记录插管天数
	If (aLocID=""){
		For xDate=aDateFrom:1:aDateTo {
			Set xDtlID=""
			For {
				Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate,aEpisodeID,xDtlID))
				Quit:xDtlID=""		
			
				Set LogDtlData=$g(^DHCHAI.IR.ICULogDtlD(xDtlID))
				Continue:LogDtlData=""
			
				Set ILLocDr=$lg(LogDtlData,3)
				Set LocData=$g(^DHCHAI.BT.LocationD(ILLocDr))
				Continue:LocData=""
				Set LocType=""
				Set BTTypeDr = $lg(LocData,5)
				Set LocTypeData=$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
				If (LocTypeData'=""){
					Set LocType=$lg(LocTypeData,2)
				}
				Continue:(aLocType'="")&&(aLocType'=LocType)

				Set IsVAP  =$lg(LogDtlData,5)
				Set IsPICC =$lg(LogDtlData,6)
				Set IsUC   =$lg(LogDtlData,7)
				Set IsCVC  =$lg(LogDtlData,10)
				Set IsCRRT =$lg(LogDtlData,11)
				Set IsPORT =$lg(LogDtlData,12)

				//使用呼吸机天数
				If ((aTubeType="ALL")||(aTubeType="VAP"))&&(IsVAP=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//使用导尿管天数
				If ((aTubeType="ALL")||(aTubeType="UC"))&&(IsUC=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				
				//使用脐/中心静脉置管天数
				If (aTubeType="PICC")&&(IsPICC=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//中心静脉置管(CVC)置管天数
				If (aTubeType="CVC")&&(IsCVC=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//中心静脉置管(CRRT)置管天数
				If (aTubeType="CRRT")&&(IsCRRT=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//中心静脉置管(PORT)置管天数
				If (aTubeType="PORT")&&(IsPORT=1){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//中心静脉置管插管天数
				If (aTubeType="PICCs")&&((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				//全部插管天数（3三大管合计）
				If (aTubeType="ALL")&&((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)){
					Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
				}
				
			}
		}
	} Else {
		For xDate=aDateFrom:1:aDateTo {
			Set xDtlID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",aLocID,xDate,aEpisodeID,""))
			Continue:xDtlID=""
			
			Set LogDtlData=$g(^DHCHAI.IR.ICULogDtlD(xDtlID))
			Continue:LogDtlData=""
			
			Set ILLocDr=$lg(LogDtlData,3)
			Set LocData=$g(^DHCHAI.BT.LocationD(ILLocDr))
			Continue:LocData=""
			Set LocType=""
			Set BTTypeDr = $lg(LocData,5)
			Set LocTypeData=$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
			If (LocTypeData'=""){
				Set LocType=$lg(LocTypeData,2)
			}
			Continue:(aLocType'="")&&(aLocType'=LocType)
			
			Set IsVAP  =$lg(LogDtlData,5)
			Set IsPICC =$lg(LogDtlData,6)
			Set IsUC   =$lg(LogDtlData,7)
			Set IsCVC  =$lg(LogDtlData,10)
			Set IsCRRT =$lg(LogDtlData,11)
			Set IsPORT =$lg(LogDtlData,12)

			//使用呼吸机天数
			If ((aTubeType="ALL")||(aTubeType="VAP"))&&(IsVAP=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//使用导尿管天数
			If ((aTubeType="ALL")||(aTubeType="UC"))&&(IsUC=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
				
			//使用脐/中心静脉置管天数
			If (aTubeType="PICC")&&(IsPICC=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//中心静脉置管(CVC)置管天数
			If (aTubeType="CVC")&&(IsCVC=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//中心静脉置管(CRRT)置管天数
			If (aTubeType="CRRT")&&(IsCRRT=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//中心静脉置管(PORT)置管天数
			If (aTubeType="PORT")&&(IsPORT=1){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//中心静脉置管插管天数
			If (aTubeType="PICCs")&&((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
			//全部插管天数（3三大管合计）
			If (aTubeType="ALL")&&((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)){
				Set Num=$i(^TMP($zn,$j,NIndex,"TubeDays"))
			}
		}
	}
	
	Set Days=+$g(^TMP($zn,$j,NIndex,"TubeDays"))
	
	Kill ^TMP($zn,$j,NIndex)
	Quit Days
}

/// 获取三管医嘱明细
/// w ##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem("296",$zdh("2020-05-01",3),$zdh("2020-05-31",3),"","","PICC","1")
ClassMethod GetTubeOrderItem(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aTubeType As %String = "", aIsSplit As %String = "0") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aTubeType,aIsSplit)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDateFrom="") return
	
	Set:aTubeType="ALL" aTubeType=""   //查询统计全部类型插管
	Set IsOnlyStatOrder=##class(DHCHAI.BT.Config).GetValByCode("PICC-OEPriority") //PICC是否只有临时医嘱(与拔管医嘱成对构成长期)
	
	Set xSCode= "",Count=0
	For {		
		Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode))  //子系统索引
		Quit:xSCode=""
		
		Set xOrdItemDesc = "" 
		For {
			Set xOrdItemDesc = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc))
			Quit:xOrdItemDesc=""
			
			Set xUpdateDate =""
			For {
				Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate))
				Quit:xUpdateDate=""
				
				Set xOrdItemID ="" 
				For {
					Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
					Quit:xOrdItemID="" 
					Set OrdItemData = $g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
					Continue:OrdItemData=""
					Set IsActive=$lg(OrdItemData,25)
					Continue:IsActive'=1
					
					Set Priority = $lg(OrdItemData,8)	//医嘱类型		
					Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xSCode,"OEPriority",Priority)
					Continue:PriorityMap=""
					Continue:PriorityMap="OUT"
					Continue:(PriorityMap="N")&(IsOnlyStatOrder'=1)

					//取的临床医嘱名称
					Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
					Continue:xMastMapID=""
					Set MapData = $g(^DHCHAI.DP.OEItmMastMapD(xMastMapID))
					Continue:MapData=""
					Set BTMapItemDr=$lg(MapData,3)
					Continue:BTMapItemDr=""  //治疗医嘱项
					Set OEItmMast=$lg($g(^DHCHAI.DP.OEItmMastD(BTMapItemDr)),3)  //医嘱项名称
					Set BTCatDr=$lg($g(^DHCHAI.DP.OEItmMastD(BTMapItemDr)),4)
					Continue:BTCatDr=""     //治疗医嘱分类
					Set OEItemCat = $lg($g(^DHCHAI.DP.OEItmCatD(BTCatDr)),2)
					Set CatCode=$p(OEItemCat,"-",3)	  //治疗医嘱分类代码			
					Continue:$e(OEItemCat,1,6)'="DRT-I-"  //过滤掉非三管医嘱
					Continue:((",PICC,VAP,UC,")'[(","_CatCode_","))
				
					If (CatCode="PICC")&&(aIsSplit=1){  // PICC医嘱拆分，通过医嘱项名称去判定
					    Set CatSubCode=""
						Set:OEItmMast["PICC" CatSubCode="PICC"
						Set:OEItmMast["CVC" CatSubCode="CVC"
						Set:OEItmMast["CRRT" CatSubCode="CRRT"
						Set:OEItmMast["PORT" CatSubCode="PORT"
						Set:OEItmMast["脐静脉置管" CatSubCode="PICC"
						Continue:(aTubeType="PICCs")&&((",PICC,CVC,CRRT，PORT,")'[(","_CatSubCode_","))
						Continue:(aTubeType'="PICCs")&&(aTubeType'="")&&(CatSubCode'=aTubeType)
					}Else {
						Continue:(aTubeType'="")&&(CatCode'=aTubeType)
					}
					
					Set OeItemDesc=$lg(OrdItemData,4)
					Set OESttDate=$lg(OrdItemData,15)
					Set OESttTime = $lg(OrdItemData,16)
					Set OEXDate=$lg(OrdItemData,17)
					Set OEXTime = $lg(OrdItemData,18)
					Continue:OESttDate>aDateTo		//排除开始时间超过统计日期
					Continue:(OEXDate'="")&&(OEXDate<aDateFrom)		//排除统计开始日期前结束医嘱
			      
			       	Set OrdDate = $lg(OrdItemData,10)
                	Set OrdTime = $lg(OrdItemData,11)
               		Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
                	Set OrdTime = $lg(OrdItemData,11)
                	Set:OrdTime'="" OrdTime=$zt(OrdTime)
                	Set OrdDateTime=OrdDate_" "_OrdTime
                	
                	Set:OESttDate'="" OESttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OESttDate)
                	Set:OESttTime'="" OESttTime=$zt(OESttTime)
                	Set SttDateTime=OESttDate_" "_OESttTime
                
                	Set:OEXDate'="" OEXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OEXDate)
                	Set:OEXTime'="" OEXTime=$zt(OEXTime)
                	Set EndDateTime=OEXDate_" "_OEXTime
               		             		
               		Set OrdItemID = $lg(OrdItemData,24)
					
             		Set OEOrdLocDr=$lg(OrdItemData,12)
	                Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
	                If OEOrdLocData'="" {
	                    Set OrdLocDesc=$lg(OEOrdLocData,3)
	                } Else {
	                    Set OrdLocDesc=$lg(OEOrdItemData,39)  //ID|Code|Desc
	                    Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
	                }
			      
					Set OrderInfo=$lb(xOrdItemID,OrdItemID,OEItmMast,OeItemDesc,Priority,SttDateTime,EndDateTime,OrdDateTime,OrdLocDesc)
					Set Count=Count+1
					Do return.SetAt(OrderInfo,Count)
				}
			}
		}
	}
	Quit return
}

}
