/// 名称: DHCHAI.STATV2.S360BWVAPInf
/// 描述: 出生体重分组新生儿呼吸机相关肺炎发病率统计表
/// 编写者: zhugz
/// 编写日期: 2019-12-12
Class DHCHAI.STATV2.S360BWVAPInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-12-12
/// Description:  出生体重分组新生儿呼吸机相关肺炎发病率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-病区（和日志相关数据 默认按病区统计）
/// 			  aQryCon  ：是否筛选有效数据  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S360BWVAPInf","QrySDayInf","1","2021-07-01","2022-07-29")																													
Query QrySDayInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,WtCatDesc:%String,WtCat:%String,InDays:%Integer,PatNum:%Integer,TubeCount:%Integer,TubeDays:%Integer,TubeRatio:%String,INFCount:%Integer,INFRatio:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aQryCon As %String = "1", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set ICUaDateFrom =aDateFrom
	Set ICUaDateTo =aDateTo
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QrySDayInf"
	Kill ^TMP($zn,$j,NIndex)
    
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
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1  		//update 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤

		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
	    //同期在科:某段时间的在科人数
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
				Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
			}
	
			Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:PaadmData=""
			Set IsNewBaby=$li(PaadmData,32)
			Set Weigth=$li(PaadmData,34)
			Set Weigth=+Weigth
			Set WtCat=5  						//默认体重未分型
			// 取体重等级及对应的天数人数
			If '$d(^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm)) {
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm)=""
				If (Weigth<=1000)&&(Weigth>0) {
					Set WtCat=1	
				}
				ElseIf (Weigth>1000)&(Weigth<=1500) {
					Set WtCat=2
				}
				ElseIf (Weigth>1500)&(Weigth<=2500) {
					Set WtCat=3
				}
				ElseIf (Weigth>2500){
					Set WtCat=4
				}
				Set ^TMP($zn,$j,NIndex,"Loc",LocID,"Adm",Paadm,"WtCat")=WtCat
				Set num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"PatNum"))
			}
			//在科天数
	    	Set InDays=..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
			Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InDays") = +$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InDays"))+InDays
			//插管天数
			Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,"VAP",aLocType)
			// 科室患者插管感染(不判断是否插管患者)
			Set InfPosInfo=##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,"VAP",aDateFrom,aDateTo,LocDr,WardDr)
			If '$d(^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)) { 
				Set ^TMP($zn,$j,NIndex,"PatLocAdm",LocID,Paadm)=""			
				If (Days'=0) {
					If ('$d(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubePat",Paadm))) {
						Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubePat",Paadm)=""												
						Set Num=$i(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeCount"))
						Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeDays")=$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"TubeDays"))+Days
					}
				}
				// 科室患者插管感染(不判断是否插管患者)
				If (InfPosInfo'="") {
					Set InfCount=$Length(InfPosInfo,"|")
					Set ^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCount")=$g(^TMP($zn,$j,NIndex,"Loc",LocID,"WtCat",WtCat,"InfCount"))+InfCount
				}
			}
		}
    }
	//科室，体重类别，住院天数，住院人数，感染例次
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Loc",xLocID))
		Quit:xLocID=""
		Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
		Continue:LocData=""
		Set LocDesc = $li(LocData,3)
		Set LocDesc2 = $li(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set IsActive= $li(LocData,14)
		
		Set xWtCat=""
		For {
			Set xWtCat=$o(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat))
			Quit:xWtCat=""
			
			Set InDays=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InDays"))	    //住院天数
			Set PatNum=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"PatNum"))	    //住院人数
			Set TubeCount=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeCount"))  //插管人数
			Set TubeDays=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"TubeDays"))	//插管天数
			Set INFCount=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"WtCat",xWtCat,"InfCount"))	//感染例次数
		 	
		 	Continue:('IsActive)&&(PatNum=0)	
			Continue:(aQryCon=2)&&((INFCount=0)&(TubeDays=0))   
			Continue:(aQryCon=3)&&((InDays=0)&(TubeDays=0))   
			
		 	Set WtCatDesc=$Case(xWtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")
			Set TubeRatio="0.00%",INFRatio="0.000‰"
			
			Set:InDays>0 TubeRatio=$fn((TubeDays/InDays)*100,"",2)_"%"
			Set:TubeDays>0 INFRatio=$fn((INFCount/TubeDays)*1000,"",3)_"‰"
			
			Set Data=$lb(xLocID,LocDesc,WtCatDesc,xWtCat,InDays,PatNum,TubeCount,TubeDays,TubeRatio,INFCount,INFRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrySDayInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfExecute ]
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

/// Creator：     luotiantian
/// CreatDate：   2020-05-24
/// Description:  呼吸机相关性肺炎感染明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-病区（和日志相关数据 按病区统计）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S360BWVAPInf","QrySDayInfDtl","1","2021-04-01","2021-07-31","W","43","5")
Query QrySDayInfDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,WtCatDesc:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String,DiagID:%String,InfPosDesc:%String,InfDate:%String,InfType:%String,EffectDesc:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

    Set NIndex="QrySDayInfDtl"
 	Kill ^TMP($zn,$j,NIndex)
    
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
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1  		//update 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
		
	    //同期在科:某段时间的在科人数
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
				Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
			}
			
			Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:PaadmData=""
			Set IsNewBaby=$li(PaadmData,32)
			Set Weigth=$li(PaadmData,34)
			Set Weigth=+Weigth
			Set WtCat=5  						//默认体重未分型
		
			If (Weigth<=1000)&&(Weigth>0) {
				Set WtCat=1	
			}
			ElseIf (Weigth>1000)&(Weigth<=1500) {
				Set WtCat=2
			}
			ElseIf (Weigth>1500)&(Weigth<=2500) {
				Set WtCat=3
			}
			ElseIf (Weigth>2500){
				Set WtCat=4
			}
			
			Continue:(aWtCat'="")&&(WtCat'=aWtCat)
			Set WtCatDesc=$Case(WtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")
			Set AdmTimes = $lg(PaadmData,38)    //患者就诊次数
			Set PatData =..BuildPaadmData(Paadm)    //取病人基本信息
    		Continue:PatData=""	
    		 
    		Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,"VAP",aLocType)	
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
	            Set TubeInfInfo =##class(DHCHAI.STATV2.S3TubeInf).GetTubeInf(Paadm,"VAP",DateFrom,DateTo,LocDr,WardDr)
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
				
				Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,"VAP",0)
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
			
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(WtCatDesc)_TransInfo_$lb(Days)_TubeInfo_InfData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}		
    }
	Kill ^TMP($zn,$j,NIndex)
	
	Quit $$$OK
}

ClassMethod QrySDayInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfDtlExecute ]
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

/// Creator：     wpl
/// CreatDate：   2020-06-05
/// Description:  出生体重分组新生儿同期住院患者人数明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-病区（和日志相关数据 按病区统计）
/// 			  aQryCon  ：是否筛选有效数据  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S360BWVAPInf","QryPatDtl","1","2021-07-01","2021-07-01","W","43","1")
Query QryPatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,WtCatDesc:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  	Set:aLocType'="W" aLocType="E"
   	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 
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
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1  		//update 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
		
	    //同期在科:某段时间的在科人数
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
				Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
			}
			
			Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:PaadmData=""
			Set IsNewBaby=$li(PaadmData,32)
			Set Weigth=$li(PaadmData,34)
			Set Weigth=+Weigth
			Set WtCat=5  						//默认体重未分型
		
			If (Weigth<=1000)&&(Weigth>0) {
				Set WtCat=1	
			}
			ElseIf (Weigth>1000)&(Weigth<=1500) {
				Set WtCat=2
			}
			ElseIf (Weigth>1500)&(Weigth<=2500) {
				Set WtCat=3
			}
			ElseIf (Weigth>2500){
				Set WtCat=4
			}
			
			Continue:(aWtCat'="")&&(WtCat'=aWtCat)
			Set WtCatDesc=$Case(WtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")
			Set AdmTimes = $lg(PaadmData,38)    //患者就诊次数
			Set PatData =..BuildPaadmData(Paadm)    //取病人基本信息
    		Continue:PatData=""	
    		Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,"VAP",aLocType)
	    	//患者转科信息
			For xTransInd=1:1:$l(TransIDs,",") {
				Set TransID=$p(TransIDs,",",xTransInd)
			    Continue:TransID=""
			    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
			  	Continue:TranData=""
			    Set TransDate	= $li(TranData,7)
			    Set OutLocDate	= $li(TranData,10)
			    Set TransTime	= $li(TranData,8)
				Set OutLocTime	= $li(TranData,11)
				//转换转科日期格式
				Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
				Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		        Set:TransTime'="" TransTime=$zt(TransTime)
			    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
		    	Set TransDateTime =TransDate_" "_TransTime
				Set OutLocDateTime =OutLocDate_" "_OutLocTime
			   	Set Data = $lb(LocDesc,AdmTimes)_PatData_$lb(WtCatDesc,TransID,LocID,LocDesc,TransDateTime,OutLocDateTime,Days)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
				
    }
	
	Quit $$$OK
}

ClassMethod QryPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatDtlExecute ]
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

/// Creator：     zhaiyusheng
/// CreatDate：   2022-10-19
/// Description:  新生儿呼吸机使用明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport,DHCHAI.IR.ICULog
/// Input:        
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-病区（和日志相关数据 按病区统计）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S360BWVAPInf","QrySDayTubePatDtl","1","2021-07-01","2021-07-01","W","43","1")
Query QrySDayTubePatDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,WtCatDesc:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,TubeDays:%Integer,OrdID:%Integer,OrdItemID:%String,OEItmMast:%String,OeItemDesc:%String,Priority:%String,SttDateTime:%String,EndDateTime:%String,OrdDateTime:%String,OrdLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySDayTubePatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "W", aLocIDs As %Text = "", aWtCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  	Set:aLocType'="W" aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

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
		Continue:LocData=""
		Set IsActive=$lg(LocData,14)
		Continue:IsActive'=1
		Set IsNICU=$lg(LocData,11)
		Continue:IsNICU'=1  		//update 按入院科室取新生儿时，新生儿标记随所在科室变化，根据20220216讨论结果，新生儿统计按NICU科室标记统计（与NICU日志保持一致），不按新生儿标记过滤
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
		
	    //同期在科:某段时间的在科人数
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
			} Else {
				Set LocDr  = LnkLocDr
				Set WardDr = LocID
				Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
			}
			
			Set PaadmData = $g(^DHCHAI.DP.PAAdmD(Paadm))
			Continue:PaadmData=""
			Set IsNewBaby=$li(PaadmData,32)
			Set Weigth=$li(PaadmData,34)
			Set Weigth=+Weigth
			Set WtCat=5  						//默认体重未分型
		
			If (Weigth<=1000)&&(Weigth>0) {
				Set WtCat=1	
			}
			ElseIf (Weigth>1000)&(Weigth<=1500) {
				Set WtCat=2
			}
			ElseIf (Weigth>1500)&(Weigth<=2500) {
				Set WtCat=3
			}
			ElseIf (Weigth>2500){
				Set WtCat=4
			}
			
			Continue:(aWtCat'="")&&(WtCat'=aWtCat)
			Set WtCatDesc=$Case(WtCat,1:"BW≤1000g",2:"BW 1001g~1500g",3:"BW 1501g~2500g",4:"BW>2500g",5:"BW未填写")
			Set AdmTimes = $lg(PaadmData,38)    //患者就诊次数
			Set PatData =..BuildPaadmData(Paadm)    //取病人基本信息
    		Continue:PatData=""	
    		Set Days=##class(DHCHAI.STATV2.S3TubeInf).GetICUDays(LocID,Paadm,aDateFrom,aDateTo,WtCat,"VAP",aLocType)
			Continue:Days=0  
	    	//患者转科信息
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
				Set TubeArr=##class(DHCHAI.STATV2.S3TubeInf).GetTubeOrderItem(Paadm,DateFrom,DateTo,TimeFrom,TimeTo,"VAP",0)
				If (TubeArr.Count()>0) {
					For ArrInd=1:1:TubeArr.Count(){
						Set TubeInfo=TubeArr.GetAt(ArrInd)
					   	Set Data = $lb(LocDesc,AdmTimes)_PatData_$lb(WtCatDesc)_TransInfo_$lb(Days)_TubeInfo
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}Else {   //有插管记录但无插管医嘱
					Set Data = $lb(LocDesc,AdmTimes)_PatData_$lb(WtCatDesc)_TransInfo_$lb(Days,"","","","","","","","","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
				
    }
	
	Quit $$$OK
}

ClassMethod QrySDayTubePatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayTubePatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayTubePatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayTubePatDtlExecute ]
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
