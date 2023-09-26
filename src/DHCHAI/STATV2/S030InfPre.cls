/// 名称: DHCHAI.STATV2.S030InfPre
/// 描述: 医院感染（例次）现患率统计表
/// 编写者：蒋朋朋
/// 编写日期: 2019-10-21
Class DHCHAI.STATV2.S030InfPre Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-14
/// Description:  现患率统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aStatDimens :  展示维度
///               aLocIDs :    科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S030InfPre","QryInfPre","","2022-11-01","2022-11-21","W","1","","")
Query QryInfPre(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocID:%String,LocDesc:%String,InCount:%Integer,HAICount:%Integer,HAIRatio:%String,INFCount:%Integer,INFRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
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
	Set:aLocType'="W" aLocType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
   	
	Set NIndex="QryInfPre"
	Kill ^TMP($zn,$j,NIndex)
    Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    //同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
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
		    If (+INFCSSHPFlag=0){
		        //同期在科:某段时间的零点在科人数
		        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I","A|O")
		    }Else{
				//同期在科:某段时间的在科人数
		        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I","A|A2|O")
		    }
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
				Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))   // add by zhoubo 
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
				Set GroupDr  = $li(LocData,7)
				If GroupDr="" {
					Set GroupDesc="其他科"
					Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				}
				//获取感染信息
				Set InfFlg=0,InfPosDescs=""
				For xTransInd=1:1:$l(TransIDs,",") {
				    Set TransID=$p(TransIDs,",",xTransInd)
				    Continue:TransID=""
				    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
				    Set TransDate	= $li(TranData,7)
				    Set OutLocDate	= $li(TranData,10)
				    Set TransTime	= $li(TranData,8)
					Set OutLocTime	= $li(TranData,11)
					// 如果转科起止日期大于统计日期，以统计日期计算
					Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
					Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
					Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""

					// 查询医院感染的感染信息
					Set InfPosDesc=##class(DHCHAI.STATV2.S030InfPre).GetInfPosInfo(Paadm,DateFrom,DateTo,LocDr,WardDr,"1")
					Set:InfPosDesc'="" InfFlg=1,InfPosDescs=InfPosDescs_"|"_InfPosDesc
				}
				Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
				// 计算感染人数及感染例次数
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
					}
					// 感染人数
					If (InfFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"InfPat",Paadm)=""
						}
					}
					// 感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							
							Continue:$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,"DiagDr",DiagDr)=""
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))
						}
					}
				}
				If (LocCount>1) {
					// 合计住院患者
					If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
						Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
						Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
					}
					// 合计感染人数
					If (InfFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfPat"))
							Set ^TMP($zn,$j,NIndex,"Sum","InfPat",Paadm)=""
						}
					}
					// 合计感染例数
					If (InfFlg=1) {
						For PosInd=1:1:$l(InfPosDescs,"|") {
							Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
							Continue:InfPosInfo=""
							Set DiagDr = $p(InfPosInfo,"^",1)
							
							Continue:$d(^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)) // 输出去重
							Set ^TMP($zn,$j,NIndex,"Sum",Paadm,"DiagDr",DiagDr)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","InfCase"))
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
		Set DimensDesc  = $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:xDimensKey=""
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
		//限制临床科室查看内容
		Continue:(IsLc=1)&(xLcDimensKey'="")&(xDimensKey'[xLcDimensKey)
		
		Set InCount  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set HAICount  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  			//新发感染人数
		Set INFCount    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase"))    		//新发感染例次数
		Set HAIRatio="0.00%",INFRatio="0.00%"
		Set:InCount>0 HAIRatio=$fn((HAICount/InCount)*100,"",2)_"%" 	//感染率
		Set:InCount>0 INFRatio=$fn((INFCount/InCount)*100,"",2)_"%" 	//感染例次率
		
		Continue:(IsActive="0")&&(HAICount=0)	
		Continue:(aQryCon="2")&&(HAICount=0)
		Continue:(aQryCon="3")&&(HAICount=0)
		
		Set Data=$lb(ind,xDimensKey,"",DimensDesc,InCount,HAICount,HAIRatio,INFCount,INFRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	If (LocCount>1) {
		Set InCount  	=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set HAICount  	=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  			//新发感染人数
		Set INFCount    =+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))    		//新发感染例次数
		Set HAIRatio="0.00%",INFRatio="0.00%"
		Set:InCount>0 HAIRatio=$fn((HAICount/InCount)*100,"",2)_"%" 	//感染率
		Set:InCount>0 INFRatio=$fn((INFCount/InCount)*100,"",2)_"%" 	//感染例次率
		
		Set Data=$lb(ind,"","","全部",InCount,HAICount,HAIRatio,INFCount,INFRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	 	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreExecute ]
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
/// CreatDate：   2020-03-02
/// Description:  现患率--住院患者感染（例次）发病率明细表(包括社区感染和医院感染)分子
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 修改时注意两个报表明细公用
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型
///               aLocIDs:   合计科室 
/// 			  aInfType ：感染类型(0:社区感染，1:医院感染)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S030InfPre","QryS030InfPreDtl","2019-08-01","2020-03-31","0001-07-0000-G-3","W")
Query QryS030InfPreDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInfType As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagDr:%String,DiagDesc:%String,InfDate:%String,InfXDate:%String,InfEffect:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryS030InfPreDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark	= $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	Set NIndex="QryS030InfPreDtl"
	Kill ^TMP($zn,$j,NIndex)
    Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    //同期在科
    Set xLocTypeDr=""
	For {
		Set xLocTypeDr=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr))
		Quit:xLocTypeDr=""
		
		Set LocTypeDic=$g(^DHCHAI.BT.DictionaryD(xLocTypeDr))
		Set LocType=$lg(LocTypeDic,2)
		Continue:LocType'=aLocType
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCHAI.BT.LocationI("IndexLocTypeDr",xLocTypeDr,xLocID))
			Quit:xLocID=""
			Continue:(aLocDr'="")&(aLocDr'=xLocID)
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_xLocID_","))
			
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc	= $lg(LocData,3)
			Set LocDesc2= $lg(LocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
				
			Set HospDr=$lg(LocData,8)
			//医院分组过滤
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
			
		    If (+INFCSSHPFlag=0){
		        //同期在科:某段时间的零点在科人数
		        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I","A|O")
		    }Else{
				//同期在科:某段时间的在科人数
		        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,xLocID,"I","A|A2|O")
		    }
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
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2	
				//患者转科基本信息
				Set PatData =..BuildPaadmData(Paadm)
	   			Continue:PatData=""
	            Set AdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	            Set AdmTimes = $lg(AdmData,38)   //就诊次数
			    
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
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					//获取感染信息
					Set InfPosDescs=##class(DHCHAI.STATV2.S030InfPre).GetInfPosInfo(Paadm,DateFrom,DateTo,LocDr,WardDr,aInfType)	
					Continue:InfPosDescs=""
					//感染信息输出
					For PosInd=1:1:$l(InfPosDescs,"|"){
						Set InfPosInfo=$p(InfPosDescs,"|",PosInd)
						Continue:InfPosInfo=""
						Set DiagDr    = $p(InfPosInfo,"^",1)
						Set DiagDesc  = $p(InfPosInfo,"^",2)
	                    Set InfDate   = $p(InfPosInfo,"^",3)
	                    Set InfXDate  = $p(InfPosInfo,"^",4)
	                    Set InfEffect = $p(InfPosInfo,"^",5)
	                    Set InfType   = $p(InfPosInfo,"^",7)
	                    Set:InfDate'="" InfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	                    Set:InfXDate'="" InfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	                    Continue:$d(^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)) // 输出去重
						Set ^TMP($zn,$j,NIndex,Paadm,"DiagDr",DiagDr)=""
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(DiagDr,DiagDesc,InfDate,InfXDate,InfEffect,InfType)
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

ClassMethod QryS030InfPreDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryS030InfPreDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
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
/// CreatDate：   2020-03-18
/// Description:  判断患者是否发生医院感染,返回感染部位信息(现患率)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
///               aInfTypeCode:1 医院感染 0：社区感染
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S030InfPre).GetInfPosInfo("1","65360","65419")
ClassMethod GetInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aWardID As %String = "", aInfTypeCode As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aLocID,aWardID,aInfTypeCode)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-15 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			// 感染诊断信息
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug	
                                //转归情况
                Set InfEffect=""
                Set IRInfEffectDr=$lg(DiagsData,8)
                If (IRInfEffectDr'=""){
                    Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
                    Set:IRInfEffectDr'="" InfEffect = $lg(IRInfEffectData,3)
                }
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:InfDate>aDateTo    // 现患率调查，感染日期大于查询截止日期，非查询期间发生感染
                Continue:(aDateTo'="")&&(InfDate>aDateTo)                   //感染日期大于调查结束日期表明感染还未开始
                if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
                    Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
                }
				//感染科室归属按统计时间最后所在科室计算
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,aDateTo,"00:00:01")
				If (aWardID'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardID)				
				}
				If (aLocID'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocID)
				}

				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set InfTypeCode=1
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
				}
				Continue:(aInfTypeCode'="")&&(aInfTypeCode'=InfTypeCode)
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)

				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType
				}
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2019-10-14
/// Description:  现患率统计
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocIDs：科室ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S030InfPre","QryInfPre1","2020-09-01","2020-12-16","1|3|4","","E","2")
Query QryInfPre1(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %Text = "", aLocType As %String = "E", aQryCon As %String = "1", listLocID As %String = "") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocID:%String,LocDesc:%String,InCount:%String,Count:%String,CountRatio:%String,HospInfCount:%String,HAIRatio:%String,HospInfCase:%String,INFRatio:%String,ComInfCount:%String,ComHAIRatio:%String,ComInfCase:%String,ComINFRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPre1Execute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %Text = "", aLocType As %String = "E", aQryCon As %String = "2", listLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aLocType'="W" aLocType="E"
    Set listLocID=$listfromstring(aLocIDs,",")
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	
 	Set StatDimensStr=..GetStatDimensStr(aLocType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
   	Set:StatType'="W" StatType="E"  //不是病区就是科室
   	
	Set NIndex="QryInfPre1"
	Kill ^TMP($zn,$j,NIndex)
    Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    if (+INFCSSHPFlag=0){
        //同期在科:某段时间的零点在科人数
        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|O")
    }else{
	//同期在科:某段时间的在科人数
       Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|A2|O")
    }
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
		Set HospDr=$li(LocData,8)
			
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 全院住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			
			// 全院科室患者
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
				// 科室患者
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)=""	
				// 科室患者感染
				Set InfPosInfo=##class(DHCHAI.STATV2.S030InfPre).GetInfPosInfo(Paadm,aDateFrom,aDateTo,LocDr,WardDr)
				If (InfPosInfo'="") {
					For InfNo=1:1:$L(InfPosInfo,"|") {
						Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
						continue:InfPosMsg=""
						Set DiagID	= $p(InfPosMsg,"^",1)
						Set InfDate	= $p(InfPosMsg,"^",3)
						Set InfType=$p(InfPosMsg,"^",7)
						
						If (InfType="医院感染") {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"HospInfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"HospInfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"HospInfPat",Paadm)=""
							}
							//记录医院感染例次数
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"HospInfCase"))
						}
						
						If (InfType="社区感染") {
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat"))
								Set ^TMP($zn,$j,NIndex,DimensKey,"ComInfPat",Paadm)=""
							}
							//记录医院感染例次数
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfCase"))
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
		Set DimenCode	= $lg(DimList,1)
		Set LocDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:DimenCode=""
         Set DimensMark  = $p(DimenCode,"-",4)
        if (DimensMark="E")||(DimensMark="W"){
            Set LocID=+$p(DimenCode,"-",3)
            Continue:(aLocIDs'="")&&($listfind(listLocID,LocID)<1)
        }
		Set InCount  	=+$g(^TMP($zn,$j,NIndex,DimenCode,"PatAdm"))  			//在院患者数(应查人数)
		Set Count  		=InCount  												//实查人数
		Set:InCount>0 CountRatio=$fn((Count/InCount)*100,"",2)_"%" 	//实查率
		Set HospInfCount =+$g(^TMP($zn,$j,NIndex,DimenCode,"HospInfPat"))  			//医院感染人数
		Set HospInfCase  =+$g(^TMP($zn,$j,NIndex,DimenCode,"HospInfCase"))    		//医院感染例次数
		Set ComInfCount  =+$g(^TMP($zn,$j,NIndex,DimenCode,"ComInfPat"))  			//社区感染人数
		Set ComInfCase   =+$g(^TMP($zn,$j,NIndex,DimenCode,"ComInfCase"))    		//社区感染例次数
		
		Set HAIRatio="0.00%",INFRatio="0.00%"
		Set:InCount>0 HAIRatio=$fn((HospInfCount/InCount)*100,"",2)_"%" 	//感染率
		Set:InCount>0 INFRatio=$fn((HospInfCase/InCount)*100,"",2)_"%" 	    //感染例次率
		
		Set ComHAIRatio="0.00%",ComINFRatio="0.00%"
		Set:InCount>0 ComHAIRatio=$fn((ComInfCount/InCount)*100,"",2)_"%" 	//感染率
		Set:InCount>0 ComINFRatio=$fn((ComInfCase/InCount)*100,"",2)_"%" 	//感染例次率
		
		Continue:(IsActive="0")&&(InCount=0)
		Continue:(aQryCon="2")&&(HospInfCount=0)&&(ComInfCount=0)
		Set Data=$lb("",DimenCode,"",LocDesc,InCount,Count,CountRatio,HospInfCount,HAIRatio,HospInfCase,INFRatio,ComInfCount,ComHAIRatio,ComInfCase,ComINFRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	 	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPre1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPre1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreExecute ]
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
