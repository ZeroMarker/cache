/// 名称: DHCHAI.STATV2.S132AntComb
/// 描述: 住院患者抗菌药物联用情况统计表
/// 编写者：ShenC
/// 编写日期: 2020-07-24
Class DHCHAI.STATV2.S132AntComb Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-07-24
/// Description:  住院患者抗菌药物联用情况统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon：  有效数据筛查  
///               aStatDimens:  展示维度    //add 20220926 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S132AntComb","QryAntComb","1","2020-05-01","2020-05-31","W","","","")
Query QryAntComb(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,UseAntiCnt:%Integer,CombSingle:%Integer,CombTwo:%Integer,CombThree:%Integer,CombFourAndMore:%Integer") [ SqlProc ]
{
}

ClassMethod QryAntCombExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
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

    Set NIndex="QryAntUse"
	Kill ^TMP($zn,$j,NIndex)
	
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
				
				Set AntUseFlg=0, CombCount=0
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

					//获取抗菌药物使用信息
					Set AntUseArr =..GetAntCombInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					Continue:AntUseArr.Count()<1
					Set AntUseFlg=1
					Set CombCount=$lg(AntUseArr.GetAt(1),14)   //联用数	
					// 统计时段内从A科转B科再转入A科，可能出现第一段A科只用一种药，第二段A科用两种药，两段时间内联合用药数不一样
					If (CombCount>0) {
						Set:CombCount>4 CombCount=4  
						If '$d(^TMP($zn,$j,NIndex,LocID,"AntComb",Paadm,CombCount)){		
							Set ^TMP($zn,$j,NIndex,LocID,"AntComb",Paadm,CombCount)=""
						}
					}
				}
	            
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 全院住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
					}
					//使用抗菌药物人数
					If (AntUseFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)=""
						}
					}
					
					For xCombCount=1:1:4 {
						If $d(^TMP($zn,$j,NIndex,LocID,"AntComb",Paadm,xCombCount)){
							If '$d(^TMP($zn,$j,NIndex,DimensKey,"AntComb",Paadm,xCombCount)){		
								Set ^TMP($zn,$j,NIndex,DimensKey,"AntComb",Paadm,xCombCount)=""
								Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntComb",xCombCount))		//联合用药等级
							}
						}
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
						}
						// 合计使用抗菌药物人数
						If (AntUseFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","UseAnti",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","UseAnti"))
								Set ^TMP($zn,$j,NIndex,"Sum","UseAnti",Paadm)=""
							}
						}
						For xCombCount=1:1:4 {
							If $d(^TMP($zn,$j,NIndex,LocID,"AntComb",Paadm,xCombCount)){
								If '$d(^TMP($zn,$j,NIndex,"Sum","AntComb",Paadm,xCombCount)){		
									Set ^TMP($zn,$j,NIndex,"Sum","AntComb",Paadm,xCombCount)=""
									Set num=$i(^TMP($zn,$j,NIndex,"Sum","AntComb",xCombCount))		//联合用药等级
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
		Set DimensKey	= $lg(DimList,1)
		Set LocDr = +$p(DimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))

		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:DimensKey=""
		Continue:(aHospIDs'["|")&(DimensKey["A")		//非全院不显示"全院"
		
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))  			//在院患者数
		Set UseAntiCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))  			//抗感染药使用人数
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)	
		Continue:(aQryCon="2")&&(UseAntiCnt=0)
        Continue:(aQryCon="3")&&(PatAdmCnt=0)

		Set CombSingle=0,CombTwo=0,CombThree=0,CombFourAndMore=0
		Set CombCount=""
		For {
			Set CombCount=$o(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))
			Quit:CombCount=""
			
			Set:CombCount=1 CombSingle=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//单联人数
			Set:CombCount=2 CombTwo=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))		//二联人数
			Set:CombCount=3 CombThree=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//三联人数
			Set:CombCount>=4 CombFourAndMore=CombFourAndMore+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//四联及以上人数
		}		
		
		Set Data=$lb(DimensKey,DimensDesc,PatAdmCnt,UseAntiCnt,CombSingle,CombTwo,CombThree,CombFourAndMore)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If (LocCount>1) {  //科室合计
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set UseAntiCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","UseAnti"))  		    //抗感染药使用人数
		
		Set CombSingle=0,CombTwo=0,CombThree=0,CombFourAndMore=0
		Set CombCount=""
		For {
			Set CombCount=$o(^TMP($zn,$j,NIndex,"Sum","AntComb",CombCount))
			Quit:CombCount=""
			
			Set:CombCount=1 CombSingle=+$g(^TMP($zn,$j,NIndex,"Sum","AntComb",CombCount))	//单联人数
			Set:CombCount=2 CombTwo=+$g(^TMP($zn,$j,NIndex,"Sum","AntComb",CombCount))		//二联人数
			Set:CombCount=3 CombThree=+$g(^TMP($zn,$j,NIndex,"Sum","AntComb",CombCount))	//三联人数
			Set:CombCount>=4 CombFourAndMore=CombFourAndMore+$g(^TMP($zn,$j,NIndex,"Sum","AntComb",CombCount))	//四联及以上人数
		}		
		
		Set Data=$lb("","全部",PatAdmCnt,UseAntiCnt,CombSingle,CombTwo,CombThree,CombFourAndMore)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	

		  	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntCombClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntCombExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntCombFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntCombExecute ]
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
/// CreatDate：   2020-07-29
/// Description:  住院患者抗菌药物联合用药明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220926 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型    //add 20220926 解决汇总多科室合计没有维度拼接科室问题，防止科室、病区分组不一致时导致汇总与明细数据不一致
///               aLocIDs:   合计科室
/// 			  aAntiComb：联用等级(1,2,3,>4)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S132AntComb","QryAntCombMolDtl","1","2020-05-01","2020-05-31","0001-07-0031-W-4","W","",1)
Query QryAntCombMolDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAntiComb As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%Integer,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntCombMolDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAntiComb As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//处理日期
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
			
			Set GroupDr  = $li(LocData,7)
			If GroupDr="" {
				Set GroupDesc="其他科"
				Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			}	
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$li(GroupData,3)
			//按科室组、科室/病区过滤
			Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

			//取统计维度
			Set DimensDesc =""
			Set:DimensMark="" DimensDesc="全部"
			Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
			Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
			Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
			Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
	
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2

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
				
					//获取抗菌药物使用信息
					Set AntUseArr =..GetAntCombInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)
					Continue:AntUseArr.Count()<1
					Set CombCount=$lg(AntUseArr.GetAt(1),14)   //联用数
					Continue:(aAntiComb'="")&(aAntiComb'=4)&(CombCount'=aAntiComb)
					Continue:(aAntiComb'="")&(aAntiComb=4)&(CombCount<aAntiComb)	
					For AntInd=1:1:AntUseArr.Count(){
						Set OrderInfo=AntUseArr.GetAt(AntInd)
						//抗菌药物级别英文转化为中文
						Set DrgPoison  = $li(OrderInfo,13)
						Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
						Set:DrgPoison="KSS2" DrgPoison="限制使用级"
						Set:DrgPoison="KSS3" DrgPoison="特殊使用级"
						Set $li(OrderInfo,13)=DrgPoison
					    //日期类型转化
					    Set OrdDateTime  = $li(OrderInfo,6)
						Set SttDateTime  = $li(OrderInfo,7)
						Set EndDateTime  = $li(OrderInfo,10)
						Set OrdDate=$p(OrdDateTime," ",1)
						Set OrdTime=$p(OrdDateTime," ",2)
						Set SttDate=$p(SttDateTime," ",1)
						Set SttTime=$p(SttDateTime," ",2)
						Set EndDate=$p(EndDateTime," ",1)
						Set EndTime=$p(EndDateTime," ",2)
						Set:OrdDate'="" OrdDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
						Set:SttDate'="" SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
						Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
						Set:OrdTime'="" OrdTime=$zt(OrdTime)
				        Set:SttTime'="" SttTime=$zt(SttTime)
					    Set:EndTime'="" EndTime=$zt(EndTime)
					    Set OrdDateTime =OrdDate_" "_OrdTime
				    	Set SttDateTime =SttDate_" "_SttTime
						Set EndDateTime =EndDate_" "_EndTime
						Set $li(OrderInfo,6)=OrdDateTime
						Set $li(OrderInfo,7)=SttDateTime
						Set $li(OrderInfo,10)=EndDateTime
						
						Set OrdItemID=$lg(OrderInfo,1)
						Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
						//取医师类型
						Set OrdDocDesc =$lg(OrdItemData,14)  //ID|Code|Desc
						Set OEDocDr=""
						Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
						Set CarPrvTpId="",CarPrvTpDesc=""
						Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
						Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
						Set $li(OrderInfo,14)=CarPrvTpDesc
						
						Set Data = $lb(DimensDesc,AdmTimes)_PatData_OrderInfo_TransInfo
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
		    }
		}
	}
		
	Quit $$$OK
}

ClassMethod QryAntCombMolDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntCombMolDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntCombMolDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntCombMolDtlExecute ]
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
/// CreatDate：   2020-07-28
/// Description:  住院患者抗菌药物联用病人明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220922 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型    //add 20220922 解决汇总多科室合计没有维度拼接科室问题，防止科室、病区分组不一致时导致汇总与明细数据不一致
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S132AntComb","QryAntCombPatDtl","1","2020-05-01","2020-05-31","0001-07-0031-W-4","W","")
Query QryAntCombPatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntUseFlg:%String") [ SqlProc ]
{
}

ClassMethod QryAntCombPatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//处理日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
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
				Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
				Set LocDesc	= $lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				
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
					//获取抗菌药物使用信息
					Set AntUseFlg=0
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					Set:AntUseArr.Count()>0 AntUseFlg=1
					Set AntUseFlg=$s(AntUseFlg="1":"是",1:"") 
					
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,AntUseFlg)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
				
	}
	Quit $$$OK
}

ClassMethod QryAntCombPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntCombPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntCombPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntCombPatDtlExecute ]
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
