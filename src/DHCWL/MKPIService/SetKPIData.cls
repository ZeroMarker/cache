/// 名称: DHCWL.MKPIService.SetKPIData
/// 描述: 处理区间指标数据
/// 编写日期:2012-03-23
/// 约定存指标数据的global为：^TEMPDHCWLKPIDATA("S",$j,...)
/// 约定取指标数据的global为：^TEMPDHCWLKPIDATA("G",$j,...)
Class DHCWL.MKPIService.SetKPIData Extends %RegisteredObject [ Not ProcedureBlock ]
{

// w ##class(DHCWL.MKPIService.SetKPIData).SetKPIData(753,170,1)

/// Description:： 计算某一区间某一指标科室的值,并将数据分别记录在DHCWL_MKPI.DHCWLMKPIData和DHCWL_MKPI.DHCWLDeptKPIData中
/// Table：       DHCWL_MKPI.DHCWLKPIMonths,DHCWL_MKPI.DHCWLMKPI,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       monId:区间id,kpiId:指标id.rbFLag:是否重新生成数据,0为不重新生成,如果该区间该指标已经有数据,则退出,否则删除原有数据,重新生成数据
/// Output：      
/// Return：      retStatus:成功则返回1,执行失败返回0
/// Others：      计算某一区间某一指标科室的值,如果指标区间和月区间不一致,则使用维护的区间计算,否则使用开始结束日期计算
ClassMethod SetKPIData(monId, kpiId, rbFlag = 0) As %Status
{
	n (monId,kpiId,rbFlag)
	s kpiSectionFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),11,"")
	s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	s monSectionFlag=$listget(^DHCWL.MKPI.MonthsD(monId),11,"")
	s id=..GetKPIDataIdByMonKPI(monId,kpiId),sumFlag=0
	q:(id'=0)&&(rbFlag=0) 1
	//test just need sum up based on low section kpi data
	i kpiSectionFlag'=monSectionFlag {
		s sc=..SetKPIDataByMonStr(monId,kpiId),sumFlag=1 
	}else {
		s sc=..SetKPIDataByDate(monId,kpiId,.data) //not the sum up
	}
	s sc=..CreatKpiData(monId, kpiId,.data,id,sumFlag)    //insert data to DHCWLDeptKPIData table
	i (sumFlag=1)||(globalFlag="Y") d
	.k ^||TEMPDHCWLKPIDATA("S",$j)  //清楚进程global
	.k ^TEMPDHCWLKPIDATA("S",$j)  //clean up the appointed global

	q sc
}

/// CreatDate：    2012-03-23
/// 对一个时间段的指标生成数据加入事务控制@20130320
/// Description:： 将数据分别记录在DHCWL_MKPI.DHCWLMKPIData和DHCWL_MKPI.DHCWLDeptKPIData中
/// Table：       DHCWL_MKPI.DHCWLKPIMonths,DHCWL_MKPI.DHCWLMKPI,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       monId:区间id,kpiId:指标id.rbFLag:是否重新生成数据,0为不重新生成,如果该区间该指标已经有数据,则退出,否则删除原有数据,重新生成数据
/// Output：      
/// Return：      retStatus:成功则返回1,执行失败返回0
/// Others：      
ClassMethod CreatKpiData(monId, kpiId, ByRef data, dataId = 0, sumFlag = 0) As %Status
{
		
	n (monId,kpiId,data,dataId,sumFlag)
	
	//add by wz.2014-5-14
	//s ContextLevel=$STACK
	//i kpiId="403"  s $ECODE=",Upassword expired,"
	s mWrongFlag=0
	i +dataId=0 d
	.k PLIST
	.s PLIST(2)=monId
	.s PLIST(3)=kpiId
	.s PLIST(4)=""
	.s PLIST(5)=+$h
	.//增加指标数据插入时间戳，精确到毫秒
	.//add by lhh@20180704 start
	.s PLIST(6)=$p($zts,",",2)  ;s PLIST(6)=""
	.//add by lhh@20180704 end
	.i $d(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId)) s mWrongFlag=1
	.q:$d(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId))
	.&sql(insert into DHCWL_MKPI.DHCWLMKPIData values PLIST())
	.s dataId=%ROWID
	else  d
	.d ..DeleteKPIData(dataId)
	q:mWrongFlag=1 0
	//now when insert datas ,there are two ways,one from data arry ,one from appointed global
	s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	s kpiNod=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	;tstart
	s wrongFlag=0
	i (globalFlag="Y")||(sumFlag=1) d  //this indicate sum the data from low section data
	.s dim="" f  s dim=$o(^||TEMPDHCWLKPIDATA("S",$j,dim)) q:((dim="")||(wrongFlag))  d
	..k PLIST
	..s PLIST(2)=dataId
	..s PLIST(3)=dim
	..i (kpiNod="")||(kpiNod=$c(0)) s PLIST(4)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim))
	..e  s PLIST(4)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim,kpiNod))
	..q:((PLIST(4)=$c(0)) || (PLIST(4)="")) 
	..&Sql(insert into DHCWL_MKPI.DHCWLDeptKPIData values PLIST())
	..i +$g(%ROWID)=0 s wrongFlag=1
	e  d	//data from data array
	.q:'$d(data)
	.s total=0
	.s dim="" f  s dim=$o(data(dim)) q:(dim="")||(wrongFlag)  d
	..k PLIST
	..s PLIST(2)=dataId
	..s PLIST(3)=dim
	..i (kpiNod="")||(kpiNod=$c(0)) s PLIST(4)=$g(data(dim))
	..e  s PLIST(4)=$g(data(dim,kpiNod))
	..q:((PLIST(4)=$c(0)) || (PLIST(4)=""))
	..&Sql(insert into DHCWL_MKPI.DHCWLDeptKPIData values PLIST())
	..i +$g(%ROWID)=0 d
	...s wrongFlag=1
	if (wrongFlag=1) d
	.;trollback
	.d ..DeleteKPIData(dataId)
	.s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	.s ^DHCWLMKPI(0,"TRACK",+$h,id)="方法CreatKpiData插入数据失败！DKPI_KPI_Dr="_dataId_"  dim="_dim_"  value="_PLIST(4)_"  回滚kpiId="_kpiId_"  monId"_monId_"下的数据"
	;e  tcommit
	q wrongFlag=0
}

/// 
/// CreatDate：    2012-06-26
/// Description:： 计算某一区间多个指标的值,并将数据分别记录在DHCWL_MKPI.DHCWLMKPIData和DHCWL_MKPI.DHCWLDeptKPIData中
/// Table：        DHCWL_MKPI.DHCWLKPIMonths,DHCWL_MKPI.DHCWLMKPI,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：        monId:区间id,kpiIdStr:指标id串,","分隔.rbFLag:是否重新生成数据,0为不重新生成,如果该区间该指标已经有数据,则退出,否则删除原有数据,重新生成数据
/// Output：      
/// Return：       retStatus:成功则返回1,执行失败返回0
/// Others：       如果使用维护的区间计算,则判断多个指标是否使用相同的区间,指标执行代码,指标区间,则同时计算,只调用指标执行代码一次
ClassMethod SetMultiKPIData(monId, kpiIdStr, rbFlag = 0, ByRef aryExecParam) As %Status
{
	n (monId, kpiIdStr, rbFlag,aryExecParam)
	q:monId="" 1
	;n $et
	;s exceptionFlag=0,$et="d ##class(DHCWL.MKPIService.SetKPIData).TrapExceptionFlag(.exceptionFlag,monId="_monId_" kpiIdStr="_kpiIdStr_")"
	new $ETRAP
	set $ETRAP="d ##class(DHCWL.MKPILogin.LoginService).GetErrorInTask()"
	s nextFlag=0
	k exData
	s numFlag=0,needNum=0
	s monSectionFlag=$listget(^DHCWL.MKPI.MonthsD(monId),11,"")	//月份区间:日，月，季，年标志
	s kpiIdLen=$l(kpiIdStr,",")
	//获取开始结束日期
	s startDate=$li(^DHCWL.MKPI.MonthsD(monId),7)
	s endDate=$li(^DHCWL.MKPI.MonthsD(monId),4)
	i startDate'="" s startDate=$zd(startDate,3)
	i endDate'="" s endDate=$zd(endDate,3)
	
	f len=1:1:kpiIdLen d
	.s kpiId=$p(kpiIdStr,",",len)
	.;if $d(^TEMPDHCWL("recordMonIDCurrent","monthID")) d
	..;s ^TEMPDHCWL("recordCurrentPlan","plan")=((^TEMPDHCWL("recordMonIDCurrent","monthID"))*len)/((^TEMPDHCWL("recordMonIDTotal","monthID"))*kpiIdLen)
	.do:$d(^TEMPDHCWL("KPI","CreatDate","progress","start")) ##class(DHCWL.util.DHCWLutilKPIDataBar).IncreaseProgress()
	.q:(kpiId="")||('$d(^DHCWL.MKPI.MKPID(kpiId)))
	.s dataId=..GetKPIDataIdByMonKPI(monId,kpiId)
	.//if has created and not rebuilde data ,directely quit
	.q:(dataId'=0)&&(rbFlag=0)
	.s kpiSectionFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),11,"") 
	.s execCode=$listget(^DHCWL.MKPI.MKPID(kpiId),4,"")
	.q:execCode=""
	.//if this condition ok,only sum up data,not need execute function code
	.i kpiSectionFlag'=monSectionFlag d
	..s sc=..SetKPIData(monId,kpiId,rbFlag)
	..s needNum=needNum+1,numFlag=numFlag+sc
	..i sc=0 d
	...;w "sum data wrong!monId="_monId_"  kpiId="_kpiId,!
	...s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	...s ^DHCWLMKPI(0,"TRACK",+$h,id)="方法SetMultiKPIData在汇总指标数据时(SetKPIData)失败!monId="_monId_"  kpiId="_kpiId_" rebuildFlag="_rbFlag
	.e  d
	..if execCode["ETL" d
	...s kpiRemark=$lg(^DHCWL.MKPI.MKPID(kpiId),6)
	...if kpiRemark'="" s execCode="s sc=##"_execCode_"(startDate,endDate,.data,"""_kpiRemark_""")" 
	..//store all execute code and kpi
	..s exData(execCode,kpiId)=dataId
	..;w exeCode,!,kpiId,!
	;s execCode=$li(^DHCWL.MKPI.MKPID(kpiId),4)
	;q:execCode="" 0
	s execCode="",globalFlag=""
	f  s execCode=$o(exData(execCode)) q:execCode=""  d
	.;modify by wz.2015-8-19
	.i $d(aryExecParam(execCode)) s execParam=aryExecParam(execCode)		//执行参数
	.s execFlag=1,nextFlag=0   //one exeCode only need run once
	.s kpiId="" f  s kpiId=$o(exData(execCode,kpiId)) q:kpiId=""  d
	..s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	..;i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""")"
	..;e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.data)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""","_".data)"
	
	..i (execCode '[ "ETL")&&(execCode '[ "(") d
	...i (execCode [ "^") d
	....i $g(execParam)'="" d
	.....i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate,execParam)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""")"
	.....e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.data,execParam)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""","_".data)"
	....e  d
	.....i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""")"
	.....e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.data)"  ;"s sc=$$"_execCode_"("""_startDate_""","""_endDate_""","_".data)"
	
	...e  d
	....i $g(execParam)'="" d
	.....i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate,execParam)"  
	.....e  s execStr="s sc=##"_execCode_"(startDate,endDate,.data,execParam)"  
	....e  d
	.....i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate)"  
	.....e  s execStr="s sc=##"_execCode_"(startDate,endDate,.data)" 
	..e  d
	...s execStr=execCode
	
	..i execFlag d   //before run function ,clear up global or data array
	...i $g(globalFlag)="Y" d
	....k ^TEMPDHCWLKPIDATA("S",$j)
	....k ^||TEMPDHCWLKPIDATA("S",$j)
	...e  k data
	...///Added by JEFF @2014-03-05 for MKPILogin module
	...///set $ETRAP="d ##class(DHCWL.MKPILogin.LoginService).GetErrorInTask()"
	...s ContextLevel=$STACK, errorOccured=0
	...x execStr
	...q:errorOccured
	...i (1=0)&&($g(sc)'=1) d
	....i $g(globalFlag)="Y" d
	.....k ^TEMPDHCWLKPIDATA("S",$j)
	.....k ^||TEMPDHCWLKPIDATA("S",$j)
	....e  k data
	....d ..TrapExceptionMess("执行函数数据返回有问题："_execStr)
	....s nextFlag=1
	...s execFlag=0
	..q:errorOccured
	..q:nextFlag=1
	..s id=$g(exData(execCode,kpiId))
	..q:(+id>0)&&(rbFlag=0)
	..;d ..TransGloFromNorToPrc(kpiId)	;add by wz.2015-6-11.如果执行代码中生成的数据保存到普通global中，就把数据转换到进程global中
	..if ($d(^TEMPDHCWLKPIDATA("S",$j))) d
	...Merge ^||TEMPDHCWLKPIDATA("S",$j)=^TEMPDHCWLKPIDATA("S",$j)
	...k ^TEMPDHCWLKPIDATA("S",$j)
	..s sc=..CreatKpiData(monId,kpiId,.data,id)
	..s needNum=needNum+1,numFlag=numFlag+sc
	..i sc=0 d
	...;w "create data wrong!monId="_monId_"  kpiId="_kpiId,!
	...s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	...s ^DHCWLMKPI(0,"TRACK",+$h,id)="方法SetMultiKPIData执行失败(CreatKpiData)! monId="_monId_"  kpiId="_kpiId_" rebuildFlag="_rbFlag
	q needNum=numFlag
}

ClassMethod SetMultiKPIDataRealService(monId, kpiIdStr) As %Status
{
	n (monId, kpiIdStr)
	;s rbFlag=1  //
	s monSectionFlag=$listget(^DHCWL.MKPI.MonthsD(monId),11,"")	//月份区间
	s kpiIdLen=$l(kpiIdStr,",")
	f len=1:1:kpiIdLen d
	.s kpiId=$p(kpiIdStr,",",len)
	.q:kpiId=""
	.s kpiSectionFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),11,"") 
	.s execCode=$listget(^DHCWL.MKPI.MKPID(kpiId),4,"")
	.q:execCode=""	
	.s exData(execCode,kpiId)=""
	s startDate=$li(^DHCWL.MKPI.MonthsD(monId),7)
	s endDate=$li(^DHCWL.MKPI.MonthsD(monId),4)
	i startDate'="" s startDate=$zd(startDate,3)
	i endDate'="" s endDate=$zd(endDate,3)
	s execCode=""
	f  s execCode=$o(exData(execCode)) q:execCode=""  d
	.s execFlag=1  
	.s kpiId="" f  s kpiId=$o(exData(execCode,kpiId)) q:kpiId=""  d
	..s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	..i globalFlag="Y" s execStr="d "_execCode_"(startDate,endDate)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	..e  s execStr="d "_execCode_"(startDate,endDate,.data)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".data)"
	..i execFlag=1 x execStr
	..e  s execFlag=2
	q 1
}

// d ##class(DHCWL.MKPIService.SetKPIData).DeleteKPIData(1)

/// Creator：      ban
/// CreatDate：    2012-06-25
/// Description:： 根据DHCWL_MKPI.DHCWLMKPIData表id删除DHCWL_MKPI.DHCWLDeptKPIData记录
/// Table：        DHCWL_MKPI.DHCWLDeptKPIData
/// Input：        kpiMonthId:DHCWL_MKPI.DHCWLMKPIData表id
/// Output：      
/// Return：       retStatus:成功则返回1,执行失败返回0
/// Others：       考虑到可能会出现上10万条数据,暂不加入事物处理
ClassMethod DeleteKPIData(kpiMonthId) As %Status
{
		n (kpiMonthId)
		q:kpiMonthId="" 0
		
		s id=0
		f  s id=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",kpiMonthId,id)) q:id=""  d
		.&sql(delete from DHCWL_MKPI.DHCWLDeptKPIData where id=:id)
		
		q 1
}

// w ##class(DHCWL.MKPIService.SetKPIData).SetKPIDataByDate(753,1,.list)

/// Creator：      ban
/// CreatDate：    2012-03-23
/// Description:： 根据开始日期,结束日期计算科室指标的数据
/// Table：       DHCWL_MKPI.DHCWLKPIMonths,DHCWL_MKPI.DHCWLMKPI
/// Input：       monId:区间id,kpiId:指标id.
/// Output：      data:返回各科的指标值
/// Return：      retStatus:成功则返回1,执行失败返回0
/// Others：      根据开始日期,结束日期计算科室指标的数据,以数组形式返回
ClassMethod SetKPIDataByDate(monId, kpiId, ByRef data) As %Status
{
	n (monId,kpiId,data)
	k data
	s startDate=$listget(^DHCWL.MKPI.MonthsD(monId),7,"")
	s endDate=$listget(^DHCWL.MKPI.MonthsD(monId),4,"")
	i startDate'="" s startDate=$zd(startDate,3)
	i endDate'="" s endDate=$zd(endDate,3)
	s execCode=$li(^DHCWL.MKPI.MKPID(kpiId),4)
	q:execCode="" 0
	//run function return data may be store appointed global or data array
	s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	i globalFlag="N" s execStr="d "_execCode_"(startDate,endDate,.data)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".data)"
	e  s execStr="d "_execCode_"(startDate,endDate)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	new $ETRAP
	set $ETRAP="d ##class(DHCWL.MKPILogin.LoginService).GetErrorInTask()"		;Added by JEFF @2014-03-05 for MKPILogin module
	s ContextLevel=$STACK
	x execStr
	i (globalFlag'="N"){
		if ($d(^TEMPDHCWLKPIDATA("S",$j))){
			Merge ^||TEMPDHCWLKPIDATA("S",$j)=^TEMPDHCWLKPIDATA("S",$j)
			k ^TEMPDHCWLKPIDATA("S",$j)
		}
	}
	;d OutPutOP^DHCWLBuildKPIDataReg("2008-01-03","2008-01-03",.data)
	q 1
}

// w ##class(DHCWL.MKPIService.SetKPIData).SetKPIDataByMonStr(6,1,.list)

/// Creator：      ban
/// CreatDate：    2012-03-23
/// Description:： 根据区间累加科室指标的数据
/// Table：       DHCWL_MKPI.DHCWLKPIMonths,DHCWL_MKPI.DHCWLMKPI
/// Input：       monId:区间id,kpiId:指标id.
/// Output：      data:返回各科的指标值
/// Return：      retStatus:成功则返回1,执行失败返回0
/// Others：      根据开始日期,结束日期计算科室指标的数据,以数组形式返回
ClassMethod SetKPIDataByMonStr(monId, kpiId) As %Status
{
	n (monId,kpiId)
	s monStr=$listget(^DHCWL.MKPI.MonthsD(monId),12,"")
	q:monStr="" 1
	s sc=..GetKPIData(monStr,kpiId)
	q 1
}

// w ##class(DHCWL.MKPIService.SetKPIData).GetKPIData("475,476,477","1",.list,1,1)

/// Description:：  根据取数规则和模式获得相应的指标数据，放在指定global^TEMPDHCWLKPIDATA("S",$j)下
/// Table：       DHCWL_MKPI.DHCWLMKPIData等
/// Input：       monIdStr:区间id指标串,用逗号分隔,如:"1,2,3",accessRule：指标取数规则，mode取数模式，详见ResovleAccessRlue方法的说明
/// Output：      ^TEMPDHCWLKPIDATA("S",$j,dim,dataNode),dim指标对应的维度值，dataNode标示该指标数据的数据节点标志
/// Return：      retStatus:成功则返回1,执行失败返回0
ClassMethod GetKPIData(monIdStr, accessRule, mode = "") As %Status
{
	n (monIdStr,accessRule,mode)
	q:(monIdStr="")||(accessRule="") 1
	//firstly resolve the param
	i mode=0 s mode="H"
	d ..ResovleAccessRlue(accessRule,mode,.resovled)  //firstly resolve the param
	s isReal=resovled("$RealFlag")
	s sumFlag=resovled("$SumFlag")
	s kpiId=resovled("$PARAMKPI")
	q:kpiId="" 1
	//s dimList=resovled("$DEF",kpiId)
	s monIdLen=$l(monIdStr,",")
	s kpiNod=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	i isReal=0 d
	.k ^TEMPDHCWLKPIDATA("S",$j)
	.k ^||TEMPDHCWLKPIDATA("S",$j)
	.f len=1:1:monIdLen d
	..s monId=$p(monIdStr,",",len)
	..q:monId=""
	..s monKPIId=0
	..f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,monKPIId)) q:monKPIId=""  d
	...s deptKPIId=0
	...f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:deptKPIId=""  d
	....s dim=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2)
	....//replace the ignore dim null to sum the data
	....;s dim=..SetDimValue(kpiId,dim,.resovled)   //3.0 added
	....s value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	....i (kpiNod="")||(kpiNod=$c(0)) d
	.....s ^||TEMPDHCWLKPIDATA("S",$j,dim)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim))+value
	....e  d
	.....s ^||TEMPDHCWLKPIDATA("S",$j,dim,kpiNod)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim,kpiNod))+value
	e  d   //is realtime data? now store the data to ^TEMPDHCWLKPIDATA("G",$j),for realtime query
	.f len=1:1:monIdLen d
	..s monId=$p(monIdStr,",",len)
	..q:monId=""
	..i globalFlag="Y" d	//using default global
	...k ^TEMPDHCWLKPIDATA("S",$j)
	...k ^||TEMPDHCWLKPIDATA("S",$j)
	...d ..SetKPIDataByDate(monId,kpiId,.data)
	...s dim="" f  s dim=$o(^||TEMPDHCWLKPIDATA("S",$j,dim)) q:dim=""  d
	....s dim2=dim ;s dim2=..SetDimValue(kpiId,dim,.resovled)  //replace the ignore dim null to sum the data
	....i (kpiNod="")||(kpiNod=$c(0)) s ^||TEMPDHCWLKPIDATA("G",$j,dim2)=$g(^||TEMPDHCWLKPIDATA("G",$j,dim2))+$g(^||TEMPDHCWLKPIDATA("S",$j,dim))
	....e  s ^||TEMPDHCWLKPIDATA("G",$j,dim2,kpiNod)=$g(^||TEMPDHCWLKPIDATA("G",$j,dim2,kpiNod))+$g(^||TEMPDHCWLKPIDATA("S",$j,dim,kpiNod))
	...;k ^TEMPDHCWLKPIDATA("S",$j)
	...k ^||TEMPDHCWLKPIDATA("S",$j)
	..e  d
	...d ..SetKPIDataByDate(monId,kpiId,.data)
	...s dim="" f  s dim=$o(data(dim)) q:dim=""  d
	...s dim2=dim ;..SetDimValue(kpiId,dim,.resovled) //replace the ignore dim null to sum the data
	...i (kpiNod="")||(kpiNod=$c(0)) s ^||TEMPDHCWLKPIDATA("G",$j,dim2)=$g(^||TEMPDHCWLKPIDATA("G",$j,dim2))+$g(data(dim))
	...e  s ^||TEMPDHCWLKPIDATA("G",$j,dim2,kpiNod)=$g(^||TEMPDHCWLKPIDATA("G",$j,dim2,kpiNod))+$g(data(dim,kpiNod))
	q 1
}

/// d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData("336","MzDocYlFee:KDLoc.Loc^KDDoc.code^KDDoc.name","R",)
/// Description:： 根据取数规则和模式获得相应的指标数据，放在指定global^TEMPDHCWLKPIDATA("G",$j)下
/// Table：       DHCWL_MKPI.DHCWLMKPIData等
/// Input：       monIdStr:区间id指标串,用逗号分隔,如:"1,2,3",accessRule：指标取数规则，mode取数模式，详见ResovleAccessRlue方法的说明
/// Output：      ^TEMPDHCWLKPIDATA("G",$j,monId,monKPIId,loc),monKPIId:指标Id,loc:科室id,monId:区间Id
/// Return：      retStatus:成功则返回1,执行失败返回0
ClassMethod GetMutiMonKPIData(monIdStr As %Text, accessRule As %Text, mode = "H", contractType = "", filterRule As %Text = "", execParam = "") As %Status
{
	
	n (monIdStr,accessRule,mode,contractType,filterRule,execParam)
	q:monIdStr="" 0
	i mode=0 s mode="H"
	s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
	d ..ResovleAccessRlue(accessRule,mode,.resovled)  //firstly resolve the param added in 3.0
	s isReal=resovled("$RealFlag")
	s sumFlag=resovled("$SumFlag")
	s convertFlag=resovled("$ConMaxFlag")
	s KPIIdStr=resovled("$PARAMKPI")
	s monIdLen=$l(monIdStr,",")
	s monIdStrParam=monIdStr
	s kpiIdLen=$l(KPIIdStr,",")
	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("PRORESDELELEFILRES",$j)
	d ..ResovleMonth(monIdStr,contractType,.resovledMon)
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
 	d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)	//add by wz.2014-12-4.解析执行代码的参数。
	i isReal=0 d	//is history?
	.f lenKPI=1:1:kpiIdLen d
	..s kpiId=$p(KPIIdStr,",",lenKPI)
	..q:kpiId=""
	..s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"1")	//add since 4.2
	..q:getValueType="2"									//是计算指标就退出
	..//now convert the monthid to the maxSec monthid start
	..i convertFlag=1 d
	...s monIdStr1=monIdStrParam,convertOk=0
	...f needConNum=1:1:4 d
	....q:convertOk=1
	....s monIdStr2=##class(DHCWL.MKPIService.DateUtil).ConvertMaxSectionByKpi(monIdStr1,kpiId)
	....i monIdStr1=monIdStr2 s convertOk=1
	....s monIdStr1=monIdStr2
	...s monIdStr=monIdStr1
	...s monIdLen=$l(monIdStr,",")
	...d ..ResovleMonth(monIdStr,contractType,.resovledMon)
	..//now convert the monthid to the maxSec monthid  ok
	..s monId="" f  s monId=$o(resovledMon(monId)) q:monId=""  d
	...s monKPIId=0 f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,monKPIId)) q:monKPIId=""  d
	....s deptKPIId=0 f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:deptKPIId=""  d
	.....q:('$d(^DHCWL.MKPI.DeptKPIDataD(deptKPIId)))
	.....s dim=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2)
	.....;s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
	.....s tempKpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)  //过滤开始
	.....s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
	.....i filterFlag d
	......s filterInd="" f  s filterInd=$o(filterTree(tempKpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	.......q:+filterInd=0
	.......s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,monId)
	.....q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	.....s value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	.....s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
	......s resDim=..SetDimValue(kpiId,position,dim,.resovled)   //3.0 added
	......i sumFlag=1 d
	.......s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim,position)=""
	.......s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim))+value  //3.0 add sum kpi data
	......e  d
	.......s ^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,resDim,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,resDim)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,resDim))+value
	.......;s data(monId,kpiId,loc)=$g(data(monId,kpiId,loc))+value
	...//now process contract month kpi data
	...s contractDateType="",conTotalValue=0 f  s contractDateType=$o(resovledMon(monId,contractDateType)) q:contractDateType=""  d
	....s conMonIds=resovledMon(monId,contractDateType)
	....s conMonLen=$l(conMonIds,",")
	....s conMonCode=resovledMon(monId,contractDateType,"CODE")
	....s conSumFlag=0
	....i (conMonCode="CM")||(conMonCode="CY") s conSumFlag=1
	....f len=1:1:conMonLen d
	.....s conMonId=$p(conMonIds,",",len),conMonName=monId_"||"_contractDateType
	.....q:conMonId=""
	.....s monKPIId=0 f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",conMonId,kpiId,monKPIId)) q:monKPIId=""  d
	......s deptKPIId=0 f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:deptKPIId=""  d
	.......s dim=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2),value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	.......;s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
	.......s tempKpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)  //过滤开始
	.......s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
	.......i filterFlag d
	........s filterInd="" f  s filterInd=$o(filterTree(tempKpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	.........q:+filterInd=0
	.........s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,conMonId)
	.......q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	.......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
	........s resDim=..SetDimValue(kpiId,position,dim,.resovled)
	........i conSumFlag=1 d
	.........s conTotalValue=conTotalValue+value
	........e  d
	.........s ^TEMPDHCWLKPIDATA("G",$j,conMonName,kpiId,resDim,position)="",^TEMPDHCWLKPIDATA("G",$j,conMonName,kpiId,resDim)=$g(^TEMPDHCWLKPIDATA("G",$j,conMonName,kpiId,resDim))+value
	.........s:sumFlag=1 ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim,position)="",^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim))+value  //3.0 add sum kpi data
	....s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
	.....i conSumFlag s ^TEMPDHCWLKPIDATA("G",$j,conMonName,kpiId,0,position)="",^TEMPDHCWLKPIDATA("G",$j,conMonName,kpiId,0)=conTotalValue
	.....e  d
	e  d	//is realtime data?
	.k exData
	.s monId="" f  s monId=$o(resovledMon(monId)) q:monId=""  d
	..s kpiIdLen=$l(KPIIdStr,",")
	..f lenK=1:1:kpiIdLen d
	...s kpiId=$p(KPIIdStr,",",lenK)
	...q:kpiId=""
	...s execCode=$listget(^DHCWL.MKPI.MKPID(kpiId),4,"")
	...q:execCode=""
	...s exData(execCode,kpiId)=""
	..s startDate=$li(^DHCWL.MKPI.MonthsD(monId),7)
	..s endDate=$li(^DHCWL.MKPI.MonthsD(monId),4)
	..i startDate'="" s startDate=$zd(startDate,3)
	..i endDate'="" s endDate=$zd(endDate,3)
	..s execCode="" f  s execCode=$o(exData(execCode)) q:execCode=""  d
	...s runFlag=1    //only run once
	...s lastHasParam=0	//add by wz.2015-1-26
	...s kpiId="" f  s kpiId=$o(exData(execCode,kpiId)) q:kpiId=""  d
	....s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	....s tempKpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	....i $d(aryExecParam(kpiId)) d
	.....s execParam=aryExecParam(kpiId)		//add by wz.2014-12-4.参数被赋值时才把参数传入执行代码
	.....s runFlag=1
	.....i (execCode [ "^") d
	......i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	......e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".dataG)"
	.....e  d
	......i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	......e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".dataG)"
	.....s lastHasParam=1	//add by wz.2015-1-26
	....e  d
	.....i (execCode [ "^") d
	......i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	......e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".dataG)"
	.....e  d
	......i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate)"
	......e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG)"
	.....i lastHasParam=1 s runFlag=1	//add by wz.2015-1-26
	.....s lastHasParam=0				//add by wz.2015-1-26
	....i runFlag d
	.....i globalFlag="Y" k ^TEMPDHCWLKPIDATA("S",$j)
	.....e  k dataG
	.....x execStr
	.....s runFlag=0
	....s dataNode=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	....s nodeFlag=1
	....i (dataNode="")||(dataNode=$c(0)) s nodeFlag=0
	....i globalFlag="Y" d
	.....s dim="" f  s dim=$o(^TEMPDHCWLKPIDATA("S",$j,dim)) q:dim=""  d
	......i (nodeFlag=0)&&($d(^TEMPDHCWLKPIDATA("S",$j,dim))=0) q
	......i (nodeFlag=1)&&($d(^TEMPDHCWLKPIDATA("S",$j,dim,dataNode))=0) q
	......;s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
	......//过滤开始
	......s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
	......i (filterFlag) d
	.......s filterInd="" f  s filterInd=$o(filterTree(tempKpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	........q:+filterInd=0
	........s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,monId)
	......q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	......s value=0  //added 20131104  每次取值之前要初始化值，否则可能造成使用上次循环得到的值使数据值有误
	......i nodeFlag=0 s value=$g(^TEMPDHCWLKPIDATA("S",$j,dim)) ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(^TEMPDHCWLKPIDATA("S",$j,dim))
	......e  s value=$g(^TEMPDHCWLKPIDATA("S",$j,dim,dataNode))
	......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
	.......s dim2=..SetDimValue(kpiId,position,dim,.resovled)   //3.0 added
	.......;patch:修改数据接口参数:S，让其只有汇总功能，不再输出明细 .2014-12-2
	.......;s ^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2))+value ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(^TEMPDHCWLKPIDATA("S",$j,dim,dataNode))
	.......;s:(sumFlag) ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2))+value
	.......i sumFlag s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2))+value
	.......e  s ^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2))+value ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(^TEMPDHCWLKPIDATA("S",$j,dim,dataNode))
	....e  d
	.....s dim="" f  s dim=$o(dataG(dim)) q:dim=""  d
	......i (nodeFlag=0)&&($d(dataG(dim))=0) q
	......i (nodeFlag=1)&&($d(dataG(dim,dataNode))=0) q
	......;s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
	......//过滤开始
	......s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
	......i filterFlag d
	.......s filterInd="" f  s filterInd=$o(filterTree(tempKpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	........q:+filterInd=0
	........s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,monId)
	......q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	......s value=0  //added 20131104  每次取值之前要初始化值，否则可能造成使用上次循环得到的值使数据值有误
	......i nodeFlag=0 s value=$g(dataG(dim)) ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(dataG(dim))
	......e  s value=$g(dataG(dim,dataNode))
	......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
	.......s dim2=..SetDimValue(kpiId,position,dim,.resovled)  //3.0 added
	.......;patch:修改数据接口参数:S，让其只有汇总功能，不再输出明细 .2014-12-2
	.......;s:$g(value) ^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2))+value ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(dataG(dim,dataNode))
	.......;s:(sumFlag)&&($g(value)) ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2))+value
	.......i (sumFlag)&&($g(value)) s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,0,kpiId,dim2))+value
	.......e  i $g(value) s ^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dim2))+value ;,data(monId,kpiId,dim)=$g(data(monId,kpiId,dim))+$g(dataG(dim,dataNode))
	...i globalFlag="Y" k ^TEMPDHCWLKPIDATA("S",$j)
	k ^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	q 1
}

// w ##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(1,1)

/// Creator：      ban
/// CreatDate：    2012-03-26
/// Description:： 获取指标对应维度的描述
/// Table：       DHCWL.MKPI.MKPIDimType,DHCWL.MKPI.MKPI
/// Input：       kpiId:指标Id,dimId:维度Id.
/// Output：      
/// Return：      des:维度的描述
/// Others：      
ClassMethod GetDimDesc(kpiId, dimId) As %String
{
	
	n (kpiId,dimId)
	s dimTypeDr=$li(^DHCWL.MKPI.MKPID(kpiId),10)
	q:dimTypeDr="" ""
	q:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimTypeDr)) ""
	s dimTypeEXCode=$li(^DHCWL.MKPI.MKPIDimTypeD(dimTypeDr),4)
	q:dimTypeEXCode="" ""
	s exCode="s des=$$"_dimTypeEXCode_"(dimId)"
	
	x exCode
	
	q $g(des)
}

// w ##class(DHCWL.MKPIService.SetKPIData).CreatTaskDataById(1)

/// Creator：      ban
/// CreatDate：    2012-03-31
/// Description:： 根据任务id生成数据
/// Table：       DHCWL_MKPI.DHCWLCreatDataTask,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       taskId:任务id
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：
ClassMethod CreatTaskDataById(taskId) As %Status
{
	n (taskId)
	q:+taskId=0 0
	s taskActive=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),2)
	q:taskActive'="Y" 0
	s exCode=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),3)
	q:exCode="" 0
	s exCode="s monId=$$"_exCode_"()"
	x exCode
	;w !,exCode
	q:+$g(monId)=0 0
	s kpiId=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),4)
	;w !, monId_"^"_kpiId
	s sc=##class(DHCWL.MKPIService.SetKPIData).SetKPIData(monId,kpiId)
	q +$g(sc)
}

// w ##class(DHCWL.MKPIService.SetKPIData).CreatTaskData()

/// Creator：      ban
/// CreatDate：    2012-03-31
/// Description:： 循环生成所有任务数据
/// Table：       DHCWL_MKPI.DHCWLCreatDataTask,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：
ClassMethod CreatTaskData() As %Status
{
	n
	s secId=0
	s sc=##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.secMM)
	i sc=1 {  //如果区间维护正确，就按照维护的区间顺序执行任务
		s level="" f  s level=$o(secMM(level),-1) q:level=""  d
		.s levelSecId="" f  s levelSecId=$o(secMM(level,levelSecId)) q:levelSecId=""  d
		..s taskId="" f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",levelSecId," Y",taskId)) q:taskId=""  d
		...s sc=##class(DHCWL.MKPIService.SetKPIData).CreatTaskDataById(taskId)
	}else{
		f  s secId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId)) q:secId=""  d
		.s taskId=0
		.f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId," Y",taskId)) q:taskId=""  d
		..s sc=##class(DHCWL.MKPIService.SetKPIData).CreatTaskDataById(taskId)
	}
	q 1
}

// w ##class(DHCWL.MKPIService.SetKPIData).GetKPIDataIdByMonKPI(montId,kpiId)

/// Creator：      ban
/// CreatDate：    2012-04-09
/// Description:： 根据区间id和指标id获取对应数据的id
/// Table：       DHCWL.MKPI.MKPIData
/// Input：       monId:区间id,kpiId:指标id
/// Output：      
/// Return：      成功返回id,否则返回0
/// Others：
ClassMethod GetKPIDataIdByMonKPI(monId, kpiId) As %String
{
	
	n (monId, kpiId)
	q:(+monId=0)||(+kpiId=0) 0
	q:'$d(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId)) 0
	s dataId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,"")) 
	//索引和数据同时存在才可以
	//add by lhh@20180704 start
	q:'$d(^DHCWL.MKPI.MKPIDataD(dataId)) 0
	//add by lhh@20180704 end
	q +dataId
}

// w ##class(DHCWL.MKPIService.SetKPIData).CreatMultiTaskData()

/// CreatDate：    2012-07-02
/// Description:： 循环整理所有任务指标,将有相同执行代码的kpi同时执行
/// Table：        DHCWL_MKPI.DHCWLCreatDataTask,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       rebuildFlag数据重生标志，1代表重生，0代表不重生。默认为不重生
/// Output：      
/// Return：       成功返回1,否则返回0
/// Others：	   
ClassMethod CreatMultiTaskData(rebuildFlag = 0, ByRef aryExecParam, flagGrp As %String = "") As %Status
{
	n (rebuildFlag, aryExecParam,flagGrp)
	k taskData
	s secId=0
	f  s secId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId)) q:secId=""  d
	.s taskId=0
	.s taskStr=""
	.f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId," Y",taskId)) q:taskId=""  d
	..s kpiId=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),4)
	..q:(kpiId="")||(kpiId=$c(0))
	..q:'$d(^DHCWL.MKPI.MKPID(kpiId))
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..q:(($d(^DHCWL.MKPI.TaskGroupDetailI("kpi"," "_$ZCVT(kpiCode,"U"))))&&(flagGrp'="ALL"))
	..s secSign=$lg(^DHCWL.MKPI.SectionD(secId),2)
	..s excDr=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),7,"")
	..if ((+excDr>0)&&($d(^DHCWL.MKPI.ExecuteCodeD(excDr)))) d
	...s exCode=$lg(^DHCWL.MKPI.ExecuteCodeD(excDr),3,"")
	..else  d
	...s exCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskId),3,"")
	..q:((exCode="")||(exCode=$c(0)))
	..s exCode=" s monId=$$"_exCode_"()"
	..x exCode
	..;i exceptionFlag=1 q
	..q:+$g(monId)=0 
	..i $d(^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)) s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=$g(taskData(monId))_","_kpiId
	..e  s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=kpiId 
	..i $d(taskData(monId)) s taskData(monId)=$g(taskData(monId))_","_kpiId
	..e  s taskData(monId)=kpiId
	..;s ^TEMPDHCWLKPIDATA("Login",$j,"kpiId",kpiId)=""		;Added by JEFF @2013-11-13
	
	//根据区间执行,数据
	s monId=0,needNums=0,numFlag=0
	f  s monId=$o(taskData(monId)) q:monId=""  d
	.s kpiStr=$g(taskData(monId))
	.s sc=..SetMultiKPIData(monId,kpiStr,rebuildFlag,.aryExecParam)
	.s needNums=needNums+1,numFlag=numFlag+sc
	.i sc=0 d
	..;w "monId="_monId_"  kpiStr="_kpiStr_"  have wrong!",!
	..s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	..s ^DHCWLMKPI(0,"TRACK",+$h,id)="指标任务方法：SetKPIData.CreatMultiTaskData执行中失败，monId="_monId_"  kpiStr="_kpiStr
	q needNums=numFlag
}

/// Creator:       wk
/// CreatDate：    2017-08-03
/// Description:： 循环整理任务组内任务指标,将有相同执行代码的kpi同时执行
/// Table：        DHCWL_MKPI.DHCWLCreatDataTask,DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       rebuildFlag数据重生标志，1代表重生，0代表不重生。默认为不重生
/// Output：      
/// Return：       成功返回1,否则返回0
/// Others：	   
ClassMethod CreatMultiTaskDataByGrp(rebuildFlag = 0, ByRef aryExecParam, taskGrp) As %Status
{
	n (rebuildFlag, aryExecParam,taskGrp)
	k taskData
	s secId=0
	s taskGrpId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(taskGrp,"DHCWL.MKPI.ConfigTaskGroup")
	f  s secId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId)) q:secId=""  d
	.s taskId=0
	.s taskStr=""
	.f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId," Y",taskId)) q:taskId=""  d
	..s kpiId=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),4)
	..q:(kpiId="")||(kpiId=$c(0))
	..q:'$d(^DHCWL.MKPI.MKPID(kpiId))
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..q:('$d(^DHCWL.MKPI.TaskGroupDetailI("kpiGroup",taskGrpId," "_$ZCVT(kpiCode,"U"))))  //屏蔽掉非任务组内的指标
	..s secSign=$lg(^DHCWL.MKPI.SectionD(secId),2)
	..s excDr=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),7,"")
	..if ((+excDr>0)&&($d(^DHCWL.MKPI.ExecuteCodeD(excDr)))) d
	...s exCode=$lg(^DHCWL.MKPI.ExecuteCodeD(excDr),3,"")
	..else  d
	...s exCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskId),3,"")
	..q:((exCode="")||(exCode=$c(0)))
	..s exCode=" s monId=$$"_exCode_"()"
	..x exCode
	..;i exceptionFlag=1 q
	..q:+$g(monId)=0 
	..i $d(^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)) s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=$g(taskData(monId))_","_kpiId
	..e  s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=kpiId 
	..i $d(taskData(monId)) s taskData(monId)=$g(taskData(monId))_","_kpiId
	..e  s taskData(monId)=kpiId
	..;s ^TEMPDHCWLKPIDATA("Login",$j,"kpiId",kpiId)=""		;Added by JEFF @2013-11-13
	//根据区间执行,数据

	s monId=0,needNums=0,numFlag=0
	f  s monId=$o(taskData(monId)) q:monId=""  d
	.s kpiStr=$g(taskData(monId))
	.s sc=..SetMultiKPIData(monId,kpiStr,rebuildFlag,.aryExecParam)
	.s needNums=needNums+1,numFlag=numFlag+sc
	.i sc=0 d
	..;w "monId="_monId_"  kpiStr="_kpiStr_"  have wrong!",!
	..s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	..s ^DHCWLMKPI(0,"TRACK",+$h,id)="指标任务方法：SetKPIData.CreatMultiTaskData执行中失败，monId="_monId_"  kpiStr="_kpiStr
	q needNums=numFlag
}

ClassMethod CreatMultiTaskDataSpecialKpi(kpiIds, rebuildFlag = 0, execParam As %String = "") As %Status
{
	n (kpiIds,rebuildFlag,execParam)
	q:kpiIds="" 1
	k taskData,SPKPIList
	;n $et
	;s exceptionFlag=0,$et="d ##class(DHCWL.MKPIService.SetKPIData).TrapExceptionFlag(.exceptionFlag)"
	//循环获得所有需要执行的任务,把相同区间的kpi整理在一起
	f i=1:1:$l(kpiIds,",") {
		s spKpiId=$p(kpiIds,",",i)
		continue:spKpiId=""
		s SPKPIList(spKpiId)=spKpiId
	}
	s secId=0
	f  s secId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId)) q:secId=""  d
	.s taskId=0
	.s taskStr=""
	.f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("Section",secId," Y",taskId)) q:taskId=""  d
	..s kpiId=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),4)
	..q:(kpiId="")||(kpiId=$c(0))
	..q:'$d(^DHCWL.MKPI.MKPID(kpiId))
	..q:'$d(SPKPIList(kpiId))
	..s secSign=$lg(^DHCWL.MKPI.SectionD(secId),2)
	..s excDr=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),7,"")
	..if ((+excDr>0)&&($d(^DHCWL.MKPI.ExecuteCodeD(excDr)))) d
	...s exCode=$lg(^DHCWL.MKPI.ExecuteCodeD(excDr),3,"")
	..else  d
	...s exCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskId),3,"")
	..q:((exCode="")||(exCode=$c(0)))
	..s exCode=" s monId=$$"_exCode_"()"
	..x exCode
	..;w !,exCode
	..q:+$g(monId)=0 
	..i $d(^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)) s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=$g(taskData(monId))_","_kpiId
	..e  s ^||TEMPDHCWL("kpiIdAndMonId",secSign,monId)=kpiId
	..i $d(taskData(monId)) s taskData(monId)=$g(taskData(monId))_","_kpiId
	..e  s taskData(monId)=kpiId
	..;s ^TEMPDHCWLKPIDATA("Login",$j,"kpiId",kpiId)=""		;Added by JEFF @2013-11-13
	
	do:$d(^TEMPDHCWL("KPI","CreatDate","progress","start")) ##class(DHCWL.util.DHCWLutilKPIDataBar).DetailTotal(.taskData)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)	//add by wz.2014-12-4.解析执行代码的参数。
	s monId=0,needNums=0,numFlag=0
	f  s monId=$o(taskData(monId)) q:monId=""  d
	.s kpiStr=$g(taskData(monId))
	.s sc=..SetMultiKPIData(monId,kpiStr,rebuildFlag,.aryExecParam)
	.s needNums=needNums+1,numFlag=numFlag+sc
	.i sc=0 d
	..;w "monId="_monId_"  kpiStr="_kpiStr_"  have wrong!",!
	..s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	..s ^DHCWLMKPI(0,"TRACK",+$h,id)="指标任务方法：SetKPIData.CreatMultiTaskData执行中失败，monId="_monId_"  kpiStr="_kpiStr
	q needNums=numFlag
}

// d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue("MZDocGhf:Dep,MZDocZcf.$D.ID^$D.Type","H",.res)

/// 取数规则解析方法
/// rule：待解析的指标取数规则，mode：取数模式，resolved：解析后的结果
/// rule和mode参数详细说明如下：
/// rule代表取数规则，定义如下：kpi1:dim1.dimPro1^dim1.dimPro2^dim2.dimPro1,kpi2:dim1.dimPro1......。kpi代表指标，dim代表维度，dimPro代表维度属性
/// 其中dim，dimPro可以缺省，若缺省dimPro则取dim下默认的dimPro，若缺省dim则取指标维度列表中第一个指标维度及其维度相关的默认维度属性
/// kpi,dim,dimPro可以是编码，也可以是id
/// mode：代表模式，目前支持的模式有：R实时数据模式；S汇总日期数据模式；C自动提升指标months区间模式。若出现R、S、C就代表使用该模式，否则代表不用该模式
/// C模式说明：若给定months id串为日日期，且该指标下有月日期的数据则自动将months id转换为对应的月日期的months id，以此类推会一直转换到年日期或该指标没有该日期类型下的数据为止，该模式只对历史数据有效
ClassMethod ResovleAccessRlueOld(rule As %Text, mode, ByRef resolved)
{
	n (rule,mode,resolved)
	s mode=$g(mode)
	s kpiDeli=",",dimDeli="^",proDeli=".",kdDeli=":"
	s dimLen=0
	k:$d(resolved) resolved
	s kpiLen=$l(rule,kpiDeli)
	s resolved("$PARAMKPI")=""
	k kpiArr
	//after 3.2 add the kpi position
	f i=1:1:kpiLen d
	.s kpiR=$p(rule,kpiDeli,i)
	.q:kpiR=""
	.s kpi=$p(kpiR,kdDeli,1)
	.i '$d(^DHCWL.MKPI.MKPID(kpi)) s kpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
	.q:(kpi="")
	.s kpi=+kpi
	.i ($d(kpiArr(kpi))=0) d
	..i resolved("$PARAMKPI")'="" s resolved("$PARAMKPI")=resolved("$PARAMKPI")_kpiDeli_kpi
	..e  s resolved("$PARAMKPI")=kpi
	..s kpiArr(kpi)=1
	.e  s kpiArr(kpi)=$g(kpiArr(kpi))+1
	.s resolved("$DELI",kpi)=","
	.//0 means not ignore
	.s resolved("$PARAM",kpi,kpiArr(kpi))=1 	//after 3.2
	.q:('$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi)))
	.s kpiDimDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi,""))
	.q:kpiDimDimId=""
	.s tempKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi,kpiDimDimId,""))
	.q:tempKpiDimId=""
	.s kpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(tempKpiDimId),7,",")
	.s resolved("$DELI",kpi)=kpiDimDeli
	.s resolved("$DEF",kpi)=..GetKpiDim(kpi,dimDeli)
	.s dimProR=$p(kpiR,kdDeli,2)
	.i ((dimProR="")) s dimProR=resolved("$DEF",kpi),resolved("$PARAM",kpi,kpiArr(kpi))=1   //if not give dim use all dim
	.i $$JudgeOnlySec(dimProR) s dimProR=dimProR_dimDeli_resolved("$DEF",kpi)
	.q:dimProR=""
	.s dimLen=$l(dimProR,dimDeli)
	.f j=1:1:dimLen d
	..s dimR=$p(dimProR,dimDeli,j)
	..q:dimR=""
	..s kpiDimCode=$p(dimR,proDeli,1)
	..s specialFlag=0
	..i $e(kpiDimCode,1)="$" d
	...s specialFlag=1
	...s secDim=$e(kpiDimCode,2,$l(kpiDimCode))
	...s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(secDim,"DHCWL.MKPI.Section")
	...q:secDimId=""
	...s dimPro=$p(dimR,proDeli,2)
	...if dimPro="" s secDimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
	...else  s secDimProId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(secDimId_"||"_dimPro)
	...i secDimProId="" s secDimProId="0"
	...s resolved("KPISECPRO",kpi,secDimProId,secDimId)=""
	..q:specialFlag=1
	..s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpi,$zcvt(kpiDimCode,"U"),""))
	..q:kpiDimId=""
	..s dim=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
	..s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1)
	..q:dim=""
	..;s dim=+dim,order=+order
	..s resolved("$PARAM",kpi,kpiArr(kpi),order,dim)=1  //1 mean this is not ingored dim
	..s dimPro=$p(dimR,proDeli,2)
	..;add by wz.begin.2014-5-8.解析维度属性参数。
	..s tmpDimPro=dimPro
	..s dimPro=$p(tmpDimPro,"(",1)
	..;add by wz.end.2014-5-8.解析维度属性参数。
	..s dimCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dim,"DHCWL.MKPI.MKPIDimType")
	..s dimPro=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode_"||"_dimPro,"DHCWL.MKPI.DimProperty") ;##class(DHCWL.MKPIService.ConfigService).GetDimProIdByCode(dimPro)
	..i dimPro="" d    //if is null use default
	...s defaDimProId=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dim,"Y",""))
	...s dimPro=defaDimProId
	..q:dimPro=""
	..;s dimPro=+dimPro
	..s resolved("$PARAM",kpi,kpiArr(kpi),order,dim,dimPro)=""
	..;add by wz.begin.2014-5-8.解析维度属性参数。
	..s dimProArg=$p(tmpDimPro,"(",2)
	..s dimProArg=$p(dimProArg,")",1)
	..i dimProArg'="" s resolved("$PARAM",kpi,kpiArr(kpi),order,dim,dimPro,"dimProArg")=dimProArg
	..;add by wz.end.2014-5-8.解析维度属性参数。	
	//now we can get the ignored dim and get the dimPro
	s kpiId="" f  s kpiId=$o(resolved("$PARAM",kpiId)) q:kpiId=""  d
	.s flag=1
	.q:'$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId))
	.s position="" f  s position=$o(resolved("$PARAM",kpiId,position)) q:position=""  d
	..s position=+position
	..s defDim="" f  s defDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,defDim)) q:defDim=""  d
	...s kpiDimId="" f  s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,defDim,kpiDimId)) q:kpiDimId=""  d
	....s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1) ;,order=+order,defDim=+defDim
	....i ($d(resolved("$PARAM",kpiId,position,order))=0)||($d(resolved("$PARAM",kpiId,position,order,defDim))=0) s resolved("$PARAM",kpiId,position,order,defDim)=0,flag=0
	....e  s resolved("$PARAM",kpiId,position,order,defDim)=1
	..i (flag=1) s resolved("$PARAM",kpiId,position)=1	//1 meanes do not need resolved directorly return
	..e  s resolved("$PARAM",kpiId,position)=0
	s mode=$zcvt(mode,"U")
	i mode [ "S" s resolved("$SumFlag")=1
	e  s resolved("$SumFlag")=0
	i mode [ "R" s resolved("$RealFlag")=1
	e  s resolved("$RealFlag")=0
	i mode [ "C" s resolved("$ConMaxFlag")=1
	e  s resolved("$ConMaxFlag")=0
	q
JudgeOnlySec(pro)
	s josDimLen=$l(pro,dimDeli),josFlagNum=0
	f josI=1:1:josDimLen {
		s theJosDim=$p(pro,dimDeli,josI)
		s theJosDim=##class(DHCWL.util.StringUtil).Trim(theJosDim)
		if $e(theJosDim,1)="$" s josFlagNum=josFlagNum+1
	}
	q josFlagNum=josDimLen
}

/// 取数规则解析方法
/// rule：待解析的指标取数规则，mode：取数模式，resolved：解析后的结果
/// rule和mode参数详细说明如下：
/// rule代表取数规则，定义如下：kpi1:dim1.dimPro1^dim1.dimPro2^dim2.dimPro1,kpi2:dim1.dimPro1......。kpi代表指标，dim代表维度，dimPro代表维度属性
/// 其中dim，dimPro可以缺省，若缺省dimPro则取dim下默认的dimPro，若缺省dim则取指标维度列表中第一个指标维度及其维度相关的默认维度属性
/// kpi,dim,dimPro可以是编码，也可以是id
/// mode：代表模式，目前支持的模式有：R实时数据模式；S汇总日期数据模式；C自动提升指标months区间模式。若出现R、S、C就代表使用该模式，否则代表不用该模式
/// C模式说明：若给定months id串为日日期，且该指标下有月日期的数据则自动将months id转换为对应的月日期的months id，以此类推会一直转换到年日期或该指标没有该日期类型下的数据为止，该模式只对历史数据有效
ClassMethod ResovleAccessRlue(rule As %Text, mode, ByRef resolved)
{
	n (rule,mode,resolved)
	s mode=$g(mode)
	s kpiDeli=",",dimDeli="^",proDeli=".",kdDeli=":", aliasDeli=" As "
	s dimLen=0
	k:$d(resolved) resolved
	s kpiLen=$l(rule,kpiDeli)
	s resolved("$PARAMKPI")=""
	k kpiArr
	s modeSec=$zcvt(mode,"U")
	//after 3.2 add the kpi position
	f i=1:1:kpiLen d
	.s kpiR=$p(rule,kpiDeli,i)
	.q:kpiR=""
	.s kpi=$p(kpiR,kdDeli,1)
	.i '$d(^DHCWL.MKPI.MKPID(kpi)) s kpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
	.q:(kpi="")
	.s kpi=+kpi
	.i ($d(kpiArr(kpi))=0) d
	..i resolved("$PARAMKPI")'="" s resolved("$PARAMKPI")=resolved("$PARAMKPI")_kpiDeli_kpi
	..e  s resolved("$PARAMKPI")=kpi
	..s kpiArr(kpi)=1
	.e  s kpiArr(kpi)=$g(kpiArr(kpi))+1
	.s resolved("$DELI",kpi)=","
	.//0 means not ignore
	.s resolved("$PARAM",kpi,kpiArr(kpi))=1 	//after 3.2
	.q:('$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi)))
	.s kpiDimDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi,""))
	.q:kpiDimDimId=""
	.s tempKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpi,kpiDimDimId,""))
	.q:tempKpiDimId=""
	.s kpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(tempKpiDimId),7,",")
	.s resolved("$DELI",kpi)=kpiDimDeli
	.s resolved("$DEF",kpi)=..GetKpiDim(kpi,dimDeli)
	.s dimProR=$p(kpiR,kdDeli,2)
	.i ((dimProR="")) s dimProR=resolved("$DEF",kpi),resolved("$PARAM",kpi,kpiArr(kpi))=1   //if not give dim use all dim
	.i modeSec [ "E"  s onlyTest=$$JudgeOnlySec2(dimProR)
	.else  d
	..i $$JudgeOnlySec2(dimProR) s dimProR=dimProR_dimDeli_resolved("$DEF",kpi)
	.;i $$JudgeOnlySec2(dimProR) s dimProR=dimProR_dimDeli_resolved("$DEF",kpi)
	.;s onlyTest=$$JudgeOnlySec2(dimProR) //s dimProR=dimProR_dimDeli_resolved("$DEF",kpi)
	.q:dimProR=""
	.s dimLen=$l(dimProR,dimDeli)
	.f j=1:1:dimLen d
	..s dimR=$p(dimProR,dimDeli,j)
	..q:dimR=""
	..s kpiDimCode=$p(dimR,proDeli,1)
	..s specialFlag=0
	..i $e(kpiDimCode,1)="$" d
	...s specialFlag=1
	...s secDim=$e(kpiDimCode,2,$l(kpiDimCode))
	...s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(secDim,"DHCWL.MKPI.Section")
	...q:secDimId=""
	...s dimPro=$p(dimR,proDeli,2)
	...if dimPro="" s secDimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
	...else  s secDimProId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(secDimId_"||"_dimPro)
	...i secDimProId="" s secDimProId="0"
	...e  s dimPro=$lg(^DHCWL.MKPI.SectionPropertyD(secDimProId),2)
	...s resolved("KPISECPRO",kpi,secDimProId,secDimId)=""
	...s curPos=$o(resolved("KPISECPRO2",kpi,""),-1)
	...s curPos=$g(curPos)+1
	...i $g(dimPro)="" s dimPro=0
	...s resolved("KPISECPRO2",kpi,curPos,dimPro)=""	;add since 4.2
	..q:specialFlag=1
	..s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpi,$zcvt(kpiDimCode,"U"),""))
	..q:kpiDimId=""
	..s dim=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
	..s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1)
	..q:dim=""
	..;s dim=+dim,order=+order
	..s resolved("$PARAM",kpi,kpiArr(kpi),order,dim)=1  //1 mean this is not ingored dim
	..s dimPro=$p(dimR,proDeli,2)
	..;add by wz.begin.2014-5-8.解析维度属性参数。
	..s tmpDimPro=dimPro
	..;add by wz.2014-11-20.解析维度属性时去除别名的影响
	..s tmpDimPro=$p(tmpDimPro," As ",1)
	..s tmpDimPro=##class(DHCWL.util.StringUtil).Trim(tmpDimPro)
	..s dimPro=$p(tmpDimPro,"(",1)
	..;add by wz.end.2014-5-8.解析维度属性参数。
	..s dimCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dim,"DHCWL.MKPI.MKPIDimType")
	..s dimPro=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode_"||"_dimPro,"DHCWL.MKPI.DimProperty") ;##class(DHCWL.MKPIService.ConfigService).GetDimProIdByCode(dimPro)
	..i dimPro="" d    //if is null use default
	...s defaDimProId=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dim,"Y",""))
	...s dimPro=defaDimProId
	..q:dimPro=""
	..;s dimPro=+dimPro
	..s resolved("$PARAM",kpi,kpiArr(kpi),order,dim,dimPro)=""
	..;add by wz.begin.2014-5-8.解析维度属性参数。
	..s dimProArg=$p(tmpDimPro,"(",2)
	..s dimProArg=$p(dimProArg,")",1)
	..i dimProArg'="" s resolved("$PARAM",kpi,kpiArr(kpi),order,dim,dimPro,"dimProArg")=dimProArg
	..;add by wz.end.2014-5-8.解析维度属性参数。	
	//now we can get the ignored dim and get the dimPro
	s kpiId="" f  s kpiId=$o(resolved("$PARAM",kpiId)) q:kpiId=""  d
	.s flag=1
	.q:'$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId))
	.s position="" f  s position=$o(resolved("$PARAM",kpiId,position)) q:position=""  d
	..s position=+position
	..s defDim="" f  s defDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,defDim)) q:defDim=""  d
	...s kpiDimId="" f  s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,defDim,kpiDimId)) q:kpiDimId=""  d
	....s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1) ;,order=+order,defDim=+defDim
	....i ($d(resolved("$PARAM",kpiId,position,order))=0)||($d(resolved("$PARAM",kpiId,position,order,defDim))=0) s resolved("$PARAM",kpiId,position,order,defDim)=0,flag=0
	....e  s resolved("$PARAM",kpiId,position,order,defDim)=1
	..i (flag=1) s resolved("$PARAM",kpiId,position)=1	//1 meanes do not need resolved directorly return
	..e  s resolved("$PARAM",kpiId,position)=0
	s mode=$zcvt(mode,"U")
	i mode [ "S" s resolved("$SumFlag")=1
	e  s resolved("$SumFlag")=0
	i mode [ "R" s resolved("$RealFlag")=1
	e  s resolved("$RealFlag")=0
	i mode [ "C" s resolved("$ConMaxFlag")=1
	e  s resolved("$ConMaxFlag")=0
	i mode [ "T" s resolved("$TotalFlag")=1
	e  s resolved("$TotalFlag")=0
	//add by wz . 2015-5-8. patch4.1.10
	i mode [ "O" s resolved("$ShowByRulerOrder")=1
	e  s resolved("$ShowByRulerOrder")=0
		
	q
JudgeOnlySec2(pro)
	s josDimLen=$l(pro,dimDeli),josFlagNum=0
	f josI=1:1:josDimLen {
		s theJosDim=$p(pro,dimDeli,josI)
		s theJosDim=##class(DHCWL.util.StringUtil).Trim(theJosDim)
		if $e(theJosDim,1)="$" s josFlagNum=josFlagNum+1
	}
	q josFlagNum=josDimLen
}

/// d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth("320","PP",.arr)
ClassMethod ResovleMonth(months As %Text, contractType, ByRef resolved)
{
	n (months,contractType,resolved)
	q:months=""
	k resolved
	s len=$l(months,",")
	s typeLen=$l(contractType,",")
	f i=1:1:len d
	.s resolved($p(months,",",i))=""
	f i=1:1:typeLen d
	.s type=$p(contractType,",",i)
	.q:type=""
	.s libId=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||"_type)
	.q:libId=""
	.f j=1:1:len d
	..s month=$p(months,",",j)
	..s resolved(month,libId)=##class(DHCWL.MKPIService.DateUtil).GeDirContrastMonId(month,type)
	..s resolved(month,libId,"CODE")=type
	q
}

/// 根据设置好的维度值，和指标取数规则，调用相应的解析函数，解析维度
/// Input：kpi要解析的指标，resolved解析完成后的取数规则，dimValues待解析的维度值
/// Output：返回解析后的维度值
ClassMethod ResolveDim(kpi, pos, ByRef resolved, dimValues, ByRef proArr = "") As %String
{
	n (kpi,pos,resolved,dimValues,proArr)
	s resolvedDim="",excDimValue="",kpiDimDeli=",",flag=1
	s kpi=+kpi
	q:$d(resolved("$PARAM",kpi,pos))=0 dimValues
	k proArr
	s comboNum=1,comboInd=0
	;s pos="" f  s pos=$o(resolved("$PARAM",kpi,pos)) q:pos=""  d
	s order="" f  s order=$o(resolved("$PARAM",kpi,pos,order)) q:(order="")  d
	.s dimDeli=resolved("$DELI",kpi)
	.s dimId="" f  s dimId=$o(resolved("$PARAM",kpi,pos,order,dimId)) q:(dimId="")  d
	..q:resolved("$PARAM",kpi,pos,order,dimId)=0
	..s dimV=$p(dimValues,dimDeli,order)
	..s dimBakV=dimV
	..s dimProId="" f  s dimProId=$o(resolved("$PARAM",kpi,pos,order,dimId,dimProId)) q:(dimProId="")  d
	...q:dimProId=""
	...s excCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),6)
	...q:excCode=$c(0)
	...;add by wz.2014-5-8.begin 加入维度属性参数的处理代码
	...i $g(resolved("$PARAM",kpi,pos,order,dimId,dimProId,"dimProArg"))'="" d
	....s dimProArg=resolved("$PARAM",kpi,pos,order,dimId,dimProId,"dimProArg")
	....s dimV=dimV_"~"_dimProArg
	...;add by wz.2014-5-8.end 加入维度属性参数的处理代码
	...s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),8,"")
	...;x "s excDimValue=$$"_excCode_"(dimV)"
	...s excDimValue=##class(DHCWL.MKPIService.SetKPIData).ExcuteDim("$$"_excCode,dimV)
	...s dimV=dimBakV
	...i ((proValueDeli'="")&&(proValueDeli'=$c(0))) d
	....q:excDimValue=""
	....s comboInd=comboInd+1
	....i resolvedDim="" d
	.....s dimDescLen=0
	....i resolvedDim'="" d 
	.....s dimDescLen=$l(resolvedDim,dimDeli)
	....s dimDescLen=dimDescLen+1
	....;s proArr("SEQ",comboInd)=order,proArr("SEQ",comboInd,dimProId)=""
	....s proArr("SEQ",comboInd)=dimDescLen,proArr("SEQ",comboInd,dimProId)=""
	....s deliLen=$l(excDimValue,proValueDeli)
	....s comboNum=comboNum*deliLen
	....f deliInd=1:1:deliLen d
	.....s tempV=$p(excDimValue,proValueDeli,deliInd)
	.....q:tempV=""
	.....s proArr("RES",comboInd)=deliLen
	.....s proArr("RES",comboInd,deliInd)=0
	.....s proArr("RES",comboInd,deliInd,tempV)=""
	....s excDimValue=" "
	...;q:excDimValue=""
	...i resolvedDim="" s resolvedDim=excDimValue
	...;modify by wk.2016-02-23
	...e  s resolvedDim=resolvedDim_dimDeli_excDimValue
	...;e  s resolvedDim=resolvedDim_","_excDimValue
	s proArr("TEMP")=1
	d ..ComboPri(comboInd,1,1,.proArr,.result)
	s i="" f  s i=$o(result(i)) q:i=""  d
	.s order="" f  s order=$o(result(i,order)) q:order=""  d
	..s value=result(i,order)
	..s proArr("OK",i,order)=value,proArr("OK",i,order,$o(result(i,order,"")))=""
	q resolvedDim
}

/// 计算组合情况
/// s src("SEQ",1)=1,src("SEQ",2)=3,src("RES",1,1,"A")="",src("RES",1,2,"B")="",src("RES",2,1,"C")="",src("RES",2,2,"D")=""
/// d ##class(DHCWL.MKPIService.SetKPIData).ComboPri(2,1,1,.src,.res)
/// [Previously private]
ClassMethod ComboPri(choiceNum As %Integer, hasChoiceNum As %Integer, totalNum As %Integer, ByRef src, ByRef result)
{
	n (choiceNum,hasChoiceNum,totalNum,src,result)
	q:$d(src)=0
	i hasChoiceNum<=choiceNum {
		f i=1:1:src("RES",hasChoiceNum) {
			continue:('$d(src("RES",hasChoiceNum,i)))
			i src("RES",hasChoiceNum,i)=0 {
				s src("RES",hasChoiceNum,i)=1
				s totalNum=src("TEMP")
				i (hasChoiceNum=choiceNum) {
					f k=1:1:hasChoiceNum {
						f l=1:1:src("RES",k) {
							continue:('$d(src("RES",k,l)))
							i src("RES",k,l)=1 {
								s tempOrder=src("SEQ",k)
								s result(totalNum,tempOrder)=$o(src("RES",k,l,""))
								s result(totalNum,tempOrder,$o(src("SEQ",k,"")))=""
							}
						}	
					}
					s totalNum=totalNum+1 ,src("TEMP")=totalNum
				}
				d ..ComboPri(choiceNum,hasChoiceNum+1,totalNum,.src,.result)
				s src("RES",hasChoiceNum,i)=0
			}
		}
	}
	q
}

/// 得到指标的维度列表
ClassMethod GetKpiDim(kpi, deli = ",") As %String
{
	n (kpi,deli)
	q:kpi="" ""
	i '$d(^DHCWL.MKPI.MKPID(kpi)) s kpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
	s kpiDimCodeList=""
	s code="" f  s code=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpi,code)) q:code=""  d
	.i kpiDimCodeList="" s kpiDimCodeList=code
	.e  s kpiDimCodeList=kpiDimCodeList_deli_code
	q kpiDimCodeList
}

/// 根据定义的指标维度按照顺序返回指标维度
ClassMethod GetKpiDimByOrder(kpi, deli = ",") As %String
{
	n (kpi,deli)
	q:kpi="" ""
	i '$d(^DHCWL.MKPI.MKPID(kpi)) s kpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
	s kpiDimCodeList="",preOrder=0
	k kpiDimOrderArr
	s code="" f  s code=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpi,code)) q:code=""  d
	.s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpi,code,""))
	.q:kpiDimId=""
	.s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
	.i (order="") s order=preOrder+1
	.s preOrder=order
	.s kpiDimOrderArr(order)=code
	s order="" f  s order=$o(kpiDimOrderArr(order)) q:order=""  d
	.i kpiDimCodeList="" s kpiDimCodeList=kpiDimOrderArr(order)
	.e  s kpiDimCodeList=kpiDimCodeList_deli_kpiDimOrderArr(order)
	q kpiDimCodeList
}

/// 根据取数规则，设置维度数据的实际值
ClassMethod SetDimValue(kpiId, position, dimValue, ByRef ignore) As %String
{
	n (kpiId,position,dimValue,ignore)
	q:dimValue="" ""
	q:'$d(ignore("$PARAM",kpiId,position)) dimValue
	//q:$g(resovled("$PARAM",+kpiId,position))=1 dimValue
	s resDimValue=dimValue
	s deli=ignore("$DELI",+kpiId)
	s order="" f  s order=$o(ignore("$PARAM",kpiId,position,order)) q:order=""  d
	.s dimId=$o(ignore("$PARAM",kpiId,position,order,""))
	.i $g(ignore("$PARAM",kpiId,position,order,dimId))=0 s $p(resDimValue,deli,order)=""
	q resDimValue
}

ClassMethod TrapExceptionMess(mess)
{
	n (mess)
	s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
	s ^DHCWLMKPI(0,"TRACK",+$h,id)=mess
	q 0
}

ClassMethod TrapExceptionFlag(ByRef continueFlag, para = "")
{
	n (continueFlag,para)
	s continueFlag=1
	s mess=$zerror
	i para'="" s mess="Parameters:"_para_$c(10)_$c(13)_mess
	w !,"Wrong in running!",!,mess,!
	d ##class(DHCWL.MKPIService.SetKPIData).TrapExceptionMess(mess)
	q
}

// d ##class(DHCWL.MKPIService.SetKPIData).RunError(753,170,1)

ClassMethod RunError()
{
	s infor=$ZERROR
	s errorInfor=$p(infor,"<",2)
	s errorInfor=$p(errorInfor,">",1)
	if (((errorInfor)="NOROUTINE")||((errorInfor)="NOLINE")){
		s errorExeCode=$g(^||TEMPDHCWL("kpiError",$j,"exeStr"))
		s infor="执行代码"_$g(errorExeCode)_"不存在"
		w !,"执行代码"_$g(errorExeCode)_"不存在",!
	}else{
		w $ZERROR
	}
	if ($g(^||TEMPDHCWL("kpiError",$j,"kpi"))'=""){
		s kpi=$g(^||TEMPDHCWL("kpiError",$j,"kpi"))
		s callFunction=$g(^||TEMPDHCWL("kpiError",$j,"callFunction"))
		s paraKpiRule=$g(^||TEMPDHCWL("kpiError",$j,"paraKpiRule"))
		s paraFilterRule=$g(^||TEMPDHCWL("kpiError",$j,"paraFilterRule"))
		s paraDateScope=$g(^||TEMPDHCWL("kpiError",$j,"paraDateScope"))
		s infor=$g(infor)
		k ^||TEMPDHCWL("kpiError",$j)
		do ##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginErrQuery(kpi,callFunction,paraKpiRule,paraFilterRule,paraDateScope,infor)
	}
	k ^||TEMPDHCWL("kpiError",$j),^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("S",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^TEMPDHCWLMKPI("SUMKPIDIM",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("S",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^||TEMPDHCWLMKPI("SUMKPIDIM",$j)
	//计算指标用
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j),^||TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	k ^TEMPDHCWLKPIDATA("G-cal",$j),^||TEMPDHCWLKPIDATA("G-cal",$j)
	//s $ECODE=""
	s $ze=""
	//q
}

ClassMethod ExcuteDim(exeStr, par)
{
 n (exeStr,par)
 s ^||TEMPDHCWL("kpiError",$j,"exeStr")=$g(exeStr)
 s exeStr="s dimValue="_exeStr_"("""_par_""")"
 x exeStr
 q $g(dimValue)
}

ClassMethod SetKpiRecObj(ByRef aryResovledRuler, kpiIdList, contractCode, monId, dimIdlList, dimDesList, kpiValueList, ByRef rec)
{
	//aryResovledRuler("COLInx",tempArr(dimproAlias),kpiId,proId)=kpiDimId
	n (aryResovledRuler,kpiIdList, contractCode, monId, dimIdlList, dimDesList, kpiValueList, rec)
	s colInx=""
	f {
		s colInx=$o(aryResovledRuler("COLInx",colInx))
		q:$g(colInx)=""
		s kpiId=""
		f {
			s kpiId=$o(aryResovledRuler("COLInx",colInx,kpiId))
			q:kpiId=""
			s proId=""
			
			f {
				q:$d(aryResovledRuler("COLInxHasData",colInx))	//避免重复维度属性数据
				s proId=$o(aryResovledRuler("COLInx",colInx,kpiId,proId))	
				q:proId=""
				s kpiDimId=aryResovledRuler("COLInx",colInx,kpiId,proId)
				s alias=aryResovledRuler("DIMPROALIAS",kpiId,kpiDimId,proId)
				
				s field=##Class(DHCWL.Interface.Field).%New()
				d field.SetName(alias)
				s value=$lg(dimDesList,colInx,"Null")
				d field.SetValue(value)
				d rec.SetAt(field,alias)
				
				s resoveldRulePos("COLInxHasData",colInx)=1
			}	
			
			s field=##Class(DHCWL.Interface.Field).%New()
			s valuePos=aryResovledRuler("COL",kpiId)
			s value=$lg(kpiValueList,valuePos,"0")
			s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
			d field.SetName(kpiCode)
			d field.SetValue(value)
			d rec.SetAt(field,kpiCode)			
			
		}
		
	}

	s field=##Class(DHCWL.Interface.Field).%New()
	s monDesc=$lg(monId,1,"")
	d field.SetName("monDesc")
	d field.SetValue(monDesc)
	d rec.SetAt(field,"monDesc")
	
	s field=##Class(DHCWL.Interface.Field).%New()
	d field.SetName("contractCode")
	d field.SetValue(contractCode)
	d rec.SetAt(field,"contractCode")
}

/// 描述: 解析执行代码的参数，返回的数据封装在DHCWL.Interface.Parameter对象下。
/// 参数: 	param：执行代码的参数：格式:指标编码1:参数名1=参数值1,参数名2=参数值2;指标编码2:参数名1=参数值1,参数名2=参数值2
/// 返回类型：	 DHCWL.Interface.Parameter 对象
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-12-4
/// 格式:kpi001:a=1,b=2;kpi002:a=11,b=22
/// d ##CLASS(MKPIService.SetKPIData).ResovleExecParam("kpi001:a=1,b=2;kpi002:a=11,b=22")
ClassMethod ResovleExecParam(execParam, ByRef aryExecParam)
{
	if $g(execParam)="" q
	s epSplit=";"		//切分成单个指标+参数的分隔符
	s kpiSplit=":"		//切分指标的分隔符
	s paramSplit=","	//切分单个参数的分隔符
	s pvSplit="="		//切分参数值的分隔符
	s epsLen=$l(execParam,epSplit)
	f i=1:1:epsLen {
		s ep=$p(execParam,epSplit,i)
		q:$g(ep)=""
		s kpi=$p(ep,kpiSplit,1)
		i '$d(^DHCWL.MKPI.MKPID(kpi)) s kpi=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpi)
		s params=$p(ep,kpiSplit,2)
		
		/*	4.1版
		s paramStr=""
		s paramLen=$l(params,paramSplit)
		f j=1:1:paramLen {
			s param=$p(params,paramSplit,j)
			q:$g(param)=""
			s paramName=$p(param,pvSplit,1)
			s paramValue=$p(param,pvSplit,2)
			if paramStr'="" s paramStr=paramStr_","
			s paramStr=paramStr_paramValue
		}
		s aryExecParam(kpi)=paramStr
		*/
		s execCode=$lg(^DHCWL.MKPI.MKPID(kpi),4)
		s aryExecParam(execCode)=params	//4.2版
		//s aryExecParam(kpi)=params	//4.2版
	}
}

/// d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData(1053,"K0079,K00079")
/// Description:： 根据取数规则和模式获得相应的指标数据，放在指定global^TEMPDHCWLKPIDATA("G",$j)下
/// Table：       DHCWL.MKPI.CalExpDef等
/// Input：       monIdStr:预留参数
/// 				  accessRule：指标取数规则，
/// 				  mode:取数模式
/// 				  contractType:预留参数
/// 				  filterRule:预留参数
/// 				  execParam:预留参数
/// Output：      ^TEMPDHCWLKPIDATA("G-cal",$j,0,KPIId,dim)
/// Return：      retStatus:成功则返回1,执行失败返回0
ClassMethod GetCalKPIData(monIdStr As %Text, accessRule As %Text, mode = "H", contractType = "", filterRule As %Text = "", execParam = "") As %Status
{
	n (monIdStr,accessRule,mode,contractType,filterRule,execParam)
	q:monIdStr="" 0
	q:accessRule="" 0
	i mode=0 s mode="H"
	s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
	d ..ResovleAccessRlue(accessRule,mode,.resovled)  //firstly resolve the param added in 3.0
	s isReal=resovled("$RealFlag")
	s sumFlag=resovled("$SumFlag")
	s convertFlag=resovled("$ConMaxFlag")
	s KPIIdStr=resovled("$PARAMKPI")
	s kpiIdLen=$l(KPIIdStr,",")

	k ^TEMPDHCWLKPIDATA("G",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	k ^TEMPDHCWLKPIDATA("G-cal",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j)
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
 	;d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)	//add by wz.2014-12-4.解析执行代码的参数。


	f lenKPI=1:1:kpiIdLen {
		//1、//得到运算指标的ID，保存到aryRelKpiID中
		s kpiId=$p(KPIIdStr,",",lenKPI)
		continue:kpiId=""
		s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"1")	//add since 4.2
		continue:getValueType="1"							//不是计算指标就退出
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
		s aryCalKpiID(kpiCode)=kpiId					//保存技术指标的CODE
	}

	//zw aryRelKpiID
	//2、得到所有参与运算的普通指标的code（ID），并存放到global:^TEMPDHCWL($j,"allRelKpiID")中
	d ..GetAllRelKpiIDs(.aryCalKpiID)
	//3、得到所有参与运算的普通指标的值
	d ..GetAllRelKpiValues(.resovled)
	//4、循环计算指标，求出每个计算指标的值
	
	k kpiArr
	s kpiCalCode=""
	f {
		s kpiCalCode=$o(aryCalKpiID(kpiCalCode))
		q:kpiCalCode=""
		s calKpiID=aryCalKpiID(kpiCalCode)
		
		s kpiArr(calKpiID)=$g(kpiArr(calKpiID))+1
		//得到参与运算的指标的汇总维度
		//d ..GetKpiSumDim(calKpiID,.resovled)
		s position = kpiArr(calKpiID)
		//s resovled("$DEF",calKpiID)="CTLOC^TAREC"
		s dim=resovled("$DEF",calKpiID)
		s sumDim=""
		s order=""
		s sumDimOrders=""
		f {
			s order=$o(resovled("$PARAM",calKpiID,position,order))	
			q:order=""
			s dimType=""
			s dimType=$o(resovled("$PARAM",calKpiID,position,order,dimType))
			if $g(resovled("$PARAM",calKpiID,position,order,dimType))=1 {
				if sumDim'="" s sumDim=sumDim_"^"
				s sumDim=sumDim_$p(dim,"^",order)
				if sumDimOrders'="" s sumDimOrders=sumDimOrders_","
				s sumDimOrders=sumDimOrders_order
			} 
		}
		d ..GetCalKpiVal(kpiCalCode,sumDimOrders)
		d ..FilterCalVal(kpiCalCode,.filterTree,.resovled,position)
		;k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	}
	//zw ^TEMPDHCWLKPIDATA("G-cal",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)	;add by wz .2015-5-3
	k ^TEMPDHCWLKPIDATA("G",$j)
	q 1
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-24
/// Description:：	执行计算公式获取计算值
/// Table：       	
/// Input：       	calFun：计算公式
/// Output：      	data
/// Return：      	-1：表示计算发生错误；
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetFormulaData(calFun)
/// 1.除数为0，发生错误；
ClassMethod GetFormulaData(calFun) As %String
{
	n (calFun)
	q:$g(calFun)="" "error"		
	s $zt="ErrorReturn"
	s excStr="s value="_calFun
	x excStr
	q $g(value)
	
ErrorReturn
	;抓取计算公式取数错误！
	w !,"ERROR:计算公式取数错误"_" 公式："_calFun
	q ""
}

ClassMethod TransCalKPIData() As %Status
{
	s kpiId=""
	f {
		s kpiId=$o(^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId))
		q:kpiId=""	
		s resDim=""
		f {
			s resDim=$o(^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim))
			q:resDim=""
			s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim)=^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim)		
			s position=""
			f {
				s position=$o(^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim,position))
				q:position=""
				s ^TEMPDHCWLKPIDATA("G",$j,0,kpiId,resDim,position)=^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim,position)
			}
		}
	}
	k ^TEMPDHCWLKPIDATA("G-cal",$j)
	q 1
}

/// 得到所有的参与运算的普通指标的id(code)
ClassMethod GetAllRelKpiIDs(ByRef aryCalKpiID)
{
	n (aryCalKpiID)
	s kpiCode=""

	f {
		s kpiCode=$o(aryCalKpiID(kpiCode))
		q:kpiCode=""
		s calExpID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode,""))
		q:$g(calExpID)=""
		s calExpObj=##class(DHCWL.MKPI.CalExpDef).%OpenId(calExpID)
		q:'$ISOBJECT(calExpObj)
		//s sumDim=calExpObj.SumDim
		s calExp=calExpObj.CalExp
		s lstExp=$LFS(calExp,">")
		s lstExpLen=$ll(lstExp)
		f lstInx=1:1:lstExpLen {
			s relKpiCode=$lg(lstExp,lstInx,"")
			s relKpiCode=$p(relKpiCode,"<",2)
			q:relKpiCode=""
			s relKpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(relKpiCode,"DHCWL.MKPI.MKPI")
			s getValueType=$lg(^DHCWL.MKPI.MKPID(relKpiID),14,"1")	//add since 4.2
			if ((+getValueType<2) && ('$d(^||TEMPDHCWL($j,"allRelKpiID",relKpiCode))))	{
				s ^||TEMPDHCWL($j,"allRelKpiID",relKpiCode)=relKpiID
			}
			if (getValueType="2") {
				s newAryCalKpiID(relKpiCode)=relKpiID
			}
		}
	
		i $d(newAryCalKpiID) {
			d ..GetAllRelKpiIDs(.newAryCalKpiID)
		}
	}
}

/// 得到所有的参与运算的普通指标值
ClassMethod GetAllRelKpiValues(ByRef resovled)
{
	s isReal=resovled("$RealFlag")
	s isRealData="S"
	if isReal s isRealData="RS"
	s normalKpiRule=""
	s relKpiCode=""
	f {
		s relKpiCode=$o(^TEMPDHCWL($j,"allRelKpiID",relKpiCode))
		q:relKpiCode=""
		i normalKpiRule'="" s normalKpiRule=normalKpiRule_","
		s normalKpiRule=normalKpiRule_relKpiCode
	}
	
	if normalKpiRule'="" d ..GetMutiMonKPIData(monIdStr,.normalKpiRule,isRealData,,,)
}

ClassMethod GetCalKpiVal(kpiCalCode, assignSumDimOrders)
{
	n (kpiCalCode,assignSumDimOrders)
	//b //3
	s kpiCalID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCalCode,"DHCWL.MKPI.MKPI")

	//resovled("$PARAM",851,position,1,30)=1
	//5、访问对象，得到计算指标的汇总维度和运算表达式
	s calExpID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCalCode,""))
	s calExpObj=##class(DHCWL.MKPI.CalExpDef).%OpenId(calExpID)
	q:'$ISOBJECT(calExpObj)
	
	s sumDim=calExpObj.SumDim
	//得到参与指标的汇总维度属性与计算指标的维度属性的映射关系，保存到aryRelKpiPos中
	d ..GetRelKpiDimPos2(sumDim,.aryRelKpiPos,assignSumDimOrders)
	s calExp=calExpObj.CalExp
	;6、得到计算指标汇总维度位置与参与计算的指标的维度之间的映射关系。保存到aryRelKpiPos
	s calDim=""
	s relKpiID=""
	//7、aryRelKpiPos的节点结构是这样的：aryRelKpiPos(参与运算的指标的ID,计算指标的维度位置序号,参与计算的指标的维度位置序号)
	f  {
		s relKpiID=$o(aryRelKpiPos(relKpiID))
		q:relKpiID=""
		q:$d(^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,0,relKpiID))	//已调整过节点位置就跳出
		
		s getValueType=$lg(^DHCWL.MKPI.MKPID(relKpiID),14,"1")		//getValueType为2表示计算指标
		i getValueType="2" {	
			s relKpiCode=aryRelKpiPos(relKpiID)
			d ..GetCalKpiVal(relKpiCode,assignSumDimOrders)
		}

		s dim=""
		f  {
			//s dim=$o(^TEMPDHCWLKPIDATA("G",$j,0,relKpiID,dim))
			s dim=$o(^TEMPDHCWLKPIDATA("G",$j,0,relKpiID,dim))
			q:dim=""
			s dimOrder=""
			s calDim=""
			//b  //3.1
			//8、取出参与运算指标的维度值，生成运算指标维度的维度值
			f {
				s dimOrder=$o(aryRelKpiPos(relKpiID,dimOrder))
				q:dimOrder=""
				s pos=$o(aryRelKpiPos(relKpiID,dimOrder,"")) 
				s resDim=$p(dim,",",pos)
				i calDim'="" s calDim=calDim_","
				s calDim=calDim_resDim
			}
			//9、参与运算指标的按运算指标的汇总维度进行汇总
			//s ^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim,relKpiID)=$g(^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim,relKpiID))+^TEMPDHCWLKPIDATA("G",$j,0,relKpiID,dim)
			s ^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim,relKpiID)=$g(^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim,relKpiID))+$g(^TEMPDHCWLKPIDATA("G",$j,0,relKpiID,dim))
		}
		s ^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,0,relKpiID)=1
			
	}
	
	//10、取出当前参与运算的指标的编码，存入aryCurRelKpi中
	s tCalExp=calExp
	s lstExp=$LFS(tCalExp,">")
	s lstExpLen=$ll(lstExp)
	f lstInx=1:1:lstExpLen {
		s relKpiCode=$lg(lstExp,lstInx,"")
		s relKpiCode=$p(relKpiCode,"<",2)
		q:relKpiCode=""
		s relKpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(relKpiCode,"DHCWL.MKPI.MKPI")
		s aryCurRelKpi(relKpiCode)=relKpiID
	}



	//11、遍历运算指标的指标维度
	s calDim=""
	f {
		//s calDim=$o(^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim))
		s calDim=$o(^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim))
		q:calDim=""
	
		//12、运算表达式中，把参与运算指标的指标代码替换成指标值。
		s relKpiCode=""
		s tCalExp=calExp
		f {
			s relKpiCode=$o(aryCurRelKpi(relKpiCode))
			q:relKpiCode=""
			s relKpiID=aryCurRelKpi(relKpiCode)
			//s relKpiCodeV=+$g(^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim,relKpiID))
			s relKpiCodeV=+$g(^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim,relKpiID))
			s tCode="<"_relKpiCode_">"
			s tCalExp= ##class(DHCWL.util.StringUtil).ReplaceStr(tCalExp,tCode,relKpiCodeV)
		}
		
		//12、执行运算表达式
		s value=..GetFormulaData(tCalExp)
		//13、保存计算指标的值
		//s ^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim,calKpiID)=value
		s ^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim,kpiCalID)=value	
	}
}

ClassMethod GetRelKpiDimPos2(sumDim As %String, ByRef aryRelKpi, assignSumDimOrders)
{
	n (sumDim,aryRelKpi,assignSumDimOrders)
	s kpiNum=$l(sumDim,",")
	f i=1:1:kpiNum {
		s sDim=$p(sumDim,",",i)
		s relKpiCode=$p(sDim,":",1)
		s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(relKpiCode,"DHCWL.MKPI.MKPI")
		s dims=$p(sDim,":",2)
		s dimLen=$l(assignSumDimOrders,",")
		s aryRelKpi(kpiID)=relKpiCode
		
		
		f j=1:1:dimLen {
			s dimOrder=$p(assignSumDimOrders,",",j)
			s dim=$p(dims,"^",dimOrder)
			continue:dim=""
			s alpDimCode=$SYSTEM.SQL.ALPHAUP(dim)
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiID,alpDimCode,""))	
			q:kpiDimID=""
			s order=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),6)
			s aryRelKpi(kpiID,j,order)=dimOrder	
		}	
	}
}

ClassMethod FilterCalVal(kpiCalCode, filterTree, resovled, position)
{
	n (kpiCalCode,filterTree,resovled,position) 
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCalCode,"DHCWL.MKPI.MKPI")

	s calDim=""
	f {
		s calDim=$o(^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,calDim))
		q:calDim=""

		//14、过滤
		s dim=calDim
		s tempKpiCode=kpiCalCode
		s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
		i filterFlag {
			s filterInd="" 
			f {
				s filterInd=$o(filterTree(tempKpiCode,filterInd))
				q:((filterInd="")||(filterResultFlag=0))
				continue:+filterInd=0
				s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd))
			}
		}
		continue:((filterFlag)&&(filterResultFlag=0))     //过滤结束
		
		s ^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,dim,position)=""
		s ^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,dim)=$g(^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,dim))+^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,dim,kpiId)  

		/*
		s position="" 
		f {
			s position=$o(resovled("$PARAM",kpiId,position))
			q:position=""
			//s resDim=..SetDimValue(kpiId,position,dim,.resovled) 
			s resDim=  dim
			s ^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim,position)=""
			s ^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim)=$g(^TEMPDHCWLKPIDATA("G-cal",$j,0,kpiId,resDim))+^TEMPDHCWLKPIDATA("G-dim-kpi",$j,0,dim,kpiId)  
		}
		*/
		
	}
}

/// Creator：      	王峥
/// CreatDate：    	2015-5-5
/// Description:： 	解析维度取数规则，并把结果保存到数组中
/// Table：       	无
/// Input：          dimRule：
/// 						格式：基础维度编码A:维度属性1^维度属性2,基础维度编码B:维度属性1^维度属性2^维度属性3
/// Output：         resolved:
/// 						格式：resolved（"$DIMPARAM",基础维度编码，维度属性编码)=维度属性在基础维度中的位置
/// Return：         
/// Others：        
/// d ##class(DHCWL.MKPIService.SetKPIData).ResovleDimRlue(dimRule,.resolved)
ClassMethod ResovleDimRlue(dimRule As %String, ByRef resolved)
{
	 s singleRuleSp=","		//维度类型分隔符
	 s dimTypeSp=":"
	 s dimProSp="^"
	 
	 k resolved
	 s ruleCnt=$l(dimRule,singleRuleSp)
	 f i=1:1:ruleCnt {
		 s singleRule=$p(dimRule,singleRuleSp,i)
		 s dimTypeCode=$p(singleRule,dimTypeSp,1)
		 s dimPros=$p(singleRule,dimTypeSp,2)
		 
		 if $g(dimPros)="" {	//维度顺序为空的，取默认维度属性。
		 	s dimID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimTypeCode,"DHCWL.MKPI.MKPIDimType") 
			s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimID,"Y",""))
			s dimPros=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
		 }
		 
		 s dimProCnt=$l(dimPros,dimProSp)
		 f j=1:1:dimProCnt {
			 s dimProCode=$p(dimPros,dimProSp,j)
			 continue:$g(dimProCode)=""
			 s resolved("$DIMPARAM",dimTypeCode,dimProCode)=j	 
		 }
	 }
}

/// Creator：      	王峥
/// CreatDate：    	2015-5-5
/// Description:： 	解析维度取数规则，并把结果保存到数组中
/// Table：       	无
/// Input：          dimRule：
/// 						格式：基础维度编码A:维度属性1^维度属性2,基础维度编码B:维度属性1^维度属性2^维度属性3
/// Output：         resolved:
/// 						格式：resolved（"$DIMPARAM",基础维度编码，维度属性编码)=维度属性在基础维度中的位置
/// Return：         
/// Others：        
/// d ##class(DHCWL.MKPIService.SetKPIData).ResovleDimRlue(dimRule,.resolved)
ClassMethod NewResovleDimRlue(dimRule As %String, ByRef resolved)
{
	 s singleRuleSp=","		//维度类型分隔符
	 s dimTypeSp=":"
	 s dimProSp="^"
	 
	 k resolved
	 s ruleCnt=$l(dimRule,singleRuleSp)
	 f i=1:1:ruleCnt {
		 s singleRule=$p(dimRule,singleRuleSp,i)
		 s dimTypeCode=$p(singleRule,dimTypeSp,1)
		 s dimPros=$p(singleRule,dimTypeSp,2)
		 
		 if $g(dimPros)="" {	//维度顺序为空的，取默认维度属性。
		 	s resolved("$DIMPARAM",dimTypeCode)=""
		 }
		 
		 s dimProCnt=$l(dimPros,dimProSp)
		 f j=1:1:dimProCnt {
			 s dimProCode=$p(dimPros,dimProSp,j)
			 continue:$g(dimProCode)=""
			 s resolved("$DIMPARAM",dimTypeCode,dimProCode)=j	 
		 }
	 }
}

/// d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData("336","MzDocYlFee:KDLoc.Loc^KDDoc.code^KDDoc.name","R",)
/// Description:： 根据取数规则和模式获得相应的指标数据，放在指定global^TEMPDHCWLKPIDATA("G",$j)下
/// Table：       DHCWL_MKPI.DHCWLMKPIData等
/// Input：       monIdStr:区间id指标串,用逗号分隔,如:"1,2,3",accessRule：指标取数规则，mode取数模式，详见ResovleAccessRlue方法的说明
/// Output：      ^TEMPDHCWLKPIDATA("G",$j,monId,monKPIId,loc),monKPIId:指标Id,loc:科室id,monId:区间Id
/// Return：      retStatus:成功则返回1,执行失败返回0
ClassMethod GetMutiMonKPIData2(gblFlag As %String, ByRef aryKpiConMon, ByRef resovled, ByRef filterTree, execParam = "") As %Status
{

	n (gblFlag,aryKpiConMon,resovled,filterTree,execParam)
	s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
	s isReal=$g(resovled("$RealFlag"))
 	
 	if '$d(gblFlag) s gblFlag="G"
	i isReal=0 {
	///resolved(kpiID,libId,conMonthid)=monthID
		s kpiID=""
		f {
			s kpiID=$o(aryKpiConMon(kpiID))	
			q:kpiID=""
			
			s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiID),14,"1")	//add since 4.2
			q:getValueType="2"									//是计算指标就退出			
			
			s libID=""
			f {
				s libID=$o(aryKpiConMon(kpiID,libID))	
				q:libID=""
				Merge aryMonthID=aryKpiConMon(kpiID,libID)
				d ..GetMonDimKPIDataOfHistory(kpiID ,gblFlag,libID,.aryMonthID,.filterTree,.resovled)
				k aryMonthID
			}
		}
	}else{
		d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)
		s kpiID=""
		f {
			s kpiID=$o(aryKpiConMon(kpiID))	
			q:kpiID=""
			
			s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiID),14,"1")	//add since 4.2
			q:getValueType="2"									//是计算指标就退出			
			
			s execCode=$listget(^DHCWL.MKPI.MKPID(kpiID),4,"")
			continue:execCode=""
			if (execCode [ "ETL")&&(execCode [ "("){
				s kpiRemark=$lg(^DHCWL.MKPI.MKPID(kpiID),6,"")
				if (kpiRemark'=""){
					s execCode="s sc=##"_execCode_"(startDate,endDate,.dataG,"""_kpiRemark_""")"
				}
			}
			s exData(execCode,kpiID)=""
		}
		q:'$d(exData)
		
		s kpiID=$o(aryKpiConMon(""))	
		Merge aryMonthID=aryKpiConMon(kpiID)

		d ..GetMonDimKPIDataOfReal(.exData ,gblFlag,.aryMonthID,.filterTree,.resovled,.aryExecParam)		
	}
	;k ^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	k ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
}

ClassMethod GetMonDimKPIDataOfReal(ByRef exData, gblFlag As %String, ByRef aryMonthID, ByRef filterTree, ByRef resovled, ByRef aryExecParam)
{
	n (exData,aryMonthID,filterTree,gblFlag,resovled,aryExecParam)
	
	s sumFlag=$g(resovled("$SumFlag"))
	s totalFlag=$g(resovled("$TotalFlag"))
	s conType=""
	f {
		s conType=$o(aryMonthID(conType))
		q:conType=""
		s monthID=""
		f {
			s monthID=$o(aryMonthID(conType,monthID))
			q:monthID=""
			
			
			s startDate=$li(^DHCWL.MKPI.MonthsD(monthID),7)
			s endDate=$li(^DHCWL.MKPI.MonthsD(monthID),4)
			i startDate'="" s startDate=$zd(startDate,3)
			i endDate'="" s endDate=$zd(endDate,3)
			s execCode=""
			f {
				s execCode=$o(exData(execCode))
				q:execCode=""
			
				i $d(aryExecParam(execCode)) {
					s execParam=aryExecParam(execCode)		
				}
				
				s runFlag=1    //only run once
				s kpiID="" 
				f {
					s kpiID=$o(exData(execCode,kpiID)) 
					q:kpiID="" 
					
					s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiID),13,"N")
					s tempKpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
					//modify by wk~2016-12-20
					/*i $g(execParam)'="" {	
						i globalFlag="Y" s execStr="d "_execCode_"(startDate,endDate,execParam)"  
						e  s execStr="d "_execCode_"(startDate,endDate,.dataG,execParam)"  
					}
					else{
						i globalFlag="Y" s execStr="d "_execCode_"(startDate,endDate)"  
						e  s execStr="d "_execCode_"(startDate,endDate,.dataG)"  
					}*/
					if (execCode '[ "ETL")&&(execCode '[ "("){
						if (execCode["^"){
							i $g(execParam)'="" {	
							i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate,execParam)"  
							e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG,execParam)"  
						}
						else{
							i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate)"  
							e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG)"  
						}
						}else{
							i $g(execParam)'="" {	
							i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate,execParam)"  
							e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG,execParam)"  
						}
						else{
							i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate)"  
							e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG)"  
						}
						}
					}else{
						s execStr=execCode
					}			
					
					i runFlag {
						i globalFlag="Y" {
							k ^TEMPDHCWLKPIDATA("S",$j)
							k ^||TEMPDHCWLKPIDATA("S",$j)
						}else{
							k dataG
						}
						s ^||TEMPDHCWL("kpiError",$j,"exeStr")=$g(execStr)
						x execStr
						s runFlag=0	
					}
					
					s dataNode=$listget(^DHCWL.MKPI.MKPID(kpiID),12,"")
					s nodeFlag=1
					i (dataNode="")||(dataNode=$c(0)) s nodeFlag=0
					
					s secdimPro=..GetSecDimPro(.resovled,kpiID,monthID)	//得到区间维度属性 
					i secdimPro=""  s secdimPro="STDT"

					i globalFlag="Y" {
						if ($d(^TEMPDHCWLKPIDATA("S",$j))){
							Merge ^||TEMPDHCWLKPIDATA("S",$j)=^TEMPDHCWLKPIDATA("S",$j)
							k ^TEMPDHCWLKPIDATA("S",$j)
						}
						//目前暂时不会调用..TransGloFromNorToPrc。在指标query改成进程global后调用
						//d ..TransGloFromNorToPrc(kpiID)	;add by wz.2015-7-29.如果执行代码中生成的数据保存到普通global中，就把数据转换到进程global中
						s dim=""
						f {
							s dim=$o(^||TEMPDHCWLKPIDATA("S",$j,dim)) 
							q:dim="" 
							continue:((nodeFlag=0)&&(($d(^||TEMPDHCWLKPIDATA("S",$j,dim)))'=1))
							continue:((nodeFlag=1)&&(($d(^||TEMPDHCWLKPIDATA("S",$j,dim,dataNode)))'=1))
							s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
							i (filterFlag) {
								s filterInd=""
								f {
									s filterInd=$o(filterTree(tempKpiCode,filterInd)) 
									q:((filterInd="")||(filterResultFlag=0))  
									continue:+filterInd=0
									s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,monthID)
									
								}
							}
							continue:((filterFlag)&&(filterResultFlag=0))     //过滤结束
							s value=0 
							i nodeFlag=0 s value=+$g(^||TEMPDHCWLKPIDATA("S",$j,dim))
							e  s value=+$g(^||TEMPDHCWLKPIDATA("S",$j,dim,dataNode))
							s position="" 
							f {
								s position=$o(resovled("$PARAM",kpiID,position)) 
								q:position=""  
								s resDim=..SetDimValue(kpiID,position,dim,.resovled)   //3.0 added
								
								i sumFlag=1 {	//汇总
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiID,resDim,secdimPro))+value  //3.0 add sum kpi data
								}elseif totalFlag=1{	//合计
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,"T")=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,"T"))+value  
								}else {		//明细
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monthID,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monthID,kpiID,resDim,secdimPro))+value
								}

							}
						}
						
					}else{
						s dim=""
						f {
							s dim=$o(dataG(dim)) 
							q:dim=""	
							continue:((nodeFlag=0)&&($d(dataG(dim))'=1))
							continue:((nodeFlag=1)&&($d(dataG(dim,dataNode))'=1))
							s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
							i filterFlag {
								s filterInd="" 
								f {
									s filterInd=$o(filterTree(tempKpiCode,filterInd))
									q:((filterInd="")||(filterResultFlag=0))  
									continue:+filterInd=0
									s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd),,monthID)
							
								}
							}
							continue:((filterFlag)&&(filterResultFlag=0))
							s value=0
							i nodeFlag=0 s value=+$g(dataG(dim)) 
							e  s value=+$g(dataG(dim,dataNode))
							s position="" 
							f {
								s position=$o(resovled("$PARAM",kpiID,position)) 
								q:position=""  
								s resDim=..SetDimValue(kpiID,position,dim,.resovled)
								
								i sumFlag=1 {	//汇总
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiID,resDim,secdimPro))+value  //3.0 add sum kpi data
								}elseif totalFlag=1{	//合计
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,"T")=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,"T"))+value  
								}else {		//明细
									s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monthID,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monthID,kpiID,resDim,secdimPro))+value
								}
								
							}
						}					
					}
					/*i globalFlag="Y" {
						k ^||TEMPDHCWLKPIDATA("S",$j)
						k ^TEMPDHCWLKPIDATA("S",$j)	;add by wz.2015-6-11.执行代码中生成的数据保存到普通global中
					}*/
				}
				i globalFlag="Y" {
						k ^||TEMPDHCWLKPIDATA("S",$j)
						k ^TEMPDHCWLKPIDATA("S",$j)	;add by wz.2015-6-11.执行代码中生成的数据保存到普通global中
				}
			}
		}
	}
}

ClassMethod GetMonDimKPIDataOfHistory(kpiID, gblFlag, contractType, ByRef aryMonthID, ByRef filterTree, ByRef resovled)
{
	
	s sumFlag=$g(resovled("$SumFlag"))
	s totalFlag=$g(resovled("$TotalFlag"))
	s monID=""
	f {
		s monID=$o(aryMonthID(monID))
		q:monID=""
		
		s secdimPro=..GetSecDimPro(.resovled,kpiID,monID)	//得到区间维度属性 
		i secdimPro=""  s secdimPro="STDT"
		s monKpiID=0
		f {
			s monKpiID=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monID,kpiID,monKpiID))	
			q:monKpiID=""
			s depKpiID=0
			f {
				s depKpiID=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKpiID,depKpiID))
				q:depKpiID=""
				
				q:('$d(^DHCWL.MKPI.DeptKPIDataD(depKpiID)))
				s dim=$lg(^DHCWL.MKPI.DeptKPIDataD(depKpiID),2)
				s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)  //过滤开始
				
				s filterResult=1
				i $d(filterTree(kpiCode)) {
					s filterInd="" 
					f {
						s filterInd=$o(filterTree(kpiCode,filterInd)) 
						q:+filterInd=0
						s filterResult=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dim,filterTree(kpiCode,filterInd),,monID)
						q:filterResult=0
					}
				} 
				continue:filterResult=0     //过滤结束
				
				s value=$lg(^DHCWL.MKPI.DeptKPIDataD(depKpiID),4)
				s position="" 
				f  {
					s position=$o(resovled("$PARAM",kpiID,position)) 
					q:position=""  
					s resDim=..SetDimValue(kpiID,position,dim,.resovled)  
 					
 					
					i sumFlag=1 {	//汇总
						//s ^TEMPDHCWLKPIDATA(gblFlag,$j,0,kpiId,resDim,position)=""
						s ^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,0,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,0,kpiID,resDim,secdimPro))+value  //3.0 add sum kpi data
					}elseif totalFlag=1{	//合计
						s ^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,"T")=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,"T"))+value  
					}else {		//明细
						//s ^TEMPDHCWLKPIDATA(gblFlag,$j,monId,kpiId,resDim,position)=""
						s ^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,monID,kpiID,resDim,secdimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,contractType,monID,kpiID,resDim,secdimPro))+value
					}
				}
			}
		}	
	}
}

ClassMethod ResovleMulMonth(ByRef resovled, monthIDs As %Text, contractType = "", ByRef aryKpiConMon, mode = "")
{
	n (resovled,monthIDs,mode,aryKpiConMon,contractType)
	if (mode [ "P"){
		s resovled("$ConMaxFlag")=0
		d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resovled, monthIDs, contractType,.aryKpiConMon)
		q
	}else{
		d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resovled, monthIDs, contractType,.aryKpiConMon)
		q
	}
}

/// d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth("320","PP",.arr)
/// resolved(kpiID,STDT,monthid)=""
/// resolved(kpiID,libId,conMonthid)=monthID
ClassMethod ResovleMonth2(ByRef resovled, monthIDs As %Text, contractType, ByRef aryKpiConMon)
{
	n (resovled,monthIDs,contractType,aryKpiConMon)
	q:monthIDs=""
	

	s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
	//d ..ResovleAccessRlue(accessRule,mode,.resovled)  //firstly resolve the param added in 3.0
	s convertFlag=resovled("$ConMaxFlag")
	s KPIIdStr=resovled("$PARAMKPI")
	s kpiIdLen=$l(KPIIdStr,",")
	
	s isReal=resovled("$RealFlag")
	s monthIDsPara=monthIDs
	s sectionErrorFlag=0
	
	f lenKPI=1:1:kpiIdLen {
		s kpiID=$p(KPIIdStr,",",lenKPI)
		q:kpiID=""
		
		i ((convertFlag=1)&&(isReal'=1)) {
			s monIdStr1=monthIDsPara,convertOk=0
			f needConNum=1:1:4 {
				s monIdStr2=##class(DHCWL.MKPIService.DateUtil).ConvertMaxSectionByKpi(monIdStr1,kpiID)
				q:monIdStr1=monIdStr2
				s monIdStr1=monIdStr2
			}
			if (sectionErrorFlag=1){
				q
			}
			s monthIDs=monIdStr1

			//d ..ResovleMonth(monIdStr,contractType,.resovledMon)
		}
	
		d ..Str2Ary(monthIDs,.aryMonth)
		Merge aryKpiConMon(kpiID,"STDT")=aryMonth
		k aryMonth
	
		s monthLen=$l(monthIDs,",")
		s conTypeLen=$l(contractType,",")

		f i=1:1:conTypeLen {
			s type=$p(contractType,",",i)
			continue:type=""
			s libId=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||"_type)
			continue:libId=""
			//s strConData=##class(DHCWL.MKPIService.DateUtil).GetContrastStrMonId(monthIDs,type)
			//d ..Str2Ary(strConData,.aryMonth)
			d ##class(DHCWL.MKPIService.DateUtil).GetContrastAryMonId(monthIDs,type,.aryMonth)
			if $d(aryMonth) {
				Merge aryKpiConMon(kpiID,libId)=aryMonth
				k aryMonth
			}
		}

	}
	if (sectionErrorFlag=1){
		q
	}
}

ClassMethod Str2Ary(strData As %Text, ByRef resolved)
{
	n (strData,resolved)
	s strLen=$l(strData,",")
	f i=1:1:strLen {
		s pieceData=$p(strData,",",i)
		s resolved(pieceData)=""	
	}
}

ClassMethod GetSecDimPro(ByRef resolve, kpiId As %String, monId As %String) As %String
{
	n (resolve,kpiId,monId)
	q:'$d(resolve("KPISECPRO2",kpiId)) "NOTEXIST" 
	
	s strRet=""
	s secResProValue=""
	s secID=$li(^DHCWL.MKPI.MonthsD(monId),11)

	
	s pos=0
	f {
		s pos=$o(resolve("KPISECPRO2",kpiId,pos))
		q:pos=""
		
		s secProCode="" 
		f  {
			s secProCode=$o(resolve("KPISECPRO2",kpiId,pos,secProCode))
			q:secProCode=""

			i secProCode=0 {	//默认维度属性，取描述
				s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId),3)
			}else{
				s alphaCode=$SYSTEM.SQL.ALPHAUP(secProCode)
				s secProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",secID,alphaCode,""))
				q:secProId=""
								
	 			s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
	 			if proExcStr="" {
		 			s secResProValue="无区间维度执行代码"
	 			}else{
		 			s proExcStrTest=proExcStr
		 			//s proExcStr="s secResProValue=$$"_proExcStr_"("""_monId_""")"
		 			//x proExcStr
		 			s secResProValue=##class(DHCWL.MKPIService.SetKPIData).ExcuteDim("$$"_proExcStr,monId)
	 			}
	 		}
			i $g(strRet)'="" {
				s strRet=strRet_","
			}
			s strRet=strRet_secResProValue

		}
	}
	q strRet
}

ClassMethod GetCalKPIDataSec(monIdStr As %Text, accessRule As %Text, mode = "H", contractType = "", filterRule As %Text = "", execParam = "") As %Status
{
	n (monIdStr,accessRule,mode,contractType,filterRule,execParam)
	q:monIdStr="" 0
	q:accessRule="" 0
	i mode=0 s mode="H"
	//s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
	d ..ResovleAccessRlue(accessRule,mode,.resovled)  //firstly resolve the param added in 3.0
	s isReal=resovled("$RealFlag")
	s sumFlag=resovled("$SumFlag")
	s convertFlag=resovled("$ConMaxFlag")
	s KPIIdStr=resovled("$PARAMKPI")
	s kpiIdLen=$l(KPIIdStr,",")

	k ^TEMPDHCWLKPIDATA("G",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	k ^TEMPDHCWLKPIDATA("G-cal",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j)
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
 	;d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)	//add by wz.2014-12-4.解析执行代码的参数。


	f lenKPI=1:1:kpiIdLen {
		//1、//得到运算指标的ID，保存到aryRelKpiID中
		s kpiId=$p(KPIIdStr,",",lenKPI)
		continue:kpiId=""
		s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"1")	//add since 4.2
		continue:getValueType="1"							//不是计算指标就退出
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
		s aryCalKpiID(kpiCode)=kpiId					//保存技术指标的CODE
	}

	//zw aryRelKpiID
	//2、得到所有参与运算的普通指标的code（ID），并存放到global:^TEMPDHCWL($j,"allRelKpiID")中
	d ..GetAllRelKpiIDs(.aryCalKpiID)
	//3、得到所有参与运算的普通指标的值
	d ..GetAllRelKpiValues(.resovled)
	//4、循环计算指标，求出每个计算指标的值
	
	k kpiArr
	s kpiCalCode=""
	f {
		s kpiCalCode=$o(aryCalKpiID(kpiCalCode))
		q:kpiCalCode=""
		s calKpiID=aryCalKpiID(kpiCalCode)
		
		s kpiArr(calKpiID)=$g(kpiArr(calKpiID))+1
		//得到参与运算的指标的汇总维度
		//d ..GetKpiSumDim(calKpiID,.resovled)
		s position = kpiArr(calKpiID)
		//s resovled("$DEF",calKpiID)="CTLOC^TAREC"
		s dim=resovled("$DEF",calKpiID)
		s sumDim=""
		s order=""
		s sumDimOrders=""
		f {
			s order=$o(resovled("$PARAM",calKpiID,position,order))	
			q:order=""
			s dimType=""
			s dimType=$o(resovled("$PARAM",calKpiID,position,order,dimType))
			if $g(resovled("$PARAM",calKpiID,position,order,dimType))=1 {
				if sumDim'="" s sumDim=sumDim_"^"
				s sumDim=sumDim_$p(dim,"^",order)
				if sumDimOrders'="" s sumDimOrders=sumDimOrders_","
				s sumDimOrders=sumDimOrders_order
			} 
		}
		d ..GetCalKpiVal(kpiCalCode,sumDimOrders)
		d ..FilterCalVal(kpiCalCode,.filterTree,.resovled,position)
		;k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	}
	//zw ^TEMPDHCWLKPIDATA("G-cal",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)	;add by wz .2015-5-3
	k ^TEMPDHCWLKPIDATA("G",$j)
	q 1
}

/// 数据结构为：aryKpiConMon(kpiID,比对标识,monthid1)=monthid2
ClassMethod GetCalKPIData2(gblFlag As %String, ByRef aryKpiConMon, ByRef resovled, ByRef filterTree)
{
	n (gblFlag,aryKpiConMon,resovled,filterTree)
	
	q:resovled("$TotalFlag")=1	//如果是求合计就退出
	
	//清空要用到的global
	//k ^TEMPDHCWLKPIDATA("G",$j)				//不使用这个，避免与取数query冲突
	k ^||TEMPDHCWLKPIDATA("G-dim-kpi",$j)			//保存计算指标的中间处理数据
	k ^||TEMPDHCWLKPIDATA("G-cal",$j)				//保存计算指标的数据
	k ^||TEMPDHCWLKPIDATA("G-rel",$j)				//保存参与计算的指标的数据
	k ^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j)	//标识global。保存哪些指标已经被读到程序中，避免重复读取
	
	//筛选指标，把计算指标复制到数组aryCalKpiConMon中
	s kpiID=""
	f {
		s kpiID=$o(aryKpiConMon(kpiID))
		q:kpiID=""
		s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiID),14,"1")	//add since 4.2
		continue:getValueType="1"                            //不是计算指标就退出
		continue:getValueType=""							
		Merge aryCalKpiConMon(kpiID)=aryKpiConMon(kpiID)
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiID,"DHCWL.MKPI.MKPI")
		s aryCalKpiID(kpiCode)=kpiID
			
	}
	//s $ET="d ##class(DHCWL.MKPIService.SetKPIData).CalRunError()"
	//2、得到所有参与运算的普通指标的code（ID），并存放到global:^TEMPDHCWL($j,"allRelKpiID")中
	d ..GetAllRelKpiIDs(.aryCalKpiID)
	//3、得到所有参与运算的普通指标的值
	s isRealData=resovled("$RealFlag")
	d ..GetAllRelKpiValues2("G-Rel",.aryCalKpiConMon,isRealData)
	
	//4、循环计算指标，求出每个计算指标的值
	k kpiArr
	s kpiCalCode=""
	f {
		s kpiCalCode=$o(aryCalKpiID(kpiCalCode))
		q:kpiCalCode=""
		s calKpiID=aryCalKpiID(kpiCalCode)
		
		s kpiArr(calKpiID)=$g(kpiArr(calKpiID))+1
		//得到参与运算的指标的汇总维度
		//position：为了区分相同指标而定义的一个位置序号。目前来看，这个position的值一直会是1
		s position = kpiArr(calKpiID)
		s dim=resovled("$DEF",calKpiID)
		s sumDim=""
		s order=""
		
		//把取数规则中计算指标的维度属性的序号保存在sumDimOrders中。
		s sumDimOrders=""
		f {
			s order=$o(resovled("$PARAM",calKpiID,position,order))	
			q:order=""
			s dimType=""
			s dimType=$o(resovled("$PARAM",calKpiID,position,order,dimType))
			if $g(resovled("$PARAM",calKpiID,position,order,dimType))=1 {
				//if sumDim'="" s sumDim=sumDim_"^"
				//s sumDim=sumDim_$p(dim,"^",order)
				if sumDimOrders'="" s sumDimOrders=sumDimOrders_","
				s sumDimOrders=sumDimOrders_order
			} 
		}
		//得到计算指标的值
		d ..GetCalKpiVal2("G-Rel",kpiCalCode,sumDimOrders,.resovled,.filterTree)
		//过滤计算指标的值
		d ..FilterCalVal2(gblFlag,kpiCalCode,.filterTree,.resovled,position)
	}

	k ^||TEMPDHCWLKPIDATA("G-dim-kpi",$j)			//保存计算指标的中间处理数据
	k ^||TEMPDHCWLKPIDATA("G-cal",$j)				//保存计算指标的数据
	k ^||TEMPDHCWLKPIDATA("G-rel",$j)				//保存参与计算的指标的数据
	k ^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j)	//标识global。保存哪些指标已经被读到程序中，避免重复读取
	
	
	q 1
}

ClassMethod CalRunError()
{
	w $zerror,!
	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("S",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
	//计算指标用
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	k ^TEMPDHCWLKPIDATA("G-cal",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi",$j)
	k ^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j)
}

/// 得到所有的参与运算的普通指标值
ClassMethod GetAllRelKpiValues2(gblFlag, ByRef aryCalKpiConMon, isRealData)
{
	n (gblFlag,aryCalKpiConMon,isRealData)
	k resolved
	i isRealData [ "R" s resolved("$RealFlag")=1
	e  s resolved("$RealFlag")=0
		
	s calKpiID=$o(aryCalKpiConMon(""))
	s relKpiCode=""
	//对于参与运算的指标，取数时全部使用与计算指标相同的对比方式和日期区间
	f {
		s relKpiCode=$o(^||TEMPDHCWL($j,"allRelKpiID",relKpiCode))
		q:relKpiCode=""
		s relKpiID=^||TEMPDHCWL($j,"allRelKpiID",relKpiCode)
		//把计算指标的对比方式和日期区间复制给参与指标
		m aryKpiConMon(relKpiID) = aryCalKpiConMon(calKpiID)
		//下面2行没有实际意义，只是为了在读取指标数据时避免因为没有这些数据而报错。
		s resolved("$PARAM",relKpiID,1)=1
		s resolved("$DELI",relKpiID)=","
	}
	
	
	//清除global
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	//获取指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData2(gblFlag,.aryKpiConMon,.resolved,.filterTree,"")
}

ClassMethod GetCalKpiVal2(gblFlag, kpiCalCode, assignSumDimOrders, ByRef resovled, ByRef filterTree)
{
	n (gblFlag,kpiCalCode,assignSumDimOrders,resovled,filterTree)

	s kpiCalID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCalCode,"DHCWL.MKPI.MKPI")

	//5、访问对象，得到计算指标的汇总维度和运算表达式
	s calExpID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCalCode,""))
	s calExpObj=##class(DHCWL.MKPI.CalExpDef).%OpenId(calExpID)
	q:'$ISOBJECT(calExpObj)
	
	s sumDim=calExpObj.SumDim
	;6、得到计算指标汇总维度位置与参与计算的指标的维度之间的映射关系。保存到aryRelKpiPos	
	//7、aryRelKpiPos的节点结构是这样的：aryRelKpiPos(参与运算的指标的ID,计算指标的维度位置序号,参与计算的指标的维度位置序号)
	d ..GetRelKpiDimPos2(sumDim,.aryRelKpiPos,assignSumDimOrders)
	s calExp=calExpObj.CalExp
	s calDim=""
	s relKpiID=""
	f  {
		s relKpiID=$o(aryRelKpiPos(relKpiID))
		q:relKpiID=""

		s conType=""
		f {
			s conType=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType))
			q:conType=""
			
			q:$d(^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,conType,0,relKpiID))
			
			s monID=""
			f {
				s monID=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID))
				q:monID=""
				
				s newSecDimPro=..GetSecDimPro(.resovled,kpiCalID,monID)
				//q:$d(^TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,conType,monID,relKpiID))	//如果该指标数据已被调整过，就退出
				s getValueType=$lg(^DHCWL.MKPI.MKPID(relKpiID),14,"1")	//add since 4.2	//getValueType值为1表示普通指标，2表示计算指标
				i getValueType="2" {	
					//这个参与指标也是个计算指标
					s relKpiCode=aryRelKpiPos(relKpiID)
					m newResovled("KPISECPRO2",relKpiID)=resovled("KPISECPRO2",kpiCalID)	//把当前计算指标的维度属性数据复制给参与指标
					m newfilterTree(relKpiCode)=filterTree(kpiCalCode)
					d ..GetCalKpiVal2(gblFlag,relKpiCode,assignSumDimOrders,.newResovled,.newfilterTree)
					k newResovled
				}
				
				q:$d(^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,conType,0,relKpiID))

				s dim=""
				f  {
					s dim=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,relKpiID,dim))
					q:dim=""
					s dimOrder=""
					s calDim=""
					//b  //3.1
					//8、取出参与运算指标的维度值，生成运算指标维度的维度值
					f {
						s dimOrder=$o(aryRelKpiPos(relKpiID,dimOrder))
						q:dimOrder=""
						s pos=$o(aryRelKpiPos(relKpiID,dimOrder,"")) 
						
						s resDim=$p(dim,",",pos)
						/*
						i calDim'="" s calDim=calDim_","
						s calDim=calDim_resDim
						*/
						s calKpiDimProOrder=aryRelKpiPos(relKpiID,dimOrder,pos)
						s $p(calDim,",",calKpiDimProOrder)=resDim
					}
					//9、参与运算指标的按运算指标的汇总维度进行汇总
					//^TEMPDHCWLKPIDATA(gblFlag,$j,contractType,0,kpiID,resDim,secdimPro)
					
					//对区间维度进行过滤
					/*
					s filterResult=1
					i $d(filterTree(kpiCalCode)) {
						s filterInd="" 
						f {
							s filterInd=$o(filterTree(kpiCalCode,filterInd)) 
							q:+filterInd=0
							s filterResult=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCalCode,"",,filterTree(kpiCalCode,filterInd),,monID)
							q:filterResult=0
						}
					} 
					continue:filterResult=0     //过滤结束
							*/
					s secdimPro="" 
					f {
						s secdimPro=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,relKpiID,dim,secdimPro))
						q:secdimPro=""
						//s ^TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,relKpiID,newSecDimPro)=$g(^TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,relKpiID,newSecDimPro))+$g(^TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,relKpiID,dim,secdimPro))
						s ^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,newSecDimPro,relKpiID)=$g(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,newSecDimPro,relKpiID))+$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,relKpiID,dim,secdimPro))
					}
				}
			}
			s ^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,conType,0,relKpiID)=1

		}

			
	}
	
	//10、取出当前参与运算的指标的编码，存入aryCurRelKpi中
	s tCalExp=calExp
	s lstExp=$LFS(tCalExp,">")
	s lstExpLen=$ll(lstExp)
	f lstInx=1:1:lstExpLen {
		s relKpiCode=$lg(lstExp,lstInx,"")
		s relKpiCode=$p(relKpiCode,"<",2)
		q:relKpiCode=""
		s relKpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(relKpiCode,"DHCWL.MKPI.MKPI")
		s aryCurRelKpi(relKpiCode)=relKpiID
	}

	//11、遍历运算指标的指标维度
	//s ^TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,relKpiID,secdimPro)
	s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType))
		q:conType=""
		s calDim=""
		f {
			//s calDim=$o(^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim))
			s calDim=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim))
			q:calDim=""
	
			//12、运算表达式中，把参与运算指标的指标代码替换成指标值。



			//s relKpiCodeV=+$g(^TEMPDHCWLKPIDATA("G-cal",$j,0,calDim,relKpiID))
			s secdimPro="" 
			f {
				s secdimPro=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,secdimPro))
				q:secdimPro=""
				
				s tCalExp=calExp
				s relKpiCode=""
				f {
					s relKpiCode=$o(aryCurRelKpi(relKpiCode))
					q:relKpiCode=""
					s relKpiID=aryCurRelKpi(relKpiCode)

					s relKpiCodeV=+$g(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,secdimPro,relKpiID))
					s tCode="<"_relKpiCode_">"
					s tCalExp= ##class(DHCWL.util.StringUtil).ReplaceStr(tCalExp,tCode,relKpiCodeV)
				}
				s value=..GetFormulaData(tCalExp)
				//13、保存计算指标的值
				s ^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,secdimPro,kpiCalID)=value	

				
			}

		}
		s ^||TEMPDHCWLKPIDATA("G-dim-kpi-loaded",$j,conType,0,kpiCalID)=1
	}
}

ClassMethod FilterCalVal2(gblFlag, kpiCalCode, ByRef filterTree, ByRef resovled, position)
{
	n (gblFlag,kpiCalCode,filterTree,resovled,position) 
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCalCode,"DHCWL.MKPI.MKPI")

	s conType=""
	f {
		//^TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,relKpiID,secdimPro)
		s conType=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType))
		q:conType=""
		
		s calDim=""
		f {
			s calDim=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim))
			q:calDim=""

			//14、过滤普通维度

			s dim=calDim
			s tempKpiCode=kpiCalCode
			s filterFlag=$d(filterTree(tempKpiCode)),filterResultFlag=1
			i filterFlag {
				s filterInd="" 
				f {
					s filterInd=$o(filterTree(tempKpiCode,filterInd))
					q:((filterInd="")||(filterResultFlag=0))
					continue:+filterInd=0
					s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(tempKpiCode,"",dim,filterTree(tempKpiCode,filterInd))
				}
			}
			continue:((filterFlag)&&(filterResultFlag=0))     //过滤结束
			s secDimPro=""
			f {
				s secDimPro=$o(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,calDim,secDimPro))
				q:secDimPro=""
				//s ^TEMPDHCWLKPIDATA("G-cal",$j,conType,0,kpiId,dim,secDimPro)=$g(^TEMPDHCWLKPIDATA("G-cal",$j,conType,0,kpiId,dim,secDimPro))+^TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,dim,kpiId,secDimPro)  	
				s ^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiId,dim,secDimPro)=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,0,kpiId,dim,secDimPro))+$g(^||TEMPDHCWLKPIDATA("G-dim-kpi",$j,conType,0,dim,secDimPro,kpiId))  	
			}
		}
	}
}

/// 描述:转换节点数据，把普通global数据转换成进程global数据。
/// 参数: 	kpiId：指标ID
/// 返回类型：	 
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2015-6-11
/// d ##CLASS(MKPIService.SetKPIData).TransGloFromNorToPrc("KLQ0004")
ClassMethod TransGloFromNorToPrc(kpiId)
{
	n (kpiId)
	s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	q:globalFlag'="Y"
	q:'$d(^TEMPDHCWLKPIDATA("S",$j))

	s dataNode=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	s nodeFlag=1
	i (dataNode="")||(dataNode=$c(0)) s nodeFlag=0
	
	s dim=""
	f {
		s dim=$o(^TEMPDHCWLKPIDATA("S",$j,dim))
		q:dim=""
		i nodeFlag=0 {
			s ^||TEMPDHCWLKPIDATA("S",$j,dim)=^TEMPDHCWLKPIDATA("S",$j,dim)

		}else{
			s dataNode=""
			f {
				s dataNode=$o(^TEMPDHCWLKPIDATA("S",$j,dim,dataNode))	
				q:dataNode=""
				s ^||TEMPDHCWLKPIDATA("S",$j,dim,dataNode)=^TEMPDHCWLKPIDATA("S",$j,dim,dataNode)
			}
			
		}
		
	}
}

ClassMethod CreatHightSecSpecialKpiData(rebuildFlag = 0, execParam As %String = "") As %Status
{
	n (rebuildFlag,execParam)
	//遍历日区间，找出可能需要重做月数据的区间
	k kpiMonthList
	k aryExecParam
	//获取可以重做月数据的区间
	d ##CLASS(DHCWL.MKPIService.SetKPIData).GetMonSecAndKpi(.kpiMonthList)
	
	//获取可以重做季数据的区间
	d ##CLASS(DHCWL.MKPIService.SetKPIData).GetQuaSecAndKpi(.kpiMonthList)
	
	//获取可以重做年数据的区间
	d ##CLASS(DHCWL.MKPIService.SetKPIData).GetYearSecAndKpi(.kpiMonthList)
	
	//将指标monthID的list转换格式
	d ##CLASS(DHCWL.MKPIService.SetKPIData).GetMonSecList(.kpiMonthList)
	//生成数据
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)	//add by wz.2014-12-4.解析执行代码的参数。
	s monId=0,needNums=0,numFlag=0
	f  s monId=$o(kpiMonthList(monId)) q:monId=""  d
	.s kpiStr=$g(kpiMonthList(monId))
	.s sc=..SetMultiKPIData(monId,kpiStr,rebuildFlag,.aryExecParam)
	.s needNums=needNums+1,numFlag=numFlag+sc
	.i sc=0 d
	..s id=$i(^DHCWLMKPI(0,"TRACK",+$h))
 	..s ^DHCWLMKPI(0,"TRACK",+$h,id)="指标任务方法：SetKPIData.CreatMultiTaskData执行中失败，monId="_monId_"  kpiStr="_kpiStr
	q needNums=numFlag
}

ClassMethod GetMonSecAndKpi(ByRef kpiMonthList)
{
	n (kpiMonthList)
	s monId=""
	for{
		s monId=$o(^||TEMPDHCWL("kpiIdAndMonId","D",monId))
		q:monId=""
		s date=$lg(^DHCWL.MKPI.MonthsD(monId),5)
		s mDate=$p(date,"-",1,2)
		s sysdate=$p($h,",",1)
 		s nowDate=$zd((sysdate),3)
 		s mNowDate=$p(nowDate,"-",1,2)
 		continue:mNowDate=mDate
 		s monthID=$o(^DHCWL.MKPI.MonthsI("Name"," "_mDate,""))
 		if ($d(^||TEMPDHCWL("kpiIdAndMonId","M",monthID))){
	 		continue:($d(kpiMonthList("M",monthID)))  
	 		s Mkpis=^||TEMPDHCWL("kpiIdAndMonId","M",monthID)
	 		s Dkpis=^||TEMPDHCWL("kpiIdAndMonId","D",monId)
	 		s len=$l(Dkpis,",")
	 		for i=1:1:len{
		 		s Dkpi=$p(Dkpis,",",i)
		 		continue:Dkpi=""
		 		if (Mkpis [ Dkpi){
			 		continue
		 		}else{
			 		s secID=$o(^DHCWL.MKPI.SectionI("SecCode","M",""))
			 		continue:secID=""
			 		if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Dkpi," Y")){
				 		if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthID,Dkpi)){
					 		if ($d(kpiMonthList("M",monthID))){
						 		s kpiMonthList("M",monthID)=kpiMonthList("M",monthID)_","_Dkpi
						 		
					 		}else{
					 			s kpiMonthList("M",monthID)=Dkpi
					 		}
				 		}
			 		}
		 		}
	 		}
	 		
 		}else{
	 		s secID=$o(^DHCWL.MKPI.SectionI("SecCode","M",""))
	 		continue:secID=""
	 		continue:($d(kpiMonthList("M",monthID)))
	 		s Dkpis=^||TEMPDHCWL("kpiIdAndMonId","D",monId)
	 		s len=$l(Dkpis,",")
	 		for i=1:1:len{
		 		s Dkpi=$p(Dkpis,",",i)
		 		q:Dkpi=""
		 		if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Dkpi," Y")){
			 		if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",monthID,Dkpi)){
					 		if ($d(kpiMonthList("M",monthID))){
						 		s kpiMonthList("M",monthID)=kpiMonthList("M",monthID)_","_Dkpi
						 		
					 		}else{
					 			s kpiMonthList("M",monthID)=Dkpi
					 		}
				 		}
		 		}
	 		}
 		}
 		
	}
	s monthID=""
	for{
		s monthID=$o(kpiMonthList("M",monthID))
		q:monthID=""
		if $d(^||TEMPDHCWL("kpiIdAndMonId","M",monthID)){
			s ^||TEMPDHCWL("kpiIdAndMonId","M",monthID)=^||TEMPDHCWL("kpiIdAndMonId","M",monthID)_","_kpiMonthList("M",monthID)
		}else{
			s ^||TEMPDHCWL("kpiIdAndMonId","M",monthID)=kpiMonthList("M",monthID)
		}
	}
}

ClassMethod GetQuaSecAndKpi(ByRef kpiMonthList)
{
	n (kpiMonthList)
	s newDate=$p($h,",",1)
	s newDate=$zd(newDate,3)
	s newQMonCode=##class(DHCWL.MKPIService.ComputerDate).GetQuabyDate(newDate)
	s newQMonID=$o(^DHCWL.MKPI.MonthsI("Name"," "_newQMonCode,""))
	q:newQMonID=""
	s monthID=""
	for{
		s monthID=$o(^||TEMPDHCWL("kpiIdAndMonId","M",monthID))
		q:monthID=""
		s date=$lg(^DHCWL.MKPI.MonthsD(monthID),5)
		s QMonCode=##class(DHCWL.MKPIService.ComputerDate).GetQuabyDate(date)
		s QMonID=$o(^DHCWL.MKPI.MonthsI("Name"," "_QMonCode,""))
		q:QMonID=""
		if (newQMonID'=QMonID){
			if $d(^||TEMPDHCWL("kpiIdAndMonId","Q",QMonID)){
				continue:($d(kpiMonthList("Q",QMonID)))
				s Qkpis=^||TEMPDHCWL("kpiIdAndMonId","Q",QMonID)
				s Mkpis=^||TEMPDHCWL("kpiIdAndMonId","M",monthID)
				s len=$l(Mkpis,",")
				for i=1:1:len{
					s Mkpi=$p(Mkpis,",",1)
					continue:Mkpi=""
					if (Qkpis [ Mkpi){
						continue
					}else{
						s secID=$o(^DHCWL.MKPI.SectionI("SecCode","Q",""))
			 			continue:secID=""
			 			if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Mkpi," Y")){
				 			if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",QMonID,Mkpi)){
					 			if ($d(kpiMonthList("Q",QMonID))){
						 			s kpiMonthList("Q",QMonID)=kpiMonthList("Q",QMonID)_","_Mkpi
						 		
					 			}else{
					 				s kpiMonthList("Q",QMonID)=Mkpi
					 			}
				 			}
			 			}
					}
				}
			}else{
				s secID=$o(^DHCWL.MKPI.SectionI("SecCode","Q",""))
	 			continue:secID=""
	 			continue:($d(kpiMonthList("Q",QMonID)))
	 			s Mkpis=^||TEMPDHCWL("kpiIdAndMonId","M",monthID)
	 			s len=$l(Mkpis,",")
	 			for i=1:1:len{
		 			s Mkpi=$p(Mkpis,",",i)
		 			q:Mkpi=""
		 			if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Mkpi," Y")){
			 			if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",QMonID,Mkpi)){
					 			if ($d(kpiMonthList("Q",QMonID))){
						 			s kpiMonthList("Q",QMonID)=kpiMonthList("Q",QMonID)_","_Mkpi
						 		
					 			}else{
					 				s kpiMonthList("Q",QMonID)=Mkpi
					 			}
				 			}
		 			}
	 			}
			}
		}else{
			continue
		}
	}
	s monthID=""
	for{
		s monthID=$o(kpiMonthList("Q",monthID))
		q:monthID=""
		if $d(^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)){
			s ^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)=^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)_","_kpiMonthList("Q",monthID)
		}else{
			s ^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)=kpiMonthList("Q",monthID)
		}
	}
}

ClassMethod GetYearSecAndKpi(ByRef kpiMonthList)
{
	n (kpiMonthList)
	s newDate=$p($h,",",1)
	s newDate=$zd(newDate,3)
	s newYMonCode=$p(newDate,"-",1)
	s newYMonCode=newYMonCode_"-Y"
	s newYMonID=$o(^DHCWL.MKPI.MonthsI("Name"," "_newYMonCode,""))
	q:newYMonID=""
	s monthID=""
	for{
		s monthID=$o(^||TEMPDHCWL("kpiIdAndMonId","Q",monthID))
		q:monthID=""
		s date=$lg(^DHCWL.MKPI.MonthsD(monthID),5)
		s YMonCode=$p(date,"-",1)
		s YMonCode=YMonCode_"-Y"
		s YMonID=$o(^DHCWL.MKPI.MonthsI("Name"," "_YMonCode,""))
		q:YMonID=""
		if (newYMonID'=YMonID){
			if $d(^||TEMPDHCWL("kpiIdAndMonId","Y",YMonID)){
				continue:($d(kpiMonthList("Y",YMonID)))
				s Ykpis=^||TEMPDHCWL("kpiIdAndMonId","Y",YMonID)
				s Qkpis=^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)
				s len=$l(Qkpis,",")
				for i=1:1:len{
					s Qkpi=$p(Qkpis,",",1)
					continue:Qkpi=""
					if (Ykpis [ Qkpi){
						continue
					}else{
						s secID=$o(^DHCWL.MKPI.SectionI("SecCode","Y",""))
			 			continue:secID=""
			 			if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Qkpi," Y")){
				 			if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",YMonID,Qkpi)){
					 			if ($d(kpiMonthList("Y",YMonID))){
						 			s kpiMonthList("Y",YMonID)=kpiMonthList("Y",YMonID)_","_Qkpi
						 		
					 			}else{
					 				s kpiMonthList("Y",YMonID)=Qkpi
					 			}
				 			}
			 			}
					}
				}
			}else{
				s secID=$o(^DHCWL.MKPI.SectionI("SecCode","Y",""))
	 			continue:secID=""
	 			continue:($d(kpiMonthList("Y",YMonID)))
	 			s Qkpis=^||TEMPDHCWL("kpiIdAndMonId","Q",monthID)
	 			s len=$l(Qkpis,",")
	 			for i=1:1:len{
		 			s Qkpi=$p(Qkpis,",",i)
		 			q:Qkpi=""
		 			if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secID,Qkpi," Y")){
			 			if $d(^DHCWL.MKPI.MKPIDataI("MONKPI",YMonID,Qkpi)){
					 			if ($d(kpiMonthList("Y",YMonID))){
						 			s kpiMonthList("Y",YMonID)=kpiMonthList("Y",YMonID)_","_Qkpi
						 		
					 			}else{
					 				s kpiMonthList("Y",YMonID)=Qkpi
					 			}
				 			}
		 			}
	 			}
			}
		}else{
			continue
		}
	}
}

ClassMethod GetMonSecList(ByRef kpiMonthList)
{
	n (kpiMonthList)
	k kpiMonList
	s sign=""
	for{
		s sign=$o(kpiMonthList(sign))
		q:sign=""
		s monthID=""
		for{
			s monthID=$o(kpiMonthList(sign,monthID))
			q:monthID=""
			s kpiMonList(monthID)=kpiMonthList(sign,monthID)
		}
	}
	k kpiMonthList
	s monthID=""
	for{
		s monthID=$o(kpiMonList(monthID))
		q:monthID=""
		s kpiMonthList(monthID)=kpiMonList(monthID)
	}
}

}
