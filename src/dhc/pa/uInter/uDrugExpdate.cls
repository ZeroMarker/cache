Class dhc.pa.uInter.uDrugExpdate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhaoliguo
/// CreatDate: 2014-11-26
/// Description:查询药库、药房过期药品数量
/// Table：dhc.pa.udata.InterLoc 
/// Input: 有效日期 YYYY-MM-DD
/// Output: 
/// Return:  过期药品数量
/// Others: w ##class(dhc.pa.uInter.uDrugExpdate).uGetDurgExpdateNum("2014-12-31")
ClassMethod uGetDurgExpdateNum(sDate)
{
	n (sDate)
	s exNum=0
	zn "dhc-data"
	k ^dhcjxDrugExpdateNum
	d GetItmLocBat^DHCPAEXPDATEWARN("mzxyf-门诊西药房","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("mzxyf-门诊西药房","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("jzyf-急诊药房","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("bjyf-保健药房","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("gryf-感染药房","","N",sDate)
	
	d GetItmLocBat^DHCPAEXPDATEWARN("xyk-西药库","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("zyk-中药库","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("jxypk-近效药品库","","N",sDate)
	d GetItmLocBat^DHCPAEXPDATEWARN("xsypk-消杀药品库","","N",sDate)
	
	s dName=""
	f  s dName=$o(^dhcjxDrugExpdateNum(dName)) q:$g(dName)=""  d	
	.s exNum=exNum+$G(^dhcjxDrugExpdateNum(dName))
	zn "dhc-app"
	
	q exNum
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.uDrugExpdateS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
