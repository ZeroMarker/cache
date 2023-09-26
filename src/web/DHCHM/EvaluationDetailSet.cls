Class web.DHCHM.EvaluationDetailSet Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

/// Debug：d ##class(%ResultSet).RunQuery("web.DHCHM.EvaluationDetailSet","FindEVADetail","","","","","","2")
Query FindEVADetail(Code As %String = "", Desc As %String = "", Type As %String = "", Sex As %String = "", Active As %String = "", aSubjectID As %String = "") As %Query(ROWSPEC = "EDID:%String:ID,EDActive:%String:EDActive,EDCode:%String:EDCode,EDDataSource:%String:EDDataSource,EDDesc:%String:EDDesc,EDNote:%String:EDNote,EDSex:%String:EDSex,EDType:%String:EDType,EDUnit:%String:EDUnit,EDRelateCode:%String,EDClassName:%String,EDMethodName:%String,EDExpression:%String,EDSort:%String,EDUpdateDate:%String,EDUpdateTime:%String")
{
}

ClassMethod FindEVADetailExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "", Sex As %String = "", Active As %String = "", aSubjectID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	Quit:aSubjectID="" $$$OK
	
	if Code'=""
	{
	s Code=$zcvt(Code,"u")
	s Code=" "_Code
	s tcode=$o(^User.DHCHMCEvaluationDetailI("EDCodeIndex",Code),-1)
	f  s tcode=$o(^User.DHCHMCEvaluationDetailI("EDCodeIndex",tcode)) q:(tcode="")||(tcode'[Code)  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCEvaluationDetailI("EDCodeIndex",tcode,ID))  quit:ID=""  d
	..d BuildDataFindEVADetail
	}
	else
	{s ID=0
	f  s ID=$o(^User.DHCHMCEvaluationDetailD(ID)) quit:ID=""  d
	.d BuildDataFindEVADetail
	}
	Quit $$$OK
BuildDataFindEVADetail
	d ResetVariablesFindEVADetail
	s obj=##class(User.DHCHMCEvaluationDetail).%OpenId(ID)
	d obj.%Close()
	q:'$IsObject(obj.EDCQDSubjectDR)
	s SubjectID=obj.EDCQDSubjectDR.%Id()
	q:(aSubjectID'="")&&(aSubjectID'=SubjectID)
	s EDActive = obj.EDActive
	i EDActive = "Y" s EDActive = "true"
	e  s EDActive = "false"
	s EDCode = obj.EDCode
	s EDDataSource = obj.EDDataSource
	s EDDesc = obj.EDDesc
	q:(Desc'="")&&(EDDesc'[Desc)
	s EDNote = obj.EDNote
	s EDSex = obj.EDSex
	s EDType = obj.EDType
	s EDUnit = obj.EDUnit
	s EDRelateCode = obj.EDRelateCode
	s EDClassName = obj.EDClassName
	s EDMethodName = obj.EDMethodName
	s EDExpression = obj.EDExpression
	s EDSort=obj.EDSort
	s EDUpdateDate=obj.EDUpdateDate
	s EDUpdateTime=obj.EDUpdateTime
	i EDUpdateDate'="" s EDUpdateDate=##class(websys.Conversions).DateLogicalToHtml(EDUpdateDate)
    i EDUpdateTime'="" s EDUpdateTime=##class(websys.Conversions).TimeLogicalToHtml(EDUpdateTime)
	d OutputRowFindEVADetail
	quit
OutputRowFindEVADetail
	s Data=$lb(ID,EDActive,EDCode,EDDataSource,EDDesc,EDNote,EDSex,EDType,EDUnit,EDRelateCode,EDClassName,EDMethodName,EDExpression,EDSort,EDUpdateDate,EDUpdateTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindEVADetail
	s (EDActive,EDCode,EDDataSource,EDDesc,EDNote,EDSex,EDType,EDUnit,EDRelateCode,EDClassName,EDMethodName)=""
	quit
}

ClassMethod FindEVADetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEVADetailExecute ]
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

ClassMethod FindEVADetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEVADetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EDSave(id, value, property)
{
	s property = property_"^EDUpdateDate^EDUpdateTime"
	s value = value_"^"_+$H_"^"_$P($H,",",2)
	set ret=##class(User.DHCHMCEvaluationDetail).SaveData(id,value,property)
	q ret
}

}
