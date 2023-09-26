/// 名称: DHCHAI.IRS.InfOmissionSrv
/// 描述: 感染漏报相关服务
/// 编写者：mayanpeng
/// 编写日期: 2018-01-05
Class DHCHAI.IRS.InfOmissionSrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-01-17
/// Description:  根据DHCHAI.STATV2.S370InfMisRep查找漏报
/// Table：       
/// Input:     	  aHospIDs：院区   
/// 			  aLocID:	科室
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// 			  InHospFlag：是否在院 
/// 				  aType:类型(1:迟报,2:漏报)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.InfOmissionSrv","QryInfMisRep","1|3|4","","2020-12-01","2021-01-12","2")
Query QryInfMisRep(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, InHospFlag As %String, aType As %String = "2") As %Query(ROWSPEC = "EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String:%String,tmpInfPosID:%String,tmpInfPosDescs:%String,InfDate:%String,InfEffect:%String,InfLocDesc:%String,RepDate:%String,RepUser:%String,IsDeath:%String") [ SqlProc ]
{
}

ClassMethod QryInfMisRepExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, InHospFlag As %String, aType As %String = "2") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//日期处理
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//院区处理
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	//定义临时Global
 	Set NIndex="QryInfMisRep"
	Kill ^TMP($zn,$j,NIndex)
	
	//同期在科
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,"E",aLocID,"I")
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
		Set HospDr	= $li(LocData,8)     
		//过滤院区
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		
	    //过滤出院患者
	    Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(Paadm))
		Continue:PAAdmData=""
	    If (InHospFlag="1"){
			Set DischDate = $li(PAAdmData,26)
			Continue:DischDate'=""
		}
		//死亡标记
		Set IsDeath=$li(PAAdmData,15)
		If (IsDeath="1"){
			Set IsDeath="是"
		}
		else{
			Set IsDeath="否"
		}
		
	    //患者基本信息
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
		//循环转科
	    for xTransInd=1:1:$l(TransIDs,",") {
		    Set TransID=$p(TransIDs,",",xTransInd)
		    Continue:TransID=""
		    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		    Set TransLocDr	= $li(TranData,5)
		    Set TransDate	= $li(TranData,7)
		    Set OutLocDate	= $li(TranData,10)
		   	
		   	Set TransLocData 	= $g(^DHCHAI.BT.LocationD(TransLocDr))
		   	Set TransLocDesc	= $li(TransLocData,3)
			
		   	Set StartDate=TransDate
		   	Set EndDate=OutLocDate
		   	Set:StartDate<aDateFrom StartDate=aDateFrom
		  	Set:(EndDate="")||(EndDate>aDateTo) EndDate=aDateTo
		    //患者感染信息
			Set InfPoss =..GetInfPosInfo(Paadm,StartDate,EndDate)
			Continue:InfPoss=""
			Set (InfPosDescs,InfDates,InfEffects)=""
			For indxi=1:1:$l(InfPoss,"|") {
				Set tmpInfPos      	= $p(InfPoss,"|",indxi)
				Set tmpInfPosID    	= $p(tmpInfPos,"^",1)
				Set tmpInfPosDescs 	= $p(tmpInfPos,"^",2)
				Set InfDate		   	= $p(tmpInfPos,"^",3)
				Set InfEffect	    = $p(tmpInfPos,"^",5)
				Set InfType	    	= $p(tmpInfPos,"^",7)
				Continue:InfType="社区感染"
				Continue:(TransDate=InfDate)		//转科当天发生感染
				Set RepUser= $p(tmpInfPos,"^",11)	//报告人
				
				//迟报报告
				If (aType=1){
					Set LateFlag="0"
					Set RepDate	= $p(tmpInfPos,"^",9) 
					Set LateRepDay=##class(DHCHAI.BT.Config).GetValByCode("INFLateRepDay")
					If ((RepDate-InfDate)>LateRepDay){
						Set LateFlag="1"
					}
					Continue:LateFlag="0"
				}
				//漏报报告
				If (aType=2){
					Set MissFlag="0"
					//1.院感科代报
					Set ReplaceFlag= $p(tmpInfPos,"^",10)
					Set:ReplaceFlag="1" MissFlag="1"
					//2.患者出院后补报(剔除手术部位感染)
					Set RepDate	= $p(tmpInfPos,"^",9) 
					Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
					If ((DischDate'="")&&(RepDate>DischDate)){
						Set PosDesc = $p(tmpInfPos,"^",2)		// 感染诊断
						if ((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染"))){
							Set MissFlag="1"	
						}
					}	
					
					Continue:MissFlag="0"
				}
				
				Set InfDate  		= $zd(InfDate,3)		//感染日期
				Set RepDate			= $p(tmpInfPos,"^",9) 	//报告日期
				Set:RepDate'="" RepDate=$zd(RepDate,3)
				Set InfLocDesc	    = $p(tmpInfPos,"^",8)	//感染科室
				Set InfData=$lb(tmpInfPosID,tmpInfPosDescs,InfDate,InfEffect,InfLocDesc,RepDate,RepUser)
				
				Set Data=PatData_InfData_$lb(IsDeath)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	    }	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfMisRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMisRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfMisRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMisRepExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-01-05
/// Description:  感染漏报查询(使用DHCHAI.STAS.StaService中的QryInfMissing作为基础方法)
/// Table：       
/// Input：       aHospIDs : DHCHAI.BT.Hospital.IDs
/// 			  aLocID : DHCHAI.BT.Location.IDs
/// 			  aDateFrom : 就诊开始时间
/// 			  aDateTo : 就诊结束时间
/// 			  InHospFlag : 是否在院(在院时日期参数无效)
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.InfOmissionSrv","QryOmission","1","","2020-01-01","2020-05-15","1")
Query QryOmission(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, InHospFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String") [ SqlProc ]
{
}

ClassMethod QryOmissionExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, InHospFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	
	Set HospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	
	If (InHospFlag=1){
		Set xDays="-1"
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=""
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
					Continue:'$IsObject(objEpisode)
					Set EpisodeDr=objEpisode.%Id()
					Set EpisodeIDx=objEpisode.PAEpisodeIDx
					Set SCode = $p(EpisodeIDx,"||",1)
					Set VisitStatus=objEpisode.PAVisitStatus
					
					
					Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
					If VisitStatusInfo'="" {
						Set VisitStatus=$p(VisitStatusInfo,"^",2)
					}
					Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
					Continue:(InHospFlag=1)&(VisitStatus="D")
					Set objAdmLoc=objEpisode.PAAdmLocDr
					Continue:'$IsObject(objAdmLoc)
					Continue:'$IsObject(objAdmLoc.BTHospDr)
					Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
					
					//判断科室是否符合条件 (为空默认符合条件)
					Set LocId=objAdmLoc.%Id()
					Continue:(aLocID'="")&(LocId'=aLocID)
					
					Set tHospID=objAdmLoc.BTHospDr.%Id()
					Continue:(HospIDs'="")&($listfind(HospIDs,tHospID)<1) //按医院过滤
					
					Set OmissionIsFollow=##class(DHCHAI.BT.Config).GetValByCode("OmissionIsFollow",tHospID)
					Set InfPatFlag=0
					Set xScreenDr=0
					For {
						Set xScreenDr=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",EpisodeDr,xScreenDr))
						Quit:xScreenDr=""
						
						Set xCSInfRepPos = ""
						For{
							Set xCSInfRepPos=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xCSInfRepPos))
							Quit:xCSInfRepPos=""
							
							Set xDtlID=""
							For{
								Set xDtlID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xCSInfRepPos,xScreenDr,xDtlID))
								Quit:xDtlID=""
								
								Set ObjCCScDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xScreenDr_"||"_xDtlID)
								Continue:'$IsObject(ObjCCScDtl)
								//过滤掉非确诊的
								Set CSStatus=ObjCCScDtl.CSStatus
								Continue:CSStatus'=1
								//过滤掉确诊的社区感染
								Set CSInfRepPosDr=ObjCCScDtl.CSInfRepPosDr
								Continue:'$IsObject(CSInfRepPosDr)
								Set IRInfType=CSInfRepPosDr.IRInfType
								Continue:IRInfType=0
								Set xDiagID = CSInfRepPosDr.%Id()
								
								//确诊的判断感染诊断是否关联院感报告
								Set Flag = 0 //默认是不关联
								Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiagID)
								For indRep=1:1:arrReport.Count() {
									Set objRep=arrReport.GetAt(indRep)
									Continue:'$IsObject(objRep)
									Set ReportID=objRep.%Id()
									Set RepType=objRep.IRRepType
									Continue:(RepType'=1)  //医院感染报告
									Continue:'$IsObject(objRep.IRStatusDr)
									Set RepStatus=objRep.IRStatusDr.BTCode
									//1保存、2提交、3审核、4作废、5退回、6取消审核
									Continue:RepStatus="4"
									Set Flag = 1	//关联了修改为1
									Quit:Flag=1
								}
								Set:Flag=0 InfPatFlag=1
								Quit:InfPatFlag=1
							}
							Quit:InfPatFlag=1
						}
						Quit:InfPatFlag=1					
					}
					Continue:InfPatFlag'=1  
					
					Set Data=##class(DHCHAI.DPS.PAAdmSrv).BuildPaadmData(EpisodeDr)
					Continue:Data=""
					
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}Else{
		Set OmissArr=..GetOmissEpisodeID(aHospIDs,aLocID,aDateFrom,aDateTo)
		For i=1:1:OmissArr.Count(){
			Set DataInfo=OmissArr.GetAt(i)
			Set xEpisodeID=$List(DataInfo,1)
			Set Data=##class(DHCHAI.DPS.PAAdmSrv).BuildPaadmData(xEpisodeID,"",aLocID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1 
		}
	}
	Quit $$$OK
}

ClassMethod QryOmissionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOmissionExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOmissionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOmissionExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-01-05
/// Description:  感染漏报返回就诊号List
/// w ##class(DHCHAI.IRS.InfOmissionSrv).GetOmissEpisodeID("1|2|3|4","580","2018-08-01","2018-08-30")
ClassMethod GetOmissEpisodeID(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	New (aHospIDs,aLocID,aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInfMissing")
  	Set sc=rs.Execute(aHospIDs,aLocID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	Set Count=0
	While (rs.Next()){
		Set xEpisodeID=rs.Data("EpisodeID")
		Continue:xEpisodeID=""
		Set xIsNeed=rs.Data("IsMiss")
		Set xIsRep=rs.Data("IsRep")
		Set xIsMiss=rs.Data("IsMiss")
		Continue:xIsMiss'="1"
		Set LocID=rs.Data("LocID")
		Set LocDesc=rs.Data("LocDesc")
		Set PapmiNo=rs.Data("PapmiNo")
		Set PatName=rs.Data("PatName")
		Set AdmDate=rs.Data("AdmDate")
		Set DischDate=rs.Data("DischDate")
		
		Set DataInfo=$lb(xEpisodeID,xIsNeed,xIsRep,xIsMiss,LocID,LocDesc,PapmiNo,PatName,AdmDate,DischDate)
		Set Count=Count+1
		Do return.SetAt(DataInfo,Count)
	}
	Do rs.Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-05
/// Description:  感染漏报查询统计(使用DHCHAI.STAS.StaService中的QryInfMissing作为基础方法)
/// Table：       
/// Input：       aHospIDs : DHCHAI.BT.Hospital.IDs
/// 			  aLocID : DHCHAI.BT.Location.IDs
/// 			  aDateFrom : 就诊开始时间
/// 			  aDateTo : 就诊结束时间
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.InfOmissionSrv","QryOmissionEcharts","1|2","580","2018-06-01","2018-09-09")
Query QryOmissionEcharts(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "xAxis:%String,MissCount:%String,NeedCount:%String,Ratio:%String") [ SqlProc ]
{
}

ClassMethod QryOmissionEchartsExecute(ByRef qHandlex As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandlex=$lb(0,repidx,0)
	Set aDateFrom=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateFrom,"1")
	Set aDateFrom=$p(aDateFrom,"^",1)
	Set aDateTo=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aDateTo,"1")
	Set aDateTo=$p(aDateTo,"^",2)
	Quit:(aDateFrom>aDateTo) $$$OK
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set ZIndex=$zn
	Kill ^TMP(ZIndex)
	
  	Set OmissArr=..GetOmissEpisodeID(aHospIDs,aLocID,aDateFrom,aDateTo)
  	//无科室参数时显示全院漏报率最大的LocCount个科室
  	If aLocID=""{
	  	Set LocCount=10
		For i=1:1:OmissArr.Count(){
			Set DataInfo=OmissArr.GetAt(i)
			Set xEpisodeID=$List(DataInfo,1)
			Set xIsNeed=$List(DataInfo,2)
			Set xIsMiss=$List(DataInfo,4)
			Set LocDesc=$List(DataInfo,6)
			
			Set ^TMP(ZIndex,"Loc",LocDesc,"LocNeedCount")=+$g(^TMP(ZIndex,"Loc",LocDesc,"LocNeedCount"))+(+xIsNeed)
			Set ^TMP(ZIndex,"Loc",LocDesc,"LocMissCount")=+$g(^TMP(ZIndex,"Loc",LocDesc,"LocMissCount"))+(+xIsMiss)
		}
		//计算漏报率
		Set xLocDesc=0
		For {
			Set xLocDesc=$o(^TMP(ZIndex,"Loc",xLocDesc))
			Quit:xLocDesc=""
			
			Set LocNeedCount=+$g(^TMP(ZIndex,"Loc",xLocDesc,"LocNeedCount"))
			Set LocMissCount=+$g(^TMP(ZIndex,"Loc",xLocDesc,"LocMissCount"))
			Set:LocNeedCount'=0 Ratio=LocMissCount/LocNeedCount
			Set:LocNeedCount=0 Ratio=0
			Set:LocNeedCount'=0 ^TMP(ZIndex,"LocRaido",Ratio,xLocDesc)=""
		}
		//输出行数据(利用节点自动升序排序)
		Set xRatio=""
		Set xForCount=0
		For {
			Set xRatio=$o(^TMP(ZIndex,"LocRaido",xRatio),-1)
			Quit:xRatio=""
			Quit:xForCount>LocCount
			Set xForCount=xForCount+1
			
			Set xLocDesc=""
			For {
				Set xLocDesc=$o(^TMP(ZIndex,"LocRaido",xRatio,xLocDesc))
				Quit:xLocDesc=""
				
				Set locNeedCount=+$g(^TMP(ZIndex,"Loc",xLocDesc,"LocNeedCount"))
				Set LocMissCount=+$g(^TMP(ZIndex,"Loc",xLocDesc,"LocMissCount"))
				
				Set Data=$lb(xLocDesc,LocMissCount,locNeedCount,xRatio)
				Set ^CacheTemp(repidx,indx)=Data
				Set indx=indx+1
			}
		}
	} Else {
		//存在科室参数时，统计该科室每个月份的数据
		For i=1:1:OmissArr.Count(){
			Set DataInfo=OmissArr.GetAt(i)
			Set xEpisodeID=$List(DataInfo,1)
			Set xIsNeed=$List(DataInfo,2)
			Set xIsMiss=$List(DataInfo,4)
			Set xAdmDate=$List(DataInfo,9)
			Set xAdmDate=##Class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(xAdmDate,"1")
			Set xAdmDate=$p(xAdmDate,"^",1)
			Continue:xAdmDate=""
			
			Set ^TMP(ZIndex,"Month",xAdmDate,"MonthNeedCount")=+$g(^TMP(ZIndex,"Month",xAdmDate,"MonthNeedCount"))+(+xIsNeed)
			Set ^TMP(ZIndex,"Month",xAdmDate,"MonthMissCount")=+$g(^TMP(ZIndex,"Month",xAdmDate,"MonthMissCount"))+(+xIsMiss)
		}
		//计算漏报率
		Set xDate=""
		For {
			Set xDate=$o(^TMP(ZIndex,"Month",xDate))
			Quit:xDate=""
			
			Set MonthNeedCount=+$g(^TMP(ZIndex,"Month",xAdmDate,"MonthNeedCount"))
			Set MonthMissCount=+$g(^TMP(ZIndex,"Month",xAdmDate,"MonthMissCount"))
			Set:MonthNeedCount'=0 Ratio=MonthMissCount/MonthNeedCount
			Set:MonthNeedCount=0 Ratio=0
			Set:MonthNeedCount'=0 ^TMP(ZIndex,"MonthRaido",xDate,Ratio)=""
		}
		
		//输出行数据(利用节点自动升序排序)
		Set xDate=""
		For {
			Set xDate=$o(^TMP(ZIndex,"MonthRaido",xDate))
			Quit:xDate=""
			
			Set xRatio=$o(^TMP(ZIndex,"MonthRaido",xDate,""))
			Set MonthNeedCount=+$g(^TMP(ZIndex,"Month",xDate,"MonthNeedCount"))
			Set MonthMissCount=+$g(^TMP(ZIndex,"Month",xDate,"MonthMissCount"))
			Set Month=$e(##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xDate),1,7)
			Set Data=$lb(Month,MonthMissCount,MonthNeedCount,xRatio)
			Set ^CacheTemp(repidx,indx)=Data
			Set indx=indx+1
		}
	}
	Kill ^TMP(ZIndex)
	Quit $$$OK
}

ClassMethod QryOmissionEchartsClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryOmissionEchartsExecute ]
{
	set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
	Quit $$$OK
}

ClassMethod QryOmissionEchartsFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOmissionEchartsExecute ]
{
	set AtEnd=$LIST(qHandlex,1)
 	set repidx=$LIST(qHandlex,2)
 	set indx=$LIST(qHandlex,3)
 	set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

}
