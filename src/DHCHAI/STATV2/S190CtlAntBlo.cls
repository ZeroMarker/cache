/// 名称: DHCHAI.STATV2.S190CtlAntBlo
/// 描述: 住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S190CtlAntBlo Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-21
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据 
///               aStatDimens:  展示维度    //add 20220929 
///               aLocIDs:    科室 
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S190CtlAntBlo","QryCtlAntBlo","","2020-05-01","2020-05-31","W","","","0","H","27,29")
Query QryCtlAntBlo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aSubDateType As %String = "", aSubHourType As %String = "0", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,CureAntiCnt:%Integer,KSS2CureCnt:%Integer,KSS3CureCnt:%Integer,BfKSS2CureSubCnt:%Integer,BfKSS3CureSubCnt:%Integer,BfKSS2CureSubRatio:%String,BfKSS3CureSubRatio:%String") [ SqlProc ]
{
}

ClassMethod QryCtlAntBloExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aSubDateType As %String = "", aSubHourType As %String = "0", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aLocType,"",aSubDateType,aSubHourType,aLocIDs,IsStatParWard)
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
						   
							Set IsKSS2CureUse   =$lg(AntUseInfo,3)
							Set IsBfKSS2CureSub =$lg(AntUseInfo,4)
							Set IsKSS3CureUse   =$lg(AntUseInfo,5)
							Set IsBfKSS3CureSub =$lg(AntUseInfo,6)
							Set IsCureUse       =$lg(AntUseInfo,11)

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
							//使用限制抗菌药物人数
							IF (IsKSS2CureUse=1) {
								IF '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsKSS2CureUse",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsKSS2CureUse"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsKSS2CureUse",Paadm)=""
								}
							}
							//使用特殊使用抗菌药物
							IF (IsKSS3CureUse=1) {
								IF '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsKSS3CureUse",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsKSS3CureUse"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsKSS3CureUse",Paadm)=""
								}
							}
							//限制抗菌药治疗前送检
							IF (IsBfKSS2CureSub=1) {
								IF '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS2CureSubmiss",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS2CureSubmiss"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS2CureSubmiss",Paadm)=""
								}
							}
							//特殊抗菌药治疗前送检血培养
							IF (IsBfKSS3CureSub=1) {
								IF '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS3CureSubmiss",Paadm))
								{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS3CureSubmiss"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsBfKSS3CureSubmiss",Paadm)=""
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
		Set PatAdmCnt  			=+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  				//在院患者数
		Set CureAntiCnt         =+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsCureUse"))		    //抗感染药治疗使用人数
		Set KSS2CureCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsKSS2CureUse"))  		//限制级抗感染药使用人数
		Set KSS3CureCnt  		=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsKSS3CureUse"))		//特殊级抗感染药治疗使用人数
		Set BfKSS2CureSubCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfKSS2CureSubmiss"))  //限制治疗前送检
		Set BfKSS3CureSubCnt	=+$g(^TMP($zn,$j,NIndex,xDimensKey,"IsBfKSS3CureSubmiss"))  //特殊治疗前送检
		Set (BfKSS3CureSubRatio,BfKSS2CureSubRatio)="0.00%"
		Set:KSS2CureCnt>0 BfKSS2CureSubRatio=$fn((BfKSS2CureSubCnt/KSS2CureCnt)*100,"",2)_"%" 			//限制治疗前送检率
		Set:KSS3CureCnt>0 BfKSS3CureSubRatio=$fn((BfKSS3CureSubCnt/KSS3CureCnt)*100,"",2)_"%" 			//特殊治疗前送检率
		
		Continue:(IsActive="0")&&(PatAdmCnt=0)
		Continue:(aQryCon="2")&&(BfKSS2CureSubCnt=0)&&(BfKSS3CureSubCnt=0)
		Continue:(aQryCon="3")&&(KSS2CureCnt=0)&&(KSS3CureCnt=0)
		
		Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,CureAntiCnt,KSS2CureCnt,KSS3CureCnt,BfKSS2CureSubCnt,BfKSS3CureSubCnt,BfKSS2CureSubRatio,BfKSS3CureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	
	If (LocCount>1) {	//科室合计
		Set PatAdmCnt  			=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  				//在院患者数
		Set CureAntiCnt         =+$g(^TMP($zn,$j,NIndex,"Sum","IsCureUse"))		    //抗感染药治疗使用人数
		Set KSS2CureCnt  		=+$g(^TMP($zn,$j,NIndex,"Sum","IsKSS2CureUse"))  		//限制级抗感染药使用人数
		Set KSS3CureCnt  		=+$g(^TMP($zn,$j,NIndex,"Sum","IsKSS3CureUse"))		    //特殊级抗感染药治疗使用人数
		Set BfKSS2CureSubCnt	=+$g(^TMP($zn,$j,NIndex,"Sum","IsBfKSS2CureSubmiss"))   //限制治疗前送检
		Set BfKSS3CureSubCnt	=+$g(^TMP($zn,$j,NIndex,"Sum","IsBfKSS3CureSubmiss"))   //特殊治疗前送检
		Set (BfKSS3CureSubRatio,BfKSS2CureSubRatio)="0.00%"
		Set:KSS2CureCnt>0 BfKSS2CureSubRatio=$fn((BfKSS2CureSubCnt/KSS2CureCnt)*100,"",2)_"%" 			//限制治疗前送检率
		Set:KSS3CureCnt>0 BfKSS3CureSubRatio=$fn((BfKSS3CureSubCnt/KSS3CureCnt)*100,"",2)_"%" 			//特殊治疗前送检率

		Set Data=$lb("","全部",PatAdmCnt,CureAntiCnt,KSS2CureCnt,KSS3CureCnt,BfKSS2CureSubCnt,BfKSS3CureSubCnt,BfKSS2CureSubRatio,BfKSS3CureSubRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	  	
	  
	Kill ^TMP($zn,$j,"QryCtlAntBlo")
	Quit $$$OK
}

ClassMethod QryCtlAntBloClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntBloExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntBloFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntBloExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	IF ind="" {				// IF there are no more rows, finish fetching
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
/// CreatDate：   2019-11-21
/// Description:  住院患者限制/特殊使用级抗菌药物治疗前血培养送检率统计明细表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接   //add 20220927 解决汇总按科室分组统计明细无法区分医院问题
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aDimensKey：统计维度
///               aLocType:  科室类型    //add 20220927 解决汇总多科室合计没有维度拼接科室问题，防止科室、病区分组不一致时导致汇总与明细数据不一致
///               aLocIDs:   合计科室 
/// 			  aIsKSS:KSS2限制使用级;KSS3特殊使用级
/// Return：      返回ROWSPEC 
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S190CtlAntBlo","QryCtlAntBloDtl","1|2","2020-06-01","2020-06-30","","W","27,29","KSS2","1","1","0")
Query QryCtlAntBloDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aIsKSS As %String = "", aIsBfSub As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,AntiKSS:%String,AntiCureSub:%String") [ SqlProc ]
{
}

ClassMethod QryCtlAntBloDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aLocType As %String, aLocIDs As %Text = "", aIsKSS As %String = "", aIsBfSub As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0") As %Status
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
	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:IsStatParWard="" IsStatParWard=0

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
				
				IF TransType="E" {
					Set LocDr  = LocID
					Set WardDr = ""
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
					Set LocDr  = LnkLocDr
					Set WardDr = LocID
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
		
				Set IsKSS2CureUse=0,IsKSS3CureUse=0
				Set IsBfKSS2CureSub=0,IsBfKSS3CureSub=0
				Set AntiKSS="",AntiCureSub=""
				Set FirstKSS2CureDate="",FirstKSS2CureTime="",FirstKSS3CureDate="",FirstKSS3CureTime=""
				//获取病人抗菌药物治疗、治疗前送检信息
				Set AntLabUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aLocType,aIsKSS,aSubDateType,aSubHourType,aLocIDs,IsStatParWard)
				Continue:(aIsKSS'="")&(AntLabUseArr.Count()<1)    //过滤非治疗性限制、特殊用药患者	
				        
				Set DHospDr   = +$p(aDimensKey,"-",1)
				Set DGroupDr  = +$p(aDimensKey,"-",2)
				Set DLocID    = +$p(aDimensKey,"-",3)
				Set DType     = $p(aDimensKey,"-",4)
				Set DHGroupDr = +$p(aDimensKey,"-",5)					
				Set DTypeID =""
				Set:DType="" DType="Sum"
				Set DTypeID=$s(DType="A":DHGroupDr,DType="H":DHospDr,DType="G":(DHospDr_"||"_DGroupDr),DType="E":DLocID,DType="W":DLocID,DType="W":DLocID,DType="Sum":aLocIDs)
				Set IsBfSub=0
				For AntLInd=1:1:AntLabUseArr.Count(){
					Set AntUseInfo=AntLabUseArr.GetAt(AntLInd)
				    Continue:AntUseInfo=""
			 		Set Type =$lg(AntUseInfo,1)
		    		Continue:(DType'=Type)
				    Set TypeID =$lg(AntUseInfo,2)
				    Set:(aDimensKey'="")&(+$p(aDimensKey,"-",1)=0) TypeID="0"_"||"_$p(TypeID,"||",2)  //分组不区分医院时特殊处理（不同医院分组下患者转院不出院情况是否存在、影响？）
				    Continue:(DTypeID'=TypeID)
			        
					Set IsKSS2CureUse   =$lg(AntUseInfo,3)
					Set IsBfKSS2CureSub =$lg(AntUseInfo,4)
					Continue:(IsBfKSS2CureSub'=1)&(aIsKSS="KSS2")
					Set IsKSS3CureUse   =$lg(AntUseInfo,5)
					Set IsBfKSS3CureSub =$lg(AntUseInfo,6)
					Continue:(IsBfKSS3CureSub'=1)&(aIsKSS="KSS3")
					Set FirstKSS2CureDate =$lg(AntUseInfo,7)
					Set FirstKSS2CureTime =$lg(AntUseInfo,8)
					Set FirstKSS3CureDate =$lg(AntUseInfo,9)
					Set FirstKSS3CureTime =$lg(AntUseInfo,10)
					Set IsBfSub=1
				}
				Continue:(aIsBfSub=1)&(IsBfSub'=1)
			
				Set:IsKSS2CureUse=1 AntiKSS="KSS2" 
				Set:IsKSS3CureUse=1 AntiKSS="KSS3"
				Set:(IsKSS2CureUse=1)&(IsKSS3CureUse=1) AntiKSS="KSS2&KSS3"
				Set:(IsBfKSS2CureSub=1)||(IsBfKSS3CureSub=1) AntiCureSub="是"
		
				//获取病人基本信息
				Set PatData =..BuildPaadmData(Paadm)
				Continue:PatData=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
	 			Set AdmTimes = $lg(PAAdmData,38)   //就诊次数

				//组织输出转科明细以及限制、特殊抗菌药物情况
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
					Set (OrderInfos,LabInfos,OrderInfo,LabInfo)=""
					Set IsKSS2=0,IsKSS3=0
					Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
					For AntInd=1:1:AntUseArr.Count() {
						Set OrderInfo=AntUseArr.GetAt(AntInd)
						Set UsePurpose 	= $li(OrderInfo,11)
						Continue:UsePurpose'["治疗"
						Set KSS	= $li(OrderInfo,13)
						Continue:(KSS'="KSS2")&(KSS'="KSS3")
						Continue:(aIsKSS'="")&(KSS'=aIsKSS)
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
		               
		                Set OrderInfos=OrderInfos_$lb(OrderInfo)				
					}
					Continue:(aIsKSS'="")&($ll(OrderInfos)=0)
					
					//获取微生物送检记录
					If (IsBfKSS2CureSub=1)||(IsBfKSS3CureSub=1) {
						Set LabDatefrom=$lg(PAAdmData,20)
						Set LabTimefrom=$lg(PAAdmData,21)
						Set LabDateTo =FirstKSS2CureDate 
						Set LabTimeTo =FirstKSS2CureTime 
						
						Set:(aIsKSS="KSS3")=1 LabDateTo =FirstKSS3CureDate,LabTimeTo=FirstKSS3CureTime
						Set LabInfoArr=..GetLabInfo(Paadm,LabDatefrom,LabDateTo,"血","细菌检测","",LabTimefrom,LabTimeTo)  //病原学送检 截止日期到开始使用抗菌药物日期					
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
					}	
				
					Set Len=$ll(OrderInfos)
					Set:($ll(OrderInfos)<$ll(LabInfos)) Len=$ll(LabInfos)
				
					If (Len>0) {
						For LenInd=1:1:Len {
							Set OrderInfo=$lg(OrderInfos,LenInd)
							Set:OrderInfo="" OrderInfo=$lb("","","","","","","","","","","","","","")
							Set LabInfo=$lg(LabInfos,LenInd)
							Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
							Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_OrderInfo_LabInfo_$lb(AntiKSS,AntiCureSub)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}	
					}Else {
						Set OrderInfo=$lb("","","","","","","","","","","","","","")
						Set:LabInfo="" LabInfo=$lb("","","","","","","","","")
						Set Data=$lb(DimensDesc,AdmTimes)_PatData_TransInfo_OrderInfo_LabInfo_$lb(AntiKSS,AntiCureSub)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}				
				}
		    }
		}
    }
	Quit $$$OK
}

ClassMethod QryCtlAntBloDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlAntBloDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlAntBloDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlAntBloDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	IF ind="" {				// IF there are no more rows, finish fetching
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
/// zw ##class(DHCHAI.STATV2.S190CtlAntBlo).GetAntLabInfo(149,$zdh("2020-05-01",3),$zdh("2020-06-30",3),"W","","","0","27,29")
ClassMethod GetAntLabInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aDrgPoison As %String = "", aSubDateType As %String = "", aSubHourType As %String = "0", aLocIDs As %Text = "", aIsStatParWard As %String = "0") As %Library.ArrayOfDataTypes
{
	
	new (aEpisodeID,aDateFrom,aDateTo,aLocType,aDrgPoison,aSubDateType,aSubHourType,aLocIDs,aIsStatParWard)
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
		Set IsCureUse=0
		Set IsKSS2CureUse=0,IsKSS3CureUse=0
		//首次使用抗菌药物时间(以科室为最小单位计算)
		Set FirstCureDate=99999,FirstCureTime=99999
		Set FirstKSS2CureDate=99999,FirstKSS2CureTime=99999,FirstKSS3CureDate=99999,FirstKSS3CureTime=99999
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
           
			Set AntUseArr =..GetAntUseInfo(aEpisodeID,DateFrom,DateTo,TimeFrom,TimeTo)	
			Set:AntUseArr.Count()>0 IsAntUse=1
			For AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose = $li(OrderInfo,11)
				Continue:UsePurpose'["治疗"
				Set IsCureUse=1	
				Set KSS	= $li(OrderInfo,13)
				Continue:(aDrgPoison'="")&&(aDrgPoison'=KSS)
				//Continue:(KSS'="KSS2")&(KSS'="KSS3")
		
				Set SttDate=$p($li(OrderInfo,7)," ",1)
				Set SttTime=$p($li(OrderInfo,7)," ",2)
				
				//add 20221124 增加治疗前送检人数判断
				If ((FirstCureDate>SttDate)||((FirstCureDate=SttDate)&(FirstCureTime>SttTime))) {
					Set FirstCureDate=SttDate
					Set FirstCureTime=SttTime
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
		//Continue:(IsKSS2CureUse'=1)&(IsKSS3CureUse'=1)
		
		//科室首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)=""

			Set LFirstCureDate=FirstCureDate,LFirstCureTime=FirstCureTime
			Set LFirstKSS2CureDate=FirstKSS2CureDate,LFirstKSS2CureTime=FirstKSS2CureTime
			Set LFirstKSS3CureDate=FirstKSS3CureDate,LFirstKSS3CureTime=FirstKSS3CureTime
			
			Set ^TMP($zn,$j,"FirstAntInfo",aLocType,xTranLocID)=$lb(LFirstKSS2CureDate,LFirstKSS2CureTime,LFirstKSS3CureDate,LFirstKSS3CureTime,LFirstCureDate,LFirstCureTime)
		}
		
		//科室分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)=""
			Set GFirstCureDate=FirstCureDate,GFirstCureTime=FirstCureTime
			Set GFirstKSS2CureDate=FirstKSS2CureDate,GFirstKSS2CureTime=FirstKSS2CureTime
			Set GFirstKSS3CureDate=FirstKSS3CureDate,GFirstKSS3CureTime=FirstKSS3CureTime

			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstKSS2CureDate,GFirstKSS2CureTime,GFirstKSS3CureDate,GFirstKSS3CureTime,GFirstCureDate,GFirstCureTime)
		} Else {
			If ((FirstCureDate<GFirstCureDate)||((FirstCureDate=GFirstCureDate)&(FirstCureTime<GFirstCureTime))) {
				Set GFirstCureDate=FirstCureDate
				Set GFirstCureTime=FirstCureTime
			}
			If ((FirstKSS2CureDate<GFirstKSS2CureDate)||((FirstKSS2CureDate=GFirstKSS2CureDate)&(FirstKSS2CureTime<GFirstKSS2CureTime))) {
				Set GFirstKSS2CureDate=FirstKSS2CureDate
				Set GFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<GFirstKSS3CureDate)||((FirstKSS3CureDate=GFirstKSS3CureDate)&(FirstKSS3CureTime<GFirstKSS3CureTime))) {
				Set GFirstKSS3CureDate=FirstKSS3CureDate
				Set GFirstKSS3CureTime=FirstKSS3CureTime
			}
			
			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstKSS2CureDate,GFirstKSS2CureTime,GFirstKSS3CureDate,GFirstKSS3CureTime,GFirstCureDate,GFirstCureTime)
		}
		
		If (LocCount>1) {   //多个科室合计
			If '$d(^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)) {
				Set ^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)=""
				Set SFirstCureDate=FirstCureDate,SFirstCureTime=FirstCureTime
				Set SFirstKSS2CureDate=FirstKSS2CureDate,SFirstKSS2CureTime=FirstKSS2CureTime
				Set SFirstKSS3CureDate=FirstKSS3CureDate,SFirstKSS3CureTime=FirstKSS3CureTime

				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstKSS2CureDate,SFirstKSS2CureTime,SFirstKSS3CureDate,SFirstKSS3CureTime,SFirstCureDate,SFirstCureTime)
			} Else {
				If ((FirstCureDate<SFirstCureDate)||((FirstCureDate=SFirstCureDate)&(FirstCureTime<SFirstCureTime))) {
					Set SFirstCureDate=FirstCureDate
					Set SFirstCureTime=FirstCureTime
				}
				If ((FirstKSS2CureDate<SFirstKSS2CureDate)||((FirstKSS2CureDate=SFirstKSS2CureDate)&(FirstKSS2CureTime<SFirstKSS2CureTime))) {
					Set SFirstKSS2CureDate=FirstKSS2CureDate
					Set SFirstKSS2CureTime=FirstKSS2CureTime
				}
				If ((FirstKSS3CureDate<SFirstKSS3CureDate)||((FirstKSS3CureDate=SFirstKSS3CureDate)&(FirstKSS3CureTime<SFirstKSS3CureTime))) {
					Set SFirstKSS3CureDate=FirstKSS3CureDate
					Set SFirstKSS3CureTime=FirstKSS3CureTime
				}
				
				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstKSS2CureDate,SFirstKSS2CureTime,SFirstKSS3CureDate,SFirstKSS3CureTime,SFirstCureDate,SFirstCureTime)
			}
		}
		
		//医院首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)=""
			Set HFirstCureDate=FirstCureDate,HFirstCureTime=FirstCureTime
			Set HFirstKSS2CureDate=FirstKSS2CureDate,HFirstKSS2CureTime=FirstKSS2CureTime
			Set HFirstKSS3CureDate=FirstKSS3CureDate,HFirstKSS3CureTime=FirstKSS3CureTime

			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstKSS2CureDate,HFirstKSS2CureTime,HFirstKSS3CureDate,HFirstKSS3CureTime,HFirstCureDate,HFirstCureTime)
		}Else{
			If ((FirstCureDate<HFirstCureDate)||((FirstCureDate=HFirstCureDate)&(FirstCureTime<HFirstCureTime))) {
				Set HFirstCureDate=FirstCureDate
				Set HFirstCureTime=FirstCureTime
			}
			If ((FirstKSS2CureDate<HFirstKSS2CureDate)||((FirstKSS2CureDate=HFirstKSS2CureDate)&(FirstKSS2CureTime<HFirstKSS2CureTime))) {
				Set HFirstKSS2CureDate=FirstKSS2CureDate
				Set HFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<HFirstKSS3CureDate)||((FirstKSS3CureDate=HFirstKSS3CureDate)&(FirstKSS3CureTime<HFirstKSS3CureTime))) {
				Set HFirstKSS3CureDate=FirstKSS3CureDate
				Set HFirstKSS3CureTime=FirstKSS3CureTime
			}

			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstKSS2CureDate,HFirstKSS2CureTime,HFirstKSS3CureDate,HFirstKSS3CureTime,HFirstCureDate,HFirstCureTime)
		}
		//医院分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)=""
			Set HGFirstCureDate=FirstCureDate,HGFirstCureTime=FirstCureTime
			Set HGFirstKSS2CureDate=FirstKSS2CureDate,HGFirstKSS2CureTime=FirstKSS2CureTime
			Set HGFirstKSS3CureDate=FirstKSS3CureDate,HGFirstKSS3CureTime=FirstKSS3CureTime
			
			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstKSS2CureDate,HGFirstKSS2CureTime,HGFirstKSS3CureDate,HGFirstKSS3CureTime,HGFirstCureDate,HGFirstCureTime)
		}Else{
			If ((FirstCureDate<HGFirstCureDate)||((FirstCureDate=HGFirstCureDate)&(FirstCureTime<HGFirstCureTime))) {
				Set HGFirstCureDate=FirstCureDate
				Set HGFirstCureTime=FirstCureTime
			}
			If ((FirstKSS2CureDate<HGFirstKSS2CureDate)||((FirstKSS2CureDate=HGFirstKSS2CureDate)&(FirstKSS2CureTime<HGFirstKSS2CureTime))) {
				Set HGFirstKSS2CureDate=FirstKSS2CureDate
				Set HGFirstKSS2CureTime=FirstKSS2CureTime
			}
			If ((FirstKSS3CureDate<HGFirstKSS3CureDate)||((FirstKSS3CureDate=HGFirstKSS3CureDate)&(FirstKSS3CureTime<HGFirstKSS3CureTime))) {
				Set HGFirstKSS3CureDate=FirstKSS3CureDate
				Set HGFirstKSS3CureTime=FirstKSS3CureTime
			}

			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstKSS2CureDate,HGFirstKSS2CureTime,HGFirstKSS3CureDate,HGFirstKSS3CureTime,HGFirstCureDate,HGFirstCureTime)
		}
	}

	//获取微生物送检记录
	Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
	Set LabDateTo=aDateTo	
	Set LabInfoArr=..GetLabInfo(aEpisodeID,LabDatefrom,LabDateTo,"血","细菌检测")
    
    Set Count=0
	Set xType=""
	For {
		Set xType=$o(^TMP($zn,$j,"FirstAntInfo",xType))
		Quit:xType=""
		
		
		Set xTypeID=""
		For {
			Set xTypeID=$o(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Quit:xTypeID=""
			
			Set IsCureUse=0,IsKSS2CureUse=0,IsKSS3CureUse=0
			Set IsBfCureSubmiss=0,IIsBfKSS2CureSubmiss=0,IsBfKSS3CureSubmiss=0

			Set AntUseInfo =$g(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Set FirstKSS2CureDate = $lg(AntUseInfo,1)
			Set FirstKSS2CureTime = $lg(AntUseInfo,2)
			Set FirstKSS3CureDate = $lg(AntUseInfo,3)
			Set FirstKSS3CureTime = $lg(AntUseInfo,4)
			Set FirstCureDate     = $lg(AntUseInfo,5)
			Set FirstCureTime     = $lg(AntUseInfo,6)
			Set:FirstCureDate'=99999 IsCureUse=1
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
				//1-aSubDateType:根据入参取时间类型(采样时间/送检医嘱开立时间)
				//目前数据池无送检医嘱数据,暂时不处理
				//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
				If ((CollDate<FirstCureDate)||((CollDate=FirstCureDate)&(CollTime<FirstCureTime)) ) {	
					If (aSubHourType=0){
						Set IsBfCureSubmiss=1 	//无限制
					}Else {
						Set SubHour=((FirstCureDate-CollDate)*86400+(FirstCureTime-CollTime))\3600
						Set:(aSubHourType=1)&(SubHour<24) IsBfCureSubmiss=1
						Set:(aSubHourType=2)&(SubHour<48) IsBfCureSubmiss=1
						Set:(aSubHourType=3)&(SubHour<72) IsBfCureSubmiss=1
						Set:(aSubHourType=4)&(SubHour<(7*24)) IsBfCureSubmiss=1
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
					}
				}
			}
            Set AntLabInfo=$lb(xType,xTypeID,IsKSS2CureUse,IsBfKSS2CureSubmiss,IsKSS3CureUse,IsBfKSS3CureSubmiss,FirstKSS2CureDate,FirstKSS2CureTime,FirstKSS3CureDate,FirstKSS3CureTime,IsCureUse,IsBfCureSubmiss,FirstCureDate,FirstCureTime)
			Set Count=Count+1
			Do return.SetAt(AntLabInfo,Count)

		}
	}
    
    Kill ^TMP($zn,$j,"FirstAntInfo")
	Kill ^TMP($zn,$j,"GetFirstAntInfo")
	
	Quit return
}

}
