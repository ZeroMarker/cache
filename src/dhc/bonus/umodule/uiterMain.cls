Class dhc.bonus.umodule.uiterMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//w ##class(dhc.bonus.umodule.uiterMain).InterMain("2015","01","chenwen",1)

ClassMethod InterMain(sYear As %String, sMonth As %String, user As %String, MethodDr As %String) As %String
{
	new (sYear,sMonth,user,MethodDr)

	s JXMonth = sMonth
	s JXYear = sYear
	s TJMonth = sMonth
	s TJYear = sYear
	s yearmonth=sYear _"-"_ sMonth
	;w yearmonth_"^"_user_"^"_sMonth,!
	/*
	;w sYear_":"_sMonth,!
	q:sYear="" "年度为空"
	q:sMonth="" "月份为空"
	s startDate=sYear_"-" _ sMonth _"-01"
	i sMonth="12" d
	.s sYear=sYear+1
	.s sMonth="1"
	e  d
	.s sMonth=sMonth+1
	i sMonth<10 s sMonth="0" _ sMonth
	s endDate=sYear _"-"_ sMonth _"-01"
	
	;w startDate _":"_endDate,!
	s YM=sYear_sMonth
	s mSDate=$zdh(startDate,3)
	;w "endDate:="_endDate,!
	s mEDate=$zdh(endDate,3)-1
	s sdate=$zd(mSDate,3)
	s edate=$zd(mEDate,3)
	
	;q sdate_":"_edate
  	;k ^zlgtmp
	 ;s ^zlgtmp("main")="interMain ...."
	;w MethodDr _":"_sdate_":"_edate,!
	w yearmonth_"^"_MethodDr_"^"_user_"^"_YM_"^"_sMonth,!
	*/
	s rtn=0
	//取物资系统的工资支出
	i MethodDr=2 d 
	.d ##class(dhc.bonus.umodule.GetHRWage).GetHRWage(sYear,sMonth,MethodDr,user)
	//取人事系统的物资支出
	i MethodDr=1 d 
	.d ##class(dhc.bonus.umodule.uGetDuraData).GetBonusDura(yearmonth,MethodDr,user)
	
	i MethodDr=3 d 
	.d ##class(dhc.bonus.umodule.GetEquiData).GetEquiData(sYear,sMonth,MethodDr,user)
	//这里是获得固定资产的数据
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.umodule.uiterMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
