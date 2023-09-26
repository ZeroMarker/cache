Class DHCMA.CPW.BTS.SurveyQuestionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2021-12-15
/// Description:  查询临床路径题目
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.SurveyQuestionSrv","QryQuestion","1")
Query QryQuestion(aParRef As %String) As %Query(ROWSPEC = "BTID:%String,BTItemTypeID:%String,BTItemTypeDesc:%String,BTItemNo:%String,BTItemDesc:%String,BTItemScore:%String,BTItemResume:%String")
{
}

ClassMethod QryQuestionExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aParRef="" $$$OK
 	Set xNum=""
 	For {
	 	Set xNum      = $o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",aParRef,xNum))
	 	Quit:xNum=""
	 	Set xSub=""
	 	For{
		 	Set xSub=$o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",aParRef,xNum,xSub))
	 		Quit:xSub=""
	 		Set ID = aParRef_"||"_xSub
	 		Set obj = ##class(DHCMA.CPW.BT.SurveyQuestion).GetObjById(ID)
	 		Continue:'$IsObject(obj)
	 		Set ItemTypeDr	= obj.SQItemType
	 		Quit:'$IsObject(ItemTypeDr)
	 		Set ItemTypeID	= ItemTypeDr.%Id()
	 		Set ItemTypeDesc= ItemTypeDr.BTDesc
	 		Set ItemNo		= obj.SQItemNo
	 		Set ItemDesc	= obj.SQItemDesc
	 		Set ItemScore	= obj.SQItemScore
	 		Set ItemResume	= obj.SQItemResume
	 		Set Data=$lb(ID,ItemTypeID,ItemTypeDesc,ItemNo,ItemDesc,ItemScore,ItemResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 
 	}	
	Quit $$$OK
}

ClassMethod QryQuestionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQuestionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQuestionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQuestionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
