/// 名称: DHCHAI.STATV2.S211OpPulInf
/// 描述: 手术患者肺部感染发病率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-13
Class DHCHAI.STATV2.S211OpPulInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-11-07
/// Description:  手术患者肺部感染率
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aStaType : 统计类型E：科室W：病区 
/// 		 	  aQryCon  : 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S211OpPulInf","QryOpPulInf","1","2021-10-01","2021-12-31","W","1","","AHW","")
Query QryOpPulInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "xDimensKey:%String,DimensDesc:%String,OperCaseCount:%Integer,PullCount:%Integer,PullRatio:%String") [ SqlProc ]
{
}

ClassMethod QryOpPulInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aOperCat As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//临时global
 	Set NIndex="QryOpPosInf"
	Kill ^TMP($zn,$j,NIndex)
	//统计维度
 	Set:aStaType'="W" aStaType="E"
 	Set HospIDCount = $l(aHospIDs,"|")
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set StatDimensStr = aStatDimens
	Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	
	//循环手麻表
 	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	//过滤无效数据
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	//过滤手术状态
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
					//Continue:"ADC"[OperStatus 
					//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
				 					 	
				 	//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36) 				    
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
					
					//过滤手术分类[急诊|择期]
				 	Set OROperType = $li(AnaesData,5)
				 	Set tOROperType=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","OperType",OROperType)

				 	
				 	//过滤退院+非住院病人
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				
				 	
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"
					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         	// 手术ICD
					Set OperDesc    = $li(AnaesData,4)         	// 手术名称
					Set OperHour    = +$li(AnaesData,10)       	// 手术时长
					Set OperDate  = $li(AnaesData,6)			// 手术开始日期
					Set ORSttTime = $li(AnaesData,7)			// 手术开始时间
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) // 手术科室[患者]
					Set OperWardDr = $p(OperLocWard,"^",2) // 手术病区[患者]
					
					If (aStaType="E"){
						Set LocDr = OperLocDr
					}Else{
						Set LocDr = OperWardDr
					}
					Continue:LocDr=""
					Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
					
					Set OperLocData = $g(^DHCHAI.BT.LocationD(LocDr))
					Continue:OperLocData=""
					Set HospDr = $li(OperLocData,8)
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)  //按科室院区过滤
					Set GroupDr = $li(OperLocData,7)			//手术科室组[患者]
					If GroupDr="" {
						Set GroupDesc="其他科"
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
		
				
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					Set InfPosInfo =..GetInfPosInfo(EpisodeDr,OperDate,aDateTo)
					Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,OperLocDr,OperWardDr)
					Continue:StatDimensInfo=""
					For indDimens=1:1:$l(StatDimensInfo,"^") {
					Set DimensKey=$p(StatDimensInfo,"^",indDimens)
					Continue:DimensKey=""
					
					Set num = $i(^TMP($zn,$j,NIndex,DimensKey,"OperCaseCount")) // 手术例次数
					
					If (InfPosInfo'=""){
						
							Set ^TMP($zn,$j,NIndex,DimensKey,"PullCount") =+$g(^TMP($zn,$j,NIndex,DimensKey,"PullCount"))+($l(InfPosInfo,"下呼吸道")-1)+($l(InfPosInfo,"肺炎")-1) // 手术患者肺部感染发生例数
						}

					}
					If (LocCount>1) {
						Set num = $i(^TMP($zn,$j,NIndex,"sum","OperCaseCount")) // 手术例次数
						If (InfPosInfo'=""){
							Set ^TMP($zn,$j,NIndex,"sum","PullCount") =+$g(^TMP($zn,$j,NIndex,"sum","PullCount"))+($l(InfPosInfo,"下呼吸道")-1)+($l(InfPosInfo,"肺炎")-1) // 手术患者肺部感染发生例数
						}
					}
				}	
					
			}
		}
	}
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
	// 输出Data
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
		
		Set OperCaseCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OperCaseCount"))  //手术例次数
		Set PullCount      =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PullCount"))      //手术患者肺部感染发生例数
		
		Set PullRatio="0.00%"
		Set:OperCaseCount>0 PullRatio=$fn((PullCount/OperCaseCount)*100,"",2)_"%"   //手术肺部感染发病率
		
		Continue:(IsActive="0")&&(OperCaseCount=0)	
		Continue:(aQryCon="2")&&(PullCount=0)
		Continue:(aQryCon="3")&&(OperCaseCount=0)
			
		Set Data=$lb(xDimensKey,DimensDesc,OperCaseCount,PullCount,PullRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		

	}
	If (LocCount>1) {
		Set OperCaseCount  =+$g(^TMP($zn,$j,NIndex,"sum","OperCaseCount"))  //手术例次数
		Set PullCount      =+$g(^TMP($zn,$j,NIndex,"sum","PullCount"))      //手术患者肺部感染发生例数
		
		Set PullRatio="0.00%"
		Set:OperCaseCount>0 PullRatio=$fn((PullCount/OperCaseCount)*100,"",2)_"%"   //手术肺部感染发病率
		
			
		Set Data=$lb("","全部",OperCaseCount,PullCount,PullRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOpPulInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpPulInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpPulInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpPulInfExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-06-16
/// Description:  肺部感染患者明细
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:		  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  aDimensKey: 维度
/// 			  aInfFlag:  感染标记  1:查询肺部感染人数
/// Return：      返回ROWSPEC
/// aDateFrom=2022-07-01&aDateTo=2022-12-31&aDimensKey=0000-00-0000-A-1&aInfFlag=1&aStaType=W&aOperCat=&aLocIDs=
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S211OpPulInf","QryOpPulInfDtl","1","2021-10-01","2021-12-31","0001-00-0000-H-2","1","W","","")
Query QryOpPulInfDtl(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,OperName:%String,OperName2:%String,OperLocDr:%String,OperStatus:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocDr:%String,Assistant1:%String,Assistant2:%String,OperLoc:%String,OperType:%String,ORAnesMethod:%String,Incision:%String,Healing:%String,InfTypeDr:%String,ASAScore:%String,IncisionNum:%String,EndoscopeFlag:%String,ImplantFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,NNISGrade:%String,InfPosDescs:%String,OperCatLists:%String,DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType,xID") [ SqlProc ]
{
}

ClassMethod QryOpPulInfDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfFlag As %String, aStaType As %String = "", aOperCat As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set HospID = +$p(aDimensKey,"-",1)			                //1.统计院区-aHospIDs
    Set:HospID="0" HospID =aHospIDs
	Set DimensMark = $p(aDimensKey,"-",4)						//2.统计科室组-aLocGroup
 	Set aLocGroup  = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")	
 	Set:aStaType="" aStaType = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")	//3.科室类型(W,E,'')
	Set aLocDr     = +$p(aDimensKey,"-",3)											//4.科室(病区)ID
	Set:aLocDr="0" aLocDr=""					
	Set HospGrpDr=""
	Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)           //5.医院分组
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospID,"|")
	
    Set NIndex="QryOpPulInfDtl"
	Kill ^TMP($zn,$j,NIndex)
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				 	Continue:AnaesData=""
				 	Set ORIsActive=$li(AnaesData,31)
				 	Continue:ORIsActive'=1
				 	/// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
			 		Set OperStatus = $li(AnaesData,34)         // 手术状态
					Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
					Set:tOperStatus'="" OperStatus=tOperStatus
				 	//Continue:"ADC"[OperStatus    // 过滤手术状态
				 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态
					
					//add 20210926 增加手术分类条件过滤
				    Set OperCatDrs = $lg(AnaesData,36)
					Continue:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))

					Set OperCatList=""
					For indC=1:1:$L(OperCatDrs,",") {
						Set OperCatDr=$p(OperCatDrs,",",indC)
						Continue:OperCatDr=""
						
						// Add by zhaoyj 2022-06-16 Global方式
						Set CatData =$g(^CF.MA.HAI.IR.CRuleOperCatD(OperCatDr))
						Continue:CatData=""
						Set OperCat =$li(CatData, 2)
						If $listfind(OperCatList,OperCat)<1 {
							Set OperCatList=OperCatList_$lb(OperCat)
						}
					}	
					Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
		
				 	Set EpisodeDr   = $li(AnaesData,2)
				 	Set ExcFlag=##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(EpisodeDr,ExAdmList)
				 	Continue:ExcFlag=1
				 	Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$li(AdmData,19)="C"

					Set TAdmType=$li(AdmData,18)
					Continue:("|"_TAdmType_"|")'="|I|"  //EP急诊留观、I住院、O门诊、E急诊流水
					// 手术信息
					Set OperICD     = $li(AnaesData,3)         // 手术ICD
					Set OperDesc    = $li(AnaesData,4)         // 手术名称
					Set OperHour    = +$li(AnaesData,10)       // 手术时长
					Set OperDate  = $li(AnaesData,6)
					Set ORSttTime = $li(AnaesData,7)
					Set OperType    = $li(AnaesData,5)			// 手术类型（急诊、择期）
					Set EndTime 	=$li(AnaesData,9)
					// 患者手术时所在的科室病区
					Set OperLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,ORSttTime)
					Continue:OperLocWard=""
					Set OperLocDr  = $p(OperLocWard,"^",1) 	// 手术科室
					Set OperWardDr = $p(OperLocWard,"^",2) 	// 手术病区
					
					If (aStaType="E"){
						Set LocID = OperLocDr
					}Else{
						Set LocID = OperWardDr
					}
					
					Continue:LocID=""
					Continue:(aLocDr'="")&(aLocDr'=LocID)
					Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
					Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
					Set LocDesc	= $lg(LocData,3)
					Set LocDesc2= $lg(LocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set HospDr=$lg(LocData,8)				//手术院区
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
				
					Set OPSData=..GetOPSDataByAnaesDr(EpisodeDr,xID)
					Continue:OPSData=""

					Set PatData =..BuildPaadmData(EpisodeDr)
				    Continue:PatData=""
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
	           	    Set AdmTimes = $lg(AdmData,38)   //就诊次数
					Set PAAdmDate = $lg(AdmData,20)  //入院日期
					Set PAAdmTime= $lg(AdmData,21)  //入院时间
					
					Set TransInfo=..GetTransInfoByDateTime(EpisodeDr,OperDate,ORSttTime) //取转科信息
					Set TransDr=$p(TransInfo,"^",1)
					Set TransLocDr=$p(TransInfo,"^",2)
					Set TransLocDesc=$p(TransInfo,"^",3)
					Set TransDateTime=$p(TransInfo,"^",4)
					Set OutLocDateTime=$p(TransInfo,"^",5)
					Set TransDate=$p(TransDateTime," ",1)
					Set TransTime=$p(TransDateTime," ",2)
					Set OutLocDate=$p(OutLocDateTime," ",1)
					Set OutLocTime=$p(OutLocDateTime," ",2)
					Set InfPosInfo=""
					Set (InfPosDescs,PosDesc,InfDate,InfxDate,InfDesc,InfType)=""
					If (aInfFlag=1){
						Set:aDateFrom>OperDate InfPosInfo =..GetInfPosInfo(EpisodeDr,aDateFrom,aDateTo)
						Set:(aDateFrom<OperDate)||(aDateFrom=OperDate) InfPosInfo =..GetInfPosInfo(EpisodeDr,OperDate,aDateTo)
						Set InfPosDescs=..GetOperPosInf(EpisodeDr,xID)
						//首先过滤无感染情况，其次结合感染所在科室是否感染进行过滤
						For InfNo=1:1:$L(InfPosInfo,"|") {
							Set InfPosMsg = $p(InfPosInfo,"|",InfNo)
							Continue:InfPosMsg=""
					
							Set InfPosDescs    						  = $p(InfPosMsg,"^",2) //感染诊断
							Set:($p(InfPosMsg,"^",3))'="" InfDate     = $zd($p(InfPosMsg,"^",3),3) //感染日期
							Set:($p(InfPosMsg,"^",4))'="" InfxDate    = $zd($p(InfPosMsg,"^",4),3) //感染转归日期
							Set InfDesc    							  = $p(InfPosMsg,"^",5) //感染转归情况
							Set PosDesc   							  = $p(InfPosMsg,"^",6) //手术部位感染
							Continue:(InfPosDescs'["下呼吸道")&&(InfPosDescs'["肺炎")
							Set InfType   							  = $p(InfPosMsg,"^",7) //感染类型
							Continue:InfType'="医院感染"
							Set Data=PatData_OPSData_$lb(InfPosDescs)_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,InfPosDescs,OperICD,OperType,PosDesc,InfDate,InfxDate,InfDesc,InfType,xID)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}					
					}
					else{
							Set Data=PatData_OPSData_$lb("")_$lb(OperCatLists)_$lb(DimensDesc,TransDr,TransLocDesc,TransDateTime,OutLocDateTime,AdmTimes,"",OperICD,OperType,"","","","","",xID)
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

ClassMethod QryOpPulInfDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOpPulInfDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOpPulInfDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOpPulInfDtlExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-06-16
/// Description:  获取感染报告手术相关感染诊断信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S211OpPulInf).GetInfPosDtlInfo(2598 65436 65496)
ClassMethod GetInfPosDtlInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs="",OPSIDs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-16 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Set StatusCode = $lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)
			Continue:StatusCode'="3"
			
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
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
	
				If (InfPos'="") {
					;Set PosDesc=objInfPos.BTDesc
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					//Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_PosDesc_"^"_InfDate
				}
			}
			//获取手术切口感染关联手术切口调查表 add
			if (InfPosDescs'=""){
				Set xOPSub=0
				For {
					Set xOPSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xOPSub))
					Quit:xOPSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xOPSub))
					Continue:INFRepExtData=""
					Set DataID=$lg(INFRepExtData,3)
					Continue:DataID=""
				
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(DataID))
					Continue:OPSData=""
				
					Set IROperDr=$lg(OPSData,3)
					Continue:IROperDr=""
				
					Set OPSID=IROperDr
					Set OPSIDs=OPSIDs_"^"_OPSID
				}
				Set:OPSIDs'="" OPSIDs = $e(OPSIDs,2,$l(OPSIDs))
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs_"#"_OPSIDs
	Quit return
}

}
