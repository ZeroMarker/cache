/// 名称: DHCHAI.STATV2.S160AntBacSub
/// 描述: 出院患者使用抗菌药物病原学送检率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S160AntBacSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-19
/// Description:  出院患者使用抗菌药物病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem、DHCHAI.DP.LabVisitNumber
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据 
///               aStatDimens:  展示维度    //add 20220928 
///               aLocIDs:    科室 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S160AntBacSub","QryAntBacSub","1","2020-05-01","2020-05-31","W","1","","27,29,31")
Query QryAntBacSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatDishCnt:%Integer,UseAntiCnt:%Integer,IsSubmissCnt:%Integer,SubmissRatio:%String,IsCureUseCnt:%Integer,IsCureSubmissCnt:%Integer,CureSubmissRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntBacSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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

    Set NIndex="QryAntBacSub"
	Kill ^TMP($zn,$j,NIndex)
	
	//科室合计人数
	Set (PatDishSum,UseAntiSum,IsSubmissSum,IsCureUseSum,IsCureSubmissSum)=0
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
		
	    Set (AntUseFlg,LabFlg,IsSubmiss,IsCureUse,IsCureSubmiss)=0
	    Set AntUseArr =..GetAntUseInfo(Paadm,AdmDate,DishDate)	
		Set:AntUseArr.Count()>0 AntUseFlg=1  //是否使用抗菌药物
		Set GenericList="",UseDateList=""
		Set LabInfo=..GetLabInfo(Paadm)
		Set:LabInfo.Count()>0 LabFlg=1
		Set:(AntUseFlg=1)&(LabFlg=1) IsSubmiss=1
		For AntInd=1:1:AntUseArr.Count(){
			Set OrderInfo=AntUseArr.GetAt(AntInd)
			Set UsePurpose = $li(OrderInfo,11)
			Set:UsePurpose["治疗" IsCureUse=1
			Set:(IsCureUse=1)&(LabFlg=1) IsCureSubmiss=1
		}
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
			}
			//使用抗菌并病原体送检人数
			If (IsSubmiss=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsSubmiss",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsSubmiss"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsSubmiss",Paadm)=""
				}
			}
			//治疗使用抗菌药物人数
			If (IsCureUse=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm)=""
				}
			}
			//治疗使用抗菌药物并病原体送检人数
			If (IsCureSubmiss=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsCureSubmiss",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsCureSubmiss"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsCureSubmiss",Paadm)=""
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
		
		Set PatDishCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatDish"))  		//出院患者数
		Set UseAntiCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseAnti"))  		//抗感染药使用人数
		Set IsSubmissCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsSubmiss"))  		//抗感染药使用并送检人数
		Set IsCureUseCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureUse"))  		//抗感染药治疗使用人数
		Set IsCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureSubmiss"))  	//抗感染药治疗使用并送检人数
		Set (SubmissRatio,CureSubmissRatio)="0.00%"
		Set:UseAntiCnt>0 SubmissRatio	= $fn(IsSubmissCnt/UseAntiCnt*100,"",2)_"%"
		Set:IsCureUseCnt>0 CureSubmissRatio	= $fn(IsCureSubmissCnt/IsCureUseCnt*100,"",2)_"%"
			
		Continue:(IsActive="0")&&(PatDishCnt=0)	
		Continue:(aQryCon="2")&&(IsSubmissCnt=0)
		Continue:(aQryCon="3")&&(UseAntiCnt=0)
		
		If (LocCount>1) {  //科室合计
			Set PatDishSum=PatDishSum+PatDishCnt
			Set UseAntiSum=UseAntiSum+UseAntiCnt
			Set IsSubmissSum=IsSubmissSum+IsSubmissCnt
			Set IsCureUseSum=IsCureUseSum+IsCureUseCnt
			Set IsCureSubmissSum=IsCureSubmissSum+IsCureSubmissCnt
		}
		
		Set Data=$lb(xDimensKey,DimensDesc,PatDishCnt,UseAntiCnt,IsSubmissCnt,SubmissRatio,IsCureUseCnt,IsCureSubmissCnt,CureSubmissRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	//出院患者住院人数及抗菌药物使用人数可以直接累加
	If (LocCount>1) {
		Set PatDishCnt  =PatDishSum  		    //出院患者数
		Set UseAntiCnt  =UseAntiSum 		    //抗感染药使用人数
		Set IsSubmissCnt=IsSubmissSum  		    //抗感染药使用并送检人数
		Set IsCureUseCnt=IsCureUseSum  		    //抗感染药治疗使用人数
		Set IsCureSubmissCnt=IsCureSubmissSum 	//抗感染药治疗使用并送检人数
		
		Set (SubmissRatio,CureSubmissRatio)="0.00%"
		Set:UseAntiCnt>0 SubmissRatio	= $fn(IsSubmissCnt/UseAntiCnt*100,"",2)_"%"
		Set:IsCureUseCnt>0 CureSubmissRatio	= $fn(IsCureSubmissCnt/IsCureUseCnt*100,"",2)_"%"			
		
		Set Data=$lb("","全部",PatDishCnt,UseAntiCnt,IsSubmissCnt,SubmissRatio,IsCureUseCnt,IsCureSubmissCnt,CureSubmissRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  		  		  							   	  				
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntBacSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntBacSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntBacSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntBacSubExecute ]
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
/// Description:  出院患者使用抗菌药物病原学送检率明细(不区分用药、送检是否在一个病区)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem、DHCHAI.DP.LabVisitNumber
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220928 解决汇总按科室分组统计明细无法区分医院问题     
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：  维度信息
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S160AntBacSub","QryAntSubmDtl","2018-03-01","2018-12-30","0000-00-0000-A-1-1-E")
Query QryAntSubmDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,IsUseAnt:%String,IsCureUse:%String,IsSubmiss:%String,IsCureSubm:%String") [ SqlProc ]
{
}

ClassMethod QryAntSubmDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "") As %Status
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

	    //获取抗菌药物和病原体送检信息
	    Set (AntUseFlg,LabFlg,IsSubmiss,IsCureUse,IsCureSubmiss)=0
	    Set AntUseArr =..GetAntUseInfo(Paadm,AdmDate,DishDate)	
		Set:AntUseArr.Count()>0 AntUseFlg=1  //是否使用抗菌药物
		Set GenericList="",UseDateList=""
		Set LabInfo=..GetLabInfo(Paadm)
		Set:LabInfo.Count()>0 LabFlg=1
		Set:(AntUseFlg=1)&(LabFlg=1) IsSubmiss=1
		For AntInd=1:1:AntUseArr.Count(){
			Set OrderInfo=AntUseArr.GetAt(AntInd)
			Set UsePurpose = $li(OrderInfo,11)
			Set:UsePurpose["治疗" IsCureUse=1
			Set:(IsCureUse=1)&(LabFlg=1) IsCureSubmiss=1
		}
		Set IsAntUse	=$Case(AntUseFlg,1:"是",:"")
		Set IsCureUse	=$Case(IsCureUse,1:"是",:"")
		Set IsSubmiss	=$Case(IsSubmiss,1:"是",:"")
		Set IsCureSubm	=$Case(IsCureSubmiss,1:"是",:"")
		
		Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
		For TransInd=1:1:TransInfoArr.Count() {
		   	Set TransInfo=TransInfoArr.GetAt(TransInd)		   
			Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_$lb(IsAntUse,IsCureUse,IsSubmiss,IsCureSubm)	
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryAntSubmDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntSubmDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntSubmDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntSubmDtlExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-06-16
/// Description:  查询病人检验病原学送检
/// Table：       DHCHAI.DP.LabVisitNumber,DHCHAI.DP.LabVisitReport
/// Input：       aEpisodeID：就诊ID
/// Return：      返回ROWSPEC
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S160AntBacSub","QryLabVisitNumber","172")
Query QryLabVisitNumber(aEpisodeID As %String, aTestSetCat As %String = "") As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeNo:%String,OrdTSDesc:%String,Specimen:%String,LocDesc:%String,CollDate:%String,VisitReportID:%String,AuthDate:%String,ResultList:%String") [ SqlProc ]
{
}

ClassMethod QryLabVisitNumberExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aTestSetCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
		
	//送检项目名称
	Set TestSetList = ##class(DHCHAI.BT.Config).GetValByCode("LabTestSetList")
	Set:(TestSetList="")&&(aTestSetCat'="") TestSetList=aTestSetCat
	Set:TestSetList'="" TestSetList=","_TestSetList_","	
	Set TestSetList =$tr(TestSetList,"，",",")
	
	Set xVisitNumberDr="",Count=0
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
		Continue:VisitData=""
		Set LabIsActive		=$li(VisitData,18)
		Continue:LabIsActive'=1
		
		Set SCode 			=$li(VisitData,14)
		Set CollDate 		=$li(VisitData,8)				//采集日期
		Set CollTime		=$li(VisitData,9)				//采集时间
		Set EpisodeNo		=$li(VisitData,3)   			//标本号
		Set RecDate 		=$li(VisitData,11)				//接收日期
		Set RecTime 		=$li(VisitData,12)				//接收时间
		Set Specimen 		=$li(VisitData,6)
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)	//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		Continue:CollDate=""
		
		Set CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
	
		//标本名称对照
		Set MapID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
		Set LabSpecMapData=$lb("","","","","","","","","")
		Set:MapID'="" LabSpecMapData=$g(^DHCHAI.DP.LabSpecMapD(MapID))
		Set MapActive	=$li(LabSpecMapData,6)
		Set MapItemDr	=$li(LabSpecMapData,3)
		if (MapItemDr'="")&&(MapActive=1) {
			Set MapItemData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
			If (MapItemData'=""){
				Set MapItemActive=$li(MapItemData,5)
				Set:MapItemActive Specimen = $li(MapItemData,3)
			}
		}
	
	    Set TestSet=""
		Set xTestSetDesc = "",CheckFlg=0
		For {
			Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,0))
			if (TestSetMapID'=""){
				Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
				Continue:TestSetMapData=""
				Continue:'$li(TestSetMapData,7) 		//无效判断
				Set TSMapItemDr=$li(TestSetMapData,4)
				Set TSMapItemData=""
				Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))				
				If (TSMapItemData'="") {    //检验医嘱对照
					Continue:'$li(TSMapItemData,5)	//无效判断
					Set TestSet	= $li(TSMapItemData,3)	
					Continue:(TestSetList'="")&&(TestSetList'[(","_TestSet_","))
					Set CheckFlg = 1
					Quit
				}				
			}
		}
		
		If (CheckFlg=0) {  //检查检验项目是否存在于检验结果中
			Set xTestSetDr=""
			For {
				Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
				Quit:xTestSetDr=""
				Quit:CheckFlg=1
				
				//最新检验报告
				Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
				Quit:xOrder=""
				Set xVisitReportDr=0
				For {
					Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
					Quit:xVisitReportDr=""
					Quit:CheckFlg=1
					
					Set xTestCode=""
					For {
						Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
						Quit:xTestCode=""
						Quit:CheckFlg=1
					
						Set xMapItemDr=0
						For {
							Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
							Quit:xMapItemDr=""
							
							Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
							
							Continue:TSMapItemData=""	  //检验医嘱对照
							Continue:'$li(TSMapItemData,5)	//无效判断
							Set TestSet	= $li(TSMapItemData,3)
							Continue:(TestSetList'="")&&(TestSetList'[(","_TestSet_","))
							Set CheckFlg = 1
							Quit										
						}
					}
				}
			}
		}
		Continue:CheckFlg=0	//过滤非指定类型的送检
		
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				// Add by zhaoyj 2022-06-16 Global方式
				Set VisitReportID=xVisitReportDr
				Set VisitReportData=$g(^DHCHAI.DP.LabVisitReportD(VisitReportID))
				Continue:VisitReportData=""
				Continue:$lg(VisitReportData,2)=""
				Set VisitNumberDr=$lg(VisitReportData,2)
				Set TestSetDr=$lg(VisitReportData,13)
				Set Order=$lg(VisitReportData,4)
				Continue:VisitReportData=""
				
				Set Status = $lg(VisitReportData,6)
				Continue:Status=6	//作废
				Set IsActive = $lg(VisitReportData,18)
				Continue:IsActive=0
				
				Set LabReportID = $lg(VisitReportData,3)
				Set LabRepOrder = $lg(VisitReportData,4)
				Set AuthDate=$lg(VisitReportData,10)
				Set AuthTime=$lg(VisitReportData,11)
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set VisitTestSet=$lg(VisitReportData,13)
				Continue:VisitTestSet=""
				Set TestSetDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(VisitTestSet)),3)
				Set OrdTsDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(VisitTestSet)),5)
				
				Set CollDateR=CollDate
				Set AuthDateR=AuthDate
				
				Set:CollTime'="" CollDateR=CollDate_" "_CollTime
				Set:AuthTime'="" AuthDateR=AuthDate_" "_AuthTime
				
				Set xResultID="",ResultList=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					Set ResultData=$g(^DHCHAI.DP.LabVisitRepResultD(xResultID))
					Continue:ResultData=""
					Set RstFormat=$lg(ResultData,5)
					Continue:RstFormat=""
					Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
					Continue:MapRstFormat=""
					Continue:MapRstFormat'="M"
					Set Bacteria=$lg(ResultData,6)
					Continue:Bacteria=""
					Continue:(Bacteria["阴性")||(Bacteria["-")
					Continue:(Bacteria["大于3种菌")
					Continue:(Bacteria["无")&&(Bacteria["生长")
					Continue:(Bacteria["未见")&&(Bacteria["菌")
					Continue:(Bacteria["未检出")&&(Bacteria["菌")
					Continue:$listfind(ResultList,Bacteria)>0  //判断是否同种菌
					Set ResultList=ResultList_$lb(Bacteria)		

				}
				
				Set Data=$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,LocDesc,CollDateR,VisitReportID,AuthDateR)_ResultList
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

			}
		}
		
	}
	Quit $$$OK
}

ClassMethod QryLabVisitNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
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

/// Creator：     luotiantian
/// CreatDate：   2020-05-11
/// Description:  出院患者使用抗菌药物病原学送检率明细
/// Description:  出院患者抗菌药物使用率明细(分子)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220929 解决汇总按科室分组统计明细无法区分医院问题     
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey： 维度信息
///               aLocIDs:   合计科室
/// 			  aAntiUse:  "治疗为1"/全部为空""
/// Return：      返回ROWSPEC  按患者医嘱记录输出
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S160AntBacSub","QryAntSubmUseDtl","1","2020-05-01","2020-05-31","","W","","","1")
Query QryAntSubmUseDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "", aAntiUse As %String = "", aLab As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String") [ SqlProc ]
{
}

ClassMethod QryAntSubmUseDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aLocIDs As %Text = "", aAntiUse As %String = "", aLab As %String = "") As %Status
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
   
   	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
    
    Set DishPatArr=..GetDishPatient(aHospIDs,aDateFrom,aDateTo)
    For index=1:1:DishPatArr.Count() {
	    Set DishPat=DishPatArr.GetAt(index)
	    Set Paadm	 = $li(DishPat,1)
	    Set HospDr	 = $li(DishPat,2)
	    Set GroupDr	 = $li(DishPat,3)
	    Set LocDr	 = $li(DishPat,4)
	    Set WardDr	 = $li(DishPat,5)
	    Set AdmDate	 = $li(DishPat,6)
	    Set DischDate = $li(DishPat,7)
	   	
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

		Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)  //存在转科日期早于入院日期情况，取全部转科记录
		For TransInd=1:1:TransInfoArr.Count(){
			Set TransInfo=TransInfoArr.GetAt(TransInd)
			Set TransID=$lg(TransInfo,1)
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)

			//获取抗菌药物使用信息,并输出
			Set (OrderInfo,LabInfo,OrderInfos,LabInfos)=""
			Set AntUseArr =..GetAntUseInfo(Paadm,AdmDate,DischDate)
			Continue:AntUseArr.Count()=0
			For AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set IsCureUse=0 
				Set UsePurpose = $li(OrderInfo,11)
				Set:UsePurpose["治疗" IsCureUse=1 
			    Continue:(aAntiUse=1)&&(IsCureUse=0)
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
				Set $li(OrderInfo,14)=CarPrvTpDesc
              
			    Set OrderInfos=OrderInfos_$lb(OrderInfo)				    	
			}
			Continue:($ll(OrderInfos)=0)
			If (aLab="1") {
				Set LabInfoArr=..GetLabInfo(Paadm,AdmDate,DischDate)
				Continue:(LabInfoArr.Count()=0)					
				For LabInd=1:1:LabInfoArr.Count(){
					Set SubLabInfo=LabInfoArr.GetAt(LabInd)
					Continue:SubLabInfo=""
					Set VisitNumberID = $lg(SubLabInfo,1)
					Set EpisodeNo	  = $lg(SubLabInfo,5)
					Set CollDate 	  = $lg(SubLabInfo,2)
					Set CollTime	  = $lg(SubLabInfo,6)
					Set Specimen      = $lg(SubLabInfo,3)
					Set TestSet       = $lg(SubLabInfo,7)
				
					Set:CollDate'="" CollDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
				    Set:CollTime'="" CollTime=$zt(CollTime)
		            Set CollDateTime=CollDate_" "_CollTime
					If '$d(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID)) {  //存在只送检未报告情况 
		          		Set LabInfo=$lb(VisitNumberID,EpisodeNo,CollDateTime,"",TestSetDesc,Specimen,"","","")			            
		               	Set LabInfos=LabInfos_$lb(LabInfo)			            
		            } Else {
			            Set xTestSetDr=""
						For {
							Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr))
							Quit:xTestSetDr=""		  
							//最新检验报告
							Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr,""),-1)
							Quit:xOrder=""
							Set xVisitReportDr=0
							For {
								Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,xTestSetDr,xOrder,xVisitReportDr))
								Quit:xVisitReportDr=""
								
								Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
								Continue:LabReportData=""
								Set RepDate = $lg(LabReportData,10)
								Set RepTime = $lg(LabReportData,11)
								
								Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
					    		Set:RepTime'="" RepTime=$zt(RepTime)
			           		 	Set RepDateTime=RepDate_" "_RepTime
			           		 	Set LabSCode = $lg(LabReportData,14)
			           		 	Set LabReportID = $lg(LabReportData,3)
			           		 	Set LabTestSetDr= $lg(LabReportData,13)
			           		 	Continue:LabTestSetDr=""
			           		 	Set LabVisitTestSet =$g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr))
			           		 	Set LabTestSetDesc =$lg(LabVisitTestSet,3)
			           		 	
			           		 	//取细菌检验结果
			           		 	Set (Bacterias,MRBTpDescs)=""
			           		 	Set xResultID=""
								For {
									Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
									Quit:xResultID=""
									
									Set LabResultInfo=$g(^DHCHAI.DP.LabVisitRepResultD(xResultID))
									Set LabInfType=$lg(LabResultInfo,13)
									Set TestCode =$lg(LabResultInfo,4)
									Set RstFormat=$lg(LabResultInfo,5)
									Continue:RstFormat'="M"
									Set Bacteria=$lg(LabResultInfo,6)
									Continue:Bacteria=""
									Set Bacterias=Bacterias_","_Bacteria
									
									Set ObjectID =LabReportID_"||"_TestCode
									Set CCResultDr=$o(^DHCHAI.IR.CCResultI("IndexObjectID",Paadm,ItemDr,LabSCode,ObjectID,0))
									Continue:CCResultDr=""
									Set ResultInfo=$g(^DHCHAI.IR.CCResultD(CCResultDr))
									Set MRBTpDr = $lg(ResultInfo,24)
									Set MRBTpDesc =""
									If (MRBTpDr'="") {
										Set MRBTpInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
										Set MRBTpDesc =$lg(MRBTpInfo,3)					
									}
									Continue:MRBTpDesc=""
									Set MRBTpDescs=MRBTpDescs_","_MRBTpDesc
								}
								Set:Bacterias'="" Bacterias=$e(Bacterias,2,$l(Bacterias))
								Set:MRBTpDescs'="" MRBTpDescs=$e(MRBTpDescs,2,$l(MRBTpDescs))
								Set LabInfo=$lb(VisitNumberID,EpisodeNo,CollDateTime,RepDateTime,LabTestSetDesc,Specimen,Bacterias,MRBTpDescs,LabInfType)
								Set LabInfos = LabInfos_$lb(LabInfo)
							}	
		                }					
					}					
				}
				Continue:($ll(LabInfos)=0)
			}
		
			Set Len=$ll(OrderInfos)
			Set:(Len<$ll(LabInfos)) Len=$ll(LabInfos)
			For LenInd=1:1:Len {
				Set OrderInfo=$lg(OrderInfos,LenInd)
				Set:OrderInfo="" OrderInfo=$lb("","","","","","","","","","","","","","")
				Set LabInfo=$lg(LabInfos,LenInd)
				Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
				Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_OrderInfo_LabInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}

	Quit $$$OK
}

ClassMethod QryAntSubmUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntSubmUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntSubmUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntSubmUseDtlExecute ]
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
