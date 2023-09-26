/// 名称: DHCHAI.IRS.CCWarningSrv
/// 描述: 暴发预警相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCWarningSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.IRS.CCWarningSrv).Test()
ClassMethod Test()
{
	do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningSrv","QryWarnResult","1|2","2019-01-01","实时现患||3^发热标准差|30|2^发热人数|7|3^检出同种菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3^上呼吸道感染|7|3^下呼吸道感染|7|3^泌尿道感染|7|3^血管相关性感染|7|3^手术切口感染|7|3^入院24H内计入|1")
	                                                                                              
	quit
}

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  查询暴发预警记录
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aHospIDs : 医院代码 多值"^"分割
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目 实时现患||3^发热|7|3^检出同种菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3^入院24H内计入|1
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningSrv","QryWarnResult","1|2","2019-10-19","实时现患||3^发热标准差|30|2^发热人数|7|3^检出同种菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3^上呼吸道感染|7|3^下呼吸道感染|7|3^泌尿道感染|7|3^血管相关性感染|7|3^手术切口感染|7|3^入院24H内计入|1")
Query QryWarnResult(aHospIDs As %String, aWarnDate As %String, aWarnItems As %String) As %Query(ROWSPEC = "DataType:%String,LocID:%String,LocDesc:%String,DataStr:%String,ViewStr:%String") [ SqlProc ]
{
}

ClassMethod QryWarnResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aWarnDate As %String, aWarnItems As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aWarnDate="")||(aWarnItems="") $$$OK
 	Set:aWarnDate["-" aWarnDate=$zdh(aWarnDate,3)
 	
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnResult"
 	Set flg=..QueryProcess(aWarnDate,aWarnItems,aHospIDs,"","","W")
 	Quit:(+flg)<1 $$$OK
 	
	//输出列
	Set HeaderStr=""
	Set xInd=0
	For {
		Set xInd=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd))
		Quit:xInd=""
		Set xSub=0
		For {
			Set xSub=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
			Quit:xSub=""
			Set HeaderData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
			Continue:HeaderData=""
			Set Header=$listget(HeaderData,1)
			Continue:Header=""
			Set HeaderStr=HeaderStr_"^"_Header
		}
	}
	Set:HeaderStr'="" HeaderStr=$e(HeaderStr,2,$l(HeaderStr))
	
	//类型、科室ID、科室名称、预警值列表、显示标识列表
	Set Data=$lb("Header","","",HeaderStr,"")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	//输出预警值
	Set xWarnLoc=""
	For {
		Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Quit:xWarnLoc=""
		
		Set WarnLocData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Continue:WarnLocData=""
		Set WarnLocDr=$listget(WarnLocData,1)
		Set WarnLocDesc=$listget(WarnLocData,2)
		Continue:(WarnLocDr="")||(WarnLocDesc="")
		
		Set DataStr="",ViewStr="",Flag=0
		Set xInd=0
		For {
			Set xInd=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd))
			Quit:xInd=""
			Set xSub=0
			For {
				Set xSub=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
				Quit:xSub=""
				Set HeaderData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
				Continue:HeaderData=""
				Set ItemDesc=$listget(HeaderData,2)
				Continue:ItemDesc=""
				Set ArgData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",ItemDesc))
				Set WarnCnt=+$listget(ArgData,3)
				Set:WarnCnt=0 WarnCnt =1   //默认条件不输入为1 add by chenjb
				
				If ItemDesc="发热标准差" {
					Set Cnt=+$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,ItemDesc))
					Set FeverNum=##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverArrByLoc(WarnLocDr,aWarnDate,aWarnDate).GetAt(1)
					Set FeverNum=+FeverNum
					If FeverNum>0 {
						Set FeverInfo=$p(aWarnItems,"^",2)
						Set FeverDays=+$p(FeverInfo,"|",2)
			 			Set Stand=##class(DHCHAI.IRS.CCFeverNumSrv).GetStandByLocDate(WarnLocDr,aWarnDate-FeverDays,aWarnDate-1)
			 			Set Average=##class(DHCHAI.IRS.CCFeverNumSrv).GetAveByLocDate(WarnLocDr,aWarnDate-FeverDays,aWarnDate-1)
			 			Set ShortCnt=FeverNum-Average-(Stand*WarnCnt)
					} Else {
						Set ShortCnt=0
					}
					Set DataStr=DataStr_"^"_Cnt
		 			Set ViewStr=ViewStr_"^"_$s(ShortCnt>0:1,1:0)
				} Else {
					If ItemDesc="检出同种菌" {
						Set Bacteria=$listget(HeaderData,1)
						Continue:Bacteria=""
						Set Cnt=+$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,ItemDesc,Bacteria))
					} ElseIf ItemDesc="手术切口感染" {
						Set OperDesc=$listget(HeaderData,1)
						Continue:OperDesc=""
						Set Cnt=+$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,ItemDesc,OperDesc))
					} Else {
						Set Cnt=+$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,ItemDesc))
					}
					Set DataStr=DataStr_"^"_Cnt
					Set ViewStr=ViewStr_"^"_$s(Cnt>=WarnCnt:1,1:0)
				}
			}
		}
		Continue:ViewStr'["1" //无满足条件,去掉项目都为0的科室
		Set:DataStr'="" DataStr=$e(DataStr,2,$l(DataStr))
		Set:ViewStr'="" ViewStr=$e(ViewStr,2,$l(ViewStr))
		
		//类型、科室ID、科室名称、预警值列表、显示标识列表
		Set Data=$lb("Data",WarnLocDr,WarnLocDesc,DataStr,ViewStr)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryWarnResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarnResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnResultExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  查询暴发预警病人列表
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID : 科室ID
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningSrv","QryWarnPatList","627","2017-08-02","实时现患||^发热标准差|7|1^发热人数|7|3^检出同种菌||^便常规异常||^呼吸机使用||^中心静脉置管||^泌尿道插管||^上呼吸道感染||^下呼吸道感染||^泌尿道感染||^血管相关性感染||^手术切口感染||^入院24H内计入|1","发热人数2")
Query QryWarnPatList(aLocID As %String, aWarnDate As %String, aWarnItems As %String, aSelItem As %String) As %Query(ROWSPEC = "EpisodeDr:%String,RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLoc:%String,AdmWard:%String,AdmBedDr:%String,AdmBed:%String,InfInfo:%String,AdmDate:%String,DischDate:%String,WarnLocDr:%String,WarnLocDesc:%String,WarnBedDr:%String,WarnBedDesc:%String,DataStr:%String") [ SqlProc ]
{
}

ClassMethod QryWarnPatListExecute(ByRef qHandle As %Binary, aLocID As %String, aWarnDate As %String, aWarnItems As %String, aSelItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aLocID="")||(aWarnDate="")||(aWarnItems="") $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnPatList"
 	Set flg=..QueryProcess(aWarnDate,aWarnItems,"",aLocID,aSelItem,"W")
 	Quit:(+flg)<1 $$$OK
 	
	//输出科室暴发预警结果
	Set xWarnLoc=""
	For {
		Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Quit:xWarnLoc=""
		
		Set WarnLocData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Continue:WarnLocData=""
		Set WarnLocDr=$listget(WarnLocData,1)
		Set WarnLocDesc=$listget(WarnLocData,2)
		
		Set xEpisodeDr=0
		For {
			Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set WarnBedData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
			Continue:WarnBedData=""
			Set WarnBedDr=$listget(WarnBedData,3)
			Set WarnBedDesc=$listget(WarnBedData,4)
			Continue:WarnBedDesc=""
			Set:WarnBedDesc'["床" WarnBedDesc=WarnBedDesc_"床"
			
			Set SummaryStr="" // add by zhoubo 2018-03-19
			Set DataStr=""
			Set xInd=0
			For {
				Set xInd=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd))
				Quit:(xInd="")||(DataStr'="")
				
				Set xSub=0
				For {
					Set xSub=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
					Quit:(xSub="")||(DataStr'="")
					
					Set HeaderData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
					Continue:HeaderData=""
					Set HeaderDesc=$listget(HeaderData,1)
					Set ItemDesc=$listget(HeaderData,2)
					Continue:ItemDesc=""
					
					If ItemDesc="检出同种菌" {
						Set Bacteria=HeaderDesc
						Continue:Bacteria=""
						If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,Bacteria)) {
							Set DataStr=1
							Set SummaryStr=SummaryStr_","_ItemDesc_":"_Bacteria
						}
					} ElseIf ItemDesc="手术切口感染" {
						Set OperDesc=HeaderDesc
						Continue:OperDesc=""
						If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,OperDesc)) {
							Set DataStr=1
							Set SummaryStr=SummaryStr_","_ItemDesc_":"_OperDesc
						}
					} Else {
						If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc)) {
							Set DataStr=1
							Set SummaryStr=SummaryStr_","_ItemDesc
						}
					}
				}
			}
			Continue:DataStr=""
			Continue:SummaryStr=""
			Set SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
			
			//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、当前床号、预警科室ID、预警科室、预警床位ID、预警床位、预警值列表
		 	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
		 	Continue:'$IsObject(objAdm)
		 	Set RegNo=objAdm.PAPapmiNo
		 	Set MrNo=objAdm.PAMrNo
		 	Set PatName=objAdm.PAPatName
		 	Set Sex=objAdm.PASex
		 	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
		 	Set Age=objAdm.PAAge
		 	Set (AdmLoc,AdmWard,AdmBed,AdmDate,DischDate)=""
		 	If $IsObject(objAdm.PAAdmLocDr){
			 	Set AdmLoc=objAdm.PAAdmLocDr.BTDesc
			 	Set AdmLoc2=objAdm.PAAdmLocDr.BTDesc2
			 	Set:AdmLoc2'="" AdmLoc=AdmLoc2
		 	}
		 	If $IsObject(objAdm.PAAdmWardDr){
			 	Set AdmWard=objAdm.PAAdmWardDr.BTDesc
			 	Set AdmWard2=objAdm.PAAdmWardDr.BTDesc2
			 	Set:AdmWard2'="" AdmWard=AdmWard2
		 	}
		 	Set (AdmBedDr,AdmBed)=""
		 	If $IsObject(objAdm.PAAdmBedDr){
			 	Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
			 	Set AdmBed=objAdm.PAAdmBedDr.BTDesc
		 	}
		 	Set AdmDate=objAdm.PAAdmDate
		 	//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		 	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		 	Set DischDate=objAdm.PADischDate
		 	//Set:DischDate'="" DischDate=$zd(DischDate,3)
	        Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		
		 	//感染信息
		 	Set InfInfo = ""
		 	Set xInfDiagID = 0
		 	For {
			 	Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeDr,xInfDiagID))
			 	Quit:xInfDiagID=""
			 	
			 	Set objInfDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
			 	Continue:'$IsObject(objInfDiag)
		 		Continue:'$IsObject(objInfDiag.IRInfPosDr)
		 		Set InfDate = objInfDiag.IRInfDate
		 		Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
		 		
		 		Set InfInfo = InfInfo_","_InfDate_objInfDiag.IRInfPosDr.BTDesc
			}
			If (InfInfo'=""){Set InfInfo = $e(InfInfo,2,$l(InfInfo))}
		 	
		 	Set Data=$lb(xEpisodeDr,RegNo,MrNo,PatName,Sex,Age,AdmLoc,AdmWard,AdmBedDr,AdmBed,InfInfo,AdmDate,DischDate)
			Set Data=Data_$lb(WarnLocDr,WarnLocDesc,WarnBedDr,WarnBedDesc,DataStr)
			Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryWarnPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarnPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnPatListExecute ]
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

// w ##class(DHCHAI.IRS.CCWarningSrv).QueryProcess("2020-03-25","1","28","","W")

ClassMethod QueryProcess(aWarnDate As %String, aWarnItems As %String, aHospIDs As %String, aLocIDs As %String, aHeader As %String = "", aLocType As %String = "W") As %String
{
	New (aWarnDate,aWarnItems,aHospIDs,aLocIDs,aHeader,aLocType,ZIndex,JIndex,NIndex)
	Set return=0
	Quit:(aWarnDate="")||(aWarnItems="") return
	Quit:(ZIndex="")||(JIndex="")||(NIndex="") return
	
	Set $ZT="QueryProcessErr"
	
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
 	Set:aWarnDate["-" aWarnDate=$zdh(aWarnDate,3)
 	
 	//条件及输出列
 	Set WarnIndex=0
 	Set xIndNo=""
 	For {
	 	Set xIndNo=$o(^DHCHAI.IR.CCItmWarnI("IdxofIndNo",xIndNo))
	 	Quit:xIndNo=""
	 	Set xItemID=0
	 	For {
		 	Set xItemID=$o(^DHCHAI.IR.CCItmWarnI("IdxofIndNo",xIndNo,xItemID))
		 	Quit:xItemID=""
		 	Set obj=##class(DHCHAI.IR.CCItmWarn).GetObjById(xItemID)
		 	Continue:'$IsObject(obj)
		 	Continue:obj.CCIsActive'=1
		 	Set Desc=obj.CCDesc
		 	Set Desc2=obj.CCDesc2
		 	Set:Desc2="" Desc2=Desc
		 	Continue:Desc=""
		 	
			Set WarnIndex=WarnIndex+1
			Set ^TMP(ZIndex,JIndex,NIndex,"WarnHeader",WarnIndex,0)=Desc
		 	If Desc="检出同种菌" {
			 	Set BactList=obj.CCArg3
			 	Set BactList=$tr(BactList,"，",",")
			 	Set BactList=$tr(BactList,"、",",")
			 	Set IsHeader=0
			 	For indBact=1:1:$l(BactList,",") {
				 	Set Bacteria=$p(BactList,",",indBact)
				 	Continue:Bacteria=""
				 	Continue:(aHeader'="")&(aHeader'[Bacteria)
				 	Set IsHeader=1
				 	Set ^TMP(ZIndex,JIndex,NIndex,"WarnHeader",WarnIndex,indBact)=$lb(Bacteria,Desc)
				}
				Continue:IsHeader<1
		 	} ElseIf (Desc="手术切口感染"){
				Set OperList=obj.CCArg3
			 	Set OperList=$tr(OperList,"，",",")
			 	Set OperList=$tr(OperList,"、",",")
			 	Set IsHeader=0
			 	For indOper=1:1:$l(OperList,",") {
				 	Set OperDesc=$p(OperList,",",indOper)
				 	Continue:OperDesc=""
				 	Continue:(aHeader'="")&(aHeader'[OperDesc)
				 	Set IsHeader=1
				 	Set ^TMP(ZIndex,JIndex,NIndex,"WarnHeader",WarnIndex,indOper)=$lb(OperDesc,Desc)
				}
				Continue:IsHeader<1
			} Else {
			 	Continue:(aHeader'="")&(aHeader'[Desc2)
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnHeader",WarnIndex,1)=$lb(Desc2,Desc)
			}
			Set ^TMP(ZIndex,JIndex,NIndex,"WarnArgs",Desc)=""
		}
	}
	
 	//检索条件
 	Set Is24HourFlag=0
 	For indWI=1:1:$l(aWarnItems,"^") {
	 	Set WarnItem=$p(aWarnItems,"^",indWI)
	 	Continue:WarnItem=""
	 	Set ItemDesc=$p(WarnItem,"|",1)
	 	Continue:ItemDesc=""
	 	//Continue:'$d(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",ItemDesc))  //输入参数与配置项目不匹配退出
	 	If ItemDesc="入院24H内计入" {
		 	Set Is24HourFlag=+$p(WarnItem,"|",2)
		} Else {
		 	Set tWarnDays=+$p(WarnItem,"|",2)
		 	Set tWarnCnt=+$p(WarnItem,"|",3)
		 	Set tFromDate=aWarnDate-(tWarnDays-1)   //包含当天是7天
		 	Set tToDate=aWarnDate
		 	Set ^TMP(ZIndex,JIndex,NIndex,"WarnArgs",ItemDesc)=$lb(tFromDate,tToDate,tWarnCnt,aWarnDate,tWarnDays)
		}
	}
	
	//按就诊筛查暴发指标
	//Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aWarnDate,aWarnDate,"","","I")
	//Quit:arrEpisodeDr.Count()<1 return  //无住院病人
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
 	
	Set RstEpisArr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aWarnDate,aWarnDate,aLocType,"","I")
 	//Quit:RstEpisArr.Count()<1 return  //无住院病人 //bug 必须输出表格头部内容
 	FOR indEpis=1:1:RstEpisArr.Count() {
		Set TransInfo=RstEpisArr.GetAt(indEpis)
		Set idxDate = $LIST(TransInfo,1)
		Set idxStatus = $LIST(TransInfo,3)
		Set idxLocID = $LIST(TransInfo,4)
		Set xEpisodeDr = $LIST(TransInfo,2)
		Continue:xEpisodeDr=""
		//根据时间点取科室、病区、床位信息
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeDr,aWarnDate)
		Continue:TransInfo=""
		Set TransBedDr=$p(TransInfo,"^",3)
		Set WarnBedDr="",WarnBedDesc=""
		Set objWarnBed=##class(DHCHAI.BT.PACBed).GetObjById(TransBedDr)
		Set objWarnLoc=""
		If $IsObject(objWarnBed) {
			Set WarnBedDr=objWarnBed.%Id()
			Set WarnBedDesc=objWarnBed.BTDesc
			
			//处理虚拟病区的问题 mayanpeng 2018-07-26
			If $IsObject(objWarnBed.BTXLocDr){
				Set objWarnLoc=objWarnBed.BTXLocDr
			}
		}
		
		If '$IsObject(objWarnLoc) {
			Set TransWardDr=idxLocID
			Set objWarnLoc=##class(DHCHAI.BT.Location).GetObjById(TransWardDr)
			Continue:'$IsObject(objWarnLoc)
		}
		Set WarnLocDr=objWarnLoc.%Id()
		Continue:(aLocIDs'="")&($listfind(aLocIDs,WarnLocDr)<1)  //按预警科室过滤
		Continue:'$IsObject(objWarnLoc.BTHospDr)
		Set WarnHospDr=objWarnLoc.BTHospDr.%Id()
		Continue:(aHospIDs'="")&($listfind(aHospIDs,WarnHospDr)<1)  //按预警科室院区过滤
		Set WarnLocDesc=objWarnLoc.BTDesc
		Set WarnLocDesc2=objWarnLoc.BTDesc2
		Set:WarnLocDesc2'="" WarnLocDesc=WarnLocDesc2
		
		
		Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDesc)=$lb(WarnLocDr,WarnLocDesc)
		Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr)=$lb(WarnLocDr,WarnLocDesc,WarnBedDr,WarnBedDesc)
		
		Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
		Continue:'$IsObject(objAdm)
		Set AdmDate=objAdm.PAAdmDate
		Set AdmTime=objAdm.PAAdmTime
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",xItemDesc))
			Quit:xItemDesc=""
			
			Set ArgData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",xItemDesc))
			Continue:ArgData=""
			Set FromDate=$listget(ArgData,1)
			Set ToDate=$listget(ArgData,2)
			Set WarnCnt=$listget(ArgData,3)
			Set WarnDate=$listget(ArgData,4)
			Set WarnDays=$listget(ArgData,5)
			If Is24HourFlag=0 {
				Set Is24HourDateTime=(AdmDate+1)_","_AdmTime
			} Else {
				Set Is24HourDateTime=""
			}
			If xItemDesc="相同感染诊断" {
				Set flg=..GetCurrInfByAdm(xEpisodeDr,WarnDate,WarnDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf (xItemDesc="发热人数") {
				Set flg=..GetFerverByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf (xItemDesc="发热标准差") {
				Set flg=..GetFerverByAdm(xEpisodeDr,WarnDate,WarnDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="检出同种菌" {
				Set BactList=..GetBactListByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				For indBL=1:1:$listlength(BactList) {
					Set Bacteria=$listget(BactList,indBL)
					Continue:Bacteria=""
					Continue:(aHeader'="")&(aHeader'[Bacteria)
					//一个患者检出多种菌统计错误修改
					Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc,Bacteria))
					Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria)=""
				}
			} ElseIf xItemDesc="便常规异常" {
				Set flg=..GetSRTByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="呼吸机使用" {
				Set flg=..GetVAPByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="中心静脉置管" {
				Set flg=..GetPICCByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="泌尿道插管" {
				Set flg=..GetUCByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				b:flg>0
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""	
			} ElseIf xItemDesc="手术切口感染" {
				Set OperList=..GetInfPosListByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime)
				For indBL=1:1:$listlength(OperList) {
					Set OperDescs=$listget(OperList,indBL)
					Continue:OperDescs=""
					Continue:(aHeader'="")&(aHeader'[OperDescs)
					//一个患者多种感染诊断修改
					Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,OperDescs))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc,OperDescs))
					Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,OperDescs)=""
				}
			} ElseIf xItemDesc="上呼吸道感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime,xItemDesc)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="下呼吸道感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime,xItemDesc)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="血管相关性感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime,xItemDesc)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} ElseIf xItemDesc="泌尿道感染" {
				Set xInfPosDesc="有症状的泌尿道感染"
				Set flg=..GetInfPosByAdm(xEpisodeDr,FromDate,ToDate,Is24HourDateTime,xInfPosDesc)
				Set:(flg>0&('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set:flg>0 ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
			} Else {}
		}
	}
	Quit 1
	
QueryProcessErr
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit -999_"^"_$ZError
}

ClassMethod GetCurrInfByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return>0  //退出
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
			Quit:xRepID=""
			Quit:return>0  //退出
			
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.IRStatusDr)
			Set Status=objRep.IRStatusDr.BTDesc
			Set StatusCode=objRep.IRStatusDr.BTCode
			Continue:StatusCode=4   //作废|删除
			
			Set arrInfDiag=objRep.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
			Continue:arrInfDiag.Count()<1
			For indD=1:1:arrInfDiag.Count() {
				Set objInfDiag=arrInfDiag.GetAt(indD)
				Continue:'$IsObject(objInfDiag)
				
				Set InfDate=objInfDiag.IRInfDate
				Continue:InfDate=""
				Continue:InfDate>aToDate
				Continue:(Is24HourDate'="")&(InfDate<Is24HourDate)
				//Continue:(Is24HourDate=InfDate)&(ActTime<Is24HourTime)
				
				Set InfXDate=objInfDiag.IRInfXDate
				If InfXDate'="" {
					Continue:InfXDate<aFromDate
				}
				Set return=1
				Quit:return>0  //退出
			}
		}
	}
	Quit return
}

/// w ##class(DHCHAI.IRS.CCWarningSrv).GetFerverByAdm(2103,$zdh("2017-08-01",3),$zdh("2017-08-31",3),"")
ClassMethod GetFerverByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:return>0 //退出
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="MR-ObsFever"  //护理-发热
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			Quit:return>0 //退出
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:return>0 //退出
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set return=1
			}
		}
	}
	Quit return
}

ClassMethod GetBactListByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %List
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=""
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-Bacteria"  //检验-检出菌
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set Bacteria=obj.CCBacteria
				Continue:Bacteria=""
				Set SCode = obj.CCSCode
				Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				If $IsObject(objBactMap){
					Continue:objBactMap.BTIsActive'=1
					If $IsObject(objBactMap.BTMapItemDr){
						Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
					}
				}
				Continue:Bacteria=""

				
				Continue:$listfind(return,Bacteria)>0
				Set return=return_$lb(Bacteria)
			}
		}
	}
	Quit return
}

ClassMethod GetSRTByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:return>0 //退出
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			Quit:return>0 //退出
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:return>0 //退出
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Continue:'$IsObject(obj.CCKeyWordDr)
				Continue:obj.CCKeyWordDr.CCDesc'="便常规"
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set return=1
			}
		}
	}
	Quit return
}

ClassMethod GetVAPByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:return>0 //退出
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-Intubate"  //医嘱-器械相关治疗
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			Quit:return>0 //退出
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:return>0 //退出
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Continue:'$IsObject(obj.CCKeyWordDr)
				Continue:obj.CCKeyWordDr.CCDesc'="呼吸机"
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set return=1
			}
		}
	}
	Quit return
}

ClassMethod GetPICCByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:return>0 //退出
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-Intubate"  //医嘱-器械相关治疗
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			Quit:return>0 //退出
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:return>0 //退出
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Continue:'$IsObject(obj.CCKeyWordDr)
				Continue:obj.CCKeyWordDr.CCDesc'="中心静脉置管"
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set return=1
			}
		}
	}
	Quit return
}

ClassMethod GetUCByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:return>0 //退出
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-Intubate"  //医嘱-器械相关治疗
		
		Set xActDate=aFromDate-1
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>aToDate
			Quit:return>0 //退出
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:return>0 //退出
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Continue:'$IsObject(obj.CCKeyWordDr)
				Continue:obj.CCKeyWordDr.CCDesc'="导尿管"
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:ActDate=""
				Continue:(Is24HourDate'="")&(ActDate<Is24HourDate)
				Continue:(Is24HourDate=ActDate)&(ActTime<Is24HourTime)
				
				Set return=1
			}
		}
	}
	Quit return
}

/// w ##class(DHCHAI.IRS.CCWarningSrv).GetInfPosListByAdm(12733,"64469","64469","")
ClassMethod GetInfPosListByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String, aInfPosDesc As %String) As %List
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=""
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
			Quit:xRepID=""
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			//Continue:'$IsObject(objRep.IRStatusDr)
			//Set Status=objRep.IRStatusDr.BTDesc
			//Set StatusCode=objRep.IRStatusDr.BTCode
			//Continue:StatusCode=4   //作废|删除
			Set arrInfDiag=objRep.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
			Continue:arrInfDiag.Count()<1
			For indD=1:1:arrInfDiag.Count() {
				Set objInfDiag=arrInfDiag.GetAt(indD)
				Continue:'$IsObject(objInfDiag)
				
				set objInfPos=objInfDiag.IRInfPosDr
				Continue:'$IsObject(objInfPos)
				Set InfPosDesc=objInfPos.BTDesc
				Set InfDate=objInfDiag.IRInfDate
				Continue:InfDate=""
				Continue:InfDate>aToDate
				Continue:(Is24HourDate'="")&(InfDate<Is24HourDate)
				//Continue:(Is24HourDate=InfDate)&(ActTime<Is24HourTime)
				Set InfXDate=objInfDiag.IRInfXDate
				If InfXDate'="" {
					Continue:InfXDate<aFromDate
				}
				Continue:$listfind(return,InfPosDesc)>0
				Set return=return_$lb(InfPosDesc)
			}
		}
	}
	Quit return
}

/// w ##class(DHCHAI.IRS.CCWarningSrv).GetInfPosByAdm(12733,"64469","64469","","有症状的泌尿道感染")
ClassMethod GetInfPosByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String, aInfPosDesc As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime,aInfPosDesc)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="")||(aInfPosDesc="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return>0  //退出
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
			Quit:xRepID=""
			Quit:return>0  //退出
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			//Continue:'$IsObject(objRep.IRStatusDr)
			//Set Status=objRep.IRStatusDr.BTDesc
			//Set StatusCode=objRep.IRStatusDr.BTCode
			//Continue:StatusCode=4   //作废|删除
			Set arrInfDiag=objRep.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
			Continue:arrInfDiag.Count()<1
			For indD=1:1:arrInfDiag.Count() {
				Set objInfDiag=arrInfDiag.GetAt(indD)
				Continue:'$IsObject(objInfDiag)
				
				set objInfPos=objInfDiag.IRInfPosDr
				Continue:'$IsObject(objInfPos)
				Set InfPosDesc=objInfPos.BTDesc
				Continue:(aInfPosDesc'=InfPosDesc)&&(aInfPosDesc'="")
				Set InfDate=objInfDiag.IRInfDate
				Continue:InfDate=""
				Continue:InfDate>aToDate
				Continue:(Is24HourDate'="")&(InfDate<Is24HourDate)
				//Continue:(Is24HourDate=InfDate)&(ActTime<Is24HourTime)
				Set InfXDate=objInfDiag.IRInfXDate
				If InfXDate'="" {
					Continue:InfXDate<aFromDate
				}
				Set return=1
				Quit:return>0  //退出
			}
		}
	}
	Quit return
}

/// w ##class(DHCHAI.IRS.CCWarningSrv).TestOneTwoFlag()
ClassMethod TestOneTwoFlag() As %String
{
	New
	Set Count =100000000
	Set CurrTime = $h
	FOR index=1:1:Count {
		Set a = 1
		Set b = 2
		Set c = 3
		Set d= 4
		if ((a'=b)&(b=c)&(a=c)&(d=4))
		{
			Set c=0
		}
  	}
  	Set ret1 = ($p($h,",",2)-$p(CurrTime,",",2))
  	
  	Set CurrTime = $h
	FOR index=1:1:Count {
		Set a = 1
		Set b = 2
		Set c = 3
		Set d = 4
		if ((a'=b)&&(b=c)&&(a=c)&&(d=4))
		{
			Set c=0
		}
  	}
  	Set ret2 = ($p($h,",",2)-$p(CurrTime,",",2))
  	W "&耗时:"_ret1_",&&耗时"_ret2,!
  	Quit "OK"
}

/// Creator：     chenjb
/// CreatDate：   2017-10-23
/// Description:  查询N天内某项目变化趋势
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID : 科室ID
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目
/// Return：      返回ROWSPEC
/// w ##class(DHCHAI.IRS.CCWarningSrv).GetCurrItemIndex("97","2019-03-19","","发热人数","1")
ClassMethod GetCurrItemIndex(aLocID As %String, aWarnDate As %String, aWarnItems As %String, aSelItem As %String, aFlag As %String) As %String
{
	New (aLocID,aWarnDate,aWarnItems,aSelItem,aFlag)
	Set ret = ""
	Quit:(aLocID="")||(aWarnDate="")||(aSelItem="") ret
	
	Set DiffDate = 7  //图表显示N天内的人数变化
	Set:aFlag="" aFlag=1  //入院24小时内是否统计  是
	Set Is24HourFlag=aFlag 
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetCurrItemIndex"
	
	Set xDateTo=$zdh(aWarnDate,3)
	Set:xDateTo>+$h xDateTo = +$h    //最大到当天
	Set xDateFrom = xDateTo - (DiffDate -1)
	
	//处理虚拟病区的问题 mayanpeng 2018-07-27
	/* Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) ret
	If $IsObject(objLoc.BTParLocDr) {
		Set aLocID=objLoc.BTParLocDr.%Id()
	} */
	Set WarnLocDr = aLocID  //防止没有定义2020-01-10
	Set xItemDesc = aSelItem   //防止没有定义2020-03-30
 	Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(xDateFrom,xDateTo,"W",aLocID,"I")	
 	Quit:RstEpisArr.Count()<1 ret  //无住院病人  
 	Set NumList = ""  //输出结果
 	For xDate=xDateFrom:1:xDateTo {
		Set num = 0
		Quit:xDate>(+$h)
		FOR index=1:1:RstEpisArr.Count() {
			Set TransInfo=RstEpisArr.GetAt(index)
			Set idxDate = $LIST(TransInfo,1)
			Set idxStatus = $LIST(TransInfo,3)
			Set idxLocID = $LIST(TransInfo,4)
			Set xEpisodeDr = $LIST(TransInfo,2)
			Continue:(idxDate'=xDate)
			//Continue:idxStatus'="A"  //入院24小时计入时不需再过滤
			
			//处理虚拟病区的问题 mayanpeng 2018-07-26
			Set TransBedInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeDr,xDate)
			Continue:TransBedInfo=""
			Set TransBedDr=$p(TransBedInfo,"^",3)
			Set objWarnBed=##class(DHCHAI.BT.PACBed).GetObjById(TransBedDr)
			Set objWarnLoc=""
			If $IsObject(objWarnBed) {
				If $IsObject(objWarnBed.BTXLocDr){
					Set objWarnLoc=objWarnBed.BTXLocDr
				}
			}
			
			//update by zf 2018-03-24
			//保证预警科室与图例科室算法一致
			If '$IsObject(objWarnLoc) {
				Set TransWardDr=idxLocID
				Set objWarnLoc=##class(DHCHAI.BT.Location).GetObjById(TransWardDr)
				Continue:'$IsObject(objWarnLoc)
			}
			Set WarnLocDr=objWarnLoc.%Id()
			
			Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
			Continue:'$IsObject(objAdm)
			Set AdmDate=objAdm.PAAdmDate
			Set AdmTime=objAdm.PAAdmTime
			
			//w idxDate_","_xDate_","_idxLocID_","_aLocID,!
			If Is24HourFlag=0 {
				Set Is24HourDateTime=(AdmDate+1)_","_AdmTime
			} Else {
				Set Is24HourDateTime=""
			}
			Set xItemDesc = aSelItem   //通过点击表格 说项目值一定存在
			
			If xItemDesc="现患人数" {
				Set flg=..GetCurrInfByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc["发热人数" {
				Set flg=..GetFerverByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="便常规异常" {
				Set flg=..GetSRTByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="呼吸机使用" {
				Set flg=..GetVAPByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="中心静脉置管" {
				Set flg=..GetPICCByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="泌尿道插管" {
				Set flg=..GetUCByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="上呼吸道感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime,xItemDesc)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="下呼吸道感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime,xItemDesc)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="血管相关性感染" {
				Set flg=..GetInfPosByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime,xItemDesc)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf xItemDesc="泌尿道感染" {
				Set xInfPosDesc="有症状的泌尿道感染"
				Set flg=..GetInfPosByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime,xInfPosDesc)
				Set:flg>0 num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
			} ElseIf ("表浅手术切口感染、深部手术切口感染、器官和腔隙感染"[xItemDesc) {
				Set OperList=..GetInfPosListByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				For indBL=1:1:$listlength(OperList) {
					Set OperDescs=$listget(OperList,indBL)
					Continue:OperDescs=""
					Continue:(xItemDesc'="")&(OperDescs'=xItemDesc)
					Set num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
				}
			} Else {
				//xItemDesc="检出同种菌"
				Set BactList=..GetBactListByAdm(xEpisodeDr,xDate,xDate,Is24HourDateTime)
				For indBL=1:1:$listlength(BactList) {
					Set Bacteria=$listget(BactList,indBL)
					Continue:Bacteria=""
					Continue:(xItemDesc'="")&(Bacteria'=xItemDesc)  //就只会一种菌
					Set num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))
				}
			} 
		}
		Set num=$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,xItemDesc))	//add
		Set:num="" num=0
		Set:NumList'="" NumList = NumList_"^"_num
		Set:NumList="" NumList = num
	}
	Set ret = NumList
	Kill ^TMP(ZIndex,JIndex,NIndex)
 	Quit ret
}

}
