Class web.DHCDocInfPart Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  取感染部位字典
/// Table：       User.DHCDocInfPart
/// Input：       User.DHCDocInfPart.ID
/// Return：      返回obj
/// w ##class(web.DHCDocInfPart).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCDocInfPart
{
	New (aId)
	Set obj=##Class(User.DHCDocInfPart).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  更新感染部位字典
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(web.DHCDocInfPart).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"        ;..#SEPARATE
	b  ;
	Set ID=$p(aInput,aSeparate,1)
	set OldCode="",OldDesc="" ;add hw 2016-1-19
	If (ID="") {
		Set obj=##class(User.DHCDocInfPart).%New()
	} Else {
		Set obj=##class(User.DHCDocInfPart).%OpenId(ID)
		set OldCode=obj.IPCode
		set OldDesc=obj.IPDesc
	}
	Quit:'$IsObject(obj) return
	s code=$p(aInput,aSeparate,2)
	s desc=$p(aInput,aSeparate,3)
	&sql(SELECT count(*) INTO :mycount   
	 	FROM  SQLUSER.DHC_Doc_InfPart
	 		WHERE (IPCode=:code)and(IPDesc=:desc))
	 if ((mycount'=0)&&((code'=OldCode)||(desc'=OldDesc)))
	 {	  
		 Quit -99
	 }else{
		Set obj.IPCode=$p(aInput,aSeparate,2)
		Set obj.IPDesc=$p(aInput,aSeparate,3)
		set active=$p(aInput,aSeparate,4)
		if (active="true")  s active=1
		e  d  s active=0
		Set obj.IPActive=active
		Set obj.IPResume=$p(aInput,aSeparate,5)
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {  //检查Save是否成功
	   		Do $System.OBJ.DisplayError(sc)
	   		Set return=-1
		} Else {
			Set return=obj.%Id()
		}
		Do obj.%Close()
	
		Quit return
	 }
}

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  删除感染部位字典
/// Table：       User.DHCDocInfPart
/// Input：       User.DHCDocInfPart.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(User.DHCDocInfPart).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     shp
/// CreatDate：   2012-11-08
/// Description:  查询院感部位
/// Table：       DHCDocInfPos
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCDocInfPart","QryInfPart","1")
Query QryInfPart() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String,IPActiveDesc:%String,IPResume:%String")
{
}

ClassMethod QryInfPartExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID=""
 	For {
		 	Set ID=$o(^User.DHCDocInfPartD(ID))
		 	Quit:ID=""
		 	Set Position=$g(^User.DHCDocInfPartD(ID))
		 	Set IPCode=$li(Position,2)
		 	Set IPDesc=$li(Position,3)
		 	Set IPActive=$li(Position,4)
		 	if IPActive=1  s IPActiveDesc="是"
		 	else  d  s IPActiveDesc="否"  
		 	Set IPResume=$li(Position,5)
		 	Set Data=$lb(ID,IPDesc,IPCode,IPActiveDesc,IPResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPartExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
