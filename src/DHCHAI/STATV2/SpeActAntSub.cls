/// 名称: DHCHAI.STATV2.SpeActAntSub
/// 描述: 提高住院患者治疗用药前送检率专项行动(2021)-统计一
/// 编写者：pylian
/// 编写日期: 2021-12-02
Class DHCHAI.STATV2.SpeActAntSub Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian    	
/// CreatDate：   2021-12-02	
/// Description:  住院患者抗菌药物治疗前病原学送检率统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
///               aStatDimens:  展示维度    //add 20221012 
///               aLocIDs:    科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActAntSub","QryAntTheSub","1|2","2020-05-01","2020-05-31","W","1","0","1","","","","")
Query QryAntTheSub(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aUseSubDateType As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,CureUseAntiCnt:%Integer,BfCureSubmissCnt:%Integer,BfCureSubRatio:%String,UnBfCureSubCnt:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aSubDateType As %String, aSubHourType As %String, aLabTestSet As %Text = "", aQryCon As %String = "1", aUseSubDateType As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aLocType,aSubDateType,aSubHourType,aLabTestSet,aUseSubDateType,aLocIDs,IsStatParWard)
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
							Set IsBfCureSubmiss =$lg(AntUseInfo,4)
						
							Set TypeDesc=DimensKey
							Set:(Type="Sum") TypeDesc="Sum" //合计科室

							//治疗使用抗菌药物
							If (IsCureUse=1) {
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse",Paadm))	{
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsCureUse",Paadm)=""
								}
							}
							//治疗前送检
							If (IsBfCureSubmiss=1) {
								If '$d(^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss",Paadm)) {
									Set num=$i(^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss"))
									Set ^TMP($zn,$j,NIndex,TypeDesc,"IsBfCureSubmiss",Paadm)=""
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
			Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 	//治疗前送检率
			Set UnBfCureSubCnt=CureUseAntiCnt-BfCureSubmissCnt                          //治疗前未送检

			Continue:(IsActive="0")&&(PatAdmCnt=0)
			Continue:(aQryCon="2")&&(BfCureSubmissCnt=0)
			Continue:(aQryCon="3")&&(CureUseAntiCnt=0)

			Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,UnBfCureSubCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	If (LocCount>1) {	//科室合计
		Set PatAdmCnt  		=+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  			//在院患者数
		Set CureUseAntiCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","IsCureUse"))	  	    //抗感染药治疗使用人数
		Set BfCureSubmissCnt=+$g(^TMP($zn,$j,NIndex,"Sum","IsBfCureSubmiss"))   //治疗前送检
		Set BfCureSubRatio="0.00%"
		Set:CureUseAntiCnt>0 BfCureSubRatio=$fn((BfCureSubmissCnt/CureUseAntiCnt)*100,"",2)_"%" 			//治疗前送检率
        Set UnBfCureSubCnt=CureUseAntiCnt-BfCureSubmissCnt                          //治疗前未送检

		Set Data=$lb("","全部",PatAdmCnt,CureUseAntiCnt,BfCureSubmissCnt,BfCureSubRatio,UnBfCureSubCnt)
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
/// CreatDate：   2021-12-02	
/// Description:  抗菌药物病原学治疗前送检率明细表(抗菌药物、病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
/// 			  aIsBfCureSub:是否病原学送检
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActAntSub","QryAntTheSubDtl","1","2020-05-01","2020-05-31","0001-07-0027-W-4","W","1","1,9","1","0","","")
Query QryAntTheSubDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aIsBfCureSub As %String = "0", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLocIDs As %Text = "") As %Status
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
	
	Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:IsStatParWard="" IsStatParWard=0

  	Set NIndex="QryAntTheSubDtl"
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
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aStaType,aSubDateType,aSubHourType,aLabTestSet,aUseSubDateType,aLocIDs,IsStatParWard)
				Continue:AntUseArr.Count()<1    //过滤非治疗性用药患者
				
				If (aIsBfCureSub=1){
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
						Continue:(IsBfCureSub'=1)	
						Set IsBfSub=1
					}
					Continue:IsBfSub'=1
				}
               
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
					For AntInd=1:1:AntUseArr.Count() {
						Set OrderInfo=AntUseArr.GetAt(AntInd)
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
		        		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
						Set:ExecTime'="" ExecTime=$zt(ExecTime)
						Set ExecDateTime = ExecDate_" "_ExecTime
						Set $li(OrderInfo,15)=ExecDateTime
						
		 				Set OrderInfos=OrderInfos_$lb(OrderInfo)				
					}
	                Continue:($ll(OrderInfos)=0) 
					//获取病人是否治疗前送检
					If (aIsBfCureSub=1) {
						Set SubLabArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(Paadm,LabDatefrom,LabDateTo,aLabTestSet,LabTimefrom,LabTimeTo,aSubDateType)  //病原学送检
						Continue:SubLabArr.Count()<1
						
						For indLab=1:1:SubLabArr.Count() {
							Set SubLabInfo=SubLabArr.GetAt(indLab)	
							Continue:SubLabInfo=""
							Set VisitNumberID = $lg(SubLabInfo,1)
							Set EpisodeNo	  = $lg(SubLabInfo,2)
							Set CollDate 	  = $lg(SubLabInfo,3)
							Set CollTime	  = $lg(SubLabInfo,4)
							Set Specimen      = $lg(SubLabInfo,5)
							Set TestSet       = $lg(SubLabInfo,6)
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

ClassMethod QryAntTheSubDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTheSubDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntTheSubDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTheSubDtlExecute ]
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
/// CreatDate：   2022-10-24	
/// Description:  抗菌药物治疗未病原学前送检明细表(病原学送检)
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input:    	  aDateFrom：开始日期
/// 			  aDateTo：结束日期
/// 			  aDimensKey：统计维度
///               aLocIDs:   合计科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.SpeActAntSub","QryAntTheSubUnBfDtl","1","2020-05-01","2020-05-31","0001-07-0027-W-4","W","1","1,9","1","0","","")
Query QryAntTheSubUnBfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%Integer,GroupID:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String,ExecDateTime:%String,VisitNumberID:%String,EpisodeNo:%String,CollDateTime:%String,RepDateTime:%String,TestSet:%String,Specimen:%String,Bacteria:%String,MRBTpDesc:%String,LabInfType:%String,DiagID:%String,InfPos:%String,InfType:%String,InfDate:%String,InfEff:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryAntTheSubUnBfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "", aLabTestSet As %Text = "", aSubDateType As %String, aSubHourType As %String = "0", aUseSubDateType As %String = "1", aLocIDs As %Text = "") As %Status
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
				Set AntUseArr =..GetAntLabInfo(Paadm,aDateFrom,aDateTo,aStaType,aSubDateType,aSubHourType,aLabTestSet,aUseSubDateType,aLocIDs,IsStatParWard)
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
					For AntInd=1:1:AntUseArr.Count() {
						Set OrderInfo=AntUseArr.GetAt(AntInd)
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
						
		        		Set:ExecDate'="" ExecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExecDate)
						Set:ExecTime'="" ExecTime=$zt(ExecTime)
						Set ExecDateTime = ExecDate_" "_ExecTime
						Set $li(OrderInfo,15)=ExecDateTime
						
		 				Set OrderInfos=OrderInfos_$lb(OrderInfo)				
					}
	                Continue:($ll(OrderInfos)=0) 
					//获取病人是否治疗前送检
					Set SubLabArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(Paadm,LabDatefrom,LabDateTo,aLabTestSet,LabTimefrom,LabTimeTo,aSubDateType)  //病原学送检
					For indLab=1:1:SubLabArr.Count() {
						Set SubLabInfo=SubLabArr.GetAt(indLab)	
						Continue:SubLabInfo=""
						Set VisitNumberID = $lg(SubLabInfo,1)
						Set EpisodeNo	  = $lg(SubLabInfo,2)
						Set CollDate 	  = $lg(SubLabInfo,3)
						Set CollTime	  = $lg(SubLabInfo,4)
						Set Specimen      = $lg(SubLabInfo,5)
						Set TestSet       = $lg(SubLabInfo,6)
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
/// CreatDate：   2021-12-02	
/// Description:  判断病人是否治疗前送检
/// Return：      1(是),0(否)
/// zw ##class(DHCHAI.STATV2.SpeActAntSub).GetIsBfCureSubmiss(822,$zdh("2020-05-01",3),$zdh("2021-12-01",3),"","",",9","1","0")
ClassMethod GetIsBfCureSubmiss(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aLabTestSet As %Text = "", aSubDateType As %String = "", aSubHourType As %String = "0") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aLabTestSet,aSubDateType,aSubHourType)
	Set return=0
  
    Set IsCureUse=0,IsBfCureSubmiss=0	
	Set FirstCureDate=99999,FirstCureTime=99999
	Set AntUseArr =..GetAntUseInfo(aEpisodeID,aDateFrom,aDateTo,aTimeFrom,aTimeTo)	
	Set:AntUseArr.Count()>0 IsCureUse=1
	
	For AntInd=1:1:AntUseArr.Count(){
		Set OrderInfo=AntUseArr.GetAt(AntInd)
		Set SttDate=$p($li(OrderInfo,7)," ",1)
		Set SttTime=$p($li(OrderInfo,7)," ",2)
    
		If ((FirstCureDate>SttDate)||((FirstCureDate=SttDate)&(FirstCureTime>SttTime))) {
			Set FirstCureDate=SttDate
			Set FirstCureTime=SttTime
		}
	}
   
	//获取微生物送检记录
	if (IsCureUse=1) {
		//1-aSubHourType:根据入参取时间类型(采样时间/送检医嘱开立时间)
		//目前数据池无送检医嘱数据,暂时不处理
		//2-aSubHourType:24h、48h、72h、7天、无限制，默认无限制，无限制表示整个住院期间，不再区分送检、用药是否同一科室
		Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
		Set LabDateTo=aDateTo
		Set LabInfoArr=..GetSpeLabInfo(aEpisodeID,LabDatefrom,LabDateTo,aLabTestSet)
		For LabInd=1:1:LabInfoArr.Count(){
			Set LabInfo=LabInfoArr.GetAt(LabInd)
			Set CollDate = $li(LabInfo,3)
			Set CollTime = $li(LabInfo,4)
			//采集日期时间在治疗之前，算作治疗前送检
			if ((CollDate<FirstCureDate)||((CollDate=FirstCureDate)&(CollTime<FirstCureTime))) {
				//规定范围内
				if (aSubHourType=0){
					Set IsBfCureSubmiss=1 	//无限制
				} else{
					Set SubHour=((FirstCureDate-CollDate)*86400+(FirstCureTime-CollTime))\3600
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

/// Creator：     pylian    	
/// CreatDate：   2021-12-02
/// 取病人给定时间段内抗菌药物使用记录
/// zw ##class(DHCHAI.STATV2.SpeActAntComb).GetAntUseInfo(2981,$zdh("2020-05-01",3),$zdh("2021-12-01",3))
ClassMethod GetAntUseInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "") As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
		
	Set xScode = "",Count=0
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
				
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	
	           	Continue:OrdDesc=""
                Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID=""
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1   //add 20221122 过滤抗菌药物对照置无效的药物
			    
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
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
				If (EndDate=aDateFrom) {
					If (EndTime'="") {
						Continue:(aTimeFrom'="")&&(EndTime<aTimeFrom)  // 停药日期在转入日期前
					}
				}
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			    If (SttDate=aDateTo) {
				    If (SttTime'="") {
						Continue:(aTimeTo'="")&&(SttTime>aTimeTo)	// 用药日期在转出日期后
					}
			    }
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Continue:UsePurpose=""
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:UsePurpose'["治疗"
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				Set OrdItemID = $li(OEOrdItemData,24)
				
				Set Generic=$li(OEOrdItemData,19)
				Set OrdDate = $li(OEOrdItemData,10)
				Set OrdTime = $li(OEOrdItemData,11)
			    Set OrdDateTime=OrdDate_" "_OrdTime
   	            Set SttDateTime=SttDate_" "_SttTime
				Set EndDateTime=EndDate_" "_EndTime
				Set OEOrdLocDr=$li(OEOrdItemData,12)
				Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
				If OEOrdLocData'="" {
					Set OrdLocDesc=$li(OEOrdLocData,3)
				} Else {
					Set OrdLocDesc=$li(OEOrdItemData,39)  //ID|Code|Desc
					Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
				}
				//取医师类型
				Set OrdDocDesc=$li(OEOrdItemData,14)  //ID|Code|Desc
				Set OEDocDr=""
				Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
				Set CarPrvTpId="",CarPrvTpDesc=""
				Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
				Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
				Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
				
				Set OrdItemInfo=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison,CarPrvTpDesc)
				Set Count=Count+1
				Do return.SetAt(OrdItemInfo,Count)
			}
		}
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-12-02
/// Description:  获取病人送检信息
/// Return：      
/// zw ##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(118,$zdh("2020-05-01",3),$zdh("2021-12-01",3),"1,9")
ClassMethod GetSpeLabInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aLabTestSet As %Text = "", aTimeFrom As %String = "", aTimeTo As %String = "", aSubDateType As %String = "") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aLabTestSet,aTimeFrom,aTimeTo,aSubDateType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
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
		If (aSubDateType="2") {				//医嘱开立日期
			Set (OrdID,SubID,OEOrdDate,OEOrdTime)=""
			Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
			Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
			Set OEOrdDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",7) 			//开医嘱日期（OEORI_Date）
			Set OEOrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",17)			//开医嘱时间（OEORI_TimeOrd）
			Continue:(aDateFrom'="")&(OEOrdDate'="")&(OEOrdDate<aDateFrom)
			Continue:(aDateTo'="")&(OEOrdDate'="")&(OEOrdDate>aDateTo)
			Continue:(aTimeFrom'="")&(OEOrdTime'="")&(OEOrdDate=aDateFrom)&(OEOrdTime<aTimeFrom)
			Continue:(aTimeTo'="")&(OEOrdTime'="")&(OEOrdDate=aDateTo)&(OEOrdTime>aTimeTo)
		}Else {
			Continue:CollDate=""
			Continue:(aDateFrom'="")&(CollDate<aDateFrom)
			Continue:(aDateTo'="")&(CollDate>aDateTo)
			Continue:(aTimeFrom'="")&(CollDate=aDateFrom)&(CollTime<aTimeFrom)
			Continue:(aTimeTo'="")&(CollDate=aDateTo)&(CollTime>aTimeTo)
		}
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
			If (TestSetMapID'=""){
				Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
				Continue:TestSetMapData=""
				Continue:'$li(TestSetMapData,7) 		//无效判断
				Set TSMapItemDr=$li(TestSetMapData,4)
				Continue:TSMapItemDr=""
				Continue:(aLabTestSet'="")&&((","_aLabTestSet_",")'[(","_TSMapItemDr_","))
				Set TestSet=xTestSetDesc
				Set CheckFlg = 1
				Quit				
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
							Continue:(aLabTestSet'="")&&((","_aLabTestSet_",")'[(","_xMapItemDr_","))
							Set CheckFlg = 1
							
							Set TestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(xTestSetDr))
							Set TestSet=$lg(TestSetData,3)
							Quit										
						}
					}
				}
			}
		}
		Continue:CheckFlg=0	//过滤非指定类型的送检

		Set LabInfo=$lb(xVisitNumberDr,EpisodeNo,CollDate,CollTime,Specimen,TestSet)
		Set Count=Count+1
		Do return.SetAt(LabInfo,Count)
	}	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-07-15
/// Description:  判断病人治疗使用及治疗前送检信息
/// Return：      
/// zw ##class(DHCHAI.STATV2.SpeActAntSub).GetAntLabInfo(822,$zdh("2020-09-01",3),$zdh("2020-10-01",3),"E","","0",",9")
ClassMethod GetAntLabInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String, aSubDateType As %String = "", aSubHourType As %String = "0", aLabTestSet As %Text = "", aUseSubDateType As %String = "1", aLocIDs As %Text = "", aIsStatParWard As %String = "0") As %Library.ArrayOfDataTypes
{
	
	new (aEpisodeID,aDateFrom,aDateTo,aLocType,aSubDateType,aSubHourType,aLabTestSet,aUseSubDateType,aLocIDs,aIsStatParWard)
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
		//首次使用抗菌药物时间(以科室为最小单位计算)
   		Set FirstCureDate=99999,FirstCureTime=99999
	
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
				Set KSS	= $li(OrderInfo,13)		
				Set SttDate=$p($li(OrderInfo,7)," ",1)
				Set SttTime=$p($li(OrderInfo,7)," ",2)

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
			}
		}
		Continue:IsCureUse'=1
		
		//科室首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo",aLocType,xTranLocID,aEpisodeID)=""
			
			Set LFirstCureDate=FirstCureDate,LFirstCureTime=FirstCureTime
			Set ^TMP($zn,$j,"FirstAntInfo",aLocType,xTranLocID)=$lb(LFirstCureDate,LFirstCureTime)
		}
		
		//科室分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)) {  //update 20220902 处理多院区患者转院不出院的情况
			Set ^TMP($zn,$j,"GetFirstAntInfo","G",HospDr_"||"_GroupDr,aEpisodeID)=""
			Set GFirstCureDate=FirstCureDate,GFirstCureTime=FirstCureTime
			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstCureDate,GFirstCureTime)
		} Else {
			If ((FirstCureDate<GFirstCureDate)||((FirstCureDate=GFirstCureDate)&(FirstCureTime<GFirstCureTime))) {
				Set GFirstCureDate=FirstCureDate
				Set GFirstCureTime=FirstCureTime
			}
			Set ^TMP($zn,$j,"FirstAntInfo","G",HospDr_"||"_GroupDr)=$lb(GFirstCureDate,GFirstCureTime)
		}
		
		If (LocCount>1) {   //多个科室合计
			If '$d(^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)) {
				Set ^TMP($zn,$j,"GetFirstAntInfo","Sum",aLocIDs,aEpisodeID)=""
				Set SFirstCureDate=FirstCureDate,SFirstCureTime=FirstCureTime
				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstCureDate,SFirstCureTime)
			} Else {
				If ((FirstCureDate<SFirstCureDate)||((FirstCureDate=SFirstCureDate)&(FirstCureTime<SFirstCureTime))) {
					Set SFirstCureDate=FirstCureDate
					Set SFirstCureTime=FirstCureTime
				}
				Set ^TMP($zn,$j,"FirstAntInfo","Sum",aLocIDs)=$lb(SFirstCureDate,SFirstCureTime)
			}
		}
		//医院首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","H",HospDr,aEpisodeID)=""
			Set HFirstCureDate=FirstCureDate,HFirstCureTime=FirstCureTime
			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstCureDate,HFirstCureTime)
		}Else{
			If ((FirstCureDate<HFirstCureDate)||((FirstCureDate=HFirstCureDate)&(FirstCureTime<HFirstCureTime))) {
				Set HFirstCureDate=FirstCureDate
				Set HFirstCureTime=FirstCureTime
			}		

			Set ^TMP($zn,$j,"FirstAntInfo","H",HospDr)=$lb(HFirstCureDate,HFirstCureTime)
		}
		//医院分组首次使用
		If '$d(^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)) {
			Set ^TMP($zn,$j,"GetFirstAntInfo","A",HospGroupDr,aEpisodeID)=""
			Set HGFirstCureDate=FirstCureDate,HGFirstCureTime=FirstCureTime
			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstCureDate,HGFirstCureTime,HGFirstKSS1CureDate,HGFirstKSS1CureTime,HGFirstKSS2CureDate,HGFirstKSS2CureTime,HGFirstKSS3CureDate,HGFirstKSS3CureTime)
		}Else{
			If ((FirstCureDate<HGFirstCureDate)||((FirstCureDate=HGFirstCureDate)&(FirstCureTime<HGFirstCureTime))) {
				Set HGFirstCureDate=FirstCureDate
				Set HGFirstCureTime=FirstCureTime
			}
			Set ^TMP($zn,$j,"FirstAntInfo","A",HospGroupDr)=$lb(HGFirstCureDate,HGFirstCureTime)
		}
	}
	
 	//获取微生物送检记录
	Set LabDatefrom=$li(^DHCHAI.DP.PAAdmD(aEpisodeID),20)
	Set LabDateTo=aDateTo	
	Set LabInfoArr=##class(DHCHAI.STATV2.SpeActAntSub).GetSpeLabInfo(aEpisodeID,LabDatefrom,LabDateTo,aLabTestSet)

    Set Count=0
	Set xType=""
	For {
		Set xType=$o(^TMP($zn,$j,"FirstAntInfo",xType))
		Quit:xType=""
		
		Set xTypeID=""
		For {
			Set xTypeID=$o(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Quit:xTypeID=""
			
			Set IsCureUse=0,IsBfCureSubmiss=0
			Set AntUseInfo =$g(^TMP($zn,$j,"FirstAntInfo",xType,xTypeID))
			Set FirstCureDate     = $lg(AntUseInfo,1)
			Set FirstCureTime     = $lg(AntUseInfo,2)
			Set:FirstCureDate'=99999 IsCureUse=1
			
			For LabInd=1:1:LabInfoArr.Count() {
				Set LabInfo=LabInfoArr.GetAt(LabInd)
				//采样日期
				Set CollDate = $li(LabInfo,3)
				Set CollTime = $li(LabInfo,4)
				If (aSubDateType="2") {				//医嘱开立日期
					Set EpisodeNo=$li(LabInfo,2)	//标本号
					Set (OrdID,SubID,OEOrdDate,OEOrdTime)=""
					Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
					Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
					Set OEOrdDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",7) 			//开医嘱日期（OEORI_Date）
					Set OEOrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",17)			//开医嘱时间（OEORI_TimeOrd）
					Set:OEOrdDate'="" CollDate = OEOrdDate
					Set:OEOrdTime'="" CollTime = OEOrdTime
				}
                // w !,CollDate," ",CollTime," ",FirstCureDate," ",FirstCureTime
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
			}
            Set AntLabInfo=$lb(xType,xTypeID,IsCureUse,IsBfCureSubmiss)
			Set Count=Count+1
			Do return.SetAt(AntLabInfo,Count)
		}
	}
    
    Kill ^TMP($zn,$j,"FirstAntInfo")
	Kill ^TMP($zn,$j,"GetFirstAntInfo")
	
	Quit return
}

}
