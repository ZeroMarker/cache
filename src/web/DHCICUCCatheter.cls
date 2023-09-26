/// 导管相关基础数据处理类
Class web.DHCICUCCatheter Extends %RegisteredObject
{

ClassMethod SaveCatheterCategory(rowId, code, description) As %String
{
	quit:code="" "E^代码不能为空"
	quit:description="" "E^描述不能为空"
	
	if +rowId set saveObj=##class(User.DHCICUCCatheterCategory).%OpenId(rowId)
	else  set saveObj=##class(User.DHCICUCCatheterCategory).%New()
	
	set saveObj.Code=code
	set saveObj.Description=description

	set sc=saveObj.%Save()
	set DataRowId=saveObj.%Id()
	quit +saveObj.%Id()
}

ClassMethod RemoveCatheterCategory(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	
	set status=##class(User.DHCICUCCatheterCategory).%DeleteId(rowId)
	quit 0
}

Query FindCatheterCategory() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from SQLUser.dhc_icuc_cathetercategory
}

ClassMethod SaveCatheterPosition(rowId, code, description) As %String
{
	quit:code="" "E^代码不能为空"
	quit:description="" "E^描述不能为空"
	
	if +rowId set saveObj=##class(User.DHCICUCCatheterPos).%OpenId(rowId)
	else  set saveObj=##class(User.DHCICUCCatheterPos).%New()
	
	set saveObj.Code=code
	set saveObj.Description=description

	set sc=saveObj.%Save()
	set DataRowId=saveObj.%Id()
	quit +saveObj.%Id()
}

ClassMethod RemoveCatheterPosition(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	
	set status=##class(User.DHCICUCCatheterPos).%DeleteId(rowId)
	quit 0
}

Query FindCatheterPosition() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from SQLUser.DHC_ICUC_CatheterPos
}

ClassMethod SaveCatheter(rowId, code, description, category, defaultPos) As %String
{
	quit:code="" "E^代码不能为空"
	quit:description="" "E^描述不能为空"
	
	if +rowId set saveObj=##class(User.DHCICUCCatheter).%OpenId(rowId)
	else  set saveObj=##class(User.DHCICUCCatheter).%New()
	
	set saveObj.Code=code
	set saveObj.Description=description
	set saveObj.Category=##class(User.DHCICUCCatheterCategory).%OpenId(category)
	set saveObj.DefaultPos=""
	set:defaultPos>0 saveObj.DefaultPos=##class(User.DHCICUCCatheterPos).%OpenId(defaultPos)

	set sc=saveObj.%Save()
	set DataRowId=saveObj.%Id()
	quit +saveObj.%Id()
}

ClassMethod RemoveCatheter(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	
	set status=##class(User.DHCICUCCatheter).%DeleteId(rowId)
	quit 0
}

/// w ##class(web.DHCICUCCatheter).FindCatheter(210)
/// d ##class(%ResultSet).RunQuery("web.DHCICUCCatheter","FindCatheter","210")
Query FindCatheter(locId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
			Category->Description As CategoryDesc,
			DefaultPos->Description As DefaultPosDesc
	from SQLUser.DHC_ICUC_Catheter
	where Category in (select CatheterCategory from SQLUser.DHC_ICUC_DeptCatheterCat where DeptID=:locId
	and (Status='Enable' or Status is null))
}

/// w ##class(web.DHCICUCCatheter).FindCatheter(210)
/// d ##class(%ResultSet).RunQuery("web.DHCICUCCatheter","FindCatheterNew","6","")
/// d ##class(%ResultSet).RunQuery("web.DHCICUCCatheter","FindCatheterNew","","210")
/// d ##class(%ResultSet).RunQuery("web.DHCICUCCatheter","FindCatheterNew","6","210")
/// d ##class(%ResultSet).RunQuery("web.DHCICUCCatheter","FindCatheterNew","","210")
Query FindCatheterNew(CatId, locId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
			Category->Description As CategoryDesc,
			DefaultPos->Description As DefaultPosDesc
	from SQLUser.DHC_ICUC_Catheter
	where ((:CatId is null) or (Category=:CatId)) and ((:locId is null) or (Category in (select CatheterCategory from SQLUser.DHC_ICUC_DeptCatheterCat where DeptID=:locId)))
}

}
