Class EPRservice.TemplatePriv.BORuleType Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.BORuleType";

/*
ClassMethod GetRuleTypeDetails(parDicId As %String) As %XML.DataSet [ WebMethod ]
{
 q:($d(parDicId)=0 || parDicId = "") ""
 
 &SQL(Select TableName,DicCodeCol,DicDescCol
 into :tableName,:dicCodeCol,:dicDescCol
 From EPRmeta.StdDictionary where ID = :parDicId)
 
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
/// ##Class(EPRservice.TemplatePriv.BORuleType).GetRuleTypeDetails()
ClassMethod GetRuleTypeDetails(parDicId As %String) As %XML.DataSet [ WebMethod ]
{
	q:($d(parDicId)=0 || parDicId = "") ""
	s DicType = "", DicCode = ""
	&SQL(select RuleTypeTag, DicCodeCol into :DicType, :DicCode from EPRmeta.StdDictionary where ID=:parDicId)
	
	Set result = ""
	if (DicType = "PATSEX")
	{
		Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllSex")
	}
	elseif (DicType = "PATDEPT")
	{
		if ($zcvt(DicCode,"U") = "CTLOC_CODE")
		{	Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllLoc")}
		elseif ($zcvt(DicCode,"U") = "CTLOC_ROWID")
		{	Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllLocRowId")}
	}
	elseif (DicType = "PATWARD")
	{
		if ($zcvt(DicCode,"U") = "WARD_CODE")
		{	Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllWard")}
		elseif ($zcvt(DicCode,"U") = "WARD_ROWID")
		{	Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllWardRowId")}
	}
	elseif (DicType = "PATTYPE")
	{
		Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllType")
	}
	elseif (DicType = "PATPRIV")
	{
		Set result=##class(%XML.DataSet).%New("EPRservice.TemplatePriv.BORuleType:SelectAllPriv")
	}
	
	Quit result
}

Query SelectAllSex() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CTSEX_Code,CTSEX_Desc From SQLUser.CT_Sex Order By CTSEX_Code
}

Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CTLOC_CODE,CTLOC_Desc From SQLUser.CT_Loc Order By CTLOC_Desc,CTLOC_RowId
}

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CTLOC_RowId,CTLOC_Desc From SQLUser.CT_Loc WHERE CTLOC_Type IN ('E','W','OP','EM') Order By CTLOC_Desc,CTLOC_RowId
}

Query SelectAllWard() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT WARD_Code,WARD_Desc FROM SQLUser.PAC_Ward ORDER BY WARD_Desc,WARD_RowID
}

Query SelectAllWardRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT WARD_RowID,WARD_Desc FROM SQLUser.PAC_Ward ORDER BY WARD_Desc,WARD_RowID
}

/// remove 'WHERE CtmDictID IS NOT NULL ' gaojb 2010-3-5 for common patient type link no depts
/// add "Distinct" by houj on 2010-04-07 sugguested by wangwt --- 解决“治疗组”的问题
Query SelectAllType() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT Distinct CtmDictCode,CtmDictDesc From EPRview.PatType Order By CtmDictCode
}

Query SelectAllPriv() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Des:%String")
{
SELECT CtmDictCode,CtmDictDesc From EPRview.PatPriv Order By CtmDictCode
}

}
