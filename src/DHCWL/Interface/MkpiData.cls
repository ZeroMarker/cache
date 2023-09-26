/// 	指标系统标准接口：指标数据接口
/// 	PartI:	定义了指标数据的生成，删除，获取，写入，更新几种标准接口方法
/// 	PartII:	定义了指标数据任务的设置、获取，以及指标执行日常任务的方法
/// 	PartIII:	定义了指标数据中用到的一些数据转换方法
Class DHCWL.Interface.MkpiData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	生成给定开始、结束日期区间的指标列表的数据。
/// Table:			
/// Input:			kpiList:指标的Code或者Id列表，多个指标间用英文逗号隔开；
/// 				fromDate:yyyy-mm-dd格式的开始日期；
/// 				toDate:yyyy-mm-dd格式的结束日期；
/// 				rebuildFlag:重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// Output:			
/// Return:			成功返回0；出错时返回生成数据出错的指标Id列表。
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).CreateKpiData("GetLocFee,16,19","2013-12-06","2013-12-06",1)
/// Other:			
ClassMethod CreateKpiData(kpiList, fromDate, toDate, rebuildFlag = 0, dataFlag = 0) As %Status
{
	n (kpiList,fromDate,toDate,rebuildFlag,dataFlag)
	q:(""=kpiList)||(""=fromDate)||(""=toDate) 0
	s ^||TEMPDHCWLKPIDATA("Login",$j,"fromDate")=fromDate
	s ^||TEMPDHCWLKPIDATA("Login",$j,"toDate")=toDate
	s ^||TEMPDHCWLKPIDATA("Login",$j,"type")="KpiLogDataProcess"
	s ^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction")="##class(DHCWL.Interface.MkpiData).CreateKpiData("_fromDate_","_toDate_","_kpiList_","_rebuildFlag_")"
	s ^||TEMPDHCWLKPIDATA("Login",$j,"kpiIds")=kpiList
	
	//add by wz.2015-1-5
	/*
	s loginOperator=""
	i $d(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator")) s loginOperator=$g(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator"))
	s ^TEMPDHCWLKPIDATA("Login",$j,"Operator")=loginOperator	
	*/

	s errorDateString=""
	s kpiList=##class(DHCWL.Interface.MkpiData).ToKpiId(kpiList,",")
	s fromDate=$zdh(fromDate,3), toDate=$zdh(toDate,3)
	s ^TEMPDHCWL("creatKpiDate",dataFlag,"count")=0
	s kpiIdLen=$l(kpiList,",")
	f dateH=fromDate:1:toDate {
		s date=$zd(dateH,3)
		s kpimName=##class(DHCWL.Interface.MkpiData).SwitchDateBySecType(date,"D")
		;i (0=$d(^DHCWL.MKPI.MonthsI("Name"," "_kpimName))) w "您指定的日期尚未加入到指标合理区间内(MonthId)！"
		i (0=$d(^DHCWL.MKPI.MonthsI("Name"," "_kpimName)))  s ^TEMPDHCWL("creatKpiDate",dataFlag)=-1
		q:(0=$d(^DHCWL.MKPI.MonthsI("Name"," "_kpimName)))
		s monthId=$o(^DHCWL.MKPI.MonthsI("Name"," "_kpimName,""))
		//默认加入了对父区间数据的处理
		s result=##class(DHCWL.MKPIService.SetKPIData).SetMultiKPIData(monthId,kpiList,rebuildFlag,,dataFlag)
		i (1'=result) {
			s ^TEMPDHCWL("creatKpiDate",dataFlag)=-1
			if (""=errorDateString) {
				s errorDateString="以下日期列表中的指标数据生成有误，请查证："_date
			}else{
				s errorDateString=errorDateString_", "_date
			}
		}else{
			s ^TEMPDHCWL("creatKpiDate",dataFlag)= +$g(^TEMPDHCWL("creatKpiDate",dataFlag,"count"),0)/((toDate-fromDate+1)*kpiIdLen)
		}
	}
	if (""=errorDateString) {
		w errorDateString,!
	}
	
	s ^||TEMPDHCWLKPIDATA("Login",$j,"ParaOther")=$g(errorDateString)
	d ##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
	d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
	//q 0
}

/// d ##class(DHCWL.Interface.MkpiData).GetKpiDataProgress(113,63)
ClassMethod GetKpiDataProgress(sd, ed, kpiIds, rbflag = 0)
{
	n (sd,ed,kpiIds,rbflag)
	s ^||TEMPDHCWLKPIDATA("Login",$j,"fromDate")=sd	
	s ^||TEMPDHCWLKPIDATA("Login",$j,"toDate")=ed		
	s ^||TEMPDHCWLKPIDATA("Login",$j,"type")="KpiLogDataProcess"	
	s ^||TEMPDHCWLKPIDATA("Login",$j,"CalledFunction")="AddKpiData@DHCWLAutoCreatMKPIData("_sd_","_ed_","_kpiIds_","_rbflag_")"
	s ^||TEMPDHCWLKPIDATA("Login",$j,"kpiIds")=kpiIds
	d ##class(DHCWL.MKPILogin.LoginService).SetDataProcessLog()
	s sysdate=$p($h,",",1)
 	s startDate=$zd((sysdate),3)
 	s endDate=$zd(sysdate,3)
 	s startDate=$zdh((startDate),3)
 	s endDate=$zdh(endDate,3)
	s:+sd>0 startDate=$zdh(sd,3)  ;补数据时就更换为要补日期的起始-1和截止范围-1;61209
	if +ed>0 {
		s ed=$zdh(ed,3)
		s:ed>sysdate ed=sysdate
		s endDate=ed 	
	}
	//把指标编码转换成ID
	s kpiLen=$L(kpiIds,",")
	s newKpiIDs=""
	f kpiInx=1:1:kpiLen {
		s kpiID=$p(kpiIds,",",kpiInx)
		i '$d(^DHCWL.MKPI.MKPID(kpiID)) {
			s kpiID=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiID)
			continue:$g(kpiID)=""
		}
		if newKpiIDs'="" s newKpiIDs=newKpiIDs_","
		s newKpiIDs=newKpiIDs_kpiID
	}
	s kpiIds=newKpiIDs
	//s ^TEMPDHCWL("recordMonIDTotal","monthID")=endDate-startDate+1
	/*if $d(^TEMPDHCWL("KPI","CreatDate","progress","start")) {
		s ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")="-1"
		s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	    s ^DHCWLMKPI(0,"TRACK",+$h,id)="生成数据的方法正在运行中,请勿重复运行："_$zd(date,3)
 	    d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
 	    q
	}*/
	do ##class(DHCWL.util.DHCWLutilKPIDataBar).Start(startDate,endDate)
 	f date=startDate:1:endDate  d
 	.//s ^TEMPDHCWL("recordMonIDCurrent","monthID")=date-startDate+1
 	.do ##class(DHCWL.util.DHCWLutilKPIDataBar).TotalProgressConfig(date)
 	.s ^TEMPDHCWL($j,"CurDay")=date
 	.s sc=##class(DHCWL.MKPIService.SetKPIData).CreatMultiTaskDataSpecialKpi(kpiIds,rbflag)
 	.i sc=0 d
 	..s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	..s ^DHCWLMKPI(0,"TRACK",+$h,id)="指标任务方法：界面手动生成数据，任务日期："_$zd(date,3)
 	do ##class(DHCWL.util.DHCWLutilKPIDataBar).end()
 	d ##class(DHCWL.MKPILogin.LoginService).StopLogRobot()
}

/// Creator:         WK
/// Creator:         2015-11-18
/// Description:     得到维度默认属性的值
/// Table:
/// Input:           dimId:维度ID或维度Code；
///                  dimProParam:维度默认属性执行代码参数  
/// Return:          返回维度默认属性的值
/// HowToUse:        s value=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(113,63)
/// Other:
ClassMethod GetDimPropertyValue(dimId, dimProParam) As %String
{
	n (dimId,dimProParam)
	s dimId=##class(DHCWL.MKPIService.ConfigService).GetDimIdByCode(dimId)
	if (dimId=""){
		q ""
	}
	s dimProCode=""
	s dimProExec=""
	for{
		s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,dimProCode))
		q:dimProCode=""
		s dimProId=""
		s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,dimProCode,dimProId))
		q:dimProId=""
		s activeFlag=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),7,"")
		if (activeFlag="Y"){
			s dimProExec=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),6,"")
			q
		}
	}
	if (dimProExec'=""){
		s dimProExecode="s result=$$"_dimProExec_"("""_dimProParam_""")"
		x dimProExecode
		q result
	}
}

/// Creator:         WK
/// Creator:         2016-01-26
/// Description:     得到维度执行代码
/// Table:
/// Input:           dimId:维度ID或维度Code； 
/// Return:          返回维度执行代码
/// HowToUse:        s value=##class(DHCWL.Interface.MkpiData).GetDimExecode(113)
/// Other:
ClassMethod GetDimExecode(dimId)
{
	n (dimId)
	s dimId=##class(DHCWL.MKPIService.ConfigService).GetDimIdByCode(dimId)
	if (dimId=""){
		q ""
	}
	s dimTypeObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId)
	if (dimTypeObj=""){
		q ""
	}
	s version=##class(DHCWL.MKPIService.VersionPath).GetVersion()
	s BVersion=$p(version,".",1)
	s SVersion=$p(version,".",2)
	if (+BVersion>=4)&&(+SVersion>=2){
		s dimExecode=dimTypeObj.KDTExeCode
	}elseif(+BVersion>4){
		s dimExecode=dimTypeObj.KDTExeCode
	}else{
		s dimExecode=dimTypeObj.KDTEXCode
	}
	do dimTypeObj.%Close()
	q dimExecode
}

/// Creator:         WK
/// Creator:         2015-11-18
/// Description:     激活所有指标任务
/// Table:
/// Input:            
/// Return:          
/// HowToUse:        d ##class(DHCWL.Interface.MkpiData).ActivateKpiTask()
/// Other:
ClassMethod ActivateKpiTask()
{
	s taskId=""
	s wrongFlag=0
	tstart
	for{
		s taskId=$o(^DHCWL.MKPI.CreatDataTaskD(taskId))
		q:taskId=""
		set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
		if creatDataTaskObj=""{
			s wrongFlag=1
			q
		}
		set creatDataTaskObj.DTaskActiveFlag="Y"
		s result=creatDataTaskObj.%Save()
		if result'=1{
			s wrongFlag=1
			q
		}
	}
	if wrongFlag=1{
		w "ERROR"
		trollback
	}
	else{
		tcommit
	}
	q
}

/// Creator:         WK
/// Creator:         2015-11-18
/// Description:     不激活所有指标任务
/// Table:
/// Input:            
/// Return:          
/// HowToUse:        d ##class(DHCWL.Interface.MkpiData).UnActivateKpiTask()
/// Other:
ClassMethod UnActivateKpiTask()
{
	s taskId=""
	s wrongFlag=0
	tstart
	for{
		s taskId=$o(^DHCWL.MKPI.CreatDataTaskD(taskId))
		q:taskId=""
		set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
		if creatDataTaskObj=""{
			s wrongFlag=1
			q
		}
		set creatDataTaskObj.DTaskActiveFlag="N"
		s result=creatDataTaskObj.%Save()
		if result'=1{
			s wrongFlag=1
			q
		}
	}
	if wrongFlag=1{
		w "ERROR"
		trollback
	}
	else{
		tcommit
	}
	q
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	删除给定开始、结束日期区间内的指标列表的指标数据。
/// Table:			
/// Input:			kpiList:指标的Code或者Id列表，多个指标间用英文逗号隔开；
/// 				fromDate:yyyy-mm-dd格式的开始日期；
/// 				toDate:yyyy-mm-dd格式的结束日期；
/// 				secType:删除指标数据的区间类型。该参数为空，则删除其所有（状态为激活的）父区间类型的数据；否则，只删除用户指定区间类型下（如：D、M、Q、Y）下的数据。
/// Output:			
/// Return:			删除成功返回0；反则返回删除出错的指标Id列表
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).DeleteKpiData("3776","2018-01-01","2018-07-10","")
/// Other:			
ClassMethod DeleteKpiData(kpiList, fromDate, toDate, secType = "") As %Status
{
	n (kpiList,fromDate,toDate,secType)
	q:(""=kpiList) "请指定要删除数据的指标！"
	q:(""=fromDate)||(""=toDate) "请指定要删除数据的开始，结束日期！"
	s kpiList=##class(DHCWL.Interface.MkpiData).ToKpiId(kpiList,",")
	s errorKpiList=0
	
	s fDate=$zdh(fromDate,3), tDate=$zdh(toDate,3)
	f curDate=fDate:1:tDate {
		s date=$zd(curDate,3)
		i (""'=secType) {
			s kpimName=##class(DHCWL.Interface.MkpiData).SwitchDateBySecType(date,secType)
			s secTypeId=$o(^DHCWL.MKPI.SectionI("SecCode",secType,""))
			Continue:(0=$d(^DHCWL.MKPI.MonthsI("SectionFlagName",secTypeId,kpimName)))
			s monthId=""
			s monthId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",secTypeId,kpimName,monthId))
			s numOfKpi=$l(kpiList,",")
			f current=1:1:numOfKpi {
				s kpiId=$p(kpiList,",",current)
				Continue:'$d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId))
				s taskRecordId="", taskRecordId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId,taskRecordId))
				TSTART
				s kpiDataStatus=##class(DHCWL.MKPIService.SetKPIData).DeleteKPIData(taskRecordId)
				&sql(delete from DHCWL_MKPI.DHCWLMKPIData where id=:taskRecordId)
				i (1=$g(kpiDataStatus))&&(0=$g(SQLCODE)) TCOMMIT
				e  TROLLBACK
				
				i (1'=$g(kpiDataStatus))||(0'=$g(SQLCODE)) s errorKpiList=$g(errorKpiList)_","_kpiId
			}
		}elseif(""=secType) {
			s numOfKpi=$l(kpiList,",")
			f current=1:1:numOfKpi {
				s kpiId=$p(kpiList,",",current)
				s kpiDefaultSecDr=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
				Continue:(""=kpiDefaultSecDr)
				d ##class(DHCWL.Interface.MkpiData).GetKpiSecIdList(kpiId,.sec)
				///	从指标默认所属的区间类型开始，删除其所有父区间的数据
				s parentSecDr=kpiDefaultSecDr
				do{
					s parentSecType=$lg(^DHCWL.MKPI.SectionD(parentSecDr),2)
					s kpimName=##class(DHCWL.Interface.MkpiData).SwitchDateBySecType(date,parentSecType)
					s monthId=$o(^DHCWL.MKPI.MonthsI("Name"," "_kpimName,""))
					i ((""'=monthId)&&($d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId)))) {
						s taskRecordId="", taskRecordId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId,taskRecordId))
						TSTART
						s kpiDataStatus=##class(DHCWL.MKPIService.SetKPIData).DeleteKPIData(taskRecordId)
						&sql(delete from DHCWL_MKPI.DHCWLMKPIData where id=:taskRecordId)
						i (1=$g(kpiDataStatus))&&(0=$g(SQLCODE)) TCOMMIT
						e  TROLLBACK
						i (1'=$g(kpiDataStatus))||(0'=$g(SQLCODE)) s errorKpiList=$g(errorKpiList)_","_kpiId
					}
					s parentSecDr=sec(parentSecDr,"Parent")	;获取当前区间类型的父区间类型
				}while(""'=parentSecDr)
			}
		}
	}
	i (0'=errorKpiList) s errorKpiList=$e(errorKpiList,3,$l(errorKpiList))
	
	//s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataProcess",kpiId)
 	//q:(1'=shouldBeLogged)
 	s login("MKPIIdList")=kpiList
	s login("CalledFunction")="##class(DHCWL.Interface.MkpiData).DeleteKpiData()"
	s login("ParaDateScope")="fromDate："_$g(fromDate)_"; toDate："_$g(toDate)
	s login("ParaOther")="secType："_$g(secType)
	
 	//add by wz.2014-12-23
	s loginOperator=""
	i $d(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator")) s loginOperator=$g(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator"))
	s login("Operator")=loginOperator	
	
	i (0'=errorKpiList) s login("OtherContent")="未成功删除以下指标的指标数据："_errorKpiList
	s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 	s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 	s status=loginService.LoginStart("KpiLogDataProcess","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 	s status=loginService.LoginContent(jsonStr)
 	s status=loginService.LoginEnd()
 	
	q errorKpiList
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	根据给定日期范围内的指标参数查询指标数据，该方法返回DataPackage对象，该对象封装了返回的数据，可以通过该对象接口去取需要的数据。
/// Table:			
/// Input:			fromDate,toDate:yyyy-mm-dd格式或yyyy-mm或yyyy-Qn或yyyy-Y格式类型的日期参数；
/// 				dateType:日期类型，当日期格式统一使用yyyy-mm-dd格式的时候可以通过该参数指定日期类型；
/// 				kpiRule:指标的取数规则；
/// 				filterRule:指标的过滤规则；
/// 				mode:取数模式；
/// 				contractType:数据对比类型。
/// Output:			
/// Return:			ResultSet
/// HowToUse:		s rs=##class(DHCWL.Interface.MkpiData).GetKpiData("2013-04-28","2013-04-28","","30")
/// Other:			rs.Next()不为空时，d rs.%Print()查看值
ClassMethod GetKpiData(fromDate, toDate, dateType = "", kpiRule, filterRule = "", mode = "", contractType = "") As %ResultSet
{
	n (fromDate,toDate,dateType,kpiRule,filterRule,mode,contractType)
	q:(""=fromDate)&&(""=toDate)&&(""=kpiRule) ""
	s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryKpiWithContract")
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule, .arr)
	q:'$d(arr("ID")) rs
	s kpiId="", kpiList=""
	while ($o(arr("ID",kpiId))) {
		s kpiId=$o(arr("ID",kpiId))
		i (""'=kpiList) {
			s kpiList=kpiList_","_kpiId
		}else{
			s kpiList=kpiId
		}
	}
	//2015-3-4.add by wz.不清楚为什么此处要把处理过后的取数规则（没有了维度和属性）作为参数来调用查询函数。
	//如果使用处理后的取数规则，在返回的维度描述中就无法得到指定的维度和属性了。
	//所以，先改成直接使用传入的参数。
	//--d rs.Execute(kpiList,fromDate,toDate,dateType,mode,contractType,filterRule)
	d rs.Execute(kpiRule,fromDate,toDate,dateType,mode,contractType,filterRule)
	q rs
	//q ##class(DHCWL.MKPIService.MKPIQuery).KpiQueryGrideShow(fromDate,toDate,dateType,kpiRule,filterRule,mode,contractType)
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	对指定kpi在指定日期date对应的区间下，当该指标没有数据时，新增该区间下，该指标的数据。新增成功返回1；
/// 					该指标存在数据时，则退出并返回0。该函数会根据指定的日期date格式自动获取区间类型，并且只新增该区间类型下的指标数据。
/// Table:			DHCWL_MKPI.DHCWLMKPIData,DHCWL_MKPI.DHCWLDeptKPIData
/// Input:			kpi:指标Id或Code；
/// 				date:要写入指标数据的日期，其格式应为：yyyy-mm-dd格式或yyyy-mm或yyyy-Qn或yyyy-Y格式。如（2013-12-06,2013-12,2013-Q4,2013-Y形式）
/// 				data:指标数据；
/// Output:			
/// Return:			成功返回1，否则返回0或错误信息。
/// HowToUse:		s data("2")=100, data("1")=60
/// 					w ##class(DHCWL.Interface.MkpiData).WriteKpiData("30","2013-Q4",.data)
/// Other:			
ClassMethod WriteKpiData(kpi, date, ByRef data) As %Status
{
	n (kpi,date,data)
	q:(""=kpi)||(""=date)||(""=$o(data(""))) 0
	q:(0=$d(^DHCWL.MKPI.MonthsI("Name"," "_date))) "日期有误，请查证"
	s kpiId=##class(DHCWL.Interface.MkpiData).ToKpiId(kpi,",")
	s monthId="", monthId=$o(^DHCWL.MKPI.MonthsI("Name"," "_date,monthId))
	q:$d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId)) "指定的指标在指定日期已有数据，如欲更新请使用UpdateKpiData"
	
	///s kpiNod=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	
	TSTART
	k PLIST
	s PLIST(2)=monthId
	s PLIST(3)=kpiId
	s PLIST(4)=""
	s PLIST(5)=+$h
	s PLIST(6)=""
	&sql(insert into DHCWL_MKPI.DHCWLMKPIData values PLIST())
	s sqlResult1=$g(SQLCODE)
	
	s dataId=%ROWID, sqlResult2=0
	//	删除DHCWL_MKPI.DHCWLDeptKPIData表中对应dataId的原有垃圾数据
	d ##class(DHCWL.MKPIService.SetKPIData).DeleteKPIData(dataId)
	s dim="" f  s dim=$o(data(dim)) q:(dim="")||(0'=sqlResult2)  d
	.k PLIST
	.s PLIST(2)=dataId
	.s PLIST(3)=dim
	.///i (kpiNod="")||(kpiNod=$c(0)) s PLIST(4)=$g(data(dim))
	.///e  s PLIST(4)=$g(data(dim,kpiNod))
	.///q:((PLIST(4)=$c(0)) || (PLIST(4)=""))
	.s PLIST(4)=$g(data(dim)) 
	.&Sql(insert into DHCWL_MKPI.DHCWLDeptKPIData values PLIST())
	.i 0'=$g(SQLCODE) d
	..s sqlResult2=$g(SQLCODE)
	i (0=sqlResult1)&&(0=sqlResult2) TCOMMIT
	e  TROLLBACK
	
	s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataProcess",kpiId)
 	i (1=shouldBeLogged) {
 		s login("MKPIIdList")=kpiId
		s login("CalledFunction")="class(DHCWL.Interface.MkpiData).WriteKpiData()"
		s login("ParaDateScope")="date："_$g(date)
		s login("OtherContent")=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.data)
		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataProcess","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
	
	q (0=sqlResult1)&&(0=sqlResult2)
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	对指定kpi在指定日期date对应的区间下，当该指标有数据时，更新该区间下，该指标的数据。更新成功返回1；
/// 					该指标不存在数据时，则退出并返回0。该函数会根据指定的日期date格式自动获取区间类型，并且只更新该区间类型下的指标数据。
/// Table:			DHCWL_MKPI.DHCWLMKPIData,DHCWL_MKPI.DHCWLDeptKPIData
/// Input:			kpi:指标Id或Code；
/// 				date:要更新指标数据的日期，其格式应为：yyyy-mm-dd格式或yyyy-mm或yyyy-Qn或yyyy-Y格式。如（2013-12-06,2013-12,2013-Q4,2013-Y形式）
/// 				data:指标数据；	
/// Output:			
/// Return:			成功返回1，否则返回0或错误信息。
/// HowToUse:		s data("2")=50, data("1")=100
/// 					w ##class(DHCWL.Interface.MkpiData).UpdateKpiData("30","2013-Q4",.data)
/// Other:			
ClassMethod UpdateKpiData(kpi, date, ByRef data) As %Status
{
	n (kpi,date,data)
	q:(""=kpi)&&(""=date)&&(""=data) 0
	q:(0=$d(^DHCWL.MKPI.MonthsI("Name"," "_date))) "日期有误，请查证"
	s kpiId=##class(DHCWL.Interface.MkpiData).ToKpiId(kpi,",")
	s monthId="", monthId=$o(^DHCWL.MKPI.MonthsI("Name"," "_date,monthId))
	q:'$d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId)) "指定的指标在指定日期没有数据，如欲生成请使用WriteKpiData"
	
	///s kpiNod=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	s mkpiDataId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monthId,kpiId,""))
	s dateTime=$h
	
	TSTART
	&sql(update DHCWL_MKPI.DHCWLMKPIData set MKD_UpdateDate=:dateTime where ID=:mkpiDataId)
	s sqlResult1=$g(SQLCODE)
	
	s sqlResult2=0
	s dim="" f  s dim=$o(data(dim)) q:(dim="")||(0'=sqlResult2)  d
	.q:'$d(^DHCWL.MKPI.DeptKPIDataI("MONDeptData",mkpiDataId," "_dim))
	.s deptKpiDataId=$o(^DHCWL.MKPI.DeptKPIDataI("MONDeptData",mkpiDataId," "_dim,""))
	.///i (kpiNod="")||(kpiNod=$c(0)) s value=$g(data(dim))
	.///e  s value=$g(data(dim,kpiNod))
	.s value=$g(data(dim)) 
	.q:((value=$c(0)) || (value=""))
	.&Sql(update DHCWL_MKPI.DHCWLDeptKPIData set DKPI_Value=:value where ID=:deptKpiDataId)
	.i 0'=$g(SQLCODE) d
	..s sqlResult2=$g(SQLCODE)
	
	i (0=sqlResult1)&&(0=sqlResult2) TCOMMIT
	e  TROLLBACK
	
	s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataProcess",kpiId)
 	i (1=shouldBeLogged) {
 		s login("MKPIIdList")=kpiId
		s login("CalledFunction")="class(DHCWL.Interface.MkpiData).UpdateKpiData()"
		s login("ParaDateScope")="date："_$g(date)
		s login("OtherContent")=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.data)
		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataProcess","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
	
	q (0=sqlResult1)&&(0=sqlResult2)
}

/// 	************************************************指标数据任务**********************************************
/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	获取指标的任务列表。Section为空则获取该指标下各个区间类型的任务。
/// Table:			DHCWL_MKPI.DHCWLCreatDataTask, DHCWL_MKPI.DHCWLSection
/// Input:			kpi:指标的Code或者Id；
/// 				section:任务区间类型的Code或者Id，默认为空。
/// Output:			
/// Return:			objList:任务对象列表。
/// HowToUse:		s list=##class(DHCWL.Interface.MkpiData).GetKpiTask("GetLocFee")
/// 					s obj=list.GetAt(1), w obj.DTaskExcuteCode
/// Other:			
ClassMethod GetKpiTask(kpi, section = "") As %ListOfObjects
{
	n (kpi,section)
	q:(""=kpi) ""
	s objList=##Class(%Library.ListOfObjects).%New()
	
	s kpi=##class(DHCWL.Interface.MkpiData).ToKpiId(kpi,",")
	i (""'=section){
		i $d(^DHCWL.MKPI.SectionI("SecCode",section)) s secId=$o(^DHCWL.MKPI.SectionI("SecCode",section,""))
		e  i $d(^DHCWL.MKPI.SectionD(section)) s secId=section
		e  s secId=""
		s activeFlag="" 
		do{
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpi,activeFlag))
			q:(""=activeFlag)
			s kpiTaskId=""
			do {
				s kpiTaskId=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpi,activeFlag,kpiTaskId))
				q:(""=kpiTaskId)
				d objList.Insert(##class(DHCWL.MKPI.CreatDataTask).%OpenId(kpiTaskId))
			}while(""'=kpiTaskId)
		}while(""'=activeFlag)
	}
	i (""=section){
		s activeFlag=""
		do{
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpi,activeFlag))
			q:(""=activeFlag)
			s kpiTaskId=""
			do {
				s kpiTaskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpi,activeFlag,kpiTaskId))
				q:(""=kpiTaskId)
				s obj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(kpiTaskId)
				//w obj.DTaskExcuteCode,!
				d objList.Insert(obj)
				
			}while(""'=kpiTaskId)
		}while(""'=activeFlag)
	}
	q objList
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	从指标的给定区间类型开始添加或修改任务执行代码和任务状态标志，给定区间的粒度必须大于等于指标的区间。
/// Table:			DHCWL_MKPI.DHCWLCreatDataTask, DHCWL_MKPI.DHCWLSection
/// Input:			kpi:指标的Code或者Id；
/// 				section:任务区间类型的Code或者Id，默认为空；
/// 				taskExeCode:任务执行代码，若为空则使用该区间下默认的执行代码；
/// 				status:任务的激活状态标志。
/// Output:			
/// Return:			rtnValue:成功返回1；否则返回0或错误原因。
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).SetKpiTask("30","D","CreatYesterdayData^DHCWLAutoCreatMKPIData1","Y")
/// Other:				
ClassMethod SetKpiTask(kpi, section = "", taskExeCode = "", status = "") As %Status
{
	n (kpi,section,taskExeCode,status)
	q:(""=kpi) 0
	
	s kpi=##class(DHCWL.Interface.MkpiData).ToKpiId(kpi,",")
	s rtnValue=""
	//	取系统配置中指标任务添加时默认激活标志。如不为空，则用之；如为空，则设定activeFlag = “N” 
	s sysVarValue=""
	i (""=status)&&($d(^DHCWL.MKPI.SysVariablesI("CodeDateTime","DefaultKpiTaskActiveFlag"))){
		s sysVarDate=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime","DefaultKpiTaskActiveFlag",""),-1)
		s sysVarTime=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime","DefaultKpiTaskActiveFlag",sysVarDate,""),-1)
		s sysVarId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime","DefaultKpiTaskActiveFlag",sysVarDate,sysVarTime,""),-1)
		s sysVarValue=$lg(^DHCWL.MKPI.SysVariablesD(sysVarId),4)
	}
	//	如果指定了任务激活状态，则使用指定的值；否则，如果系统配置中指定了默认的任务激活状态，用系统配置；否则，置为"N"。
	i (""='status){
		s status=status
	}elseif(""'=sysVarValue){
		s status=sysVarValue
	}else{
		s status="N"
	}
	
	//	给定区间不为空，则取该区间下默认执行代码；给定区间为空，则从指标自身区间，依次沿其父区间添加或修改任务，其中执行代码取各相应区间下默认的执行代码
	
	//	.sec为指标的区间类型Id双向链表，父区间节点"Parent"，子区间节点"Child"
	d ##class(DHCWL.Interface.MkpiData).GetKpiSecIdList(kpi,.sec)
	s kpiTaskSecId="", kpiTaskSection=""
	i (""'=section){
		//	从section所指定区间开始，依次对其父区间添加或更新指标任务
		//	如果section是区间类型Code，则将其转化为Id
		i $d(^DHCWL.MKPI.SectionI("SecCode",section)) {
			s secId=$o(^DHCWL.MKPI.SectionI("SecCode",section,""))
		}elseif ($d(^DHCWL.MKPI.SectionD(section))) {
			s secId=section
		}
		s childSecId=sec(secId,"Child")
		q:(""=childSecId) "section所指定区间的子区间没有指标任务，请查证"
		q:'($d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",childSecId,kpi))) "section所指定区间的子区间没有指标任务，请查证"
		s kpiTaskSecId=childSecId
		s kpiTaskSection=$lg(^DHCWL.MKPI.SectionD(childSecId),2)
	}else{
		//	从kpi的区间开始，依次对其父区间添加或更新指标任务
		s kpiDefaultSecDr=$lg(^DHCWL.MKPI.MKPID(kpi),11)
		s kpiTaskSecId=kpiDefaultSecDr
		s kpiTaskSection=$lg(^DHCWL.MKPI.SectionD(kpiTaskSecId),2)
	}
	q:((""=kpiTaskSecId)||(""=kpiTaskSection)) "指标默认区间为空，请查证！"
	s kpiTaskSecId=sec(kpiTaskSecId,"Parent")
	s childSecId=sec(kpiTaskSecId,"Child"), parentSecId=sec(kpiTaskSecId,"Parent")
	do{
		//s exeCodeId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType","TAS",kpiTaskSection,""))
		//q:(""=exeCodeId)
		s kpiTaskSection=$lg(^DHCWL.MKPI.SectionD(kpiTaskSecId),2)
		s exeCodeId="", taskExeCodeDr=""
		do{
			s exeCodeId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType","TAS",kpiTaskSection,exeCodeId))
			q:(""=exeCodeId)
			s defaultExeCodeFlag=$lg(^DHCWL.MKPI.ExecuteCodeD(exeCodeId),12)	;筛选出执行代码子类中默认的执行代码
			q:("Y"'=defaultExeCodeFlag)&&(""=$g(taskExeCode))	;如果是默认执行代码，那执行代码不许为空
			s exeCode=$lg(^DHCWL.MKPI.ExecuteCodeD(exeCodeId),3)
			q:(""'=$g(taskExeCode))&&(exeCode'=$g(taskExeCode))
			s taskExeCodeDr=exeCodeId	;因执行代码子类中默认的执行代码的唯一性，故而taskExeCodeDr有值的话，只会有一个值
		}while(""'=exeCodeId)
		q:(""=taskExeCodeDr)
		i $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",childSecId,kpi)){
			if '$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",kpiTaskSecId,kpi)){
				//	新增
				s sqlResult=##class(DHCWL.MKPIService.ExcCodeService).Insert(kpi,kpiTaskSecId,status,kpiTaskSection,taskExeCodeDr)
				i (0'=sqlResult) s rtnValue=sqlResult
			}else{
				//	更新
				q:(""=status)&&(""=taskExeCodeDr)
				s sqlResult=##class(DHCWL.MKPIService.ExcCodeService).Update(kpi,kpiTaskSecId,status,kpiTaskSection,taskExeCodeDr)
				i (0'=sqlResult) s rtnValue=sqlResult
			}
		}
		s childSecId=sec(kpiTaskSecId,"Child"), parentSecId=sec(kpiTaskSecId,"Parent")
		s kpiTaskSecId=parentSecId
	}while((""'=kpiTaskSecId)||(""=taskExeCodeDr))
	
	q:(""=rtnValue) 1
	q rtnValue
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	根据开始日期和结束日期生成所有的指标数据，主要用在挂指标任务中。该方法也应该有容错处理，一个指标任务出差不应该影响其他指标任务的执行。
/// Table:			
/// Input:			fromDate：yyyy-mm-dd格式的开始日期；
/// 				toDate：yyyy-mm-dd格式的结束日期；
/// 				rebuildFlag：重生数据标志，如果为1则在有数据的情况下会删除已有数据然后重新生成，如果没有数据则直接生成。如果为0则在有数据的情况下略过。
/// Output:			
/// Return:			
/// HowToUse:		d ##class(DHCWL.Interface.MkpiData).ExecuteTaskMulEveryday("2013-12-06","2013-12-06",0)
/// Other:			
ClassMethod ExecuteTaskMulEveryday(fromDate = "", toDate = "", rebuildFlag = 0)
{
	n (fromDate,toDate,rebuildFlag)
	d ExecuteTaskMulEveryday^DHCWLAutoCreatMKPIData(fromDate,toDate,rebuildFlag)
	q
}

/// 	************************************************数据转换**********************************************
/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	将指标Id(或Code)串转化为Id串,去掉其中非法的指标Id(或Code)
/// Table:			
/// Input:			kpiList:指标的Id或Code串，可能其中既有Id，又有Code；
/// 					delimiter:分隔符。相邻Id或者Code之间的分隔符。
/// Return:			指标Id串，沿用原来串分隔符分隔
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).ToKpiId("1,3,2343dfa,GetLocFee,ls33l",",")
ClassMethod ToKpiId(kpiList As %String, delimiter As %String) As %String
{
	n (kpiList,delimiter)
	q:(""=kpiList)||(""=delimiter) ""
	s num=$l(kpiList,delimiter), newKpiList=""
	f current=1:1:num d
	.s currentKpi=$p(kpiList,delimiter,current)
	.q:('$d(^DHCWL.MKPI.MKPID(currentKpi)))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(currentKpi,"U"))))
	.i $d(^DHCWL.MKPI.MKPID(currentKpi)) s currentKpi=currentKpi
	.i $d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(currentKpi,"U"))) s currentKpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(currentKpi)
	.i ""=$g(newKpiList) s newKpiList=currentKpi
	.e  s newKpiList=$g(newKpiList)_delimiter_currentKpi
	q newKpiList
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	将指标Id(或Code)串转化为Code串,去掉其中非法的指标Id(或Code)
/// Table:			
/// Input:			kpiList:指标的Id或Code串，可能其中既有Id，又有Code；
/// 					delimiter:分隔符。相邻Id或者Code之间的分隔符。
/// Return:			指标Code串，沿用原来串分隔符分隔		
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).ToKpiCode("1,3,2343dfa,GetLocFee,ls33l",",")
ClassMethod ToKpiCode(kpiList As %String, delimiter As %String) As %String
{
	n (kpiList,delimiter)
	q:(""=kpiList)||(""=delimiter) ""
	s num=$l(kpiList,delimiter), newKpiList=""
	f current=1:1:num d
	.s currentKpi=$p(kpiList,delimiter,current)
	.q:('$d(^DHCWL.MKPI.MKPID(currentKpi)))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(currentKpi,"U"))))
	.i $d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(currentKpi,"U"))) s currentKpi=currentKpi
	.i $d(^DHCWL.MKPI.MKPID(currentKpi)) s currentKpi=$lg(^DHCWL.MKPI.MKPID(currentKpi),2)
	.i ""=$g(newKpiList) s newKpiList=currentKpi
	.e  s newKpiList=$g(newKpiList)_delimiter_currentKpi
	q newKpiList
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	将日期date转化为secType所指定的区间类型下的日期。如："2013-12-06",secType取Y时,返回"2013-Y";
/// 					M:"2013-12";Q:"2013-Q4"
/// Table:			
/// Input:			date:yyyy-mm-dd格式的日期数据；
/// 					secType:区间类型代码，如：D,M,Q,Y。
/// Return:			secType类型下的日期
/// HowToUse:		w ##class(DHCWL.Interface.MkpiData).SwitchDateBySecType("2013-12-06","Q")
ClassMethod SwitchDateBySecType(date, secType) As %String
{
	n (date,secType)
	q:(""=date)||(""=secType) ""
	s year=$p(date,"-",1), month=$p(date,"-",2), day=$p(date,"-",3)
	s dateH=$zdh(date,3)	;检查日期是否合法
	q:("D"=secType) date
	q:("M"=secType) year_"-"_month
	;q:("Q"=secType) year_"-Q"_$Normalize(month/3+0.4,0)
	s quarter=##class(DHCWL.MKPIService.DateUtil).IntegerDiv(month,3)
	q:("Q"=secType) year_"-Q"_quarter
	q:("Y"=secType) year_"Y"
	q date
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	构造指标(Id或Code)区间及其所有父区间构成的双向链表，存于sec数组中
/// 					其中用sec(currentSecId,"Parent")的值记录当前区间（currentSecId为当前区间Id）的
/// 					父区间Id；sec(currentSecId,"Child")的值记录子区间Id。如果相关父区间、子区间不存在，则存空值
/// Table:			
/// Input:			kpi:指标的Id或Code；
/// 					sec:用来存储返回值(区间双向链表)的数组。
/// Return:			
/// HowToUse:		d ##class(DHCWL.Interface.MkpiData).GetKpiSecIdList("GetLocFee",.sec)
ClassMethod GetKpiSecIdList(kpi, ByRef sec)
{
	n (kpi,sec)
	k sec
	q:""=kpi ""
	s kpi=##class(DHCWL.Interface.MkpiData).ToKpiId(kpi,",")
	s kpiDefaultSecDr=$lg(^DHCWL.MKPI.MKPID(kpi),11)	;指标的区间类型Id
	
	s secIdStr="", parentSecDr="", currentSecDr=kpiDefaultSecDr, childSecDr=""
	do{
		s sec(currentSecDr,"Child")=childSecDr
		s childSecDr=currentSecDr
		s parentSecDr=$lg(^DHCWL.MKPI.SectionD(currentSecDr),8)	;获取当前区间类型的父区间类型
		s sec(currentSecDr,"Parent")=parentSecDr
		s currentSecDr=parentSecDr
	}while(""'=currentSecDr)
	q
}

/// Creator:		wz
/// CreatDate:		2015-02-02
/// Description:	根据指标的“创建者”，“类型”，“区间”查询指标ID或编码
/// Input:
/// 				retType	类型：要得到ID或CODE
/// 				user	创建者
/// 				cate		类型
/// 				sectionFlag		区间
/// Table:			
/// 				
/// Return:			
/// HowToUse:		d ##class(DHCWL.Interface.MkpiData)SearchKPIByCTS(,"wz","")
ClassMethod SearchKPIByCTS(retType = "ID", user = "", cate = "", sectionFlag = "") As %String
{
	n (retType,user,cate,sectionFlag)
	s retData=""
	if retType="" s retType="ID"
	s searchcnd=""
	if ##class(DHCWL.util.StringUtil).Trim(user)'="" s searchcnd="MKPI_User='"_user_"'"
	if ##class(DHCWL.util.StringUtil).Trim(cate)'="" {
		if ##class(DHCWL.util.StringUtil).Trim(searchcnd)'="" s searchcnd=searchcnd_" and "
		s searchcnd=searchcnd_"MKPI_Cate->MKPIFL_Name='"_cate_"'"
	}
	if ##class(DHCWL.util.StringUtil).Trim(sectionFlag)'="" {
		if ##class(DHCWL.util.StringUtil).Trim(searchcnd)'="" s searchcnd=searchcnd_" and "
		s searchcnd=searchcnd_"MKPI_SectionFlag->sec_name='"_sectionFlag_"'"
	}

	s sql="select ID,MKPI_Code from DHCWL_MKPI.DHCWLMKPI "
	if ##class(DHCWL.util.StringUtil).Trim(searchcnd)'="" s sql=sql_"where "_searchcnd

	s rs=##class(%Library.ResultSet).%New()
	s st=rs.Prepare(sql) if ($$$ISERR(st)) goto ErrorGetSearched
	s st=rs.Execute()  if ($$$ISERR(st)) goto ErrorGetSearched
	While(rs.Next()){
		if retData'="" s retData=retData_","
		if retType="ID" s retData=retData_rs.Get("ID")
		else  if retType="CODE" s retData=retData_rs.Get("MKPI_Code")
	}
	d rs.Close()


	q retData
ErrorGetSearched

	q ""
}

/// Creator：      	王峥
/// CreatDate：    	2015-5-5
/// Description:： 	通过维度取数规则，得到维度属性值
/// Table：       	
/// Input：          dimRule：
/// 						格式：基础维度编码A:维度属性1^维度属性2,基础维度编码B:维度属性1^维度属性2^维度属性3
/// Output：        dimType:维度类型
/// 					dimIDV:维度ID
/// 					dimProV:维度属性值
/// 				
/// Return：         
/// Others：        
/// d ##class(%ResultSet).RunQuery("DHCWL.Interface.MkpiData","QryDimValuesByDimType","HosAll:AllHosDesc")
Query QryDimValuesByDimType(dimRule As %String) As %Query(ROWSPEC = "dimType:%String,dimIDV:%String,dimProV:%String") [ SqlProc ]
{
}

ClassMethod QryDimValuesByDimTypeExecute(ByRef qHandle As %Binary, dimRule As %String) As %Status
{
	n (qHandle,dimRule)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TEMPDHCWL($j)
	K ^TEMPDHCWLCode($j)
	i ($g(dimRule)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
 	//解析维度规则
 	d ##class(DHCWL.MKPIService.SetKPIData).ResovleDimRlue(dimRule,.resolved)
 	;resolved（"$DIMPARAM",基础维度编码，维度属性编码)=维度属性在基础维度中的位置
 	s dimType=""
 	f {
		s dimType=$o(resolved("$DIMPARAM",dimType)) 	
	 	q:dimType=""
	 	
	 	s dimTypeCode=$SYSTEM.SQL.ALPHAUP(dimType)
	 	//得到维度类型的ID
	 	s dimTypeID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimTypeCode,""))
	 	continue:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID))
	 	//得到维度类型的执行代码
	 	s typeExeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),9)
	 	continue:$g(typeExeCode)=""
	 	
	 	s count=0
 		s execCode="s count=$$"_typeExeCode_"()"
		x execCode
		
		f inx=0:1:count-1  {
			s itemList=$g(^TEMPDHCWLCode($j,inx))
			//维度的ID值
			s dimID=$p(itemList,"^",1)
			
			s dimProCode=""
			s dimProV=""
			f {
				//维度属性编码
				s dimProCode=$o(resolved("$DIMPARAM",dimType,dimProCode))
				q:dimProCode=""
				s dimProCodeUP=$SYSTEM.SQL.ALPHAUP(dimProCode)
				s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,dimProCodeUP,""))
				continue:$g(dimProID)=""
				//属性执行代码
				s proExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),6)
				continue:$g(proExeCode)=""
				
				if (proExeCode [ "AllHos"){
					s proExeCode=##class(DHCWL.util.StringUtil).Trim(proExeCode)
					s excString="s dimPro=$$"_proExeCode_"()"
				}else{
					s excString="s dimPro=$$"_proExeCode_"("""_dimID_""")"
				}
				x excString	
				
				s dimProVPos=resolved("$DIMPARAM",dimType,dimProCode)
				s $p(dimProV,",",dimProVPos)=dimPro
			}
			s Data=$lb($g(dimType),$g(dimID),$g(dimProV))
			d OuputRow			
 		}
	
 	}
 
	k ^TEMPDHCWL($j)
	k ^TEMPDHCWLCode($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
OuputRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryDimValuesByDimTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDimValuesByDimTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDimValuesByDimTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDimValuesByDimTypeExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      	wk
/// CreatDate：    	2016-02-25
/// Description:： 	通过维度取数规则，得到基础维度、维度属性值
/// Table：       	
/// Input：          dimRule：
/// 						格式：基础维度编码,基础维度编码:维度属性1^维度属性2
/// Output：        dimType:维度类型.维度属性或维度类型
/// 					dimIDV:维度值
/// 					dimProV:解析后维度属性值或基础维度值
/// 				
/// Return：         
/// Others：        
/// d ##class(%ResultSet).RunQuery("DHCWL.Interface.MkpiData","QryDimValues","CTLOC:LocDesc^LocHospid")
Query QryDimValues(dimRule As %String, dimFilter As %String) As %Query(ROWSPEC = "dimType:%String,dimIDV:%String,dimProV:%String") [ SqlProc ]
{
}

ClassMethod QryDimValuesExecute(ByRef qHandle As %Binary, dimRule As %String, dimFilter As %String = "") As %Status
{
	n (qHandle,dimRule,dimFilter)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TEMPDHCWL($j)
	K ^TEMPDHCWLCode($j)
	K ^||TEMPDHCWL("exeCodeError",$J)
	s $ET="d ##class(DHCWL.Interface.MkpiData).RunError()"
	s errorFlag=0
	i ($g(dimRule)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	i ($p(dimRule,",",2)'="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//解析维度规则
 	d ##class(DHCWL.MKPIService.SetKPIData).NewResovleDimRlue(dimRule,.resolved)
 	;resolved（"$DIMPARAM",基础维度编码，维度属性编码)=维度属性在基础维度中的位置
 	s dimType=""
 	f {
		s dimType=$o(resolved("$DIMPARAM",dimType)) 	
	 	q:dimType=""
	 	k map
	 	if (dimFilter'=""){
	 		s filter=##class(DHCWL.MKPIService.Base.Filter).%New()
	 		s map(dimType)=dimType
	 		d filter.ResovleFilterRule(dimFilter,.map)
	 	}
	 	s dimTypeCode=$SYSTEM.SQL.ALPHAUP(dimType)
	 	//得到维度类型的ID
	 	s dimTypeID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimTypeCode,""))
	 	continue:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID))
	 	//得到维度类型的执行代码
	 	s typeExeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),9)
	 	continue:$g(typeExeCode)=""
	 	
	 	s count=0
 		s execCode="s count=$$"_typeExeCode_"()"
		x execCode
		
		f inx=0:1:count-1  {
			s dimProInfor=dimType
			s itemList=$g(^TEMPDHCWLCode($j,inx))
			//维度的ID值
			s dimID=$p(itemList,"^",1)
			k dims
			s dimProCode=""
			if ($o(resolved("$DIMPARAM",dimType,dimProCode))'=""){
				s dimProV=""
				f {
					//维度属性编码
					s dimProCode=$o(resolved("$DIMPARAM",dimType,dimProCode))
					q:dimProCode=""
					if ($p(dimProInfor,":",2)=""){
						s dimProInfor=dimProInfor_":"_dimProCode
					}else{
						s dimProInfor=dimProInfor_"^"_dimProCode
					}
					//s dimdimProCode=dimType_"."_dimProCode
					s dims(dimType)=dimID
					s dimProCodeUP=$SYSTEM.SQL.ALPHAUP(dimProCode)
					s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,dimProCodeUP,""))
					continue:$g(dimProID)=""
					//属性执行代码
					s proExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),6)
					continue:$g(proExeCode)=""
					s excString="s dimPro=$$"_proExeCode_"("""_dimID_""")"
					do ##class(DHCWL.util.CheckKpiData).CheckKpiExCodetest(proExeCode)
					if ($o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))'=""){
						s errorFlag=1
						q 
					}
					x excString
					s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro," 	"_$char(10)_$char(13))	
					//s dims(dimdimProCode)=dimPro
					s dimProVPos=resolved("$DIMPARAM",dimType,dimProCode)
					s $p(dimProV,",",dimProVPos)=dimPro
				}
				if (errorFlag=1){
					q 
				}
				if (dimFilter'=""){
	 				s flag=filter.FilterValues(.dims)
	 				if ('flag){
		 				continue
	 				}
	 			}
				s Data=$lb($g(dimProInfor),$g(dimID),$g(dimProV))
				d OuputRow1			
 			}else{
	 			s i=2
	 			s dimValues=""
	 			for{
	 			s dimValue=$p(itemList,"^",i)
	 			q:dimValue=""
	 			s i=i+1
	 			if (dimValues=""){
		 			s dimValues=dimValue
	 			}else{
	 				s dimValues=dimValues_","_dimValue
	 			}
	 			}
	 			if (dimFilter'=""){
	 				s dims(dimType)=dimID
	 				s flag=filter.FilterValues(.dims)
	 				if ('flag){
		 				continue
	 				}
	 			}
	 			s Data=$lb($g(dimType),$g(dimID),$g(dimValues))
	 			d OuputRow1
 			}
 			q:errorFlag=1
		}
		q:errorFlag=1
	
 	}
 	if (errorFlag=1){
 	q "error"
 	}
	k ^TEMPDHCWL($j)
	k ^TEMPDHCWLCode($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryDimValuesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDimValuesByDimTypeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDimValuesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDimValuesByDimTypeExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod RunError()
{
	if ($d(^||TEMPDHCWL("exeCodeError",$J,"saveExCode"))){
		if (($o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))'="")){
			s exeCode=$o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))
			if ($g(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",exeCode))=1){
				q
			}
			s ^||TEMPDHCWL("exeCodeError",$J,"saveExCode",exeCode)=1
			w "执行代码 "_exeCode_"不存在,请维护后再进行操作",!
			q
		}
	}
}

/// Creator:		wk
/// CreatDate:		2016-12-15
/// Description:	通过指标执行代码获取获取相关指标的信息
/// Table:			
/// Input:			
/// Return:			
/// HowToUse:		d ##class(DHCWL.Interface.MkpiData).GetKpiInforByExc("GetBedNum^DHCWLBuildKPIDataLeaderQuery",.data)
ClassMethod GetKpiInforByExc(exeCode, ByRef kpiInforList)
{
	n (exeCode,kpiInforList)
	k kpiInforList
	q:exeCode=""
	i ($p(exeCode,"$$",2)'="")  s exeCode=$p(exeCode,"$$",2)
	i ($p(exeCode,"##",2)'="")  s exeCode=$p(exeCode,"##",2)
	s kpiID=""
	for{
		s kpiID=$o(^DHCWL.MKPI.MKPID(kpiID))
		q:kpiID=""
		s kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiID)
		if kpiObj=""{
			w "kpiID打开对象错误,请检查后升级！！"
			q
		}
		s kpiExc=kpiObj.MKPIEXCode
		continue:kpiExc=""
		i ($p(kpiExc,"$$",2)'="")  s kpiExc=$p(kpiExc,"$$",2)
	    i ($p(kpiExc,"##",2)'="")  s kpiExc=$p(kpiExc,"##",2)
		if (kpiExc=exeCode){
			if ($d(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID," Y"))){
				s kpiCode=kpiObj.MKPICode
				s kpiDesc=kpiObj.MKPIDesc
				s kpiDataNode=kpiObj.MKPIDataNod
				s kpiRemark=kpiObj.MKPIRemark
				continue:kpiRemark=""
				;s kpiInforList(kpiCode,kpiDesc,kpiDataNode,kpiRemark)=""
				s kpiInforList(kpiCode)=kpiDataNode_"^"_kpiRemark
			}
		}
		k kpiObj
	}
}

}
