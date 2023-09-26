Class dhc.bonus.uinter.uInterMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others:w ##class(dhc.bonus.uinter.uInterMain).InterMain("2014","09","9")
ClassMethod InterMain(sYear As %String, sMonth As %String, MethodDr As %String) As %String
{
	new (sYear,sMonth,MethodDr)

	s JXMonth = sMonth
	s JXYear = sYear
	s TJMonth = sMonth
	s TJYear = sYear
	
	;w sYear_":"_sMonth,!
	q:sYear="" "年度为空"
	q:sMonth="" "年度为空"
	s startDate=sYear_"-" _ sMonth _"-01"
	i sMonth="12" d
	.s sYear=sYear+1
	.s sMonth="01"
	e  d
	.s sMonth=sMonth+1
	i sMonth<10 s sMonth="0" _ sMonth
	s endDate=sYear _"-"_ sMonth _"-01"
	;w startDate _":"_endDate,!
	s YM=sYear_sMonth
	s mSDate=$zdh(startDate,3)
	s mEDate=$zdh(endDate,3)-1
	s sdate=$zd(mSDate,3)
	s edate=$zd(mEDate,3)
	
	;q sdate_":"_edate
  	;k ^zlgtmp
	 ;s ^zlgtmp("main")="interMain ...."
	;w MethodDr _":"_sdate_":"_edate,!
	s rtn=0
	//科室收入
	i MethodDr=1 d
	.d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetYWData(sdate,edate,MethodDr)
	//科室支出数据采集
	i MethodDr=3 d
	.d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDeptsDirectCost(sdate,edate,MethodDr)
	//门诊收入采集
	i MethodDr=4 d
	.d ##class(dhc.bonus.uinter.uGetYWSRgdj).GetDepTarAMCCate(sdate,edate,MethodDr)
	//门诊人数
	i MethodDr=5 d
	.;d ##class(dhc.bonus.uinter.uGetClinicCountData).GetClinicCount(sdate,edate,MethodDr)
	// 期内入院人数,出院人数总计,实际开放总床日数,实际占用总床日数,出院者占用总床日数
   	i MethodDr=6 d
	.d ##class(dhc.bonus.uinter.uGetClinicCountData).MRDynaALLData(sdate,edate,MethodDr)
	//绩效考核分采集
	i MethodDr=7 d
	.d ##class(dhc.bonus.uinter.uGetJXScore).GetJXScore(JXYear,JXMonth,MethodDr)
	//医师挂号工作量采集
	i MethodDr=8 d
	.d ##class(dhc.bonus.uinter.uGetRegPersonData).GetRegPersonData(JXYear,JXMonth,MethodDr)
	//体检工作量采集
	i MethodDr=9 d 
	.d ##Class(dhc.bonus.uinter.uGetTJWorkData).GetTJWorkData(TJYear,TJMonth,MethodDr)

	//药房发退药作量采集
	i MethodDr=11 d 
	.d ##class(dhc.bonus.uinter.uGetYFFTDataGDJ).GetYFFTData(sdate,edate,MethodDr)
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uInterMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
