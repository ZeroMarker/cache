/// 名称: DHCHAI.DI.DIO.FromLis10Srv
/// 描述: 检验数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromLis10Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询接收标本记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","QryLabVisitNumber",19787631,"2017-01-01","2017-08-15")
Query QryLabVisitNumber(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,TestSetStr:%String")
{
}

ClassMethod QryLabVisitNumberExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" $$$OK
		Set AdmStr=$g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:ArcimType'="L"
		 	
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSub=0
				For {
					Set xSub=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSub))
					Quit:xSub=""
					
					Set xEpis=$p($g(^OEORD(OrdID,"I",xSub,3)),"^",20)
					Continue:xEpis=""
					
					Set VisitNumberData=$g(^TEPI(xEpis))
					Continue:VisitNumberData=""
					Set CollDate=$p(VisitNumberData,"\",10) //采集标本时间
					Set RecDate=$p(VisitNumberData,"\",32)  //接收标本时间
					Set:RecDate="" RecDate=CollDate
					Continue:RecDate=""
					Continue:RecDate<aDateFrom
					Continue:RecDate>aDateTo
					
					Set VisitNumberDr=xEpis
					Set Data=..BuildVisitNumber(VisitNumberDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {
		//标本采集日期
		//检验号基本信息EP_VisitNumber
		//^TDAY(1,{EPVIS_DateOfCollection},{EPVIS_StatusPatient},{EPVIS_VisitNumber})
		//接收标本日期(无结果)
		//检验号基本信息EP_VisitNumber
		//^TDAY(6,{EPVIS_DateOfReceiving},{EPVIS_StatusPatient},{EPVIS_VisitNumber})
		For xDate=aDateFrom:1:aDateTo {
			Set IndexNote=$s($d(^TDAY(6,xDate)):6,1:1)
			Set xStatus=""
			For {
				Set xStatus=$o(^TDAY(IndexNote,xDate,xStatus))
				Quit:xStatus=""
				
				Set xEpis=0
				For {
					Set xEpis=$o(^TDAY(IndexNote,xDate,xStatus,xEpis))
					Quit:xEpis=""
					
					Set VisitNumberData=$g(^TEPI(xEpis))
					Continue:VisitNumberData=""
					Set EpisodeID=..GetEpisodeIDByLab(xEpis)
					Continue:EpisodeID=""
					Set AdmStr=$g(^PAADM(EpisodeID))
					Set AdmType=$p(AdmStr,"^",2)	   //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					
					Set VisitNumberDr=xEpis
					Set Data=..BuildVisitNumber(VisitNumberDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
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

/// Creator：     zhufei
/// CreatDate：   2017-08-21
/// Description:  组织Query输出标本记录
/// Input：       aVisitNumberID : 标本ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).BuildVisitNumber(2)
ClassMethod BuildVisitNumber(aVisitNumberID As %String, ByRef errMsg As %String = "") As %List
{
	New (aVisitNumberID,errMsg)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set $ZT="BuildVisitNumberErr"
	
	Set VisitNumberData=..GetVisitNumber(aVisitNumberID)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr=""
	Set TestSetInfo=..GetVisitTestSet(aVisitNumberID)
	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		If TestSetStr="" {
			Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		} Else {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		}
	}
	Quit:TestSetStr="" return
	
	Set return=$list(VisitNumberData,1,17)
	Set return=return_$lb(TestSetStr)
	Quit return
	
BuildVisitNumberErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询检验报告记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","QryLabVisitReport",19787631,"2016-08-01","2017-08-01")
Query QryLabVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
{
}

ClassMethod QryLabVisitReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" $$$OK
		Set AdmStr=$g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:ArcimType'="L"
		 	
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSub=0
				For {
					Set xSub=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSub))
					Quit:xSub=""
					
					Set xEpis=$p($g(^OEORD(OrdID,"I",xSub,3)),"^",20)
					Continue:xEpis=""
					
					Set xTS=""
					For {
						Set xTS=$o(^TEPI(xEpis,1,xTS))
						Quit:xTS=""
						
						Set xCnt=0
						For {
							Set xCnt=$o(^TEPI(xEpis,1,xTS,xCnt))
							Quit:xCnt=""
							
							Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
							Continue:ReportData=""
							Set AuthDate=$p(ReportData,"\",4)
							Continue:AuthDate=""
							Continue:AuthDate<aDateFrom
							Continue:AuthDate>aDateTo
							
							Set ReportID=xEpis_"||"_xTS_"||"_xCnt
							Set Data=..BuildVisitReport(ReportID)
							Continue:Data=""
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	} Else {
		//报告审核日期
		//检验医嘱EP_VisitTestSet
		//^TEPIi("AUTHORISED",{VISTS_DateOfAuthorisation},{EP_VisitNumber.EPVIS_VisitNumber},{VISTS_TestSet_DR},EP_VisitTestSet.VISTS_TestSetCounter})
		For xDate=aDateFrom:1:aDateTo {
			Set xEpis=0
			For {
				Set xEpis=$o(^TEPIi("AUTHORISED",xDate,xEpis))
				Quit:xEpis=""
				
				Set xTS=""
				For {
					Set xTS=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS))
					Quit:xTS=""
					
					Set xCnt=0
					For {
						Set xCnt=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS,xCnt))
						Quit:xCnt=""
						
						Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
						Continue:ReportData=""
						Set EpisodeID=..GetEpisodeIDByLab(xEpis)  // 就诊号
						Continue:EpisodeID=""
						Set AdmStr=$g(^PAADM(+EpisodeID))
						Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
						Continue:(AdmType'="I")&(AdmType'="E")
						
						Set ReportID=xEpis_"||"_xTS_"||"_xCnt
						Set Data=..BuildVisitReport(ReportID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabVisitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-08-21
/// Description:  组织Query输出检验报告
/// Input：       aReportID:检验报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).BuildVisitReport("2000000001||H1514||1")
ClassMethod BuildVisitReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildVisitReportErr"
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Quit:(Epis="")||(TS="")||(Cnt="") return
	Set VisitNumberDr=Epis
	Set ReportID=Epis_"||"_TS
	Set Order=Cnt
	
	Set ReportData=$g(^TEPI(Epis,1,TS,Cnt))
	Quit:ReportData="" return
	Set RepStatus       = $p(ReportData,"\",31)
	Quit:RepStatus'="A" return //报告未审核
	
	Set RegDate         = $p(ReportData,"\",1)
	Set RegTime         = $p(ReportData,"\",2)
	Set:$l(RegTime) RegTime=RegTime*60
	Set RegUserCode     = $p(ReportData,"\",3)
	Set RegUserDesc     = ""
	If RegUserCode'="" {
		Set RegUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(RegUserCode,"U"),0))
		Set:RegUserDr'="" RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
	}
	Set AuthDate        = $p(ReportData,"\",4)
	Set AuthTime        = $p(ReportData,"\",5)
	Set:$l(AuthTime) AuthTime=AuthTime*60
	Set AuthUserCode    = $p(ReportData,"\",6)
	Set AuthUserDesc    = ""
	If AuthUserCode'="" {
		Set AuthUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(AuthUserCode,"U"),0))
		Set:AuthUserDr'="" AuthUserDesc=$p($g(^SSU("SSUSR",AuthUserDr)),"^",2)
	}
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",ArcimCode="",ArcimDesc=""
	Set TestSetRow=aReportID
	Set TSCode=TS
	Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
	Set HISOrderID=..GetOEItemIDsByLab("",TestSetRow)
	If HISOrderID'="" {
		Set ArcimID=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),1)),"^",2)
		If ArcimID'="" {
			Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)
		}
	}
	Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
	
	Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	Set return=$lb(ReportID)
	Set return=return_$list(VisitNumberData,1,17)
	Set return=return_$lb(TestSetStr)
	Set return=return_$lb(TestSetRow)
	Set return=return_$lb(Order)
	Set return=return_$lb(RepStatus)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserName)
	Set return=return_$lb(AuthDate)
	Set return=return_$lb(AuthTime)
	Set return=return_$lb(AuthUserCode)
	Set return=return_$lb(AuthUserName)
	Quit return
	
BuildVisitReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  通过标本ID取标本信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetVisitNumber(2000000001)
ClassMethod GetVisitNumber(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set VisitNumberData=$g(^TEPI(aVisitNumberID))
	Quit:VisitNumberData="" return
	Set EpisodeNo=aVisitNumberID  // 检验号/标本号
	Set EpisodeID=..GetEpisodeIDByLab(EpisodeNo)  // 就诊号
	Quit:EpisodeID="" return
	
	Set (SpecCode,SpecDesc,CollDate,CollTime,CollUser,RecDate,RecTime,RecUser,LocCode,LocDesc,WardCode,WardDesc)=""
	Set OEItemIDs=..GetOEItemIDsByLab(EpisodeNo)
	Quit:OEItemIDs="" return
	For indOE=1:1:$l(OEItemIDs,",") {
		Set OEItemID=$p(OEItemIDs,",",indOE)
		Continue:OEItemID=""
		
		Set OrdID=$p(OEItemID,"||",1)
		Set SubID=$p(OEItemID,"||",2)
		Continue:(OrdID="")||(SubID="")
		
		//标本
		If SpecDesc="" {
			Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
			Set:SpecDr'="" SpecCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
			Set:SpecCode'="" SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
			If SpecDesc="" {
				Set SpecCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
				Set:SpecCode'="" SpecDesc=$p($g(^DHCSpS("SPS",SpecCode)),"^",2)
			}
		}
		
		//采集日期时间
		If CollDate="" {
			Set CollDateTime=..GetCollDateTime(OEItemID)
			Set CollDate=$p(CollDateTime,"^",1)
			Set CollTime=$p(CollDateTime,"^",2)
			Set CollUser=$p(CollDateTime,"^",3)
			If CollDate="" {
				Set OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OEItemID,""),-1)
				If $l(OrdExecId){
					Set CollDate=$p($g(^DHCOrdExec(OrdExecId)),"^",13)
					Set CollTime=$p($g(^DHCOrdExec(OrdExecId)),"^",14)
				}
			}
		}
		
		//接收日期时间
		If RecDate="" {
			Set RecDateTime=..GetRecDateTime(OEItemID)
			Set RecDate=$p(RecDateTime,"^",1)
			Set RecTime=$p(RecDateTime,"^",2)
			Set RecUser=$p(RecDateTime,"^",3)
			If RecDate="" {
				Set LabTestSetRow=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",35)
				If LabTestSetRow'="" {
					Set LabNo=+LabTestSetRow
					Set TS=$p(LabTestSetRow,"||",2)		//updae by liuyh 2018-03-20 bug修复
					Set TSCnt=+$p(LabTestSetRow,"||",3)
					Set RecDate=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",21)
					If $l(RecDate) Set RecDate=RecDate
					Set RecTime=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",22)
					If $l(RecTime) Set RecTime=RecTime*60
				}
			}
		}
		
		//申请科室
		If LocDesc="" {
			Set LocDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",3)
			Set:LocDr'="" LocCode=$p($g(^CTLOC(LocDr)),"^",1)
			Set:LocDr'="" LocDesc=$p($g(^CTLOC(LocDr)),"^",2)
		}
		
		//开医嘱时病人所在病区
		If WardDesc="" {
			Set WardDr=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",2)
			Set:WardDr'="" WardCode=$p($g(^CTLOC(WardDr)),"^",1)
			Set:WardDr'="" WardDesc=$p($g(^CTLOC(WardDr)),"^",2)
		}

	}
	Set CollUserCode=$p(CollUser,"|",2)
	Set CollUserName=$p(CollUser,"|",3)
	Set RecUserCode=$p(RecUser,"|",2)
	Set RecUserName=$p(RecUser,"|",3)
	
	Set return=$lb(aVisitNumberID)
	Set return=return_$lb(EpisodeID)       //就诊号
	Set return=return_$lb(EpisodeNo)       //检验号 对应医嘱表OEORI_LabEpisodeNo
	Set return=return_$lb(SpecCode)        //标本
	Set return=return_$lb(SpecDesc)
	Set return=return_$lb(LocCode)         //申请科室
	Set return=return_$lb(LocDesc)
	Set return=return_$lb(CollDate)        //采集日期
	Set return=return_$lb(CollTime)
	Set return=return_$lb(CollUserCode)    //采集用户
	Set return=return_$lb(CollUserName)
	Set return=return_$lb(RecDate)         //接收日期
	Set return=return_$lb(RecTime)
	Set return=return_$lb(RecUserCode)     //接收用户
	Set return=return_$lb(RecUserName)
	Set return=return_$lb(WardCode)        //申请病区
	Set return=return_$lb(WardDesc)
	Quit return
}

/// 取标本采集日期时间
/// OEItemID为医嘱ID
ClassMethod GetCollDateTime(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
    Set OrdXSub=$o(^OEORD(OrdID,"I",SubID,"X",0))
    Quit:OrdXSub="" return
    Set OEItemXID=OrdID_"||"_SubID_"||"_OrdXSub
    Set OrdExecID=$o(^DHCOrdExec(0,"OEOREDR",OrdID_"||"_SubID_"||"_OrdXSub,""))
    Quit:OrdExecID="" return
	
	Set (CollUserCode,CollUserDesc)=""
	Set CollUserID=$p(^DHCOrdExec(OrdExecID),"^",12)
	If CollUserID'="" {
		Set CollUserCode=$p($g(^SSU("SSUSR",CollUserID)),"^",1)
		Set CollUserDesc=$p($g(^SSU("SSUSR",CollUserID)),"^",2)
	}
	Set CollDate=$p(^DHCOrdExec(OrdExecID),"^",13)
	Set CollTime=$p(^DHCOrdExec(OrdExecID),"^",14)
	Quit:CollDate="" return
	
	Set return=CollDate_"^"_CollTime_"^"_CollUserID_"|"_CollUserCode_"|"_CollUserDesc
    Quit return
}

/// 取标本接受日期时间
/// OEItemID为医嘱ID，Flag标本状态（R）
ClassMethod GetRecDateTime(aOEItemID As %String, aFlag As %String = "R") As %String
{
	New (aOEItemID, aFlag)
	Set return=""
	Quit:(aOEItemID="")||(aFlag="") return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set RESSTID=$o(^OEC("RESST",0,"Code",aFlag,""))
	
	Set (RecDate,RecTime,RecUserID,RecUserCode,RecUserDesc)=""
	Set xRES=""
	For {
		Set xRES=$O(^OEORD(OrdID,"I",SubID,"RES",xRES))
		Quit:xRES=""
		Set Values=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",2)
		If RESSTID=Values {
			Set RecDate=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",4)
			Set RecTime=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",5)
			Set RecUserID=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",3)
			If RecUserID'="" {
				Set RecUserCode=$p($g(^SSU("SSUSR",RecUserID)),"^",1)
				Set RecUserDesc=$p($g(^SSU("SSUSR",RecUserID)),"^",2)
			}
		}
	}
	Quit:RecDate="" return
	
	Set return=RecDate_"^"_RecTime_"^"_RecUserID_"|"_RecUserCode_"|"_RecUserDesc
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-10
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetVisitTestSet(2000000001)
ClassMethod GetVisitTestSet(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:aVisitNumberID="" return
	
	Set Epis=aVisitNumberID
	Set xTS=""
	For {
		Set xTS=$o(^TEPI(Epis,1,xTS))
		Quit:xTS=""
		
		//检验医嘱
		Set TSCode=xTS
		Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
		Continue:TSDesc=""
		
		//HIS医嘱
		Set ArcimCode="",ArcimDesc=""
		Set TestSetRow=Epis_"||"_xTS_"||"_1
		Set HISOrdItemDr=..GetOEItemIDsByLab("",TestSetRow)
		If HISOrdItemDr'="" {
			Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
			If ArcimID'="" {
				Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
			}
		}
		
		Set ID=Epis_"||"_xTS
		Set WorkGroupMachineDr=""
		Set Data=$lb(ID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr)
		Set return=return_$lb(Data)
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  通过检验报告ID取检验结果接口
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetRepResult("2017263526||D0612")
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set LabRepVerExt=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVerExt")
	Set LabRepVerExt=+LabRepVerExt
	Set $ZT="GetRepResultErr"
	//调用检验组提供的接口
	/*
	Set ds = ##class(%Library.ResultSet).%New("LISService.Business.ReportResult:QryTestSetResult")
	Do ds.Execute(aReportID)
	while(ds.Next())
	{
		Set TestCode 	= ds.Data("TestCode")		//检验项目名称
		Set TCCode	 	= ds.Data("TCCode")			//检验项目代码
		Continue:(TestCode="")||(TCCode="")
		Set RstFormat 	= ds.Data("RstFormat")		//结果类型
		Set Result 		= ds.Data("Result")			//检测结果
		Set TextRes 	= ds.Data("TextRes")		//定性结果
		Set ResNoes 	= ds.Data("ResNoes")		//结果说明(备注)
		Set AbFlag 		= ds.Data("AbFlag")			//异常提示
		Set Unit 		= ds.Data("Unit")			//单位
		Set RefRanges 	= ds.Data("RefRanges")		//参考范围
		Set MDRResult 	= ds.Data("MDRResult")		//多耐结果
		Set IsActive 	= ds.Data("IsActive")		//有效标志
		Set ResultSenID = ds.Data("ResultSenID")	//药敏结果ID
		Set ResultData = ResultSenID_"^"_TestCode_"^"_TCCode_"^"_RstFormat_"^"_Result_"^"_TextRes
		_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
		Set return = return_$lb(ResultData)
	}
	Set ResultData ="检验项目名称^检验项目代码D^M^检测结果^定性结果^结果说明(备注)^异常提示^单位^参考范围^多耐结果^1^1"
	Set return = return_$lb(ResultData)
	*/
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Set:Cnt="" Cnt=$o(^TEPI(Epis,1,TS,""),-1)
	Quit:(Epis="")||(TS="") return
	
	Set xTC=""
	For {
		Set xTC=$o(^TEPI(Epis,1,TS,Cnt,"DATA",xTC))
		Quit:xTC=""
		
		Set ResultID=Epis_"||"_TS_"||"_Cnt_"||"_xTC
		Set ReportData=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC))
		Continue:ReportData=""
		Set tResult=$p(ReportData,"\",1)
		Set LabResult=..GetTestCodeResult(Epis,xTC,tResult)
		Continue:LabResult=""
		
		Set ItemCode=$p(LabResult,$c(2),1)    //检验项目代码
		Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
		Set ItemResult=$p(LabResult,$c(2),3)  //结果
		Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
		Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
		Set ItemRangs=$p(LabResult,$c(2),6)   //参考范围
		Set Synonym=$p(LabResult,$c(2),7)     //英文缩写
		Set RstFormat=$p(LabResult,$c(2),8)   //输出数据类型
		Set Comments=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"REM",1))
		Set Comments1=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"REM",0))  //增加备注取的位置
		Set:Comments1'="" Comments=Comments_Comments1
		Set Comments=$tr(Comments,"^","")
		Set WarnFlag=""    //危急值
		
		//第三方LIS同步到检验结构中,程序需特殊处理
		If LabRepVerExt>0 {
			Set tLabResult=$Get(^TEPI(Epis,1,TS,Cnt,"DATA",xTC))
			Set AbnorFlag=$p(tLabResult,"\",2)   //异常标记
			Set WarnFlag=$p(tLabResult,"\",8)    //危急值
			If '$Length(WarnFlag) Set WarnFlag="N"
			Set:ItemRangs="" ItemRangs=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"Ranges"))
			Set:ItemUnit="" ItemUnit=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"Unit"))
		}
		
		//检测“超广谱β-内酰胺酶（ESBLs）细菌”结果
		Set IsESBLs=0
		If ($zcvt(ItemDesc,"U")["ESBLS")||(ItemDesc["β-内酰胺酶")||(ItemDesc["β-Lac") {
			Set:(ItemResult["阳")||(ItemResult["+") IsESBLs=1
		}
		If ($zcvt(Comments,"U")["ESBLS")||(Comments["β-内酰胺酶")||(Comments["β-Lac") {
			Set IsESBLs=1
		}
		If ($zcvt(ItemResult,"U")["ESBL(+)") {
			Set IsESBLs=1
		}
		If (ItemDesc["难辨梭菌毒素") {
			Set:ItemResult["阳性" IsESBLs=1
		}
		If IsESBLs'=1 {
			Set xAnti=""
			For {
				Set xAnti=$o(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"ANT",xAnti))
				Quit:xAnti=""
				
				Set AntiDesc=$p($g(^TTAB("ANT",xAnti)),"\",1)
				Continue:AntiDesc=""
				
				Set SenCode=$g(^TEPI(Epis,1,TS,Cnt,"DATA",xTC,"ANT",xAnti))
				Set SenCode=$p(SenCode,"\",1)
				Set SenDesc=""
				Set:SenCode'="" SenDesc=$p(^TTAB("SENS",SenCode),"\",1)
				
				If ($zcvt(AntiDesc,"U")["ESBLS")||(AntiDesc["β-内酰胺酶")||(AntiDesc["β-Lac") {
					Set:(SenDesc["阳")||(SenDesc["+") IsESBLs=1
					Quit
				}
				If ($zcvt(AntiDesc,"U")["ESBL(+)") {
					Set IsESBLs=1
					Quit
				}
			}
		}
		Set MDRResult=$s(IsESBLs=1:"ESBLs",1:"")
		
		Set ResultData=""
		Set $p(ResultData,"^",1)=ResultID
		Set $p(ResultData,"^",2)=ItemCode    //检验项目代码
		Set $p(ResultData,"^",3)=ItemDesc    //检验项目名称
		Set $p(ResultData,"^",4)=RstFormat   //结果类型
		Set $p(ResultData,"^",5)=ItemResult	 //检测结果
		Set $p(ResultData,"^",6)=""          //定性结果
		Set $p(ResultData,"^",7)=Comments    //结果说明(备注)
		Set $p(ResultData,"^",8)=AbnorFlag	 //异常提示
		Set $p(ResultData,"^",9)=ItemUnit    //单位
		Set $p(ResultData,"^",10)=ItemRangs  //参考范围
		Set $p(ResultData,"^",11)=MDRResult  //多耐结果（是否ESBLs+）
		Set return=return_$lb(ResultData)
	}
	Quit return
	
GetRepResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  通过检验结果ID取药敏结果接口
/// Input：       aResultSenID:检验结果ID
/// Return：      药敏结果信息
/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetResultSen(61)
ClassMethod GetResultSen(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetResultSenErr"
	//调用检验组提供的接口
	/*
	Set ds = ##class(%Library.ResultSet).%New("LISService.Business.ReportResult:QryTestSetResultSen")
	Do ds.Execute(aResultID)
	while(ds.Next())
	{
		Set AntCode 	= ds.Data("AntCode")
		Set AntDesc	 	= ds.Data("AntDesc")
		Set Sensitivity = ds.Data("Sensitivity")
		Set IsActive 	= ds.Data("IsActive")
		Set ResultSenData = AntCode_"^"_AntDesc_"^"_Sensitivity_"^"_IsActive
		Set return = return_$lb(ResultSenData)
	}
	Set ResultSenData = "抗生素代码^抗生素名称^药敏结果^1"
	Set return = return_$lb(ResultSenData)
	*/
	
	Set Epis=$p(aResultID,"||",1)
	Set TS=$p(aResultID,"||",2)
	Set Cnt=$p(aResultID,"||",3)
	Set TC=$p(aResultID,"||",4)
	Quit:(Epis="")||(TS="")||(Cnt="")||(TC="") return
	
	For xCnt=Cnt:-1:1 {
		Set xAnti=""
		For {
			Set xAnti=$o(^TEPI(Epis,1,TS,xCnt,"DATA",TC,"ANT",xAnti))
			Quit:xAnti=""
			
			Set AntDesc=$p($g(^TTAB("ANT",xAnti)),"\",1)
			Continue:AntDesc=""
			
			Set AntiInfo=$g(^TEPI(Epis,1,TS,xCnt,"DATA",TC,"ANT",xAnti))
			Continue:AntiInfo=""
			Set SenCode=$p(AntiInfo,"\",1)
			Set SenDesc=""
			Set:SenCode'="" SenDesc=$p(^TTAB("SENS",SenCode),"\",1)
			
			Set ResultSenData = xAnti_"^"_AntDesc_"^"_SenDesc_"^"_1
			Set return = return_$lb(ResultSenData)
		}
		Quit:return'=""
	}
	Quit return
	
GetResultSenErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetEpisodeIDByLab(2000000001,"2000000001||H1514||1")
ClassMethod GetEpisodeIDByLab(aLabEpisodeNo As %String, aLabTestSetRow As %String = "") As %String
{
	New (aLabEpisodeNo,aLabTestSetRow)
	Set return=""
	Quit:(aLabEpisodeNo="")&(aLabTestSetRow="") return
	
	//检验号索引
	//^OEORD(0,"EpisNo",{OEORI_LabEpisodeNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	If aLabTestSetRow'="" {
		Set LabEpisodeNo=$p(aLabTestSetRow,"||",1)
	} Else {
		Set LabEpisodeNo=aLabEpisodeNo
	}
	Set OrdID=$o(^OEORD(0,"EpisNo",LabEpisodeNo,0))
	Quit:OrdID="" return
	Set return=$p($g(^OEORD(OrdID)),"^",1)
	Quit return
}

/// w ##Class(DHCHAI.DI.DIO.FromLis10Srv).GetOEItemIDsByLab(2000000001,"2000000001||H1514||1")
ClassMethod GetOEItemIDsByLab(aLabEpisodeNo As %String, aLabTestSetRow As %String = "") As %String
{
	New (aLabEpisodeNo,aLabTestSetRow)
	Set return=""
	Quit:(aLabEpisodeNo="")&(aLabTestSetRow="") return
	
	//检验号索引
	//^OEORD(0,"EpisNo",{OEORI_LabEpisodeNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	If aLabTestSetRow'="" {
		Set LabEpisodeNo=$p(aLabTestSetRow,"||",1)
	} Else {
		Set LabEpisodeNo=aLabEpisodeNo
	}
	
	Set xOrdID=0
	For {
		Set xOrdID=$o(^OEORD(0,"EpisNo",LabEpisodeNo,xOrdID))
		Quit:xOrdID=""
		Quit:(aLabTestSetRow'="")&(return'="")
		
		Set xSub=0
		For {
			Set xSub=$o(^OEORD(0,"EpisNo",LabEpisodeNo,xOrdID,xSub))
			Quit:xSub=""
			Quit:(aLabTestSetRow'="")&(return'="")
			
			If $p(aLabTestSetRow,"||",2)'="" {
				Set LabTestSetRow=$p($g(^OEORD(xOrdID,"I",xSub,3)),"^",35)
				Continue:$p(LabTestSetRow,"||",2)'=$p(aLabTestSetRow,"||",2)
			}
			
			Set return=return_","_xOrdID_"||"_xSub
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
ClassMethod GetTestCodeResult(LabNo As %String, TC As %String, Result As %String) As %String
{
	New (LabNo,TC,Result)
	Set return=""
	Quit:TC="" return
	Quit:'$d(^TTAB("TC",TC)) return
	
	Set ItemName=$p(^TTAB("TC",TC),"\",1)        //项目名称
	Set ItemDate=$p(^TEPI(LabNo),"\",10)
	Set Synonym=$p(^TTAB("TC",TC),"\",12)        //英文缩写
	Set ItemUnits=..GetTCUnitByDate(TC,ItemDate) //项目单位
	Set ItemType=$p(^TTAB("TC",TC),"\",3)        //输出数据类型
	Set ItemResult=Result
	If ItemType="V" {         //微生物 Micro Pathogen||V
		If ItemResult'="" {
			set xItemResult=ItemResult
			set xItemResult=$ZCVT($g(xItemResult),"U")
			set xItemResult=$tr(xItemResult," ","")
			Set:$d(^TTAB("BUG",xItemResult)) ItemResult=$p($g(^TTAB("BUG",xItemResult)),"\",1)
		}
	}
	If ItemType["N" {         //??
		Set Decimal=$e(ItemType,2)
		Set:Decimal="" Decimal="0"
		Set ItemResult=$$CheckResDecimal(ItemResult,Decimal)
	}
	If ItemType["S" {         //Standard Comment标准意见
		If ItemResult'="" {
			Set:$d(^TTAB("TC",TC,2,ItemResult,1)) ItemResult=$p($g(^TTAB("TC",TC,2,ItemResult,1)),"\",1)
		}
	}
	If ItemType="B2" {        //血型结果
		If ItemResult'="" {
			Set:$d(^TTAB("BB-BG",ItemResult)) ItemResult=$p($g(^TTAB("BB-BG",ItemResult)),"\",1)
		}
	}
	
	Set ResFlag=..GetAbnorFlag(TC ,ItemResult)  //异常标志
	Set RefRanges=..GetTCRanges(TC)             //参考范围
	Set RefRanges=$tr(RefRanges,$C(1),"~")      //参考范围高低值之间用“~”分隔
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(TC)
	
	//异常标志特殊字符处理
	Set ResFlag=$tr(ResFlag,$c(28),"")
	
	Set $p(return,$c(2),1)=TC
	Set $p(return,$c(2),2)=ItemName
	Set $p(return,$c(2),3)=$tr(ItemResult,$c(13,10),"")
	Set $p(return,$c(2),4)=ItemUnits
	Set $p(return,$c(2),5)=ResFlag
	Set $p(return,$c(2),6)=RefRanges
	Set $p(return,$c(2),7)=Synonym
	Set $p(return,$c(2),8)=ItemType
	
	//特殊不可见字符处理
	Set return=$tr(return,$c(0),"")
	Set return=$tr(return,$c(1),"")
	Set return=$tr(return,$c(10),"")
	Set return=$tr(return,$c(13),"")
	Quit return
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
 ...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 ...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 ...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 ...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 ...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 ...i $l($p(^(x),"\",25)),'$l(age) q
 ...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 ...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 ...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 ...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
   s Scopy=""
   i '$l(date) s date=+$h
   i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   i $l(date) d
   .s num=1
   .s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   ..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   ...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// 获得检验项目的类别
/// [Previously private]
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=^ARC("IC",ItemCatId) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// 获得检验项目的名称
/// [Previously private]
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// 获得医嘱项目对应的检验医嘱关联代码TestSetCode
/// [Previously private]
ClassMethod GetExtTestSetCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	
	Set TestSetCode=""
	Set chl=""
	For {
		Set chl=$o(^ARCIM(ItemId,ItemSub,"EXT",chl))
		Quit:chl=""
		Set DateTo=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",2)
		Set DateFrom=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",1)
		Quit:(DateFrom'="")&(DateFrom>+$h)
		Quit:(DateTo'="")&(DateTo<+$h)
		Set TestSetCode=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",4)
	}
	Quit TestSetCode
}

/// 根据标本代码获取标本名称描述
/// [Previously private]
ClassMethod GetSpecimenDesc(SpecCode As %String) As %String
{
	S SpecDesc=""
	Q:'$l(SpecCode) SpecDesc
	S DataFlag=$D(^TTAB("SPEC",SpecCode))
	Q:(DataFlag'=1)&(DataFlag'=11) SpecDesc
	S SpeData=^TTAB("SPEC",SpecCode)
	S SpecDesc=$P(SpeData,"\",1)
	Q SpecDesc
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验抗生素字典
/// Table：        CT_Antibiotics
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","GetLisAntiDic")
Query GetLisAntiDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisAntiDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=""
 	For {
		Set xID=$o(^TTAB("ANT",xID))
		Quit:xID=""
		
		Set AntCode=xID
		Set AntDesc=$p($g(^TTAB("ANT",xID)),"\",1)
		Set IsActive=$p($g(^TTAB("ANT",xID)),"\",4)
		Set IsActive=$s(IsActive="Y":1,1:0)
		Continue:(AntCode="")||(AntDesc="")
		
		set Data=$lb(xID,AntCode,AntDesc,IsActive)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetLisAntiDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisAntiDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLisAntiDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisAntiDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验细菌字典
/// Table：        CT_Bugs
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","GetLisBactDic")
Query GetLisBactDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisBactDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=""
 	For {
		Set xID=$o(^TTAB("BUG",xID))
		Quit:xID=""
		
		Set BactCode=xID
		Set BactDesc=$p($g(^TTAB("BUG",xID)),"\",1)
		Set IsActive=$p($g(^TTAB("BUG",xID)),"\",11)
		Set IsActive=$s(IsActive'="N":1,1:0)
		Continue:(BactCode="")||(BactDesc="")
		
		set Data=$lb(xID,BactCode,BactDesc,IsActive)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetLisBactDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisBactDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLisBactDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisBactDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验标本字典
/// Table：        CT_Specimen
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","GetLisSpecDic")
Query GetLisSpecDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisSpecDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=""
 	For {
		Set xID=$o(^TTAB("SPEC",xID))
		Quit:xID=""
		
		Set SpecCode=xID
		Set SpecDesc=$p($g(^TTAB("SPEC",xID)),"\",1)
		Set IsActive=$p($g(^TTAB("SPEC",xID)),"\",3)
		Set IsActive=$s(IsActive="Y":1,1:0)
		Continue:(SpecCode="")||(SpecDesc="")
		
		set Data=$lb(xID,SpecCode,SpecDesc,IsActive)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetLisSpecDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisSpecDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLisSpecDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisSpecDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验项目字典
/// Table：        CT_TestCode
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","GetLisTestCodeDic")
Query GetLisTestCodeDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,RstFormat:%String,IsActive:%String,TSDescStr:%String")
{
}

ClassMethod GetLisTestCodeDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=""
 	For {
		Set xID=$o(^TTAB("TC",xID))
		Quit:xID=""
		
		Set TCCode=xID
		Set TCDesc=$p($g(^TTAB("TC",xID)),"\",1)
		Set RstFormat=$p($g(^TTAB("TC",xID)),"\",3)
		Set IsActive=$p($g(^TTAB("TC",xID)),"\",19)
		Set IsActive=$s(IsActive="Y":1,1:0)
		Continue:(TCCode="")||(TCDesc="")
		
		Set TSDescList="",TSDescStr=""
		Set xTSID=0
		For {
			Set xTSID=$o(^TTAB("TC",xID,1,xTSID))
			Quit:xTSID=""
			
			Set TSCode=xTSID
			Set TSDesc=$p($g(^TTAB("TS",xTSID)),"\",1)
			Continue:TSDesc=""
			Set tIsActive=$p($g(^TTAB("TS",xTSID)),"\",12)
			Set tIsActive=$s(tIsActive="Y":1,1:0)
			Continue:tIsActive'=1
			Continue:$listfind(TSDescList,TSDesc)>0
			Set TSDescList=TSDescList_$lb(TSDesc)
			If TSDescStr'="" {
				Set TSDescStr=TSDescStr_"!!"_TSDesc
			} Else {
				Set TSDescStr=TSDesc
			}
		}
		Continue:TSDescList=""
		
		set Data=$lb(xID,TCCode,TCDesc,RstFormat,IsActive,TSDescStr)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetLisTestCodeDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisTestCodeDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLisTestCodeDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisTestCodeDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验标本字典
/// Table：        CT_TestSet、ARC_ItemExternalCodes
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","GetLisTestSetDic")
Query GetLisTestSetDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,TSHISCode:%String,ArcimCode:%String,ArcimDesc:%String")
{
}

ClassMethod GetLisTestSetDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=""
 	For {
		Set xID=$o(^TTAB("TS",xID))
		Quit:xID=""
		
		Set TSCode=xID
		Set TSDesc=$p($g(^TTAB("TS",xID)),"\",1)
		Set TSHISCode=TSCode
		Set IsActive=$p($g(^TTAB("TS",xID)),"\",12)
		Set IsActive=$s(IsActive="Y":1,1:0)
		Continue:(TSCode="")||(TSDesc="")
		
		Set ArcimID="",ArcimCode="",ArcimDesc=""
		Set tTSHISCode=$$ALPHAUP^SSUTIL4(TSHISCode)
		If tTSHISCode'="" {
			Set ArcimID=$o(^ARCIM(0,"ExtCode",tTSHISCode,""),-1)
			If ArcimID'="" {
				Set ArcimID=ArcimID_"||1"
				Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
			}
		}
		
		set Data=$lb(xID,TSCode,TSDesc,IsActive,TSHISCode,ArcimCode,ArcimDesc)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetLisTestSetDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisTestSetDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLisTestSetDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisTestSetDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2018-07-09
/// Description:  根据标本号同步检验标本病区数据
/// 			  aEpisodeNo：检验号/标本号
///               DHCHAI.DP.LabVisitNumber
/// Return：      DHCHAI.DP.LabVisitNumber.ID
/// w ##class(DHCHAI.DI.DIO.FromLis10Srv).SyncVisitNumber("LIS01","1000000769")
ClassMethod SyncVisitNumber(aSCode As %String, aEpisodeNo As %String) As %String
{
	New (aSCode,aEpisodeNo)
	Set return=0
	Quit:(aSCode="")||(aEpisodeNo="") return
	Set $ZT="SyncVisitNumberErr"
	
	Set EpisodeID=..GetEpisodeIDByLab(aEpisodeNo)  // 就诊号
	Quit:EpisodeID="" return
	
	Set (WardDr,WardCode,WardDesc,RecDate,RecTime)=""
	Set xOrdID=0
	For {
		Set xOrdID=$o(^OEORD(0,"EpisNo",aEpisodeNo,xOrdID))
		Quit:xOrdID=""
	
		Set xSubID=0
		For {
			Set xSubID=$o(^OEORD(0,"EpisNo",aEpisodeNo,xOrdID,xSubID))
			Quit:xSubID=""
			
			Set OEItemID=xOrdID_"||"_xSubID
			
			//接收日期时间
			If RecDate="" {
				Set RecDateTime=..GetRecDateTime(OEItemID)
				Set RecDate=$p(RecDateTime,"^",1)
				Set RecTime=$p(RecDateTime,"^",2)
				Set RecUser=$p(RecDateTime,"^",3)
				If RecDate="" {
					Set LabTestSetRow=$p($g(^OEORD(xOrdID,"I",xSubID,3)),"^",35)
					If LabTestSetRow'="" {
						Set LabNo=+LabTestSetRow
						Set TS=$p(LabTestSetRow,"||",2)		//updae by liuyh 2018-03-20 bug修复
						Set TSCnt=+$p(LabTestSetRow,"||",3)
						Set RecDate=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",21)
						If $l(RecDate) Set RecDate=RecDate
						Set RecTime=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",22)
						If $l(RecTime) Set RecTime=RecTime*60
					}
				}
			}
			
			Set LocDr=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",3)
			Set WardDr=$p($g(^OEORD(xOrdID,"I",xSubID,9)),"^",2)
			Set:WardDr'="" WardCode = $p($g(^CTLOC(WardDr)),"^",1)
		    Set:WardDr'="" WardDesc = $p($g(^CTLOC(WardDr)),"^",2)
			Set objWard = ##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,WardCode)
		}
	}
		
	Set xID =$o(^DHCHAI.DP.LabVisitNumberI("IndexLabEpisodeNo",aEpisodeNo,"")) 
	Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(xID)
	Quit:'$IsObject(obj) return
	If '$IsObject(objWard){
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,RecDate,RecTime)
		Set WardDr =$p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
	}
	
	Set obj.LabWardDr=objWard
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
SyncVisitNumberErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-07
/// Description:  查询接收标本记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10Srv","QryLabVisitReportN",19787631)
Query QryLabVisitReportN(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
{
}

ClassMethod QryLabVisitReportNExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ReportID=xEpis_"||"_xTS_"||"_xCnt
	Set Data=..BuildVisitReport(aReportID)
	Quit:Data="" $$$OK
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryLabVisitReportNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitReportNExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitReportNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitReportNExecute ]
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
/// CreatDate：   2018-08-14
/// Description:  查询检验报告记录(仅微生物送检，多重耐药菌监控使用)
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aDateFrom  ：审核开始日期
///               aDateTo    ：审核截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLis10PumchSrv","QryGermVisitReport","","2018-08-14","2018-08-14")
Query QryGermVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
{
}

ClassMethod QryGermVisitReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'=""{
		
	} Else {
		//报告审核日期
		//检验医嘱EP_VisitTestSet
		//^TEPIi("AUTHORISED",{VISTS_DateOfAuthorisation},{EP_VisitNumber.EPVIS_VisitNumber},{VISTS_TestSet_DR},EP_VisitTestSet.VISTS_TestSetCounter})
		For xDate=aDateFrom:1:aDateTo {
			Set xEpis=0
			For {
				Set xEpis=$o(^TEPIi("AUTHORISED",xDate,xEpis))
				Quit:xEpis=""
				
				Set EpisodeID=##class(DHCHAI.DI.DIO.FromLis10Srv).GetEpisodeIDByLab(xEpis)  // 就诊号
				Continue:EpisodeID=""
				Set AdmStr=$g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
				Continue:(AdmType'="I")&(AdmType'="E")
				
				Set xTS=""
				For {
					Set xTS=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS))
					Quit:xTS=""
					
					Set xCnt=0
					For {
						Set xCnt=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS,xCnt))
						Quit:xCnt=""
						
						Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
						Continue:ReportData=""
						
						Set ReportID=xEpis_"||"_xTS_"||"_xCnt
						Set Data=..BuildGermVisitReport(ReportID)
						
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryGermVisitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGermVisitReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryGermVisitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGermVisitReportExecute ]
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
/// CreatDate：   2018-08-14
/// Description:  组织Query输出检验报告(仅微生物送检，多耐监控使用)
/// Input：       aReportID:检验报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromLis10PumchSrv).BuildGermVisitReport("2000000001||H1514||1")
ClassMethod BuildGermVisitReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildGermVisitReportErr"
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Quit:(Epis="")||(TS="")||(Cnt="") return
	Set VisitNumberDr=Epis
	Set ReportID=Epis_"||"_TS
	Set Order=Cnt
	
	Set ReportData=$g(^TEPI(Epis,1,TS,Cnt))
	Quit:ReportData="" return
	Set RepStatus       = $p(ReportData,"\",31)
	Quit:RepStatus'="A" return //报告未审核
	
	//取检验医嘱
	Set TestSetStr="",ArcimCode="",ArcimDesc=""
	Set TestSetRow=aReportID
	Set TSCode=TS
	Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
	//过滤非微生物送检 update mayanpeng 2018-08-14
	Set MapItem=##class("DHCHAI.DPS.LabTestSetSrv").GetMapItemByTestSet("LIS01",TSDesc)
	Quit:MapItem="" return
	Set MapItemCode=$p(MapItem,"^",2)
	Quit:MapItemCode'="1" return //检验医嘱标准字典 细菌检测 的code为1
	//取HIS医嘱
	Set HISOrderID=##class(DHCHAI.DI.DIO.FromLis10Srv).GetOEItemIDsByLab("",TestSetRow)
	If HISOrderID'="" {
		Set ArcimID=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),1)),"^",2)
		If ArcimID'="" {
			Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2) //医嘱子项名称
		}
	}
	Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
	
	Set RegDate         = $p(ReportData,"\",1)
	Set RegTime         = $p(ReportData,"\",2)
	Set:$l(RegTime) RegTime=RegTime*60
	Set RegUserCode     = $p(ReportData,"\",3)
	Set RegUserDesc     = ""
	If RegUserCode'="" {
		Set RegUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(RegUserCode,"U"),0))
		Set:RegUserDr'="" RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
	}
	Set AuthDate        = $p(ReportData,"\",4)
	Set AuthTime        = $p(ReportData,"\",5)
	Set:$l(AuthTime) AuthTime=AuthTime*60
	Set AuthUserCode    = $p(ReportData,"\",6)
	Set AuthUserDesc    = ""
	If AuthUserCode'="" {
		Set AuthUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(AuthUserCode,"U"),0))
		Set:AuthUserDr'="" AuthUserDesc=$p($g(^SSU("SSUSR",AuthUserDr)),"^",2)
	}
	
	
	Set VisitNumberData=##class(DHCHAI.DI.DIO.FromLis10Srv).GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<15 return
	
	Set return=$lb(ReportID)
	Set return=return_$list(VisitNumberData,1,15)
	Set return=return_$lb(TestSetStr)
	Set return=return_$lb(TestSetRow)
	Set return=return_$lb(Order)
	Set return=return_$lb(RepStatus)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserName)
	Set return=return_$lb(AuthDate)
	Set return=return_$lb(AuthTime)
	Set return=return_$lb(AuthUserCode)
	Set return=return_$lb(AuthUserName)
	Quit return
	
BuildGermVisitReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
