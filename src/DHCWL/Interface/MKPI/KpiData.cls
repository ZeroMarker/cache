Class DHCWL.Interface.MKPI.KpiData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:         wk
/// CreatDate:       2016-05-31
/// Description:     默认查询做过生成数据任务的区间,当type赋值“E”表示查询可以查询出存在指标数据的区间
/// Table:           DHCWL_MKPI.DHCWLMKPIData,DHCWL_MKPI.DHCWLDeptKPIData
/// Input: 			kpi:输入一个(只支持单个指标的查询)正确的指标ID，或指标Code
///       			fromDate:开始日期,可以为空,为空时表示查询指标生成数据日期从最早开始
///       			toDate:结束日期,可以为空,为空时表示查询指标生成数据的最晚日期
///       			type:可赋值“E”,默认为空表示查询做过生成数据任务的区间,“E”表示查询可以查询出数据的区间
/// Output:			将符合条件的日期打印出来
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).CheckExisKpiData("lhcs0617")
ClassMethod CheckExisKpiData(kpi, fromDate = "", toDate = "", type = "")
{
	n (kpi,fromDate,toDate,type)
	k kpiDataList
	//将日期类型装换成monID类型
	if (fromDate'=""){
		s froMonID=##class(DHCWL.util.DateUtil).GetMonthIdByName(fromDate_":"_fromDate)
	}else{
		s froMonID=""
	}
	if (toDate'=""){
		s toMonID=##class(DHCWL.util.DateUtil).GetMonthIdByName(toDate_":"_toDate)
	}else{
		s toMonID=""
	}
	s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
	if (kpiID=""){
		w "请输入正确指标ID或Code"
		q
	}
	//遍历指标数据表
	s kpiDataID=""
	s errorFlag=0
	for{
		s kpiDataID=$o(^DHCWL.MKPI.MKPIDataI("MKDKPIdr",kpiID,kpiDataID))
		q:kpiDataID=""
		//E模式下只查询存在指标数据的区间
		if (type="E"){
			if ('$d(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",kpiDataID))){
				continue
			}
		}
		s monthID=$lg(^DHCWL.MKPI.MKPIDataD(kpiDataID),3)
		if ((monthID="")||(monthID=" ")){
			s errorFlag=1
			q
		}
		//将符合条件的monthID保存起来
		s kpiDataList(monthID)=""
	}
	if (errorFlag=1){
		w "指标数据ID"_kpiDataID_"有问题,请检查后再操作"
		q
	}
	//打印两种模式查询的区间
	if (type="E"){
		w "存在指标数据的区间:",!
	}else{
		w "做过生成指标数据任务的区间:",!
	}
	s monthID=""
	s startData=""
	s endData=""
	for{
		s monthID=$o(kpiDataList(monthID))
		q:monthID=""
		if (froMonID'=""){
			if (monthID<froMonID){
				continue
			}
		}
		if (toMonID'=""){
			if (monthID>toMonID){
				if (startData'=""){
					if (endData'=""){
						w $lg(^DHCWL.MKPI.MonthsD(startData),2)_"-"_$lg(^DHCWL.MKPI.MonthsD(endData),2)_" "
					}else{
						w $lg(^DHCWL.MKPI.MonthsD(startData),2)_" "
					}
				}
				q
			}
		}
		s monthSign=$lg(^DHCWL.MKPI.MonthsD(monthID),5)
		if ($p(monthSign,"-",3)=""){
			if (startData'=""){
				if (endData'=""){
					w $lg(^DHCWL.MKPI.MonthsD(startData),2)_"-"_$lg(^DHCWL.MKPI.MonthsD(endData),2)_" "
				}else{
					w $lg(^DHCWL.MKPI.MonthsD(startData),2)_" "
				}
			}
			w $lg(^DHCWL.MKPI.MonthsD(monthID),2)_" "
			s startData=""
			s endData=""
			continue
		}
		if (startData=""){
			s startData=monthID
		}elseif (endData=""){
			if (monthID=(startData+1)){
				s endData=monthID
			}
			else{
				w $lg(^DHCWL.MKPI.MonthsD(startData),2)_" "
				s startData=""
			}
		}elseif ((endData'="")){
			if (monthID=(endData+1)){
				s endData=monthID
			}else{
				w $lg(^DHCWL.MKPI.MonthsD(startData),2)_"-"_$lg(^DHCWL.MKPI.MonthsD(endData),2)_" "
				s startData=monthID
				s endData=""
			}
		}
	}
}

/// Creator:         wk
/// CreatDate:       2017-02-07
/// Description:     用于一键检查中区间任务顺序的检查
/// Table:           DHCWL_MKPI.DHCWLCreatDataTask，DHCWL_MKPI.DHCWLKPIMonths
/// Input: 			data数组，用来保存查询到的错误信息
/// Output:			data数组，返回查询到的错误信息
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskOrder(.data)
ClassMethod CheckKpiTaskOrder(ByRef data)
{
	n (data)
	s kpiID=""
	s nowDate=$zd(+$h,3)
	s nowYear=$p(nowDate,"-",1)
  	s startDate=nowYear_"-01-01"
  	if ('$d(^DHCWL.MKPI.MonthsI("Name"," "_startDate))){
		d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths(nowYear)
	}
	q:('$d(^DHCWL.MKPI.MonthsI("Name"," "_startDate))) "本年度的monId还未生成"
  	s startDate=$zdh(startDate,3)
  	k tempDataList
  	s lastYear=nowYear-1
  	s endDate=nowYear_"-01-31"
  	s endDate=$zdh(endDate,3)
  	//如果检查年份去年的monthID没有生成，则首先生成
  	if ($o(^DHCWL.MKPI.MonthsI("Code",lastYear_"Y",""))=""){
	  	d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths(lastYear)
  	}
  	s lastMonId=$o(^DHCWL.MKPI.MonthsI("Code",lastYear_"12",""))
  	q:lastMonId="" "请先生成"_lastYear_"年monId"
  	s firstMonth=nowYear_"-01"
 	for{
	  s kpiID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID))
	  q:kpiID=""
	  k secList
	  k secRunDateList
	  s kpiTaskID=""
	  for{
		  s kpiTaskID=$O(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID," Y",kpiTaskID))   //只获取激活的指标任务
		  q:kpiTaskID=""
		  s excDr=$li(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),7,"")
		  if ((+excDr>0)&&($d(^DHCWL.MKPI.ExecuteCodeD(excDr)))){
			  s exCode=$lg(^DHCWL.MKPI.ExecuteCodeD(excDr),3,"")
		  }else{
			  s kpiTaskExCode=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),3,"")
		  }
		  s secID=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),5)
		  s secCode=$lg(^DHCWL.MKPI.SectionD(secID),2)
		  s secList(secCode)=kpiTaskExCode    //将符合条件的指标区间code和执行代码保存起来
	  }
	  s sc=##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskActive(.secList)   //检查高区间与低区间激活状态是否配置错误
	  if (sc="error"){
		  if ($d(tempDataList("高区间与低区间任务激活状态配置异常"))){
		      s tempDataList("高区间与低区间任务激活状态配置异常")=tempDataList("高区间与低区间任务激活状态配置异常")_","_kpiID
		  }else{
			  s tempDataList("高区间与低区间任务激活状态配置异常")=kpiID			
		  }
		  continue
	  }
	  
	  if ($d(secList("M"))){   
		  s MExeCode=secList("M")
		  if ((MExeCode="")||(MExeCode=$c(0))||(MExeCode'["^")){     ///任务执行代码不存在记录并退出检查
			  if ($d(tempDataList("月任务缺少执行代码的指标"))){
				  s tempDataList("月任务缺少执行代码的指标")=tempDataList("月任务缺少执行代码的指标")_","_kpiID
			  }else{
				  s tempDataList("月任务缺少执行代码的指标")=kpiID			  
			  } 
			  continue 
		  }else{
			  for date=startDate:1:endDate{           ///从1月1号到1月31号遍历，如果返回monId则记录并退出遍历
				  s ^TEMPDHCWL($j,"CurDay")=date
			  	  s exCode=" s monId=$$"_MExeCode_"()"
			  	  x exCode
			  	  if (+$g(monId)=0){
				  	  continue
			  	  }
			  	  continue:(lastMonId)'=(monId)
			  	  s secRunDateList("M")=date
			  	  s DExeCode=secList("D")
			  	  if ((DExeCode="")||(DExeCode=$c(0))||(DExeCode'["^")){
				  	  if ($d(tempDataList("日任务缺少执行代码的指标"))){
				      	   s tempDataList("日任务缺少执行代码的指标")=tempDataList("日任务缺少执行代码的指标")_","_kpiID
			  		  }else{
				  	  	   s tempDataList("日任务缺少执行代码的指标")=kpiID			
			 		  }
			 		  q  
			  	  }
			  	  s ^TEMPDHCWL($j,"CurDay")=(date+1)
			  	  s exCode=" s monId=$$"_DExeCode_"()"
			  	  x exCode
			  	  s testMonthID=$lg(^DHCWL.MKPI.MonthsD(monId),5)
			  	  s testMonthID=$p(testMonthID,"-",1,2)
			  	  if (testMonthID'=firstMonth){
				  	  if ($d(tempDataList("月任务早于日任务的指标"))){
					  	  s tempDataList("月任务早于日任务的指标")=tempDataList("月任务早于日任务的指标")_","_kpiID
				  	  }else{
					  	  s tempDataList("月任务早于日任务的指标")=kpiID
				  	  }
			  	  }
			  	  q
			  }
		  }
	  }
	   if (($d(secList("Q")))){
		  s QExeCode=secList("Q")                        
		  if ((QExeCode="")||(QExeCode=$c(0))||(QExeCode'["^")){
			  if ($d(tempDataList("季任务缺少执行代码的指标"))){
				  s tempDataList("季任务缺少执行代码的指标")=tempDataList("季任务缺少执行代码的指标")_","_kpiID
			  }else{
				  s tempDataList("季任务缺少执行代码的指标")=kpiID       ///季任务执行代码不存在
			  }
			  continue
		  }else{
			  for date=startDate:1:endDate{
				  s ^TEMPDHCWL($j,"CurDay")=date
			  	  s exCode=" s monId=$$"_QExeCode_"()"
			  	  x exCode
			  	  continue:+$g(monId)=0 
			  	  s secRunDateList("Q")=date
			  	  q
			  }
		  }
		  if ((secRunDateList("M"))>(secRunDateList("Q"))){
			  if ($d(tempDataList("季任务早于月任务的指标"))){
				  s tempDataList("季任务早于月任务的指标")=tempDataList("季任务早于月任务的指标")_","_kpiID
			  }else{
				  s tempDataList("季任务早于月任务的指标")=kpiID             
			  }
		  }
		  
		  if ($d(secList("Y"))){
			  s YExeCode=secList("Y")
			  if ((YExeCode="")||(YExeCode=$c(0))||(QExeCode'["^")){
				  if ($d(tempDataList("年任务缺少执行代码的指标"))){
				  	 s tempDataList("年任务缺少执行代码的指标")=tempDataList("年任务缺少执行代码的指标")_","_kpiID
			  	  }else{
				  	 s tempDataList("年任务缺少执行代码的指标")=kpiID                   
			 	  } 
			 	  continue 
		  	  }else{
			  	  for date=startDate:1:endDate{
				  	 s ^TEMPDHCWL($j,"CurDay")=date
			  	 	 s exCode=" s monId=$$"_YExeCode_"()"
			  	  	 x exCode
			  	     continue:+$g(monId)=0 
			  	     s secRunDateList("Y")=date
			  	     q
			  	  }
		      }
		      if ((secRunDateList("Q"))>(secRunDateList("Y"))){
			  	  if ($d(tempDataList("年任务早于季任务的指标"))){
				  	  s tempDataList("年任务早于季任务的指标")=tempDataList("年任务早于季任务的指标")_","_kpiID
			  	  }else{
				      s tempDataList("年任务早于季任务的指标")=kpiID             //月任务晚于季任务
			      }
		      }	  
		  }
		  
	  }
  }
  //修改数据保存格式，便于csp使用
  s infor=""
  for{
	  s infor=$o(tempDataList(infor))
	  q:infor=""
	  s kpis=tempDataList(infor)
	  s data(infor)=kpis
  }
  k tempDataList
}

/// Creator:         wk
/// CreatDate:       2017-02-08
/// Description:     检查用户保存的指标区间任务执行顺序是否合理
/// Table:           DHCWL_MKPI.DHCWLKPIMonths
/// Input: 			指标区间任务信息，包括执行代码、激活状态、区间
/// Output:			如果存在错误，返回错误提示，否则返回ok
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskByItface()
ClassMethod CheckKpiTaskByItface(taskList) As %String
{
	n (taskList)
	k kpiTaskList
	k secRunDateList
	q:taskList="" "保存区间不能为空"
	s taskLen=$l(taskList,"@")
	q:(taskLen=1) "ok"
	s nowDate=$zd(+$h,3)
	s nowYear=$p(nowDate,"-",1)
	s startDate=nowYear_"-01-01"
	if ('$d(^DHCWL.MKPI.MonthsI("Name"," "_startDate))){
		d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths(nowYear)
	}
	q:('$d(^DHCWL.MKPI.MonthsI("Name"," "_startDate))) "本年度的monId还未生成"
  	s startDate=$zdh(startDate,3)
  	s endDate=nowYear_"-01-31"
  	s endDate=$zdh(endDate,3)
  	s lastYear=nowYear-1
  	if ($o(^DHCWL.MKPI.MonthsI("Code",lastYear_"Y",""))=""){
	  	d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths(lastYear)
  	}
  	s lastMonId=$o(^DHCWL.MKPI.MonthsI("Code",lastYear_"12",""))
  	q:lastMonId="" "请先生成"_lastYear_"年monId"
  	s firstMonth=nowYear_"-01"
	s errorFlag=0
	f i=1:1:taskLen {
		s task=$p(taskList,"@",i)
		s secCode=$p(task,"||",1)
		s taskExecode=$p(task,"||",2)
		s activeFlag=$p(task,"||",3)
		continue:(activeFlag'["Y")
		if ((taskExecode="")||(taskExecode=$c(0))||(taskExecode'["^")){
			s errorFlag=1
			q
		}
		if (secCode'="D")&(secCode'="M")&(secCode'="Q")&(secCode'="Y"){
			s errorFlag=2
			q
		}
		s kpiTaskList(secCode)=taskExecode
	}
	q:(errorFlag=1) "执行代码不能为空"
	q:(errorFlag=2) "区间维护不正确,请保证是D,M,Q,Y"
	s sc=##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskActive(.kpiTaskList)
	q:(sc="error") "高区间与低区间激活状态配置异常"
	q:('$d(kpiTaskList("M"))) "ok"
	s MTaskExec=kpiTaskList("M")
	s errorInfor=""
	for date=startDate:1:endDate{           ///从1月1号到1月31号遍历，如果返回monId则记录并退出遍历
		s ^TEMPDHCWL($j,"CurDay")=date
		s exCode=" s monId=$$"_MTaskExec_"()"
		x exCode
		if (+$g(monId)=0){
			continue
		}
		continue:(lastMonId)'=(monId)
		s secRunDateList("M")=date
		s DExeCode=kpiTaskList("D")
		s ^TEMPDHCWL($j,"CurDay")=(date+1)
		s exCode=" s monId=$$"_DExeCode_"()"
		x exCode
		s testMonthID=$lg(^DHCWL.MKPI.MonthsD(monId),5)
		s testMonthID=$p(testMonthID,"-",1,2)
		if (testMonthID'=firstMonth){
			s errorInfor="月任务将会早于日任务执行,请合理配置区间任务"
			q
		}else{
			q
		}
	}
	q:(errorInfor'="") errorInfor
	
	if ($d(kpiTaskList("Q"))){
		s QTaskExec=kpiTaskList("Q")
		for date=startDate:1:endDate{
			s ^TEMPDHCWL($j,"CurDay")=date
			s exCode=" s monId=$$"_QTaskExec_"()"
			x exCode
			continue:+$g(monId)=0 
			s secRunDateList("Q")=date
			q
		}
		if ((secRunDateList("M"))>(secRunDateList("Q"))){
			  q "季任务将早于月任务执行,请合理配置区间任务"	  
		}
	}
	
	if ($d(kpiTaskList("Y"))){
		s YTaskExec=kpiTaskList("Y")
		for date=startDate:1:endDate{
			s ^TEMPDHCWL($j,"CurDay")=date
			s exCode=" s monId=$$"_YTaskExec_"()"
			x exCode
			continue:+$g(monId)=0 
			s secRunDateList("Y")=date
			q
		}
		if ((secRunDateList("Q"))>(secRunDateList("Y"))){
			q "年任务将早于季任务执行,请合理配置区间任务"	  	  
		}	
	}
	q "ok"
}

/// Creator:         wk
/// CreatDate:       2017-02-08
/// Description:     检查导入的指标区间任务执行顺序是否合理
/// Table:           DHCWL_MKPI.DHCWLKPIMonths，DHCWL_MKPI.DHCWLCreatDataTask
/// Input: 			
/// Output:			导入的指标如果区间任务执行顺序错误，则返回错误
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskByInput()
ClassMethod CheckKpiTaskByInput() As %String
{
	s kpiCode=""
	k kpiTaskErrList
	for{
		s kpiCode=$o(^TEMPDHCWL("REALINPUT",$j,kpiCode))     //遍历导入的指标
		q:kpiCode=""
		s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		continue:kpiID=""
		s kpiTasks=""
		s activeFlag=""
		for{
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,activeFlag))  //将区间任务拼成串，用于调用接口
			q:activeFlag=""
			s kpiTaskID=""
			for{
				s kpiTaskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,activeFlag,kpiTaskID))
				q:kpiTaskID=""
				s sec=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),6)
				s exec=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),3)
				s flag=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),2)
				if (kpiTasks=""){
					s kpiTasks=sec_"||"_exec_"||"_flag
				}else{
					s kpiTasks=kpiTasks_"@"_sec_"||"_exec_"||"_flag
				}
			}
		}
		s errorFlag=0
		if (kpiTasks'=""){
			s result=##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskByItface(kpiTasks)       //指标区间任务维护错误，将指标任务置为不激活状态
			if (result'="ok"){
				s actFlag=""
				for{
					s actFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,actFlag))
					q:actFlag=""
					s taskID=""
					for{
						s taskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiID,actFlag,taskID))
						q:taskID=""
						s sign="N"
						&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ActiveFlag=:sign where ID=:taskID)
						i (SQLCODE'=0){
							s errorFlag=1
							q
						} 
					}
				}
				if (errorFlag=0){
					s kpiTaskErrList(kpiCode)=result
				}
			}
		}
		if (errorFlag'=0){
			k kpiTaskErrList
			s kpiTaskErrList(-1)=""
			q
		}
	}
	if ($o(kpiTaskErrList(""))=""){
		q ""
	}
	s errorInfor=""
	s kpiCode=""
	//将修改了激活状态的指标提示给用户
	for{    
		s kpiCode=$o(kpiTaskErrList(kpiCode))
		q:kpiCode=""
		if (kpiCode=(-1)){
			s errorInfor="检查功能错误,请到:系统配置-指标常见问题检查,查看具体问题"
			q
		}else{
			if (errorInfor=""){
				s errorInfor="以下指标任务已被停止,请查看--指标"_kpiCode_":"_kpiTaskErrList(kpiCode)
			}else{
				s errorInfor=errorInfor_"--指标"_kpiCode_":"_kpiTaskErrList(kpiCode)
			}
		}
	}
	q errorInfor
}

/// Creator:         wk
/// CreatDate:       2017-02-10
/// Description:     检查判断是否存在指标任务高区间指标被激活低区间指标没有被激活情况
/// Table:           
/// Input: 			包含有区间的数组
/// Output:			正确返回ok，错误返回error
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskActive(.data)
ClassMethod CheckKpiTaskActive(ByRef data) As %String
{
	n (data)
	if ($d(data("Y"))){
		if ( '$d(data("Q")) ) || ('$d(data("M"))) || ('$d(data("D"))){
			q "error"
		}else{
			q "ok"
		}
	}
	if ($d(data("Q"))){
		if (('$d(data("M"))) || ('$d(data("D")))){
			q "error"
		}else{
			q "ok"
		}
	}
	if ($d(data("M"))){
		if ('$d(data("D"))){
			q "error"
		}else{
			q "ok"
		}
	}
	q "ok"
}

/// Creator:         wk
/// CreatDate:       2017-12-05
/// Description:     作废度量时删除指标度量
/// Table:           DHCWL_MKPI.DHCWLMKPIMeasure
/// Input: 			 
/// Output:			 删除状态
/// Return:
/// Others:			d ##class(DHCWL.Interface.MKPI.KpiData).DeleteKpiMeasure()
ClassMethod DeleteKpiMeasure(ID) As %String
{
	n (ID)
	s result="error"
	&sql(delete from DHCWL_MKPI.DHCWLMKPIMeasure where MKPI_MeaDr=:ID)
	if SQLCODE=0{
		s result="ok"
	}else{
		s result="删除指标度量失败"
	}
	q result
}

}
