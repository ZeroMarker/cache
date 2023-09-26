Class DHCMA.CPW.BTS.SurveyOptionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2021-12-15
/// Description:  查询临床路径题目选项
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.SurveyOptionSrv","QryOption","1||2")
Query QryOption(aParRef As %String) As %Query(ROWSPEC = "BTID:%String,BTOptionNo:%String,BTOptionDesc:%String,BTOptionScore:%String")
{
}

ClassMethod QryOptionExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aParRef="" $$$OK
 	Set Survey=$p(aParRef,"||",1)
 	Set Question=$p(aParRef,"||",2)
 	Set xNum=""
 	For {
	 	Set xNum      = $o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",Survey,Question,xNum))
	 	Quit:xNum=""
	 	Set xSub=""
	 	For{
		 	Set xSub      = $o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",Survey,Question,xNum,xSub))
		 	Quit:xSub=""
		 	Set ID = aParRef_"||"_xSub
	 		Set obj = ##class(DHCMA.CPW.BT.SurveyOption).GetObjById(ID)
		 	continue:'$IsObject(obj)
		 	Set OptionNo     = obj.SQOptionNo
		 	Set OptionDesc   = obj.SQOptionDesc
		 	Set OptionScore  = obj.SQOptionScore
			Set Data=$lb(ID,OptionNo,OptionDesc,OptionScore)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 	
 	}	
	Quit $$$OK
}

ClassMethod QryOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOptionExecute ]
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
