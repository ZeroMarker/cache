Include webimport

IncludeGenerator webimport

/// Log 28554 - AI - 27-02-2003 : Created class to perform basic lookups.
Class web.MRCAllType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

Parameter SQLDATEFROM = "MRCAT_DateFrom";

Parameter SQLDATETO = "MRCAT_DateTo";

Parameter SQLCODE = "MRCAT_Code";

Parameter SQLDESCRIPTION = "MRCAT_Desc";

Parameter SQLROWID = "MRCAT_RowId";

/// Log 39206 - AI - 18-09-2003 : Added filter to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((MRCAT_DateFrom <= CURRENT_DATE OR MRCAT_DateFrom IS NULL) AND (MRCAT_DateTo >= CURRENT_DATE OR MRCAT_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpTagBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String, tag As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpTagClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpTagFetch ]
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// cjb 20/04/2005 51228 - new query.  written in cache
/// zhouzq 2011-07-16 查找过敏分类
/// d ##class(%ResultSet).RunQuery("web.MRCAllType","LookUpTag","0","","")
ClassMethod LookUpTagExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, tag As %Library.String = "", date As %Library.String = "") As %Library.Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	
	n rowid,catCode,catDesc,catTag
	s datefrom=+$h
	i date'="" {
		///不知什么格式
	}
	s rowid=0
	f  {
		s rowid=$o(^MRC("AT",rowid))
		q:rowid=""
		s catCode=$P($g(^MRC("AT",rowid)),"^",1)
		s catDesc=$P($g(^MRC("AT",rowid)),"^",2)
		s catTag=$P($g(^MRC("AT",rowid)),"^",6)
		s catDateFrom=$P($g(^MRC("AT",rowid)),"^",9)
		s catTagDesc=""
		i (catTag="P")!(catTag="G")!(catTag="I") s catTagDesc=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",catTag)
		Q:(catDateFrom'="")&&(catDateFrom>datefrom)
		i (catDesc[desc)&&((catTagDesc=tag)||(tag="")){
			s ind=ind+1
			Set ^CacheTemp(repid,ind)=$lb(catDesc,rowid,catCode,catTagDesc,catTag)
		}
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpTagFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpTagExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// cjb 20/04/2005 51228 - new query.  written in cache
Query LookUpTag(desc As %String, tag As %String, date As %Date = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Tag:%String,HIDDEN:%String")
{
}

/// 过敏记录中date没传时,查询不出数据
/// ((MRCAT_DateFrom<=:date)OR(MRCAT_DateFrom iS NULL)) AND  
/// cjb 20/04/2005 51228 - new query.  filter by Tag
Query LookUpByTag(desc As %String, tag As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
	SELECT MRCAT_Desc, MRCAT_RowId, MRCAT_Code, MRCAT_TagDescription
	FROM MRC_AllType
	WHERE (%ALPHAUP MRCAT_Desc %STARTSWITH %ALPHAUP :desc) AND ((MRCAT_TagDescription = :tag) OR (:tag IS NULL)) AND
 	  	((MRCAT_DateTo>=:date) OR (MRCAT_DateTo iS NULL))
}

}
