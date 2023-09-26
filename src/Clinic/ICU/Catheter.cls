Import SQLUSER

Class Clinic.ICU.Catheter Extends %RegisteredObject
{

/// w ##class(Clinic.ICU.Catheter).SaveCatheter()
ClassMethod SaveCatheter(rowId, code, description, category, defaultPos, recordItem) As %String
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
	set saveObj.RecordItem=##class(User.DHCICUCRecordItem).%OpenId(recordItem)
	
	set sc=saveObj.%Save()
	set DataRowId=saveObj.%Id()
	quit +saveObj.%Id()
}

/// w ##class(Clinic.ICU.Catheter).RemoveCatheterOld(404)
ClassMethod RemoveCatheterOld(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	set status=##class(User.DHCICUCCatheter).%DeleteId(rowId)
	quit 0
}

/// w ##class(Clinic.ICU.Catheter).RemoveCatheter(404)
ClassMethod RemoveCatheter(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	set obj=##class(User.DHCICUCCatheter).%OpenId(rowId)
	set obj.Status="Disable"
	set sc=obj.%Save()
	quit 0
}

/// w ##class(Clinic.ICU.Catheter).RemoveCatheter(404)
ClassMethod ActiveCatheter(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	set obj=##class(User.DHCICUCCatheter).%OpenId(rowId)
	set obj.Status="Enable"
	set sc=obj.%Save()
	quit 0
}

/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindCatheter","","","","Y")
/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindCatheter","","","","Disable")
Query FindCatheter(CatId, locId, CatherDesc, status = "Y") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
			Category As CategoryID,
			Category->Description As CategoryDesc,
			DefaultPos As DefaultPosID,
			DefaultPos->Description As DefaultPosDesc,
			RecordItem As RecordItemID,
			RecordItem->ICUCRI_Desc As LinkRecordItem,
			RecordItem->ICUCRI_ViewCat_Dr As LinkRecordItemCatID,
			(select ICUCVC_Desc from SQLUser.DHC_ICUC_ViewCat
			 where ICUCVC_RowId=RecordItem->ICUCRI_ViewCat_Dr) As LinkRecordItemCat,
			Status As Status
	from SQLUser.DHC_ICUC_Catheter
	where ((:CatId is null) or (Category=:CatId)) 
		and ((:locId is null) or (Category in (select CatheterCategory from SQLUser.DHC_ICUC_DeptCatheterCat where DeptID=:locId)))
		and ((:CatherDesc is null) or (Description[:CatherDesc))
		and ((((Status is null) or (Status="Enable")) and (:status="Y"))
		or ((Status="Disable") and (:status="N")))
}

/// 导管分类相关方法20220615
Query FindCatheterCategory() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from SQLUser.dhc_icuc_cathetercategory
}

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

/// 导管部位相关方法20220615
Query FindCatheterPosition() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from SQLUser.DHC_ICUC_CatheterPos
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

/// 科室关联导管分类相关方法20220615
/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindDeptCatheterCat")
Query FindDeptCatheterCat(locId As %String, catheterCategoryId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * ,
		DeptID As DeptID,
		(SELECT CTLOC_Desc FROM SQLUser.CT_Loc where CTLOC_RowID=DeptID) As DeptDesc,
		CatheterCategory As CatId,
		CatheterCategory->Description As CatDesc
		from SQLUser.DHC_ICUC_DeptCatheterCat
		where ((:locId is null) or ((:locId is not null) and (DeptID=:locId)))
		and ((:catheterCategoryId is null) or ((:catheterCategoryId is not null) and (CatheterCategory=:catheterCategoryId)))
}

/// w ##class(Clinic.ICU.Catheter).SaveDeptCatheterCat(210,10)
ClassMethod SaveDeptCatheterCat(Location, Category) As %String
{
	quit:Location="" "科室不能为空"
	quit:Category="" "分类不能为空"
	set rowId=""
	&sql(SELECT RowId into rowId FROM SQLUSER.DHC_ICUC_DeptCatheterCat
	 where DeptID=:Location and CatheterCategory=:Category)
	quit:(+rowId) "该科室与该分类已经关联，无需重新关联！"
	
	set saveObj=##class(User.DHCICUCDeptCatheterCat).%New()
	set saveObj.DeptID=Location
	set saveObj.CatheterCategory=##class(User.DHCICUCCatheterCategory).%OpenId(Category)
	set sc=saveObj.%Save()
	quit 0
}

/// w ##class(Clinic.ICU.Catheter).ModifyDeptCatheterCat(15,210,6)
/// w ##class(Clinic.ICU.Catheter).ModifyDeptCatheterCat(15,210,5)
ClassMethod ModifyDeptCatheterCat(rowId, Location, Category) As %String
{
	quit:Location="" "科室不能为空"
	quit:Category="" "分类不能为空"
	set selectId=""
	&sql(SELECT RowId into selectId FROM SQLUSER.DHC_ICUC_DeptCatheterCat
	 where DeptID=:Location and CatheterCategory=:Category and RowId<>:rowId)
	quit:(+selectId) "该科室与该分类已经关联，无需重新关联！"
	
	set saveObj=##class(User.DHCICUCDeptCatheterCat).%OpenId(rowId)
	set saveObj.DeptID=Location
	set saveObj.CatheterCategory=##class(User.DHCICUCCatheterCategory).%OpenId(Category)
	set sc=saveObj.%Save()
	quit 0
}

ClassMethod RemoveDeptCatheterCat(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	set status=##class(User.DHCICUCDeptCatheterCat).%DeleteId(rowId)
	quit 0
}

/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindRecordItem","体温")
Query FindRecordItem(RDesc As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 
	select 
		ICUCRI_RowId As RowId,
		ICUCRI_Code As Code,
		(ICUCRI_Desc)_"-"_(ICUCRI_Code)_"-"_(select ICUCVC_Desc from SQLUser.DHC_ICUC_ViewCat
		 where ICUCVC_RowId=ICUCRI_ViewCat_Dr) As Description,
		ICUCRI_ViewCat_Dr As CatId,
		(select ICUCVC_Desc from SQLUser.DHC_ICUC_ViewCat
		 where ICUCVC_RowId=ICUCRI_ViewCat_Dr) As Cat
			
	from SQLUser.DHC_ICUC_RecordItem
	where ((:RDesc is null) or (ICUCRI_Desc[:RDesc))
}

/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindCTLoc","")
Query FindCTLoc(Desc As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select 
		CTLOC_RowID As id,
		CTLOC_Desc As text
	from SQLUser.CT_Loc
	where CTLOC_RowID=(
		SELECT WARD_LocationDR FROM SQLUser.PAC_Ward where WARD_RowID=(
			SELECT BED_WARD_ParRef FROM PAC_Bed WHERE BED_BedType_DR->BEDTP_ICUFlag="Y"))
	and ((:Desc is null) or (CTLOC_Desc[:Desc))
}

/// 查询ICU科室
/// d ##class(%ResultSet).RunQuery("Clinic.ICU.Catheter","FindICULoc") 
Query FindICULoc() As %Query(ROWSPEC = "ctlocId,ctlocDesc")
{
}

ClassMethod FindICULocExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 
  	s locId=""
 	f  s locId=$o(^DHCICUPara(0,"Ctloc",locId)) q:locId=""  d
	    .s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",locId,""))
	    .q:'$d(^DHCICUPara(tIcuParaId))
	    .s tDeptID=$p(^DHCICUPara(tIcuParaId),"^",2)
	    .q:tDeptID=""
	    .s tDeptName=$p($g(^CTLOC(+tDeptID)),"^",2)
	    .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tDeptID,tDeptName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICULocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICULocExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindICULocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICULocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
