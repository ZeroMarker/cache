/// 名称: DHCHAI.STATV2.S140AntPreThe
/// 描述: 同期住院患者抗菌药物预防/治疗使用构成比统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S140AntPreThe Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  医院抗菌药物预防/治疗使用构成比统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S140AntPreThe","QryHospAntPreThe","2022-10-01","2022-10-31","E","1")
Query QryHospAntPreThe(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,UseAntiCnt:%Integer,UseAntiRatio:%String,CureUseAntiCnt:%Integer,CureUseAntiRatio:%String,PreUseAntiCnt:%Integer,PreUseAntiRatio:%String") [ SqlProc ]
{
}

ClassMethod QryHospAntPreTheExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
    Set NIndex="QryHospAntPreThe"
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
				
				Set AntUseFlg=0,CureUseFlg=0,PreUseFlg=0
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
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					Set:AntUseArr.Count()>0 AntUseFlg=1
					For AntInd=1:1:AntUseArr.Count() {
						Set OrderInfo=AntUseArr.GetAt(AntInd)
						Set UsePurpose = $li(OrderInfo,11)
						Set:UsePurpose="治疗+预防" UsePurpose="治疗"
						Set:UsePurpose["治疗" CureUseFlg=1
						Set:UsePurpose["预防" PreUseFlg=1
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
					If (CureUseFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti",Paadm)) {
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti",Paadm)=""
						}
					}
					If (PreUseFlg=1) {
						If '$d(^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti",Paadm)) {							
							Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti"))
							Set ^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti",Paadm)=""
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
						If (CureUseFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","CureUseAnti",Paadm)) {					
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","CureUseAnti"))
								Set ^TMP($zn,$j,NIndex,"Sum","CureUseAnti",Paadm)=""
							}
						}
						//预防使用抗菌药物人数
						If (PreUseFlg=1) {
							If '$d(^TMP($zn,$j,NIndex,"Sum","PreUseAnti",Paadm)) {
								Set num=$i(^TMP($zn,$j,NIndex,"Sum","PreUseAnti"))
								Set ^TMP($zn,$j,NIndex,"Sum","PreUseAnti",Paadm)=""
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
		Set xDimensKey	= $lg(DimList,1)
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))

		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set UseAntiCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseAnti"))  		//抗感染药使用人数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"CureUseAnti"))		//抗感染药治疗使用人数
		Set PreUseAntiCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PreUseAnti"))  		//抗感染药预防使用人数
		Set UseAntiRatio="0.00%",CureUseAntiRatio="0.00%",PreUseAntiRatio="0.00%"
		Set:PatAdmCnt>0 UseAntiRatio=$fn((UseAntiCnt/PatAdmCnt)*100,"",2)_"%" 			 //Anti使用率
		Set:UseAntiCnt>0 CureUseAntiRatio=$fn((CureUseAntiCnt/UseAntiCnt)*100,"",2)_"%"  //Anti治疗占比
		Set:UseAntiCnt>0 PreUseAntiRatio=$fn((PreUseAntiCnt/UseAntiCnt)*100,"",2)_"%" 	 //Anti预防占比
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(CureUseAntiCnt=0)&&(PreUseAntiCnt=0)
		Continue:(aQryCon="3")&&(UseAntiCnt=0)

		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,UseAntiCnt,UseAntiRatio,CureUseAntiCnt,CureUseAntiRatio,PreUseAntiCnt,PreUseAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	  	
	If (LocCount>1) {  //合计
 		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			   //在院患者数
		Set UseAntiCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","UseAnti"))  		       //抗感染药使用人数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","CureUseAnti"))		   //抗感染药治疗使用人数
		Set PreUseAntiCnt  	=+$g(^TMP($zn,$j,NIndex,"Sum","PreUseAnti"))  		   //抗感染药预防使用人数
		Set UseAntiRatio="0.00%",CureUseAntiRatio="0.00%",PreUseAntiRatio="0.00%"
		Set:PatAdmCnt>0 UseAntiRatio=$fn((UseAntiCnt/PatAdmCnt)*100,"",2)_"%" 			 //Anti使用率
		Set:UseAntiCnt>0 CureUseAntiRatio=$fn((CureUseAntiCnt/UseAntiCnt)*100,"",2)_"%"  //Anti治疗占比
		Set:UseAntiCnt>0 PreUseAntiRatio=$fn((PreUseAntiCnt/UseAntiCnt)*100,"",2)_"%" 	 //Anti预防占比
		
		Set Data=$lb("","全部",PatAdmCnt,UseAntiCnt,UseAntiRatio,CureUseAntiCnt,CureUseAntiRatio,PreUseAntiCnt,PreUseAntiRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospAntPreTheClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospAntPreTheExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospAntPreTheFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospAntPreTheExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  抗菌药物预防/治疗使用构成比统计表(分子) 抗菌用药明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
/// 			  aAntiUse:  1 :治疗/2:预防/ 全部为空
/// Return：      返回ROWSPEC 
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S140AntPreThe","QryAntPreTheDtl","","2020-05-01","2022-05-31","0000-00-0000-A-1","E","","1")  
Query QryAntPreTheDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAntiUse As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntPreTheDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aAntiUse As %String) As %Status
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
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")

    Set:aAntiUse="1" aAntiUse="治疗"
    Set:aAntiUse="2" aAntiUse="预防"
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
					Set AntUseFlg=0
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					Continue:AntUseArr.Count()=0
					For AntInd=1:1:AntUseArr.Count(){
						Set OrderInfo=AntUseArr.GetAt(AntInd)
						//抗菌药物级别英文转化为中文
						Set DrgPoison  = $li(OrderInfo,13)
						Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
						Set:DrgPoison="KSS2" DrgPoison="限制使用级"
						Set:DrgPoison="KSS3" DrgPoison="特殊使用级"
						Set $li(OrderInfo,13)=DrgPoison
						//日期类型转化]
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
		                Set OrderInfo=OrderInfo_$lb(CarPrvTpDesc)
						
						Set UsePurpose = $li(OrderInfo,11)
						Set:UsePurpose="治疗+预防" UsePurpose="治疗"
						Continue:(aAntiUse'="")&&(UsePurpose'[aAntiUse)
						
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

ClassMethod QryAntPreTheDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntPreTheDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntPreTheDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntPreTheDtlExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-12
/// Description:  住院患者抗菌药物预防/治疗使用构成比统计表(分母) 在院患者
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:         
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S140AntPreThe","QryAntPreThePatDtl","","2020-05-01","2022-05-31","0001-07-0000-G-3","E")
Query QryAntPreThePatDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntUseFlg:%String") [ SqlProc ]
{
}

ClassMethod QryAntPreThePatDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "") As %Status
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
				Set LocDesc	= $li(LocData,3)
		
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
					
					//获取抗菌药物使用信息
					Set AntUseFlg=0
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					Set:AntUseArr.Count()>0 AntUseFlg=1
					Set AntUseFlg=$s(AntUseFlg="1":"是",1:"") 
					
					Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,AntUseFlg)	
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		    }
		}
				
	}
	Quit $$$OK
}

ClassMethod QryAntPreThePatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntPreThePatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntPreThePatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntPreThePatDtlExecute ]
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
