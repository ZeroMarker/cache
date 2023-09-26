/// 名称: DHCHAI.DI.DIO.FromLisSrv
/// 描述: 检验数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromLisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询接收标本记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","QryLabVisitNumber","832554","2017-01-01","2018-11-18")
Query QryLabVisitNumber(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,ReqNotes:%String,TestSetStr:%String")
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
				Set AdmStr = $g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
				Continue:(AdmType'="I")&(AdmType'="E")
				
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
					Set AdmStr = $g(^PAADM(+EpisodeID))
					Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					
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
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).BuildVisitNumber(2)
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
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","QryLabVisitReport","832554","2017-01-01","2018-11-18")
Query QryLabVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,ReqNotes:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
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
				Continue:(AdmType'="I")&(AdmType'="E")
				
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
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).BuildVisitReport(20)
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
	Quit:$listlength(VisitNumberData)<18 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",TestSetRow=""
	Set TestSetInfo=..GetVisitTestSet(VisitNumberDr,aReportID)
	//Set:TestSetInfo="" TestSetInfo=..GetVisitTestSet(VisitNumberDr)  //如果为空，取全部检验医嘱
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
			Set TestSetStr=TestSetStr_"!!"_TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		} Else {
			Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		}
		Set:TestSetRow="" TestSetRow=$listget(tData,8)
	}
	Quit:TestSetStr="" return
	
	Set return=$lb(aReportID)
	Set return=return_$list(VisitNumberData,1,18)
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
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetVisitNumber(2)
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
	Set HospitalDr=$listget(VisitNumberData,21)		// HospitalDr
	Set:SpecimenDr'="" SpecimenCode=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),2)
	Set:SpecimenDr'="" SpecimenDesc=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),3) //修改新版检验同步不到标本等问题
	//检验系统未存标本信息，从医嘱系统取
	If SpecimenDesc="" {
		Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
		Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
		Set tSpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
		Set:tSpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",tSpecDr),"^",1)
		If SpecimenCode'="" {
			Set SpecimenDr=$o(^dbo.BTSpecimenI("IndexCode",HospitalDr,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
			Set:SpecimenDr'="" SpecimenDesc=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),3) //修改新版检验同步不到标本等问题
		}
		If SpecimenDesc="" {
			Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
			Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
		}
	}
	Quit:SpecimenDesc="" return
	
	Set (LocationCode,LocationDesc)=""
	Set LocationDr=$listget(VisitNumberData,22)		// 科室
	Set:LocationDr'="" LocationCode=$listget($g(^dbo.BTLocationD(LocationDr)),5)
	Set:LocationDr'="" LocationDesc=$listget($g(^dbo.BTLocationD(LocationDr)),3)
	//update 20190508  检验BT_Location有部分数据Code与HISCode的存储是反的, 8.3标准版科室HISCode由存储CT_LOC的CTLOC_Code改CTLOC_RowID
	If (LocationCode'="")&&('$d(^CTLOC(0,"Code",$zcvt(LocationCode,"U")))) {
		Set LocationCode=$p($g(^CTLOC(LocationCode)),"^",1)
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
	
	Set (WardCode,WardDesc)=""
	Set WardDr=$listget(VisitNumberData,26)		   // 病区
	Set:WardDr'="" WardCode=$listget($g(^dbo.BTWardD(WardDr)),4)  //病区HISCode
	Set:WardDr'="" WardDesc=$listget($g(^dbo.BTWardD(WardDr)),3)
	//update 20190508 检验BT_Ward有部分数据Code与HISCode的存储是反的, 8.3标准版病区HISCode由存储PAC_Ward的WARD_Code改WARD_RowID
	If (WardCode'="")&&('$d(^PAWARD(0,"WARD_Code",$zcvt(WardCode,"U")))) {
		Set WardCode=$p($g(^PAWARD(WardCode)),"^",1)
	}
	
	Set ReqNotes=$listget(VisitNumberData,48)  //医嘱备注	add 20230424
	Set return=$lb(aVisitNumberID)
	Set return=return_$lb(EpisodeID)       //就诊号
	Set return=return_$lb(EpisodeNo)       //检验号 对应医嘱表OEORI_LabEpisodeNo
	Set return=return_$lb(SpecimenCode)    //标本
	Set return=return_$lb(SpecimenDesc)
	Set return=return_$lb(LocationCode)    //申请科室
	Set return=return_$lb(LocationDesc)
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
	Set return=return_$lb(ReqNotes)        //医嘱备注	 add 20230424

	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-10
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetVisitTestSet(212)
ClassMethod GetVisitTestSet(aVisitNumberID As %String, aVisitReportDr As %String = "") As %List
{
	New (aVisitNumberID,aVisitReportDr)
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
			Set VisitReportDr=$listget(tTSInfo,11)
			Continue:(aVisitReportDr'="")&(aVisitReportDr'=VisitReportDr)
			Set HISOrdItemDr=$listget(tTSInfo,10)
			
			//检验医嘱
			Set TSData=$g(^dbo.BTTestSetD(TestSetDr))
			Continue:TSData=""
			Set TSCode=$listget(TSData,2)
			Set TSDesc=$listget(TSData,3)
			Continue:TSDesc=""
			
			//HIS医嘱
			If HISOrdItemDr'="" {
				Set ArcimCode="",ArcimDesc=""
				Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
				If ArcimID'="" {
					Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
				}
				Set TestSetRow=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),3)),"^",35)
				Set Data=$lb(xID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr,TestSetRow)
				Set return=return_$lb(Data)
			} Else {
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(aVisitNumberID))
				If VisitNumberData'="" {
					Set EpisodeNo=$listget(VisitNumberData,2)		// 检验号/标本号
					Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
					Set SubID=""
					For {
						Set SubID=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,SubID))
						Quit:SubID=""
						
						Set HISOrdItemDr=OrdID_"||"_SubID
						Set ArcimCode="",ArcimDesc=""
						Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
						If ArcimID'="" {
							Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
							Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
						}
						
						Set TestSetRow=""
						Set SubID2=""
						For {
							Set SubID2=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,SubID2))
							Quit:SubID2=""
							Set TestSetRow=$p($g(^OEORD(OrdID,"I",SubID2,3)),"^",35)
							Quit:TestSetRow'=""
						}
						
						Set Data=$lb(xID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr,TestSetRow)
						Set return=return_$lb(Data)
					}
				}
			}
		}
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  通过检验报告ID取检验结果接口
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepResult(22870)
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
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
	
	Set xTestCodeID = ""
 	For {
		Set xTestCodeID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTestCodeID))
		Quit:xTestCodeID=""
		
		Set xResultID = ""
		For {
			Set xResultID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTestCodeID,xResultID))
			Quit:xResultID=""
			
			Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
			Continue:ResultData=""
			
			Set TestCodeData    = $g(^dbo.BTTestCodeD(xTestCodeID))
			Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
			Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
			Set RstFormat       = $lg(TestCodeData,9) //结果类型
			Set:RstFormat="X" RstFormat = "T" 	//文本格式
			Set Result			= $lg(ResultData,5)	  //检测结果
			Set TextRes			= $lg(ResultData,6)	  //定性结果
			Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
			Set AbFlag			= $lg(ResultData,9)	  //异常提示
			Set Unit			= $lg(ResultData,11)  //单位
			Set:Unit["^" Unit=$tr(Unit,"^","~")       //特殊字符处理
			Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
			Set MDRResult   	= $lg(ResultData,27)  //多耐结果
			Set MultipleRes   	= $lg(ResultData,33)  //多耐类型
			
			Set RstResItems=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepRstResItem(xResultID) //根据检验结果获取耐药机制阳性结果
			For indItem=1:1:$listlength(RstResItems) {
				Set RstResItem=$listget(RstResItems,indItem)
				Continue:RstResItem=""
				Set MDRResult=MDRResult_","_RstResItem
			}
			
			Set ResultData = xResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
			_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult_"^"_MultipleRes
			
			Set return = return_$lb(ResultData)
		}
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
/// Input：       aResultID:检验结果ID
/// Return：      药敏结果信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetResultSen(61)
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
	
	Set xAntibioticsID = ""
	For {
		Set xAntibioticsID=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",aResultID,xAntibioticsID))	
		Quit:xAntibioticsID=""
		
		Set AntibioticsData=$g(^dbo.BTAntibioticsD(xAntibioticsID))
		Set AntCode=$lg(AntibioticsData,2)
		Set AntDesc=$lg(AntibioticsData,3)
		Continue:AntDesc=""
		
		Set xResSenID=""
		For {
			Set xResSenID=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",aResultID, xAntibioticsID,xResSenID))
			Quit:xResSenID=""
			
			Set SensitivityDR=$lg($g(^dbo.RPVisitNumberReportResSenD(xResSenID)),6)
			Set SenCode="",SenDesc=""
		    If SensitivityDR'=""{
			    Set SensitivityData=$g(^dbo.BTSensitivityD(SensitivityDR))
			    Set SenCode=$lg(SensitivityData,2)
			    Set SenDesc=$lg(SensitivityData,3)
		    }
		    Continue:SenDesc=""
			Set ResultSenData = AntCode_"^"_AntDesc_"^"_SenDesc_"^"_1
			Set return = return_$lb(ResultSenData)
		}
	}
	Quit return
GetResultSenErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  通过检验结果ID取耐药机制结果接口
/// Input：       aResultID:检验结果ID
/// Return：      耐药机制信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepRstRes(1296)
ClassMethod GetRepRstRes(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResErr"

	Set xResItemID=""   //耐药机制
	For {
		Set xResItemID=$o(^dbo.RPVisitNumberRepResRstI("IndexDataMaster",aResultID,xResItemID))
		Quit:xResItemID="" 
		
		Set ResItemData=$g(^dbo.BTMCResistanceItemD(xResItemID))
		Continue:ResItemData=""
		Set ResItemCode=$lg(ResItemData,2)
		Set ResItemName=$lg(ResItemData,3)
		
		Set xRstResID="" 
		For {
			Set xRstResID=$o(^dbo.RPVisitNumberRepResRstI("IndexDataMaster",aResultID,xResItemID,xRstResID))
			Quit:xRstResID=""  
			
			Set ResRstData=$g(^dbo.RPVisitNumberRepResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResRstDr=$lg(ResRstData,4)
			Continue:ResRstDr=""
			Set ResData = $g(^dbo.BTBaseTableD(ResRstDr))
			Continue:ResData=""
			Set RstCode = $lg(ResData,3)
			Set RstName = $lg(ResData,4)

			Set RepResRstData = xRstResID_"^"_xResItemID_"^"_ResItemCode_"^"_ResItemName_"^"_ResRstDr_"^"_RstCode_"^"_RstName
			Set return = return_$lb(RepResRstData)
		}
	}
	
	Quit return
GetRepRstResErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-05-30
/// Description:  通过检验结果ID取耐药机制阳性项目列表
/// Input：       aResultID:检验结果ID
/// Return：      耐药机制信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepRstResItem(1296)
ClassMethod GetRepRstResItem(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResItemErr"

	Set xResItemID=""   //耐药机制
	For {
		Set xResItemID=$o(^dbo.RPVisitNumberRepResRstI("IndexDataMaster",aResultID,xResItemID))
		Quit:xResItemID="" 
		
		Set ResItemData=$g(^dbo.BTMCResistanceItemD(xResItemID))
		Continue:ResItemData=""
		Set ResItemCode=$lg(ResItemData,2)
		Set ResItemName=$lg(ResItemData,3)
		//排除非多重耐药菌项目
	    Continue:(ResItemCode="A0001")||(ResItemCode="A0004")||(ResItemCode="A0005")||(ResItemCode="A0006")||(ResItemCode="A0007")
	 
		Set xRstResID="" 
		For {
			Set xRstResID=$o(^dbo.RPVisitNumberRepResRstI("IndexDataMaster",aResultID,xResItemID,xRstResID))
			Quit:xRstResID=""  
			
			Set ResRstData=$g(^dbo.RPVisitNumberRepResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResRstDr=$lg(ResRstData,4)
			Continue:ResRstDr=""
			Set ResData = $g(^dbo.BTBaseTableD(ResRstDr))
			Continue:ResData=""
			Set RstCode = $lg(ResData,3)
			Set RstName = $lg(ResData,4)
            Continue:(RstName'="阳性")&&(RstName'="MRSA")
			Set return = return_$lb(ResItemName)
		}
	}
	
	Quit return
GetRepRstResItemErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询检验抗生素字典
/// Table：        dbo.BTAntibiotics
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","GetLisAntiDic")
Query GetLisAntiDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisAntiDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^dbo.BTAntibioticsD(xID))
		Quit:xID=""
		
		Set AntibioticsData=$g(^dbo.BTAntibioticsD(xID))
		Set AntCode=$lg(AntibioticsData,2)
		Set AntDesc=$lg(AntibioticsData,3)
		Set IsActive=$lg(AntibioticsData,18)
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
/// Table：        dbo.BTOrganism
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","GetLisBactDic")
Query GetLisBactDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisBactDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^dbo.BTOrganismD(xID))
		Quit:xID=""
		
		Set OrganismData=$g(^dbo.BTOrganismD(xID))
		Set BactCode=$lg(OrganismData,2)
		Set BactDesc=$lg(OrganismData,3)
		Set IsActive=$lg(OrganismData,14)
		Set:IsActive'=0 IsActive=1
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
/// Table：        dbo.BTSpecimen
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","GetLisSpecDic")
Query GetLisSpecDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisSpecDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^dbo.BTSpecimenD(xID))
		Quit:xID=""
		
		Set SpecimenData=$g(^dbo.BTSpecimenD(xID))
		Set SpecCode=$lg(SpecimenData,2)
		Set SpecDesc=$lg(SpecimenData,3)
		Set IsActive=$lg(SpecimenData,11)
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
/// Table：        dbo.BTTestCode
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","GetLisTestCodeDic")
Query GetLisTestCodeDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,RstFormat:%String,IsActive:%String,TSDescStr:%String")
{
}

ClassMethod GetLisTestCodeDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^dbo.BTTestCodeD(xID))
		Quit:xID=""
		
		Set TestCodeData=$g(^dbo.BTTestCodeD(xID))
		Set TCCode=$lg(TestCodeData,2)
		Set TCDesc=$lg(TestCodeData,3)
		Set RstFormat=$lg(TestCodeData,9)
		Set IsActive=$lg(TestCodeData,25)
		Continue:(TCCode="")||(TCDesc="")
		
		Set TSDescList="",TSDescStr=""
		Set xTSID=0
		For {
			Set xTSID=$o(^dbo.BTTestSetLayoutI("IndexTestCode",xID,xTSID))
			Quit:xTSID=""
			
			Set TestSetData=$g(^dbo.BTTestSetD(xTSID))
			Set TSCode=$lg(TestSetData,2)
			Set TSDesc=$lg(TestSetData,3)
			Continue:TSDesc=""
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
/// Table：        dbo.BTTestSet、ARC_ItemExternalCodes
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","GetLisTestSetDic")
Query GetLisTestSetDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,TSHISCode:%String,ArcimCode:%String,ArcimDesc:%String")
{
}

ClassMethod GetLisTestSetDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^dbo.BTTestSetD(xID))
		Quit:xID=""
		
		Set TestSetData=$g(^dbo.BTTestSetD(xID))
		Set TSCode=$lg(TestSetData,2)
		Set TSDesc=$lg(TestSetData,3)
		Set TSHISCode=$lg(TestSetData,7)
		Set:TSHISCode="" TSHISCode=TSCode
		Set IsActive=$lg(TestSetData,18)
		Continue:IsActive'=1		//过滤无效医嘱(2716836) ADD 2022-6-20
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
/// w ##class(DHCHAI.DI.DIO.FromLisSrv).SyncVisitNumber("LIS01","1000000715")
ClassMethod SyncVisitNumber(aSCode As %String, aEpisodeNo As %String) As %String
{
	New (aSCode,aEpisodeNo)
	Set return=0
	Quit:(aSCode="")||(aEpisodeNo="") return
	Set $ZT="SyncVisitNumberErr"
	
	Set aVisitNumberID=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(aEpisodeNo),""))
	Quit:(aVisitNumberID="") return
	Set VisitNumberData=$g(^dbo.RPVisitNumberD(aVisitNumberID))
	Quit:VisitNumberData="" return

	Set RecDate=$listget(VisitNumberData,66)		// 接收日期
	Set:RecDate'="" RecDate=$zdh(RecDate,8)
	Set RecTime=$listget(VisitNumberData,67)		// 接收日期
	Set WardDr=$listget(VisitNumberData,26)		    // 病区
	Set (WardCode,WardDesc)=""

	Set:WardDr'="" WardCode=$listget($g(^dbo.BTWardD(WardDr)),4)  //病区HISCode
	Set:WardDr'="" WardDesc=$listget($g(^dbo.BTWardD(WardDr)),3)	
	//update 20190508 检验BT_Ward有部分数据Code与HISCode的存储是反的, 8.3标准版病区HISCode由存储PAC_Ward的WARD_Code改WARD_RowID
	If (WardCode'="")&&('$d(^PAWARD(0,"WARD_Code",$zcvt(WardCode,"U")))) {
		Set WardCode=$p($g(^PAWARD(WardCode)),"^",1)
	}	
	
	Set objWard=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,WardCode)
		
	Set xID =$o(^DHCHAI.DP.LabVisitNumberI("IndexLabEpisodeNo",aEpisodeNo,"")) 
	Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(xID)
	Quit:'$IsObject(obj) return
	
	Set EpisodeID = obj.LabEpisodeDr.%Id()
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
/// Input：       aReportID ：就诊号
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromLisSrv","QryLabVisitReportN","16")
Query QryLabVisitReportN(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocCode:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardCode:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
{
}

ClassMethod QryLabVisitReportNExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
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

/// Creator：     pylian
/// CreatDate：   2019-08-21
/// Description:  处理单位导致的检验结果存储数据错误问题
/// 			  
/// Table		  DHCHAI.DP.LabVisitRepResult
/// w ##class(DHCHAI.DI.DIO.FromLisSrv).SyncVisitRepResult()
ClassMethod SyncVisitRepResult() As %String
{
	Set return =0 ,Count=0
	
	W "开始",!
	Set CurrTime = $h
	Set (LabUnit,LabRefRanges)=""	
	
	Set xResultID=""
	For { 
		Set xResultID =$o(^DHCHAI.DP.LabVisitRepResultD(xResultID))
		Quit:xResultID=""
        w !,xResultID
        
		Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
		Continue:'$IsObject(objResult)
		Continue:objResult.LabRstFormat="M"
		Set MDRResult = objResult.LabMDRResult
		Continue:MDRResult=""
		Set Unit = objResult.LabUnit
		Set RefRanges = objResult.LabRefRanges
		
		Set LabUnit = Unit_"~"_RefRanges
		Set LabRefRanges = MDRResult
		
		Set obj=##class(DHCHAI.DP.LabVisitRepResult).%OpenId(xResultID)
		Set obj.LabUnit = LabUnit
		Set obj.LabRefRanges = LabRefRanges
		Set obj.LabMDRResult = ""
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
		}Else {
			Set Count =Count+1
		}
		Do obj.%Close()
	}
	
	Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Set return = Count
	Quit return
}

}
