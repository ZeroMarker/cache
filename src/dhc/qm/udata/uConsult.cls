Class dhc.qm.udata.uConsult Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:     ban
/// CreateDate:  2015-09-06
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式                        
/// Others:  w ##class(dhc.qm.udata.uConsult).GetConsultInfo("<Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><status>0</status><qmschemDr>4</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetConsultInfo(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><status>0</status><qmschemDr>4</qmschemDr><deptGroupDr>20</deptGroupDr></Request>"
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
	 
	 s resultString=##class(dhc.qm.udata.uConsult).List(deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-05
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uConsult).List("20","43","201502","3","4","0")
ClassMethod List(deptGroupDr, wardDr, period, planDr, qmschemDr, status) As %String
{
	n (deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	s statusName=""
	q:deptGroupDr="" "NodeptGroupDr"
	q:wardDr="" "NowardDr"
	q:period="" "Noperiod"
	q:planDr="" "NoplanDr"
    q:qmschemDr="" "NoqmschemDr"
	q:status="" "Nostatus"
	s sqlStr="select JXPat_rowid,JXPat_Adm,JXPat_name,JXPat_code,JXPat_Indoccode,JXPat_IndocName,JXPat_consultID,JXPat_consultdepart,JXPat_consultdoccode,JXPat_consultdoc,JXPat_applydate,JXPat_consultdate,JXPat_consultdepart->DEP_Desc as consultdepartName from dhc_qm_data.JXPat"
			_"  where JXPat_rowid in(select distinct LocResultdetail_JXPatDr from dhc_qm_data.LocResultdetail"
			_"  where LocResultdetail_parRef->LocResultMain_Plandr='"_planDr_"' and LocResultdetail_parRef->LocresultMain_schemDr ='"_qmschemDr_"' and LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"' and LocResultdetail_parRef->LocResultmain_period='"_period_"' and LocResultdetail_parRef->LocresultMain_wardDr='"_wardDr_"' and LocResultdetail_saveStatus='"_status_"')"
    ;w sqlStr,!
	s applocName=""
	i deptGroupDr'=""  d
	.s applocName=$p(^RBC("DEP",deptGroupDr),"^",2)
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^consultID^consultdepart^consultdepartName^applocDr^applyloc^consultdoccode^consultdoc^applydate^consultdate^status^statusName"
	While(result.Next())
	{   
		s PatRowid = result.Data("JXPat_rowid")
		s PatName = result.Data("JXPat_name")
		s Code = result.Data("JXPat_code")
		s Indoccode = result.Data("JXPat_Indoccode")
		s IndocName = result.Data("JXPat_IndocName")
		s consultID = result.Data("JXPat_consultID")
		s consultdepart = result.Data("JXPat_consultdepart")
		s consultdepartName = result.Data("consultdepartName")
		s consultdoccode = result.Data("JXPat_consultdoccode")
		s consultdoc = result.Data("JXPat_consultdoc")
		s applydate = result.Data("JXPat_applydate")
		s consultdate = result.Data("JXPat_consultdate")
		s admNo = result.Data("JXPat_Adm")
		
	    ;s jxpatDate = $zd(JXPatOperatordate,3)
		i status=0 s statusName="未检"
		i status=1 s statusName="已检"
		s tmp=PatRowid_"^"_admNo_"^"_PatName_"^"_Code_"^"_Indoccode_"^"_IndocName_"^"_consultID_"^"_consultdepart_"^"_consultdepartName_"^"_deptGroupDr_"^"_applocName_"^"_consultdoccode_"^"_consultdoc_"^"_applydate_"^"_consultdate_"^"_status_"^"_statusName
		;w tmp,!
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

}
