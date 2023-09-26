/// 名称: DHCMA.Util.IO.SyncLis2Srv
/// 描述: LIS(v2.0)提供接口服务
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.IO.SyncLis2Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验项目字典
/// Table：        dbo.BTTestCode
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","GetLisTestCodeDic","")
Query GetLisTestCodeDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,RstFormat:%String,IsActive:%String,TSStr:%String")
{
}

ClassMethod GetLisTestCodeDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildTCDicData(aID)
	} Else {
	 	Set xID=0
	 	For {
			Set xID=$o(^dbo.BTTestCodeD(xID))
			Quit:xID=""
			
			Do BuildTCDicData(xID)
	 	}
	}
	Quit $$$OK
 	
BuildTCDicData(xID)
	Set TestCodeData=$g(^dbo.BTTestCodeD(xID))
	Set TCCode=$lg(TestCodeData,2)
	Set TCDesc=$lg(TestCodeData,3)
	Set RstFormat=$lg(TestCodeData,9)
	Set IsActive=$lg(TestCodeData,25)
	Quit:(TCCode="")||(TCDesc="")
	
	Set TSStr=""
	Set xTSID=0
	For {
		Set xTSID=$o(^dbo.BTTestSetLayoutI("IndexTestCode",xID,xTSID))
		Quit:xTSID=""
		
		Set TestSetData=$g(^dbo.BTTestSetD(xTSID))
		Set TSCode=$lg(TestSetData,2)
		Set TSDesc=$lg(TestSetData,3)
		Continue:TSDesc=""
		Set TSStr=TSStr_"^"_xTSID
	}
	Set:TSStr'="" TSStr=$e(TSStr,2,$l(TSStr))
	
	set Data=$lb(xID,TCCode,TCDesc,RstFormat,IsActive,TSStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
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
/// Table：        dbo.BTTestSet、dbo.BTTestSetLayout、ARC_ItemExternalCodes
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","GetLisTestSetDic","")
Query GetLisTestSetDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,TSHISCode:%String,ArcimCode:%String,ArcimDesc:%String,TCStr:%String")
{
}

ClassMethod GetLisTestSetDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildTSDicData(aID)
	} Else {
	 	Set xID=0
	 	For {
			Set xID=$o(^dbo.BTTestSetD(xID))
			Quit:xID=""
			
			Do BuildTSDicData(xID)
	 	}
	}
	Quit $$$OK
 	
BuildTSDicData(xID)
	Set TestSetData=$g(^dbo.BTTestSetD(xID))
	Set TSCode=$lg(TestSetData,2)
	Set TSDesc=$lg(TestSetData,3)
	Set TSHISCode=$lg(TestSetData,7)
	Set:TSHISCode="" TSHISCode=TSCode
	Set IsActive=$lg(TestSetData,18)
	Quit:(TSCode="")||(TSDesc="")
	
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
	
	Set TCStr=""
	Set xWordGroupDr=0
	For {
		Set xWordGroupDr=$o(^dbo.BTTestSetLayoutI("IndexMaster",xID,xWordGroupDr))
		Quit:xWordGroupDr=""
		
		Set xTCID=0
		For {
			Set xTCID=$o(^dbo.BTTestSetLayoutI("IndexMaster",xID,xWordGroupDr,xTCID))
			Quit:xTCID=""
			
			Set TestCodeData=$g(^dbo.BTTestCodeD(xTCID))
			Set TCCode=$lg(TestCodeData,2)
			Set TCDesc=$lg(TestCodeData,3)
			Continue:TCDesc=""
			Set TCStr=TCStr_"^"_xTCID
		}
	}
	Set:TCStr'="" TCStr=$e(TCStr,2,$l(TCStr))
	
	set Data=$lb(xID,TSCode,TSDesc,IsActive,TSHISCode,ArcimCode,ArcimDesc,TCStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
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

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验标本字典
/// Table：        dbo.BTSpecimen
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","GetLisSpecDic","")
Query GetLisSpecDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisSpecDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildSpecDicData(aID)
	} Else {
	 	Set xID=0
	 	For {
			Set xID=$o(^dbo.BTSpecimenD(xID))
			Quit:xID=""
			
			Do BuildSpecDicData(xID)
	 	}
	}
	Quit $$$OK
 	
BuildSpecDicData(xID)
	Set SpecimenData=$g(^dbo.BTSpecimenD(xID))
	Set SpecCode=$lg(SpecimenData,2)
	Set SpecDesc=$lg(SpecimenData,3)
	Set IsActive=$lg(SpecimenData,11)
	Quit:(SpecCode="")||(SpecDesc="")
	
	set Data=$lb(xID,SpecCode,SpecDesc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
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

/// Creator：     pylian
/// CreatDate：   2019-02-01
/// Description:  查询接收标本记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","QryLabVisitNumber","53442486","2019-03-15","2019-04-18")
Query QryLabVisitNumber(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String")
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
		Set xReqDate=""
		For {
			Set xReqDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate))
			Quit:xReqDate=""
			
			Set xID=0
			For {
				Set xID=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate,xID))
				Quit:xID=""
				
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(xID))
				Continue:VisitNumberData=""
				Set RecDate=$listget(VisitNumberData,66)  //接收日期
				Continue:RecDate=""
				Set RecDate=$zdh(RecDate,8)
				Continue:RecDate<aDateFrom
				Continue:RecDate>aDateTo
				
				Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
				Continue:EpisodeID=""
				
				Set Data=..BuildVisitNumber(xID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} Else {
		Set xRecHospDr=""
		For {
			Set xRecHospDr=$o(^dbo.RPVisitNumberI("IndexReceiveDate",xRecHospDr))
			Quit:xRecHospDr=""
			
			For xDate=aDateFrom:1:aDateTo {
				Set xRecDate=$zd(xDate,8)
				Set xID=0
				For {
					Set xID=$o(^dbo.RPVisitNumberI("IndexReceiveDate",xRecHospDr,xRecDate,xID))
					Quit:xID=""
					
					Set VisitNumberData=$g(^dbo.RPVisitNumberD(xID))
					Continue:VisitNumberData=""
					Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
					Continue:EpisodeID=""
					
					Set Data=..BuildVisitNumber(xID)
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
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).BuildVisitNumber(7623304)
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
		Set OEOrdItemID=$listget(tData,7)
		If TestSetStr="" {
			Set TestSetStr=TSCode_"#"_TSDesc_"#"_OEOrdItemID_"#"_ArcimCode_"#"_ArcimDesc
		} Else {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"#"_TSDesc_"#"_OEOrdItemID_"#"_ArcimCode_"#"_ArcimDesc
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
/// Description:  通过标本ID取标本信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).GetVisitNumber(40110)
ClassMethod GetVisitNumber(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set VisitNumberData=$g(^dbo.RPVisitNumberD(aVisitNumberID))
	Quit:VisitNumberData="" return
	Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
	Quit:EpisodeID="" return
	
	Set EpisodeNo=$listget(VisitNumberData,2)		// 检验号/标本号
	Set (SpecimenCode,SpecimenDesc)=""
	Set SpecimenDr=$listget(VisitNumberData,56)		// 标本
	Set:SpecimenDr'="" SpecimenCode=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),2)
	Set:SpecimenDr'="" SpecimenDesc=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),3) //修改新版检验同步不到标本等问题
	Quit:SpecimenDesc="" return
	Set (LocationID,LocationDesc)=""
	Set LocationDr=$listget(VisitNumberData,22)		// 科室
	Set:LocationDr'="" LocationID=$listget($g(^dbo.BTLocationD(LocationDr)),5)
	Set:LocationDr'="" LocationDesc=$listget($g(^dbo.BTLocationD(LocationDr)),3)
	//检验BT_Location有部分数据Code与HISCode的存储是反的, 8.3标准版科室HISCode由存储CT_LOC的CTLOC_Code改CTLOC_RowID
	//处理8.3以下版本问题 
	If (LocationID'="")&&($d(^CTLOC(0,"Code",$zcvt(LocationID,"U")))) {
		Set LocationID=$O(^CTLOC(0,"Code",$zcvt(LocationID,"U"),0))
	}
	Set CollDate=$listget(VisitNumberData,51)		// 采集日期
	Set:CollDate'="" CollDate=$zdh(CollDate,8)
	Set CollTime=$listget(VisitNumberData,52)		// 采集时间
	Set CollUserDr=$listget(VisitNumberData,53)		// 采集人
	Set (CollUserCode,CollUserName)=""
	Set:CollUserDr'="" CollUserName=$listget($g(^dbo.SYSUserD(CollUserDr)),3)
	Set:CollUserDr'="" CollUserCode=$listget($g(^dbo.SYSUserD(CollUserDr)),2)
	Set RecDate=$listget(VisitNumberData,66)		// 接受日期
	Set:RecDate'="" RecDate=$zdh(RecDate,8)
	Set RecTime=$listget(VisitNumberData,67)		// 接受时间
	Set RecUserDr=$listget(VisitNumberData,68)		// 接受人
	Set (RecUserCode,RecUserName)=""
	Set:RecUserDr'="" RecUserName=$listget($g(^dbo.SYSUserD(RecUserDr)),3)
	Set:RecUserDr'="" RecUserCode=$listget($g(^dbo.SYSUserD(RecUserDr)),2)
	
	Set (WardID,WardDesc)=""
	Set WardDr=$listget(VisitNumberData,26)		   // 病区
	Set:WardDr'="" WardID=$listget($g(^dbo.BTWardD(WardDr)),4)  //病区HISCode
	Set:WardDr'="" WardDesc=$listget($g(^dbo.BTWardD(WardDr)),3)
	
	//检验BT_Ward有部分数据Code与HISCode的存储是反的, 8.3标准版病区HISCode由存储PAC_Ward的WARD_Code改WARD_RowID
	//处理8.3以下版本问题 
	If (WardID'="")&&($d(^PAWARD(0,"WARD_Code",$zcvt(WardID,"U")))) {
		Set WardID=$O(^PAWARD(0,"WARD_Code",$zcvt(WardID,"U"),0))
	}	
	Set return=$lb(aVisitNumberID)
	Set return=return_$lb(EpisodeID)       //就诊号
	Set return=return_$lb(EpisodeNo)       //检验号 对应医嘱表OEORI_LabEpisodeNo
	Set return=return_$lb(SpecimenCode)    //标本
	Set return=return_$lb(SpecimenDesc)
	Set return=return_$lb(LocationID)    //申请科室
	Set return=return_$lb(LocationDesc)
	Set return=return_$lb(CollDate)        //采集日期
	Set return=return_$lb(CollTime)
	Set return=return_$lb(CollUserCode)    //采集用户
	Set return=return_$lb(CollUserName)
	Set return=return_$lb(RecDate)         //接收日期
	Set return=return_$lb(RecTime)
	Set return=return_$lb(RecUserCode)     //接收用户
	Set return=return_$lb(RecUserName)
	Set return=return_$lb(WardID)        //申请病区
	Set return=return_$lb(WardDesc)

	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询检验报告记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","QryLabVisitReport","53322996","2019-03-19","2019-03-25")
Query QryLabVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
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
		Set xReqDate=""
		For {
			Set xReqDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate))
			Quit:xReqDate=""
			
			Set xVisitNumberDr=0
			For {
				Set xVisitNumberDr=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate,xVisitNumberDr))
				Quit:xVisitNumberDr=""
				
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(xVisitNumberDr))
				Continue:VisitNumberData=""
				Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
				Continue:EpisodeID=""
				Set AdmStr = $g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
				Continue:(AdmType'="I")&(AdmType'="E")&(AdmType'="O")
				
				Set xWorkGrpMachDr=""
				For {
					Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr))
					Quit:xWorkGrpMachDr=""
					
					Set xOrderNo=0
					For {
						Set xOrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo))
						Quit:xOrderNo=""
						
						Set xReportDr=0
						For {
							Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo,xReportDr))
							Quit:xReportDr=""
							
							Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
							Continue:ReportData=""
							Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
							Continue:VisitNumberDr=""
							Set AuthDate=$lg(ReportData,19)		       //审核日期
							Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
							Set ReAuthDate=$lg(ReportData,23)		   //复审日期
							Set:ReAuthDate'="" ReAuthDate=$zdh(ReAuthDate,8)
							
							Set IsAct=0
							If (AuthDate'="")&(AuthDate>=aDateFrom)&(AuthDate<=aDateTo) {
								Set IsAct=1
							}
							If (ReAuthDate'="")&(ReAuthDate>=aDateFrom)&(ReAuthDate<=aDateTo) {
								Set IsAct=1
							}
							Continue:IsAct<1
							
							Set Data=..BuildVisitReport(xReportDr)
							Continue:Data=""
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	} Else {
		// 新审核
		Set xWorkGrpMachDr=""
		For {
			Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGrpMachDr))
			Quit:xWorkGrpMachDr=""
			
			For xDate=aDateFrom:1:aDateTo {
				Set xAuthDate=$zd(xDate,8)
				Set xReportDr=""
				For {
					Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGrpMachDr,xAuthDate,xReportDr))
					Quit:xReportDr=""
					
					Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
					Continue:ReportData=""
					Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
					Continue:VisitNumberDr=""
					Set VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDr))
					Continue:VisitNumberData=""
					Set EpisodeID=$listget(VisitNumberData,5)  // 就诊号
					Continue:EpisodeID=""
					Set AdmStr=$g(^PAADM(+EpisodeID))
					Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					
					Set Data=..BuildVisitReport(xReportDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
		// 重新审核
		Set xWorkGrpMachDr=""
		For {
			Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexReAuthDate",xWorkGrpMachDr))
			Quit:xWorkGrpMachDr=""
			
			For xDate=aDateFrom:1:aDateTo{
				Set xReAuthDate=$zd(xDate,8)
				Set xReportDr=""
				For {
					Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexReAuthDate",xWorkGrpMachDr,xReAuthDate,xReportDr))
					Quit:xReportDr=""
					
					Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
					Continue:ReportData=""
					Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
					Continue:VisitNumberDr=""
					Set VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDr))
					Continue:VisitNumberData=""
					Set EpisodeID=$listget(VisitNumberData,5)  // 就诊号
					Continue:EpisodeID=""
					Set AdmStr=$g(^PAADM(+EpisodeID))
					Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					
					Set Data=..BuildVisitReport(xReportDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
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
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).BuildVisitReport(5388280)
ClassMethod BuildVisitReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildVisitReportErr"
	
	Set ReportData=$g(^dbo.RPVisitNumberReportD(aReportID))
	Quit:ReportData="" return
	Set VisitNumberDr=$lg(ReportData,2)			//标本ID
	Quit:VisitNumberDr="" return
	
	Set WorkGrpMachDr   = $lg(ReportData,4)			//WorkGroupMachineDR
	Set Order			= $lg(ReportData,5)			//报告序号
	Set TestSetRow		= ""						//医嘱表OEORI_LabTestSetRow字段
	Set RepStatus  		= $lg(ReportData,22)		//状态
	Set RegDate 		= $lg(ReportData,16)		//录入日期
	Set:RegDate'="" RegDate=$zdh(RegDate,8)
	Set RegTime 		= $lg(ReportData,17)		//录入时间
	Set RegUserDr		= $lg(ReportData,18)		//录入人
	Set (RegUserCode,RegUserName)=""
	Set:RegUserDr'="" RegUserName=$listget($g(^dbo.SYSUserD(RegUserDr)),3)
	Set:RegUserDr'="" RegUserCode=$listget($g(^dbo.SYSUserD(RegUserDr)),2)
	Set AuthDate 		= $lg(ReportData,19)		//审核日期
	Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
	Set AuthTime 		= $lg(ReportData,20)		//审核时间
	Set AuthUserDr	 	= $lg(ReportData,21)		//审核人
	Set (AuthUserCode,AuthUserName)=""
	Set:AuthUserDr'="" AuthUserName=$listget($g(^dbo.SYSUserD(AuthUserDr)),3)
	Set:AuthUserDr'="" AuthUserCode=$listget($g(^dbo.SYSUserD(AuthUserDr)),2)
	
	Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",TestSetRow=""
	Set TestSetInfo=..GetVisitTestSet(VisitNumberDr,WorkGrpMachDr)
	Set:TestSetInfo="" TestSetInfo=..GetVisitTestSet(VisitNumberDr)  //如果为空，取全部检验医嘱
	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Continue:TSDesc=""
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		Set HISOrderID=$listget(tData,7)
		Set TestSetStr=TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
		Set TestSetRow=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),3)),"^",35)
		Quit
	}
	Quit:TestSetStr="" return
	
	Set return=$lb(aReportID)
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

/// Creator：     liyi
/// CreatDate：   2017-08-10
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).GetVisitTestSet(7487526)
ClassMethod GetVisitTestSet(aVisitNumberID As %String, aWorkGrpMachDr As %String = "") As %List
{
	New (aVisitNumberID,aWorkGrpMachDr)
	Set return=""
	Quit:aVisitNumberID="" return
	
	Set xTestSetID=0
	For {
		Set xTestSetID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",aVisitNumberID,xTestSetID))
		Quit:xTestSetID=""
		
		Set xID=0
		For {
			Set xID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",aVisitNumberID,xTestSetID,xID))
			Quit:xID=""
			
			Set tTSInfo=$g(^dbo.RPVisitNumberTestSetD(xID))
			Continue:tTSInfo=""
			Set TestSetDr=$listget(tTSInfo,3)
			Continue:TestSetDr=""
			Set WorkGroupMachineDr=$listget(tTSInfo,5)
			Continue:(aWorkGrpMachDr'="")&(aWorkGrpMachDr'=WorkGroupMachineDr)
			Set HISOrdItemDr=$listget(tTSInfo,10)
	
			//检验医嘱
			Set TSData=$g(^dbo.BTTestSetD(TestSetDr))
			Continue:TSData=""
			Set TSCode=$listget(TSData,2)
			Set TSDesc=$listget(TSData,3)
			Continue:TSDesc=""
		 	
		    //HIS医嘱
			Set ArcimCode="",ArcimDesc=""
			If HISOrdItemDr'="" {
				Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
				If ArcimID'="" {
					Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
				}
			}
			
			Set Data=$lb(xID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr)
			
			Set return=return_$lb(Data)
		}
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-03-07
/// Description:  通过检验报告ID、检验项目ID取检验项目结果
/// Input：       aReportID:检验报告ID
/// Input：       aTCID:检验项目ID
/// Return：      标本信息
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).GetTestCodeResult("5485049","1228")
ClassMethod GetTestCodeResult(aReportID As %String, aTCID As %String) As %List
{
	New (aReportID,aTCID)
	Set return=""
	Quit:(aReportID="")||(aTCID="") return	
	
	Set xResultID = ""
	For {
		Set xResultID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,aTCID,xResultID))
		Quit:xResultID=""
		
		Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
		Continue:ResultData=""
	
		Set TestCodeData    = $g(^dbo.BTTestCodeD(aTCID))
		Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
		Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
		Set RstFormat       = $lg(TestCodeData,9) //结果类型
		Set:RstFormat="X" RstFormat = "T" 	//文本格式
		Set Result			= $lg(ResultData,5)	  //检测结果
		Set TextRes			= $lg(ResultData,6)	  //定性结果
		Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
		Set AbFlag			= $lg(ResultData,9)	  //异常提示
		Set Unit			= $lg(ResultData,11)  //单位
		Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
		Set MDRResult   	= $lg(ResultData,27)  //多耐结果
	
		Set ResultData = xResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
		_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
	
		 //特殊不可见字符处理
		Set ResultData=$tr(ResultData,$c(0),"")
		Set ResultData=$tr(ResultData,$c(1),"")
		Set ResultData=$tr(ResultData,$c(10),"")
		Set ResultData=$tr(ResultData,$c(13),"")
		
		Set return = return_$lb(ResultData)

	} 	
   
	
	Quit return
	
GetTestCodeResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-04-29
/// Description:  查询检验报告记录（根据检验项目查询检验结果）
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.IO.SyncLis2Srv","QryLabVisitRepItem","53199533","2019-03-05","2019-03-05")
Query QryLabVisitRepItem(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String,TCResultID:%String,TCID:%String,TCCode:%String,TCDesc:%String,TCRstFormat:%String,TCResult:%String,TCTextRes:%String,TCAbFlag:%String,TCRefRanges:%String")
{
}

ClassMethod QryLabVisitRepItemExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aTCCodes=$g(aTCCodes)
	
	Set xReqDate=""
	For {
		Set xReqDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate))
		Quit:xReqDate=""
		
		Set xVisitNumberDr=0
		For {
			Set xVisitNumberDr=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			
			Set VisitNumberData=$g(^dbo.RPVisitNumberD(xVisitNumberDr))
			Continue:VisitNumberData=""
			Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
			Continue:EpisodeID=""
			Set AdmStr = $g(^PAADM(+EpisodeID))
			Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
			Continue:(AdmType'="I")&(AdmType'="E")&(AdmType'="O")
			
			Set xWorkGrpMachDr=""
			For {
				Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr))
				Quit:xWorkGrpMachDr=""
				
				Set xOrderNo=0
				For {
					Set xOrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo))
					Quit:xOrderNo=""
					
					Set xReportDr=0
					For {
						Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo,xReportDr))
						Quit:xReportDr=""
						
						Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
						Continue:ReportData=""
						Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
						Continue:VisitNumberDr=""
						Set AuthDate=$lg(ReportData,19)		       //审核日期
						Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
						Set ReAuthDate=$lg(ReportData,23)		   //复审日期
						Set:ReAuthDate'="" ReAuthDate=$zdh(ReAuthDate,8)
						
						Set IsAct=0
						If (AuthDate'="")&(AuthDate>=aDateFrom)&(AuthDate<=aDateTo) {
							Set IsAct=1
						}
						If (ReAuthDate'="")&(ReAuthDate>=aDateFrom)&(ReAuthDate<=aDateTo) {
							Set IsAct=1
						}
						Continue:IsAct<1
						
						Set WorkGrpMachDr   = $lg(ReportData,4)			//WorkGroupMachineDR
						Set Order			= $lg(ReportData,5)			//报告序号
						Set TestSetRow		= ""						//医嘱表OEORI_LabTestSetRow字段
						Set RepStatus  		= $lg(ReportData,22)		//状态
						Set RegDate 		= $lg(ReportData,16)		//录入日期
						Set:RegDate'="" RegDate=$zdh(RegDate,8)
						Set RegTime 		= $lg(ReportData,17)		//录入时间
						Set RegUserDr		= $lg(ReportData,18)		//录入人
						Set (RegUserCode,RegUserName)=""
						Set:RegUserDr'="" RegUserName=$listget($g(^dbo.SYSUserD(RegUserDr)),3)
						Set:RegUserDr'="" RegUserCode=$listget($g(^dbo.SYSUserD(RegUserDr)),2)
						Set AuthDate 		= $lg(ReportData,19)		//审核日期
						Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
						Set AuthTime 		= $lg(ReportData,20)		//审核时间
						Set AuthUserDr	 	= $lg(ReportData,21)		//审核人
						Set (AuthUserCode,AuthUserName)=""
						Set:AuthUserDr'="" AuthUserName=$listget($g(^dbo.SYSUserD(AuthUserDr)),3)
						Set:AuthUserDr'="" AuthUserCode=$listget($g(^dbo.SYSUserD(AuthUserDr)),2)
						
						Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
						Continue:VisitNumberData=""
						Continue:$listlength(VisitNumberData)<17
						
						//取检验医嘱与HIS医嘱
						Set TestSetStr="",TestSetRow=""
						Set TestSetInfo=..GetVisitTestSet(VisitNumberDr,WorkGrpMachDr)
						Set:TestSetInfo="" TestSetInfo=..GetVisitTestSet(VisitNumberDr)  //如果为空，取全部检验医嘱
						For indTS=1:1:$ll(TestSetInfo) {
							Set tData=$listget(TestSetInfo,indTS)
							Continue:tData=""
							Set TSCode=$listget(tData,2)
							Set TSDesc=$listget(tData,3)
							Continue:TSDesc=""
							Set ArcimCode=$listget(tData,4)
							Set ArcimDesc=$listget(tData,5)
							Set HISOrderID=$listget(tData,7)
							If TestSetStr'="" {
								Set TestSetStr=TestSetStr_"!!"_TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
							} Else {
								Set TestSetStr=TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
							}
							Set TestSetRow=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),3)),"^",35)
							//Quit
						}
						Continue:TestSetStr=""
						
						//检验项目结果
						Set xTCID=""
						For {
							Set xTCID=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",xReportDr,xTCID))
							Quit:xTCID=""
							
							Set xResultID=""
							For {
								Set xResultID=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",xReportDr,xTCID,xResultID))
								Quit:xResultID=""
							
								Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
								Continue:ResultData=""
								
								Set TestCodeData    = $g(^dbo.BTTestCodeD(xTCID))
								Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
								Continue:(aTCCodes'="")&((","_aTCCodes_",")'[(","_TestCodeCode_","))
								Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
								Set RstFormat       = $lg(TestCodeData,9) //结果类型
								Set:RstFormat="X" RstFormat = "T" 	//文本格式
								Set Result			= $lg(ResultData,5)	  //检测结果
								Set TextRes			= $lg(ResultData,6)	  //定性结果
								Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
								Set AbFlag			= $lg(ResultData,9)	  //异常提示
								Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
								
								Set return=$lb(xReportDr)
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
								
								Set return=return_$lb(xResultID)
								Set return=return_$lb(xTCID)
								Set return=return_$lb(TestCodeCode)
								Set return=return_$lb(TestCodeDesc)
								Set return=return_$lb(RstFormat)
								Set return=return_$lb(Result)
								Set return=return_$lb(TextRes)
								Set return=return_$lb(AbFlag)
								Set return=return_$lb(RefRanges)
							    
							    Set Data=return
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
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
/// CreatDate：   2019-04-29
/// Description:  组织Query输出检验报告
/// Input：       aReportID:检验报告ID
///               aTCCodes:检验项目代码（多）
/// Return：      返回List
/// w ##Class(DHCMA.Util.IO.SyncLis2Srv).BuildVisitRepoItem(5313665,"")
ClassMethod BuildVisitRepoItem(aReportID As %String, aTCCodes As %String = "", ByRef errMsg As %String = "") As %List
{
	New (aReportID,aTCCodes, errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildVisitRepoItemErr"
	
	Set ReportData=$g(^dbo.RPVisitNumberReportD(aReportID))
	Quit:ReportData="" return
	Set VisitNumberDr=$lg(ReportData,2)			//标本ID
	Quit:VisitNumberDr="" return
	
	Set WorkGrpMachDr   = $lg(ReportData,4)			//WorkGroupMachineDR
	Set Order			= $lg(ReportData,5)			//报告序号
	Set TestSetRow		= ""						//医嘱表OEORI_LabTestSetRow字段
	Set RepStatus  		= $lg(ReportData,22)		//状态
	Set RegDate 		= $lg(ReportData,16)		//录入日期
	Set:RegDate'="" RegDate=$zdh(RegDate,8)
	Set RegTime 		= $lg(ReportData,17)		//录入时间
	Set RegUserDr		= $lg(ReportData,18)		//录入人
	Set (RegUserCode,RegUserName)=""
	Set:RegUserDr'="" RegUserName=$listget($g(^dbo.SYSUserD(RegUserDr)),3)
	Set:RegUserDr'="" RegUserCode=$listget($g(^dbo.SYSUserD(RegUserDr)),2)
	Set AuthDate 		= $lg(ReportData,19)		//审核日期
	Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
	Set AuthTime 		= $lg(ReportData,20)		//审核时间
	Set AuthUserDr	 	= $lg(ReportData,21)		//审核人
	Set (AuthUserCode,AuthUserName)=""
	Set:AuthUserDr'="" AuthUserName=$listget($g(^dbo.SYSUserD(AuthUserDr)),3)
	Set:AuthUserDr'="" AuthUserCode=$listget($g(^dbo.SYSUserD(AuthUserDr)),2)
	
	Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",TestSetRow=""
	Set TestSetInfo=..GetVisitTestSet(VisitNumberDr,WorkGrpMachDr)
	Set:TestSetInfo="" TestSetInfo=..GetVisitTestSet(VisitNumberDr)  //如果为空，取全部检验医嘱
	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Continue:TSDesc=""
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		Set HISOrderID=$listget(tData,7)
		If TestSetStr'="" {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
		} Else {
			Set TestSetStr=TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
		}
		Set TestSetRow=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),3)),"^",35)
		
	}
	Quit:TestSetStr="" return
	
	//检验项目结果
	Set xTCID=""
	For {
		Set xTCID=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTCID))
		Quit:xTCID=""
	
		Set xResultID=""
		For {
			Set xResultID=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTCID,xResultID))
			Quit:xResultID=""
			
	
			Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
			Continue:ResultData=""
								
			Set TestCodeData    = $g(^dbo.BTTestCodeD(xTCID))
			Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
			Continue:(aTCCodes'="")&((","_aTCCodes_",")'[(","_TestCodeCode_","))
			Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
			Set RstFormat       = $lg(TestCodeData,9) //结果类型
			Set:RstFormat="X" RstFormat = "T" 	//文本格式
			Set Result			= $lg(ResultData,5)	  //检测结果
			Set TextRes			= $lg(ResultData,6)	  //定性结果
			Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
			Set AbFlag			= $lg(ResultData,9)	  //异常提示
			Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
			
			Set return=$lb(aReportID)
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
			
			Set return=return_$lb(TestCodeCode)
			Set return=return_$lb(TestCodeDesc)
			Set return=return_$lb(RstFormat)
			Set return=return_$lb(Result)
			Set return=return_$lb(TextRes)
			Set return=return_$lb(AbFlag)
			Set return=return_$lb(RefRanges)
		}
	}
	
	Quit return
	
BuildVisitRepoItemErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
