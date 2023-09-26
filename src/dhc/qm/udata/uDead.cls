Class dhc.qm.udata.uDead Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:     ban
/// CreateDate:  2015-08-17
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式                        
/// Others:  w ##class(dhc.qm.udata.uDead).GetDeadInfo("<Request><planDr>6</planDr><status>1</status><wardDr>43</wardDr><qmschemDr>6</qmschemDr><deptGroupDr>20</deptGroupDr><period>201502</period></Request>")
ClassMethod GetDeadInfo(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><wardDr>33</wardDr><planDr>3</planDr><period>201502</period><status>1</status><qmschemDr>6</qmschemDr><deptGroupDr>18</deptGroupDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s deptGroupDr=request.deptGroupDr
	   s wardDr=request.wardDr
	   s period=request.period
	   s planDr=request.planDr
	   s qmschemDr=request.qmschemDr
	   s status=request.status
	}
	 s resultString=""
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:wardDr="" "NowardDr"
	 q:period="" "Noperiod"
	 q:planDr="" "NoplanDr"
	 q:qmschemDr="" "NoqmschemDr"
	 q:status="" "Nostatus"
	 
	 s resultString=##class(dhc.qm.udata.uOPerInfo).List(deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	 q resultString
}

}
