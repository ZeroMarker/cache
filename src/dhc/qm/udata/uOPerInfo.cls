Class dhc.qm.udata.uOPerInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:     ban
/// CreateDate:  2015-08-05
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式                        
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetOperInfo("<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><status>0</status></Request>")
///                                                         <Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><status>0</status><qmschemDr>1</qmschemDr><deptGroupDr>20</deptGroupDr></Request>
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetOperInfo("<Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><status>0</status><qmschemDr>9</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetOperInfo(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><status>0</status></Request>"
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

/// Creator:     ban
/// CreateDate:  2015-08-05
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).List("20","43","201501","1","1","0")
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).List("27","124","201503","1","3","0")
ClassMethod List(deptGroupDr, wardDr, period, planDr, qmschemDr, status) As %String
{
	n (deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	s statusName=""
	s deceNum = 0
	q:deptGroupDr="" "NodeptGroupDr"
	q:wardDr="" "NowardDr"
	q:period="" "Noperiod"
	q:planDr="" "NoplanDr"
    q:qmschemDr="" "NoqmschemDr"
	q:status="" "Nostatus"
	s sqlStr="select JXPat_rowid,JXPat_name,JXPat_code,JXPat_Indoccode,JXPat_IndocName,JXPat_operatorcode,JXPat_operdocname,JXPat_operatorID,JXPat_operator,JXPat_operatordate,JXPat_decedate,JXPat_Adm from dhc_qm_data.JXPat"
			_"  where JXPat_rowid in(select distinct LocResultdetail_JXPatDr from dhc_qm_data.LocResultdetail"
			_"  where LocResultdetail_parRef->LocResultMain_Plandr='"_planDr_"' and LocResultdetail_parRef->LocresultMain_schemDr ='"_qmschemDr_"' and LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"' and LocResultdetail_parRef->LocResultmain_period='"_period_"' and LocResultdetail_parRef->LocresultMain_wardDr='"_wardDr_"' and LocResultdetail_saveStatus='"_status_"')"
    w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^operatorcode^operdocname^operatorID^operator^operatordate^status^statusName^decedate^deadNum"
	While(result.Next())
	{   
		s JXPatRowid = result.Data("JXPat_rowid")
		s JXPatName = result.Data("JXPat_name")
		s JXPatCode = result.Data("JXPat_code")
		s JXPatIndoccode = result.Data("JXPat_Indoccode")
		s JXPatIndocName = result.Data("JXPat_IndocName")
		s JXPatOperatorcode = result.Data("JXPat_operatorcode")
		s JXPatOperdocname = result.Data("JXPat_operdocname")
		s JXPatOperatorID = result.Data("JXPat_operatorID")
		s JXPatOperator = result.Data("JXPat_operator")
		s JXPatOperatordate = result.Data("JXPat_operatordate")
		s decedate = result.Data("JXPat_decedate")
		s admNo = result.Data("JXPat_Adm")
		
		s deceNum = deceNum + 1
	    s jxpatDate = $zd(JXPatOperatordate,3)
	    s decedate = $zd(decedate,3)
		i status=0 s statusName="未检"
		i status=1 s statusName="已检"
		s tmp=JXPatRowid_"^"_admNo_"^"_JXPatName_"^"_JXPatCode_"^"_JXPatIndoccode_"^"_JXPatIndocName_"^"_JXPatOperatorcode_"^"_JXPatOperdocname_"^"_JXPatOperatorID_"^"_JXPatOperator_"^"_jxpatDate_"^"_status_"^"_statusName_"^"_decedate_"^"_deceNum
		;w tmp,!
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:     wang ying 
/// CreateDate:  2015-08-07
/// Description: 根据科室组ID、病区ID、考核期间、检查项目ID查询检查点信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.CheckInfo
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      调查明细信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetCheckInfo("<Request><patRowid>17</patRowid><wardDr>45</wardDr><period>201503</period><qmschemDr>2</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetCheckInfo("<Request><patRowid>n</patRowid><wardDr>43</wardDr><period>201502</period><qmschemDr>7</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetCheckInfo("<Request><patRowid>1</patRowid><wardDr>33</wardDr><period>201503</period><qmschemDr>4</qmschemDr><deptGroupDr>18</deptGroupDr></Request>")
ClassMethod GetCheckInfo(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><qmschemDr>1</qmschemDr><patRowid>1</patRowid></Request>"
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
	   s qmschemDr=request.qmschemDr
	   s patRowid=request.patRowid
	  
	}
	 s resultString=""
	 q:deptGroupDr="" "NodeptGroupDr"
	 ;q:wardDr="" "NowardDr"
	 q:period="" "Noperiod"
	 q:qmschemDr="" "NoqmschemDr"
	 ;q:patRowid="" "NopatRowid"
	 s resultString=##class(dhc.qm.udata.uOPerInfo).detailList(deptGroupDr,wardDr,period,qmschemDr,patRowid)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-08-07
/// Description: 根据科室组ID、病区ID、考核期间、检查项目ID查询检查点信息
///              patRowid为n的时候 代表的是交接班获取检查点的
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.CheckInfo
/// Input:       科室组ID、病区ID、考核期间、检查项目ID、病人id
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).detailList("20","45","201503","2","")
ClassMethod detailList(deptGroupDr, wardDr, period, qmschemDr, patRowid) As %String
{
	n (deptGroupDr,wardDr,period,qmschemDr,patRowid)
	s statusName=""
	
	q:deptGroupDr="" "NodeptGroupDr"
	q:wardDr="" "NowardDr"
	q:period="" "Noperiod"
    q:qmschemDr="" "NoqmschemDr"
	s sqlStr="SELECT LocResultdetail_rowid,LocResultdetail_JXPatDr,LocResultdetail_JXPatDr->JXPat_name,LocResultdetail.LocResultdetail_checkDr,LocResultdetail_checkDr->Check_name,LocResultdetail_checkDr->Check_code,LocResultdetail_checkDr->Check_locType,"
			_"LocResultdetail_checkDr->Check_colType as colType,LocResultdetail_checkDr->Check_AssessType,LocResultdetail_checkDr->Check_photo,LocResultdetail_actValue,LocResultdetail_txtValue,LocResultdetail_PicLink,"
			_"LocResultdetail_checkDr->Check_spcil,LocResultdetail_checkDr->Check_ObjectType,LocResultdetail_checkDr->Check_comp FROM dhc_qm_data.LocResultdetail where %ID>0"
    
    i period'="" s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_period='"_period_"'"
    ;i ((patRowid'="")&&(patRowid'="n")) s sqlStr=sqlStr_" and LocResultdetail_JXPatDr='"_patRowid_"'"
    i patRowid'="" s sqlStr=sqlStr_" and LocResultdetail_JXPatDr='"_patRowid_"'"
    i wardDr'="" s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_wardDr='"_wardDr_"'" 
    i deptGroupDr'=""  s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"'"
    i qmschemDr'="" s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_schemDr='"_qmschemDr_"'"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^patRowid^patName^checkDr^checkName^CheckcolType^CheckcolTypeName^ChecklocType^ChecklocTypeName"
	            _"^CheckObjectType^CheckObjectTypeName^Checkcomp^Checkspcil^Checkphoto^CheckAssessType^CheckAssessTypeName^txtValue^actValue^PicLink"
	While(result.Next())
	{   
		s checkCode=""
		s rowid = result.Data("LocResultdetail_rowid")
		s JXPatRowid = result.Data("LocResultdetail_JXPatDr")
		s JXPatName = result.Data("JXPat_name")
		s checkDr = result.Data("LocResultdetail_checkDr")
		s checkName = result.Data("Check_name")
		
		s CheckcolType = result.Data("colType")
		i CheckcolType="1" s CheckcolTypeName="录入"
		i CheckcolType="2" s CheckcolTypeName="PAD采集"
		i CheckcolType="3" s CheckcolTypeName="计算"
		
		s ChecklocType = result.Data("colType")
		i ChecklocType="1" s ChecklocTypeName="考核调查科室"
		i ChecklocType="2" s ChecklocTypeName="考核执行科室"
		
		s CheckObjectType = result.Data("Check_ObjectType")
		i CheckObjectType="1" s CheckObjectTypeName="科室"
		i CheckObjectType="2" s CheckObjectTypeName="病人"
		
		
		s Checkcomp = result.Data("Check_comp")
		s Checkspcil = result.Data("Check_spcil")
		s Checkphoto = result.Data("Check_photo")
		s CheckAssessType = result.Data("Check_AssessType")
		i CheckAssessType="1" s CheckAssessTypeName="选项"
		i CheckAssessType="2" s CheckAssessTypeName="文本"
		s txtValue = result.Data("LocResultdetail_txtValue")
		s actValue = result.Data("LocResultdetail_actValue")
		s PicLink = result.Data("LocResultdetail_PicLink")
		;w PicLink,! 
		s checkCode= result.Data("Check_code")
		i ((checkCode'="016")&&(checkCode'="017")) d
		.s tmp=rowid_"^"_JXPatRowid_"^"_JXPatName_"^"_checkDr_"^"_checkName_"^"_CheckcolType_"^"_CheckcolTypeName_"^"_ChecklocType_"^"_ChecklocTypeName_"^"_CheckObjectType_"^"_CheckObjectTypeName_"^"_Checkcomp_"^"_Checkspcil_"^"_Checkphoto_"^"_CheckAssessType_"^"_CheckAssessTypeName_"^"_txtValue_"^"_actValue_"^"_PicLink
		.d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-25
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式                        
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetOper("<Request><wardDr>33</wardDr><period>201502</period><planDr>3</planDr><deptGroupDr>18</deptGroupDr><status>0</status><qmschemDr>2</qmschemDr></Request>")
///                                                         <Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><status>0</status><qmschemDr>1</qmschemDr><deptGroupDr>20</deptGroupDr></Request>
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetOper("<Request><wardDr>33</wardDr><period>201502</period><planDr>3</planDr><deptGroupDr>18</deptGroupDr><status>0</status><qmschemDr>3</qmschemDr></Request>")
ClassMethod GetOper(Param As %String) As %String
{
	 	 
	;n (Param)
	i Param="" s Param="<Request><deptGroupDr>18</deptGroupDr><wardDr>33</wardDr><period>201502</period><planDr>1</planDr><qmschemDr>2</qmschemDr><status>0</status></Request>"
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
	 
	 s resultString=##class(dhc.qm.udata.uOPerInfo).UnOperationList(deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-25
/// Description: 根据科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态查询病人信息
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.JXPat
/// Input:       科室组ID、病区ID、考核期间、计划表ID、检查项目ID、是否检状态
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).UnOperationList("20","43","201501","1","1","0")
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).UnOperationList("18","33","201502","3","6","0")
ClassMethod UnOperationList(deptGroupDr, wardDr, period, planDr, qmschemDr, status) As %String
{
	;n (deptGroupDr,wardDr,period,planDr,qmschemDr,status)
	s statusName=""
	s deceNum = 0
	q:deptGroupDr="" "NodeptGroupDr"
	q:wardDr="" "NowardDr"
	q:period="" "Noperiod"
	q:planDr="" "NoplanDr"
    q:qmschemDr="" "NoqmschemDr"
	q:status="" "Nostatus"
	s sqlStr="select JXPat_rowid,JXPat_Adm,JXPat_name,JXPat_code,JXPat_Indoccode,JXPat_IndocName,JXPat_OperationID,JXPat_Operation,JXPat_Operationdate from dhc_qm_data.JXPat"
			_"  where JXPat_rowid in(select distinct LocResultdetail_JXPatDr from dhc_qm_data.LocResultdetail"
			_"  where LocResultdetail_parRef->LocResultMain_Plandr='"_planDr_"' and LocResultdetail_parRef->LocresultMain_schemDr ='"_qmschemDr_"' and LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"' and LocResultdetail_parRef->LocResultmain_period='"_period_"' and LocResultdetail_parRef->LocresultMain_wardDr='"_wardDr_"' and LocResultdetail_saveStatus='"_status_"')"
    w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^OperationID^OperationName^Operationdate^status^statusName"
	While(result.Next())
	{   
		s JXPatRowid = result.Data("JXPat_rowid")
		s JXPatName = result.Data("JXPat_name")
		s JXPatCode = result.Data("JXPat_code")
		s JXPatIndoccode = result.Data("JXPat_Indoccode")
		s JXPatIndocName = result.Data("JXPat_IndocName")
		s JXPatOperationID = result.Data("JXPat_OperationID")
		s JXPatOperationName = result.Data("JXPat_Operation")
		s JXPatOperationdate = result.Data("JXPat_Operationdate")
		s admNo = result.Data("JXPat_Adm")
	    s JXPatOperationdate = $zd(JXPatOperationdate,3)
	    
		i status=0 s statusName="未检"
		i status=1 s statusName="已检"
		s tmp=JXPatRowid_"^"_admNo_"^"_JXPatName_"^"_JXPatCode_"^"_JXPatIndoccode_"^"_JXPatIndocName_"^"_JXPatOperationID_"^"_JXPatOperationName_"^"_JXPatOperationdate_"^"_status_"^"_statusName
		;w tmp,!
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:     ban 
/// CreateDate:  2015-11-26
/// Description: 根据检查点对应的id，获取检查点的图片路径
/// Table:       dhc_qm_data.LocResultdetail
/// Input:       检查点ID
/// Return:      调查明细信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).GetImageURL("<Request><checkRowid>69</checkRowid></Request>")
ClassMethod GetImageURL(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><checkRowid>37</checkRowid></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	;s ^hhjkgkk = Param
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s checkRowid=request.checkRowid
	}
	s resultString=""
	q:checkRowid="" "NocheckRowid"
	&sql(select LocResultdetail_PicLink into :ImageURL from dhc_qm_data.LocResultdetail  where LocResultdetail_rowid =:checkRowid)
	i ImageURL '="" d
	.s resultString="{success:'true',info:'"_ImageURL_"'}"
	e  d
	.s resultString= "{success:'false',info:''}"
	q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-11-26
/// Description: 根据检查点对应的id，检查点的图片路径,删除图片
/// Table:       dhc_qm_data.LocResultdetail
/// Input:       检查点ID
/// Return:      调查明细信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).DeleteImageURL("<Request><checkRowid>125</checkRowid><PicLink>http://10.160.16.30:8081/VideoShare/files2015/12/01/14/4f990573-4514-4ccc-91d0-04595e655ca9.jpg</PicLink></Request>")
ClassMethod DeleteImageURL(Param As %String) As %String
{
	 	 
	n (Param)
	i Param="" s Param="<Request><checkRowid>7</checkRowid><PicLink>http://10.160.16.30:8081/VideoShare/files2015/11/24/16/cc9c11a4-f8c3-4fcc-88c0-32af290318ed.jpg</PicLink></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	;s ^hhjkgkk = Param
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s checkRowid=request.checkRowid
	   s PicLink=request.PicLink
	}
	s resultString=""
	q:checkRowid="" "NocheckRowid"
	q:PicLink="" "NoPicLink"
	s resultString=..DeleteImage(checkRowid,PicLink)
	q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-11-26
/// Description: 根据检查点对应的id，检查点的图片路径,删除图片
/// Table:       dhc_qm_data.LocResultdetail
/// Input:       检查点ID
/// Return:      调查明细信息，json格式
/// Others:  w ##class(dhc.qm.udata.uOPerInfo).DeleteImage("7","http://10.160.16.30:8081/VideoShare/files2015/11/24/16/cc9c11a4-f8c3-4fcc-88c0-32af290318ed.jpg")
ClassMethod DeleteImage(checkRowid, PicLink) As %String
{
	 	 
	n (checkRowid,PicLink)
	
	s resultString=""
	q:checkRowid="" "NocheckRowid"
	q:PicLink="" "NoPicLink"
	s sqlcode=0
	&sql(select LocResultdetail_PicLink into :ImageURL from dhc_qm_data.LocResultdetail  where LocResultdetail_rowid =:checkRowid)
	i ImageURL '="" d
	.s len=$l(PicLink)
	.s end=$f(ImageURL,PicLink)
	.s start=end-len
	.;w start_"^"_len_"^"_end_"^"_$e(ImageURL,1,start-1),!
	.s url=$e(ImageURL,1,start-1)_$e(ImageURL,end+1,$l(ImageURL))
	.&sql(update dhc_qm_data.LocResultdetail set LocResultdetail_PicLink=:url where LocResultdetail_rowid =:checkRowid)
	.i sqlcode'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("DeleteImageURL",checkRowid_"^"_url,sqlcode,"")
	.s resultString="{success:'true',info:'"_sqlcode_"'}"
	e  d
	.s resultString= "{success:'false',info:''}"
	q resultString
}

}
