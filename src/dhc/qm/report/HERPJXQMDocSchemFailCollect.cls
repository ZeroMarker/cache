Import SQLUser

Class dhc.qm.report.HERPJXQMDocSchemFailCollect Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     初雅莉
/// CreateDate:  2016-03-07
/// Description: 医师汇总统计明细
///             
/// Input:     locdr(科室rowid),schemDr（检查项目code）,frequency（期间频次：Q,M）,stDate（开始时间）,endDate（结束时间）  
/// Return:    json
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocSchemFailCollect","GetDocSchemFailCount","2015","M","5","5","16","53","JXPat_IndocName")
Query GetDocSchemFailCount(year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String, docType As %String) As %Query(ROWSPEC = "patdr:%String,periods:%String,desc:%String,lrward:%String,code:%String,patname:%String,schemname:%String,doctyname:%String,sum:%String,active:%String,checkinfo:%String,opername:%String,departDr:%Integer,checkDr:%Integer") [ SqlProc ]
{
}

ClassMethod GetDocSchemFailCountExecute(ByRef qHandle As %Binary, year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String, docType As %String) As %Status
{
	n (qHandle,year,frequency,stDate,endDate,schemDr,locdr,docType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:year="" $$$OK
    q:frequency="" $$$OK
    q:stDate="" $$$OK
    q:endDate="" $$$OK
    q:schemDr="" $$$OK
    ;q:locdr="" $$$OK
    ;w "asdbga"
    q:docType="" $$$OK 

    i stDate<10   s stDate="0"_stDate
    i endDate<10  s endDate="0"_endDate
    s stDate1=year_stDate
	s endDate1=year_endDate
	
	i docType="JXPat_IndocName"  s docTypeCode="JXPat_Indoccode"
	i docType="JXPat_operdocname"  s docTypeCode="JXPat_operatorcode"
	
	//**根据传来的schemId,获得该检查项目的dataType
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemDr)
	s getCheckBySchemSql="SELECT QMSchemDetail_rowid, QMSchemDetail_parRef, QMSchemDetail_CheckDr as checkId FROM dhc_qm_data.QMSchemDetail "
		 	_" WHERE QMSchemDetail_parRef->QMSchem_Code = '"_schemDr_"' "
	
	s getCheckBySchem=##class(%Library.ResultSet).%New()
	d getCheckBySchem.Prepare(getCheckBySchemSql)
	d getCheckBySchem.Execute()
	s useParamStr=stDate1_"^"_endDate1_"^"_frequency_"^"_schemDr_"^"_locdr
	s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(getCheckBySchem,"checkId","",dataType,useParamStr)
	s filedSql=$p(fieldStr,"^",2)
	
	s getMainSql = "select DISTINCT lrd.LocResultdetail_parRef as parRef,LocResultdetail_JXPatDr as jxpat"
				_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail lrd"
				_" WHERE lm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
   				_" and lrd.LocResultdetail_parRef->LocResultMain_period between '"_stDate1_"' AND '"_endDate1_"'  "
   				_" and lm.LocResultMain_schemDr->QMSchem_periodType = '"_frequency_"' " 
   				_" and lm.LocResultMain_schemDr->QMSchem_Code='"_schemDr_"' "
   				_" and lm.LocResultMain_auditState=1 "
   				;_" and lm.LocResultMain_schemDr = '"_schemDr_"' "
    i locdr'=""  s getMainSql = getMainSql_" and lm.LocResultMain_departDr = '"_locdr_"' "
  	s getMainSql = getMainSql_filedSql
  	s getMain=##class(%Library.ResultSet).%New()
	d getMain.Prepare(getMainSql)
	d getMain.Execute()
	;w getMainSql,!
	while(getMain.Next()){
		s parRef=getMain.Data("parRef")
		s jxpat=getMain.Data("jxpat")
		
		&sql(DECLARE DetailCursor CURSOR FOR 
	  		SELECT LocResultdetail_JXPatDr,LocResultdetail_parRef->LocResultMain_period,LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc,LocResultdetail_parRef->LocResultMain_departDr,
			LocResultdetail_parRef->LocResultMain_wardDr as lrward,LocResultdetail_JXPatDr->JXPat_code,LocResultdetail_JXPatDr->JXPat_name,
			LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name,LocResultdetail_JXPatDr->JXPat_IndocName,
			LocResultdetail_JXPatDr->JXPat_operdocname,LocResultdetail_actValue,LocResultdetail_checkDr->Check_name,LocResultdetail_checkDr
			into :patdr,:period,:desc,:departDr,:lrwardId,:code,:patname,:schemname,:indocname,:opername,:active,:checkinfo,:checkDr
			FROM dhc_qm_data.LocResultdetail 
			WHERE LocResultdetail_parRef=:parRef and LocResultdetail_JXPatDr=:jxpat )
  		 &sql(OPEN DetailCursor)
	  	 FOR {
		  	&sql(FETCH DetailCursor)
	        QUIT:SQLCODE  
			if (lrwardId'="")&&(lrwardId'=0)&&($Data(^PAWARD(lrwardId))'=0){
				s lrward=$P(^PAWARD(lrwardId),"^",2)
			}else{
				s lrward=" "
			}
			i docType="JXPat_IndocName"  d
			.s doctyname=indocname 
			
			i docType="JXPat_operdocname" d
			.s doctyname=opername
			s sum=1 ;//////////
			d a
		 }
  		 &sql(CLOSE DetailCursor)
	}
	

  	q $$$OK
a
	
   	 s Data=$lb(patdr,period,desc,lrward,code,patname,schemname,doctyname,sum,active,checkinfo,opername,departDr,checkDr)
   	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
    
 
	q
}

ClassMethod GetDocSchemFailCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocSchemFailCountExecute ]
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

ClassMethod GetDocSchemFailCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocCheckSchemCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:     ban
/// CreateDate:  2016-05-30
/// Description: 科主任方案不合格统计
///             
/// Input:     locdr(科室rowid),schemDr（检查项目code）,frequency（期间频次：Q,M）,stDate（开始时间）,endDate（结束时间）  
/// Return:    json
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocSchemFailCollect","GetDeptDirecterSchemFailCount","2015","M","5","5","0030101","53")
Query GetDeptDirecterSchemFailCount(year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String) As %Query(ROWSPEC = "patdr:%String,periods:%String,desc:%String,lrward:%String,code:%String,patname:%String,schemname:%String,doctyname:%String,sum:%String,active:%String,checkinfo:%String,opername:%String,checkId:%Integer,departDr:%Integer") [ SqlProc ]
{
}

ClassMethod GetDeptDirecterSchemFailCountExecute(ByRef qHandle As %Binary, year As %String, frequency As %String, stDate As %String, endDate As %String, schemDr As %String, locdr As %String) As %Status
{
	n (qHandle,year,frequency,stDate,endDate,schemDr,locdr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:year="" $$$OK
    q:frequency="" $$$OK
    q:stDate="" $$$OK
    q:endDate="" $$$OK
    q:schemDr="" $$$OK
    

    i stDate<10   s stDate="0"_stDate
    i endDate<10  s endDate="0"_endDate
    s stDate1=year_stDate
	s endDate1=year_endDate
	
	//**根据传来的schemId,获得该检查项目的dataType
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemDr)
	s getCheckBySchemSql="SELECT QMSchemDetail_rowid, QMSchemDetail_parRef, QMSchemDetail_CheckDr as checkId FROM dhc_qm_data.QMSchemDetail "
		 	_" WHERE QMSchemDetail_parRef->QMSchem_Code = '"_schemDr_"' "
	
	s getCheckBySchem=##class(%Library.ResultSet).%New()
	d getCheckBySchem.Prepare(getCheckBySchemSql)
	d getCheckBySchem.Execute()
	s useParamStr=stDate1_"^"_endDate1_"^"_frequency_"^"_schemDr_"^"_locdr
	s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(getCheckBySchem,"checkId","",dataType,useParamStr)
	s filedSql=$p(fieldStr,"^",2)
	
	s getMainSql = "select DISTINCT lrd.LocResultdetail_parRef as parRef,LocResultdetail_JXPatDr as jxpat"
				_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.LocResultdetail lrd"
				_" WHERE lm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
   				_" and lrd.LocResultdetail_parRef->LocResultMain_period between '"_stDate1_"' AND '"_endDate1_"'  "
   				_" and lm.LocResultMain_schemDr->QMSchem_periodType = '"_frequency_"' " 
   				_" and lm.LocResultMain_schemDr->QMSchem_Code='"_schemDr_"' "
   				;_" and lm.LocResultMain_schemDr = '"_schemDr_"' "
   				_" and (lm.LocResultMain_auditState=1 or lrd.LocResultdetail_saveStatus=1) " // pad端保存状态为1 201682 "
    i locdr'=""  s getMainSql = getMainSql_" and lm.LocResultMain_departDr = '"_locdr_"' "
  	s getMainSql = getMainSql_filedSql
  	s getMain=##class(%Library.ResultSet).%New()
	d getMain.Prepare(getMainSql)
	d getMain.Execute()
	;w getMainSql,!
	while(getMain.Next()){
		s parRef=getMain.Data("parRef")
		s jxpat=getMain.Data("jxpat")
		
		&sql(DECLARE DetailCursors CURSOR FOR 
	  		SELECT LocResultdetail_JXPatDr,LocResultdetail_parRef->LocResultMain_period,LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc,LocResultdetail_parRef->LocResultMain_departDr,
			LocResultdetail_parRef->LocResultMain_wardDr as lrward,LocResultdetail_JXPatDr->JXPat_code,LocResultdetail_JXPatDr->JXPat_name,
			LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name,LocResultdetail_JXPatDr->JXPat_IndocName,
			LocResultdetail_JXPatDr->JXPat_operdocname,LocResultdetail_actValue,LocResultdetail_checkDr->Check_name,LocResultdetail_checkDr
			into :patdr,:period,:desc,:departDr,:lrwardId,:code,:patname,:schemname,:indocname,:opername,:active,:checkinfo,:checkId
			FROM dhc_qm_data.LocResultdetail 
			WHERE LocResultdetail_parRef=:parRef and LocResultdetail_JXPatDr=:jxpat )
  		 &sql(OPEN DetailCursors)
	  	 FOR {
		  	&sql(FETCH DetailCursors)
	        QUIT:SQLCODE  
			if (lrwardId'="")&&(lrwardId'=0)&&($Data(^PAWARD(lrwardId))'=0){
				s lrward=$P(^PAWARD(lrwardId),"^",2)
			}else{
				s lrward=" "
			}
			
			s sum=1 ;//////////
			d aa
		 }
  		 &sql(CLOSE DetailCursors)
	}
	

  	q $$$OK
aa
	
   	 s Data=$lb(patdr,period,desc,lrward,code,patname,schemname,doctyname,sum,active,checkinfo,opername,checkId,departDr)
   	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
    
 
	q
}

ClassMethod GetDeptDirecterSchemFailCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptDirecterSchemFailCountExecute ]
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

ClassMethod GetDeptDirecterSchemFailCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptDirecterSchemFailCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.qm.report.HERPJXQMDocB7B2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
