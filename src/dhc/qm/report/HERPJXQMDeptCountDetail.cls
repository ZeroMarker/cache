/// 科室检查项目汇总查询
Class dhc.qm.report.HERPJXQMDeptCountDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     初雅莉
/// CreateDate:  2016-02-19
/// Description: 质量管理信息系统---科室检查项目汇总查询  
/// Input:       year（年度）, frequency（频次）, stDate（开始时间）, endDate（结束时间）, dept（科室rowid）, schem（检查项id） 
/// Return:      json格式
/// Others:  d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDeptCountDetail","DeptCountDetail","2016","Q","2","2","5","10")
Query DeptCountDetail(year As %String, frequency As %String, stDate As %String, endDate As %String, dept As %String, scheme As %String) As %Query(ROWSPEC = "schemName:%String,schemRowid:%String,deptId:%String,deptName:%String,wardName:%String,checkId:%String,checkName:%String,actValue:%String,pcode:%String,pname:%String,adm:%String,failNum:%String") [ SqlProc ]
{
}

ClassMethod DeptCountDetailExecute(ByRef qHandle As %Binary, year As %String, frequency As %String, stDate As %String, endDate As %String, dept As %String, scheme As %String) As %Status
{
	n (qHandle,year,frequency,stDate,endDate, dept, scheme)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	;s ^chuPa = year_"^"_frequency_"^"_stDate_"^"_endDate_"^"_ dept_"^"_scheme
	q:year="" $$$OK 
    q:frequency="" $$$OK
    q:stDate="" $$$OK
    q:endDate="" $$$OK
    
    i stDate<10   s stDate="0"_stDate
    i endDate<10  s endDate="0"_endDate
    s stDate=year_stDate
	s endDate=year_endDate
	
	
	//根据科室id 取科室code
	//绩效与质量科室对应 2016-06-28
	s deptCode=""
	s deptCode=$p(^DHCCJXPAJXUNIT(dept),"^",2)
	
	//检查方案，根据id取code
	s schemCode=""
	&sql(select QMSchem_Code into :schemCode from dhc_qm_data.QMSchem where QMSchem_Rowid=:scheme)
    s sqlStr="SELECT m.LocResultMain_schemDr as schemRowid,m.LocResultMain_schemDr->QMSchem_name as schemName,m.LocResultMain_schemDr->QMSchem_Code as schemCode, "
		_"m.LocResultMain_departDr as deptId,m.LocResultMain_departDr->DEP_Desc as deptName,m.LocResultMain_departDr->DEP_Code as deptCode, "
		_"m.LocResultMain_wardDr,m.LocResultMain_wardDr->WARD_Desc as wardName, "
		_"m.LocResultMain_period,d.LocResultdetail_checkDr as checkId,c.Check_code,c.Check_name as checkName,  "
		_"d.LocResultdetail_actValue as actValue,m.LocResultMain_failNum as failNum, "
		_"d.LocResultdetail_JXPatDr as jxpatDr,d.LocResultdetail_JXPatDr->JXPat_Adm as adm,d.LocResultdetail_JXPatDr->JXPat_code as pcode,d.LocResultdetail_JXPatDr->JXPat_name as pname "
		_" FROM dhc_qm_data.LocResultMain m,dhc_qm_data.LocResultdetail d,dhc_qm_data.CheckInfo c,dhc_qm_data.QMSchemDetail qd "
		_" WHERE m.LocResultMain_rowid=d.LocResultdetail_parRef "
		_" and d.LocResultdetail_checkDr=c.Check_rowid  "
		_"  AND qd.QMSchemDetail_parRef=m.LocResultMain_schemDr "
		;_"AND qd.QMSchemDetail_CheckDr= d.LocResultdetail_checkDr "
	
		;_" and c.Check_colType in (1,4) "
	if (stDate'="")&&(endDate'="") {
		s sqlStr=sqlStr_" and m.LocResultMain_period between '"_stDate_"' and '"_endDate_"' "
	}
	;if dept'="" {s sqlStr=sqlStr_" and m.LocResultMain_departDr = "_dept_" "}
	if deptCode'="" {
	
		s sqlStr=sqlStr_" and m.LocResultMain_departDr->DEP_Code = '"_deptCode_"' "
	}
	;if scheme'="" {s sqlStr=sqlStr_" and qd.QMSchemDetail_parRef = "_scheme_" "}
	if schemCode'="" {s sqlStr=sqlStr_" and qd.QMSchemDetail_parRef->QMSchem_Code = '"_schemCode_"' "}	
	if frequency'="" {s sqlStr=sqlStr_" AND qd.QMSchemDetail_parRef->QMSchem_periodType = '"_frequency_"'"}
	s sqlStr=sqlStr_" and m.LocResultMain_auditState=1 " //2016-06-16  add cyl 审核状态
	s sqlStr=sqlStr_" order by m.LocResultMain_period,m.LocResultMain_schemDr,m.LocResultMain_departDr"	
	
	;s ^chuSql=sqlStr
	s deptCountResult=##class(%Library.ResultSet).%New()
	d deptCountResult.Prepare(sqlStr)
	d deptCountResult.Execute()
    While(deptCountResult.Next()){
        s schemName = deptCountResult.Data("schemName")
        s schemRowid = deptCountResult.Data("schemRowid")
        s schemCode=deptCountResult.Data("schemCode")
        s deptId = deptCountResult.Data("deptId")
        s deptName = deptCountResult.Data("deptName")
       ; s deptCode= deptCountResult.Data("deptCode")
        s wardName = deptCountResult.Data("wardName")
        s checkId = deptCountResult.Data("checkId")
        s checkName = deptCountResult.Data("checkName")
        s actValue = deptCountResult.Data("actValue")
        //对isvalue数字的进行处理，保留两位小数
		if ($number(actValue)'=""){
			s actValue=$fn(actValue,"",2)
		}
        s pcode = deptCountResult.Data("pcode")
        s pname = deptCountResult.Data("pname")
        s adm = deptCountResult.Data("adm")
        s deptfailNum = deptCountResult.Data("failNum")
        s jxpatDr = deptCountResult.Data("jxpatDr")
        //科室检查项目取failNum的值，医师检查项要单独计算不合格例数
        s jxpatUnQSum=0
	    if (jxpatDr'=0){
		    if ($Data(^deptSchemeTemp(deptId,schemRowid))'=0){ //已经计算了不合格的值
				s failNum=$Get(^deptSchemeTemp(deptId,schemRowid))
			}else{
				s jxpatUnQSum =##class(dhc.qm.report.HERPJXQMDocCollect).GetDotUnqualifiedNum(deptId,schemRowid,schemCode,"","",frequency,stDate,endDate,"","","") ;取得不合格病例数	
		    	s ^deptSchemeTemp(deptId,schemRowid)=jxpatUnQSum
		    	s failNum=$Get(^deptSchemeTemp(deptId,schemRowid))
			}
				
	    }else{
			s failNum=deptfailNum
		}
		
		d aa   	  
	}
 	k ^deptSchemeTemp
  	q $$$OK
aa
    s Data=$lb(schemName,schemRowid,deptId,deptName,wardName,checkId,checkName,actValue,pcode,pname,adm,failNum)		
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod DeptCountDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptCountDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptCountDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptCountDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.qm.report.HERPJXQMDept73DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
