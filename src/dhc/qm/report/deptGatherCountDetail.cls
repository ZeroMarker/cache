Class dhc.qm.report.deptGatherCountDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     初雅莉
/// CreateDate:  2016-03-02
/// Description: 科室汇总统计明细
/// Table:      dhc_qm_data.LocResultdetail lrd , dhc_qm_data.LocResultMain lrm  
/// Input:      year（年度）， type（期间类型）, period（期间）, check（检查项目id）, dept（部门id）
/// Return:     num
/// d ##class(%ResultSet).RunQuery("dhc.qm.report.deptGatherCountDetail","GetDetailInfo","2015","Q","2","6","")
Query GetDetailInfo(year As %String, type As %String, period As %String, schemId As %String, deptId As %String) As %Query(ROWSPEC = "period:%String,scheme:%String,deptName:%String,ward:%String,JXPatDr:%String,patient:%String,code:%String,checkname:%String,isvalue:%String,checkDr:%String,depId:%String") [ SqlProc ]
{
}

ClassMethod GetDetailInfoExecute(ByRef qHandle As %Binary, year As %String, type As %String, period As %String, schemId As %String, deptId As %String) As %Status
{
	
	n (qHandle,year,type,period,schemId,deptId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;w dept,!
    Set ind=1
	 i period>10   d
    .s period=year_period
	e  d
	.s period=year_0_period
	
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemId)
	
	//得到检查项的所有检查点
	s getCheckBySchemSql="SELECT QMSchemDetail_rowid, QMSchemDetail_parRef, QMSchemDetail_CheckDr as checkId FROM dhc_qm_data.QMSchemDetail "
		 	_" WHERE QMSchemDetail_parRef->QMSchem_Code = '"_schemId_"' "
	
	s getCheckBySchem=##class(%Library.ResultSet).%New()
	d getCheckBySchem.Prepare(getCheckBySchemSql)
	d getCheckBySchem.Execute()
	s useParamStr=period_"^"_period_"^"_type_"^"_schemId_"^"_deptId
	//获得不合格例数的过滤条件
	s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(getCheckBySchem,"checkId","",dataType,useParamStr)
	s filedSql=$p(fieldStr,"^",2)
	//获得不合格的信息
	s getMainSql = "select DISTINCT lrd.LocResultdetail_parRef as parRef,lrd.LocResultdetail_JXPatDr AS jxpat"
				_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail lrd ,dhc_qm_data.JXPat p ,dhc_qm_data.CheckInfo c "
				_" WHERE lm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
				;_"AND (lrd.LocResultdetail_JXPatDr=p.JXPat_rowid or lrd.LocResultdetail_JXPatDr=0) AND lrd.LocResultdetail_checkDr=c.Check_rowid "
   				_" and LocResultMain_period = '"_period_"'  "
   				_" and LocResultMain_schemDr->QMSchem_periodType = '"_type_"' " 
   				_" and LocResultMain_schemDr->QMSchem_Code = '"_schemId_"' "
    i deptId'=""  s getMainSql = getMainSql_" and LocResultMain_departDr = '"_deptId_"' "
  	s getMainSql = getMainSql_filedSql
  	s getMain=##class(%Library.ResultSet).%New()
	d getMain.Prepare(getMainSql)
	d getMain.Execute()
	;s ^chuField2=getMainSql
  	while(getMain.Next()){
	  	s parRef=getMain.Data("parRef")
	  	s jxpat=getMain.Data("jxpat")
	  	&sql(DECLARE DetailCursor CURSOR FOR 
	  		SELECT top 20 LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name ,LocResultdetail_parRef->LocResultMain_departDr,
			LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc,LocResultdetail_parRef->LocResultMain_period,
			LocResultdetail_parRef->LocResultMain_wardDr ,LocResultdetail_JXPatDr->JXPat_name,LocResultdetail_JXPatDr->JXPat_code ,
			LocResultdetail_JXPatDr,LocResultdetail_checkDr ,LocResultdetail_checkDr->Check_name, LocResultdetail_actValue 
			into:scheme,:depId,:deptName,:period,:wardId,:patient,:code,:JXPatDr,:checkDr,:checkname,:isvalue
			 FROM dhc_qm_data.LocResultdetail 
			 WHERE LocResultdetail_parRef=:parRef and LocResultdetail_JXPatDr=:jxpat )
  		 &sql(OPEN DetailCursor)
	  	 FOR {
		  	&sql(FETCH DetailCursor)
	        QUIT:SQLCODE  
			if (wardId'="")&&(wardId'=0)&&($Data(^PAWARD(wardId))'=0){
				s ward=$P(^PAWARD(wardId),"^",2)
			}else{
				s ward=""
			}
			 //对isvalue数字的进行处理，保留两位小数
			if ($number(isvalue)'=""){
				s isvalue=$fn(isvalue,"",2)
			}
			d detail
		 }
  		 &sql(CLOSE DetailCursor)		
		
  	}
 
  	q $$$OK
detail
    s Data=$lb(period,scheme,deptName,ward,JXPatDr,patient,code,checkname,isvalue,checkDr,depId)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDetailInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailInfoExecute ]
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

ClassMethod GetDetailInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:     初雅莉
/// CreateDate:  2016-06-27
/// Description: 质量管理信息系统---科室检查项目汇总查询  
/// Input:       year（年度）, type（频次）, period,\, dept（科室rowid）, schem（检查项code） 
/// Return:      json格式
///          
/// Others:  d ##class(%ResultSet).RunQuery("dhc.qm.report.deptGatherCountDetail","GetDetailInfoNew","2016","Q","2","","0060301")
Query GetDetailInfoNew(year As %String, type As %String, period As %String, deptId As %String, schemId As %String) As %Query(ROWSPEC = "schemName:%String,schemRowid:%String,deptId:%String,deptName:%String,wardName:%String,checkIdDep:%String,checkNameDep:%String,actValue:%String,pcode:%String,pname:%String,adm:%String,failNum:%Integer,deptCode:%String") [ SqlProc ]
{
}

ClassMethod GetDetailInfoNewExecute(ByRef qHandle As %Binary, year As %String, type As %String, period As %String, deptId As %String, schemId As %String) As %Status
{
	n (qHandle,year,type,period,deptId, schemId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	;s ^chuPa = year_"^"_type_"^"_period_"^schemId="_schemId_"^deptId="_deptId
	q:year="" $$$OK 
    q:type="" $$$OK
    
     i period>10   d
    .s period=year_period
	e  d
	.s period=year_0_period
    
	
	
	//根据科室id 取科室code
	
	s deptCode=deptId
	;i deptId'="" s deptCode=$p(^RBC("DEP",deptId),"^",1)
	
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
				_" WHERE  (LocResultdetail_parRef->LocResultMain_auditState=1 or LocResultdetail_saveStatus=1) " // pad端保存状态为1 201682 " "
				_" and LocResultdetail_parRef->LocResultMain_period ='"_period_"' "
				_" and LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code= '"_schemCode_"' " 
				_" AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType = '"_type_"' " 
				
	
	if deptCode'="" {
		s getUnQSql=getUnQSql_" and LocResultdetail_parRef->LocResultMain_departDr = '"_deptCode_"' "
	}
	s getUnQSql=getUnQSql_filedSql
	
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
		_" WHERE  " //2016-06-16  add cyl 审核状态
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
      
       ; i jxpatDr=524 b
        //科室检查项目取failNum的值，医师检查项要单独计算不合格例数
        /*
        s jxpatUnQSum=0
	    if (jxpatDr'=0){
		    if ($Data(^deptSchemeTemp(deptId,schemRowid))'=0){ //已经计算了不合格的值
				s failNum=$Get(^deptSchemeTemp(deptId,schemRowid))
			}else{
				s jxpatUnQSum =##class(dhc.qm.report.HERPJXQMDocCollect).GetDotUnqualifiedNum(deptId,schemRowid,schemCode,"","",type,period,period,"","","") ;取得不合格病例数	
		    	s ^deptSchemeTemp(deptId,schemRowid)=jxpatUnQSum
		    	s failNum=$Get(^deptSchemeTemp(deptId,schemRowid))
			}
				
	    }else{
			s failNum=deptfailNum
		}
		*/
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

ClassMethod GetDetailInfoNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailInfoNewExecute ]
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

ClassMethod GetDetailInfoNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailInfoNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.qm.report.deptGatherC148DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
