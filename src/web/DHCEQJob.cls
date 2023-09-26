Class web.DHCEQJob Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add by Mozy 2011-7-23
/// 任务入口
/// type	0或空:按自然月执行,当月1日执行
/// 		1:系统设置的报表开始日期
/// 返回	0:成功
/// w ##class(web.DHCEQJob).DoMain()
ClassMethod DoMain(type As %String = "")
{
	Set flag=0
	Set beginday=0
	Set today=$Piece($H,",",1)
	Set today=$Zd(today,3)
	If type = 1
	{
		Set beginday = $Order(^DHCEQCCode("DHCEQCSysSet","0","Code","901001",0))
		Set beginday=$Piece($Get(^DHCEQCCode("DHCEQCSysSet",beginday)),"^",2)
		Set today=$Piece(today,"-",3)
		If today'=beginday Set flag=1
	}
	else
	{
		;0或空:当月1日执行
		Set day=$Piece(today,"-",3)
		If day'="01" Set flag=-1
	}
	;Do ##Class(web.DHCEQJob).MonthDepre(1)
	;Do ##Class(web.DHCEQJob).MonthDepre(2)	;成本折旧(扣除)
	Quit:flag'=0 flag
	
	Set ^DHCEQLog("Job","DoMain",$zd($h,3),$zt($piece($h,",",2)))="Start"
	Do ##Class(web.DHCEQJob).Snap()			;快照
	Do ##Class(web.DHCEQJob).MonthReport()	;月报
	Do ##Class(web.DHCEQJob).AMonthReport()
	Do ##Class(web.DHCEQJob).CheckReport()
	Set ^DHCEQLog("Job","DoMain",$zd($h,3),$zt($piece($h,",",2)))="Finish"
	
	Quit flag
}

/// 每月定期执行一次计提折旧,单独建立一个任务
/// 因当月入库的下月计提,且当月即使报废也要计提折旧,
/// 故定义在每期第一天凌晨计提当月折旧
/// d ##Class(web.DHCEQJob).MonthDepre()
ClassMethod MonthDepre(DepreTypeDR As %Library.String = "1")
{
	;Modified By JDL 20150811  ZX0024 调整为月末计提折旧。每天执行该任务,若是最后一天,则执行折旧任务
	i 1=##Class(web.DHCEQReport).IsLastReportDate(+$H)
	{
		s Date=$H
		s Node="MonthDepre"
		i DepreTypeDR'=1 s Node="MonthDepre"_DepreTypeDR
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		;获取当前日期所属会计周期的月份
		s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
		s Result= ##class(web.DHCEQMonthDepre).GetMonthDepre(MonthStr,"",DepreTypeDR)
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
	}
}

/// 任务时间设置在凌晨时间,否则会出错
/// 如客户需要，可以对设备台帐每月底定时做一次快照
/// Do ##Class(web.DHCEQJob).Snap()
ClassMethod Snap()
{
	//modified by ZY0288 20211230 每天执行该任务,若-1是最后一天,则执行快照任务
	i 1=##Class(web.DHCEQReport).IsLastReportDate(+$H-1)
	{
		s Date=$H
		s Node="Snap"
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		s Result= ##Class(web.DHCEQSnapShot).Snap()
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
	}
}

/*已经移至web.DHCEQJobForAna
/// 设备使用信息采集，一般每天凌晨采集前一天的数据
ClassMethod GatherData()
{
	s Date=$H
	s Node="GatherData"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s GatherDate=+$H-1
	s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCHIS(GatherDate)	
	s ^DHCEQLog("Job",Node,Date,"Result","His")=Result
	s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCLIS(GatherDate)	
	s ^DHCEQLog("Job",Node,Date,"Result","Lis")=Result
	s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCRIS(GatherDate)	
	s ^DHCEQLog("Job",Node,Date,"Result","Ris")=Result	
	//add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
	s Result= ##Class(web.DHCEQIUsedRecord).GatherPacs(GatherDate)
	s ^DHCEQLog("Job",Node,Date,"Result","Pacs")=Result	
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}
*/
/// add by lmm 2020-03-06 CZF0086
/// 删除原月报，初始化至开始月份月报前，重新出具月报
/// 入参：FromMonthStr 开始月报月  ToMonthStr结束月报月  ToMonthStr为空为当前月份
/// W ##Class(web.DHCEQJob).insertMonthReport("2019-11","2020-02")
ClassMethod insertMonthReport(FromMonthStr As %String = "", ToMonthStr As %String = "", EquipTypeDR As %String = "")
{
	
	i FromMonthStr="" s FromMonthStr=$p($zd($h,3),"-",1,2)
	//modify by lmm 2020-02-17
	s CurMonth=$p($zd($h,3),"-",1,2)
	if ((ToMonthStr="")||(ToMonthStr=CurMonth))
	{
		s ToMonthStr=$p($zd($h,3),"-",1,2)
		s ToDate=$zdh(ToMonthStr_"-01",3)
		s ToDate=ToDate-1
		s ToMonthStr=$p($zd(ToDate,3),"-",1,2)
		
	}
	else
	{
		 s ToDate=$zdh(ToMonthStr_"-01",3)
	}
	
	s SnapDate=+$g(^DHCEQSnapShot(1,"Equip",0,"Begin"))		//初始化日期
	s SnapDate=$zdh($p($zd(SnapDate,3),"-",1,2)_"-01",3)
	s FromDate=$zdh(FromMonthStr_"-01",3)
	//modify by lmm 2020-02-17 end
	if (FromDate<SnapDate) 
	{
		//s FromDate=SnapDate
		s FromMonthStr=$p($zd(SnapDate,3),"-",1,2)
	}  
	
	
	s FromYear=$p(FromMonthStr,"-",1)
	s ToYear=$p(ToMonthStr,"-",1)
	s FromMonth=$p(FromMonthStr,"-",2)
	s ToMonth=$p(ToMonthStr,"-",2)
	
	s result=##Class(web.DHCEQJob).deleteMonthReport(FromMonthStr,ToMonthStr,EquipTypeDR)
	i result
	{
		q result
	} 

	if (FromDate<SnapDate) 
	{
		s FromDate=SnapDate
		s InitMonthStr=$p($zd(SnapDate,3),"-",1,2)
		s result=##Class(web.DHCEQReport).InitReport("0",EquipTypeDR,"",InitMonthStr)
		i result<0
		{
			q result	
			
		}
		
		
	}
	
	//modify by lmm 2019-12-03
	while (FromDate<=ToDate)   //modify by lmm 2019-11-29
	{
		d ##Class(web.DHCEQJob).MonthReport(FromDate,EquipTypeDR)
		s FromMonthStr=##Class(web.DHCEQCommon).MonthStrAdd("M",1,FromMonthStr)	//下月月份
		s FromDate=$zdh(FromMonthStr_"-01",3)
	}	
	
	

	q 0
}

/// W ##Class(web.DHCEQJob).deleteMonthReport("2019-07","2019-08","2")
ClassMethod deleteMonthReport(FromMonthStr As %String = "", ToMonthStr As %String = "", EquipTypeDR As %String = "")
{
	new (FromMonthStr,ToMonthStr,EquipTypeDR)
	s FromDate=$zdh(FromMonthStr_"-01",3)
	s ToDate=$zdh(ToMonthStr_"-01",3)
	
	s SQLCODE=0
	s Year=0
	f  s Year=$o(^DHCEQMonthReportList(0,"YearMonth",Year)) quit:Year=""  d
	.s Month=0
	.f  s Month=$o(^DHCEQMonthReportList(0,"YearMonth",Year,Month)) quit:Month=""  d
	..s Date=$zdh(Year_"-"_Month_"-01",3)
	..q:(Date<FromDate)
	..q:(Date>ToDate)
	..s EquipType=0
	..f  s EquipType=$o(^DHCEQMonthReportList(0,"YearMonth",Year,Month,EquipType)) quit:EquipType=""  d
	...q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	...s rowid=0
	...f  s rowid=$o(^DHCEQMonthReportList(0,"YearMonth",Year,Month,EquipType,rowid)) quit:rowid=""  d
	....&SQL(delete from sqluser.DHC_EQMonthReportList where MRL_RowID=:rowid )
	....q:(SQLCODE'=0)
	
	q SQLCODE
}

/// 任务时间设置在凌晨时间,否则会出错
/// 下月初来执行上月的月结,执行时间应安排在计提折旧后
/// 可以定义在会计周期第一天(如每月1日)凌晨，执行上月的月结
/// d ##Class(web.DHCEQJob).MonthReport("2019-11")
ClassMethod MonthReport(MonthReportDate As %String = "", EquipTypeDR As %String = "")
{
	//modified by ZY0288 20211230 每天执行该任务,若-1是最后一天,则执行月报任务
	i (MonthReportDate'="")||(1=##Class(web.DHCEQReport).IsLastReportDate(+$H-1))
	{
		 //modify by lmm 2020-02-17 begin CZF0086
		i (MonthReportDate'="")
		{
			s Date=MonthReportDate
			s ReportDate=+Date    //当月生成当月月结
		}
		else
		{
			s Date=$H
			s ReportDate=+Date-1  //下月生成上月月结
		}
		 //modify by lmm 2020-02-17 end
		s Node="MonthReport"
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		;取前一天所属的会计月份
		
		s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)
		
		//实物月报
		s Result= ##class(web.DHCEQReport).SaveMonthReport(MonthStr,EquipTypeDR)
		//财务月报
		//s Result= ##class(web.DHCEQReport).SaveMonthReport(MonthStr,"","","1")
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
	}
}

/*已经移至web.DHCEQJobForAna
/// Add by JDL 2010-11-09  JDL0057
/// 根据月消耗的消耗项目量，来倒推各个项目的消耗,并生成使用记录消耗项目
/// 可以定义在每月初 凌晨执行，来推算上月项目消耗。
/// d ##Class(web.DHCEQJob).GenUsedConsumableItem()
ClassMethod GenUsedConsumableItem()
{
	s GenYear=$p($zd(+$H,3),"-",1)
	s GenMonth=$p($zd(+$H,3),"-",2)
	i ((+GenMonth)="1")
	{
		s GenYear=GenYear-1
		s GenMonth="12"
	}
	else
	{
		s GenMonth=GenMonth-1
	}
	d ##Class(web.DHCEQIUsedRecord).GenUsedConsumableItem(GenYear,GenMonth)
}

/// Add by JDL 2010-12-23
/// 根据设备月度消耗资源定义，生成设备当月资源消耗
/// 可以定义在每月初 凌晨执行，生成设备当月资源消耗
ClassMethod AutoCreateUsedResource()
{
	d ##class(web.DHCEQUsedResource).AutoCreateUsedResource()
}

/// add by zy 2011-11-11 ZY0085 地坛锐珂Pacs	每天凌晨，在GatherData之前执行
ClassMethod GatherDataFromSoap(Date)
{
	d ##Class(web.DHCEQIUseRecord).ExecSoap(Date)
}
*/
/// 配件月结,会计周期执行,进行汇总
/// d ##Class(web.DHCEQJob).AMonthReport()
ClassMethod AMonthReport()
{
	s Date=$H
	s Node="AMonthReport"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;取前一天所属的会计月份
	s ReportDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)
	
	s Result= ##class(web.DHCEQAReport).SaveAMonthReport(MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// add by zy 2014-7-17 ZY0114 检测月结和快照数据,是不是正确, 在月报和快照任务结束之后执行这个.
/// d ##Class(web.DHCEQJob).CheckReport()
ClassMethod CheckReport()
{
	s Date=$H
	s Node="CheckReport"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s ReportDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)
	
	s Result= ##class(web.DHCEQCheckResult).CheckMonthReport(MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// Add By DJ 2016-09-19
/// d ##Class(web.DHCEQJob)AStockSnap()
ClassMethod AStockSnap()
{
	s Date=$H
	s Node="AStockSnap"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s Result= ##Class(web.DHCEQASnapShot).AStockSnap()
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// add by zx 2017-01-09 科室最后确认维修单，三天内未作处理时系统自动处理
/// d ##Class(web.DHCEQJob).AutoAuditData()
ClassMethod AutoAuditData()
{
	new Date,Time,Node,MaintID,ApproveListID,Action,ApproveDate,ApproveTime
	new TimeDiff,ValueList,ApproveOpinion,Result
	s Date=$p($H,",",1)
	s Time=$p($H,",",2)
	s Node="AutoAuditData"
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s MaintID=0
	f  s MaintID=$o(^DHCEQMMaintRequest(0,"Status","1",MaintID)) q:MaintID=""  d
	.q:$p($g(^DHCEQMMaintRequest(MaintID)),"^",57)="Y"
	.s ApproveListID=$o(^DHCEQApproveList(0,"Source","25",MaintID,""),-1)
	.q:ApproveListID=""
	.s Action=$p($g(^DHCEQApproveList(ApproveListID)),"^",11)
	.q:Action'="5"
	.s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID","25",MaintID,""))
	.q:(ApproveInfoID'="")&&($p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)'=7)
	.s ApproveDate=$p($g(^DHCEQApproveList(ApproveListID)),"^",7)
	.s ApproveTime=$p($g(^DHCEQApproveList(ApproveListID)),"^",8)
	.s TimeDiff=##Class(web.DHCEQCommon).TimeDiff(ApproveDate,ApproveTime,Date,Time)
	.q:$p(TimeDiff,",",1)<259200  //三天内没处理单据不做处理
	.s ValueList=MaintID_"^1^^"
	.s ApproveOpinion="系统自动确认"
	.s Result=##Class(web.DHCEQM.DHCEQMMaintRequest).AuditData(ValueList, "2", "7", "","",ApproveOpinion)
	.s ^DHCEQLog("Job",Node,Date,"Result",MaintID)=Result
	
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// Add by zx 2021-05-20
/// 保修合同通过自动任务生成提醒类消息,插入DHC_EQMessageSendInfo表
/// w ##Class(web.DHCEQJob).CreateGuaranteeMessages()
ClassMethod CreateGuaranteeMessages()
{
	s Date=$H
	s Node="GuaranteeMessages"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	
	s EquipID=0
	f  s EquipID=$o(^DHCEQContractList(0,"SourceID",4,EquipID)) q:EquipID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQContractList(0,"SourceID",4,EquipID,rowid)) quit:rowid=""  d
	..s ContractDR=$P(^DHCEQContractList(rowid),"^",1)
	..q:($p($g(^DHCEQContract(ContractDR)),"^",24)'=2)		;过滤非审核状态合同记录
	..q:($p($g(^DHCEQContract(ContractDR)),"^",39)'=1)		;过滤非保修合同
	..s LastDate=$p($g(^DHCEQContract(ContractDR)),"^",11)
	..s NextDate=$p($g(^DHCEQContract(ContractDR)),"^",12)
	..q:NextDate<Date		;保修截止日期已经过期则不显示
	..s GuaranteeMonths=##Class(web.DHCEQCommon).DateDiffInt("m",LastDate,NextDate)
	..s GuaranteeTimes=$p($g(^DHCEQContract(ContractDR)),"^",55)
	..s WarnDaysNum=$p($g(^DHCEQContract(ContractDR)),"^",56)
	..s GuaranteeFlag=0
	..q:(GuaranteeMonths="")||(GuaranteeTimes="")
	..i (GuaranteeMonths#GuaranteeTimes)=0 d
	...s SectionMonths=GuaranteeMonths/GuaranteeTimes
	...f Num=1:1:GuaranteeTimes d
	....s GuaranteeDate=##Class(web.DHCEQCommon).DateAddInt("M",Num*SectionMonths,LastDate)
	....i ((Date+WarnDaysNum)>=GuaranteeDate)&&(Date<GuaranteeDate) s GuaranteeFlag=1
	..e  d
	...s SectionDays=(NextDate-LastDate)/GuaranteeTimes
	...f Num=1:1:GuaranteeTimes d
	....s GuaranteeDate=LastDate+(Num*SectionDays)
	....i ((Date+WarnDaysNum)>=GuaranteeDate)&&(Date<GuaranteeDate) s GuaranteeFlag=1
	..q:GuaranteeFlag=0
	..s EquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	..s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	..s ContractName=$P($g(^DHCEQContract(ContractDR)),"^",1)
	..s ContractNo=$P($g(^DHCEQContract(ContractDR)),"^",2)
	..s Content="【保修信息】"_EquipName_"("_EquipNo_")保修合同:"_ContractName_"("_ContractNo_")到约定保修时间，请及时处理。"
	..s SendInfoVal="^^^^"_Content_"^"_"15832106002"_"^^^"  //发送人地址需处理
	..s Result=##Class(web.DHCEQMessageSendInfo).AddData(SendInfoVal)
	..s ^DHCEQLog("Job",Node,Date,"Result",ContractDR)=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// add by czf 2021-06-17 1983571
/// 转移单科室接收超过时间自动审核
/// d ##Class(web.DHCEQJob).AutoAuditStoreMove()
ClassMethod AutoAuditStoreMove()
{
	new Date,Time,Node,SMFromLocDR,SMDR,ApproveInfoID,ApproveListDR,ApproveSetDR,ActionDR,ApproveDate,ApproveFlowDR,ApproveRoleDR,ApproveStepDR,ApproveTime
	new TimeDiff,ApproveVal,AuditUser,AuditOpinion,Result
	s SysConfirmTime=##class(web.DHCEQCommon).GetSysInfo("302015")
	i +SysConfirmTime'=0
	{
		s Date=$p($H,",",1)
		s Time=$p($H,",",2)
		s Node="AutoAuditStoreMove"
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		
		s SMFromLocDR=0
		f  s SMFromLocDR=$o(^DHCEQStoreMove(0,"StatusFromLoc","1",SMFromLocDR)) q:SMFromLocDR=""  d
		.s SMDR=""
		.f  s SMDR=$o(^DHCEQStoreMove(0,"StatusFromLoc","1",SMFromLocDR,SMDR)) q:SMDR=""  d
		..q:$p($g(^DHCEQStoreMove(SMDR)),"^",27)="Y"
		..s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID","14",SMDR,""))
		..q:ApproveInfoID=""
		..s ApproveSetDR=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",3)
		..q:ApproveSetDR=""
		..s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code","Move_Receive",0))
		..q:ActionDR=""
		..s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))	//获取科室接收审批流设置
		..q:ApproveFlowDR=""
		..s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",2)
		..s ApproveStepDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",3)
		..q:(ApproveRoleDR="")||(ApproveStepDR="")
		..q:$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)'=ApproveStepDR	//过滤下一步审核非接收科室确认的单据
		..s ApproveListDR=$o(^DHCEQApproveList(0,"Source","14",SMDR,""),-1)
		..q:ApproveListDR=""
		..s ApproveDate=$p($g(^DHCEQApproveList(ApproveListDR)),"^",7)
		..s ApproveTime=$p($g(^DHCEQApproveList(ApproveListDR)),"^",8)
		..s TimeDiff=##Class(web.DHCEQCommon).TimeDiff(ApproveDate,ApproveTime,Date,Time)
		..q:$p(TimeDiff,",",1)<SysConfirmTime*24*3600  //SysConfirmTime天内没处理单据不做处理
		..s AuditUser=1
		..s AuditOpinion="系统自动确认"
		..s ApproveVal=SMDR_"^^^^^^^^"_AuditUser_"^^^^"_AuditOpinion_"^"
		..s Result=##Class(web.DHCEQ.EM.BUSStoreMove).AuditData(ApproveVal, ApproveRoleDR, ApproveStepDR, "","Move_Receive")
		..s ^DHCEQLog("Job",Node,Date,"Result",SMDR)=Result
		
		s ^DHCEQLog("Job",Node,Date,"End")=$H
	}
}

/// add by czf 2023-03-09
/// 同步科室
/// d ##class(web.DHCEQJob).SyntaxDepartment()
ClassMethod SyntaxDepartment()
{
	;his科室同步
	s SQLCODE=0
	s CTLocRowID=0
	f  s CTLocRowID=$o(^CTLOC(CTLocRowID)) q:CTLocRowID=""  d
	.s DeptRowID=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID",1,CTLocRowID,""))
	.q:DeptRowID'=""
	.s CTLocCode=$p($g(^CTLOC(CTLocRowID)),"^",1)
	.s CTLocDesc=$p($g(^CTLOC(CTLocRowID)),"^",2)
	.s CTLocHospDR=$p($g(^CTLOC(CTLocRowID)),"^",22)
	.&SQL(INSERT INTO SQLUSER.DHC_EQCDepartment(Dept_Code,Dept_Desc,Dept_LeaderUserDR,Dept_ContactsUserDR,Dept_OrganizeType,Dept_OrganizeID,Dept_DeptType,Dept_ExType,Dept_ExID,Dept_ExDesc,Dept_ActiveFlag,Dept_InvalidFlag) Values(:CTLocCode,:CTLocDesc,'1','1','1',:CTLocHospDR,'1','1',:CTLocRowID,:CTLocDesc,'Y','N'))
	.q:SQLCODE'=0
	
	;科室类型同步
	s DeptRowID=0
	f  s DeptRowID=$o(^DHCEQCCode("DHCEQCDepartment",DeptRowID))  q:DeptRowID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCDepartment",DeptRowID)),"^",19)="Y"
	.s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",DeptRowID,""))
	.i (LTRowID="") d
	..&SQL(INSERT INTO SQLUSER.DHC_EQCLocType(LT_type,LT_LocDR) values ('2',:DeptRowID))
	..q:SQLCODE
	
	q SQLCODE
}

/// add by czf 2023-03-17
/// 同步用户
/// d ##class(web.DHCEQJob).SyntaxUser()
ClassMethod SyntaxUser()
{
	s SQLCODE=0
	s SSUserRowID=0
	f  s SSUserRowID=$o(^SSU("SSUSR",SSUserRowID)) q:SSUserRowID=""  d
	.s EQUserRowID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",SSUserRowID,""))
	.q:EQUserRowID'=""
	.&SQL(INSERT INTO SQLUSER.DHC_EQCUser (U_LoginName,U_LogoinPassword,U_Name,U_DefaultLocDR,U_GroupDR,U_ExType,U_ExID,U_ActiveFlag) SELECT SSUSR_Initials,SSUSR_Password,SSUSR_Name,SSUSR_DefaultDept_DR,SSUSR_Group,'1',SSUSR_RowId,'Y' FROM SQLUSER.SS_User where SSUSR_RowID=:SSUserRowID)
	.q:SQLCODE'=0
	.s URowID=$g(%ROWID)
	.q:URowID=""
	.s UDeptDR=$p($g(^DHCEQCCode("DHCEQCUser",URowID)),"^",14)
	.q:UDeptDR=""
	.s NewDeptDR=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",1,UDeptDR,0))
	.q:NewDeptDR=""
	.s OrganizeType=0
	.s OrganizeID=+$p($g(^CTLOC(UDeptDR)),"^",22)
	.i OrganizeID>0 s OrganizeType=1
	.&SQL(Update SQLUSER.DHC_EQCUser Set U_DefaultLocDR=:NewDeptDR,U_OrganizeType=:OrganizeType,U_OrganizeID=:OrganizeID Where U_RowID=:URowID)
	.q:SQLCODE'=0
	
	q "ok"
}

}
