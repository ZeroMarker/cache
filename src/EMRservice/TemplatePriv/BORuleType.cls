Class EMRservice.TemplatePriv.BORuleType Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.BORuleType";

/*
ClassMethod GetRuleTypeDetails(parDicId As %String) As %XML.DataSet [ WebMethod ]
{
 q:($d(parDicId)=0 || parDicId = "") ""
 
 &SQL(Select TableName,DicCodeCol,DicDescCol
 into :tableName,:dicCodeCol,:dicDescCol
 From EMRmeta.StdDictionary where ID = :parDicId)
 
 q:($d(tableName)=0 || tableName = "") ""
 q:($d(dicCodeCol)=0 || dicCodeCol = "") ""
 q:($d(dicDescCol)=0 || dicDescCol = "") ""

 s sql = "SELECT "_dicCodeCol_","_dicDescCol_" From "_tableName_" Order By "_dicCodeCol

 Set result=##class(%XML.DataSet).%New()
	
 Do result.Prepare(sql)
 Do result.SetArgs()
 Quit result
}
*/
/// 取得所有带有模板组信息的template
/// 取得所有带有模板组信息的template
/// 以Query方式实现 P8对SQL支持不同
/// ##Class(EMRservice.TemplatePriv.BORuleType).GetRuleTypeDetails()
ClassMethod GetRuleTypeDetails(parDicId As %String) As %XML.DataSet [ WebMethod ]
{
	q:($d(parDicId)=0 || parDicId = "") ""
	s DicType = "", DicCode = "" , Code=""
	&SQL(select RuleTypeTag, DicCodeCol,Code into :DicType, :DicCode,:Code from EMRmeta.StdDictionary where ID=:parDicId)
	
	Set result = ""
	if (DicType = "PATSEX")
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllSex")
	}
	elseif (DicType = "PATDEPT")
	{
		if ($zcvt(DicCode,"U") = "CTLOC_CODE")
		{	Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllLoc")}
		elseif ($zcvt(DicCode,"U") = "CTLOC_ROWID")
		{	Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllLocRowId")}
	}
	elseif (DicType = "PATWARD")
	{
		if ($zcvt(DicCode,"U") = "WARD_CODE")
		{	Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllWard")}
		elseif ($zcvt(DicCode,"U") = "WARD_ROWID")
		{	Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllWardRowId")}
	}
	elseif (DicType = "PATTYPE")
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllType")
	}
	elseif (DicType = "PATPRIV")
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllPriv")
	}
	elseif (DicType = "PATULEVEL")
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllUserLevel")
	}
	elseif (DicType = "PATDIA")
	{
		 s result = ##class(EMRservice.dataset.EALLICDDiagnos).%New()
	     d result.SetArgs(Code)
	}
	elseif (DicType = "SSLAN")
	{
		 Set result=##class(%XML.DataSet).%New("EMRservice.TemplatePriv.BORuleType:SelectAllLanage")
	}

	
	Quit result
}

Query SelectAllSex() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CTSEX_Code,CTSEX_Desc From SQLUser.CT_Sex Order By CTSEX_Code
}

Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String,HosID:%String,HosName:%String")
{
SELECT CTLOC_CODE,CTLOC_Desc,CTLOC_Hospital_DR->HOSP_RowId,CTLOC_Hospital_DR->HOSP_Desc From SQLUser.CT_Loc  Order By CTLOC_Desc,CTLOC_RowId
}

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String,HosID:%String,HosName:%String")
{
SELECT CTLOC_RowId,CTLOC_Desc,CTLOC_Hospital_DR->HOSP_RowId,CTLOC_Hospital_DR->HOSP_Desc From SQLUser.CT_Loc WHERE CTLOC_Type IN ('E','W','OP','EM') Order By CTLOC_Desc,CTLOC_RowId
}

Query SelectAllWard() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String,HosID:%String,HosName:%String")
{
SELECT WARD_Code,WARD_Desc,c.CTLOC_Hospital_DR->HOSP_RowId,c.CTLOC_Hospital_DR->HOSP_Desc 
FROM SQLUser.PAC_Ward w JOIN SQLUser.CT_Loc c ON w.WARD_LocationDR =c.CTLOC_RowID ORDER BY WARD_Desc,WARD_RowID
}

Query SelectAllWardRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String,HosID:%String,HosName:%String")
{
SELECT WARD_RowID,WARD_Desc,c.CTLOC_Hospital_DR->HOSP_RowId,c.CTLOC_Hospital_DR->HOSP_Desc 
FROM SQLUser.PAC_Ward w JOIN SQLUser.CT_Loc c ON w.WARD_LocationDR =c.CTLOC_RowID ORDER BY WARD_Desc,WARD_RowID
}

/// remove 'WHERE CtmDictID IS NOT NULL ' gaojb 2010-3-5 for common patient type link no depts
/// add "Distinct" by houj on 2010-04-07 sugguested by wangwt --- 解决“治疗组”的问题
Query SelectAllType() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT Distinct CtmDictCode,CtmDictDesc From EMRview.PatType Order By CtmDictCode
}

Query SelectAllPriv() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CtmDictCode,CtmDictDesc From EMRview.PatPriv Order By CtmDictCode
}

Query SelectAllUserLevel() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT Name,Description From EMRmeta.UserLevel Order By Name
}

// w ##Class(%ResultSet).RunQuery("EMRservice.TemplatePriv.BORuleType","GetAllDiagnos","S12")

Query GetAllDiagnos(ADicCode As %String) As %Query(ROWSPEC = "Alias,DicDesc,Code,ID")
{
}

ClassMethod GetAllDiagnosExecute(ByRef qHandle As %Binary, ADicCode As %String) As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")			
		
		//get and  validate date of the ICD item.  yejian
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate>dateTo)))
		
		//校验ICD10,过滤门诊诊断 
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(flagCode="")||($e(flagCode,1,2) = "MZ")
				
		s Alias=$g(^MRC("ID",rowid,"ALIAS",1))
		//s Code=$g(^MRC("ID",rowid,"ALIAS",2))
		s Code=$p($g(^MRC("ID",rowid)),"^",4)
		if (Code ="")	continue
		s DicDesc=$p($g(^MRC("ID",rowid)),"^",2)
		
		s Data = $LB(Alias,DicDesc,Code,rowid)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1			
	}		
	q $$$OK
}

ClassMethod GetAllDiagnosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDiagnosExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAllDiagnosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDiagnosExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query SelectAllLanage() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{

SELECT CTLAN_CODE,CTLAN_DESC FROM SQLUser.SS_Language
}

}
