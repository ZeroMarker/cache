Import SQLUser

Class dhc.qm.report.HERPJXQMDocCheckSchemCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr=n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr=l
	...i PeriodDr=1 s PeriodName="上半年"
	...i PeriodDr=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr=0
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
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

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wjt
/// CreatDate:2015-8-5
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocCheckSchemCollect","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocCheckSchemCollect","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT Cycle_rowid,Cycle_code FROM dhc_qm_data.Cycle WHERE Cycle_active='Y'
}

/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocCheckSchemCollect","GetLocType")
Query GetLocType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT DEP_RowId,DEP_Desc FROM RBC_DepartmentGroup where DEP_RowId>0
}

Query GetSchem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT QMSchem_RowID,QMSchem_Code,QMSchem_name FROM dhc_qm_data.QMSchem WHERE QMSchem_RowID>0
}

/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocCheckSchemCollect","GetDocCheckSchemCount","2015","Q","2","2","11","43","JXPat_IndocName","")
Query GetDocCheckSchemCount(year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String, docType As %String, code As %String) As %Query(ROWSPEC = "patdr:%String,periods:%String,desc:%String,lrward:%String,code:%String,patname:%String,schemname:%String,doctyname:%String,failNum:%String,active:%String,checkName:%String,picLink:%String,schemeId:%String,deptId:%String") [ SqlProc ]
{
}

ClassMethod GetDocCheckSchemCountExecute(ByRef qHandle As %Binary, year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String, docType As %String, code As %String) As %Status
{
	n (qHandle,year,frequency,stDate,endDate,schemDr,locdr,docType,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:year="" $$$OK
    q:frequency="" $$$OK
    q:stDate="" $$$OK
    q:endDate="" $$$OK
    q:docType="" $$$OK
   
  	 k ^deptSchemeTemp	
     i stDate<10   s stDate="0"_stDate
     i endDate<10  s endDate="0"_endDate
     s stDate1=year_stDate
	 s endDate1=year_endDate
	//根据传入的医生类别不同，组合查找不同字段的sql
	set docTypeCode=""
	i docType="JXPat_IndocName"  s docTypeCode="JXPat_Indoccode"
	i docType="JXPat_operdocname"  s docTypeCode="JXPat_operatorcode"
	i docType="JXPat_consultdoc"  s docTypeCode="JXPat_consultdoccode"
	
    s sqlStr=" SELECT DISTINCT lrd.LocResultdetail_JXPatDr as patdr,lrm.LocResultMain_period as period,lrm.LocResultMain_departDr as deptId,lrm.LocResultMain_departDr->DEP_Desc as depname, "
    		  _" lrm.LocResultMain_wardDr  as lrward, lrd.LocResultdetail_JXPatDr->JXPat_code as code, "
              _" lrd.LocResultdetail_JXPatDr->JXPat_name as patname, lrm.LocResultMain_schemDr as schemeId,lrm.LocResultMain_schemDr->QMSchem_code as schemeCode, lrm.LocResultMain_schemDr->QMSchem_name as sname, " 
              _" lrd.LocResultdetail_JXPatDr->"_docType_" as docTyname,lrd.LocResultdetail_JXPatDr->JXPat_Indoccode as docCode ,  lrd.LocResultdetail_parRef->LocResultMain_failNum  " 
              _" AS failNum , lrd.LocResultdetail_actValue AS active,lrd.LocResultdetail_checkDr->Check_name AS checkName ,lrd.LocResultdetail_PicLink as picLink "
              _" FROM dhc_qm_data.LocResultdetail lrd , dhc_qm_data.LocResultMain lrm "
              _" WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
   			  _" and lrd.LocResultdetail_parRef->LocResultMain_period between '"_stDate1_"' AND '"_endDate1_"'  "
   			  ;_"  AND lrd.LocResultdetail_JXPatDr->JXPat_IndocName='李康' "
     i locdr'=""    s sqlStr=sqlStr_" AND lrm.LocResultMain_departDr ='"_locdr_"' "
     i schemDr'=""  s sqlStr=sqlStr_" AND lrm.LocResultMain_schemDr='"_schemDr_"' "
     s sqlStr=sqlStr_" AND lrm.LocResultMain_schemDr->QMSchem_periodType='"_frequency_"'"
     s sqlStr=sqlStr_" ORDER BY lrm.LocResultMain_schemDr->QMSchem_name,lrd.LocResultdetail_checkDr->Check_name,lrd.LocResultdetail_JXPatDr->JXPat_name  " 
	 
	;w sqlStr,! 		 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s ^topmnsuSqlStr = sqlStr
	
	d result.Execute()	
	s cod1=""
    While(result.Next()){
	    s patdr = result.Data("patdr")
	    s period = result.Data("period")
	    s desc = result.Data("depname")
	    s deptId=result.Data("deptId")
	    s lrwardId = result.Data("lrward")
	    if ($d(^PAWARD(lrwardId))'=0)&&(lrwardId'=0){
			s lrward=$P(^PAWARD(lrwardId),"^",2)
		}else{
			s lrward=""
		}
	    
	    s code = result.Data("code")
	    s patname = result.Data("patname")
        s schemname = result.Data("sname")
        s schemeId=result.Data("schemeId")
        s schemeCode=result.Data("schemeCode")
        s doctyname = result.Data("docTyname") 
        s docCode=result.Data("docCode")
		s failNum = result.Data("failNum")
		s active = result.Data("active")		
		i active="Y"   s active="是"
		i active="N"   s active="否"	
		//对isvalue数字的进行处理，保留两位小数
		if ($number(active)'=""){
			s active=$fn(active,"",2)
		}
		s checkName = result.Data("checkName")
		s picLink = result.Data("picLink")
		;s cod1=cod1_code
		;s sum = ..GetfailCount(frequency,"N",schemDr,stDate1,endDate1)
		 //科室检查项目取failNum的值，医师检查项要单独计算不合格例数
        s jxpatUnQSum=0
        i docCode="" s docCode="no"
        i doctyname="" s doctyname="no"
	    if (patdr'=0){
		    if ($Data(^deptSchemeTemp(deptId,schemeId,docCode,doctyname))'=0){ //已经计算了不合格的值
				s failNum=$Get(^deptSchemeTemp(deptId,schemeId,docCode,doctyname))
			}else{
				s jxpatUnQSum =##class(dhc.qm.report.HERPJXQMDocCollect).GetDotUnqualifiedNum(deptId,schemeId,schemeCode,docCode,doctyname,frequency,stDate1,endDate1,docTypeCode,docType,"") ;取得不合格病例数	
		    	s ^deptSchemeTemp(deptId,schemeId,docCode,doctyname)=jxpatUnQSum
		    	s failNum=$Get(^deptSchemeTemp(deptId,schemeId,docCode,doctyname))
			}
				
	    }else{
			s failNum=failNum
		}
		
	 d a    	  
	}
	k ^deptSchemeTemp			
  	q $$$OK
a
	;schemName,schemRowid,deptId,deptName,wardName,checkId,checkName,actValue,pcode,pname,adm,failNum
    s Data=$lb(patdr,period,desc,lrward,code,patname,schemname,doctyname,failNum,active,checkName,picLink,schemeId,deptId)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
 	;s m=$p(^CacheTemp,":",8)
 	;w m
	q
}

ClassMethod GetDocCheckSchemCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocCheckSchemCountExecute ]
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

ClassMethod GetDocCheckSchemCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocCheckSchemCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(dhc.qm.report.HERPJXQMDocCheckSchemCollect).GetfailCount("Q","N","1","201501","201503")
ClassMethod GetfailCount(type, active, schemDr, stDate1, endDate1) As %String
{
	n (type,active,schemDr,stDate1,endDate1)
 	;w code
 	s failcount = 0
	s sqlStr=" SELECT lrd.LocResultdetail_JXPatDr,lrd.LocResultdetail_parRef->LocResultMain_period  , " 
	   _" lrd.LocResultdetail_JXPatDr->JXPat_code as code,lrd.LocResultdetail_checkDr->Check_name AS checks, " 
	   _" lrd.LocResultdetail_actValue AS active FROM dhc_qm_data.LocResultDetail lrd "
	   _" WHERE lrd.LocResultdetail_RowID >0 AND lrd.LocResultdetail_actValue='"_active_"' "
	   _" AND lrd.LocResultdetail_parRef->LocResultMain_schemDr='"_schemDr_"' "
	   _" AND lrd.LocResultdetail_parRef->LocResultMain_period between '"_stDate1_"' AND '"_endDate1_"' "
	s sqlStr = sqlStr_" and lrd.LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType = '"_type_"' "
    s sqlStr = sqlStr_" group by lrd.LocResultdetail_JXPatDr,lrd.LocResultdetail_parRef->LocResultMain_period  "
    ;w sqlStr,!
	;s ^shsjgdsjkah = sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="code"
	s tmp=0
	While(result.Next())
	{
		;s code=code_","_result.Data("code") 
		;s failcount = result.Data("failcount")
		s failcount = failcount + 1
		s tmp=failcount
		
	}
	;w code,!
	d result.Close()

	q tmp
}

Storage Default
{
<StreamLocation>^dhc.qm.report.HERPJXQMDocB3C0S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
