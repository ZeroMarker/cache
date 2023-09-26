Class web.DHCHM.ExpressionSet Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

Query FindExpression(ESID, Type) As %Query(ROWSPEC = "ExID:%String:ID,EAgeMax:%String:EAgeMax,EAgeMin:%String:EAgeMin,ECQuestionnaireDR:%String:ECQuestionnaireDR,QDesc:%String:QDesc,EExpression:%String:EExpression,EExpressionType:%String:EExpressionType,EParameters:%String:EParameters,ERemark:%String:ERemark,ESex:%String:ESex,ESourceID:%String:ESourceID,EType:%String:EType,EUnit:%String:EUnit")
{
}

ClassMethod FindExpressionExecute(ByRef qHandle As %Binary, ESID, Type) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCExpressionD(ID))  quit:ID=""  d
	.d BuildDataFindExpression
	Quit $$$OK
BuildDataFindExpression
	d ResetVariablesFindExpression
	s obj=##class(User.DHCHMCExpression).%OpenId(ID)
	s EAgeMax = obj.EAgeMax
	s EAgeMin = obj.EAgeMin
	s ECQuestionnaireDR = obj.ECQuestionnaireDR.%Id()
	i ECQuestionnaireDR '= "" d
	.s QDesc=obj.ECQuestionnaireDR.QDesc
	s EExpression = obj.EExpression
	s EExpressionType = obj.EExpressionType
	s EParameters = obj.EParameters
	s ERemark = obj.ERemark
	s ESex = obj.ESex
	s ESourceID = obj.ESourceID
	q:ESID'=ESourceID
	s EType = obj.EType
	q:Type'=EType
	s EUnit = obj.EUnit
	d OutputRowFindExpression
	quit
OutputRowFindExpression
	s Data=$lb(ID,EAgeMax,EAgeMin,ECQuestionnaireDR,QDesc,EExpression,EExpressionType,EParameters,ERemark,ESex,ESourceID,EType,EUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindExpression
	s (EAgeMax,EAgeMin,ECQuestionnaireDR,QDesc,EExpression,EExpressionType,EParameters,ERemark,ESex,ESourceID,EType,EUnit)=""
	quit
}

ClassMethod FindExpressionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExpressionExecute ]
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

ClassMethod FindExpressionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExpressionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindQN() As %Query(ROWSPEC = "ECQuestionnaireDR:%String:ID,QActive:%String:QActive,QCode:%String:QCode,QDesc:%String:QDesc,QRemark:%String:QRemark,QType:%String:QType")
{
}

ClassMethod FindQNExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMCQuestionnaireD(ID))  quit:ID=""  d
	.d BuildDataFindQN
	Quit $$$OK
BuildDataFindQN
	d ResetVariablesFindQN
	s obj=##class(User.DHCHMCQuestionnaire).%OpenId(ID)
	s QActive = obj.QActive
	s QCode = obj.QCode
	s QDesc = obj.QDesc
	s QRemark = obj.QRemark
	s QType = obj.QType
	d OutputRowFindQN
	quit
OutputRowFindQN
	s Data=$lb(ID,QActive,QCode,QDesc,QRemark,QType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindQN
	s (QActive,QCode,QDesc,QRemark,QType)=""
	quit
}

ClassMethod FindQNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQNExecute ]
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

ClassMethod FindQNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQNExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ExSave(id, value, property, flag As %String = "N")
{
	set ret=##class(User.DHCHMCExpression).SaveData(id,value,property,flag)
	q ret
}

ClassMethod ExDelete(id, flag As %String = "N")
{
	set ret=##class(User.DHCHMCExpression).Delete(id, flag)
	q ret
}

}
