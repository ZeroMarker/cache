/// 名称: DHCHAI.STATV2.S171AntTheSub
/// 描述: 出院患者抗菌药物治疗前病原学送检率统计表
/// 编写者：caogang
/// 编写日期: 2022-08-04
Class DHCHAI.STATV2.S171AntTheSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2022-10-11	
/// Description:  出院患者抗菌药物治疗前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S171AntTheSub","QryAntTheSub","1|2","2020-05-01","2020-05-31","","0","W","1","1","","","")
Query QryAntTheSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aSubDateType As %String = "", aSubHourType As %String = "0", aLocType As %String = "", aQryCon As %String = "1", aUseSubDateType As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aLabSubType As %String = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatDishCnt:%Integer,CureUseAntiCnt:%Integer,BfCureSubmissCnt:%Integer,BfCureSubRatio:%String,CureUseKSS1:%Integer,UseKSS1AndSub:%Integer,UseKSS1SubRatio:%String,CureUseKSS2:%Integer,UseKSS2AndSub:%Integer,UseKSS2SubRatio:%String,CureUseKSS3:%Integer,UseKSS3AndSub:%Integer,UseKSS3SubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aSubDateType As %String = "", aSubHourType As %String = "0", aLocType As %String = "", aQryCon As %String = "1", aUseSubDateType As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aLabSubType As %String = "") As %Status
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
	
	//检验类型
	If (aLabSubType=1) {    // 指向性（细菌）
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestBactList")
	}ElseIf(aLabSubType=2) {  // 非指向性（常规检验）
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestCommList")
	}Else {
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestSetList")
	}
	//是否统计门急诊送检
	Set StaOELab = ##class(DHCHAI.BT.Config).GetValByCode("StaOELabSub")
	Set:StaOELab="" StaOELab=0
	
	//抗菌药物给药途径
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set InstrucList=","_InstrucList_","
    //抗菌药物等级
	Set arrDrgPoison=$lb("","KSS1","KSS2","KSS3")
	
    Set NIndex="QryAntTheSub"
	Kill ^TMP($zn,$j,NIndex)
    
    //科室合计出院人数、治疗使用人数、治疗送检人数
    Set (PatDishSum,CureUseAntiSum,BfCureSubmissSum,CureUseKSS1Sum,UseKSS1AndSubSum,CureUseKSS2Sum,UseKSS2AndSubSum,CureUseKSS3Sum,UseKSS3AndSubSum)=0
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

		//获取首次治疗性抗菌药物使用信息
		Set IsCureUse=0,IsBfCureSub=0,IsKSS1CureUse=0,IsBfKSS1CureSub=0,IsKSS2CureUse=0,IsBfKSS2CureSub=0,IsKSS3CureUse=0,IsBfKSS3CureSub=0
		For indDP=1:1:$ll(arrDrgPoison) {
			Set DrgPoison=$lg(arrDrgPoison,indDP)
			
			Set IsUse=0,IsBfSub=0
			Set AntUseInfo=..GetFirstCureAnt(Paadm,AdmDate,DishDate,InstrucList,DrgPoison)					
			Set FirstCureDate=$p(AntUseInfo,"^",1)
			Set FirstCureTime=$p(AntUseInfo,"^",2)
			Set:+(FirstCureDate)>0 IsUse=1
			Set:(DrgPoison="")&(IsUse=1) IsCureUse=1
			Set:(DrgPoison="KSS1")&(IsUse=1) IsKSS1CureUse=1
			Set:(DrgPoison="KSS2")&(IsUse=1) IsKSS2CureUse=1
			Set:(DrgPoison="KSS3")&(IsUse=1) IsKSS3CureUse=1
			If (IsUse=1) {	
				Set IsBfSub=..GetIsBfCureSubmiss(Paadm,AdmDate,DishDate,TestSetCat,aSubDateType,aSubHourType,StaOELab,FirstCureDate,FirstCureTime)
				Set:(DrgPoison="")&(IsBfSub=1) IsBfCureSub=1
				Set:(DrgPoison="KSS1")&(IsBfSub=1) IsBfKSS1CureSub=1
				Set:(DrgPoison="KSS2")&(IsBfSub=1) IsBfKSS2CureSub=1
				Set:(DrgPoison="KSS3")&(IsBfSub=1) IsBfKSS3CureSub=1
			}
		}
		    		
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 出院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)) {
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}

			//治疗使用抗菌药物
			If (IsCureUse=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsCureUse"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsCureUse",Paadm)=""
				}
			}
			//治疗前送检
			If (IsBfCureSub=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"IsBfCureSubmiss",Paadm)=""
				}
			}
			// 非限制类抗菌药物使用人数
			If (IsKSS1CureUse=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS1",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS1"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS1",Paadm)=""
				}
			}
			// 非限制类抗菌药物送检人数
			If (IsBfKSS1CureSub=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseKSS1AndSub",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseKSS1AndSub"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseKSS1AndSub",Paadm)=""
				}
			}
			// 限制类抗菌药物使用人数
			If (IsKSS2CureUse=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS2",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS2"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS2",Paadm)=""
				}
			}
			// 限制类抗菌药物送检人数
			If (IsBfKSS2CureSub=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseKSS2AndSub",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseKSS2AndSub"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseKSS2AndSub",Paadm)=""
				}
			}
			// 特殊类抗菌药物使用人数
			If (IsKSS3CureUse=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS3",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS3"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"CureUseKSS3",Paadm)=""
				}
			}
			// 特殊类抗菌药物送检人数
			If (IsBfKSS3CureSub=1){
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseKSS3AndSub",Paadm)) {
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseKSS3AndSub"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseKSS3AndSub",Paadm)=""
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
		Set PatDishCnt  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//出院患者数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureUse"))		//抗感染药治疗使用人数
		Set BfCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfCureSubmiss"))  //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//Anti使用率

		Set CureUseKSS1  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"CureUseKSS1"))  		// 非限制类抗感染药使用人数
		Set UseKSS1AndSub	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseKSS1AndSub"))  		// 非限制类抗感染药送检人数
		Set CureUseKSS2  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"CureUseKSS2"))  		// 限制类抗感染药使用人数
		Set UseKSS2AndSub	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseKSS2AndSub"))  		// 限制类抗感染药送检人数
		Set CureUseKSS3  	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"CureUseKSS3"))  		// 特殊类抗感染药使用人数
		Set UseKSS3AndSub	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"UseKSS3AndSub"))  		// 特殊类抗感染药送检人数
		Set UseKSS1SubRatio="0.00%",UseKSS2SubRatio="0.00%",UseKSS3SubRatio="0.00%"
		Set:CureUseKSS1>0 UseKSS1SubRatio=$fn((UseKSS1AndSub/CureUseKSS1)*100,"",2)_"%"  // 非限制类抗菌药物送检率
		Set:CureUseKSS2>0 UseKSS2SubRatio=$fn((UseKSS2AndSub/CureUseKSS2)*100,"",2)_"%"  // 限制类抗菌药物送检率
		Set:CureUseKSS3>0 UseKSS3SubRatio=$fn((UseKSS3AndSub/CureUseKSS3)*100,"",2)_"%"  // 特殊类抗菌药物送检率
		
		Continue:(IsActive="0")&&(PatDishCnt=0)
		Continue:(aQryCon="2")&&(BfCureSubmissCnt=0)
		Continue:(aQryCon="3")&&(CureUseAntiCnt=0)
		
		If (LocCount>1) {  //科室合计
			Set PatDishSum=PatDishSum+PatDishCnt
			Set CureUseAntiSum=CureUseAntiSum+CureUseAntiCnt
			Set BfCureSubmissSum=BfCureSubmissSum+BfCureSubmissCnt
			Set CureUseKSS1Sum=CureUseKSS1Sum+CureUseKSS1
			Set UseKSS1AndSubSum=UseKSS1AndSubSum+UseKSS1AndSub
			Set CureUseKSS2Sum=CureUseKSS2Sum+CureUseKSS2
			Set UseKSS2AndSubSum=UseKSS2AndSubSum+UseKSS2AndSub
			Set CureUseKSS3Sum=CureUseKSS3Sum+CureUseKSS3
			Set UseKSS3AndSubSum=UseKSS3AndSubSum+UseKSS3AndSub
		}
		
		Set Data=$lb(xDimensKey,DimensDesc,PatDishCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,CureUseKSS1,UseKSS1AndSub,UseKSS1SubRatio,CureUseKSS2,UseKSS2AndSub,UseKSS2SubRatio,CureUseKSS3,UseKSS3AndSub,UseKSS3SubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	

	If (LocCount>1) {	//科室合计
		Set PatDishCnt      =PatDishSum  			//出院患者数
		Set CureUseAntiCnt  =CureUseAntiSum		    //抗感染药治疗使用人数
		Set BfCureSubmissCnt=BfCureSubmissSum	    //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//Anti使用率

		Set CureUseKSS1  	=CureUseKSS1Sum  		// 非限制类抗感染药使用人数
		Set UseKSS1AndSub	=UseKSS1AndSubSum  		// 非限制类抗感染药送检人数
		Set CureUseKSS2  	=CureUseKSS2Sum  		// 限制类抗感染药使用人数
		Set UseKSS2AndSub	=UseKSS2AndSubSum  		// 限制类抗感染药送检人数
		Set CureUseKSS3  	=CureUseKSS3Sum  		// 特殊类抗感染药使用人数
		Set UseKSS3AndSub	=UseKSS3AndSubSum  		// 特殊类抗感染药送检人数
		Set UseKSS1SubRatio="0.00%",UseKSS2SubRatio="0.00%",UseKSS3SubRatio="0.00%"
		Set:CureUseKSS1>0 UseKSS1SubRatio=$fn((UseKSS1AndSub/CureUseKSS1)*100,"",2)_"%"  // 非限制类抗菌药物送检率
		Set:CureUseKSS2>0 UseKSS2SubRatio=$fn((UseKSS2AndSub/CureUseKSS2)*100,"",2)_"%"  // 限制类抗菌药物送检率
		Set:CureUseKSS3>0 UseKSS3SubRatio=$fn((UseKSS3AndSub/CureUseKSS3)*100,"",2)_"%"  // 特殊类抗菌药物送检率
	
		Set Data=$lb("","全部",PatDishCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,CureUseKSS1,UseKSS1AndSub,UseKSS1SubRatio,CureUseKSS2,UseKSS2AndSub,UseKSS2SubRatio,CureUseKSS3,UseKSS3AndSub,UseKSS3SubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntTheSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubExecute ]
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
/// CreatDate：   2018-07-26
/// Description:  抗菌药物治疗前送检率出院患者明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S171AntTheSub","QryAntTheSubDenDtl","","2020-07-01","2020-07-31","0001-07-0057-W-4","W","")
Query QryAntTheSubDenDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aLocIDs As %Text = "", aIsAntUse As %String = "0", aDrgPoison As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubDenDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aLocIDs As %Text = "", aIsAntUse As %String = "0", aDrgPoison As %String = "") As %Status
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
	    Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
		For TransInd=1:1:TransInfoArr.Count(){
			Set TransInfo=TransInfoArr.GetAt(TransInd)

			Set TransID=$lg(TransInfo,1)
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		    Set TransTime	= $li(TranData,8)
			Set OutLocTime	= $li(TranData,11)

			//抗菌药物使用信息输出
			Set (OrderInfos,OrderInfo)=""	
			Set AntUseArr =..GetAntUseInfo(Paadm,TransDate,OutLocDate,TransTime,OutLocTime)
			For AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose = $li(OrderInfo,11)
				Continue:UsePurpose'["治疗"
		
				//抗菌药物级别英文转化为中文
				Set DrgPoison  = $li(OrderInfo,13)
				Continue:(aDrgPoison'="")&(aDrgPoison'=DrgPoison)
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
	                  
                //取首次执行时间	                    
                Set ExecDate= $lg(OrdItemData,45)
        		Set ExecTime= $lg(OrdItemData,46)
        		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
				Set:ExecTime'="" ExecTime=$zt(ExecTime)
				Set ExecDateTime = ExecDate_" "_ExecTime
				Set $li(OrderInfo,15)=ExecDateTime
				
                Set OrderInfos=OrderInfos_$lb(OrderInfo)		
			}
			Continue:(aIsAntUse=1)&($ll(OrderInfos)=0)
			
			Set Len=$ll(OrderInfos)
			If (Len>0) {
				For LenInd=1:1:Len {
					Set OrderInfo=$lg(OrderInfos,LenInd)
					Set:OrderInfo="" OrderInfo=$lb("","","","","","","","","","","","","","","")
					Set Data = $lb(DimensDesc,AdmTimes)_PatData_OrderInfo_TransInfo
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}Else {
				Set OrderInfo=$lb("","","","","","","","","","","","","","","")
				Set Data = $lb(DimensDesc,AdmTimes)_PatData_OrderInfo_TransInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryAntTheSubDenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubDenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubDenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubDenDtlExecute ]
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
/// CreatDate：   2022-10-11	
/// Description:  抗菌药物病原学治疗前送检率分子明细表(病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  IsBfCureSubmiss:是否病原学送检
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S171AntTheSub","QryAntTheSubMolDtl","","2020-05-01","2020-05-31","0000-00-0000-A-1","","W","1","0",1,"")
Query QryAntTheSubMolDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDrgPoison As %String = "", aStaType As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLabSubType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubMolDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDrgPoison As %String = "", aStaType As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLabSubType As %String = "", aLocIDs As %Text = "") As %Status
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
 	Set aLocType = aStaType	
 	Set:aLocType="" aLocType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
	//检验类型
	If (aLabSubType=1) {    // 指向性（细菌）
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestBactList")
	}ElseIf(aLabSubType=2) {  // 非指向性（常规检验）
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestCommList")
	}Else {
		Set TestSetCat = ##class(DHCHAI.BT.Config).GetValByCode("LabTestSetList")
	}
	//是否统计门急诊送检
	Set StaOELab = ##class(DHCHAI.BT.Config).GetValByCode("StaOELabSub")
	Set:StaOELab="" StaOELab=0
	//抗菌药物给药途径
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set InstrucList=","_InstrucList_","
	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	
	
  	Set NIndex="QryAntTheSubMolDtl"
	Kill ^TMP($zn,$j,NIndex)

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
	   
	   	Set IsUse=0,IsBfSub=0
		Set AntUseInfo=..GetFirstCureAnt(Paadm,AdmDate,DishDate,InstrucList,aDrgPoison)					
		Set FirstCureDate=$p(AntUseInfo,"^",1)
		Set FirstCureTime=$p(AntUseInfo,"^",2)
		Set:+(FirstCureDate)>0 IsUse=1
        Continue:IsUse=0
		Set IsBfSub=..GetIsBfCureSubmiss(Paadm,AdmDate,DishDate,TestSetCat,aSubDateType,aSubHourType,StaOELab,FirstCureDate,FirstCureTime)
		Continue:IsBfSub=0
	   
	    //获取病人就诊信息
	    Set PatData=..BuildPaadmData(Paadm)
	    Continue:PatData=""
	  	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 	Set AdmTimes = $lg(PAAdmData,38)   //就诊次数
	 	Set LabDatefrom=$lg(PAAdmData,20)
	 	Set LabTimefrom=$lg(PAAdmData,21)
	    Set TransInfoArr =..GetTransInfo(Paadm,"","",aStaType)    //存在转科日期早于入院日期情况，取全部转科记录
		For TransInd=1:1:TransInfoArr.Count(){
			Set TransInfo=TransInfoArr.GetAt(TransInd)

			Set TransID=$lg(TransInfo,1)
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
			Set (OrderInfos,LabInfos,InfPosInfos,OrderInfo,LabInfo,InfPosInfo,LabDateTo,LabTimeTo)=""
			Set AntUseArr =..GetAntUseInfo(Paadm,TransDate,OutLocDate,TransTime,OutLocTime)
			Continue:AntUseArr.Count()<1
			For AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose = $li(OrderInfo,11)
				Continue:UsePurpose'["治疗"					
				Set DrgPoison  = $li(OrderInfo,13)
				Continue:(aDrgPoison'="")&(aDrgPoison'=DrgPoison)
				//抗菌药物级别英文转化为中文
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
				
			    Set:LabDateTo="" LabDateTo=SttDate   //病原学送检截止在抗菌药物开始日期
			    Set:LabTimeTo="" LabTimeTo=SttTime
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
	                  
                //取首次执行时间	                    
                Set ExecDate= $lg(OrdItemData,45)
        		Set ExecTime= $lg(OrdItemData,46)
        		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
				Set:ExecTime'="" ExecTime=$zt(ExecTime)
				Set ExecDateTime = ExecDate_" "_ExecTime
				Set $li(OrderInfo,15)=ExecDateTime

                Set OrderInfos=OrderInfos_$lb(OrderInfo)				
			}
            Continue:($ll(OrderInfos)=0) 
          
            //获取微生物送检记录
			Set LabInfoArr=..GetLabInfo(Paadm,LabDatefrom,LabDateTo,"",TestSetCat,StaOELab,LabTimefrom,LabTimeTo)  //病原学送检
			Continue:LabInfoArr.Count()<1
			For LabInd=1:1:LabInfoArr.Count(){
				//获取送检结果明细
				Set (ResultList,LabResultInfo)=""
				Set SubLabInfo=LabInfoArr.GetAt(LabInd)
				Set VisitNumberID = $lg(SubLabInfo,1)
				Set EpisodeNo	  = $lg(SubLabInfo,5)
				Set CollDate 	  = $lg(SubLabInfo,2)
				Set CollTime	  = $lg(SubLabInfo,6)
				Set Specimen      = $lg(SubLabInfo,3)
				Set TestSet       = $lg(SubLabInfo,7)							
				Set TestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",VisitNumberID,""))

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
			
			//感染信息
            Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",Paadm,1,xRepID))
				Quit:xRepID=""
			
				Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
				Continue:RepData=""
				Set IRStatusDr=$lg(RepData,8)
				Continue:IRStatusDr=""
				Set StatusCode = $lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
				Continue:StatusCode'=3
				
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xSub))
					Quit:xSub=""
			
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xRepID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set DiagID=$lg(INFRepExtData,3)
					Continue:DiagID=""

					Set DiagsInfo=$g(^DHCHAI.IR.INFDiagnosD(DiagID))
					Continue:DiagsInfo=""
					// 感染日期
					Set InfDate = $lg(DiagsInfo,5)
					Set InfXDate = $lg(DiagsInfo,7)
					Continue:InfDate<DateFrom
					Continue:InfDate>DateTo
					Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
					Set:InfXDate'="" InfXDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)

					Set InfTypeCode=$lg(DiagsInfo,18)
					Set InfType=$s(InfTypeCode=0:InfType="社区感染",1:"医疗机构感染")
					// 感染部位/感染诊断
					Set InfPosDr=$lg(DiagsInfo,3)
					Continue:(InfPosDr="")
					Set InfPosInfo=$g(^DHCHAI.BT.InfPosD(InfPosDr))
					Set InfPosDesc=$lg(InfPosInfo,3)
										
					//感染转归	
					Set InfEffect=""
					Set IRInfEffectDr = $lg(DiagsInfo,8)
					If (IRInfEffectDr'=""){
						Set IRInfEffectInfo=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
						Set InfEffect=$lg(IRInfEffectInfo,3)
					}			
					Set InfPosInfo=$lb(DiagID,InfPosDesc,InfType,InfDate,InfEffect,InfXDate)
					Set InfPosInfos=InfPosInfos_$lb(InfPosInfo)
                }
			}
			Set Len=$ll(OrderInfos)
			Set:($ll(LabInfos)<$ll(InfPosInfos)) Len1=$ll(InfPosInfos)
			Set:($ll(LabInfos)>=$ll(InfPosInfos)) Len1=$ll(LabInfos)
			Set:Len<Len1 Len=Len1
			
			For LenInd=1:1:Len {
				Set OrderInfo=$lg(OrderInfos,LenInd)
				Set:OrderInfo="" OrderInfo=$lb("","","","","","","","","","","","","","","")
				Set LabInfo=$lg(LabInfos,LenInd)
				Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
				Set InfPosInfo=$lg(InfPosInfos,LenInd)
				Set:InfPosInfo="" InfPosInfo=$lb("","","","","","")
				
				Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_OrderInfo_LabInfo_InfPosInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
    }

	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntTheSubMolDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubMolDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubMolDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubMolDtlExecute ]
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
/// CreatDate：   2022-10-11
/// 取出院患者首次使用抗菌药物时间
/// w ##class(DHCHAI.STATV2.S171AntTheSub).GetFirstCureAnt(49,$zdh("2020-05-01",3),$zdh("2021-12-31",3),"","KSS2")
ClassMethod GetFirstCureAnt(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInstrucList As %String = "", aDrgPoison As %String = "") As %String
{
	new (aEpisodeID,aDateFrom,aDateTo,aInstrucList,aDrgPoison)
    
    Set return=""
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	
	//首次使用抗菌药物时间
	Set IsFisrt=0,FirstCureDate="",FirstCureTime=""
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		Quit:IsFisrt=1
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			Quit:IsFisrt=1
						
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
				Quit:IsFisrt=1
					
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            Set DrgPoison = $lg(OEOrdItemData,29) //抗菌用药等级
				Continue:(aDrgPoison'="")&(aDrgPoison'=DrgPoison)
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID=""
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1

	            Set SttDate = $li(OEOrdItemData,15)
	            Set SttTime = $li(OEOrdItemData,16)
				Set EndDate = $li(OEOrdItemData,17)
				Set EndTime	= $li(OEOrdItemData,18)
				
	            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"
			
	            If PriorityMap="N"{
					Set EndDate = SttDate
					Set EndTime	= SttTime
				}
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在查询日期前
				Continue:(SttDate>aDateTo)	// 用药日期在查询日期后
			   
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(aInstrucList'="")&&(aInstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Continue:UsePurpose=""
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:UsePurpose'["治疗"				
				Set IsFisrt=1
				Set FirstCureDate=SttDate
				Set FirstCureTime=SttTime			
			}
		}
	}
	Set return=FirstCureDate_"^"_FirstCureTime
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-10-11
/// Description:  判断出院患者是否治疗前送检
/// Return：      
/// w ##class(DHCHAI.STATV2.S171AntTheSub).GetIsBfCureSubmiss(49,$zdh("2020-05-01",3),$zdh("2020-08-31",3),"降钙素原,细菌检测","","0","0","65503","41019")
ClassMethod GetIsBfCureSubmiss(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLabTestSet As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aStaOELab As %String = "0", aFirstCureDate As %String = "", aFirstCureTime As %String = "") As %String
{
	new (aEpisodeID,aDateFrom,aDateTo,aLabTestSet,aSubDateType,aSubHourType,aStaOELab,aFirstCureDate,aFirstCureTime)
	Set return=0
	
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
    Set IsCureUse=0,IsBfCureSubmiss=0	
	Set FirstCureDate =aFirstCureDate
	Set FirstCureTime =aFirstCureTime
	Set:+(FirstCureDate)>0 IsCureUse=1
	Quit:IsCureUse'=1 return
    
	//获取微生物送检记录
	If (IsCureUse=1) {
		//1-aSubDateType:根据入参取时间类型(采样时间/送检医嘱开立时间)
		//目前数据池无送检医嘱数据,暂时不处理
		//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
		Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
		Set LabDateTo=FirstCureDate
		Set LabInfoArr=##class(DHCHAI.STATV2.AbstractComm).GetLabInfo(aEpisodeID,LabDatefrom,LabDateTo,"",aLabTestSet,aStaOELab)
		
		For LabInd=1:1:LabInfoArr.Count(){
			Set LabInfo=LabInfoArr.GetAt(LabInd)
			Set CollDate = $li(LabInfo,2)
			Set CollTime = $li(LabInfo,6)
			If (aSubDateType="2") {				//医嘱开立日期
				Set EpisodeNo=$li(LabInfo,5)	//标本号
				Set (OrdID,SubID,OEOrdDate,OEOrdTime)=""
				Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
				Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
				Set OEOrdDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",7) 			//开医嘱日期（OEORI_Date）
				Set OEOrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",17)			//开医嘱时间（OEORI_TimeOrd）
				Set:OEOrdDate'="" CollDate = OEOrdDate
				Set:OEOrdTime'="" CollTime = OEOrdTime
			}
			//采集日期时间在治疗之前，算作治疗前送检
			If ((CollDate<aFirstCureDate)||((CollDate=aFirstCureDate)&(CollTime<aFirstCureTime))) {
				//规定范围内
				If (aSubHourType=0){
					Set IsBfCureSubmiss=1 	//无限制
				} else{
					Set SubHour=((aFirstCureDate-CollDate)*86400+(aFirstCureTime-CollTime))\3600
					Set:(aSubHourType=1)&(SubHour<24) IsBfCureSubmiss=1
					Set:(aSubHourType=2)&(SubHour<48) IsBfCureSubmiss=1
					Set:(aSubHourType=3)&(SubHour<72) IsBfCureSubmiss=1
					Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfCureSubmiss=1
				}
			}
			
			Quit:IsBfCureSubmiss=1
		}
	}	
	Set return=IsBfCureSubmiss
	
	Quit return
}

}
