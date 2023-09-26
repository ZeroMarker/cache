Class web.DHCHM.QuestionnaireSet Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionnaireSet","FindQuestion") 
Query FindQuestion() As %Query(ROWSPEC = "QNID:%String:ID,QActive:%String:QActive,QCode:%String:QCode,QDesc:%String:QDesc,QRemark:%String:QRemark,QType:%String:QType")
{
}

ClassMethod FindQuestionExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionnaireD(ID))  quit:ID=""  d
	.d BuildDataFindQuestion
	Quit $$$OK
BuildDataFindQuestion
	d ResetVariablesFindQuestion
	s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
	s QActive = obj.QActive
	i QActive = "Y" s QActive = "true"
	e  s QActive = "false"
	s QCode = obj.QCode
	s QDesc = obj.QDesc
	s QRemark = obj.QRemark
	s QType = obj.QType
	d OutputRowFindQuestion
	quit
OutputRowFindQuestion
	s Data=$lb(ID,QActive,QCode,QDesc,QRemark,QType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQuestion
	s (QActive,QCode,QDesc,QRemark,QType)=""
	quit
}

ClassMethod FindQuestionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuestionExecute ]
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

ClassMethod FindQuestionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuestionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindQSubject(ParRef) As %Query(ROWSPEC = "QSID:%String:ID,QSActive:%String:QSActive,QSCode:%String:QSCode,QSDesc:%String:QSDesc,QSOrder:%String:QSOrder,QSRemark:%String:QSRemark,QSSex:%String,QSDocFlag:%String,QSMinAge:%String,QSMaxAge:%String")
{
}

ClassMethod FindQSubjectExecute(ByRef qHandle As %Binary, ParRef) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Sub=0
	f  s Sub=$o(^User.DHCHMCQuestionnaireD(ParRef,"QSubject",Sub))  quit:Sub=""  d
	.s ID=ParRef_"||"_Sub
	.d BuildDataFindQSubject
	Quit $$$OK
BuildDataFindQSubject
	d ResetVariablesFindQSubject
	s obj=##class(User.DHCHMCQuestionSubject).%OpenId(ID)
	s QSActive = obj.QSActive
	i QSActive = "Y" s QSActive = "true"
	e  s QSActive = "false"
	s QSCode = obj.QSCode
	s QSDesc = obj.QSDesc
	s QSOrder = obj.QSOrder
	s QSRemark = obj.QSRemark
	s QSSex = obj.QSSex
	s QSDocFlag = obj.QSDocFlag
	s QSMinAge = obj.QSMinAge
	s QSMaxAge = obj.QSMaxAge
	d OutputRowFindQSubject
	quit
OutputRowFindQSubject
	s Data=$lb(ID,QSActive,QSCode,QSDesc,QSOrder,QSRemark,QSSex,QSDocFlag,QSMinAge,QSMaxAge)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQSubject
	s (QSActive,QSCode,QSDesc,QSOrder,QSRemark,QSSex,QSDocFlag,QSMinAge,QSMaxAge)=""
	quit
}

ClassMethod FindQSubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQSubjectExecute ]
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

ClassMethod FindQSubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQSubjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCSDLink(ParRef) As %Query(ROWSPEC = "SDLID:%String:ID,SDLActive:%String:SDLActive,SDLNote:%String:SDLNote,SDLOrder:%String:SDLOrder,SDLQuestionsDetailDR:%String:SDLQuestionsDetailDR,QDDesc:%String:QDDesc,QDType:%String:QDType")
{
}

ClassMethod FindCSDLinkExecute(ByRef qHandle As %Binary, ParRef) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	if ParRef="" Quit $$$OK
	s index=1
	s sort=""
	f  s sort=$O(^User.DHCHMCSDLinkI("SDLOrderIndex",+ParRef,$p(ParRef,"||",2),sort))  q:sort=""  d
	.s Sub=0
	.f  s Sub=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+ParRef,$p(ParRef,"||",2),sort,Sub))  quit:Sub=""  d
	..s ID=ParRef_"||"_Sub
	..d BuildDataFindCSDLink
	Quit $$$OK
BuildDataFindCSDLink
	d ResetVariablesFindCSDLink
	s obj=##class(User.DHCHMCSDLink).%OpenId(ID)
	s SDLActive = obj.SDLActive
	s SDLNote = obj.SDLNote
	s SDLOrder = obj.SDLOrder
	i $ISOBJECT(obj.SDLQuestionsDetailDR) d
	.s SDLQuestionsDetailDR = obj.SDLQuestionsDetailDR.%Id()
	.i SDLQuestionsDetailDR '= "" d
	..s QDDesc=obj.SDLQuestionsDetailDR.QDDesc
	..s QDType = obj.SDLQuestionsDetailDR.QDType
	d OutputRowFindCSDLink
	quit
OutputRowFindCSDLink
	s Data=$lb(ID,SDLActive,SDLNote,SDLOrder,SDLQuestionsDetailDR,QDDesc,QDType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindCSDLink
	s (SDLActive,SDLNote,SDLOrder,SDLQuestionsDetailDR,QDDesc,QDType)=""
	quit
}

ClassMethod FindCSDLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCSDLinkExecute ]
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

ClassMethod FindCSDLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCSDLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionnaireSet","FindQD")
Query FindQD(Desc = "") As %Query(ROWSPEC = "SDLQuestionsDetailDR:%String:ID,QDActive:%String:QDActive,QDCode:%String:QDCode,QDDesc:%String:QDDesc,QDElementNum:%String:QDElementNum,QDLinkCode:%String:QDLinkCode,QDNote:%String:QDNote,QDRemark:%String:QDRemark,QDRequired:%String:QDRequired,QDSex:%String:QDSex,QDType:%String:QDType,QDUnit:%String:QDUnit")
{
}

ClassMethod FindQDExecute(ByRef qHandle As %Binary, Desc = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionsDetailD(ID))  quit:ID=""  d
	.d BuildDataFindQD
	Quit $$$OK
BuildDataFindQD
	d ResetVariablesFindQD
	s obj=##class(User.DHCHMCQuestionsDetail).%OpenId(ID)
	s QDActive = obj.QDActive
	q:QDActive'="Y"
	s QDCode = obj.QDCode
	s QDDesc = obj.QDDesc
	q:(Desc'="")&&(QDDesc'[Desc)
	s QDElementNum = obj.QDElementNum
	s QDLinkCode = obj.QDLinkCode
	s QDNote = obj.QDNote
	s QDRemark = obj.QDRemark
	s QDRequired = obj.QDRequired
	s QDSex = obj.QDSex
	s QDType = obj.QDType
	s QDUnit = obj.QDUnit
	d OutputRowFindQD
	quit
OutputRowFindQD
	s Data=$lb(ID,QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQD
	s (QDActive,QDCode,QDDesc,QDElementNum,QDLinkCode,QDNote,QDRemark,QDRequired,QDSex,QDType,QDUnit)=""
	quit
}

ClassMethod FindQDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQDExecute ]
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

ClassMethod FindQDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionnaireSet","FindEDL",1)
Query FindEDL(ParRef) As %Query(ROWSPEC = "EDLID:%String:ID,QEDLActive:%String:QEDLActive,QEDLCalculateOrder:%String:QEDLCalculateOrder,QEDLEvaluationDetailDR:%String:QEDLEvaluationDetailDR,EDDesc:%String:EDDesc,QEDLNote:%String:QEDLNote,QEDLOrder:%String:QEDLOrder")
{
}

ClassMethod FindEDLExecute(ByRef qHandle As %Binary, ParRef) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i ParRef="" Quit $$$OK
	s index=1
	s Sub=0
	f  s Sub=$o(^User.DHCHMCQuestionnaireD(ParRef,"QEDLink",Sub))  quit:Sub=""  d
	.s ID=ParRef_"||"_Sub
	.d BuildDataFindEDL
	Quit $$$OK
BuildDataFindEDL
	d ResetVariablesFindEDL
	s obj=##class(User.DHCHMCQEDLink).%OpenId(ID)
	s QEDLActive = obj.QEDLActive
	i QEDLActive = "Y" s QEDLActive = "true"
	e  s QEDLActive = "false"
	s QEDLCalculateOrder = obj.QEDLCalculateOrder
	i $ISOBJECT(obj.QEDLEvaluationDetailDR) d
	.s QEDLEvaluationDetailDR = obj.QEDLEvaluationDetailDR.%Id()
	.i QEDLEvaluationDetailDR '= "" d
	..s EDDesc=obj.QEDLEvaluationDetailDR.EDDesc
	s QEDLNote = obj.QEDLNote
	s QEDLOrder = obj.QEDLOrder
	d OutputRowFindEDL
	quit
OutputRowFindEDL
	s Data=$lb(ID,QEDLActive,QEDLCalculateOrder,QEDLEvaluationDetailDR,EDDesc,QEDLNote,QEDLOrder)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindEDL
	s (QEDLActive,QEDLCalculateOrder,QEDLEvaluationDetailDR,EDDesc,QEDLNote,QEDLOrder)=""
	quit
}

ClassMethod FindEDLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEDLExecute ]
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

ClassMethod FindEDLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEDLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.QuestionnaireSet","FindEvaDetail")
Query FindEvaDetail(Desc As %String = "") As %Query(ROWSPEC = "QEDLEvaluationDetailDR:%String:ID,EDActive:%String:EDActive,EDCode:%String:EDCode,EDDataSource:%String:EDDataSource,EDDesc:%String:EDDesc,EDNote:%String:EDNote,EDSex:%String:EDSex,EDType:%String:EDType,EDUnit:%String:EDUnit")
{
}

ClassMethod FindEvaDetailExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCEvaluationDetailD(ID))  quit:ID=""  d
	.d BuildDataFindEvaDetail
	Quit $$$OK
BuildDataFindEvaDetail
	d ResetVariablesFindEvaDetail
	s obj=##class(User.DHCHMCEvaluationDetail).%OpenId(ID)
	s EDActive = obj.EDActive
	s EDCode = obj.EDCode
	s EDDataSource = obj.EDDataSource
	s EDDesc = obj.EDDesc
	q:(Desc'="")&&(EDDesc'[Desc)
	s EDNote = obj.EDNote
	s EDSex = obj.EDSex
	s EDType = obj.EDType
	s EDUnit = obj.EDUnit
	d OutputRowFindEvaDetail
	quit
OutputRowFindEvaDetail
	s Data=$lb(ID,EDActive,EDCode,EDDataSource,EDDesc,EDNote,EDSex,EDType,EDUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindEvaDetail
	s (EDActive,EDCode,EDDataSource,EDDesc,EDNote,EDSex,EDType,EDUnit)=""
	quit
}

ClassMethod FindEvaDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEvaDetailExecute ]
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

ClassMethod FindEvaDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEvaDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QNSave(id, value, property)
{
	set ret=##class(User.DHCHMCQuestionnaire).SaveData(id,value,property)
	q ret
}

ClassMethod QSSave(id, value, property)
{
	s Code = $P(value,"^",2)
	s ParRef = $P(value,"^",5)
	i $D(^User.DHCHMCQuestionSubjectI("QSCodeIndex",ParRef," "_Code)) 
	{
		q:id="" "-1^编码已存在"
		q:(id'="")&&($O(^User.DHCHMCQuestionSubjectI("QSCodeIndex",ParRef," "_Code,""))'=$P(id,"||",2)) "-1^编码已存在"
	}
	set ret=##class(User.DHCHMCQuestionSubject).SaveData(id,value,property)
	q ret
}

ClassMethod SDLSave(id, value, property, parref, sdlqddr)
{
	s qs="",flag=0
	f  s qs=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+parref,qs)) q:qs=""  d
	.s order=""
	.f  s order=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+parref,qs,order)) q:order=""  d
	..s sub=""
	..f  s sub=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+parref,qs,order,sub)) q:sub=""  d
	...s sdlid=+parref_"||"_qs_"||"_sub
	...s obj=##class(User.DHCHMCSDLink).%OpenId(sdlid)
	...i $ISOBJECT(obj.SDLQuestionsDetailDR) d
	....s SDLQuestionsDetailDR=obj.SDLQuestionsDetailDR.%Id()
	....i SDLQuestionsDetailDR=sdlqddr s flag=1
	....i (id=sdlid)&&(SDLQuestionsDetailDR=sdlqddr) s flag=0
	
	q:flag=1 "-1^该问卷已有此内容"
	set ret=##class(User.DHCHMCSDLink).SaveData(id,value,property)
	q ret
}

ClassMethod EDLSave(id, value, property, edlparref, edleddr)
{
	s order="",flag=0
	f  s order=$o(^User.DHCHMCQEDLinkI("QEDLOrderIndex",edlparref,order)) q:order=""  d
	.s edlsub=""
	.f  s edlsub=$o(^User.DHCHMCQEDLinkI("QEDLOrderIndex",edlparref,order,edlsub)) q:edlsub=""  d
	..s edlid=edlparref_"||"_edlsub
	..s obj=##class(User.DHCHMCQEDLink).%OpenId(edlid)
	..i $ISOBJECT(obj.QEDLEvaluationDetailDR) d
	...s QEDLEvaluationDetailDR=obj.QEDLEvaluationDetailDR.%Id()
	...i QEDLEvaluationDetailDR=edleddr s flag=1
	...i (id=edlid)&&(QEDLEvaluationDetailDR=edleddr) s flag=0
	
	q:flag=1 "-1^该问卷已有此评估"
	set ret=##class(User.DHCHMCQEDLink).SaveData(id,value,property)
	q ret
}

}
