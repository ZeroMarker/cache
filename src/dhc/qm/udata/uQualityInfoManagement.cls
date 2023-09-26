/// author:zhaowei、yangyuying、penglintao
Class dhc.qm.udata.uQualityInfoManagement Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//caution:coltype好像应该为1和4

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).List("", "", 0, 15,"2015","M","05","","","","","demo")
ClassMethod List(sortField, sortDir, start, limit, year, type, period, dept, ward, checkdr, scheme, userid) As %String
{
	n (sortField, sortDir, start, limit,year,type,period,dept,ward,checkdr,scheme,userid)
	//此变量用于判断字符传中是否有病人信息若有，则返回字符传中包含病人信息
	s flag="false"
	s sqlStr=""
	s yearmonth=""
    if ((year'="")&(period'="")){
	s yearmonth=year_period
    }
    
    set schemedrs=""
    
    //&sql(SELECT max(Plan_QMSchemDr) into:schemedrs FROM dhc_qm_data.Plan WHERE Plan_CheckUser=:userid AND Plan_Status=1)
	s sqlStr=" SELECT "
	_" m.LocResultMain_rowid,m.LocResultMain_schemDr,m.LocResultMain_schemDr->QMSchem_name,m.LocResultMain_departDr,m.LocResultMain_departDr->DEP_Desc,m.LocResultMain_wardDr,m.LocResultMain_wardDr->WARD_Desc,m.LocResultMain_period,LocResultMain_auditDr->SSUSR_Name as audituser, LocResultMain_auditDate, LocResultMain_auditState, "
	_" d.LocResultdetail_rowid,d.LocResultdetail_JXPatDr,d.LocResultdetail_checkDr,d.LocResultdetail_saveUserDr->SSUSR_Name,d.LocResultdetail_saveDate,d.LocResultdetail_disqua,d.LocResultdetail_actValue,d.LocResultdetail_txtValue, "
	_" c.Check_code,c.Check_name, "
	//_" p.JXPat_Adm,p.JXPat_code as pcode,p.JXPat_name as pname,p.JXPat_IndocName,p.JXPat_operdocname "
	_" d.LocResultdetail_JXPatDr->JXPat_Adm,d.LocResultdetail_JXPatDr->JXPat_code as pcode,d.LocResultdetail_JXPatDr->JXPat_name as pname, "
	_" d.LocResultdetail_JXPatDr->JXPat_IndocName,d.LocResultdetail_JXPatDr->JXPat_operdocname "
	
	_" FROM dhc_qm_data.LocResultMain m,dhc_qm_data.LocResultdetail d,dhc_qm_data.CheckInfo c,dhc_qm_data.QMSchemDetail qd "
	_" WHERE m.LocResultMain_rowid=d.LocResultdetail_parRef "
	_" and d.LocResultdetail_checkDr=c.Check_rowid  "
	_"  AND qd.QMSchemDetail_parRef=m.LocResultMain_schemDr AND qd.QMSchemDetail_CheckDr= d.LocResultdetail_checkDr "
	
	_" and c.Check_colType in (1,4) "
	//_" and qd.QMSchemDetail_parRef in ("_schemedrs_")"
	if yearmonth'="" {
	s sqlStr=sqlStr_" and m.LocResultMain_period like '"_yearmonth_"'"
	}
	if dept'="" {s sqlStr=sqlStr_" and m.LocResultMain_departDr = "_dept_""}
	if ward'="" {s sqlStr=sqlStr_" and m.LocResultMain_wardDr = "_ward_""}
	if checkdr'="" {s sqlStr=sqlStr_" and c.Check_rowid = "_checkdr_""}
	if scheme'="" {s sqlStr=sqlStr_" and qd.QMSchemDetail_parRef = "_scheme_""}	
	if type'="" {s sqlStr=sqlStr_" AND qd.QMSchemDetail_parRef->QMSchem_periodType = '"_type_"'"}
	
	s sqlStr=sqlStr_" order by m.LocResultMain_period,m.LocResultMain_schemDr,m.LocResultMain_departDr,m.LocResultMain_wardDr"	
	;k ^chu2Sql
	;s ^chu2Sql = sqlStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s count=0
	s end=start+limit-1

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonWithOutPatient=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="parref^schemedr^schemename^desc^warddr^period^name^jxpatdr^adm^pcode^pname^indocname^operdocname^auditstate^audituser^auditdate^disqua"
	//s jsonTitleWithPatient="parref^schemedr^schemename^desc^warddr^period^name^jxpatdr^adm^pcode^pname^indocname^operdocname^auditstate^audituser^auditdate^disqua"
	s jsonTitleWithOutPatient="parref^schemedr^schemename^desc^warddr^period^name^auditstate^audituser^auditdate^disqua"
	While(result.Next())
	{
		s rowid= result.Data("LocResultdetail_rowid")
		s parref= result.Data("LocResultMain_rowid")
		
		s schemedr=result.Data("LocResultMain_schemDr")
		s schemename=result.Data("QMSchem_name")
		s departDr= result.Data("LocResultMain_departDr")
		s Desc= result.Data("DEP_Desc")
		//s wardDr= result.Data("LocResultMain_wardDr")
		s wardDr= result.Data("WARD_Desc")
		s period= result.Data("LocResultMain_period")
		//s JXPatDr= result.Data("LocResultdetail_JXPatDr")
		s JXPatDr= result.Data("pname")
		s checkDr= result.Data("LocResultdetail_checkDr")
		s code= result.Data("Check_code")
		s name= result.Data("Check_name")
		//病人信息不用显示了
		s Adm= result.Data("JXPat_Adm")
		i Adm'="" {s flag="true"}
		s pcode= result.Data("pcode")
		s pname= result.Data("pname")
		s IndocName= result.Data("JXPat_IndocName")
		s operdocname= result.Data("JXPat_operdocname")
	
		
		s savedate= result.Data("LocResultdetail_saveDate")
		s auditdate=result.Data("LocResultMain_auditDate")
		s audituser=result.Data("audituser")
		s auditstate=result.Data("LocResultMain_auditState")
		//1：提交 0：未提交 2：取消提交
		;i auditstate=1 s auditstate="审核"
		;i (auditstate=0) s auditstate="未审核"
		;i auditstate=2 s auditstate="取消审核"
		if (auditstate=1){
			s auditstate="审核"
		}elseif ( auditstate=2){
			s auditstate="取消审核"
		}else{
			s auditstate="未审核"
		}
		
		if savedate'="" {s savedate=##class(websys.Conversions).DateLogicalToHtml(savedate)}
		;w savedate,!
		s saveuserdr= result.Data("SSUSR_Name")
		s disqua= result.Data("LocResultdetail_disqua")
		s actvalue=result.Data("LocResultdetail_actValue")
		if actvalue'="" { if (actvalue="Y"){ s actvalue="是" }elseif (actvalue="N"){s actvalue="否"} }
		//else { s actvalue=result.Data("LocResultdetail_txtValue")}  //2015-12-17添加
		//if ((actvalue'="")&(actvalue="Y")) {s actvalue="是"}elseif ((actvalue'="")&(actvlaue="N")){ s actvalue="否"}
		s txtvalue=result.Data("LocResultdetail_txtValue")
		//此处显示值更改为actvalue
		//disqua用于展示行转列的值
		s disqua=rowid_"||"_actvalue_"||"_txtvalue


	s tempWithOutPatient=parref_"^"_schemedr_"^"_schemename_"^"_Desc_"^"_wardDr_"^"_period_"^"_name_"^"_auditstate_"^"_audituser_"^"_auditdate_"^"_disqua
	s temp=parref_"^"_schemedr_"^"_schemename_"^"_Desc_"^"_wardDr_"^"_period_"^"_name_"^"_JXPatDr_"^"_Adm_"^"_pcode_"^"_pname_"^"_IndocName_"^"_operdocname_"^"_auditstate_"^"_audituser_"^"_auditdate_"^"_disqua
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	.d jsonWithOutPatient.InsertRowData(tempWithOutPatient)
	s count=count+1
	}

	d result.Close()
	if (flag="true"){
	s resultString = json.getJsonData(jsonTitle,count)	
		}else {
	s resultString = jsonWithOutPatient.getJsonData(jsonTitleWithOutPatient,count)			
			}
	
	k json
	k jsonWithOutPatient
	q resultString
}

/// 获取科室
/// Others：w ##class(dhc.qm.udata.uQualityInfoManagement).DeptList(0,10,"")
ClassMethod DeptList(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DEP_RowId,DEP_Desc FROM SQLUser.RBC_DepartmentGroup where DEP_RowId>0 "
	i str'="" s sqlStr = sqlStr_" and DEP_Desc LIKE '%"_str_"%'"


	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit-1
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^Name"
	
	While(result.Next()){
		s rowid = result.Data("DEP_RowId")
		s Name = result.Data("DEP_Desc")

		s tmp=rowid_"^"_Name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^Name",count)
 	k json
	q resultString
}

//获取方案

/// Others：w ##class(dhc.qm.udata.uQualityInfoManagement).SchemeList(0,10,"手")
ClassMethod SchemeList(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT QMSchem_RowID,QMSchem_name FROM dhc_qm_data.QMSchem WHERE QMSchem_active='Y'"
	i str'="" s sqlStr = sqlStr_" and QMSchem_name LIKE '%"_str_"%'"
	s sqlStr=sqlStr_" and QMSchem_active='Y'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit-1
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^Name"
	
	While(result.Next()){
		s rowid = result.Data("QMSchem_RowID")
		s Name = result.Data("QMSchem_name")

		s tmp=rowid_"^"_Name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^Name",count)
 	k json
	q resultString
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).audit(1,1,1)
ClassMethod audit(rowid, audit, userid) As %String
{
	n (rowid,audit,userid)
	s data=$p($h,",",1)
	
	&sql( UPDATE dhc_qm_data.LocResultdetail
	SET LocResultdetail_saveUserDr = :userid
	, LocResultdetail_saveDate = :data
	, LocResultdetail_disqua = :audit
	WHERE LocResultdetail_rowid = :rowid)

	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).auditmain(1,1,1)
ClassMethod auditmain(rowid, audit, userid) As %String
{
	n (rowid,audit,userid)
	s data=$p($h,",",1)
	
	&sql( UPDATE dhc_qm_data.LocResultMain
	SET LocResultMain_auditDr = :userid
	, LocResultMain_auditDate = :data
	, LocResultMain_auditState = :audit
	WHERE LocResultMain_rowid = :rowid)
   
	q SQLCODE
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListJXPat("1","10","杨")
ClassMethod ListJXPat(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXPat_rowid,JXPat_name from dhc_qm_data.JXPat WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and JXPat_name LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXPat_rowid")
		s name = result.Data("JXPat_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListCheck("1","10","","")
ClassMethod ListCheck(start, limit, str, schemdr) As %String
{
	n (start, limit, str,schemdr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Check_rowid,Check_name from dhc_qm_data.CheckInfo c,dhc_qm_data.QMSchemDetail qm WHERE c.Check_rowid=qm.QMSchemDetail_CheckDr and qm.QMSchemDetail_parRef="_schemdr
	i str'="" s sqlStr = sqlStr_" and Check_name LIKE '%"_str_"%'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Check_rowid")
		s name = result.Data("Check_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListSSUSR("1","10","")
ClassMethod ListSSUSR(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SS_User WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		s name = result.Data("SSUSR_Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListDEP("1","10","")
ClassMethod ListDEP(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DEP_RowId,DEP_Desc from RBC_DepartmentGroup WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and DEP_Desc LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("DEP_RowId")
		s name = result.Data("DEP_Desc")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListPlandr("1","10","")
ClassMethod ListPlandr(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Plan_rowid,Plan_Title from dhc_qm_data.Plan WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and Plan_Title LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Plan_rowid")
		s name = result.Data("Plan_Title")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListschemDr("1","10","",3901)
ClassMethod ListschemDr(start, limit, str, userid) As %String
{
	n (start, limit, str,userid)
	//s userid=1
	//&sql(SELECT max(Plan_QMSchemDr) into:schemedrs FROM dhc_qm_data.Plan WHERE Plan_CheckUser=:userid AND Plan_Status=1)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select QMSchem_RowID,QMSchem_name from dhc_qm_data.QMSchem WHERE  QMSchem_active='Y' and QMSchem_importType=2"
	//_"and QMSchem_RowID in ("_schemedrs_")"
	i str'="" s sqlStr = sqlStr_" and QMSchem_name LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("QMSchem_RowID")
		s name = result.Data("QMSchem_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListdepartDr("1","10","")
ClassMethod ListdepartDr(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DEP_RowId,DEP_Desc from SQLUser.RBC_DepartmentGroup WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and DEP_Desc LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("DEP_RowId")
		s name = result.Data("DEP_Desc")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListwardDr("1","10","")
ClassMethod ListwardDr(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CTLOC_RowID,CTLOC_Code from SQLUser.CT_Loc WHERE 1=1"
	i str'="" s sqlStr = sqlStr_" and JXPat_name LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("CTLOC_RowID")
		s name = result.Data("CTLOC_Code")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).SuperInsert("",13,6,"201501","106","","",90,"","33","","","3901","","","")
ClassMethod SuperInsert(plandr, schemdr, departdr, period, warddr, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua) As %String
{
	n (plandr, schemdr, departdr, period, warddr, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua)
	s result=0
	s message=0
	s flag=..IsExistMain( schemdr, departdr, period, warddr)
	if ((flag="")||(flag=0)){ //没有存在的记录
		s result=..InsertMain(plandr, schemdr, departdr, period, warddr)
		s message=message_" InsertMain -> "_result
	}else{
		s result=result+..UpdateMain(flag, plandr, schemdr, departdr, period, warddr)
		s message=message_" UpdateMain -> "_result	
	} 
	s maindr=..IsExistMain(schemdr, departdr, period, warddr)

	s flag=..IsExistDetail(maindr, jxpatdr, checkdr)
	
	s savedate=$p($h,",",1)
	if ((flag="")||(flag=0)){
		
		s result=result+..InsertDetail(schemdr,maindr, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua)
		s message=message_" InsertDetail -> "_result
	}else{	
		s result=result+..UpdateDetail(flag,maindr,sdetaildr,jxpatdr,checkdr,rate,actvalue,txtvalue,piclink,saveuserdr,savedate,exdepartdr,disqua)	
		s message=message_" UpdateDetail -> "_result
	}

	q result
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).IsExistMain(1,2,4,"2",5)
ClassMethod IsExistMain(schemdr, departdr, period, warddr) As %String
{
	n ( schemdr, departdr, period, warddr)
	s rowid=0
	i warddr'="" d
	.&sql(SELECT LocResultMain_rowid into :rowid FROM dhc_qm_data.LocResultMain WHERE  LocResultMain_schemDr=:schemdr and LocResultMain_departDr=:departdr and LocResultMain_period=:period and LocResultMain_wardDr=:warddr)
	e  d
	.&sql(SELECT LocResultMain_rowid into :rowid FROM dhc_qm_data.LocResultMain WHERE  LocResultMain_schemDr=:schemdr and LocResultMain_departDr=:departdr and LocResultMain_period=:period)
	q rowid
}

/// Creator: wang ying
/// CreatDate:2015-11-19
/// Description: 查询符合条件的记录
/// Table: dhc_qm_data.QMSchemDetail
/// Input:schemdr:方案id,checkdr:检查点id
/// Output: 方案明细id
/// Return: 
/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).IsExistSchemDetail("14","28") 
ClassMethod IsExistSchemDetail(schemdr, checkdr) As %String
{
	n ( schemdr,checkdr)
	&sql(SELECT QMSchemDetail_rowid into :rowid FROM dhc_qm_data.QMSchemDetail WHERE QMSchemDetail_parRef=:schemdr AND QMSchemDetail_CheckDr=:checkdr)
	q rowid
}

/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).IsExistDetail(57,4,2)
ClassMethod IsExistDetail(parref, jxpatdr, checkdr) As %Integer
{
	n (parref,jxpatdr, checkdr)
	s rowid=0
	i jxpatdr'="" d
	.&sql(SELECT LocResultdetail_rowid into :rowid FROM dhc_qm_data.LocResultdetail WHERE LocResultdetail_parRef=:parref and LocResultdetail_JXPatDr=:jxpatdr and LocResultdetail_checkDr=:checkdr)
	e  d
	.&sql(SELECT LocResultdetail_rowid into :rowid FROM dhc_qm_data.LocResultdetail WHERE LocResultdetail_parRef=:parref and LocResultdetail_checkDr=:checkdr)
	q rowid
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).InsertMain(1,2,4,"2",5)
ClassMethod InsertMain(plandr, schemdr, departdr, period, warddr) As %String
{
	n (plandr,schemdr,departdr,period,warddr)


	&sql(INSERT INTO dhc_qm_data.LocResultMain(LocResultMain_Plandr,LocResultMain_schemDr,LocResultMain_departDr,LocResultMain_period,LocResultMain_wardDr) VALUES (:plandr,:schemdr,:departdr,:period,:warddr ))

	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).InsertDetail(3,2,4,2,5,"4","6","3",4,"6",7)
ClassMethod InsertDetail(schemdr, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua) As %String
{
	n (schemdr,parref,sdetaildr,jxpatdr,checkdr,rate,actvalue,txtvalue,piclink,saveuserdr,savedate,exdepartdr,disqua)
	&sql(SELECT QMSchemDetail_rowid into:sdetaildr FROM dhc_qm_data.QMSchemDetail WHERE QMSchemDetail_parRef = :schemdr AND QMSchemDetail_CheckDr = :checkdr)
	//w !," parref "_parref_" sdetaildr "_sdetaildr_" jxpatdr "_jxpatdr_" checkdr "_checkdr_" rate "_rate_" actvalue "_actvalue_" txtvalue "_txtvalue_" piclink "_piclink_" saveuserdr "_saveuserdr_" savedate "_savedate_" exdepartdr "_exdepartdr_" disqua "_disqua,!
	;b
	s saveStatus=1
	&sql(INSERT INTO dhc_qm_data.LocResultdetail(LocResultdetail_parRef, LocResultdetail_sDetailDr, LocResultdetail_JXPatDr, LocResultdetail_checkDr, LocResultdetail_rate, LocResultdetail_actValue, LocResultdetail_txtValue, LocResultdetail_PicLink, LocResultdetail_saveUserDr, LocResultdetail_saveDate, LocResultdetail_exdepartDr, LocResultdetail_disqua,LocResultdetail_saveStatus) VALUES (:parref,:sdetaildr,:jxpatdr,:checkdr,:rate,:actvalue,:txtvalue,:piclink,:saveuserdr,:savedate,:exdepartdr,:disqua,:saveStatus))

	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateMain(57,1,2,4,"2",5)
ClassMethod UpdateMain(rowid, plandr, schemdr, departdr, period, warddr) As %String
{
	n (rowid,plandr,schemdr,departdr,period,warddr)

 	i plandr =""  s Plist(2) = $list(^DHCCJXQMLocResultMainD(rowid),2)
 	i schemdr =""  s Plist(3) = $list(^DHCCJXQMLocResultMainD(rowid),3)
 	i departdr =""  s Plist(4) = $list(^DHCCJXQMLocResultMainD(rowid),4)
 	i period =""  s Plist(5) = $list(^DHCCJXQMLocResultMainD(rowid),5)
 	i warddr =""  s Plist(6) = $list(^DHCCJXQMLocResultMainD(rowid),6)
 	i plandr '=""  s Plist(2) = plandr
 	i schemdr '=""  s Plist(3) = schemdr
 	i departdr '=""  s Plist(4) = departdr
 	i period '=""  s Plist(5) = period
 	i warddr '=""  s Plist(6) = warddr
	&sql(UPDATE dhc_qm_data.LocResultMain VALUES Plist() where %ID=:rowid)
	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateDetail(165,57,2,4,2,5,"4","6","3",4,"6",7,5)
ClassMethod UpdateDetail(rowid, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua) As %String
{
	n (rowid,parref,sdetaildr,jxpatdr,checkdr,rate,actvalue,txtvalue,piclink,saveuserdr,savedate,exdepartdr,disqua)
	//w !," rowid "_rowid_" parref "_parref_" sdetaildr "_sdetaildr_" jxpatdr "_jxpatdr_" checkdr "_checkdr_" rate "_rate_" actvalue "_actvalue_" txtvalue "_txtvalue_" piclink "_piclink_" saveuserdr "_saveuserdr_" savedate "_savedate_" exdepartdr "_exdepartdr_" disqua "_disqua,!


 	i parref =""  s Plist(2) = $list(^DHCCJXQMLocResultdetailD(rowid),2)
 	i sdetaildr =""  s Plist(3) = $list(^DHCCJXQMLocResultdetailD(rowid),3)
 	i jxpatdr =""  s Plist(4) = $list(^DHCCJXQMLocResultdetailD(rowid),4)
 	i checkdr =""  s Plist(5) = $list(^DHCCJXQMLocResultdetailD(rowid),5)
 	i rate =""  s Plist(6) = $list(^DHCCJXQMLocResultdetailD(rowid),6)
 	i actvalue =""  s Plist(7) = $list(^DHCCJXQMLocResultdetailD(rowid),7)
 	i txtvalue =""  s Plist(8) = $list(^DHCCJXQMLocResultdetailD(rowid),8)
 	i piclink =""  s Plist(9) = $list(^DHCCJXQMLocResultdetailD(rowid),9)
 	i saveuserdr =""  s Plist(10) = $list(^DHCCJXQMLocResultdetailD(rowid),10)
 	i savedate =""  s Plist(11) = $p($h,",",1) //$list(^DHCCJXQMLocResultdetailD(rowid),11)
 	i exdepartdr =""  s Plist(12) = $list(^DHCCJXQMLocResultdetailD(rowid),12)
 	i disqua =""  s Plist(13) = $list(^DHCCJXQMLocResultdetailD(rowid),13)
 	
 	i parref '=""  s Plist(2) = parref
 	i sdetaildr '=""  s Plist(3) = sdetaildr
 	i jxpatdr '=""  s Plist(4) = jxpatdr
 	i checkdr '=""  s Plist(5) = checkdr
 	i rate '=""  s Plist(6) = rate
 	i actvalue '=""  s Plist(7) = actvalue
 	i txtvalue '=""  s Plist(8) = txtvalue
 	i piclink '=""  s Plist(9) = piclink
 	i saveuserdr '=""  s Plist(10) = saveuserdr
 	i savedate '=""  s Plist(11) = savedate
 	i exdepartdr '=""  s Plist(12) = exdepartdr
 	i disqua '=""  s Plist(13) = disqua
 	s Plist(14) = 1
	&sql(UPDATE dhc_qm_data.LocResultdetail VALUES Plist() where %ID=:rowid)
	q SQLCODE
}

/// //////////////////////////////////////////////////
/// Other: w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateRecTotal("86","", "", "", "", "", "330", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod UpdateRecTotal(mainrowid, plandr, schemdr, departdr, period, warddr, detailrowid, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua) As %String
{
	n (mainrowid, plandr, schemdr, departdr, period, warddr,detailrowid, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua)
	s result=0
	s result=result+..UpdateRecMain(mainrowid, plandr, schemdr, departdr, period, warddr)
	s result=result+..UpdateRecDetail(detailrowid, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua)
	q result
}

/// //////////////////////////////////////////////////
/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateRecMain("93","","","","","")
ClassMethod UpdateRecMain(mainrowid, plandr, schemdr, departdr, period, warddr) As %String
{
	n (mainrowid, plandr, schemdr, departdr, period, warddr)
	
 	i plandr     =""  s Plist(2) = $list(^DHCCJXQMLocResultMainD(mainrowid),2)
 	i schemdr    =""  s Plist(3) = $list(^DHCCJXQMLocResultMainD(mainrowid),3)
 	i departdr   =""  s Plist(4) = $list(^DHCCJXQMLocResultMainD(mainrowid),4)
 	i period     =""  s Plist(5) = $list(^DHCCJXQMLocResultMainD(mainrowid),5)
 	i warddr     =""  s Plist(6) = $list(^DHCCJXQMLocResultMainD(mainrowid),6)
 	
 	i plandr     '=""  s Plist(2) = plandr
 	i schemdr    '=""  s Plist(3) = schemdr
 	i departdr   '=""  s Plist(4) = departdr
 	i period     '=""  s Plist(5) = period
 	i warddr     '=""  s Plist(6) = warddr
 	&sql(UPDATE dhc_qm_data.LocResultMain VALUES Plist() where %ID=:mainrowid)
 	q SQLCODE
}

/// //////////////////////////////////////////////////
/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateRecDetail("337","","","","","","","","","","","","")
ClassMethod UpdateRecDetail(detailrowid, parref, sdetaildr, jxpatdr, checkdr, rate, actvalue, txtvalue, piclink, saveuserdr, savedate, exdepartdr, disqua) As %String
{
	n (detailrowid,parref,sdetaildr,jxpatdr,checkdr,rate,actvalue,txtvalue,piclink,saveuserdr,savedate,exdepartdr,disqua)


 	i parref =""  s Plist(2) = $list(^DHCCJXQMLocResultdetailD(detailrowid),2)
 	i sdetaildr =""  s Plist(3) = $list(^DHCCJXQMLocResultdetailD(detailrowid),3)
 	i jxpatdr =""  s Plist(4) = $list(^DHCCJXQMLocResultdetailD(detailrowid),4)
 	i checkdr =""  s Plist(5) = $list(^DHCCJXQMLocResultdetailD(detailrowid),5)
 	i rate =""  s Plist(6) = $list(^DHCCJXQMLocResultdetailD(detailrowid),6)
 	i actvalue =""  s Plist(7) = $list(^DHCCJXQMLocResultdetailD(detailrowid),7)
 	i txtvalue =""  s Plist(8) = $list(^DHCCJXQMLocResultdetailD(detailrowid),8)
 	i piclink =""  s Plist(9) = $list(^DHCCJXQMLocResultdetailD(detailrowid),9)
 	i saveuserdr =""  s Plist(10) = $list(^DHCCJXQMLocResultdetailD(detailrowid),10)
 	i savedate =""  s Plist(11) =$p($h,",",1) // $list(^DHCCJXQMLocResultdetailD(detailrowid),11)
 	i exdepartdr =""  s Plist(12) = $list(^DHCCJXQMLocResultdetailD(detailrowid),12)
 	i disqua =""  s Plist(13) = $list(^DHCCJXQMLocResultdetailD(detailrowid),13)
 	
 	i parref '=""  s Plist(2) = parref
 	i sdetaildr '=""  s Plist(3) = sdetaildr
 	i jxpatdr '=""  s Plist(4) = jxpatdr
 	i checkdr '=""  s Plist(5) = checkdr
 	i rate '=""  s Plist(6) = rate
 	i actvalue '=""  s Plist(7) = actvalue
 	i txtvalue '=""  s Plist(8) = txtvalue
 	i piclink '=""  s Plist(9) = piclink
 	i saveuserdr '=""  s Plist(10) = saveuserdr
 	i savedate '=""  s Plist(11) = savedate
 	i exdepartdr '=""  s Plist(12) = exdepartdr
 	i disqua '=""  s Plist(13) = disqua
 	s Plist(14) = 1
	&sql(UPDATE dhc_qm_data.LocResultdetail VALUES Plist() where %ID=:detailrowid)
	q SQLCODE
}

/// Creator:     初雅莉
/// CreateDate:  2015-11-24
/// Description: 质量管理信息维护---审核
///              当登录用户点击审核按钮时，要审核所有该登录人的记录。
/// Table:       dhc_qm_data.LocResultMain，dhc_qm_data.LocResultdetail,
/// 				 dhc_qm_data.CheckInfo ,    dhc_qm_data.QMSchemDetail
/// Input:       year,period,type,userid,status(审核状态)
/// Return:      
/// Others:  w ##class(dhc.qm.udata.uQualityInfoManagement).AuditAll("2016","02","Q","5681","1")
ClassMethod AuditAll(year, period, type, userid, status) As %String
{
	n (year,period,type,userid,status)
	s yearmonth=""
    if ((year'="")&(period'="")){
		s yearmonth=year_period
    }
	
	set sqlStr = "SELECT  m.LocResultMain_rowid as mainID ,m.LocResultMain_auditDr AS auditDr,m.LocResultMain_auditDate AS auditDate, "
						_"m.LocResultMain_auditState AS auditState,d.LocResultdetail_rowid,d.LocResultdetail_saveDate, "
						_"d.LocResultdetail_saveUserDr->SSUSR_Name,d.LocResultdetail_saveUserDr->SSUSR_Rowid as userid "
				_"FROM dhc_qm_data.LocResultMain m , "
					 _"dhc_qm_data.LocResultdetail d, "
					 _"dhc_qm_data.CheckInfo c, "
					 _"dhc_qm_data.QMSchemDetail qd   "
				_"WHERE m.LocResultMain_rowid=d.LocResultdetail_parRef  " 
				     _"AND d.LocResultdetail_checkDr=c.Check_rowid    "
				     _"AND qd.QMSchemDetail_parRef=m.LocResultMain_schemDr  "
				     _"AND qd.QMSchemDetail_CheckDr= d.LocResultdetail_checkDr   "
				     _"AND c.Check_colType in (1,4)   "
				     _"AND qd.QMSchemDetail_parRef->QMSchem_periodType = '"_type_"'  "
				     _"AND d.LocResultdetail_saveUserDr='"_userid_"' "
	if yearmonth'="" {
		s sqlStr=sqlStr_"AND m.LocResultMain_period like '"_yearmonth_"' "
	}
	if (status=1){ //审核
		set sqlStr=sqlStr_"AND( m.LocResultMain_auditState<>1 OR  m.LocResultMain_auditState IS NULL ) "
	}
	if (status=2){//取消审核
		set sqlStr=sqlStr_"AND m.LocResultMain_auditState=1 "
	}
	;w sqlStr,!	   
	set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(sqlStr)
	do result.Execute()
	
	set count = 0 ;统计出来的要审核或取消审核的个数
	set nowTime = ##class(websys.Conversions).DateLogicalToHtml($h) //获得当前日期
	while(result.Next()){
		set mainRowId = result.Data("mainID")
		//审核。改变表dhc_qm_data.LocResultMain，审核人，审核时间和审核状态
		set updateCode =..UpdateAudit(mainRowId,userid,nowTime,status)
		if (updateCode=1){
			set count=count+1
		}
	}
	s sqlcode=##class(dhc.qm.udata.uPlan).calPCScore(yearmonth,type)
	;set ^chuPa = year_"^"_period_"^"_type_"^"_userid_"--"_count_"--"
	q count
}

/// Creator:     初雅莉
/// CreateDate:  2015-11-24
/// Description: 质量管理信息维护---审核 更新表 dhc_qm_data.LocResultMain///             
/// Table:       dhc_qm_data.LocResultMain，
/// Input:       mainRowId(LocResultMain表rowid),userid,nowTime（当前时间）,auditState（审核转态：1审核，2取消审核，0或者null未审核）
/// Return:      状态
/// Others:  w ##class(dhc.qm.udata.uQualityInfoManagement).UpdateAudit("63","1","2015-11-24","1")
ClassMethod UpdateAudit(mainRowId, userid, nowTime, auditState) As %String
{
	n (mainRowId,userid,nowTime,auditState)
     s nowTim=##class(websys.Conversions).DateHtmlToLogical(nowTime)
	set sqlStr = "UPDATE dhc_qm_data.LocResultMain "
				_"SET LocResultMain_auditDr ="_userid
				_",LocResultMain_auditDate='"_nowTim_"',LocResultMain_auditState="_auditState
				_" WHERE LocResultMain_rowid ="_mainRowId	
	set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(sqlStr)
	do result.Execute()
	
	q result.Execute()
}

/// Creator:     初雅莉
/// CreateDate:  2015-12-24
/// Description: 质量管理信息维护---查询             
/// Table:       dhc_qm_data.LocResultMain，
/// Input:       
/// Return:     json
/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).ListNew("", "",0,10,"2016","Q","02","27","","","17","3901")
ClassMethod ListNew(sortField, sortDir, start, limit, year, type, period, dept, ward, checkdr, scheme, userid) As %String
{
	n (sortField, sortDir, start, limit,year,type,period,dept,ward,checkdr,scheme,userid)
	//此变量用于判断字符传中是否有病人信息若有，则返回字符传中包含病人信息
	s flag="false"
	s sqlStr=""
	s yearmonth=""
    if ((year'="")&(period'="")){
		s yearmonth=year_period
    }
   
    set schemedrs=""
    //&sql(SELECT max(Plan_QMSchemDr) into:schemedrs FROM dhc_qm_data.Plan WHERE Plan_CheckUser=:userid AND Plan_Status=1)
	s sqlStr=" SELECT "
	_" m.LocResultMain_rowid,m.LocResultMain_schemDr,m.LocResultMain_schemDr->QMSchem_name,m.LocResultMain_departDr,m.LocResultMain_departDr->DEP_Desc,m.LocResultMain_wardDr as wardId,m.LocResultMain_wardDr->WARD_Desc,m.LocResultMain_period,LocResultMain_auditDr->SSUSR_Name as audituser, LocResultMain_auditDate, LocResultMain_auditState, "
	_" d.LocResultdetail_rowid as delRowid,d.LocResultdetail_JXPatDr,d.LocResultdetail_checkDr,d.LocResultdetail_saveUserDr->SSUSR_Name,d.LocResultdetail_saveDate,d.LocResultdetail_disqua,d.LocResultdetail_actValue,d.LocResultdetail_txtValue, "
	_" c.Check_code,c.Check_name, "
	_" d.LocResultdetail_JXPatDr->JXPat_Adm,d.LocResultdetail_JXPatDr->JXPat_code as pcode,d.LocResultdetail_JXPatDr->JXPat_name as pname, "
	_" d.LocResultdetail_JXPatDr->JXPat_IndocName,d.LocResultdetail_JXPatDr->JXPat_operdocname "
	_" ,d.LocResultdetail_JXPatDr->JXPat_OccurDate as occurDate "  //2016-9-20 add发生时间  cyl
	_" FROM dhc_qm_data.LocResultMain m,dhc_qm_data.LocResultdetail d,dhc_qm_data.CheckInfo c " ;,dhc_qm_data.QMSchemDetail qd "
	_" WHERE m.LocResultMain_rowid=d.LocResultdetail_parRef "
	_" and d.LocResultdetail_checkDr=c.Check_rowid  "
	;_" AND qd.QMSchemDetail_CheckDr= d.LocResultdetail_checkDr "
	_" and c.Check_colType in (1,4) "
	_" and m.LocResultMain_departDr!=0"
	//_"  AND qd.QMSchemDetail_parRef=m.LocResultMain_schemDr" 
	if yearmonth'="" {
		s sqlStr=sqlStr_" and m.LocResultMain_period like '"_yearmonth_"'"
	}
	if dept'="" {s sqlStr=sqlStr_" and m.LocResultMain_departDr = "_dept_" "}
	if ward'="" {s sqlStr=sqlStr_" and m.LocResultMain_wardDr = "_ward_" "}
	if checkdr'="" {s sqlStr=sqlStr_" and c.Check_rowid = "_checkdr_" "}
	if scheme'="" {s sqlStr=sqlStr_" and m.LocResultMain_schemDr = "_scheme_" "}	
	if type'="" {
		s sqlStr=sqlStr_" AND m.LocResultMain_schemDr->QMSchem_periodType='"_type_"' "  //20160518 cyl 修改，去掉表dhc_qm_data.QMSchemDetail的约束条件。
		
	}
	;s sqlStr=sqlStr_" and m.LocResultMain_schemDr in (11,13,15) "
	s sqlStr=sqlStr_" order by m.LocResultMain_period,m.LocResultMain_schemDr,m.LocResultMain_departDr"	
	;s ^chuSql=sqlStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	;s count=0
	

	//定义要进行判断的schemid，jxpat，period，deptid，wardid

	s periodr=period
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="parref^schemedr^schemename^desc^warddr^period^jxpatdr^adm^pcode^pname^indocname^operdocname^auditstate^audituser^auditdate^occurDate"  //2016-9-20

	s schemPerJxpatJson=""
	s schemPerJxpatList=""
	
	s checkRowidList=""
	s checkidStr=""
	
	s checksjson =""
	s checkRowidjson=""
	
	s deptList=""
	s deptJson=""
	s deptStr =""

	s checkCou=0
	While(result.Next())
	{
		s delRowid= result.Data("delRowid")
		s parref= result.Data("LocResultMain_rowid")
		
		s schemedr=result.Data("LocResultMain_schemDr")
		s schemename=result.Data("QMSchem_name")
		s departDr= result.Data("LocResultMain_departDr")  //科室
		s Desc= result.Data("DEP_Desc")
	
		s wardDr= result.Data("WARD_Desc")
		s wardId=result.Data("wardId")
		s period= result.Data("LocResultMain_period")
		s JXPatDrRowid= result.Data("LocResultdetail_JXPatDr")
		s JXPatDr= JXPatDrRowid
		s checkDr= result.Data("LocResultdetail_checkDr")
		//s code= result.Data("Check_code")
		s checkname= result.Data("Check_name")
		
		s Adm= result.Data("JXPat_Adm")
		i Adm'="" {s flag="true"}
		s pcode= result.Data("pcode")
		s pname= result.Data("pname")
		s IndocName= result.Data("JXPat_IndocName")
		s operdocname= result.Data("JXPat_operdocname")
		s savedate= result.Data("LocResultdetail_saveDate")
		s auditdate=result.Data("LocResultMain_auditDate")
		if (auditdate'=""){
			s auditdate=##class(websys.Conversions).DateLogicalToHtml(auditdate)
		}else{
			s auditdate=auditdate
		}
		
		s audituser=result.Data("audituser")
		s auditstate=result.Data("LocResultMain_auditState")
		s occurDate=result.Data("occurDate") //2016-9-20
		if (auditstate=1){
			s auditstate="审核"
		}elseif ( auditstate=2){
			s auditstate="取消审核"
		}else{
			s auditstate="未审核"
		}
		
		if savedate'="" {s savedate=##class(websys.Conversions).DateLogicalToHtml(savedate)}
		s saveuserdr= result.Data("SSUSR_Name")
		s actvalue=result.Data("LocResultdetail_actValue")
		//2016-04-28 cyl 修改
		if (actvalue="Y"){
			 s actvalue="是" 
		}elseif(actvalue="N"){
			s actvalue="否"
		}elseif(actvalue=$char(0)){
			 s actvalue="空"
		}elseif($ISVALIDNUM(actvalue)=1){
			s actvalue=$fn(actvalue,"",2)
		}else{
			s actvalue=actvalue
		}
		
		
		//来判断当前的cheksjon中是否已经有改检查点，没有则添加
		//checkidStr用来拼显示数据的json
		s checkidStr="check_"_checkDr
		s checkStr =checkidStr_"||"_checkname //用来确定检查点的json
		s checksList = $LISTFROMSTRING(checksjson,"^")
		s checkfind = $LISTFIND(checksList,checkStr)
		if (checkfind=0) s checksjson=checksjson_"^"_checkStr
		
		
		s checkRowidList = $LISTFROMSTRING(checkRowidjson,"^")
		s checkRowidfind = $LISTFIND(checkRowidList,checkidStr)
		if (checkRowidfind=0)  do
		.s checkRowidjson=checkRowidjson_"^"_checkidStr
		.s checkRowidList = $LISTFROMSTRING(checkRowidjson,"^")
		
		/*
		将jxpat放在一个list里面，schemPerJxpatStr用shem_period_jxpat
		然后判断在list中是否存在，如果存在，则要拼检查点，将拼接的值放在一个global里面^check(jxpat)
		如果不存在，那么就插入。
		=========临时global含义=============
		===^TEMPPat(schemPerJxpatStr)病人信息
		===^TEMPCheckTitle(schemPerJxpatStr) checkjsonTitle
		===^TEMPCheck(schemPerJxpatStr)检查点数据
		*/
		if (JXPatDrRowid'=0)&&(JXPatDrRowid'=""){
			//=======================start======有病人信息的================================================//
			s schemPerJxpatStr =  schemedr_"_"_period_"_"_JXPatDrRowid
			s schemPerJxpatList = $LISTFROMSTRING(schemPerJxpatJson,"^")
			/*2016-01-25
			*发现新问题：当获取病人信息之前，已经加载了可是检查项
			*解决：检查点list已经存在，要将已经存在的chek填充^
			*1、新的检查点，要在chek后面添加。
			*2、已经存在的要进行替换
			*/
			//checkidStr在checkRowidList的什么位置上
			s checkIndex = $LISTFIND(checkRowidList,checkidStr) //检查点在什么位置上
			s checkLen = $LISTLENGTH(checkRowidList)
			s isReplace=0 //是否要位置值替换
			s str=""
			for i=1:1:(checkLen-2)  do
			.s str=str_"^"
			
			if (checkIndex'=checkLen) do	
			.s isReplace=1
			
			if (schemPerJxpatList="") do
			.s schemPerJxpatJson=schemPerJxpatStr
			.s ^TEMPPat(schemPerJxpatStr)=parref_"^"_schemedr_"^"_schemename_"^"_Desc_"^"_wardDr_"^"_period_"^"_JXPatDr_"^"_Adm_"^"_pcode_"^"_pname_"^"_IndocName_"^"_operdocname_"^"_auditstate_"^"_audituser_"^"_auditdate_"^"_occurDate
			.s schemPerJxpatList = $LISTFROMSTRING(schemPerJxpatJson,"^")
			.s ^TEMPCheck(schemPerJxpatStr)=str
			s jxpatfind = $LISTFIND(schemPerJxpatList,schemPerJxpatStr)
		
			if (jxpatfind=0) do 
			.s schemPerJxpatJson=schemPerJxpatJson_"^"_schemPerJxpatStr
			.;s ^TEMPCheckTitle(schemPerJxpatStr)="^"_checkidStr
			.s schemPerJxpatList = $LISTFROMSTRING(schemPerJxpatJson,"^")
			.if (isReplace=1) do
			..s ^TEMPCheck(schemPerJxpatStr)=str
			..s $PIECE(^TEMPCheck(schemPerJxpatStr),"^",checkIndex)= actvalue_"*"_delRowid
			.else  do
			..s ^TEMPCheck(schemPerJxpatStr)=str_"^"_actvalue_"*"_delRowid
			.s ^TEMPPat(schemPerJxpatStr)=parref_"^"_schemedr_"^"_schemename_"^"_Desc_"^"_wardDr_"^"_period_"^"_JXPatDr_"^"_Adm_"^"_pcode_"^"_pname_"^"_IndocName_"^"_operdocname_"^"_auditstate_"^"_audituser_"^"_auditdate_"^"_occurDate
			else  do
			.;如果记录找到，拼global
			.;s ^TEMPCheckTitle(schemPerJxpatStr)=$GET(^TEMPCheckTitle(schemPerJxpatStr))_"^check_"_checkDr
			.if (isReplace=1) do
			..s $PIECE(^TEMPCheck(schemPerJxpatStr),"^",checkIndex)= actvalue_"*"_delRowid
			..s ^TEMPCheck(schemPerJxpatStr)=$GET(^TEMPCheck(schemPerJxpatStr))
			.else  do
			..s ^TEMPCheck(schemPerJxpatStr)=$GET(^TEMPCheck(schemPerJxpatStr))_"^"_actvalue_"*"_delRowid
			
			
			s checkCou=$LISTLENGTH(checkRowidList)
			//=======================end======有病人信息的================================================//
		
		}else{
			//=======================start======无病人信息的====科室检查项目==========================================//
		   /*科室检查项目思路：
		    * 1、科室检查项目中，没有管床医师，所以当管床医师pcode为空的时候，则要对科室id进行处理
		    * 2、建一个科室list depList用来存科室检查项目的rowid
		    * 3、如果depList没有当前的科室id，则重新生成一个global，生成一条记录
		    * 4、最后循环deplist生成json
			*/
		
			/*
			*如果是同一个可是，不同的检查点，拼一条
			*/
		//	s depGlobalflag=departDr_"||"_schemedr
			s depGlobalflag=departDr_"||"_wardId_"||"_schemedr  //2015-7-10 加入病区 cyl
			s ^TEMPDept(depGlobalflag)=parref_"^"_schemedr_"^"_schemename_"^"_Desc_"^"_wardDr_"^"_period_"^"_JXPatDr_"^"_Adm_"^"_pcode_"^"_pname_"^"_IndocName_"^"_operdocname_"^"_auditstate_"^"_audituser_"^"_auditdate_"^"_occurDate
			s str=""
		    
			/*
			*一个检查点可能是病人的也可能是科室的。
			*1、科室的检查点和病人的检查点没有重复的
			 2、科室的检查点和病人的检查点有重复的
			 	有重复的肿么办？
			 	（1）找到检查点的位置，然后for循环补^
			*/
			//checkidStr在checkRowidList的什么位置上
			
			s checkIndex = $LISTFIND(checkRowidList,checkidStr) //检查点在什么位置上
			s beforeIndex = checkIndex //要把上个位置定下来
			s checkLen = $LISTLENGTH(checkRowidList)
			s isReplace=0
			if (checkCou'=0){
				for i=1:1:(checkCou-1) do
				.s str=str_"^"
			}else{
				for i=1:1:(checkLen-2)  do
				.s str=str_"^"
			}		
			if (checkIndex'=checkLen) do	
			.s isReplace=1
			s deptList=$LISTFROMSTRING(deptStr,",")
			if (deptList="") do
			.s deptStr=departDr_"||"_wardId_"||"_schemedr
			.s deptList=$LISTFROMSTRING(deptStr,",")
			.s ^TEMPDeptCheck(depGlobalflag)=str
			s depFind = $LISTFIND(deptList,depGlobalflag)
			if (depFind=0) do 
			.;没有找到
			.s deptStr=deptStr_","_departDr_"||"_wardId_"||"_schemedr
			.s deptList=$LISTFROMSTRING(deptStr,",")
			.if (isReplace=1) do
			..s ^TEMPDeptCheck(depGlobalflag)=str
			..s $PIECE(^TEMPDeptCheck(depGlobalflag),"^",checkIndex)= actvalue_"*"_delRowid
			.else  do
			..s ^TEMPDeptCheck(depGlobalflag)=str_"^"_actvalue_"*"_delRowid
			else  do
			.;存在
			.if (isReplace=1) do
			..;要替换这个位置的值
			..s $PIECE(^TEMPDeptCheck(depGlobalflag),"^",checkIndex)= actvalue_"*"_delRowid
			..s ^TEMPDeptCheck(depGlobalflag)=$GET(^TEMPDeptCheck(depGlobalflag))
			.else  do
			..s ^TEMPDeptCheck(depGlobalflag)=$GET(^TEMPDeptCheck(depGlobalflag))_"^"_actvalue_"*"_delRowid
			
			
		
		}
		
	
	
		//=======================end======无病人信息的================================================//
	}
	//	最后循环list，就global的值放入json中，处理list和global，json
	
    s resultCount=0
    s totalCount=0
    s end=start+limit-1
    SET ptr=0
    s schemLen =$LISTLENGTH(schemPerJxpatList)
    ;w "value="_schemPerJxpatList,!
    WHILE $LISTNEXT(schemPerJxpatList,ptr,value) {
	
		s temp = $GET(^TEMPPat(value))
		s rowIn = temp_$GET(^TEMPCheck(value))
		if (totalCount>=start)&&(totalCount<=end){
			d json.InsertRowData(rowIn)
			s resultCount=resultCount+1	
		}
		
		s totalCount=totalCount+1
		k ^TEMPCheckTitle(value)
		k ^TEMPPat(value)
		k ^TEMPCheck(value)
		
		

    }
   
    SET ptr2=0
      s depLen =$LISTLENGTH(schemPerJxpatList)
    WHILE $LISTNEXT(deptList,ptr2,value) {
	 
		if (value'=""){
		s temp2 = $GET(^TEMPDept(value))
		s rowIn2 = temp2_$GET(^TEMPDeptCheck(value))
		if (totalCount>=start)&&(totalCount<=end){
			d json.InsertRowData(rowIn2)
			s resultCount=resultCount+1	
		}
		
		s totalCount=totalCount+1
		;d json.InsertRowData(rowIn)
		k ^TEMPDeptCheck(value)
		k ^TEMPDept(value)
		
		}
    }
  
    s jsonTitle=jsonTitle_$REPLACE($LISTTOSTRING(checkRowidList),",","^") //确定最终json的title
	d result.Close()
	s resultString = json.getJsonDataNew(jsonTitle,resultCount,totalCount,checksjson)	
	k json
	
    q resultString
}

/// Creator: wang ying
/// CreatDate:2016-03-21
/// Description: 调用统计组的接口统计24小时重返数量
/// Table: 
/// Input:startDate:开始时间,endDate:结束时间
/// Output: 
/// Return: 
/// others:w ##class(dhc.qm.udata.uQualityInfoManagement).getTimeCFNum("2016","01","Q") 
ClassMethod getTimeCFNum(year, period, periodType) As %String
{
	n ( year,period,periodType)
	
	 if ((year'="")&(period'="")){
		s period=year_period
    }
	q:period="" "Noperiod"
	q:periodType="" "NOperiodType"
	
	s periodStr=##class(dhc.qm.udata.uComm).getTime(period,periodType)
	q:periodStr=""
	
	s startDate=$p(periodStr,"^",1)
	s endDate=$p(periodStr,"^",2)
	
	q:startDate="" "NostartDate"
	q:endDate="" "NoendDate"
	;W startDate_"^"_endDate,!
	s flag=0
	s flag=$$GetLocWardDYZDTS^DHCWLBuildKPIDataYGYY004(startDate,endDate)
	q:flag'=1
	q:'$d(^TEMPDHCWLKPIDATA("S",$j))
	s locDr=0
	f  s locDr=$o(^TEMPDHCWLKPIDATA("S",$j,locDr))  q:locDr=""  d
	.s deptGDr=$p($g(^CTLOC(locDr)),"^",19)
	.q:deptGDr=""
	.s num=$g(^TEMPDHCWLKPIDATA("S",$j,locDr,"TimeCFNum"))
	.s ^TEMPDHCJXQM($j,"TimeCFNum",deptGDr)=$g(^TEMPDHCJXQM($j,"TimeCFNum",deptGDr))+num
	
	s SQLCODE=0
	s deptGroup=0
	f  s deptGroup=$o(^TEMPDHCJXQM($j,"TimeCFNum",deptGroup)) q:deptGroup=""  d
	.s CFNum=$g(^TEMPDHCJXQM($j,"TimeCFNum",deptGroup))
	.s qmschemDr=0
	.&sql(SELECT QMSchem_RowID into :qmschemDr FROM dhc_qm_data.QMSchem WHERE QMSchem_Code='0060402')
	.s mainData=period_"^^"_deptGroup_"^0^"_qmschemDr_"^1^^"_CFNum_"^"
    .s SQLCODE=##class(dhc.qm.udata.uPatInfo).InsertLocUnitResult(mainData,0)
	.i SQLCODE'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("InsertgetTimeCFNum",mainData_"^0",SQLCODE,"")
	
	k ^TEMPDHCWLKPIDATA("S",$j),^TEMPDHCJXQM($j,"TimeCFNum")
	
	q SQLCODE
}

/// Creator:     初雅莉
/// CreateDate:  2015-12-24
/// Description: 质量管理信息维护---查询             
/// Table:       dhc_qm_data.LocResultMain，
/// Input:       
/// Return:     json
/// Others:w ##class(dhc.qm.udata.uQualityInfoManagement).GetChecks("", "",0,10,"2016","Q","01","","","","","3901")
ClassMethod GetChecks(sortField, sortDir, start, limit, year, type, period, dept, ward, checkdr, scheme, userid) As %String
{
	n (sortField, sortDir, start, limit,year,type,period,dept,ward,checkdr,scheme,userid)
	//此变量用于判断字符传中是否有病人信息若有，则返回字符传中包含病人信息
	
	s sqlStr=""
	s yearmonth=""
    if ((year'="")&(period'="")){
		s yearmonth=year_period
    }
    ;s ^chuPa=sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_year_"^"_type_"^"_period_"^"_dept_"^"_ward_"^"_checkdr_"^"_scheme_"^"_userid
    set schemedrs=""
	s sqlStr="SELECT DISTINCT LocResultdetail_checkDr , LocResultdetail_checkDr->Check_name AS checkName "
		_" FROM dhc_qm_data.LocResultdetail "
		_" WHERE  LocResultdetail_checkDr->Check_colType in (1,4)  "
		_" AND LocResultdetail_parRef->LocResultMain_departDr!=0  "

	if yearmonth'="" {
		s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_period='"_yearmonth_"'"
	}
	if dept'="" {s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_departDr = "_dept_" "}
	if ward'="" {s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_wardDr = "_ward_" "}
	if checkdr'="" {s sqlStr=sqlStr_" and  LocResultdetail_checkDr = "_checkdr_" "}
	if scheme'="" {s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_schemDr = "_scheme_" "}	
	if type'="" {
		s sqlStr=sqlStr_" 	AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType='"_type_"' "  //20160518 cyl 修改，去掉表dhc_qm_data.QMSchemDetail的约束条件。
		
	}
	s sqlStr=sqlStr_" order by LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr"	
	;s ^chuSql = sqlStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s checksjson =""
	s resultString=""

	While(result.Next())
	{
		
		
		s checkDr= result.Data("LocResultdetail_checkDr")
		s checkname= result.Data("checkName")
		
		//来判断当前的cheksjon中是否已经有改检查点，没有则添加
		//checkidStr用来拼显示数据的json
		s checkidStr="check_"_checkDr
		s checkStr =checkidStr_"||"_checkname //用来确定检查点的json
		s checksList = $LISTFROMSTRING(checksjson,"^")
		s checkfind = $LISTFIND(checksList,checkStr)
		if (checkfind=0) s checksjson=checksjson_"^"_checkStr
		
	
	}
	
 
	s resultString=checksjson
    q resultString
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uQualityInfo90BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
