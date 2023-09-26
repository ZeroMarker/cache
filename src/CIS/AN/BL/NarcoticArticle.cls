Class CIS.AN.BL.NarcoticArticle Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedDrug")
Query FindNarcoticArticle(filterDesc As %String = "", articleType As %String = "", reservation As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   ArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',ArcimID) As ArcimDesc,
	   Description,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpiredDate) As ExpiredDate,
	   ArticleType,
	   %EXTERNAL(ArticleType) As ArticleTypeDesc,
	   EditFlag,
	   UpdateUser,
	   %ODBCOUT(UpdateDate)_' '_%ODBCOUT(UpdateTime) As UpdateDT,
	   Reservation,
	   %EXTERNAL(Reservation) As ReservationDesc,
	   0 As PackQty,
	   Uom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',Uom) As UomDesc
	   from CF_AN.NarcoticArticle
	   where ((UPPER(Description) [ UPPER(:filterDesc)) or (:filterDesc is null))
	   and ((UPPER('^'_:articleType_'^') [ UPPER('^'+ArticleType+'^')) or (:articleType is null))
	   and (Reservation=:reservation or :reservation is null)
}

}
