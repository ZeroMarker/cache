/// 名称: DHCHAI.STATV2.S150AntVarDay
/// 描述: 出院患者人均使用抗菌药物品种数和天数统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S150AntVarDay Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-18
/// Description:  出院患者人均使用抗菌药物品种数和天数统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据
///               aStatDimens:  展示维度    //add 20220928 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S150AntVarDay","QryAntVarDay","1","2022-10-01","2022-10-31","E","1","","")
Query QryAntVarDay(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatDishCnt:%Integer,UseAntiCnt:%Integer,AntiCount:%Integer,UseDays:%Integer,AvgCount:%Integer,AvgDays:%Float") [ SqlProc ]
{
}

ClassMethod QryAntVarDayExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

	Set NIndex="QryAntVarDay"
	Kill ^TMP($zn,$j,NIndex)
	
    Set (PatDishSum,UseAntiSum,AntiCntSum,UseDaysSum)=0  //科室合计出院人数、使用人数、种类、天数
    Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index=1:1:DishPatArr.Count() {
	    Set DishPat=DishPatArr.GetAt(index)
	    Set Paadm	= $li(DishPat,1)
	    Set HospDr	= $li(DishPat,2)
	    Set GroupDr	= $li(DishPat,3)
	    Set LocDr	= $li(DishPat,4)
	    Set WardDr	= $li(DishPat,5)
	    Set AdmDate	= $li(DishPat,6)
	    Set DishDate= $li(DishPat,7)
		
		Set LocID = LocDr
		Set:aLocType="W" LocID=WardDr
	    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))    
		Set:aLocType="W" GroupDr  = $li($g(^DHCHAI.BT.LocationD(WardDr)),7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		
	    Set AntUseFlg=0
	    Set AntUseArr =..GetAntUseInfo(Paadm,AdmDate,DishDate)	
		Set:AntUseArr.Count()>0 AntUseFlg=1  //是否使用抗菌药物
		
		//计算使用种类和天数
		Set GenericList="",UseDateList=""
		For AntInd=1:1:AntUseArr.Count() {
			Set OrderInfo=AntUseArr.GetAt(AntInd)
			Set OrdItemID=$lg(OrderInfo,1)
			Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
			Set SCode=$lg(OrdItemData,28)
			
			//update 20210824 根据讨论结果抗菌药物品种数按对照标准名称统计
			Set AntiDesc = $li(OrderInfo,3)
			Set AntiDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntiDesc)  //去掉特殊字符
			Set AntiID = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,AntiDesc,""))
			Continue:AntiID=""
			Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiID))
			Continue:AntiMapData=""
			Set BTMapItemDr=$lg(AntiMapData,3)
			Continue:BTMapItemDr=""
			Set Generic=$lg($g(^DHCHAI.DP.OEAntiMastD(BTMapItemDr)),3)
			Continue:Generic=""							
			Set:$lf(GenericList,Generic)<1 GenericList=GenericList_$lb(Generic)
			
			Set StartDT		=$li(OrderInfo,7)
			Set StartDate	=$p(StartDT," ",1)
			Set EndDT		=$li(OrderInfo,10)
			Set EndDate		=$p(EndDT," ",1)
			
			For tmpDate=StartDate:1:EndDate {
				Set:$lf(UseDateList,tmpDate)<1 UseDateList=UseDateList_$lb(tmpDate) 
			}	
		}
		Set GenericCount= $ll(GenericList)
		Set AntiUseDays	= $ll(UseDateList)

		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 全院出院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatDish",Paadm)) {
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatDish"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatDish",Paadm)=""
			}
			//使用抗菌药物人数
			If (AntUseFlg=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)=""
				}
				// 抗菌用药的种类数量
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"AntiCount",Paadm)) {
					Set ^TMP($zn,$j,NIndex,DimensKey,"AntiCount")=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntiCount"))+GenericCount
					Set ^TMP($zn,$j,NIndex,DimensKey,"AntiCount",Paadm)=""
				}
				/*
				For i=1:1:GenericCount {
					Set Generic = $list(GenericList,i)
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"AntiCount",Generic)) {
						Set ^TMP($zn,$j,NIndex,DimensKey,"AntiCount")=$i(^TMP($zn,$j,NIndex,DimensKey,"AntiCount"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"AntiCount",Generic)=""
					}	
				}
				*/
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseDays",Paadm)) {
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseDays")=+$g(^TMP($zn,$j,NIndex,DimensKey,"UseDays"))+AntiUseDays
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseDays",Paadm)=""
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
		Set PatDishCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatDish"))  		//出院患者数
		Set UseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseAnti"))  		//抗感染药使用人数
		Set AntiCount  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiCount"))  		//抗感染药使用种类
		Set UseDays  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseDays"))  		//抗感染药使用天数
		Set AvgCount=0,AvgDays=0
		Set:UseAntiCnt>0 AvgCount	= $fn(AntiCount/UseAntiCnt,"",2)
		Set:UseAntiCnt>0 AvgDays	= $fn(UseDays/UseAntiCnt,"",2)
		
		Continue:(IsActive="0")&&(PatDishCnt=0)	
		Continue:(aQryCon="2")&&(AntiCount=0)
		Continue:(aQryCon="3")&&(UseAntiCnt=0)
		
		If (LocCount>1) {  //科室合计
			Set PatDishSum=PatDishSum+PatDishCnt
			Set UseAntiSum=UseAntiSum+UseAntiCnt
			Set AntiCntSum=AntiCntSum+AntiCount
			Set UseDaysSum=UseDaysSum+UseDays
		}

		Set Data=$lb(xDimensKey,DimensDesc,PatDishCnt,UseAntiCnt,AntiCount,UseDays,AvgCount,AvgDays)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	//出院患者住院人数及抗菌药物使用人数可以直接累加
	If (LocCount>1) {
		Set PatDishCnt  =PatDishSum  		    //出院患者数
		Set UseAntiCnt  =UseAntiSum 		    //抗感染药使用人数
		Set AntiCount   =AntiCntSum  		    //抗感染药使用种类
		Set UseDays     =UseDaysSum 		    //抗感染药使用天数
		
		Set AvgCount=0,AvgDays=0
		Set:UseAntiCnt>0 AvgCount	= $fn(AntiCount/UseAntiCnt,"",2)
		Set:UseAntiCnt>0 AvgDays	= $fn(UseDays/UseAntiCnt,"",2)
		
		Set Data=$lb("","全部",PatDishCnt,UseAntiCnt,AntiCount,UseDays,AvgCount,AvgDays)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  		  							   
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntVarDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntVarDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntVarDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntVarDayExecute ]
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
/// CreatDate：   2019-11-19
/// Description:  出院患者人均使用抗菌药物品种数和天数统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220928 解决汇总按科室分组统计明细无法区分医院问题     
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：  维度信息
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC 按患者就诊记录输出 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S150AntVarDay","QryAntVarDayDtl","","2020-06-01","2020-06-30","","W","")
Query QryAntVarDayDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsUseAnt:%String,AntCount:%Integer,UseDays:%Integer,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntVarDayDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
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
 	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"") //3.科室类型(W,E,'')
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK		
	Set aLocDr     = +$p(aDimensKey,"-",3)								  //4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
    Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index=1:1:DishPatArr.Count() {
	    Set DishPat=DishPatArr.GetAt(index)
	    Set Paadm	= $li(DishPat,1)
	    Set HospDr	= $li(DishPat,2)
	    Set GroupDr	= $li(DishPat,3)
	    Set LocDr	= $li(DishPat,4)
	    Set WardDr	= $li(DishPat,5)
	    Set AdmDate	= $li(DishPat,6)
	    Set DishDate= $li(DishPat,7)
	    
		Set:aStaType="W" LocDr=WardDr
		Continue:(aLocDr'="")&(aLocDr'=LocDr)
	    Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))    
		Set:aStaType="W" GroupDr  = $li($g(^DHCHAI.BT.LocationD(WardDr)),7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
		Set GroupDesc=$li(GroupData,3)
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

		Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
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
	   
		//取统计维度
		Set DimensDesc =""
		Set:DimensMark="" DimensDesc="全部"
		Set:DimensMark="A" DimensDesc=$lg(HospGrpInfo,3)
		Set:DimensMark="H" DimensDesc=$lg(HospInfo,3)       //医院名称
		Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
		Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
	   
	    //获取病人就诊信息
	    Set PatData=..BuildPaadmData(Paadm)
	    Continue:PatData=""
	  	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 	Set AdmTimes = $lg(PAAdmData,38)   //就诊次数

	    //获取抗菌药物使用信息
	    Set IsUseAnt="",GenericList="",UseDateList=""
	    Set AntUseArr =..GetAntUseInfo(Paadm,AdmDate,DishDate)	
		Set:AntUseArr.Count()>0 IsUseAnt="是"  //是否使用抗菌药物
		For AntInd=1:1:AntUseArr.Count(){
			Set OrderInfo=AntUseArr.GetAt(AntInd)
			Set OrdItemID=$lg(OrderInfo,1)
			Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
			Set SCode=$lg(OrdItemData,28)
			
			//计算使用种类和天数
			Set AntiDesc = $li(OrderInfo,3)
			Set AntiDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntiDesc)  //去掉特殊字符
			Set AntiID = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,AntiDesc,""))
			Continue:AntiID=""
			Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiID))
			Continue:AntiMapData=""
			Set BTMapItemDr=$lg(AntiMapData,3)
			Continue:BTMapItemDr=""
			Set Generic=$lg($g(^DHCHAI.DP.OEAntiMastD(BTMapItemDr)),3)
			Continue:Generic=""							
			Set:$lf(GenericList,Generic)<1 GenericList=GenericList_$lb(Generic)
			Set StartDT		=$li(OrderInfo,7)
			Set StartDate	=$p(StartDT," ",1)
			Set EndDT		=$li(OrderInfo,10)
			Set:EndDT'=" " EndDate=$p(EndDT," ",1)
			Set:EndDate="" EndDate=DishDate
			
			For tmpDate=StartDate:1:EndDate {
				Set:$lf(UseDateList,tmpDate)<1 UseDateList=UseDateList_$lb(tmpDate) 
			}
	   }
	   Set AntCount	= $ll(GenericList)
	   Set UseDays	= $ll(UseDateList)
	  
	   Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
	   For TransInd=1:1:TransInfoArr.Count() {
		   Set TransInfo=TransInfoArr.GetAt(TransInd)
		   
		   Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(IsUseAnt,AntCount,UseDays)_TransInfo	
		   Set ^CacheTemp(repid,ind)=Data
		   Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryAntVarDayDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntVarDayDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntVarDayDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntVarDayDtlExecute ]
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
