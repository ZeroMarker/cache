/// 绩效考核系统-科室考核汇总报表--质控明细
Class dhc.pa.report.JXLocSumGroReportDetaill Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     初雅莉
/// CreateDate:  2016-08-23
/// Description: 绩效考核科室汇总报表链接--质量管理信息系统---科室检查项目汇总查询  
/// Input:       year（cycleDr）, type（频次）, period,\, dept（科室组id）, schem（检查项code） 
/// Return:      json格式
/// Others:  d ##class(%ResultSet).RunQuery("dhc.pa.report.JXLocSumGroReportDetaill","GetPAQMDetailInfo","6","Q","2","2","0060203","1||5")
Query GetPAQMDetailInfo(year As %String, type As %String, period As %String, deptId As %String, schemId As %String, schemDr As %String) As %Query(ROWSPEC = "schemName:%String,schemRowid:%String,deptId:%String,deptName:%String,wardName:%String,checkIdDep:%String,checkNameDep:%String,actValue:%String,pcode:%String,pname:%String,adm:%String,failNum:%Integer,deptCode:%String") [ SqlProc ]
{
}

ClassMethod GetPAQMDetailInfoExecute(ByRef qHandle As %Binary, year As %String, type As %String, period As %String, deptId As %String, schemId As %String, schemDr As %String) As %Status
{
	n (qHandle,year,type,period,deptId, schemId,schemDr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	;s ^chuPa = year_"^"_type_"^"_period_"^schemId="_schemId_"^deptId="_deptId_"^schemDr="_schemDr
	q:year="" $$$OK 
    q:type="" $$$OK
    
    
    
    //根据cycleDr 获得year
    s year=$p(^DHCCJXPACYCLE(year),"^",1)
     i period>10   d
    .s period=year_period
	e  d
	.s period=year_0_period
    
	
	
	//根据科室组id 取科室code
	
	;s deptCode=deptId
	s depts=$p(^DHCCJXPAJXGROUP(deptId),"^",3)
	s deptList=$LISTFROMSTRING(depts,"-")
	SET ptr=0,count=0
	s deptCodeStr=""
   	WHILE $LISTNEXT(deptList,ptr,value) {
  		s deptCode=$p(^DHCCJXPAJXUNIT(value),"^",2)
  		s deptCodeStr=deptCodeStr_",'"_deptCode_"'"
   }
  
	s deptCodeStr=$e(deptCodeStr,2,*)
	

	
	;s ^TEMPdeptStr=schemDr_"&"_schemId_"&"_deptCodeStr

	
	//检查方案，根据id取code
	s schemCode=schemId
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemId)
	
	//得到检查项的所有检查点
	s getCheckBySchemSql="SELECT QMSchemDetail_rowid, QMSchemDetail_parRef, QMSchemDetail_CheckDr as checkId FROM dhc_qm_data.QMSchemDetail "
		 	_" WHERE QMSchemDetail_parRef->QMSchem_Code = '"_schemId_"' "
	
	s getCheckBySchem=##class(%Library.ResultSet).%New()
	d getCheckBySchem.Prepare(getCheckBySchemSql)
	d getCheckBySchem.Execute()
	s useParamStr=period_"^"_period_"^"_type_"^"_schemId_"^"_deptId
	//合理用血方案进行特殊处理
	if (schemCode="0060404"){
		s filedSql=" and LocResultdetail_checkDr->Check_code='060' "
		_" and LocResultdetail_actValue!='' and LocResultdetail_actValue is not null "
	}else{
		//获得不合格例数的过滤条件
		s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(getCheckBySchem,"checkId","",dataType,useParamStr)
		s filedSql=$p(fieldStr,"^",2)
		//将filedSql中的lrd.替换为空
		s filedSql=$replace(filedSql,"lrd.","")
	}
	/*只查询出不合格的记录  实现
	*1、通过拼接特殊检查点的过滤条件，得到科室，jxpatDr，period，schemCode，type
	*2、根据上面的条件，在
	*/	

	s getUnQSql="SELECT  LocResultdetail_parRef->LocResultMain_departDr as deptId,  LocResultdetail_parRef,LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc as deptName,"
				_" LocResultdetail_parRef->LocResultMain_departDr->DEP_Code as deptCode, LocResultdetail_parRef->LocResultMain_wardDr as wardDr ,LocResultdetail_JXPatDr as jxpatDr "
				_" FROM dhc_qm_data.LocResultdetail "
				_" WHERE  LocResultdetail_parRef->LocResultMain_auditState=1  "
				_" and LocResultdetail_parRef->LocResultMain_period ='"_period_"' "
				_" and LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code= '"_schemCode_"' " 
				_" AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType = '"_type_"' " 
				;_" and LocResultdetail_parRef->LocResultMain_departDr->DEP_Code = '"_deptCode_"' "
				_" and LocResultdetail_parRef->LocResultMain_departDr->DEP_Code in("_deptCodeStr_") "
	
	s getUnQSql=getUnQSql_filedSql
	
	;s ^chuSql=getUnQSql
	s getUnQSqlResult=##class(%Library.ResultSet).%New()
	d getUnQSqlResult.Prepare(getUnQSql)
	d getUnQSqlResult.Execute()
    While(getUnQSqlResult.Next()){
    	 s parRef = getUnQSqlResult.Data("LocResultdetail_parRef")
    	 s jxpatDr = getUnQSqlResult.Data("jxpatDr")
    	 s wardDr = getUnQSqlResult.Data("wardDr")
    	 
    	 s sqlStr="SELECT LocResultdetail_parRef->LocResultMain_schemDr as schemRowid,LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name as schemName, "
		_" LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code as schemCode, LocResultdetail_parRef->LocResultMain_departDr as deptId, "
		_" LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc as deptName,LocResultdetail_parRef->LocResultMain_departDr->DEP_Code as deptCode,  "
		_" LocResultdetail_parRef->LocResultMain_wardDr,LocResultdetail_parRef->LocResultMain_wardDr->WARD_Desc as wardName, LocResultdetail_parRef->LocResultMain_period, "
		_" LocResultdetail_checkDr as checkId,LocResultdetail_checkDr->Check_code,LocResultdetail_checkDr->Check_name as checkName,   "
		_" LocResultdetail_actValue as actValue,LocResultdetail_parRef->LocResultMain_failNum as failNum, LocResultdetail_JXPatDr as jxpatDr, "
		_" LocResultdetail_JXPatDr->JXPat_Adm as adm,LocResultdetail_JXPatDr->JXPat_code as pcode, "
		_" LocResultdetail_JXPatDr->JXPat_name as pname  "
		_" FROM dhc_qm_data.LocResultdetail "
		_" WHERE  " 
		_" LocResultdetail_parRef='"_parRef_"' "
		

	if (jxpatDr'=0)&&(jxpatDr'="") {
		s sqlStr=sqlStr_" and LocResultdetail_JXPatDr = '"_jxpatDr_"' "
	}
	
	if (wardDr'="")&&(wardDr'=0) {s sqlStr=sqlStr_" and LocResultdetail_parRef->LocResultMain_wardDr= '"_wardDr_"' "}	
	s sqlStr=sqlStr_" order by LocResultdetail_parRef->LocResultMain_period,LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_departDr"	

	;w sqlStr,!
	;s ^chuSql=sqlStr
	s deptCountResult=##class(%Library.ResultSet).%New()
	d deptCountResult.Prepare(sqlStr)
	d deptCountResult.Execute()
    While(deptCountResult.Next()){
	    s actValue="",checkName=""
        s schemName = deptCountResult.Data("schemName")
        s schemRowid = deptCountResult.Data("schemRowid")
        s schemCode=deptCountResult.Data("schemCode")
        s deptId = deptCountResult.Data("deptId")
        s deptName = deptCountResult.Data("deptName")
        s deptCode= deptCountResult.Data("deptCode")
        s wardName = deptCountResult.Data("wardName")
        s checkIdDep = deptCountResult.Data("checkId")
        s checkNameDep = deptCountResult.Data("checkName")
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
      
      
		d aa   	  
	}
    	 
    	 
    	 
    	 
    	 
    }	
		
		
	
 	k ^deptSchemeTemp
  	q $$$OK
aa
   
    s Data=$lb(schemName,schemRowid,deptId,deptName,wardName,checkIdDep,checkNameDep,actValue,pcode,pname,adm,failNum,deptCode)		
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPAQMDetailInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAQMDetailInfoExecute ]
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

ClassMethod GetPAQMDetailInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAQMDetailInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.pa.report.JXLocSumGroA51BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
