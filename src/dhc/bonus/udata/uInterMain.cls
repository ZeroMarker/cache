Class dhc.bonus.udata.uInterMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-21
/// Description: 奖金系统数据采集接口
/// Table：
/// Input:
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).InterMain("2011","M04",4,"")
ClassMethod InterMain(sYear, sPeriod, InterLocSetDr, InterLocMethodDr)
{
	n (sYear, sPeriod, InterLocSetDr,InterLocMethodDr)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="SELECT * FROM dhc_bonus_inter.InterLocMethod"_
	" WHERE %ID>0 AND InterLocSet_rowid="_InterLocSetDr_" and InterLocMethod_active='Y'"
	i InterLocMethodDr'="" d
	 .s sqlStr = sqlStr_" and InterLocMethod_rowid="_InterLocMethodDr
	s sqlStr = sqlStr_"order by InterLocMethod_order" 
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLocMethod_rowid")
		s methodName = result.Data("InterLocMethod_methodName")
		s globalType = result.Data("InterLocMethod_ReturnType")
		
		s tempGloble = result.Data("InterLocMethod_ReturnName")
		k @tempGloble
				
		//w sYear_"^"_sPeriod_"^"_rowid,!
		//获取接口方法参数
		s sPamaName = ..GetInterMethodParam(sYear, sPeriod,rowid)
			
		//得到接口方法并执行	
		s classMethodName=methodName_sPamaName
		//w "classMethodName:"_classMethodName,!
		d @classMethodName
		
		s sStart="$o("_tempGloble_"(""""))"
		s sEnd="$o("_tempGloble_"(""""),-1)"
		
		//w "zlg sStart:"_sStart,!
		s start=..indirect(sStart)
		s end=..indirect(sEnd)
		
		//w "start:"_start,!
		//w "end:"_end,!
		
		//当Global中无数据时，将不对其进行取数操作。
		continue:(start="")
		
		s sparam = rowid_"^"_sYear_"^"_sPeriod_"^"_updateflag
		TSTART
		//删除存在的数据
		s rtn= ..DeleteCollectTempData(rowid,sYear,sPeriod)
		
		if rtn'=0 d 
		.TROLLBACK
		E   d
		.TCOMMIT
		
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		s sdataLog = sYear_"^"_sPeriod_"^"_rowid_"^"_UpdateDate_"^0^"_updateflag_"^系统导入" 
	 	d ..SaveCollectLog(sdataLog)
	 
		//对Global取数处理
		for i=start:1:end {
			
		 d ..GetGlobalsData(tempGloble,i,globalType,sparam)
		}
		
	}
		d result.Close()
	
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-6-10
/// Description: 奖金收入数据采集接口
/// Table：
/// Input:
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).subInterMain("2011","M02",4,"",2)
ClassMethod subInterMain(sYear, sPeriod, InterLocSetDr, InterLocMethodDr, DataType)
{
	n (sYear, sPeriod, InterLocSetDr,InterLocMethodDr,DataType)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="SELECT * FROM dhc_bonus_inter.InterLocMethod"_
	" WHERE %ID>0 AND InterLocSet_rowid="_InterLocSetDr_" and InterLocMethod_active='Y'"
	_" and  InterLocSet_rowid->InterLocSet_type="_DataType
	i InterLocMethodDr'="" d
	 .s sqlStr = sqlStr_" and InterLocMethod_rowid="_InterLocMethodDr
	s sqlStr = sqlStr_" order by InterLocMethod_order" 
	
	w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLocMethod_rowid")
		s methodName = result.Data("InterLocMethod_methodName")
		s globalType = result.Data("InterLocMethod_ReturnType")
		
		s tempGloble = result.Data("InterLocMethod_ReturnName")
		k @tempGloble
				
		//获取接口方法参数
		s sPamaName = ..GetInterMethodParam(sYear, sPeriod,rowid)
		//w "sPamaName:"_sPamaName,!	
		//得到接口方法并执行	
		s classMethodName=methodName_sPamaName
		w "classMethodName:"_classMethodName,!
		/*
		d @classMethodName
		
		s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		s sdataLog = sYear_"^"_sPeriod_"^"_rowid_"^"_UpdateDate_"^0^"_updateflag_"^系统导入" 
	 	d ..SaveCollectLog(sdataLog)
	 */
		
	}
		d result.Close()
	
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-22
/// Description: 保存采集的数据到临时表中
/// Table：dhc_bonus_data.BonusCollectTemp
/// Input:data_^科室编码^指标编码^核算年度^核算期间^指标值^保存日期^采集标识
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).SaveCollectTempData("101^01080^2011^M01^1.35^2011-04-22 11:23:57^62203_41037")
ClassMethod SaveCollectTempData(data)
{
	n (data)
	
	s BonusUnitCode=$p(data,"^",1)
	s BonusTargetCode=$p(data,"^",2)
	s BonusYear=$p(data,"^",3)
	s BonusPeriod=$p(data,"^",4)
	s TargetValue=$fn($p(data,"^",5),"",2)
	s UpdateDate=$p(data,"^",6)
	s Flag=$p(data,"^",7)
	s InterMethodDr=$p(data,"^",8)
	
	s status = 0
	
	&sql(insert into dhc_bonus_data.BonusCollectTemp(BonusUnitCode,BonusTargetCode,BonusYear,BonusPeriod,TargetValue,UpdateDate,Flag,InterLocMethodID,status ) values(:BonusUnitCode,:BonusTargetCode,:BonusYear,:BonusPeriod,:TargetValue,:UpdateDate,:Flag,:InterMethodDr,:status))
	s rowid =%ROWID
	
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-22
/// Description: 保存采集的数据到临时表中
/// Table：dhc_bonus_data.BonusCollectTemp
/// Input:data_^科室编码^指标编码^核算年度^核算期间^指标值^保存日期^采集标识
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).SaveCollectTempData("101^01080^2011^M01^1.35^2011-04-22 11:23:57^62203_41037")
ClassMethod DeleteCollectTempData(InterMethodDr, BonusYear, BonusPeriod)
{
	n (InterMethodDr,BonusYear,BonusPeriod)
	
	&sql(Delete from  dhc_bonus_data.BonusCollectTemp where InterLocMethodID=:InterMethodDr AND BonusYear=:BonusYear and BonusPeriod=:BonusPeriod )
		
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-5-1 于家中 
/// Description: 保存采集的数据记录
/// Table：dhc_bonus_inter.InterLog
/// Input:data_核算年度^核算期间^接口方法ID^导入时间^导入状态^导入标识^导入描述
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).SaveCollectTempData("101^01080^2011^M01^1.35^2011-04-22 11:23:57^62203_41037")
ClassMethod SaveCollectLog(data)
{
	n (data)
	//InterLog_rowid  InterLog_Year   InterLog_Period InterLog_MethodDr       
	//InterLog_ImportDate     InterLog_status InterLog_Flag   InterLog_LogDesc

	s Year=$p(data,"^",1)
	i Year'=""  d  s PLIST(2)=Year
	
	s Period=$p(data,"^",2)
	i Period'=""  d  s PLIST(3)=Period
	
	s MethodDr=$p(data,"^",3)
	i MethodDr'=""  d  s PLIST(4)=MethodDr
	
	s ImportDate=$p(data,"^",4)
	i ImportDate'=""  d  s PLIST(5)=ImportDate
	
	s status=$p(data,"^",5)
	i status'=""  d  s PLIST(6)=status
	s Flag=$p(data,"^",6)
	i Flag'=""  d  s PLIST(7)=Flag
	s LogDesc=$p(data,"^",7)
	i LogDesc'=""  d  s PLIST(8)=LogDesc
	
	&sql(insert into dhc_bonus_inter.InterLog values PLIST())
	s rowid =%ROWID
	
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-22
/// Description: 获取接口方法的参数字符串
/// Table：
/// Input:sYear_核算年, sPeriod_核算期间, sInterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).GetInterMethodParam("2011","M02",3)
ClassMethod GetInterMethodParam(sYear, sPeriod, sInterLocMethodDr)
{
	n (sYear, sPeriod, sInterLocMethodDr)
	
	s rowid = sInterLocMethodDr
	s intertLocDr = $list(^dhcbsInterLocMethodD(rowid),6)
	
	s LocMethDr=""
	s orderIndex=""
	s sParam=""
	
	f  s LocMethDr = $O(^dhcbsMethodParamI("InterLocMethodID",rowid,LocMethDr)) q:LocMethDr=""  d
	.f  s orderIndex = $O(^dhcbsMethodParamI("InterLocMethodID",rowid,LocMethDr,orderIndex)) q:orderIndex=""  d
	..s paramCode=$LI(^dhcbsMethodParamD(orderIndex),3)
	..s paramFlag=$LI(^dhcbsMethodParamD(orderIndex),4)
	..s paramDefault=$LI(^dhcbsMethodParamD(orderIndex),5)
	
	..s paramValue=..GetInterMethodParamValue(intertLocDr,sYear, sPeriod,paramCode,paramDefault)
	..s sParam =sParam_","_paramValue
		  	
	s sParam="("_$E(sParam,2,$L(sParam))_")"
	q sParam
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-22
/// Description: 解析接口方法的返回值(global)
/// Table：
/// Input:sYear_核算年, sPeriod_核算期间, sInterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回解析后的值
/// Others: w ##class(dhc.bonus.udata.uInterMain).GetGlobalsData("^DHCBonusTargetInterfaceTmp",2,"02","9^2011^M01^6666")
ClassMethod GetGlobalsData(globalName, num, globalType, param)
{
	n (globalName, num, globalType,param)
	
	s methodDr=  $p(param,"^",1)
	s BonusYear= $p(param,"^",2)
	s BonusPeriod= $p(param,"^",3)
	s Flag =$p(param,"^",4)
	
	
	s TempGlobals=globalName_"("_num_")"
	
	s BonusUnitCode =$p(@TempGlobals,"^",1)
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
	//globalType=01: 标准global，格式:^单元编码^单元名称^指标编码^指标名称^指标值
	i (globalType="201") d
	 .s BonusTargetCode =$p(@TempGlobals,"^",3)
	 .s TargetValue=$fn($p(@TempGlobals,"^",5),"",2)
	 .i (TargetValue'=0) d
	 ..s sdata = BonusUnitCode_"^"_BonusTargetCode_"^"_BonusYear_"^"_BonusPeriod_"^"_TargetValue_"^"_UpdateDate_"^"_Flag_"^"_methodDr 
	 ..d ..SaveCollectTempData(sdata)
	// .s sdataLog = BonusYear_"^"_BonusPeriod_"^"_methodDr_"^"_UpdateDate_"^0^"_Flag_"^系统导入" 
	// .d ..SaveCollectLog(sdataLog)

	//globalType=02: 扩展global，格式:^单元编码^单元名称^指标值1^指标值2^指标值3...^指标值n
	i globalType="202" d
	.s locationDr=""
	.i $D(^DHCCJXPAOUTKPIRULE(0,"MedthDr")) d
	..f  s locationDr= $O(^DHCCJXPAOUTKPIRULE(0,"MedthDr",methodDr,locationDr) ) q:locationDr=""  d
	...s rowID=""
	...f  s rowID= $O(^DHCCJXPAOUTKPIRULE(0,"MedthDr",methodDr,locationDr,rowID) ) q:rowID=""  d
	....s BonusTargetCode=$p(^DHCCJXPAOUTKPIRULE(rowID),"^",1)
	....s TargetValue=$fn($p(@TempGlobals,"^",locationDr),"",2)
	....i (TargetValue'=0) d
	.....s sdata = BonusUnitCode_"^"_BonusTargetCode_"^"_BonusYear_"^"_BonusPeriod_"^"_TargetValue_"^"_UpdateDate_"^"_Flag_"^"_methodDr 
	.....d ..SaveCollectTempData(sdata)
	//....s sdataLog = BonusYear_"^"_BonusPeriod_"^"_methodDr_"^"_UpdateDate_"^0^"_Flag_"^系统导入" 
	//....d ..SaveCollectLog(sdataLog)
	
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-22
/// Description: 获取接口方法的参数字符串
/// Table：
/// Input:sYear_核算年, sPeriod_核算期间, sInterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).GetInterMethodParamValue(4,"2011","M01","101","""""")
ClassMethod GetInterMethodParamValue(locSetDr, sYear, sPeriod, sParamCode, sParamDefault)
{
	n (locSetDr,sYear, sPeriod, sParamCode,sParamDefault)
	
	s rtn =""""""
	//核算年度
	if (sParamCode="101"){
		i sParamDefault'="" d
		.s rtn =""""_sParamDefault_""""
		e  d
		.s rtn =""""_sYear_""""
	}

	elseif(sParamCode="102"){
		//核算期间
		i sParamDefault'="" d
		.s rtn =""""_sParamDefault_""""
		e  d
		.s rtn =""""_sPeriod_""""
	}elseif(sParamCode="103"){
		//开始时间
		i sParamDefault="" d
		.s rtn =""""_..getInterLocSetPeriod(locSetDr,sYear, sPeriod,"start")_""""
		e  d
		.s rtn =""""_sParamDefault_""""
	}elseif(sParamCode="104"){
		//结束时间
		i sParamDefault="" d
		.s rtn =""""_..getInterLocSetPeriod(locSetDr,sYear, sPeriod,"end")_""""
		e  d
		.s rtn =""""_sParamDefault_""""
	}elseif(sParamCode="105"){
		//固定科室
		i sParamDefault'="" d
		.s rtn = """"_sParamDefault_""""

	}elseif(sParamCode="106"){
		//方案科室
		i sParamDefault'="" d
		.s rtn =""""_..getSchemeDept(sParamDefault)_""""

	}elseif(sParamCode="107"){
		//固定人员
		i sParamDefault'="" d
		.s rtn =""""_sParamDefault_""""

	}elseif(sParamCode="108"){
		//方案人员
		i sParamDefault'="" d
		.s rtn =""""_..getSchemePerson(sParamDefault)_""""

	}elseif(sParamCode="109"){
		//固定指标
		i sParamDefault'="" d
		.s rtn =""""_sParamDefault_""""

	}elseif(sParamCode="110"){
		//方案指标
		i sParamDefault'="" d
		.s rtn = """"_..getSchemeTarget(sParamDefault)_""""

	}
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-21
/// Description: 得到奖金方案的科室
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).getSchemeDept("02")
ClassMethod getSchemeDept(schemeCode)
{
	n (schemeCode)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="select BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName from dhc_bonus_data.BonusSchemeUnit   where BonusUnitID->UnitFlag in (1,2) and BonusSchemeID->BonusSchemeCode='"_schemeCode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s rtn =""
	While(result.Next()){
		s code = result.Data("BonusUnitCode")
		s rtn=rtn_"^"_code
	}
	
	s rtn = $E(rtn,2,$L(rtn))
	d result.Close()
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-21
/// Description: 得到奖金方案的人员
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).getSchemePerson("02")
ClassMethod getSchemePerson(schemeCode)
{
	n (schemeCode)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="select BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName from dhc_bonus_data.BonusSchemeUnit"_
	"   where BonusUnitID->UnitFlag=3 and BonusSchemeID->BonusSchemeCode='"_schemeCode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s rtn =""
	While(result.Next()){
		s code = result.Data("BonusUnitCode")
		s rtn=rtn_"^"_code
	}
	
	s rtn = $E(rtn,2,$L(rtn))
	d result.Close()
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-21
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).getSchemeTarget("02")
ClassMethod getSchemeTarget(schemeCode)
{
	n (schemeCode)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="select BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName from dhc_bonus_data.SchemeTarget"_
	"   where  BonusSchemeID->BonusSchemeCode='"_schemeCode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s rtn =""
	While(result.Next()){
		s code = result.Data("BonusTargetCode")
		s rtn=rtn_"^"_code
	}
	
	s rtn = $E(rtn,2,$L(rtn))
	d result.Close()
	
	q rtn
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-25
/// Description: 获取接口套的时间范围
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).getInterLocSetPeriod(4,"2011","M01","start")
ClassMethod getInterLocSetPeriod(InterLocDr, sYear, sPeriod, sFlag)
{
	n (InterLocDr,sYear,sPeriod,sFlag)
	
	s PeriodType=$E(sPeriod,1,1)
	s PeriodMonth=$E(sPeriod,2,3)

	s sqlStr="select BonusYear InterPeriod_year,BonusPeriod InterPeriod_period , StartDate InterPeriod_startDate ,EndDate  InterPeriod_endDate"_
			" from dhc_bonus_Data.SchemePeriod where BonusYear ='"_sYear_"' and BonusPeriod= '"_PeriodType_PeriodMonth_"'"
	//w "SetPeriod:"_sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s rtn =""
	While(result.Next()){
		s startDate = result.Data("InterPeriod_startDate")
		s endDate = result.Data("InterPeriod_endDate")
		i sFlag="start" d
		.s rtn= $zd(startDate,3)
		e  d
		.s rtn= $zd(endDate,3) 
	}

	

	d result.Close()
	
	q rtn
}

ClassMethod indirect(str)
{
	
	q @str
}

/// 
/// BonusSubIncomeCollectID^IncomeItemCode^IncomeItemName^BonusYear^BonusPeriod^MakeBillDeptCode^MakeBillDeptName^ExecuteDeptCode^ExecuteDeptName^SickDeptCode^SickDeptName^ChiefDoctorCode^ChiefDoctorName^MakeBillDoctorCode^MakeBillDoctorName^ExecuteDoctorCode^ExecuteDoctorName^SickType^ExpensesType^IncomeMoney^State^InterLocMethodID^UpdateDate
/// Creator: Zhao LiGuo
/// CreatDate: 2011-4-21
/// Description: 得到奖金方案的指标
/// Table：dhc_bonus_data.BonusSchemeUnit
/// Input:schemeCode_奖金方案编码
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uInterMain).getSchemeTarget("02")
ClassMethod InsertSubCollectData(sParm, sData)
{
	n (sParm,sData)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="select BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName from dhc_bonus_data.SchemeTarget"_
	"   where  BonusSchemeID->BonusSchemeCode='"_schemeCode_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s rtn =""
	While(result.Next()){
		s code = result.Data("BonusTargetCode")
		s rtn=rtn_"^"_code
	}
	
	s rtn = $E(rtn,2,$L(rtn))
	d result.Close()
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
