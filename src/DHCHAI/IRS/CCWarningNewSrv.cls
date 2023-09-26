/// 名称: DHCHAI.IRS.CCWarningSrv
/// 描述: 暴发预警相关服务
/// 编写者：pylian
/// 编写日期: 2021-03-11
Class DHCHAI.IRS.CCWarningNewSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-03-11
/// Description:  查询暴发预警记录
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aHospIDs : 医院代码 多值"^"分割
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目 相同感染诊断|7|3^发热标准差|30|2^发热人数|7|3^检出同种同源菌|7|3^入院24H内计入|1
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningNewSrv","QryWarnResult","1|2","","2019-02-14","相同感染诊断|7|3^发热标准差|30|2^发热人数|7|3^检出同种同源菌|7|3^入院24H内计入|0")   
Query QryWarnResult(aHospIDs As %String, aLocIDs As %String, aWarnDate As %String, aWarnItems As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,InfInfo:%String,BacteriaInfo:%String,FeverCnt:%String,FeStandCnt:%String,TZBacteriaInfo:%String") [ SqlProc ]
{
}

ClassMethod QryWarnResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocIDs As %String, aWarnDate As %String, aWarnItems As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aWarnDate="")||(aWarnItems="") $$$OK

 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnResult"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	Set flg=..QueryProcess(aWarnDate,aWarnItems,aHospIDs,aLocIDs,"W")
 	Quit:(+flg)<1 $$$OK
 
	//输出预警值
	Set xWarnLoc=""
	For {
		Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Quit:xWarnLoc=""
		
		Set InfInfo="",BacteriaInfo="",TZBacteriaInfo="",InfCnt=0,BactCnt=0,FeverCnt=0,AbFever=0,FeStandCnt=0,JNSJCnt=0
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
			Quit:xItemDesc=""
			
			Set ArgData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",xItemDesc))
			Continue:ArgData=""
			Set FromDate=$listget(ArgData,1)
			Set ToDate=$listget(ArgData,2)
			Set WarnCnt=$listget(ArgData,3)
			Set WarnDate=$listget(ArgData,4)
			Set WarnDays=$listget(ArgData,5)
			Set:WarnCnt=0 WarnCnt =1   //默认条件不输入为1
			Set:WarnDays=0 WarnDays =7   //默认条件不输入为7
		    
			If (xItemDesc="相同感染诊断") {
				Set xInfPos=""
				For {
					Set xInfPos=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
					Quit:xInfPos=""
					
					Set InfCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
					Continue:InfCnt<WarnCnt
					Set InfInfo=InfInfo_"^"_xInfPos_"#"_InfCnt
				}			
				Set:InfInfo'="" InfInfo=$e(InfInfo,2,$l(InfInfo))
			}ElseIf (xItemDesc="检出同种菌") {
				Set xBacteria=""
				For {
					Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Quit:xBacteria=""
					
					Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Continue:BactCnt<WarnCnt
					Set BacteriaInfo=BacteriaInfo_"^"_xBacteria_"#"_BactCnt
				}				
				Set:BacteriaInfo'="" BacteriaInfo=$e(BacteriaInfo,2,$l(BacteriaInfo))
			}ElseIf (xItemDesc="检出同种同源多耐菌") {
				Set xBacteria=""
				For {
					Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Quit:xBacteria=""
					Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Continue:BactCnt<WarnCnt
					Set TZBacteriaInfo=TZBacteriaInfo_"^"_xBacteria_"#"_BactCnt
				}				
				Set:TZBacteriaInfo'="" TZBacteriaInfo=$e(TZBacteriaInfo,2,$l(TZBacteriaInfo))
			}ElseIf (xItemDesc="发热人数") {
				Set FeverCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
				Continue:FeverCnt<WarnCnt
				Set AbFever =1
			}ElseIf (xItemDesc="发热标准差") {
				Set FeStandCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
				Set:$e(FeStandCnt,1)="." FeStandCnt = "0"_FeStandCnt
			}Else{}
		}
		Continue:(InfInfo="")&&(BacteriaInfo="")&&(TZBacteriaInfo="")&&(AbFever=0)&&(FeStandCnt=0)
		Set:AbFever=0 FeverCnt=0
		Set LocData=$g(^DHCHAI.BT.LocationD(xWarnLoc))
		Set LocDesc=$li(LocData,3)
		Set LocDesc2=$li(LocData,4)
	    Set:LocDesc2'="" LocDesc=LocDesc2
		//科室ID、科室名称、预警值列表
		Set Data=$lb(xWarnLoc,LocDesc,InfInfo,BacteriaInfo,FeverCnt,FeStandCnt,TZBacteriaInfo)
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

/// Creator：     pylian
/// CreatDate：   2021-03-12
/// Description:  查询暴发预警病人列表
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID : 科室ID
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningNewSrv","QryWarnPatList","29","2022-12-04","相同感染诊断|7|3^发热标准差|30|2^发热人数|7|3^检出同种同源菌|7|3^入院24H内计入|0","相同感染诊断")
Query QryWarnPatList(aLocID As %String, aWarnDate As %String, aWarnItems As %String, aSelItem As %String = "") As %Query(ROWSPEC = "EpisodeDr:%String,RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLoc:%String,AdmWard:%String,AdmBedDr:%String,AdmBed:%String,InfInfo:%String,AdmDate:%String,DischDate:%String,WarnLocDr:%String,WarnLocDesc:%String,WarnBedDesc:%String,SummaryStr:%String,BacteriaStr:%String") [ SqlProc ]
{
}

ClassMethod QryWarnPatListExecute(ByRef qHandle As %Binary, aLocID As %String, aWarnDate As %String, aWarnItems As %String, aSelItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aLocID="")||(aWarnDate="")||(aWarnItems="") $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnPatList"
 	Set flg=..QueryProcess(aWarnDate,aWarnItems,"",aLocID,"W")
 	Quit:(+flg)<1 $$$OK
   
	//输出科室暴发预警结果
	Set xWarnLoc=""
	For {
		Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Quit:xWarnLoc=""
		Continue:(aLocID'="")&&(aLocID'=xWarnLoc)  //过滤科室、病区
		
		Set xEpisodeDr=""
		For {
			Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set WarnBed=""
			Set WarnBedDr=$g(^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",xWarnLoc,xEpisodeDr))
			Set WarnBedData=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			If WarnBedData'=""{
				Set WarnBed=$li(WarnBedData,3)
			}
			Set:(WarnBed'="")&&(WarnBed'["床") WarnBed=WarnBed_"床"
			
			Set SummaryStr="",BacteriaStr=""
			Set xItemDesc=""
			For {
				Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc))
				Quit:xItemDesc=""
				If (xItemDesc="相同感染诊断") {
					Set xDiagID=""
					For {
						Set xDiagID=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc,xDiagID))
						Quit:xDiagID=""				
					
						Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
						Continue:'$IsObject(objDiag)
						Set InfPos = objDiag.IRInfPosDr.BTDesc
						Continue:(aSelItem'="")&&(aSelItem'=InfPos)	
						Set SummaryStr=SummaryStr_","_xItemDesc_":"_InfPos					
					}			
				}ElseIf (xItemDesc="检出同种菌") {
					Set xBacteria=""
					For {
						Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc,xBacteria))
						Quit:xBacteria=""
						//add 20221206 增加检出菌信息
						If (BacteriaStr'[xBacteria) {
							Set BacteriaStr=BacteriaStr_","_xBacteria
						}
						Continue:(aSelItem'="")&&(aSelItem'=xBacteria)	
						Set SummaryStr=SummaryStr_","_xItemDesc_":"_xBacteria	
					}				
				}ElseIf (xItemDesc="检出同种同源多耐菌") {
					Set xBacteria=""
					For {
						Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc,xBacteria))
						Quit:xBacteria=""
						
						Continue:(aSelItem'="")&&(aSelItem'=xBacteria)	
						Set SummaryStr=SummaryStr_","_xItemDesc_":"_xBacteria	
					}				
			
				}ElseIf (xItemDesc="发热人数") {
					Continue:(aSelItem'="")&&(aSelItem'=xItemDesc)
					If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc)) {
						Set SummaryStr=SummaryStr_","_xItemDesc
					}
				}ElseIf (xItemDesc="发热标准差") {
					Continue:(aSelItem'="")&&(aSelItem'=xItemDesc)
					If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc)) {
						Set SummaryStr=SummaryStr_","_xItemDesc
					}
				}Else{}
			
			}
			Continue:SummaryStr=""
			Set SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
			Set:BacteriaStr'="" BacteriaStr=$e(BacteriaStr,2,$l(BacteriaStr))
			
			//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、当前床号、预警科室ID、预警科室、预警床位ID、预警床位、预警值列表
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:PAAdmData=""
			
			Set RegNo=$li(PAAdmData,4)     //登记号
			Set MrNo=$li(PAAdmData,5)        //病案号
			Set PatName=$li(PAAdmData,6)     //姓名
			Set Sex=$li(PAAdmData,7)             //性别
			Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
			Set Age=$li(PAAdmData,37)             //年龄
			Set AdmDate=$li(PAAdmData,20)     //就诊日期
			Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set AdmTime=$li(PAAdmData,21)     //就诊时间
			Set:AdmTime'="" AdmTime=$zt(AdmTime)
			Set DischDate=$li(PAAdmData,26) //出院日期
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		
			Set LocID=$li(PAAdmData,22)
			Continue:LocID=""
			Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
			Set LocDesc=$li(AdmLocData,3)
			Set LocDesc2=$li(AdmLocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set WardID=$li(PAAdmData,23)
			Continue:WardID=""
			Set AdmWardData=$g(^DHCHAI.BT.LocationD(WardID))
			Set WardDesc=$li(AdmWardData,3)
			Set WardDesc2=$li(AdmWardData,4)
			Set:WardDesc2'="" WardDesc=WardDesc2
			Set (CurrBedDr,CurrBed,AdmBedData)=""           //床位
			Set CurrBedDr=$li(PAAdmData,25)
			If CurrBedDr'=""{
				Set AdmBedData=$g(^DHCHAI.BT.PACBedD(CurrBedDr))
				If AdmBedData'=""{
					Set CurrBed=$li(AdmBedData,3)
				}
			}
			Set:(CurrBed'="")&&(CurrBed'["床") CurrBed=CurrBed_"床"
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
		 	
		 	
		 	Set WarnLocData=$g(^DHCHAI.BT.LocationD(xWarnLoc))
			Set WarnLocDesc=$li(WarnLocData,3)
			Set WarnLocDesc2=$li(WarnLocData,4)
		    Set:WarnLocDesc2'="" WarnLocDesc=WarnLocDesc2
	       
		 	Set Data=$lb(xEpisodeDr,RegNo,MrNo,PatName,Sex,Age,LocDesc,WardDesc,CurrBedDr,CurrBed,InfInfo,AdmDate,DischDate)
			Set Data=Data_$lb(WarnLocDr,WarnLocDesc,WarnBed,SummaryStr,BacteriaStr)
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

/// w ##class(DHCHAI.IRS.CCWarningNewSrv).QueryProcess("2019-02-14","相同感染诊断|7|3^发热标准差|30|2^发热人数|7|3^检出同种同源菌|7|3^入院24H内计入|0","","","W")
ClassMethod QueryProcess(aWarnDate As %String, aWarnItems As %String, aHospIDs As %String, aLocIDs As %String, aLocType As %String = "W") As %String
{
	New (aWarnDate,aWarnItems,aHospIDs,aLocIDs,aLocType,ZIndex,JIndex,NIndex)
	Set return=0
	Quit:(aWarnDate="")||(aWarnItems="") return
	Quit:(ZIndex="")||(JIndex="")||(NIndex="") return
	
	Set $ZT="QueryProcessErr"
	
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
 	Set:aWarnDate["-" aWarnDate=$zdh(aWarnDate,3)
 	Set:aWarnDate["/" aWarnDate=$zdh(aWarnDate,4)	
 	
 	//检索条件
 	Set Is24HourFlag=0
 	For indWI=1:1:$l(aWarnItems,"^") {
	 	Set WarnItem=$p(aWarnItems,"^",indWI)
	 	Continue:WarnItem=""
	 	Set ItemDesc=$p(WarnItem,"|",1)
	 	Continue:ItemDesc=""
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
		Set:WarnCnt=0 WarnCnt =1   //默认条件不输入为1
		Set:WarnDays=0 WarnDays =7   //默认条件不输入为7
       
		If xItemDesc="相同感染诊断" {
			Set CurrInfAdm=..GetCurrInfAdm(aHospIDs,aLocIDs,FromDate,ToDate,Is24HourFlag)
			For indC=1:1:CurrInfAdm.Count() {
				Set CurrInfInfo=CurrInfAdm.GetAt(indC)
				Continue:CurrInfInfo=""
				Set xEpisodeDr = $LIST(CurrInfInfo,1)
				Set WarnLocDr = $LIST(CurrInfInfo,2)
				Set WarnBedDr= $LIST(CurrInfInfo,3)
				Set WardDate = $LIST(CurrInfInfo,4)
				Set DiagnosID = $LIST(CurrInfInfo,5)   //以感染信息ID判断唯一	
				Set InfPos = $LIST(CurrInfInfo,6)			
				Continue:xEpisodeDr=""
				//add by chenjb 20210824判断感染部位之前是否排除
				Set QEp=..QueryProcessEpisode(aWarnDate,InfPos,xEpisodeDr)
				Continue:QEp=1
				//update 20221205 需求：3074768相同感染诊断调整为患者数量而不是感染诊断数量
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,InfPos))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc,InfPos))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,InfPos)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,DiagnosID)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",WarnLocDr,xEpisodeDr)=WarnBedDr
				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)=""    //记录预警科室	
			}			
		} ElseIf xItemDesc="检出同种菌" {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria") //检验-检出菌
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()	
			Set BacteriaAdm=..GetBacteriaAdm(aHospIDs,aLocIDs,FromDate,ToDate,ItemDr,Is24HourFlag)
			For indB=1:1:BacteriaAdm.Count() {
				Set BacteriaInfo=BacteriaAdm.GetAt(indB)
				Continue:BacteriaInfo=""
				Set xEpisodeDr = $LIST(BacteriaInfo,1)
				Set WarnLocDr = $LIST(BacteriaInfo,2)
				Set WarnBedDr= $LIST(BacteriaInfo,3)
				Set WardDate = $LIST(BacteriaInfo,4)
				Set Bacteria = $LIST(BacteriaInfo,5)			
				Continue:xEpisodeDr=""
				//add by chenjb 20210824判断感染部位之前是否排除
				Set QEp=..QueryProcessEpisode(aWarnDate,Bacteria,xEpisodeDr)
				Continue:QEp=1
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc,Bacteria))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",WarnLocDr,xEpisodeDr)=WarnBedDr
				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)=""    //记录预警科室
			}
		}ElseIf xItemDesc="检出同种同源多耐菌" {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria") //检验-检出菌
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()	
			Set BacteriaAdm=..GetTZTYBactAdm(aHospIDs,aLocIDs,FromDate,ToDate,ItemDr,Is24HourFlag)
			Set MRbSenList=""
			If (BacteriaAdm.Count()>1){
				Set MRbSenList=BacteriaAdm.GetAt(BacteriaAdm.Count())
			}
			Continue:(MRbSenList="")
			For indB=1:1:(BacteriaAdm.Count()-1) {
				Set BacteriaInfo=BacteriaAdm.GetAt(indB)
				Continue:BacteriaInfo=""
				Set xEpisodeDr = $LIST(BacteriaInfo,1)
				Set WarnLocDr  = $LIST(BacteriaInfo,2)
				Set WarnBedDr  = $LIST(BacteriaInfo,3)
				Set WardDate   = $LIST(BacteriaInfo,4)
				Set Bacteria   = $LIST(BacteriaInfo,5)
				Set MRBSenList = $LIST(BacteriaInfo,6)
				Set MRBCode    = $LIST(BacteriaInfo,7)			
				Continue:xEpisodeDr=""
				//add by chenjb 20210824判断感染部位之前是否排除
				Set QEp=..QueryProcessEpisode(aWarnDate,Bacteria,xEpisodeDr)
				Continue:QEp=1
				Set MRBSenCnt=0   // 药敏谱计数
				For indC=1:1:$LL(MRbSenList){
					Set SenList=$LG(MRbSenList,indC)
					Continue:SenList=""
					Set tMRBCode=$LIST(SenList,1)
					Set tWarnLocDr=$LIST(SenList,2) 
					If (MRBCode=tMRBCode)&&(MRBSenList=SenList)&&(tWarnLocDr=WarnLocDr){
						Set MRBSenCnt=MRBSenCnt+1
					}
				}
				Continue:(MRBSenCnt<WarnCnt)
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc,Bacteria))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc,Bacteria)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",WarnLocDr,xEpisodeDr)=WarnBedDr
				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)=""    //记录预警科室
			}
		}ElseIf (xItemDesc="发热人数") {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever") //护理-发热
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()
			Set FerverAdm=..GetFerverAdm(aHospIDs,aLocIDs,FromDate,ToDate,ItemDr,Is24HourFlag)
			For indF=1:1:FerverAdm.Count() {
				Set FerverInfo=FerverAdm.GetAt(indF)
				Continue:FerverInfo=""
				Set xEpisodeDr = $LIST(FerverInfo,1)
				Set WarnLocDr = $LIST(FerverInfo,2)
				Set WarnBedDr= $LIST(FerverInfo,3)
				Set WardDate = $LIST(FerverInfo,4)			
				Continue:xEpisodeDr=""
				//add by chenjb 20210824判断感染部位之前是否排除
				Set QEp=..QueryProcessEpisode(aWarnDate,xItemDesc,xEpisodeDr)
				Continue:QEp=1
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",WarnLocDr,xEpisodeDr)=WarnBedDr
				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",WarnLocDr)=""    //记录预警科室
			}
			
		}ElseIf (xItemDesc="发热标准差") {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever") //护理-发热
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()
			Set FerverAdm=..GetFerverAdm(aHospIDs,aLocIDs,WarnDate,WarnDate,ItemDr,Is24HourFlag)

			For indF=1:1:FerverAdm.Count() {
				Set FerverInfo=FerverAdm.GetAt(indF)
				Continue:FerverInfo=""
				Set xEpisodeDr = $LIST(FerverInfo,1)
				Set WarnLocDr = $LIST(FerverInfo,2)
				Set WarnBedDr= $LIST(FerverInfo,3)
				Set WardDate = $LIST(FerverInfo,4)					
				Continue:xEpisodeDr=""
				//add by chenjb 20210824判断感染部位之前是否排除
				Set QEp=..QueryProcessEpisode(aWarnDate,"发热人数",xEpisodeDr)
				Continue:QEp=1
				//Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xItemDesc)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",WarnLocDr,xEpisodeDr)=WarnBedDr
				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"Fever",WarnLocDr)))
				Set ^TMP(ZIndex,JIndex,NIndex,"Fever",WarnLocDr)=""    //记录发热科室
			}
			
			Continue:('$d(^TMP(ZIndex,JIndex,NIndex,"Fever")))
			Set xWarnLocDr="", ShortCnt=0
			For {
				Set xWarnLocDr =$o(^TMP(ZIndex,JIndex,NIndex,"Fever",xWarnLocDr))
				Quit:xWarnLocDr=""
				Set FeverNum=##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverArrByLoc(xWarnLocDr,WarnDate,WarnDate).GetAt(1)
				Set FeverNum=+FeverNum
			
				If FeverNum>0 {
		 			Set Stand=##class(DHCHAI.IRS.CCFeverNumSrv).GetStandByLocDate(xWarnLocDr,WarnDate-WarnDays,WarnDate-1)
		 			Set Average=##class(DHCHAI.IRS.CCFeverNumSrv).GetAveByLocDate(xWarnLocDr,WarnDate-WarnDays,WarnDate-1)
		 			Set ShortCnt=FeverNum-Average-(Stand*WarnCnt)	
		 			Set:ShortCnt'=0 ShortCnt=$fn(ShortCnt,"",2)	
		 		 	If (ShortCnt>0) {
			 			Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLocDr,xItemDesc)))
						Set ^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLocDr,xItemDesc)=ShortCnt  //比WarnDays天平均发热人数高WarnCnt个标准差
		 				
		 				Continue:($d(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLocDr)))
						Set ^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLocDr)=""    //记录预警科室
		 			}Else {
			 			Set ^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLocDr,xItemDesc)=0
		 			}
				} 
			}
		}Else{}
	}
 
	Quit 1
	
QueryProcessErr
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2021-03-11
/// Description:  获取患者感染信息列表
/// Table：       DHCHAI.IR.CCResult
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aFlg : 是否入院24h内
/// Return：      返回%List
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetCurrInfAdm("","86","2021-04-06","2021-04-06","0")
ClassMethod GetCurrInfAdm(aHospIDs As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String, aFlg As %String = "0") As %Library.ArrayOfDataTypes
{
	New (aHospIDs,aLocIDs,aDateFrom,aDateTo,aFlg)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateTo>+$h aDateTo=+$h
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")

	Set Count=0
	Set ZIndex=$zn,JIndex=$j,NIndex="GetCurrInfAdm"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetCurrInfAdmErr"
	Set xEpisodeID="" 
	For {
		Set xEpisodeID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set xDiagID = ""
		For {
			Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID,xDiagID))
			Quit:xDiagID=""
			
			Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiag)
			Continue:'$IsObject(objDiag.IRInfPosDr) 
			Set IsActive = objDiag.IRIsActive
			Continue:IsActive'=1
	       
			Set InfPosID = objDiag.IRInfPosDr.%Id()
			Set InfPos = objDiag.IRInfPosDr.BTDesc
			Set InfDate = objDiag.IRInfDate    //感染日期
			Set InfXDate = objDiag.IRInfXDate  //结束日期
	 
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(xEpisodeID))
			Continue:PAAdmData=""
			Set RegNo=$li(PAAdmData,4)     //登记号
			Set AdmDate=$lg(PAAdmData,20)     //就诊日期
			Set AdmTime=$lg(PAAdmData,21)     //就诊时间
			Set DischDate=$lg(PAAdmData,26)   //出院日期
			Set:(InfXDate="")&&(DischDate="") InfXDate=+$h
			Set:(InfXDate="")&&(DischDate'="") InfXDate=DischDate
	        Continue:(aFlg=0)&&(InfDate<(AdmDate+1))      // 24h内不计入     
		    Continue:((InfDate>aDateTo)||(InfXDate<aDateFrom))   // 感染发生日期晚于截止日期/感染转归日期早于开始日期，非预警期间发生感染
			Set xRepID=""			
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xDiagID,xRepID))
		    If (xRepID){    //已上报
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				If $IsObject(objReport){
					Continue:(objReport.IRRepType'=1)
					Continue:'$IsObject(objReport.IRStatusDr)
					Continue:objReport.IRStatusDr.BTCode=4	
				}				
		    }
			//根据异常发生时间点取科室、病区、床位信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,InfDate,"00:00:01")
			Continue:TransInfo=""
			Set WarnLocDr=$p(TransInfo,"^",2)
			Set WarnBedDr=$p(TransInfo,"^",3)					
			Set WarnBedDesc="",WarnXLocDr=""
			Set WarnBedInfo=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			Set:WarnBedInfo'="" WarnBedDesc=$lg(WarnBedInfo,3)
			Set:WarnBedInfo'="" WarnXLocDr=$lg(WarnBedInfo,11)
			Set:WarnXLocDr'="" WarnLocDr=WarnXLocDr  //处理虚拟病区的问题
			Continue:(aLocIDs'="")&($listfind(aLocIDs,WarnLocDr)<1)  //按预警科室过滤
			Set WarnHospDr=""
			Set WarnLocInfo=$g(^DHCHAI.BT.LocationD(WarnLocDr))
			Set:WarnLocInfo'="" WarnHospDr=$lg(WarnLocInfo,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,WarnHospDr)<1)  //按预警科室院区过滤
			
			//Continue:$d(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,xDiagID))   //同一次感染只算一次
			//Set ^TMP(ZIndex,JIndex,NIndex,xEpisodeID,xDiagID)=""
			
			Set AbEpisList=$lb(xEpisodeID,WarnLocDr,WarnBedDr,InfDate,xDiagID,InfPos,InfXDate)
			Set Count=Count+1
			Do return.SetAt(AbEpisList,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
GetCurrInfAdmErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-11
/// Description:  获取体温异常患者列表
/// Table：       DHCHAI.IR.CCResult
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aItemDr : 监测项目
///               aFlg : 是否入院24h内
/// Return：      返回%List
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetFerverAdm("","84","2019-02-14","2019-02-14","4","0")
ClassMethod GetFerverAdm(aHospIDs As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String, aItemDr As %String, aFlg As %String = "0") As %Library.ArrayOfDataTypes
{
	New (aHospIDs,aLocIDs,aDateFrom,aDateTo,aItemDr,aFlg)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="")||(aItemDr="") return

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateTo>+$h aDateTo=+$h
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
 	
	Set Count=0
	Set ZIndex=$zn,JIndex=$j,NIndex="GetFerverAdm"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetFerverAdmErr"
    Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
	
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate,xID))
			Quit:xID=""
		   
			Set ResultData=$g(^DHCHAI.IR.CCResultD(xID))
			Continue:ResultData=""
		   
		    Set EpisodeDr = $lg(ResultData,2)
		    Set IsActive  = $lg(ResultData,14)
			Continue:IsActive'=1
			Set ActDate   = $lg(ResultData,8)
			Set ActTime   = $lg(ResultData,9)
			
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:PAAdmData=""
			Set AdmDate=$lg(PAAdmData,20)     //就诊日期
			Set AdmTime=$lg(PAAdmData,21)     //就诊时间
	        Continue:(aFlg=0)&&(ActDate<(AdmDate+1))      // 24h内不计入
	        Continue:(aFlg=0)&&(ActDate=(AdmDate+1))&&(ActTime<AdmTime)      // 24h内不计入	        
			
			//根据异常发生时间点取科室、病区、床位信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			Continue:TransInfo=""
			Set WarnLocDr=$p(TransInfo,"^",2)
			Set WarnBedDr=$p(TransInfo,"^",3)					
			Set WarnBedDesc="",WarnXLocDr=""
			Set WarnBedInfo=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			Set:WarnBedInfo'="" WarnBedDesc=$lg(WarnBedInfo,3)
			Set:WarnBedInfo'="" WarnXLocDr=$lg(WarnBedInfo,11)
			Set:WarnXLocDr'="" WarnLocDr=WarnXLocDr  //处理虚拟病区的问题
			Continue:(aLocIDs'="")&($listfind(aLocIDs,WarnLocDr)<1)  //按预警科室过滤
			Set WarnHospDr=""
			Set WarnLocInfo=$g(^DHCHAI.BT.LocationD(WarnLocDr))
			Set:WarnLocInfo'="" WarnHospDr=$lg(WarnLocInfo,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,WarnHospDr)<1)  //按预警科室院区过滤
			
			Continue:$d(^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate))   //同一日内的异常只算一次
			Set ^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate)=""
			Set AbEpisList=$lb(EpisodeDr,WarnLocDr,WarnBedDr,ActDate)
			Set Count=Count+1
			Do return.SetAt(AbEpisList,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
GetFerverAdmErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-11
/// Description:  获取检出菌患者列表
/// Table：       DHCHAI.IR.CCResult
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aItemDr : 监测项目
///               aFlg : 是否入院24h内
/// Return：      返回%List
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetBacteriaAdm("","","2019-02-06","2019-02-12","1","0")
ClassMethod GetBacteriaAdm(aHospIDs As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String, aItemDr As %String, aFlg As %String = "0") As %Library.ArrayOfDataTypes
{
	New (aHospIDs,aLocIDs,aDateFrom,aDateTo,aItemDr,aFlg)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="")||(aItemDr="") return

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateTo>+$h aDateTo=+$h
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")

	Set Count=0
	Set ZIndex=$zn,JIndex=$j,NIndex="GetBacteriaAdm"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetBacteriaAdmErr"
    Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
	
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate,xID))
			Quit:xID=""
		   
			Set ResultData=$g(^DHCHAI.IR.CCResultD(xID))
			Continue:ResultData=""
		   
		    Set EpisodeDr = $lg(ResultData,2)
		    Set IsActive  = $lg(ResultData,14)
			Continue:IsActive'=1
			Set ActDate   = $lg(ResultData,8)
			Set ActTime   = $lg(ResultData,9)
			Set Bacteria  = $lg(ResultData,23)
			Continue:Bacteria=""
			Set SCode = $lg(ResultData,17)
			Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			Set tmpBacteria=""
			If $IsObject(objBactMap){
				Continue:objBactMap.BTIsActive'=1
				If $IsObject(objBactMap.BTMapItemDr){
					Set tmpBacteria=objBactMap.BTMapItemDr.BTBacDesc
				}
			}
			Continue:tmpBacteria=""
			Set Bacteria=tmpBacteria
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:PAAdmData=""
			Set AdmDate=$lg(PAAdmData,20)     //就诊日期
			Set AdmTime=$lg(PAAdmData,21)     //就诊时间
	        Continue:(aFlg=0)&&(ActDate<(AdmDate+1))      // 24h内不计入
	        Continue:(aFlg=0)&&(ActDate=(AdmDate+1))&&(ActTime<AdmTime)      // 24h内不计入	        
			
			//根据异常发生时间点取科室、病区、床位信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			Continue:TransInfo=""
			Set WarnLocDr=$p(TransInfo,"^",2)
			Set WarnBedDr=$p(TransInfo,"^",3)					
			Set WarnBedDesc="",WarnXLocDr=""
			Set WarnBedInfo=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			Set:WarnBedInfo'="" WarnBedDesc=$lg(WarnBedInfo,3)
			Set:WarnBedInfo'="" WarnXLocDr=$lg(WarnBedInfo,11)
			Set:WarnXLocDr'="" WarnLocDr=WarnXLocDr  //处理虚拟病区的问题
			Continue:(aLocIDs'="")&($listfind(aLocIDs,WarnLocDr)<1)  //按预警科室过滤
			Set WarnHospDr=""
			Set WarnLocInfo=$g(^DHCHAI.BT.LocationD(WarnLocDr))
			Set:WarnLocInfo'="" WarnHospDr=$lg(WarnLocInfo,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,WarnHospDr)<1)  //按预警科室院区过滤
			
			Continue:$d(^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate,Bacteria))   //同一日内的同种菌只算一次
			Set ^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate,Bacteria)=""
			
			Set AbEpisList=$lb(EpisodeDr,WarnLocDr,WarnBedDr,ActDate,Bacteria)
			Set Count=Count+1
			Do return.SetAt(AbEpisList,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
GetBacteriaAdmErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-04-24
/// Description:  获取同种同药敏谱患者列表
/// Table：       DHCHAI.IR.CCResult
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aItemDr : 监测项目
///               aFlg : 是否入院24h内
/// Return：      返回%List
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetTZTYBactAdm("","","2020-04-13","2022-04-14","1","0")
ClassMethod GetTZTYBactAdm(aHospIDs As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String, aItemDr As %String, aFlg As %String = "0") As %Library.ArrayOfDataTypes
{
	New (aHospIDs,aLocIDs,aDateFrom,aDateTo,aItemDr,aFlg)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="")||(aItemDr="") return
	Set BactSenArry=""
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateTo>+$h aDateTo=+$h
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")

	Set Count=0,SenCount=0
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTZTYBactAdm"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetTZTYBactAdmErr"
    Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
	
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",aItemDr,xActDate,xID))
			Quit:xID=""
		   
			Set ResultData=$g(^DHCHAI.IR.CCResultD(xID))
			Continue:ResultData=""
		   
		    Set EpisodeDr = $lg(ResultData,2)
		    Set IsActive  = $lg(ResultData,14)
			Continue:IsActive'=1
			Set ActDate   = $lg(ResultData,8)
			Set ActTime   = $lg(ResultData,9)
			Set Bacteria  = $lg(ResultData,23)
			Continue:Bacteria=""
			Set SCode = $lg(ResultData,17)
			Set IsAbFlag=$lg(ResultData,21)   //异常标志
			Continue:IsAbFlag'=1 //过滤非耐药菌
			
			Set MRBID= $lg(ResultData,24)
			Continue:MRBID=""
			Set MRBData=$g(^DHCHAI.IR.CRuleMRBD(MRBID))
			Set MRBDesc=$lg(MRBData,3)
			Set MRBCode=$lg(MRBData,2)
			Continue:MRBDesc="" //过滤出多重耐药菌
			
			//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
			Set ResultID = $p($lg(ResultData,19),"=",2)  //检验结果ID
			
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:PAAdmData=""
			Set AdmDate=$lg(PAAdmData,20)     //就诊日期
			Set AdmTime=$lg(PAAdmData,21)     //就诊时间
	        Continue:(aFlg=0)&&(ActDate<(AdmDate+1))      // 24h内不计入
	        Continue:(aFlg=0)&&(ActDate=(AdmDate+1))&&(ActTime<AdmTime)      // 24h内不计入	        
			
			//根据异常发生时间点取科室、病区、床位信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			Continue:TransInfo=""
			Set WarnLocDr=$p(TransInfo,"^",2)
			Set WarnBedDr=$p(TransInfo,"^",3)					
			Set WarnBedDesc="",WarnXLocDr=""
			Set WarnBedInfo=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			Set:WarnBedInfo'="" WarnBedDesc=$lg(WarnBedInfo,3)
			Set:WarnBedInfo'="" WarnXLocDr=$lg(WarnBedInfo,11)
			Set:WarnXLocDr'="" WarnLocDr=WarnXLocDr  //处理虚拟病区的问题
			Continue:(aLocIDs'="")&($listfind(aLocIDs,WarnLocDr)<1)  //按预警科室过滤
			Set WarnHospDr=""
			Set WarnLocInfo=$g(^DHCHAI.BT.LocationD(WarnLocDr))
			Set:WarnLocInfo'="" WarnHospDr=$lg(WarnLocInfo,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,WarnHospDr)<1)  //按预警科室院区过滤
			
			Continue:$d(^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate,MRBDesc))   //同一日内的同种菌只算一次
			Set ^TMP(ZIndex,JIndex,NIndex,EpisodeDr,ActDate,MRBDesc)=""
			
			Set MRBSenList=$lb(MRBCode,WarnLocDr)  //药敏结果
			Set xSenID = ""
			For {
		    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
		    	Quit:xSenID=""
				
				Set SenData = $g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
				Continue:SenData=""
			    
				Set AntCode      = $lg(SenData,3)
				Set AntDesc      = $lg(SenData,4)
				Set Sensitivity  = $lg(SenData,5)
		        Set MRBSenList = MRBSenList_$lb(AntCode_"#"_Sensitivity)
			}
			Continue:MRBSenList=$Lb(MRBCode,WarnLocDr)
			Set BactSenArry=BactSenArry_$lb(MRBSenList)
			
			Set AbEpisList=$lb(EpisodeDr,WarnLocDr,WarnBedDr,ActDate,MRBDesc,MRBSenList,MRBCode)
			Set Count=Count+1
			Do return.SetAt(AbEpisList,Count)
		}
	}
	Set Count=Count+1
	Do return.SetAt(BactSenArry,Count)
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
GetTZTYBactAdmErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// w ##class(DHCHAI.IRS.CCWarningSrv).GetFerverByAdm(6,$zdh("2019-02-08",3),$zdh("2019-02-14",3),"")
ClassMethod GetFerverByAdm(aEpisodeDr As %String, aFromDate As %String, aToDate As %String, aIs24HourDateTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aToDate,aIs24HourDateTime)
	Set return=0
	Quit:(aEpisodeDr="")||(aFromDate="")||(aToDate="") return
	
	Set Is24HourDate=$p(aIs24HourDateTime,",",1)
	Set Is24HourTime=$p(aIs24HourDateTime,",",2)
	
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever") //护理-发热
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	
	Set xActDate=aFromDate-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aToDate
		Quit:return>0 //退出
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
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
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-12
/// Description:  查询N天内某项目变化趋势
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID : 科室ID
///               aWarnDate : 预警日期
///               aWarnItems : 预警项目
/// Return：      返回ROWSPEC
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetCurrItemIndex("57","2020-08-13","检出同种同源多耐菌:（MRSA）耐甲氧西林的金黄色葡萄球菌|100","0")
/// w ##class(DHCHAI.IRS.CCWarningNewSrv).GetCurrItemIndex("84","2022-12-05","相同感染诊断:胸膜腔感染|7","0")
ClassMethod GetCurrItemIndex(aLocID As %String, aWarnDate As %String, aSelItem As %String, aFlag As %String) As %String
{
	New (aLocID,aWarnDate,aSelItem,aFlag)
	Set ret = ""
	Quit:(aLocID="")||(aWarnDate="")||(aSelItem="") ret
	
	Set aWarnDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aWarnDate)
	Set ZIndex=$zn,JIndex=$j,NIndex="GetCurrItemIndex"
	
	//检索条件
 	Set ItemDesc=$p(aSelItem,":",1)
 	Set WarnInfo=$p(aSelItem,":",2)
 	Set WarnDesc=$p(WarnInfo,"|",1)
 	Set WarnDays=+$p(WarnInfo,"|",2)       //图表显示N天内的人数变化
 	Set:WarnDays=0 WarnDays =7 
 	Set:WarnDays>7 WarnDays =7            //默认条件为7
 	Set FromDate=aWarnDate-(WarnDays-1)   //包含当天是7天
 	Set ToDate=aWarnDate
	
	Set NumList = ""  //输出结果		
	For xDate=FromDate:1:ToDate {
		Set num = 0
		Quit:xDate>(+$h)	

		If ItemDesc="相同感染诊断" {
			Set CurrInfAdm=..GetCurrInfAdm("",aLocID,xDate,xDate,aFlag)
			For indC=1:1:CurrInfAdm.Count() {
				Set CurrInfInfo=CurrInfAdm.GetAt(indC)
				Continue:CurrInfInfo=""
				Set xEpisodeDr = $LIST(CurrInfInfo,1)
				Set WarnLocDr = $LIST(CurrInfInfo,2)
				Set WardDate = $LIST(CurrInfInfo,4)
				Set DiagnosID = $LIST(CurrInfInfo,5)   //以感染信息ID判断唯一	
				Set InfPos = $LIST(CurrInfInfo,6)			
				Continue:xEpisodeDr=""
				Continue:(InfPos'=WarnDesc)
				//update 20221205 需求：3074768相同感染诊断调整为患者数量而不是感染诊断数量
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,InfPos))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,ItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,InfPos)=""
			}			
		} ElseIf ItemDesc="检出同种菌" {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria") //检验-检出菌
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()	
			Set BacteriaAdm=..GetBacteriaAdm("",aLocID,xDate,xDate,ItemDr,aFlag)
			For indB=1:1:BacteriaAdm.Count() {
				Set BacteriaInfo=BacteriaAdm.GetAt(indB)
				Continue:BacteriaInfo=""
				Set xEpisodeDr = $LIST(BacteriaInfo,1)
				Set WarnLocDr = $LIST(BacteriaInfo,2)
				Set WardDate = $LIST(BacteriaInfo,4)
				Set Bacteria = $LIST(BacteriaInfo,5)			
				Continue:xEpisodeDr=""
				Continue:(Bacteria'=WarnDesc)
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,Bacteria))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,ItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,Bacteria)=""
			}
		} ElseIf ItemDesc="检出同种同源多耐菌" {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria") //检验-检出菌
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()	
			Set BacteriaAdm=..GetTZTYBactAdm("",aLocID,xDate,xDate,ItemDr,aFlag)
			For indB=1:1:(BacteriaAdm.Count()-1) {
				Set BacteriaInfo=BacteriaAdm.GetAt(indB)
				Continue:BacteriaInfo=""
				Set xEpisodeDr = $LIST(BacteriaInfo,1)
				Set WarnLocDr  = $LIST(BacteriaInfo,2)
				Set WarnBedDr  = $LIST(BacteriaInfo,3)
				Set WardDate   = $LIST(BacteriaInfo,4)
				Set Bacteria   = $LIST(BacteriaInfo,5)
				Set MRBSenList = $LIST(BacteriaInfo,6)
				Set MRBCode    = $LIST(BacteriaInfo,7)			
				Continue:xEpisodeDr=""
				Continue:(Bacteria'=WarnDesc)
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,Bacteria))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,ItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc,Bacteria)=""
			}
		}ElseIf (ItemDesc="发热人数")||(ItemDesc="发热标准差") {
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever") //护理-发热
			Continue:'$IsObject(objItem) 
			Continue:objItem.CCIsActive'=1 
			Set ItemDr=objItem.%Id()				
			Set FerverAdm=..GetFerverAdm("",aLocID,xDate,xDate,ItemDr,aFlag)
			For indF=1:1:FerverAdm.Count() {
				Set FerverInfo=FerverAdm.GetAt(indF)
				Continue:FerverInfo=""
				Set xEpisodeDr = $LIST(FerverInfo,1)
				Set WarnLocDr = $LIST(FerverInfo,2)
				Set WardDate = $LIST(FerverInfo,4)			
				Continue:xEpisodeDr=""
			
				Set:('$d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc))) num=$i(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",WarnLocDr,xDate,ItemDesc))
				Set ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,xDate,ItemDesc)=""
			}
			
		}Else{}
	   
		Set num=$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",aLocID,xDate,ItemDesc))	//add
		Set:num="" num=0
		Set:NumList'="" NumList = NumList_"^"_num
		Set:NumList="" NumList = num
	}
	
	Set ret = NumList
	Kill ^TMP(ZIndex,JIndex,NIndex)
 	Quit ret
}

/// w ##class(DHCHAI.IRS.CCWarningNewSrv).QueryProcessEpisode("65979","上呼吸道感染","21")
/// 判断预警病例项目是否已经排除过，是=1 0-否 所谓的排除即1=预警日期之前同样的排除项目
ClassMethod QueryProcessEpisode(aWarnDateEp As %String, aWarnItemEp As %String, aEpisodeDr As %String) As %String
{
	New (aWarnDateEp,aWarnItemEp,aEpisodeDr)
	Set return=0
	Quit:(+aWarnDateEp=0)||(aWarnItemEp="")||(+aEpisodeDr=0) return
	//DHCHAI.IR.CCWarningActEp IndexEpisodeWarnAct
	Set xWarningActID = 0
	For {
		Set xWarningActID=$o(^DHCHAI.IR.CCWarningActEpI("IndexEpisodeWarnAct",aEpisodeDr,xWarningActID))
		Quit:xWarningActID=""
		Quit:return>0 //退出
		//排除数据如果很大取数据可考虑用global代替class
		Set objWarningAct = ##class(DHCHAI.IR.CCWarningAct).GetObjById(xWarningActID)
		Quit:'$IsObject(objWarningAct)
		Set LsWarningDate = objWarningAct.IRWarnDate
		Set LsWarningItem = objWarningAct.IRWarnItem
		Set:(LsWarningItem=aWarnItemEp)&(LsWarningDate<aWarnDateEp) return=1
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-03-07
/// Description:  查询暴发预警科室分布
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aHospIDs : 医院ID
///               aWarnDate : 预警日期
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningNewSrv","QryWarnLoc","1|2","2023-01-16")             
Query QryWarnLoc(aHospIDs As %String, aWarnDate As %String) As %Query(ROWSPEC = "LocCnt:%String") [ SqlProc ]
{
}

ClassMethod QryWarnLocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aWarnDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aWarnDate="" aWarnDate=+$h
 	Quit:(aWarnDate="") $$$OK

 	Set WarnItems=""
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
		 	Continue:Desc=""
		 	Set Arg1=obj.CCArg1
		 	Set Arg2=obj.CCArg2
		 	Set Arg3=obj.CCArg3
		 	Set Arg4=obj.CCArg4
		 	Set Arg5=obj.CCArg5
		 	If WarnItems'="" {
				Set WarnItems=WarnItems_"^"_Desc_"|"_Arg1_"|"_Arg2
			} Else {
				Set WarnItems=Desc_"|"_Arg1_"|"_Arg2
			}
	 	}
	}
	Quit:WarnItems="" $$$OK
	
	Set Is24HourFlag = ##class(DHCHAI.BT.Config).GetValByCode("CCWarningFlag","")
	If (WarnItems'="")&&(WarnItems'["入院24H内计入") {  //默认入院24h不计入，导致数据与院感暴发预警数据不一致问题
		 Set WarnItems=WarnItems_"^入院24H内计入|"_Is24HourFlag  
	}   
	       
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnLoc"
 	
 	Set flg=..QueryProcess(aWarnDate,WarnItems,aHospIDs,"","W")
 	Quit:(+flg)<1 $$$OK

 	Set LocCnt=0	 
 	//输出预警值
	Set xWarnLoc=""
	For {
		Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
		Quit:xWarnLoc=""
		
		Set InfInfo="",BacteriaInfo="",InfCnt=0,BactCnt=0,FeverCnt=0,AbFever=0,FeStandCnt=0
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
			Quit:xItemDesc=""
			
			Set ArgData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",xItemDesc))
			Continue:ArgData=""
			Set FromDate=$listget(ArgData,1)
			Set ToDate=$listget(ArgData,2)
			Set WarnCnt=$listget(ArgData,3)
			Set WarnDate=$listget(ArgData,4)
			Set WarnDays=$listget(ArgData,5)
			Set:WarnCnt=0 WarnCnt =1   //默认条件不输入为1
			Set:WarnDays=0 WarnDays =7   //默认条件不输入为7
		    
			If (xItemDesc="相同感染诊断") {
				Set xInfPos=""
				For {
					Set xInfPos=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
					Quit:xInfPos=""
					
					Set InfCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
					Continue:InfCnt<WarnCnt
					//add 20230116 已经处置（排除或确诊）的项目不再预警
					Continue:($d(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xWarnLoc,WarnDate,xInfPos)))
					
					Set InfInfo=InfInfo_"^"_xInfPos_"#"_InfCnt
				}			
				Set:InfInfo'="" InfInfo=$e(InfInfo,2,$l(InfInfo))
			}ElseIf (xItemDesc="检出同种菌") {
				Set xBacteria=""
				For {
					Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Quit:xBacteria=""
					
					Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Continue:BactCnt<WarnCnt
					//add 20230116 已经处置（排除或确诊）的项目不再预警
					Continue:($d(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xWarnLoc,WarnDate,xItemDesc)))

					Set BacteriaInfo=BacteriaInfo_"^"_xBacteria_"#"_BactCnt
				}				
				Set:BacteriaInfo'="" BacteriaInfo=$e(BacteriaInfo,2,$l(BacteriaInfo))
			}ElseIf (xItemDesc="检出同种同源多耐菌") {
				Set xBacteria=""
				For {
					Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Quit:xBacteria=""
					Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
					Continue:BactCnt<WarnCnt
					//add 20230116 已经处置（排除或确诊）的项目不再预警
					Continue:($d(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xWarnLoc,WarnDate,xItemDesc)))

					Set TZBacteriaInfo=TZBacteriaInfo_"^"_xBacteria_"#"_BactCnt
				}				
				Set:TZBacteriaInfo'="" TZBacteriaInfo=$e(TZBacteriaInfo,2,$l(TZBacteriaInfo))
			}ElseIf (xItemDesc="发热人数") {
				Set FeverCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
				Continue:FeverCnt<WarnCnt
				//add 20230116 已经处置（排除或确诊）的项目不再预警
				Continue:($d(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xWarnLoc,WarnDate,xItemDesc)))
				
				Set AbFever =1
			}ElseIf (xItemDesc="发热标准差") {
				//add 20230116 已经处置（排除或确诊）的项目不再预警
				Continue:($d(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xWarnLoc,WarnDate,xItemDesc)))
				Set FeStandCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
				Set:$e(FeStandCnt,1)="." FeStandCnt = "0"_FeStandCnt
			}Else{}
		}
		Continue:(InfInfo="")&&(BacteriaInfo="")&&(AbFever=0)&&(FeStandCnt=0)		
		Set LocCnt=LocCnt+1
	}
	
	Set ^CacheTemp(repid,ind)=$lb(LocCnt)
	Set ind=ind+1
	
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryWarnLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarnLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnLocExecute ]
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
/// CreatDate：   2021-03-11
/// Description:  获取检出菌患者送检及药敏结果列表
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCWarningNewSrv","QryWarnPatLab","29","2020-08-01","2020-08-05","0","大肠埃希菌")
Query QryWarnPatLab(aLocID As %String, aDateFrom As %String, aDateTo As %String, aFlg As %String = "0", aBact As %String = "", aMRB As %String = "", aEpisodeIDs As %String = "") As %Query(ROWSPEC = "EpisodeDr:%String,RegNo:%String,MrNo:%String,PatName:%String,WarnLocDr:%String,WarnBedDesc:%String,LabVisitNumberDr:%String,LabOrdDesc:%String,LabReportDr:%String,ResultID:%String,ActDateTime:%String,RepDateTime:%String,Specimen:%String,Bacteria:%String,MRBDesc:%String,AntSenList:%String") [ SqlProc ]
{
}

ClassMethod QryWarnPatLabExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String, aDateTo As %String, aFlg As %String = "0", aBact As %String = "", aMRB As %String = "", aEpisodeIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateTo>+$h aDateTo=+$h
	//检出菌监测项目
    Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	Quit:ItemDr="" $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryWarnPatLab"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set AntiList=""
	Set $ZT="GetBacteriaAdmErr"
    Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
	    
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",ItemDr,xActDate,xID))
			Quit:xID=""
		   
			Set ResultData=$g(^DHCHAI.IR.CCResultD(xID))
			Continue:ResultData=""
		    
		    Set EpisodeDr = $lg(ResultData,2)
		    Continue:(aEpisodeIDs'="")&((","_aEpisodeIDs_",")'[(","_EpisodeDr_","))  //过滤非预警明细列表中的患者
		    Set IsActive  = $lg(ResultData,14)
			Continue:IsActive'=1
			Set ActDate   = $lg(ResultData,8)
			Set ActTime   = $lg(ResultData,9)
			Set RepDate   = $lg(ResultData,11)
			Set RepTime   = $lg(ResultData,12)
			Set Specimen  = $lg(ResultData,22)   //原始标本名称
			Set Bacteria  = $lg(ResultData,23)
			Continue:Bacteria=""
			Set SCode = $lg(ResultData,17)
			Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			Set tmpBacteria=""
			If $IsObject(objBactMap){
				Continue:objBactMap.BTIsActive'=1
				If $IsObject(objBactMap.BTMapItemDr){
					Set tmpBacteria=objBactMap.BTMapItemDr.BTBacDesc
				}
			}
			Continue:tmpBacteria=""
			Set Bacteria=tmpBacteria
			Continue:(aBact'="")&(Bacteria'=aBact)
			Set MRBID= $lg(ResultData,24)
			Set MRBData=""
			Set:MRBID'="" MRBData=$g(^DHCHAI.IR.CRuleMRBD(MRBID))
			Set MRBDesc=$lg(MRBData,3)
			Set MRBID2= $lg(ResultData,31)
			Set MRBData2=""
			Set:MRBID2'="" MRBData2=$g(^DHCHAI.IR.CRuleMRBD(MRBID2))
			Set MRBDesc2=$lg(MRBData2,3)					
			Continue:(aMRB'="")&(aMRB'=MRBDesc)&(aMRB'=MRBDesc2)
			
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
			Continue:PAAdmData=""
			Set RegNo=$lg(PAAdmData,4)     //登记号
			Set MrNo=$lg(PAAdmData,5)        //病案号
			Set PatName=$lg(PAAdmData,6)     //姓名
			Set AdmDate=$lg(PAAdmData,20)     //就诊日期
			Set AdmTime=$lg(PAAdmData,21)     //就诊时间
	        Continue:(aFlg=0)&&(ActDate<(AdmDate+1))      // 24h内不计入
	        Continue:(aFlg=0)&&(ActDate=(AdmDate+1))&&(ActTime<AdmTime)      // 24h内不计入	        
			
			//根据异常发生时间点取科室、病区、床位信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			Continue:TransInfo=""
			Set WarnLocDr=$p(TransInfo,"^",2)
			Set WarnBedDr=$p(TransInfo,"^",3)					
			Set WarnBedDesc="",WarnXLocDr=""
			Set WarnBedInfo=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
			Set:WarnBedInfo'="" WarnBedDesc=$lg(WarnBedInfo,3)
			Set:WarnBedInfo'="" WarnXLocDr=$lg(WarnBedInfo,11)
			Set:WarnXLocDr'="" WarnLocDr=WarnXLocDr    //处理虚拟病区的问题
			Continue:(aLocID'="")&(aLocID'=WarnLocDr)  //按预警科室过滤
		    Set:(WarnBedDesc'="")&&(WarnBedDesc'["床") WarnBedDesc=WarnBedDesc_"床"

		    Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set:RepTime'="" RepTime=$zt(RepTime,1)
			
			Set ResultID = $p($lg(ResultData,19),"=",2)  //检验结果ID
		    // 送检项目
		    Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
			Continue:RepRstData=""
			Set LabReportDr      = $lg(RepRstData,2)
			Continue:LabReportDr=""
			Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
			Set OrdListDesc=""	//检验医嘱名称
			Set xTestSetDesc=""
			For {
				Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",LabVisitNumberDr,xTestSetDesc))
				Quit:xTestSetDesc=""
				Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
			}
			Set:OrdListDesc'="" OrdListDesc=$e(OrdListDesc,2,$l(OrdListDesc))
			
			Set xSenID = ""
			For {
		    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
		    	Quit:xSenID=""
				
				Set SenData = $g(^DHCHAI.DP.LabVisitRepRstSenD(xSenID))
				Continue:SenData=""
			    
				Set AntCode      = $lg(SenData,3)
				Set AntDesc      = $lg(SenData,4)
				Set Sensitivity  = $lg(SenData,5)
				If ($listfind(AntiList,AntDesc)<1) {
					Set AntiList=AntiList_$lb(AntDesc)
				}
				Set ^TMP(ZIndex,JIndex,NIndex,"AdmLabInfo",EpisodeDr,ResultID)=$lb(EpisodeDr,RegNo,MrNo,PatName,WarnLocDr,WarnBedDesc,LabVisitNumberDr,OrdListDesc,LabReportDr,ResultID,ActDate_" "_ActTime,RepDate_" "_RepTime,Specimen,Bacteria,MRBDesc)
				Set ^TMP(ZIndex,JIndex,NIndex,"AdmLabAntSen",EpisodeDr,ResultID,AntDesc)=Sensitivity
			}
		}
	}
	
	Set xEpisodeDr=""
	For {
		Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"AdmLabAntSen",xEpisodeDr))
		Quit:xEpisodeDr=""
		
		Set xResultID=""
		For {
			Set xResultID=$o(^TMP(ZIndex,JIndex,NIndex,"AdmLabAntSen",xEpisodeDr,xResultID))
			Quit:xResultID=""
			
			Set AdmLabInfo=$g(^TMP(ZIndex,JIndex,NIndex,"AdmLabInfo",xEpisodeDr,xResultID))
			Set AntSenList=""
			For indS=1:1:$ll(AntiList) {
				Set AntDesc=$lg(AntiList,indS)
				Continue:AntDesc=""
				Set Sensitivity=$g(^TMP(ZIndex,JIndex,NIndex,"AdmLabAntSen",xEpisodeDr,xResultID,AntDesc))
				Set AntSenList=AntSenList_","_AntDesc_":"_Sensitivity
			}
	
			Set:AntSenList'="" AntSenList=$e(AntSenList,2,$l(AntSenList))
			Set Data=AdmLabInfo_$lb(AntSenList)
			Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
			
		}
	}
	
 	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryWarnPatLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnPatLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarnPatLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnPatLabExecute ]
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
