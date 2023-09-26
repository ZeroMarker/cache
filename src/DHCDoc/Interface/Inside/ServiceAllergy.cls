/// Creator:      李旭
/// CreatDate:    2022.01.11
/// Description:  患者过敏记录信息相关的接口类
Class DHCDoc.Interface.Inside.ServiceAllergy Extends %RegisteredObject
{

Query PatAllergyList(AdmID) As %Query(ROWSPEC = "RowID,CategoryCode::分类代码,Category::分类,AllergenCode::过敏源代码,Allergen::过敏原,ALGItem::过敏项目,ALGTag::过敏类型,ALGStatus::状态,ALGInActive::未激活标志,ALGCheckConflict::冲突检测是否开启,OnsetDate::发作日期,ALGUpdateUserDR::最后更新用户ID,UpdateUserCode::最后更新用户工号,UpdateUserDesc::最后更新用户,ALGLastUpdateDate::最后更新日期,ALGLastUpdateTime::最后更新时间,ALGComments::注释") [ SqlProc ]
{
}

/// Desc：通过就诊ID获取过敏记录信息
/// Input：AdmID:就诊ID
/// Output：RowID:ID,CategoryCode:分类代码,Category:分类,AllergenCode:过敏源代码,Allergen:过敏原,ALGItem:过敏项目,ALGTag:过敏类型,ALGStatus:状态,ALGInActive:未激活标志,ALGCheckConflict:冲突检测是否开启,OnsetDate:发作日期,ALGUpdateUserDR:最后更新用户ID,UpdateUserCode:最后更新用户工号,UpdateUserDesc:最后更新用户,ALGLastUpdateDate:最后更新日期,ALGLastUpdateTime:最后更新时间,ALGComments:注释
/// debugger：d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.ServiceAllergy","PatAllergyList","195")
ClassMethod PatAllergyListExecute(ByRef qHandle As %Binary, AdmID) As %Status
{
    s ^templx("PatAllergyList")=$lb(AdmID)
    s ind=1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s PatID=$p(^PAADM(AdmID),"^",1)
    q:PatID="" $$$OK
    
    s SubID=0
    for {
		s SubID=$o(^PAPER(PatID,"ALG",SubID))
		q:SubID=""
		d ResetNull
		s RowID=PatID_"||"_SubID
		s AllergyInfo=$g(^PAPER(PatID,"ALG",SubID))

		;通用项过敏源
		s ALGPHCGEDR=$p(AllergyInfo,"^",4)
		i ALGPHCGEDR'="" d
		.s ALGItem=$p(^PHCGE("GE",ALGPHCGEDR),"^",2)
		.s ALGTag="G"
		;药学过敏源
		s ALGPHCDMDR=$p(AllergyInfo,"^",27)
		.s ALGItem=$p(^PHCD(ALGPHCDMDR,1),"^",2)
		.s ALGTag="P"		
		s ALGIngredDR=$p(AllergyInfo,"^",32)
		i ALGIngredDR'="" d
		.s ALGItem=$p(^PHC("INGR",ALGIngredDR),"^",2)
		.s ALGTag="I"
		;过敏类型
		s ALGTag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",ALGTag)

		;医嘱项ID
		i ALGItem="" d
		.s ALGExternalID=$p(AllergyInfo,"^",30)
		.i ALGExternalID["||" d
		..s ALGItemID=ALGExternalID
		..s ALGItem=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
		.e  i ALGExternalID'="" d
		..s ALGItem=ALGExternalID
		..s ALGItemID=ALGExternalID
		
		;分类
		s ALGMRCAllTypeDR=$p(AllergyInfo,"^",29)
		i ALGMRCAllTypeDR'="" d
		.s CategoryCode=$p(^MRC("AT",ALGMRCAllTypeDR),"^",1)
		.s Category=$p(^MRC("AT",ALGMRCAllTypeDR),"^",2)
		;过敏原
		s ALGTypeDR=$p(AllergyInfo,"^",9)
		i ALGTypeDR'="" d
		.s AllergenCode=$p(^PAC("ALG",ALGTypeDR),"^",1)
		.s Allergen=$p(^PAC("ALG",ALGTypeDR),"^",2)
		
		;发作日期
		s ALGOnsetDate=$p(AllergyInfo,"^",14)
		s OnsetDate=##class(websys.Conversions).DateLogicalToHtml(ALGOnsetDate)		
		;更新日期和更新人
		s ALGUpdateUserDR=$p(AllergyInfo,"^",16)
		i ALGUpdateUserDR'="" d
		.s UpdateUserCode=$p(^SSU("SSUSR",ALGUpdateUserDR),"^",1)
		.s UpdateUserDesc=$p(^SSU("SSUSR",ALGUpdateUserDR),"^",2)
		s ALGLastUpdateDate=$p(AllergyInfo,"^",23)
		s ALGLastUpdateDate=##class(websys.Conversions).DateLogicalToHtml(ALGLastUpdateDate)
		s ALGLastUpdateTime=$p(AllergyInfo,"^",24)
		s:ALGLastUpdateTime'="" ALGLastUpdateTime=$zt(ALGLastUpdateTime,1)
		;状态
		s ALGStatus=$p(AllergyInfo,"^",8)
		s ALGStatus=$case(ALGStatus,"A":"Active","I":"Inactive",:"")
		;未激活标志
		s ALGInActive=$p(AllergyInfo,"^",19)
		s ALGCheckConflict=$P($g(^PAPER(PatID,"ALG",SubID,"DHC")),"^",3)
		s ALGCheckConflict=$case(ALGCheckConflict,"Y":"是",:"否")
		s CommentSub=$g(^PAPER(PatID,"ALG",SubID,"CMT",0))
		s:CommentSub'="" ALGComments=$g(^PAPER(PatID,"ALG",SubID,"CMT",CommentSub))
		s ALGComments=$tr(ALGComments,$c(10,13),"")
		
		d PatAllergyListOut
	}
    
    q $$$OK
    
ResetNull
	s (RowID,CategoryCode,Category,AllergenCode,Allergen,ALGItem,ALGTag,ALGStatus,ALGInActive,ALGCheckConflict,OnsetDate,ALGUpdateUserDR,UpdateUserCode,UpdateUserDesc,ALGLastUpdateDate,ALGLastUpdateTime,ALGComments)=""
	q ""
PatAllergyListOut    	
	s Data=$lb(RowID,CategoryCode,Category,AllergenCode,Allergen,ALGItem,ALGTag,ALGStatus,ALGInActive,ALGCheckConflict,OnsetDate,ALGUpdateUserDR,UpdateUserCode,UpdateUserDesc,ALGLastUpdateDate,ALGLastUpdateTime,ALGComments)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q ""
}

ClassMethod PatAllergyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatAllergyListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PatAllergyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatAllergyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                
		Set AtEnd=1
		Set Row=""
	}Else {         
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
