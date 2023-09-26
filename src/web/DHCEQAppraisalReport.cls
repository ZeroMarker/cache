Import SQLUser

/// Mozy0226	
/// 2019-9-22
/// 设备鉴定报告业务
Class web.DHCEQAppraisalReport Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQAppraisalReport).SaveData(5,1)
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST, rowid
	s SQLCODE=0
	s rowid=$p(val,"^",1)
	
 	i (+isDel=1)
 	{
	 	&SQL(update SQLUSER.DHC_EQAppraisalReport set AR_InvalidFlag='Y' where AR_RowID = :rowid)
 	 	if (SQLCODE)&(SQLCODE'=100)
 	 	{
	 	 	q SQLCODE
 	 	}
 	 	q 0
 	}
	s PLIST(2) = $p(val,"^",2)	;AR_Type
	s PLIST(3) = $p(val,"^",3)	;AR_EquipDR
	;s PLIST(4) = $p(val,"^",3)	;AR_No
	s PLIST(5) = $p(val,"^",4)	;AR_Name
	s PLIST(6) = $p(val,"^",5)	;AR_UseLocDR
	s PLIST(7) = $p(val,"^",6)	;AR_LocationDR
	s PLIST(8) = $p(val,"^",7)	;AR_DepreMonths
	s PLIST(9) = $p(val,"^",8)	;AR_StateDR
	s PLIST(10) = $p(val,"^",9)	;AR_CheckResult
	
	s PLIST(11) = $p(val,"^",10)	;AR_CheckContent
	s PLIST(12) = $p(val,"^",11)	;AR_MaintCounts
	s PLIST(13) = $p(val,"^",12)	;AR_FrequencyUnit
	s PLIST(14) = $p(val,"^",13)	;AR_PreviousMaintFee 
	s PLIST(15) = $p(val,"^",14)	;AR_TotalFee
	s PLIST(16) = $p(val,"^",15)	;AR_Situation
	s PLIST(17) = $p(val,"^",16)	;AR_OtherSituation
	s PLIST(18) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;AR_ReportDate
	s PLIST(19) = $p(val,"^",18)	;AR_CheckUserDR
	s PLIST(20) = $p(val,"^",19)	;AR_Phone
	s PLIST(21) = $p(val,"^",20)	;AR_Remark
	s PLIST(22) = 0					;AR_Status
	s PLIST(29) = $p(val,"^",21)	;AR_RejectReason
	
	s PLIST(36) = "N"				;AR_InvalidFlag
	s PLIST(37) = $p(val,"^",22)	;AR_OriginalFee
	;s PLIST(37)=$p(val,"^",19)		;AR_Hold1
	;s PLIST(38)=$p(val,"^",20)
	;s PLIST(39)=$p(val,"^",21)
	;s PLIST(40)=$p(val,"^",22)
	;s PLIST(41)=$p(val,"^",23)
	if (rowid'="") 
	{
		&SQL(Update SQLUSER.DHC_EQAppraisalReport Values :PLIST() where AR_RowID = :rowid) 
	}
	else
	{
		s PLIST(4)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAppraisalReport", +$H)
		s PLIST(19) = ##Class(web.DHCEQCommon).getMapIDBySource("user",PLIST(19))	;AR_CheckUserDR
		&SQL(Insert Into SQLUSER.DHC_EQAppraisalReport Values :PLIST())
	}
	if SQLCODE
	{
		Quit SQLCODE
	}
 	Set ID=$Get(%ROWID)
 	Quit ID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQAppraisalReport","GetAppraisalReport",1,"off")
/// d ##class(%ResultSet).RunQuery("web.DHCEQAppraisalReport","GetAppraisalReport",1,"on",1,2)
Query GetAppraisalReport(BussType As %String = "", WaitAD As %String = "", Status As %String = "", ApproveRole As %String = "", No As %String = "", EquipNo As %String = "", Name As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TType:%String,TEquipDR:%String,TNo:%String,TName:%String,TUseLoc:%String,TLocation:%String,TEquipNo:%String,TFileNo:%String,TModel:%String,TLeaveFactoryNo:%String,TState:%String,TReportDate:%String,TCheckUser:%String,TStatus:%String")
{
}

ClassMethod GetAppraisalReportExecute(ByRef qHandle As %Binary, BussType As %String = "", WaitAD As %String = "", Status As %String = "", ApproveRole As %String = "", No As %String = "", EquipNo As %String = "", Name As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetAppraisalReport")=BussType_","_WaitAD_","_Status_","_ApproveRole_","_No_","_EquipNo_","_Name_","_StartDate_","_EndDate
 	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("33")
 	// MZY0123	2636828,2637079		2022-05-12
 	s StartDate=+##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i EndDate="" s EndDate=+$H
	Set index=1
	Set TRow=0
	
	s rowid=0
	f  s rowid=$o(^DHCEQAppraisalReport(rowid)) q:rowid=""  d
	.d ResetVariablesGetAppraisalReport
	.s ARFlag=$p($g(^DHCEQAppraisalReport(rowid)),"^",35)
	.i ARFlag="" s ARFlag="N"
	.q:(InvalidFlag'="")&&(InvalidFlag'=ARFlag)
	.s TRowID=rowid
	.s TType = $p($g(^DHCEQAppraisalReport(TRowID)),"^",1)
	.q:(BussType'="")&&(BussType'=TType)
	.s TStatus = +$p($g(^DHCEQAppraisalReport(TRowID)),"^",21)
	.q:(Status'="")&&(TStatus'=Status)
	.q:(WaitAD="on")&&(TStatus="0")
	.s TEquipDR = +$p($g(^DHCEQAppraisalReport(TRowID)),"^",2)
	.Quit:(TStatus=0)&&(##Class(web.DHCEQCommon).CheckManageLimit("","","","","","","",TEquipDR))
	.s TNo = $p($g(^DHCEQAppraisalReport(TRowID)),"^",3)
	.q:(No'="")&&(TNo'[No)
	.s TName = $p($g(^DHCEQAppraisalReport(TRowID)),"^",4)
	.q:(Name'="")&&(TName'[Name)
	.s TUseLocDR = $p($g(^DHCEQAppraisalReport(TRowID)),"^",5)
	.s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TLocationDR = $p($g(^DHCEQAppraisalReport(TRowID)),"^",6)
	.s TLocation = ##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	.s TEquipNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.q:(EquipNo'="")&&(TEquipNo'[EquipNo)
	.s TFileNo = $p($g(^DHCEQEquip(TEquipDR)),"^",85)
	.s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", $p($g(^DHCEQEquip(TEquipDR)),"^",3))
	.s TLeaveFactoryNo = $p($g(^DHCEQEquip(TEquipDR)),"^",10)
	.s TState = $p($g(^DHCEQCCode("DHCEQEquipStatus", +$p($g(^DHCEQAppraisalReport(TRowID)),"^",8))),"^",2)		;0:正常运行/1:带病工作/2:故障停机/3:功能受限/4:性能落后
	.s TReportDate = $p($g(^DHCEQAppraisalReport(TRowID)),"^",17)
	.Quit:(TReportDate>EndDate)||(TReportDate<StartDate)
	.s TReportDate = ##Class(web.DHCEQCommon).TransValueToPage(TReportDate,"date")
	.s TCheckUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQAppraisalReport(TRowID)),"^",18))
	.s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus) //状态解析
	.
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s CurRole=""
	.i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.q:((WaitAD="on")&&(CurRole'="")&&(CurRole'=ApproveRole))
	.
	.d OutputRowGetAppraisalReport
	
	Quit $$$OK
OutputRowGetAppraisalReport
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TType,TEquipDR,TNo,TName,TUseLoc,TLocation,TEquipNo,TFileNo,TModel,TLeaveFactoryNo,TState,TReportDate,TCheckUser,TStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAppraisalReport
	Set (TRowID,TType,TEquipDR,TNo,TName,TUseLoc,TLocation,TEquipNo,TFileNo,TModel,TLeaveFactoryNo,TState,TReportDate,TCheckUser,TStatus)=""
	Quit
}

ClassMethod GetAppraisalReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppraisalReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAppraisalReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppraisalReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2019-11-29
/// Description:   润乾打印(设备鉴定报告)
/// Input：        ARRowID:鉴定报告ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAppraisalReport","GetAppraisalReportPrint","20") 
Query GetAppraisalReportPrint(ARRowID As %String = "") As %Query(ROWSPEC = "ARNo:%String,ARUseLocDR_DeptDesc:%String,AR_Name:%String,ARCheckUserDR_UName:%String,ARPhone:%String,AREquipDR_EQFileNo:%String,AREquipDR_EquipNo:%String,AREquipDR_EQModelDR_MDesc:%String,AREquipDR_EQLeaveFactoryNo:%String,AREquipDR_EQStartDate:%String,ARLocation:%String,ARLimitYear:%String,ARDepreMonths:%String,ARState:%String,ARCheckResult:%String,ARMaintCounts:%String,ARPreviousMaintFee:%String,ARTotalFee:%String,ARSituation:%String,AROtherSituation:%String,ARAuditUser:%String,ARAuditDate:%String") [ SqlProc ]
{
}

ClassMethod GetAppraisalReportPrintExecute(ByRef qHandle As %Binary, ARRowID As %String = "") As %Status
{
	
	s repid=$I(^CacheTemp)
 	s ind=1
 	s Rowid=0
 	s (TNo,TUseLoc,TName,TCheckUser ,TPhone,TFileNo,TEquipNo,TModel,TLeaveFactoryNo,TStartDate,TLocation,TLimitYear,TDepreMonths,TState,CheckResult,TMaintCounts,TPreviousMaintFee,TTotalFee,TSituation,TOtherSituation,TAuditUser,TAuditDate)=""
 	i ARRowID=""  d	 
 	.d OutputRowGetAppraisalReportPrint	
 	.q 	
	e  d 
	.s TNo = $p($g(^DHCEQAppraisalReport(ARRowID)),"^",3)
	.s TUseLocDR = $p($g(^DHCEQAppraisalReport(ARRowID)),"^",5)
	.s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR) //使用科室
	.s TName = $p($g(^DHCEQAppraisalReport(ARRowID)),"^",4)
	.s TCheckUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQAppraisalReport(ARRowID)),"^",18))
	.s TPhone=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",19)
	.s TEquipDR = +$p($g(^DHCEQAppraisalReport(ARRowID)),"^",2)
	.s TFileNo = $p($g(^DHCEQEquip(TEquipDR)),"^",85) //档案号
	.s TEquipNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71) //设备编号
	.s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", $p($g(^DHCEQEquip(TEquipDR)),"^",3))
	.s TLeaveFactoryNo = $p($g(^DHCEQEquip(TEquipDR)),"^",10)
	.s TStartDate = $p($g(^DHCEQEquip(TEquipDR)),"^",44) //启用日期
	.s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	.s TLocationDR = $p($g(^DHCEQAppraisalReport(ARRowID)),"^",6)
	.s TLocation = ##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	.s TLimitYear= $p($g(^DHCEQEquip(TEquipDR)),"^",31) //使用年限 AREquipDR_EQLimitYearsNum
	.s TDepreMonths=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",7) //AR_DepreMonths
	.s TState = $p($g(^DHCEQCCode("DHCEQEquipStatus", +$p($g(^DHCEQAppraisalReport(ARRowID)),"^",8))),"^",2)		;0:正常运行/1:带病工作/2:故障停机/3:功能受限/4:性能落后  ARStateDR_ESDesc
	.s CheckResult= $CASE($p($g(^DHCEQAppraisalReport(ARRowID)),"^",9),"0":"合格","1":"不合格",:"没有定义")
	.s TMaintCounts=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",11)
	.i (TMaintCounts'="")&&($p($g(^DHCEQAppraisalReport(ARRowID)),"^",12)'="") s TMaintCounts=TMaintCounts_"次/"_$case($p($g(^DHCEQAppraisalReport(ARRowID)),"^",12),0:"周",1:"月",2:"季度",3:"半年",4:"年",:"")	// MZY0123	2636828,2637079		2022-05-12
	.s TPreviousMaintFee=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",13) //AR_PreviousMaintFee
	.s TTotalFee=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",14) //;AR_TotalFee
	.s TSituation=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",15)    ;AR_Situation
	.s TOtherSituation=$p($g(^DHCEQAppraisalReport(ARRowID)),"^",16) ;AR_OtherSituation
	.s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQAppraisalReport(ARRowID)),"^",25)) //ARAuditUserDR_UName
	.s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAppraisalReport(ARRowID)),"^",26),"date") //ARAuditDate
	.d OutputRowGetAppraisalReportPrint	 
		

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetAppraisalReportPrint
 set Data=$lb(TNo,TUseLoc,TName,TCheckUser ,TPhone,TFileNo,TEquipNo,TModel,TLeaveFactoryNo,TStartDate,TLocation,TLimitYear,TDepreMonths,TState,CheckResult,TMaintCounts,TPreviousMaintFee,TTotalFee,TSituation,TOtherSituation,TAuditUser,TAuditDate) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAppraisalReportPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppraisalReportPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetAppraisalReportPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppraisalReportPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 计量检测或质量检测
/// d ##Class(web.DHCEQAppraisalReport).CheckResultList("CheckResult",130)
ClassMethod CheckResultList(name, width, value As %String = "") As %String
{
	s selectfir=$case(value,0:"selected",:"")
	s selectsec=$case(value,1:"selected",:"")
	;;下拉列表	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name, width)
	w "<option value=1 "_selectsec_">不合格</option>"
	w "<option value=0 "_selectfir_">合格</option>"
	w "</select>",!
}

/// 维修频率单位
/// d ##Class(web.DHCEQAppraisalReport).FrequencyUnitList("FrequencyUnit",130)
ClassMethod FrequencyUnitList(name, width, value As %String = "") As %String
{
	;s ^DHCEQMozy("FrequencyUnitList")=name_","_ width_","_ value
	s selectfir=$case(value,0:"selected",:"")
	s selectsec=$case(value,1:"selected",:"")
	s selectthi=$case(value,2:"selected",:"")
	s selectthr=$case(value,3:"selected",:"")
	s selectfou=$case(value,4:"selected",:"")
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name, width)
	w "<option value=></option>"
	w "<option value=0 "_selectfir_">周</option>"
	w "<option value=1 "_selectsec_">月</option>"
	w "<option value=2 "_selectthi_">季度</option>"
	w "<option value=3 "_selectthr_">半年</option>"
	w "<option value=4 "_selectfou_">年</option>"
	
	w "</select>",!
}

/// w ##Class(web.DHCEQAppraisalReport).GetOneData(1)
ClassMethod GetOneData(rowid As %Library.String = "")
{
	i rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s result=$g(^DHCEQAppraisalReport(rowid))
	s resultex=resultex_"^"	;AR_UseLocDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",5))
	s resultex=resultex_"^"	;AR_LocationDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("location",$p(result,"^",6))
	s resultex=resultex_"^"	;AR_StateDR
	s DrepreTotal=$p(result,"^",7)
	i DrepreTotal=""  d
	.s EquipDR=$p(result,"^",2)
	.s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",EquipDR,0))
	.i DepreSetID'="" s DrepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22) //已折旧月份 zyq 2022-09-19
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQEquipStatus",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"	;AR_CheckResult
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",9),"0":"合格","1":"不合格",:"没有定义")
	s resultex=resultex_"^"	;AR_FrequencyUnit
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",12),"0":"周","1":"月","2":"季度","3":"半年","4":"年",:"没有定义")
	s $p(result,"^",17)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date")		;ReportDate
	s resultex=resultex_"^"	;AR_CheckUserDR
	s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(result,"^",18))
	s resultex=resultex_"^"	;AR_AuditUserDR
	s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(result,"^",25))
	s $p(result,"^",26)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",26),"date")		;AuditDate
	s $p(result,"^",27)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"time")		;AuditTime
	
	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("33",rowid)
	s result=result_resultex_"^"_apprInfo_"^"_DrepreTotal
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 描述:提交
/// w ##Class(web.DHCEQAppraisalReport).SubmitData(4)
ClassMethod SubmitData(RowID As %Library.String = "")
{
	new (RowID, %session)  // 清空session值后影响消息生成
	i RowID="" q ""
	s InvalidFlag=$p($g(^DHCEQAppraisalReport(RowID)),"^",35)
	i InvalidFlag="Y" q -1015
	Set $ZT="ERRORSubmit"
  	
  	s PLIST(22)	= 1
	s PLIST(23) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;AR_SubmitUserDR
 	s PLIST(24) = +$H							;AR_SubmitDate
	s PLIST(25) = $Piece($H,",",2)				;AR_SubmitTime
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("33")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "", "")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus
	
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(22)="2"				;Status
		s PLIST(26) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;AR_AuditUserDR
 		s PLIST(27) = +$H							;AR_AuditDate
		s PLIST(28) = $Piece($H,",",2)				;AR_AuditTime
		Set AppInfoStatus="2"		;AppInfoStatus
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,33,##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")))
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}

	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAppraisalReport values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;最后一步需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQAppraisalReport).LastAuditAction(RowID, ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")), +$H)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("82", RowID, ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")), ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息
}

/// 描述:取消提交
/// w ##Class(web.DHCEQAppraisalReport).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val, CurRole, %session)  //清空session值后影响消息生成
	Set $ZT="ERRORCancelSubmit"
	s RowID=$P(val,"^",1)
	q:RowID="" ""
	s RejectReason=$P(val,"^",2)
	s User=$P(val,"^",3)
	s CancelToFlowDR=$P(val,"^",4)
	s ApproveSet=$P(val,"^",5)
	
	;获取取消到上一步的信息
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	
	s PLIST(22)=Status
	s PLIST(29)=RejectReason
	s PLIST(30)=User		;RejectUserDR
	s PLIST(31)=+$H			;RejectDate
	s PLIST(32)=$Piece($H,",",2)	;RejectTime
	
	TSTART
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("33")
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAppraisalReport values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("82", RowID, User, ApproveFlow, "Y", CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancelSubmit
	TRollBack
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancelSubmit"_ErrorMsg     //返回错误消息
}

/// 描述:审核
/// w ##Class(web.DHCEQAppraisalReport).AuditData("9^^2620^^47",2,1,"")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new (val, CurRole,RoleStep, editFieldsInfo, %session)  //ZX0035 清空session值后,影响消息生成
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag,AppInfoStatus,PLIST
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s User=$P(val,"^",3)
	s Date=+$H
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("33")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("33", RowID)
	i ApproveSet="" q -4007
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	Set AppInfoStatus="1"			;AppInfoStatus
	
	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQAppraisalReport(RowID)),"^",21)=2)
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1
		
		s PLIST(22)="2"
		s PLIST(26) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;AR_AuditUserDR
		s PLIST(27)=Date				;AR_AuditDate
		s PLIST(28)=$Piece($H,",",2)	;AR_AuditTime
		&SQL(update sqluser.DHC_EQAppraisalReport values :PLIST() where AR_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		Set AppInfoStatus="2"			;AppInfoStatus
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQAppraisalReport).LastAuditAction(RowID, User, Date)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("82", RowID, User, ApproveFlow_"^"_ApproveSet, "N", CurRole, AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg		//返回错误消息
}

/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// w ##Class(web.DHCEQAppraisalReport).LastAuditAction(8,2620,65252)
ClassMethod LastAuditAction(RowID, User, Date)
{
	s SQLCODE=##class(web.DHCEQAppraisalReport).InsertEQLifeInfo(RowID, User, Date)	//生命周期信息
	q SQLCODE
}

/// 描述:写设备的生命周期信息
/// w ##Class(web.DHCEQAppraisalReport).InsertEQLifeInfo(8,2620,65252)
ClassMethod InsertEQLifeInfo(RowID, User, Date)
{
	q:RowID=""
	s Time=$P($H,",",2)
	Kill LI
	
	Set EquipDR = $p($g(^DHCEQAppraisalReport(RowID)),"^",2)
	Set LI(2) = EquipDR
	Set LI(9)=$Piece($Get(^DHCEQEquip(EquipDR)),"^",19)   	//变动后使用科室
	Set LI(10)=$Piece($Get(^DHCEQEquip(EquipDR)),"^",17) 	//变动后管理科室
	Set LI(11)=$Piece($Get(^DHCEQEquip(EquipDR)),"^",67)  	//变动后库房
	Set LI(12)=$Piece($Get(^DHCEQEquip(EquipDR)),"^",27)  	//变动后原值
	Set LI(13)=$Piece($Get(^DHCEQEquip(EquipDR)),"^",28)  	//变动后净值
	If $p($g(^DHCEQAppraisalReport(RowID)),"^",1)=1 Set LI(15)="报废预警鉴定"  //变动描述
	Set LI(16)=Date						//变动日期
	Set LI(17)=Time						//变动时间
	;Set LI(18)=$Piece(result,"^",58)  	//费用
	Set LI(19)="O"						//生命周期类型:报废预警鉴定
	Set LI(20)=82						//来源类型
	Set LI(21)=RowID					//来源ID
	;Set LI(23)=$Piece(result,"^",40)  	//备注
	Set LI(27)=User						//更新人
	Set LI(28)=Date						//更新日期
	Set LI(29)=Time						//更新时间
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	
	Quit SQLCODE
}

/// 描述:作废
/// w ##Class(web.DHCEQAppraisalReport).CancelData(4)
ClassMethod CancelData(RowID As %Library.String = "")
{
	i RowID="" q ""
	/*i $p($g(^DHCEQAppraisalReport(RowID)),"^",21)="3" q -1015
	i $p($g(^DHCEQAppraisalReport(RowID)),"^",35)="Y" q -1015
	Set $ZT="ERRORCancel"
  	
  	s PLIST(22)	= 3
	s PLIST(33) = %session.Get("LOGON.USERID")	;AR_CancelUserDR
 	s PLIST(34) = +$H							;AR_CancelDate
	s PLIST(35) = $Piece($H,",",2)				;AR_CancelTime
	
	&SQL(update sqluser.DHC_EQAppraisalReport values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("82", RowID, %session.Get("LOGON.USERID"), ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		q SQLCODE
	}*/
	
 	q RowID
ERRORCancel
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息
}

}
