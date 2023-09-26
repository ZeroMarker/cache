/// 名称: DHCHAI.STATV2.S170AntTheSub
/// 描述: 住院患者抗菌药物治疗前病原学送检率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S170AntTheSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2021-08-16	
/// Description:  住院患者抗菌药物治疗前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S170AntTheSub","QryAntTheSub","1|2","2020-05-01","2020-05-31","","0","W","1","1","","","")
Query QryAntTheSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aSubDateType As %String = "", aSubHourType As %String = "0", aLocType As %String = "", aQryCon As %String = "1", aUseSubDateType As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "", aLabSubType As %String = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,CureUseAntiCnt:%Integer,BfCureSubmissCnt:%Integer,BfCureSubRatio:%String,CureUseKSS1:%Integer,UseKSS1AndSub:%Integer,UseKSS1SubRatio:%String,CureUseKSS2:%Integer,UseKSS2AndSub:%Integer,UseKSS2SubRatio:%String,CureUseKSS3:%Integer,UseKSS3AndSub:%Integer,UseKSS3SubRatio:%String,UnBfCureSubCnt:%Integer") [ SqlProc ]
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
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:IsStatParWard="" IsStatParWard=0
	
    Set NIndex="QryAntTheSub"
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
				
		        Set AntUseArr="",IsCureUse=0
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aLocType,"",aSubDateType,aSubHourType,"1",aUseSubDateType,TestSetCat,StaOELab,aLocIDs,IsStatParWard)
				Set:AntUseArr.Count()>0 IsCureUse=1
		    		
				Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
				For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					// 住院患者人数
					If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)) {
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
					}
					If (LocCount>1) {
						// 合计住院患者
						If '$d(^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)){
							Set num=$i(^TMP($zn,$j,NIndex,"Sum","PatAdm"))
							Set ^TMP($zn,$j,NIndex,"Sum","PatAdm",Paadm)=""
						}
					}
					Set DHospDr   = +$p(DimensKey,"-",1)
					Set DGroupDr  = +$p(DimensKey,"-",2)
					Set DLocID    = +$p(DimensKey,"-",3)
					Set DType     = $p(DimensKey,"-",4)
					Set DHGroupDr = +$p(DimensKey,"-",5)
					Set DTypeID =""
					Set DTypeID=$s(DType="A":DHGroupDr,DType="H":DHospDr,DType="G":(DHospDr_"||"_DGroupDr),DType="E":DLocID,DType="W":DLocID)
					
					If (IsCureUse=1) {
						For AntInd=1:1:AntUseArr.Count(){
							Set AntUseInfo=AntUseArr.GetAt(AntInd)
						    Continue:AntUseInfo=""
						    Set Type =$lg(AntUseInfo,1)
						    Continue:(DType'=Type)&(Type'="Sum")
						    Set TypeID =$lg(AntUseInfo,2)
						    Set:StatDimensStr="G" TypeID="0"_"||"_$p(TypeID,"||",2)  //分组不区分医院时特殊处理（不同医院分组下患者转院不出院情况是否存在、影响？）
						    Continue:(Type'="Sum")&(DTypeID'=TypeID)
						    Continue:(Type="Sum")&((","_aLocIDs_",")'[(","_TypeID_","))
						    
							Set IsCureUse       =$lg(AntUseInfo,3)
							Set IsBfCureSub 	=$lg(AntUseInfo,4)
							Set IsKSS1CureUse   =$lg(AntUseInfo,5)
							Set IsBfKSS1CureSub =$lg(AntUseInfo,6)
							Set IsKSS2CureUse   =$lg(AntUseInfo,7)
							Set IsBfKSS2CureSub =$lg(AntUseInfo,8)
							Set IsKSS3CureUse   =$lg(AntUseInfo,9)
							Set IsBfKSS3CureSub =$lg(AntUseInfo,10)
					
							Set TypeDesc=DimensKey
							Set:(Type="Sum") TypeDesc="Sum" //合计科室

							//治疗使用抗菌药物
							If (IsCureUse=1) {
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse",Paadm)=""
								}
							}
							//治疗前送检
							If (IsBfCureSub=1) {
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss",Paadm)=""
								}
							}
							// 非限制类抗菌药物使用人数
							If (IsKSS1CureUse=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS1",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS1"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS1",Paadm)=""
								}
							}
							// 非限制类抗菌药物送检人数
							If (IsBfKSS1CureSub=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS1AndSub",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS1AndSub"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"UseKSS1AndSub",Paadm)=""
								}
							}
							// 限制类抗菌药物使用人数
							If (IsKSS2CureUse=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS2",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS2"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS2",Paadm)=""
								}
							}
							// 限制类抗菌药物送检人数
							If (IsBfKSS2CureSub=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS2AndSub",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS2AndSub"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"UseKSS2AndSub",Paadm)=""
								}
							}
							// 特殊类抗菌药物使用人数
							If (IsKSS3CureUse=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS3",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS3"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"CureUseKSS3",Paadm)=""
								}
							}
							// 特殊类抗菌药物送检人数
							If (IsBfKSS3CureSub=1){
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS3AndSub",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"UseKSS3AndSub"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"UseKSS3AndSub",Paadm)=""
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
		Set xDimensKey	= $lg(DimList,1)
		Set LocDr = +$p(xDimensKey,"-",3)
		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))

		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:((HospIDCount="1")&(xDimensKey["A"))
		Continue:xDimensKey=""
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  			//在院患者数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureUse"))		//抗感染药治疗使用人数
		Set BfCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfCureSubmiss"))  //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//Anti使用率
		Set UnBfCureSubCnt=CureUseAntiCnt-BfCureSubmissCnt                          //治疗前未送检
		
		
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
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(BfCureSubmissCnt=0)
		Continue:(aQryCon="3")&&(CureUseAntiCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,CureUseKSS1,UseKSS1AndSub,UseKSS1SubRatio,CureUseKSS2,UseKSS2AndSub,UseKSS2SubRatio,CureUseKSS3,UseKSS3AndSub,UseKSS3SubRatio,UnBfCureSubCnt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	

	If (LocCount>1) {	//科室合计
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","IsCureUse"))		//抗感染药治疗使用人数
		Set BfCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,"Sum","IsBfCureSubmiss"))  //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//Anti使用率
		Set UnBfCureSubCnt=CureUseAntiCnt-BfCureSubmissCnt                          //治疗前未送检

		Set CureUseKSS1  	=+$g(^TMP($zn,$j,NIndex,"Sum","CureUseKSS1"))  		// 非限制类抗感染药使用人数
		Set UseKSS1AndSub	=+$g(^TMP($zn,$j,NIndex,"Sum","UseKSS1AndSub"))  		// 非限制类抗感染药送检人数
		Set CureUseKSS2  	=+$g(^TMP($zn,$j,NIndex,"Sum","CureUseKSS2"))  		// 限制类抗感染药使用人数
		Set UseKSS2AndSub	=+$g(^TMP($zn,$j,NIndex,"Sum","UseKSS2AndSub"))  		// 限制类抗感染药送检人数
		Set CureUseKSS3  	=+$g(^TMP($zn,$j,NIndex,"Sum","CureUseKSS3"))  		// 特殊类抗感染药使用人数
		Set UseKSS3AndSub	=+$g(^TMP($zn,$j,NIndex,"Sum","UseKSS3AndSub"))  		// 特殊类抗感染药送检人数
		Set UseKSS1SubRatio="0.00%",UseKSS2SubRatio="0.00%",UseKSS3SubRatio="0.00%"
		Set:CureUseKSS1>0 UseKSS1SubRatio=$fn((UseKSS1AndSub/CureUseKSS1)*100,"",2)_"%"  // 非限制类抗菌药物送检率
		Set:CureUseKSS2>0 UseKSS2SubRatio=$fn((UseKSS2AndSub/CureUseKSS2)*100,"",2)_"%"  // 限制类抗菌药物送检率
		Set:CureUseKSS3>0 UseKSS3SubRatio=$fn((UseKSS3AndSub/CureUseKSS3)*100,"",2)_"%"  // 特殊类抗菌药物送检率
	
		Set Data=$lb("","全部",PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,CureUseKSS1,UseKSS1AndSub,UseKSS1SubRatio,CureUseKSS2,UseKSS2AndSub,UseKSS2SubRatio,CureUseKSS3,UseKSS3AndSub,UseKSS3SubRatio,UnBfCureSubCnt)
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
/// Description:  抗菌药物治疗前送检率住院患者明细表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aLocType： 科室类型
/// 			  aLocGroup：科室分组  
/// 			  aLocIDs：  科室  
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S170AntTheSub","QryAntTheSubDenDtl","","2020-07-01","2020-07-31","0001-07-0057-W-4","W","")
Query QryAntTheSubDenDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aLocIDs As %Text = "", aIsAntUse As %String = "0", aDrgPoison As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String") [ SqlProc ]
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
 	Set aLocType = aStaType		
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

					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			        Set:TransTime'="" TransTime=$zt(TransTime)
				    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
			    	Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
				
					//抗菌药物使用信息输出
					Set (OrderInfos,OrderInfo)=""				
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)					
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
	                    Set OrderInfo=OrderInfo_$lb(CarPrvTpDesc)
	                    
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

/// Creator：     ShenC
/// CreatDate：   2020-05-21
/// Description:  抗菌药物病原学治疗前送检率分子明细表(病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  IsBfCureSubmiss:是否病原学送检
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S170AntTheSub","QryAntTheSubMolDtl","1","2020-05-01","2020-05-31","0001-07-0027-W-4","","W","1","0",1,"1","")
Query QryAntTheSubMolDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDrgPoison As %String = "", aStaType As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLabSubType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
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
	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:IsStatParWard="" IsStatParWard=0

  	Set NIndex="QryAntTheSubMolDtl"
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
				
				If TransType="E" {
					Set LocDr  = LocID
					Set WardDr = ""
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
				
				Set IsCureUse=0,IsKSS1CureUse=0,IsKSS2CureUse=0,IsKSS3CureUse=0
				Set IsBfCureSub=0,IsBfKSS1CureSub=0,IsBfKSS2CureSub=0,IsBfKSS3CureSub=0
				//获取病人抗菌药物治疗、治疗前送检信息
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aStaType,"",aSubDateType,aSubHourType,"1",aUseSubDateType,TestSetCat,StaOELab,aLocIDs,IsStatParWard)
				Continue:AntUseArr.Count()<1    //过滤非治疗性用药患者	
				Set IsBfSub=0
				Set DHospDr   = +$p(aDimensKey,"-",1)
				Set DGroupDr  = +$p(aDimensKey,"-",2)
				Set DLocID    = +$p(aDimensKey,"-",3)
				Set DType     = $p(aDimensKey,"-",4)
				Set DHGroupDr = +$p(aDimensKey,"-",5)
				Set DTypeID =""
				Set:DType="" DType="Sum"
				Set DTypeID=$s(DType="A":DHGroupDr,DType="H":DHospDr,DType="G":(DHospDr_"||"_DGroupDr),DType="E":DLocID,DType="W":DLocID,DType="Sum":aLocIDs)
				
				For AntInd=1:1:AntUseArr.Count(){
					Set AntUseInfo=AntUseArr.GetAt(AntInd)
				    Continue:AntUseInfo=""
				    Continue:IsBfSub=1
				    Set Type =$lg(AntUseInfo,1)
				    Continue:DType'=Type
				    Set TypeID =$lg(AntUseInfo,2)
				    Set:(DType'="A")&(aDimensKey'="")&(+$p(aDimensKey,"-",1)=0) TypeID="0"_"||"_$p(TypeID,"||",2)  //分组不区分医院时特殊处理（不同医院分组下患者转院不出院情况是否存在、影响？）
				    Continue:(DTypeID'=TypeID)
				    
					Set IsCureUse       =$lg(AntUseInfo,3)
					Set IsBfCureSub 	=$lg(AntUseInfo,4)
					Continue:(IsBfCureSub'=1)&(aDrgPoison="")
					Set IsKSS1CureUse   =$lg(AntUseInfo,5)
					Set IsBfKSS1CureSub =$lg(AntUseInfo,6)
					Continue:(IsBfKSS1CureSub'=1)&(aDrgPoison="KSS1")
					Set IsKSS2CureUse   =$lg(AntUseInfo,7)
					Set IsBfKSS2CureSub =$lg(AntUseInfo,8)
					Continue:(IsBfKSS2CureSub'=1)&(aDrgPoison="KSS2")
					Set IsKSS3CureUse   =$lg(AntUseInfo,9)
					Set IsBfKSS3CureSub =$lg(AntUseInfo,10)
					Continue:(IsBfKSS3CureSub'=1)&(aDrgPoison="KSS3")
					Set IsBfSub=1
				}
				Continue:IsBfSub'=1

				//获取病人基本信息
				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 			Set AdmTimes = $lg(PAAdmData,38)   //就诊次数
				Set LabDatefrom=$lg(PAAdmData,20)
				Set LabTimefrom=$lg(PAAdmData,21)
				
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
					Set TransInfo=$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
					
					//获取抗菌药物使用信息
					Set (OrderInfos,LabInfos,InfPosInfos,OrderInfo,LabInfo,InfPosInfo,LabDateTo,LabTimeTo)=""
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)
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
								
					    Set OrdItemID=$lg(OrderInfo,1)
						Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
		                //取首次执行时间	                    
		                Set ExecDate= $lg(OrdItemData,45)
		        		Set ExecTime= $lg(OrdItemData,46)
					    If (aUseSubDateType=2) {
						    Set:LabDateTo="" LabDateTo=ExecDate   //病原学送检截止在抗菌药物开始日期
					    	Set:LabTimeTo="" LabTimeTo=ExecTime
					    }Else {
						    Set:LabDateTo="" LabDateTo=SttDate   //病原学送检截止在抗菌药物开始日期
					    	Set:LabTimeTo="" LabTimeTo=SttTime
					    }
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
                		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
						Set:ExecTime'="" ExecTime=$zt(ExecTime)
						Set ExecDateTime = ExecDate_" "_ExecTime
						Set $li(OrderInfo,15)=ExecDateTime
	                    
		                Set OrderInfos=OrderInfos_$lb(OrderInfo)				
					}
	                Continue:($ll(OrderInfos)=0) 
	              
	                //获取微生物送检记录
					Set LabInfoArr=..GetLabInfo(Paadm,LabDatefrom,LabDateTo,"",TestSetCat,StaOELab,LabTimefrom,LabTimeTo,aLabSubType,aSubDateType)  //病原学送检
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
/// CreatDate：   2023-05-18	
/// Description:  抗菌药物治疗未病原学前送检明细表(病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S170AntTheSub","QryAntTheSubUnBfDtl","1","2020-05-01","2020-05-31","0001-01-0026-E-4","E","1","0","1","","")
Query QryAntTheSubUnBfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLabSubType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubUnBfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLabSubType As %String = "", aLocIDs As %Text = "") As %Status
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
	//检出菌监测项目
	Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:IsStatParWard="" IsStatParWard=0

  	Set NIndex="QryAntTheSubUnBfDtl"
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
				
				If TransType="E" {
					Set LocDr  = LocID
					Set WardDr = ""
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
		      
				//获取病人抗菌药物治疗、治疗前送检信息
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aStaType,"",aSubDateType,aSubHourType,"1",aUseSubDateType,TestSetCat,StaOELab,aLocIDs,IsStatParWard)
				Continue:AntUseArr.Count()<1    //过滤非治疗性用药患者
			   
				Set IsBfSub=0,IsUse=0
				Set DHospDr   = +$p(aDimensKey,"-",1)
				Set DGroupDr  = +$p(aDimensKey,"-",2)
				Set DLocID    = +$p(aDimensKey,"-",3)
				Set DType     = $p(aDimensKey,"-",4)
				Set DHGroupDr = +$p(aDimensKey,"-",5)
				Set DTypeID =""
				Set:DType="" DType="Sum"
				Set DTypeID=$s(DType="A":DHGroupDr,DType="H":DHospDr,DType="G":(DHospDr_"||"_DGroupDr),DType="E":DLocID,DType="W":DLocID,DType="Sum":aLocIDs)
				
				For AntInd=1:1:AntUseArr.Count(){
					Set AntUseInfo=AntUseArr.GetAt(AntInd)
				    Continue:AntUseInfo=""
				    Continue:IsBfSub=1
				    Set Type =$lg(AntUseInfo,1)
				    Continue:DType'=Type
				    Set TypeID =$lg(AntUseInfo,2)
				    Set:(DType'="A")&(aDimensKey'="")&(+$p(aDimensKey,"-",1)=0) TypeID="0"_"||"_$p(TypeID,"||",2)  //分组不区分医院时特殊处理（不同医院分组下患者转院不出院情况是否存在、影响？）
				    Continue:(DTypeID'=TypeID)

					Set IsCureUse       =$lg(AntUseInfo,3)
					Continue:(IsCureUse'=1)     //update20230413 转科情况存在AntUseArr不为空，某个科室未用药的情况，需过滤未使用抗菌药物的
					Set IsUse=1
					Set IsBfCureSub 	=$lg(AntUseInfo,4)
					Continue:(IsBfCureSub'=1)	
					Set IsBfSub=1
				}
				Continue:IsUse'=1
				Continue:IsBfSub=1
				
               
				//获取病人基本信息
				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 			Set AdmTimes = $lg(PAAdmData,38)   //就诊次数
				Set LabDatefrom=$lg(PAAdmData,20)
		        Set LabTimefrom=$lg(PAAdmData,21)
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
					Set TransInfo=$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)
			
					//获取抗菌药物使用信息
					Set (OrderInfos,LabInfos,InfPosInfos,OrderInfo,LabInfo,InfPosInfo,LabDateTo,LabTimeTo)=""
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)
					Continue:AntUseArr.Count()<1
					For AntInd=1:1:AntUseArr.Count(){
						Set OrderInfo=AntUseArr.GetAt(AntInd)
						Set UsePurpose = $li(OrderInfo,11)
						Continue:UsePurpose'["治疗"					
						Set DrgPoison  = $li(OrderInfo,13)
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
						
						Set OrdItemID=$lg(OrderInfo,1)
						Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
		                //取首次执行时间	                    
		                Set ExecDate= $lg(OrdItemData,45)
		        		Set ExecTime= $lg(OrdItemData,46)
					    If (aUseSubDateType=2) {
						    Set:LabDateTo="" LabDateTo=ExecDate   //病原学送检截止在抗菌药物开始日期
					    	Set:LabTimeTo="" LabTimeTo=ExecTime
					    }Else {
						    Set:LabDateTo="" LabDateTo=SttDate   //病原学送检截止在抗菌药物开始日期
					    	Set:LabTimeTo="" LabTimeTo=SttTime
					    }
		        		
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
                		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
						Set:ExecTime'="" ExecTime=$zt(ExecTime)
						Set ExecDateTime = ExecDate_" "_ExecTime
						Set $li(OrderInfo,15)=ExecDateTime
						
		 				Set OrderInfos=OrderInfos_$lb(OrderInfo)				
					}
	                Continue:($ll(OrderInfos)=0) 
	                
	                //获取微生物送检记录
					Set LabInfoArr=..GetLabInfo(Paadm,LabDatefrom,LabDateTo,"",TestSetCat,StaOELab,LabTimefrom,LabTimeTo,aLabSubType,aSubDateType)  //病原学送检
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
					zw OrderInfos
					w !
					zw InfPosInfos
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
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntTheSubUnBfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubUnBfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubUnBfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubUnBfDtlExecute ]
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
/// CreatDate：   2022-07-15
/// Description:  判断病人治疗使用及治疗前送检信息
/// Return：      
/// zw ##class(DHCHAI.STATV2.S170AntTheSub).GetAntLabInfo(166,$zdh("2020-05-01",3),$zdh("2020-05-31",3),"W","","","0","1","","")
ClassMethod GetAntLabInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aDrgPoison As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aAntKeyList As %String = "0", aUseSubDateType As %String = "1", aTestSetCat As %String = "", aStaOELab As %String = "0", aLocIDs As %Text = "", aIsStatParWard As %String = "0") As %Library.ArrayOfDataTypes
{
	
	new (aEpisodeID,aDateFrom,aDateTo,aLocType,aDrgPoison,aSubDateType,aSubHourType,aAntKeyList,aUseSubDateType,aTestSetCat,aStaOELab,aLocIDs,aIsStatParWard)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
    Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="")||(aLocType="") return
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数

    Kill ^TMP($zn,$j,"FirstAntInfo")
	Kill ^TMP($zn,$j,"GetFirstAntInfo")
	
	//启用虚拟病区查询
	If (aIsStatParWard=1)&&(aLocType'="E"){
	   	Set xTransID=""
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID,xTransID))
			Quit:xTransID=""

			Set TranData= $g(^DHCHAI.DP.PAAdmTransD(xTransID))
			Continue:TranData=""
			Set TransType   = $lg(TranData,4)
			Continue:(TransType'="B")
			Set TransLocDr  = $lg(TranData,5)
			Set TransDate	= $lg(TranData,7)
		    Set OutLocDate	= $lg(TranData,10)
		    Set TransBedDr  = $lg(TranData,6)	
			Continue:TransBedDr=""
			Set TransBedInfo = $g(^DHCHAI.BT.PACBedD(TransBedDr))
			Continue:TransBedInfo=""
			Set TransLocDr = $lg(TransBedInfo,11)	    
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_TransLocDr_","))
		    Continue:(TransDate>aDateTo)
		    Continue:(OutLocDate'="")&(OutLocDate<aDateFrom)
		    Set ^TMP($zn,$j,"GetFirstAntInfo","TransLoc",TransLocDr,xTransID)=""
		}
	}Else{
		Set xTransID=""
		For {
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID,xTransID))
			Quit:xTransID=""

			Set TranData= $g(^DHCHAI.DP.PAAdmTransD(xTransID))
			Continue:TranData=""
			Set TransType   = $lg(TranData,4)
			Continue:(TransType'=aLocType)
			Set TransLocDr  = $lg(TranData,5)
			Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_TransLocDr_","))
			Set TransDate	= $lg(TranData,7)
		    Set OutLocDate	= $lg(TranData,10)
		    Continue:(TransDate>aDateTo)
		    Continue:(OutLocDate'="")&(OutLocDate<aDateFrom)
		    Set ^TMP($zn,$j,"GetFirstAntInfo","TransLoc",TransLocDr,xTransID)=""
		}
	}
	Set xTranLocID=""
	For {
		Set xTranLocID = $o(^TMP($zn,$j,"GetFirstAntInfo","TransLoc",xTranLocID))
		Quit:xTranLocID=""
		
		Set LocData = $g(^DHCHAI.BT.LocationD(xTranLocID))
		Continue:LocData=""
		Set HospDr  = $lg(LocData,8)
		Set GroupDr = $lg(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		Set HospInfo="",HospGroupDr=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
		Set HospGroupDr=$lg(HospInfo,5)
		
		//获取抗菌药物使用信息
		Set IsAntUse=0,IsCureUse=0
		Set IsKSS1CureUse=0,IsKSS2CureUse=0,IsKSS3CureUse=0
		//首次使用抗菌药物时间(以科室为最小单位计算)
   		Set FirstCureDate=99999,FirstCureTime=99999
		Set FirstKSS1CureDate=99999,FirstKSS1CureTime=99999, FirstKSS2CureDate=99999,FirstKSS2CureTime=99999,FirstKSS3CureDate=99999,FirstKSS3CureTime=99999
	
		Set xID=""
		For {
			Set xID = $o(^TMP($zn,$j,"GetFirstAntInfo","TransLoc",xTranLocID,xID))
			Quit:xID=""
			Set TranData= $g(^DHCHAI.DP.PAAdmTransD(xID))
			Continue:TranData=""
			Set TransDate	= $lg(TranData,7)
	    	Set OutLocDate	= $lg(TranData,10)
		    Set TransTime	= $lg(TranData,8)
			Set OutLocTime	= $lg(TranData,11)
			//如果转科起止日期大于统计日期，以统计日期计算
			Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
			Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
			Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""

			Set AntUseArr =..GetAntUseInfo(aEpisodeID,DateFrom,DateTo,TimeFrom,TimeTo,aAntKeyList)	
			Set:AntUseArr.Count()>0 IsAntUse=1
			For AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose = $li(OrderInfo,11)
				Continue:UsePurpose'["治疗"
				Set KSS	= $li(OrderInfo,13)
				Continue:(aDrgPoison'="")&&(aDrgPoison'=KSS)
		
				Set SttDate=$p($lg(OrderInfo,7)," ",1)
				Set SttTime=$p($lg(OrderInfo,7)," ",2)
				If (aUseSubDateType="2") {				//护士执行时间
					Set OrdItemID=$lg(OrderInfo,1)
			   	 	Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
                 	Continue:$lg(OEOrdItemData,25)=0
                	Set AntExecDate= $lg(OEOrdItemData,45)
                	Set AntExecTime= $lg(OEOrdItemData,46)
					Set:AntExecDate'="" SttDate =AntExecDate
					Set:AntExecTime'="" SttTime =AntExecTime
				}	
				
				Set IsCureUse=1
				If ((FirstCureDate>SttDate)||((FirstCureDate=SttDate)&(FirstCureTime>SttTime))) {
					Set FirstCureDate=SttDate
					Set FirstCureTime=SttTime
				}
					
				If (KSS="KSS1") {
					Set IsKSS1CureUse=1
					If ((FirstKSS1CureDate>SttDate)||((FirstKSS1CureDate=SttDate)&(FirstKSS1CureTime>SttTime))) {
						Set FirstKSS1CureDate=SttDate
						Set FirstKSS1CureTime=SttTime
					}
				}
				If (KSS="KSS2") {
					Set IsKSS2CureUse=1
					If ((FirstKSS2CureDate>SttDate)||((FirstKSS2CureDate=SttDate)&(FirstKSS2CureTime>SttTime))) {
						Set FirstKSS2CureDate=SttDate
						Set FirstKSS2CureTime=SttTime
					}
				}
				If (KSS="KSS3"){
					Set IsKSS3CureUse=1
					If ((FirstKSS3CureDate>SttDate)||((FirstKSS3CureDate=SttDate)&(FirstKSS3CureTime>SttTime))) {
						Set FirstKSS3CureDate=SttDate
						Set FirstKSS3CureTime=SttTime
					}
				}	
			}
		}
		Continue:IsCureUse'=1
		
		//科室首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)=""
			
			Set LFirstCureDate=FirstCureDate,LFirstCureTime=FirstCureTime
			Set LFirstKSS1CureDate=FirstKSS1CureDate,LFirstKSS1CureTime=FirstKSS1CureTime
			Set LFirstKSS2CureDate=FirstKSS2CureDate,LFirstKSS2CureTime=FirstKSS2CureTime
			Set LFirstKSS3CureDate=FirstKSS3CureDate,LFirstKSS3CureTime=FirstKSS3CureTime
			
			Set ^TMP($zn,$j,"FirstAntInfo",aLocType,xTranLocID)=$lb(LFirstCureDate,LFirstCureTime,LFirstKSS1CureDate,LFirstKSS1CureTime,LFirstKSS2CureDate,LFirstKSS2CureTime,LFirstKSS3CureDate,LFirstKSS3CureTime)
		}
		
		//科室分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)) {   //update 20220902 处理多院区患者转院不出院的情况
			Set ^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)=""
			Set GFirstCureDate=FirstCureDate,GFirstCureTime=FirstCureTime
			Set GFirstKSS1CureDate=FirstKSS1CureDate,GFirstKSS1CureTime=FirstKSS1CureTime
			Set GFirstKSS2CureDate=FirstKSS2CureDate,GFirstKSS2CureTime=FirstKSS2CureTime
			Set GFirstKSS3CureDate=FirstKSS3CureDate,GFirstKSS3CureTime=FirstKSS3CureTime

			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstCureDate,GFirstCureTime,GFirstKSS1CureDate,GFirstKSS1CureTime,GFirstKSS2CureDate,GFirstKSS2CureTime,GFirstKSS3CureDate,GFirstKSS3CureTime)
		} Else {
			If ((FirstCureDate<GFirstCureDate)||((FirstCureDate=GFirstCureDate)&(FirstCureTime<GFirstCureTime))) {
				Set GFirstCureDate=FirstCureDate
				Set GFirstCureTime=FirstCureTime
			}
			If ((FirstKSS1CureDate<GFirstKSS1CureDate)||((FirstKSS1CureDate=GFirstKSS1CureDate)&(FirstKSS1CureTime<GFirstKSS1CureTime))) {
				Set GFirstKSS1CureDate=FirstKSS1CureDate
				Set GFirstKSS1CureTime=FirstKSS1CureTime
			}
			If ((FirstKSS2CureDate<GFirstKSS2CureDate)||((FirstKSS2CureDate=GFirstKSS2CureDate)&(FirstKSS2CureTime<GFirstKSS2CureTime))) {
				Set GFirstKSS2CureDate=FirstKSS2CureDate
				Set GFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<GFirstKSS3CureDate)||((FirstKSS3CureDate=GFirstKSS3CureDate)&(FirstKSS3CureTime<GFirstKSS3CureTime))) {
				Set GFirstKSS3CureDate=FirstKSS3CureDate
				Set GFirstKSS3CureTime=FirstKSS3CureTime
			}
			
			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstCureDate,GFirstCureTime,GFirstKSS1CureDate,GFirstKSS1CureTime,GFirstKSS2CureDate,GFirstKSS2CureTime,GFirstKSS3CureDate,GFirstKSS3CureTime)
		}
		
		If (LocCount>1) {   //多个科室合计
			If '$d(^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)) {
				Set ^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)=""
				Set SFirstCureDate=FirstCureDate,SFirstCureTime=FirstCureTime
				Set SFirstKSS1CureDate=FirstKSS1CureDate,SFirstKSS1CureTime=FirstKSS1CureTime
				Set SFirstKSS2CureDate=FirstKSS2CureDate,SFirstKSS2CureTime=FirstKSS2CureTime
				Set SFirstKSS3CureDate=FirstKSS3CureDate,SFirstKSS3CureTime=FirstKSS3CureTime

				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstCureDate,SFirstCureTime,SFirstKSS1CureDate,SFirstKSS1CureTime,SFirstKSS2CureDate,SFirstKSS2CureTime,SFirstKSS3CureDate,SFirstKSS3CureTime)
			} Else {
				If ((FirstCureDate<SFirstCureDate)||((FirstCureDate=SFirstCureDate)&(FirstCureTime<SFirstCureTime))) {
					Set SFirstCureDate=FirstCureDate
					Set SFirstCureTime=FirstCureTime
				}
				If ((FirstKSS1CureDate<SFirstKSS1CureDate)||((FirstKSS1CureDate=SFirstKSS1CureDate)&(FirstKSS1CureTime<SFirstKSS1CureTime))) {
					Set SFirstKSS1CureDate=FirstKSS1CureDate
					Set SFirstKSS1CureTime=FirstKSS1CureTime
				}
				If ((FirstKSS2CureDate<SFirstKSS2CureDate)||((FirstKSS2CureDate=SFirstKSS2CureDate)&(FirstKSS2CureTime<SFirstKSS2CureTime))) {
					Set SFirstKSS2CureDate=FirstKSS2CureDate
					Set SFirstKSS2CureTime=FirstKSS2CureTime
				}
				If ((FirstKSS3CureDate<SFirstKSS3CureDate)||((FirstKSS3CureDate=SFirstKSS3CureDate)&(FirstKSS3CureTime<SFirstKSS3CureTime))) {
					Set SFirstKSS3CureDate=FirstKSS3CureDate
					Set SFirstKSS3CureTime=FirstKSS3CureTime
				}
				
				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstCureDate,SFirstCureTime,SFirstKSS1CureDate,SFirstKSS1CureTime,SFirstKSS2CureDate,SFirstKSS2CureTime,SFirstKSS3CureDate,SFirstKSS3CureTime)
			}
		}
		
		
		//医院首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)=""
			Set HFirstCureDate=FirstCureDate,HFirstCureTime=FirstCureTime
			Set HFirstKSS1CureDate=FirstKSS1CureDate,HFirstKSS1CureTime=FirstKSS1CureTime
			Set HFirstKSS2CureDate=FirstKSS2CureDate,HFirstKSS2CureTime=FirstKSS2CureTime
			Set HFirstKSS3CureDate=FirstKSS3CureDate,HFirstKSS3CureTime=FirstKSS3CureTime

			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstCureDate,HFirstCureTime,HFirstKSS1CureDate,HFirstKSS1CureTime,HFirstKSS2CureDate,HFirstKSS2CureTime,HFirstKSS3CureDate,HFirstKSS3CureTime)
		}Else{
			If ((FirstCureDate<HFirstCureDate)||((FirstCureDate=HFirstCureDate)&(FirstCureTime<HFirstCureTime))) {
				Set HFirstCureDate=FirstCureDate
				Set HFirstCureTime=FirstCureTime
			}		
			If ((FirstKSS1CureDate<HFirstKSS1CureDate)||((FirstKSS1CureDate=HFirstKSS1CureDate)&(FirstKSS1CureTime<HFirstKSS1CureTime))) {
				Set HFirstKSS1CureDate=FirstKSS1CureDate
				Set HFirstKSS1CureTime=FirstKSS1CureTime
			}
			If ((FirstKSS2CureDate<HFirstKSS2CureDate)||((FirstKSS2CureDate=HFirstKSS2CureDate)&(FirstKSS2CureTime<HFirstKSS2CureTime))) {
				Set HFirstKSS2CureDate=FirstKSS2CureDate
				Set HFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<HFirstKSS3CureDate)||((FirstKSS3CureDate=HFirstKSS3CureDate)&(FirstKSS3CureTime<HFirstKSS3CureTime))) {
				Set HFirstKSS3CureDate=FirstKSS3CureDate
				Set HFirstKSS3CureTime=FirstKSS3CureTime
			}

			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstCureDate,HFirstCureTime,HFirstKSS1CureDate,HFirstKSS1CureTime,HFirstKSS2CureDate,HFirstKSS2CureTime,HFirstKSS3CureDate,HFirstKSS3CureTime)
		}
		//医院分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)=""
			Set HGFirstCureDate=FirstCureDate,HGFirstCureTime=FirstCureTime
			Set HGFirstKSS1CureDate=FirstKSS1CureDate,HGFirstKSS1CureTime=FirstKSS1CureTime
			Set HGFirstKSS2CureDate=FirstKSS2CureDate,HGFirstKSS2CureTime=FirstKSS2CureTime
			Set HGFirstKSS3CureDate=FirstKSS3CureDate,HGFirstKSS3CureTime=FirstKSS3CureTime
			
			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstCureDate,HGFirstCureTime,HGFirstKSS1CureDate,HGFirstKSS1CureTime,HGFirstKSS2CureDate,HGFirstKSS2CureTime,HGFirstKSS3CureDate,HGFirstKSS3CureTime)
		}Else{
			If ((FirstCureDate<HGFirstCureDate)||((FirstCureDate=HGFirstCureDate)&(FirstCureTime<HGFirstCureTime))) {
				Set HGFirstCureDate=FirstCureDate
				Set HGFirstCureTime=FirstCureTime
			}
			If ((FirstKSS1CureDate<HGFirstKSS1CureDate)||((FirstKSS1CureDate=HGFirstKSS1CureDate)&(FirstKSS1CureTime<HGFirstKSS1CureTime))) {
				Set HGFirstKSS1CureDate=FirstKSS1CureDate
				Set HGFirstKSS1CureTime=FirstKSS1CureTime
			}
			If ((FirstKSS2CureDate<HGFirstKSS2CureDate)||((FirstKSS2CureDate=HGFirstKSS2CureDate)&(FirstKSS2CureTime<HGFirstKSS2CureTime))) {
				Set HGFirstKSS2CureDate=FirstKSS2CureDate
				Set HGFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<HGFirstKSS3CureDate)||((FirstKSS3CureDate=HGFirstKSS3CureDate)&(FirstKSS3CureTime<HGFirstKSS3CureTime))) {
				Set HGFirstKSS3CureDate=FirstKSS3CureDate
				Set HGFirstKSS3CureTime=FirstKSS3CureTime
			}

			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstCureDate,HGFirstCureTime,HGFirstKSS1CureDate,HGFirstKSS1CureTime,HGFirstKSS2CureDate,HGFirstKSS2CureTime,HGFirstKSS3CureDate,HGFirstKSS3CureTime)
		}
	}

	//获取微生物送检记录
	Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
	Set LabDateTo=aDateTo	
	Set LabInfoArr=..GetLabInfo(aEpisodeID,LabDatefrom,LabDateTo,"",aTestSetCat,aStaOELab)
  
    Set Count=0
	Set xType=""
	For {
		Set xType=$o(^TMP($zn,$j,"FirstAntInfo",xType))
		Quit:xType=""
		
		Set xTypeID=""
		For {
			Set xTypeID=$o(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Quit:xTypeID=""
			
			Set IsCureUse=0,IsKSS1CureUse=0,IsKSS2CureUse=0,IsKSS3CureUse=0
			Set IsBfCureSubmiss=0,IsBfKSS1CureSubmiss=0,IsBfKSS2CureSubmiss=0,IsBfKSS3CureSubmiss=0

			Set AntUseInfo =$g(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Set FirstCureDate     = $lg(AntUseInfo,1)
			Set FirstCureTime     = $lg(AntUseInfo,2)
			Set FirstKSS1CureDate = $lg(AntUseInfo,3)
			Set FirstKSS1CureTime = $lg(AntUseInfo,4)
			Set FirstKSS2CureDate = $lg(AntUseInfo,5)
			Set FirstKSS2CureTime = $lg(AntUseInfo,6)
			Set FirstKSS3CureDate = $lg(AntUseInfo,7)
			Set FirstKSS3CureTime = $lg(AntUseInfo,8)
			Set:FirstCureDate'=99999 IsCureUse=1
			Set:FirstKSS1CureDate'=99999 IsKSS1CureUse=1
			Set:FirstKSS2CureDate'=99999 IsKSS2CureUse=1
			Set:FirstKSS3CureDate'=99999 IsKSS3CureUse=1
					
			For LabInd=1:1:LabInfoArr.Count() {
				Set LabInfo=LabInfoArr.GetAt(LabInd)
				//采样日期
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
				
                //w !,CollDate," ",CollTime," ",FirstCureDate," ",FirstCureTime
				//1-aSubDateType:根据入参取时间类型(采样时间/送检医嘱开立时间)
				//目前数据池无送检医嘱数据,暂时不处理
				//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
				//采集日期时间在治疗之前，算作治疗前送检
				If ((CollDate<FirstCureDate)||((CollDate=FirstCureDate)&(CollTime<FirstCureTime)) ) {	
					If (aSubHourType=0){
						Set IsBfCureSubmiss=1 	//无限制
					}Else {
						Set SubHour=((FirstCureDate-CollDate)*86400+(FirstCureTime-CollTime))\3600
						Set:(aSubHourType=1)&(SubHour<24) IsBfCureSubmiss=1
						Set:(aSubHourType=2)&(SubHour<48) IsBfCureSubmiss=1
						Set:(aSubHourType=3)&(SubHour<72) IsBfCureSubmiss=1
						Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfCureSubmiss=1
						Set:(aSubHourType=5)&(SubHour<(14*24)) IsBfCureSubmiss=1
					}
				}
				
				//采集日期时间在治疗之前，算作治疗前送检
				If (IsKSS1CureUse=1)&((CollDate<FirstKSS1CureDate)||((CollDate=FirstKSS1CureDate)&(CollTime<FirstKSS1CureTime)) ) {
					//规定范围内
					If (aSubHourType=0){
						Set IsBfKSS1CureSubmiss=1 	//无限制
					} Else {
						Set SubHour=((FirstKSS1CureDate-CollDate)*86400+(FirstKSS1CureTime-CollTime))\3600
						Set:(aSubHourType=1)&(SubHour<24) IsBfKSS1CureSubmiss=1
						Set:(aSubHourType=2)&(SubHour<48) IsBfKSS1CureSubmiss=1
						Set:(aSubHourType=3)&(SubHour<72) IsBfKSS1CureSubmiss=1
						Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfKSS1CureSubmiss=1
						Set:(aSubHourType=5)&(SubHour<(14*24)) IsBfKSS1CureSubmiss=1
					}

				}
				//采集日期时间在治疗之前，算作治疗前送检
				If (IsKSS2CureUse=1)&((CollDate<FirstKSS2CureDate)||((CollDate=FirstKSS2CureDate)&(CollTime<FirstKSS2CureTime)) ) {
					//规定范围内
					If (aSubHourType=0){
						Set IsBfKSS2CureSubmiss=1 	//无限制
					} Else {
						Set SubHour=((FirstKSS2CureDate-CollDate)*86400+(FirstKSS2CureTime-CollTime))\3600
						Set:(aSubHourType=1)&(SubHour<24) IsBfKSS2CureSubmiss=1
						Set:(aSubHourType=2)&(SubHour<48) IsBfKSS2CureSubmiss=1
						Set:(aSubHourType=3)&(SubHour<72) IsBfKSS2CureSubmiss=1
						Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfKSS2CureSubmiss=1
						Set:(aSubHourType=5)&(SubHour<(14*24)) IsBfKSS2CureSubmiss=1
					}
				}
				//采集日期时间在治疗之前，算作治疗前送检
				If (IsKSS3CureUse=1)&((CollDate<FirstKSS3CureDate)||((CollDate=FirstKSS3CureDate)&(CollTime<FirstKSS3CureTime)) ) {
					//规定范围内
					If (aSubHourType=0){
						Set IsBfKSS3CureSubmiss=1 	//无限制
					} Else {
						Set SubHour=((FirstKSS3CureDate-CollDate)*86400+(FirstKSS3CureTime-CollTime))\3600
						Set:(aSubHourType=1)&(SubHour<24) IsBfKSS3CureSubmiss=1
						Set:(aSubHourType=2)&(SubHour<48) IsBfKSS3CureSubmiss=1
						Set:(aSubHourType=3)&(SubHour<72) IsBfKSS3CureSubmiss=1
						Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfKSS3CureSubmiss=1
						Set:(aSubHourType=5)&(SubHour<(14*24)) IsBfKSS3CureSubmiss=1
					}
				}
			}
            Set AntLabInfo=$lb(xType,xTypeID,IsCureUse,IsBfCureSubmiss,IsKSS1CureUse,IsBfKSS1CureSubmiss,IsKSS2CureUse,IsBfKSS2CureSubmiss,IsKSS3CureUse,IsBfKSS3CureSubmiss)
			Set Count=Count+1
			Do return.SetAt(AntLabInfo,Count)

		}
	}

    Kill ^TMP($zn,$j,"FirstAntInfo")
	Kill ^TMP($zn,$j,"GetFirstAntInfo")
	
	Quit return
}

}
