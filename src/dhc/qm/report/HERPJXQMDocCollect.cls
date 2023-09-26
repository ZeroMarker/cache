Import SQLUser

Class dhc.qm.report.HERPJXQMDocCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     cyl
/// CreateDate:  2015-12-10
/// Description: 医师不合格病例汇总统计
///             
/// Table:      dhc_qm_data.LocResultMain,dhc_qm_data.JXPat
/// Input:       year（年度）, frequency（频次）, stDate（开始时间）, endDate（结束时间）, locdr（科室rowid）, docType（医生类别） 
/// Return:      json格式
/// Others:  d ##class(%ResultSet).RunQuery("dhc.qm.report.HERPJXQMDocCollect","GetDocUnqualifiedCount","2015","Q","2","2","","JXPat_IndocName")
Query GetDocUnqualifiedCount(year As %String, frequency As %String, stDate As %String, endDate As %String, locdr As %String, docType As %String) As %Query(ROWSPEC = "schemName:%String,schemRowid:%String,schemCode:%String,docCode:%String,docName:%String,unQSum:%Integer") [ SqlProc ]
{
}

ClassMethod GetDocUnqualifiedCountExecute(ByRef qHandle As %Binary, year As %String, frequency As %String, stDate As %String, endDate As %String, locdr As %String, docType As %String) As %Status
{
	n (qHandle,year,frequency,stDate,endDate,locdr,docType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	q:year="" $$$OK 
    q:frequency="" $$$OK
    q:stDate="" $$$OK
    q:endDate="" $$$OK
    ;q:locdr="" $$$OK
    q:docType="" $$$OK
 
    i stDate<10   s stDate="0"_stDate
    i endDate<10  s endDate="0"_endDate
    s stDate1=year_stDate
	s endDate1=year_endDate

	;  set ^chuPara =year_"^"_frequency_"^"_stDate_"^"_endDate_"^"_locdr_"^"_docType_"^"_stDate1_"^"_endDate1
	//根据传入的医生类别不同，组合查找不同字段的sql
	set docTypeCode=""
	i docType="JXPat_IndocName"  s docTypeCode="JXPat_Indoccode"
	i docType="JXPat_operdocname"  s docTypeCode="JXPat_operatorcode"
	i docType="JXPat_consultdoc"  s docTypeCode="JXPat_consultdoccode"
	
	//得到科室的所有医生和检查项目
	s deptSchemSql="SELECT DISTINCT lrd.LocResultdetail_JXPatDr->"_docTypeCode_" as docCode, lrd.LocResultdetail_JXPatDr->"_docType_" as docName,lrd.LocResultdetail_parRef->LocResultMain_departDr as deptId,lrd.LocResultdetail_JXPatDr as jxpatDr, "
					_" lrd.LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code as schemCode,lrd.LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name as schemName,lrd.LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_rowid as schemRowid"
				_" FROM dhc_qm_data.LocResultMain lm,dhc_qm_data.Locresultdetail lrd  "
				_"  WHERE lm.LocResultMain_rowid=lrd.LocResultdetail_parRef and lrd.LocResultdetail_parRef->LocResultMain_period BETWEEN '"_stDate1_"' AND '"_endDate1_"'"
				_" AND lrd.LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType='"_frequency_"' "
 				
 	i locdr'=""   s deptSchemSql=deptSchemSql_" AND lrd.LocResultdetail_parRef->LocResultMain_departDr='"_locdr_"' "
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(deptSchemSql)
	d result.Execute()	
	;s ^chuSql=deptSchemSql
    While(result.Next()){
	    s schemCode = result.Data("schemCode")
        s schemName = result.Data("schemName")
        s schemRowid = result.Data("schemRowid")
       
        
        s docCode =result.Data("docCode")
		s docName=result.Data("docName")
		
		s deptId=result.Data("deptId")
		s jxpatDr=result.Data("jxpatDr")
		if (jxpatDr'=0){ ;当jxpatDr=0时，为科室检查项
			s unQSum =..GetDotUnqualifiedNum(deptId,schemRowid,schemCode,docCode,docName,frequency,stDate1,endDate1,docTypeCode,docType,jxpatDr) ;取得不合格病例数	
			d aa   
		}	  
	}
  	q $$$OK
aa
    s Data=$lb(schemName,schemRowid,schemCode,docCode,docName,unQSum)		
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDocUnqualifiedCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocUnqualifiedCountExecute ]
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

ClassMethod GetDocUnqualifiedCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocUnqualifiedCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:     cyl
/// CreateDate:  2015-12-10
/// Description: 医师不合格病例数
///             
/// Table:       dhc_qm_data.LocResultMain, dhc_qm_data.Locresultdetail
/// Input:     deptdr(科室rowid),schemRowid（检查项目rowid）,docCode（医生编码）,frequency（期间频次：Q,M）,stDate（开始时间）,endDate（结束时间）  
/// Return:     unQNum（指定医师不合格病例数）
/// Others:  w ##class(dhc.qm.report.HERPJXQMDocCollect).GetDotUnqualifiedNum("27","16","","李康","Q","201601","201601","JXPat_Indoccode","JXPat_IndocName")
ClassMethod GetDotUnqualifiedNum(deptdr As %String, schemRowid, schemCode As %String, docCode As %String, docName As %String, frequency As %String, stDate As %String, endDate As %String, docTypeCode As %String, docType As %String, jxpatDr As %String) As %String
{
	
	set unQNum=0
	;s ^chuPa=locdr_"^"_schemRowid_"^"_docCode_"^"_docName_"^"_frequency_"^"_stDate1_"^"_endDate1_"^"_docTypeCode_"^"_docType
	if docCode=$c(0) s docCode=""
	if docName=$c(0) s docName=""
	
	
	//**根据传来的schemId,获得该检查项目的dataType
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemCode)
	//得到该检查项的所有检查点
	s getCheckSql="SELECT DISTINCT lrd.LocResultdetail_checkDr as checkId "
				_"FROM dhc_qm_data.LocResultMain lrm,dhc_qm_data.Locresultdetail lrd "
				_"WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
				;_"and lrm.LocResultMain_departDr="_deptdr_" "
				_"AND lrm.LocResultMain_schemDr="_schemRowid_" "
				_"AND lrm.LocResultMain_period BETWEEN '"_stDate_"' AND '"_endDate_"' " 
				_"AND lrm.LocResultMain_schemDr->QMSchem_periodType='"_frequency_"' "
				;_"AND lrm.LocResultMain_auditState=1 "
	s result3=##class(%Library.ResultSet).%New()
	d result3.Prepare(getCheckSql)
	d result3.Execute()	
	
	set sqlNumStr="SELECT DISTINCT lrd.LocResultdetail_JXPatDr->JXPat_code,lrd.LocResultdetail_JXPatDr->JXPat_name  "
			_"FROM dhc_qm_data.LocResultMain lrm,dhc_qm_data.Locresultdetail lrd "
			_"WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
			_"and lrm.LocResultMain_departDr="_deptdr_" "
			_"AND lrm.LocResultMain_schemDr="_schemRowid_" "
			_"AND lrm.LocResultMain_period BETWEEN '"_stDate_"' AND '"_endDate_"' " 
			_"AND lrm.LocResultMain_schemDr->QMSchem_periodType='"_frequency_"' "
			_"AND lrm.LocResultMain_auditState=1 "
	if jxpatDr'=""	s sqlNumStr=sqlNumStr_"and lrd.LocResultdetail_JXPatDr="_jxpatDr_" "
	if docType'=""  s sqlNumStr=sqlNumStr_"AND lrd.LocResultdetail_JXPatDr->"_docType_"='"_docName_"' "
	if docTypeCode'="" 	 s sqlNumStr=sqlNumStr_"AND lrd.LocResultdetail_JXPatDr->"_docTypeCode_"='"_docCode_"'  "
	s useParamStr=stDate_"^"_endDate_"^"_frequency_"^"_schemCode_"^"_deptdr
	s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(result3,"checkId",sqlNumStr,dataType,useParamStr)
	
	s unQNum=$p(fieldStr,"^",1)
	/*
	//要循环所有的检查点。找到特殊检查点的特殊值为不合格
	set checkFiledStr = "SELECT DISTINCT lrd.LocResultdetail_checkDr as checkId "
						_"FROM dhc_qm_data.LocResultMain lrm,dhc_qm_data.Locresultdetail lrd "
						_"WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
						_"and lrm.LocResultMain_departDr="_deptdr_" "
						_"AND lrm.LocResultMain_schemDr="_schemRowid_" "
						_"AND lrm.LocResultMain_period BETWEEN '"_stDate_"' AND '"_endDate_"' " 
						_"AND lrm.LocResultMain_schemDr->QMSchem_periodType='"_frequency_"' "
						_"AND lrm.LocResultMain_auditState=1 "
	if docType'="" s checkFiledStr=checkFiledStr_"AND lrd.LocResultdetail_JXPatDr->"_docType_"='"_docName_"' "
	if docTypeCode'="" 	 s checkFiledStr=checkFiledStr_"AND lrd.LocResultdetail_JXPatDr->"_docTypeCode_"='"_docCode_"'  "
	
	//**根据传来的schemId,获得该检查项目的dataType
	;&sql(SELECT QMSchem_dataType into:dataType FROM dhc_qm_data.QMSchem WHERE QMSchem_RowID =:schemRowid)
	s dataType=##class(dhc.qm.report.SchemCheckComm).GetSchemDataType(schemRowid)
	s result3=##class(%Library.ResultSet).%New()
	d result3.Prepare(checkFiledStr)
	d result3.Execute()	
	
	//计算不合格例数
	set sqlNumStr="SELECT DISTINCT lrd.LocResultdetail_JXPatDr->JXPat_code,lrd.LocResultdetail_JXPatDr->JXPat_name  "
			_"FROM dhc_qm_data.LocResultMain lrm,dhc_qm_data.Locresultdetail lrd "
			_"WHERE lrm.LocResultMain_rowid=lrd.LocResultdetail_parRef "
			_"and lrm.LocResultMain_departDr="_deptdr_" "
			_"AND lrm.LocResultMain_schemDr="_schemRowid_" "
			_"AND lrm.LocResultMain_period BETWEEN '"_stDate_"' AND '"_endDate_"' " 
			_"AND lrm.LocResultMain_schemDr->QMSchem_periodType='"_frequency_"' "
			_"AND lrm.LocResultMain_auditState=1 "
	if docType'=""  s sqlNumStr=sqlNumStr_"AND lrd.LocResultdetail_JXPatDr->"_docType_"='"_docName_"' "
	if docTypeCode'="" 	 s sqlNumStr=sqlNumStr_"AND lrd.LocResultdetail_JXPatDr->"_docTypeCode_"='"_docCode_"'  "
	s fieldStr=##class(dhc.qm.report.SchemCheckComm).getFieldStrOrCount(result3,"checkId",sqlNumStr,dataType)
	s unQNum=$p(fieldStr,"^",1)
 */
	q unQNum
}

Storage Default
{
<StreamLocation>^dhc.qm.report.HERPJXQMDoc6ABDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
