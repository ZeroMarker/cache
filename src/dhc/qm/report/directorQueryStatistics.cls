Class dhc.qm.report.directorQueryStatistics Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//    d ##class(%ResultSet).RunQuery("dhc.qm.report.directorQueryStatistics","GetInfo","2016","Q","2","2","25","20")

Query GetInfo(Cycle As %String, type As %String, startdate As %String, enddate As %String, check As %String, dept As %String) As %Query(ROWSPEC = "period:%String,scheme:%String,deptd:%String,ward:%String,JXPatDr:%String,patient:%String,code:%String,checkname:%String,failNum:%String,isvalue:%String,link:%String,schemeId:%String,schemeCode:%String,checkDr:%String,deptId:%Integer") [ SqlProc ]
{
}

ClassMethod GetInfoExecute(ByRef qHandle As %Binary, Cycle As %String, type As %String, startdate As %String, enddate As %String, check As %String, dept As %String) As %Status
{
	
	n (qHandle,Cycle,type,startdate,enddate,check,dept)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:Cycle="" $$$OK
    q:type="" $$$OK
    q:startdate="" $$$OK
    q:enddate="" $$$OK
   
    
    i startdate>10  d
    .s startdate=Cycle_startdate
	e    d
	.s startdate=Cycle_0_startdate
	i enddate>10  d
	.s enddate=Cycle_enddate
	e    d
	.s enddate=Cycle_0_enddate
	
    s sqlStr="SELECT LocResultMain_schemDr,LocResultMain_schemDr->QMSchem_name,LocResultMain_schemDr->QMSchem_code as schemCode, "
				_" LocResultMain_departDr,LocResultMain_departDr->DEP_Desc,LocResultMain_period,LocResultMain_wardDr, "
				_" LocResultMain_failNum  ,ld.LocResultdetail_JXPatDr->JXPat_name,ld.LocResultdetail_JXPatDr->JXPat_code ,LocResultdetail_JXPatDr,LocResultdetail_checkDr , "
				_" ld.LocResultdetail_checkDr->Check_code,ld.LocResultdetail_checkDr->Check_name,LocResultdetail_actValue,LocResultdetail_PicLink  "
			_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail ld ,dhc_qm_data.QMSchemDetail qd,dhc_qm_data.CheckInfo c  "
			_" WHERE lm.LocResultMain_rowid=ld.LocResultdetail_parRef "
			_"   and ld.LocResultdetail_checkDr=c.Check_rowid  "
			_"   AND qd.QMSchemDetail_parRef=lm.LocResultMain_schemDr AND qd.QMSchemDetail_CheckDr= ld.LocResultdetail_checkDr "
			_"   and LocResultMain_period between '"_startdate_"' and  '"_enddate_"'  "
			_"   and LocResultMain_schemDr->QMSchem_periodType = '"_type_"' " 
 
    i check'="" s sqlStr = sqlStr_" and LocResultMain_schemDr->QMSchem_RowID = '"_check_"' "
    i dept'=""  s sqlStr = sqlStr_" and LocResultMain_departDr = '"_dept_"' "
    s sqlStr=sqlStr_" and (LocResultMain_auditState=1 or LocResultdetail_saveStatus=1) " //加入审核状态 2016-7-19 cyl  pad端保存状态为1 2016825
	s sqlStr=sqlStr_" order by lm.LocResultMain_period,lm.LocResultMain_schemDr,lm.LocResultMain_departDr"  
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;s ^chuSql=sqlStr
	
	d result.Execute()
	s cod1=""	
    While(result.Next()){
	    //中文
	    s period = result.Data("LocResultMain_period")
	    s scheme = result.Data("QMSchem_name")
	    s schemeId=result.Data("LocResultMain_schemDr")
		s schemeCode=result.Data("schemCode")
	    
	    s deptd = result.Data("DEP_Desc")
        s deptId = result.Data("LocResultMain_departDr")
        s JXPatDr=result.Data("LocResultdetail_JXPatDr")
		s wardId=result.Data("LocResultMain_wardDr")
		if ($d(^PAWARD(wardId))'=0)&&(wardId'=0){
			s ward=$P(^PAWARD(wardId),"^",2)
		}else{
			s ward=""
		}
		
		s patient=result.Data("JXPat_name")
		s failNum=result.Data("LocResultMain_failNum")
		s code=result.Data("JXPat_code")
		s checkname=result.Data("Check_name")
		s checkDr=result.Data("LocResultdetail_checkDr")
		s isvalue=result.Data("LocResultdetail_actValue")
		;i isvalue="Y"   s isvalue="是"
		;i isvalue="N"   s isvalue="否"
		//对isvalue数字的进行处理，保留两位小数
		if ($number(isvalue)'=""){
			s isvalue=$fn(isvalue,"",2)
		}
		
		s link=result.Data("LocResultdetail_PicLink")
		 //科室检查项目取failNum的值，医师检查项要单独计算不合格例数
        s jxpatUnQSum=0
	    if (JXPatDr'=0){
		    if ($Data(^deptSchemeTemp(deptId,schemeId))'=0){ //已经计算了不合格的值
				s failNum=$Get(^deptSchemeTemp(deptId,schemeId))
			}else{
				s jxpatUnQSum =##class(dhc.qm.report.HERPJXQMDocCollect).GetDotUnqualifiedNum(deptId,schemeId,schemeCode,"","",type,startdate,enddate,"","","") ;取得不合格病例数	
		    	s ^deptSchemeTemp(deptId,schemeId)=jxpatUnQSum
		    	s failNum=$Get(^deptSchemeTemp(deptId,schemeId))
			}
				
	    }else{
			s failNum=failNum
		}
		
		;s sum =111 ;..GetfailCount(type,period,check,dept)
		;W sum,!
	 d a    ;OutputRow28	  
	}
	k ^deptSchemeTemp
  	q $$$OK
a
	
    s Data=$lb(period,scheme,deptd,ward,JXPatDr,patient,code,checkname,failNum,isvalue,link,schemeId,schemeCode,checkDr,deptId)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfoExecute ]
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

ClassMethod GetInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetfailCount(type, period, check, dept) As %String
{
	n (type,period,check,dept)
 	
	
    s sqlStr=" SELECT LocResultMain_schemDr->QMSchem_name,LocResultMain_departDr->DEP_Desc,count(DISTINCT ld.LocResultdetail_JXPatDr->JXPat_code||LocResultMain_period) AS failcount,LocResultMain_period,LocResultMain_wardDr "
	_" ,p.JXPat_name,p.JXPat_code ,LocResultdetail_JXPatDr,LocResultdetail_checkDr ,c.Check_code,c.Check_name,LocResultdetail_actValue,LocResultdetail_PicLink  "
	_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail ld ,dhc_qm_data.JXPat p ,dhc_qm_data.CheckInfo c "
	_" WHERE lm.LocResultMain_rowid=ld.LocResultdetail_parRef AND ld.LocResultdetail_JXPatDr=p.JXPat_rowid AND ld.LocResultdetail_checkDr=c.Check_rowid "
	s sqlStr = sqlStr_" and ld.LocResultdetail_actValue='N' " 
    s sqlStr = sqlStr_" and LocResultMain_period ='"_period_"'   "
      s sqlStr = sqlStr_" and LocResultMain_schemDr->QMSchem_periodType = '"_type_"' " 
     s sqlStr = sqlStr_" and LocResultMain_schemDr->QMSchem_RowID = '"_check_"' "
    i dept'=""  s sqlStr = sqlStr_" and LocResultMain_departDr = '"_dept_"' "
	
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="code"
	s tmp=0
	While(result.Next())
	{
		
		s failcount = result.Data("failcount")
		
		s tmp=failcount
		
	}
	
	d result.Close()
	
	q tmp
}

//w ##class(dhc.qm.report.directorQueryStatistics).GetfailCount("2052706205270620527062052706205270620527062052706205270620527062052706C315360C315360C315360C315360C315360A025735A025735A025735A025735A025735188324918832491883249","N","1","201501","201504")

/*ClassMethod GetfailCount(code, active, check, startdate, enddate) As %String
{
	n (code,active,check,startdate,enddate)
 	;w code
	s sqlStr=" SELECT DISTINCT lrd.LocResultdetail_JXPatDr->JXPat_code as code, " 
	   _" count(DISTINCT lrd.LocResultdetail_JXPatDr->JXPat_code) AS failcount,lrd.LocResultdetail_checkDr->Check_name AS checks, " 
	   _" lrd.LocResultdetail_actValue AS active FROM dhc_qm_data.LocResultDetail lrd "
	   _" WHERE lrd.LocResultdetail_RowID >0 AND lrd.LocResultdetail_actValue='"_active_"' "
	   _" AND lrd.LocResultdetail_parRef->LocResultMain_schemDr='"_check_"' "
	   _" AND lrd.LocResultdetail_parRef->LocResultMain_period between '"_startdate_"' AND '"_enddate_"' "
	;w "code->"_code,!
	s code=..get(code)
	;s code=..get(code)
	;w code
	s code=..MyArray(code)
	;w code
	i code'="" 
	s sqlStr=sqlStr_" and lrd.LocResultdetail_JXPatDr->JXPat_code in ("_code_")"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;s count=0
	;s resultString="" 
	;s end=start+limit-1
	
	s json=##class(dhc.qm.comm.JsonObj).%New()
	s jsonTitle="code"
	
	While(result.Next())
	{
		s code=code_","_result.Data("code") 
		;s code = result.Data("code")
		s failcount = result.Data("failcount")
		;w failcount,!
		;s failcount=count("failcount")
		s checks = result.Data("checks")
		s active = result.Data("active")
		s tmp=failcount
		;s tmp=code_"^"_failcount_"^"_checks_"^"_active	
		;i (count>=start)&(count<=end) d
		;.d json.InsertRowData(tmp)
		;s count=count+1
	}
	;w code,!
	d result.Close()
	;s resultString = json.getJsonData(jsonTitle,count)
	;k json
	q tmp
}

/// others:w ##class(dhc.qm.report.directorQueryStatistics).MyArray("1||4,1||6,1||7")
ClassMethod MyArray(s) As %String
{
	n (s)
	s len=$L(s,",")
	s resultString=""
	for i=1:1:len{
		i resultString="" {
		s resultString=resultString_"'"_$p(s,",",i)_"'"}else{
		s resultString=resultString_",'"_$p(s,",",i)_"'"	
			}
		}
	q resultString
}

/// others:w ##class(dhc.qm.report.directorQueryStatistics).get("2052706205270620527062052706205270620527062052706205270620527062052706C315360C315360C315360C315360C315360A025735A025735A025735A025735A025735188324918832491883249")
ClassMethod get(code)
{
	n (code)
	q:$L(code)<=7 code
	q $E(code,1,7)_","_..get($E(code,8,))
}*/
Storage Default
{
<Data name="directorQueryStatisticsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.qm.report.directorQue162BD</DataLocation>
<DefaultData>directorQueryStatisticsDefaultData</DefaultData>
<IdLocation>^dhc.qm.report.directorQue162BD</IdLocation>
<IndexLocation>^dhc.qm.report.directorQue162BI</IndexLocation>
<StreamLocation>^dhc.qm.report.directorQue162BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
