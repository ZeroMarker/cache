Class dhc.pa.uInter.uDrugCFNum Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhaoliguo
/// CreatDate: 2014-11-26
/// Description:查询药房发药处方数量
/// Table：dhc.pa.udata.InterLoc 
/// Input: 有效日期 YYYY-MM-DD
/// Output: 
/// Return:  过期药品数量
/// Others: w ##class(dhc.pa.uInter.uDrugCFNum).uGetDurgCFNum("2014-05")
ClassMethod uGetDurgCFNum(sDate)
{
	n (sDate)
	s startDate=sDate_"-01"
	s month=$p(sDate,"-",2)
	s year=$p(sDate,"-",1)
	i month<12 d
	.s month1=month+1
	.s endDate=year_"-"_month1_"-"_"01"
	e  d
	.s year=year+1
	.s endDate=year_"-01-01"
	
	s bDate =$zdh(startDate,3)
	s eDate=$zdh(endDate,3)-1

	s cfNum=0
	&sql(SELECT count(a.%ID) into:cfNum FROM sqluser.DHC_PHDISPEN a,sqluser.DHC_PHLOC b
	WHERE PHD_PYDATE>=:bDate AND PHD_PYDATE<=:eDate
	AND a.PHD_PHL_DR= b.PHL_ROWID AND b.PHL_CTLOC_DR IN (82,154,307,84,414))
	
	q cfNum
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.uDrugCFNumS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
