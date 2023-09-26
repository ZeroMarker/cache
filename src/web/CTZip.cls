Include webimport

IncludeGenerator webimport

Class web.CTZip Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 414;

Parameter SQLCODE = "CTZIP_Code";

Parameter SQLDATEFROM = "CTZIP_DateFrom";

Parameter SQLDESCRIPTION = "CTZIP_Code";

Parameter SQLDATETO = "CTZIP_DateTo";

Parameter SQLROWID = "CTZIP_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTZIP_DateFrom <= CURRENT_DATE OR CTZIP_DateFrom IS NULL) AND (CTZIP_DateTo >= CURRENT_DATE OR CTZIP_DateTo IS NULL))";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetIdFromZipAndCity(zipcode As %String = "", citydesc As %String = "")
{
}

ClassMethod LookUpBrokerUnique(itmjs As %Library.String = "", itmjsex As %Library.String = "", zipdesc As %Library.String = "", citydesc As %Library.String = "", date As %Date = "", provdesc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpWithCityProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithCityProvFetch ]
{
}

ClassMethod LookUpWithCityProvExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, city As %Library.String, date As %Date = "", prov As %Library.String) As %Library.Status
{
}

ClassMethod LookUpWithCityProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithCityProvExecute ]
{
}

ClassMethod LookUpWithCityDescClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithCityDescFetch ]
{
}

ClassMethod LookUpWithCityDescExecute(ByRef QHandle As %Library.Binary, text As %Library.String, code As %Library.String, city As %Library.String, prov As %Library.String) As %Library.Status
{
}

ClassMethod LookUpWithCityDescFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithCityDescExecute ]
{
}

Query LookUpByCity(city As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "City:%Library.String,ZipCode:%Library.String,HIDDEN:%Library.String,prov:%String")
{
SELECT CTZIP_City_DR->CTCIT_Desc, CTZIP_Code, CTZIP_City_DR, CTZIP_Province_DR->PROV_Desc
FROM CT_Zip
WHERE CTZIP_City_DR IN
 (
 SELECT CTCIT_ROWID
 FROM	CT_City
 WHERE	CTCIT_Desc %STARTSWITH :city
 )
}

Query LookUpByCityArea(cityarea As %String, date As %Date = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "City:%String,ZIP:%String,CityArea:%String,Province:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT 	CTZIP_City_DR->CTCIT_Desc, CTZIP_Code, CTZIP_CITYAREA_DR->CITAREA_Desc, CTZIP_Province_DR->PROV_Desc, CTZIP_City_DR, CTZIP_CITYAREA_DR, CTZIP_Province_DR
	FROM SQLUser.CT_Zip
	WHERE CTZIP_CITYAREA_DR IN
	(
	SELECT CITAREA_ROWID
	FROM SQLUser.CT_CityArea
	WHERE CITAREA_Desc %STARTSWITH :cityarea
	)
	AND (((CTZIP_DateFrom  <= :date) OR (CTZIP_DateFrom  IS NULL)) 
	AND ((CTZIP_DateTo >= :date) OR (CTZIP_DateTo  IS NULL)))
}

ClassMethod LookUpCityAreaBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", cdate As %String = {+$h}) As %Library.Boolean
{
}

/// returns suburb (city) and zip
Query LookUpByZipCity(desc As %Library.String, city As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "City:%Library.String,ZIP:%Library.String,HIDDEN:%Library.String")
{
SELECT CTZIP_City_DR->CTCIT_Desc, CTZIP_Code,  CTZIP_City_DR
FROM CT_Zip
WHERE (CTZIP_Code %STARTSWITH :desc)
}

Query LookUpWithCityProv(desc As %String, city As %String, date As %Date = "", prov As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "code,city,prov,hidden,hidden,desc,hidden,hidden,remark,hca")
{
}

Query LookUpWithCityDesc(text As %String, code As %String, city As %String, prov As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "code,descn,prov,cit,cityarea,hca,region")
{
}

}
