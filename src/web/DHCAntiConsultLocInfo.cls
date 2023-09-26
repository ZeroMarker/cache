Class web.DHCAntiConsultLocInfo Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     shp
/// CreatDate：   2012-12-05
/// Description:  可会诊科室信息
/// Table：       DHC_Anti_ConsultLocInfo
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCAntiConsultLocInfo","QryAntConLocInfo","")
Query QryAntConLocInfo(LocID As %String) As %Query(ROWSPEC = "SeqNo:%String,ConLocDesc:%String,ConLocCode:%String,IsConLoc:%String,IsSpecLoc:%String,IsActive:%String,Rowid:%String,ConLocRowid:%String")
{
}

ClassMethod QryAntConLocInfoExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID="",SeqNo=0
 	For {
		 	Set ID=$o(^User.DHCAntiConsultLocInfoD(ID))
		 	Quit:ID=""
		 	Set Position=$g(^User.DHCAntiConsultLocInfoD(ID))
		 	Set ConLoc=$li(Position,2)
		 	continue:(LocID'="")&&(ConLoc'=LocID)
		 	set ConLocDesc=$p(^CTLOC(ConLoc),"^",2)
		 	Set ConLocCode=$li(Position,3) 
		 	Set IsConLoc=$li(Position,4)
		 	set IsSpecLoc=$li(Position,5)
		 	Set IsActive=$li(Position,6)
		 	s SeqNo=SeqNo+1
		 	Set Data=$lb(SeqNo,ConLocDesc,ConLocCode,IsConLoc,IsSpecLoc,IsActive,ID,ConLoc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAntConLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntConLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntConLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntConLocInfoExecute ]
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

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  可会诊科室字典
/// Table：       User.DHCAntiConsultLocInfo
/// Input：       User.DHCAntiConsultLocInfo.ID
/// Return：      返回obj
/// w ##class(web.DHCAntiConsultLocInfo).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCAntiConsultLocInfo
{
	New (aId)
	Set obj=##Class(User.DHCAntiConsultLocInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  更新可会诊科室字典
/// Table：       User.DHCAntiConsultLocInfo
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// 
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"        ;..#SEPARATE
	b  ;
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(User.DHCAntiConsultLocInfo).%New()
	} Else {
		Set obj=##class(User.DHCAntiConsultLocInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ANTLocDR=$p(aInput,aSeparate,2)
	Set obj.ANTLocCode=$p(aInput,aSeparate,3)
	set active=$p(aInput,aSeparate,4)
	if (active="true")  s active=1
	e  d  s active=0
	Set obj.ANTActive=active
	Set isConLoc=$p(aInput,aSeparate,5)
	if (isConLoc="true")  s isConLoc=1
	e  d  s isConLoc=0
	set obj.ANTIsConLoc=isConLoc
	Set SpecailLoc=$p(aInput,aSeparate,6)
	if (SpecailLoc="true")  s sepcialloc=1
	e  d  s sepcialloc=0
	set obj.ANTIsSpecConLoc=sepcialloc
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

/// Creator：     shp
/// CreatDate：   2012-11-22
/// Description:  删除可会诊科室字典
/// Table：       User.DHCAntiConsultLocInfo
/// Input：       User.DHCAntiConsultLocInfo.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(User.DHCAntiConsultLocInfo).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

ClassMethod GetExecuteLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecuteLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetExecuteLocExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCAntiConsultLocInfo","GetExecuteLoc","b")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=$$ALPHAUP^SSUTIL4(code)
 Set CTLOCRowid=""
	Set RetStr=""
	F  s CTLOCRowid=$O(^CTLOC(CTLOCRowid)) q:CTLOCRowid=""  d
	.Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
	.Q:CTLOCType'="E"
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Quit:(code'="")&&($p($$ALPHAUP^SSUTIL4(CTLOCDesc),code)'="")
	.Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.Set CTLOCCode=CTLOCDesc     //$P(CTLOCDesc,"-",2)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(CTLOCCode,CTLOCRowid,CTLOCDescQuickCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExecuteLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecuteLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetExecuteLoc(code As %String) As %Query(ROWSPEC = "Desc:%String,Rowid:%String,Code:%String")
{
}

ClassMethod GetExecuteDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecuteDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetExecuteDocExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCAntiConsultLocInfo","GetExecuteDoc","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	S ^tempshp("Locid")=LocId
 	q:LocId="" ""
	s ret=""
	s RESRowid=0
	f  s RESRowid=$o(^RB("RES",0,"CTLOC",LocId,RESRowid)) q:RESRowid=""  d
    .s CTPCPDR=$P(^RB("RES",RESRowid),"^",2)
    .q:'$d(^CTPCP(CTPCPDR,1))
    .s Desc=$P(^CTPCP(CTPCPDR,1),"^",2)
   	.Do OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow1
	set Data=$lb(Desc,CTPCPDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExecuteDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecuteDocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetExecuteDoc(LocId As %String) As %Query(ROWSPEC = "Desc:%String,Rowid:%String")
{
}

/// w ##class(web.DHCAntiConsultLocInfo).CheckUnique(9,294)
ClassMethod CheckUnique(LocID)
{
	q:($g(LocID)="") 0
	s rowid="",find=0
	for  s rowid=$o(^User.DHCAntiConsultLocInfoD(rowid))  q:rowid=""  d
	.s Loc=$list(^User.DHCAntiConsultLocInfoD(rowid),2)
	.if (LocID=Loc)  s find=1
	
	q find
}

Query QryAntConDocInfo(LocID As %String) As %Query(ROWSPEC = "SeqNo:%String,ConDocDesc:%String,ConDocID:%String,ConDocAtive:%String,rowid:%String")
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCAntiConsultLocInfo","QryAntConDocInfo","9")
ClassMethod QryAntConDocInfoExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID="",SeqNo=0
 	For {
		 	Set ID=$o(^User.DHCAntiConsultDocInfoI("ConLocDR"," "_LocID,ID))
		 	Quit:ID=""
		 	;s locdr=$list(^User.DHCAntiConsultDocInfoD(ID),"^",2)
		 	;continue:locdr'=LocID
		 	s ConDocID=$list(^User.DHCAntiConsultDocInfoD(ID),3)
		 	s ConDocDesc=$p(^CTPCP(ConDocID,1),"^",2)
		 	S ConDocAtive=$list(^User.DHCAntiConsultDocInfoD(ID),4)
		 	S SeqNo=SeqNo+1
		 	Set Data=$lb(SeqNo,ConDocDesc,ConDocID,ConDocAtive,ID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAntConDocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntConDocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntConDocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntConDocInfoExecute ]
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

/// w ##class(web.DHCAntiConsultLocInfo).ConDocUpdate("^9^294^true")
ClassMethod ConDocUpdate(input As %String) As %String
{
	New (input)
	Set return=0
	Set ID=$p(input,"^",1)
	If (ID="") {
		Set obj=##class(User.DHCAntiConsultDocInfo).%New()
	} Else {
		Set obj=##class(User.DHCAntiConsultDocInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) -1
	Set obj.ConLocDR=$p(input,"^",2)
	Set obj.ConDocDr=$p(input,"^",3)
	set active=$p(input,"^",4)
	b   ;
	if (active="true")  s active=1
	e  d  s active=0
	Set obj.ConActive=active
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

ClassMethod DeleteConDocById(rowid) As %String
{

	New (rowid)
	Set return=0
	Set sc = ##class(User.DHCAntiConsultDocInfo).%DeleteId(+rowid)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// w ##class(web.DHCAntiConsultLocInfo).CheckUniqueDoc("9","294")
ClassMethod CheckUniqueDoc(LocId, DocId) As %String
{
	q:(($g(LocId)="")||($g(DocId)="")) 0
	s rowid="",find=0
	f  s rowid=$O(^User.DHCAntiConsultDocInfoI("ConLocDR"," "_LocId,rowid))  Q:rowid=""  D
	.S doc=$list(^User.DHCAntiConsultDocInfoD(rowid),3)
	.if (doc=DocId)  s find=1
	q find
}

ClassMethod GetLocDesc(LocId) As %String
{
	
	q:($g(LocId)="") ""
	s ConLocDesc=$p(^CTLOC(LocId),"^",2)
	;i ConLocDesc["-"  s ConLocDesc=$p(ConLocDesc,"-",2)
	q ConLocDesc
}

}
