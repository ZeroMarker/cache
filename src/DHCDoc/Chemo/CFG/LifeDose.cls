/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 化疗药品终身剂量维护
Class DHCDoc.Chemo.CFG.LifeDose Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.LifeDosage).Save("903||1")
ClassMethod Save(LDID, Arcim, LDosage, Uom)
{
	
	i LDID="" {
		Q:$d(^CF.DOC.Chemo.LifeDoseI("Arcim",Arcim)) "-113"
		s a=##class(User.ChemoLifeDose).%New()
	} else {
		s a=##class(User.ChemoLifeDose).%OpenId(LDID)
		s oldArcim=a.LDArcimDRGetObjectId()
		Q:$d(^CF.DOC.Chemo.LifeDoseI("Arcim",Arcim))&&(oldArcim'=Arcim) "-113"
	}
	s a.LDDosage=LDosage
	d a.LDArcimDRSetObjectId(Arcim)
	//d a.LDUomDRSetObjectId(Uom)
	s a.LDUomDR=Uom
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-111"
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod Delete(LDID As %String)
{
	Q:LDID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_LifeDose WHERE LD_ID=:LDID)
	Q:SQLCODE'=0 "-112"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 查询
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.LifeDose","QryLifeDosage")
Query QryLifeDosage(InArcim = "") As %Query(ROWSPEC = "id,arcim,arcimDesc,dosage,uom,uomDesc")
{
}

ClassMethod QryLifeDosageExecute(ByRef qHandle As %Binary, InArcim = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	d ..InitUomData()
 	s id=0
 	f  s id=$o(^CF.DOC.Chemo.LifeDoseD(id)) q:id=""  d
 	.s arcim=$p(^CF.DOC.Chemo.LifeDoseD(id),"^",1)
 	.Q:(InArcim'="")&&(arcim'=InArcim)
 	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
 	.s dosage=$p(^CF.DOC.Chemo.LifeDoseD(id),"^",2)
 	.s uom=$p(^CF.DOC.Chemo.LifeDoseD(id),"^",3)
 	.;s uomDesc=$p(^CT("UOM",uom),"^",2)
 	.s uomDesc=..GetUomDesc(uom)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,arcim,arcimDesc,dosage,uom,uomDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryLifeDosageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLifeDosageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLifeDosageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLifeDosageExecute ]
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

/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 查询单位
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.LifeDose","QryUom")
Query QryUom() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryUomExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=""
 	f  s id=$o(^CF.DOC.Chemo.Ext.UomD(id)) q:id=""  d
 	.s text=$g(^CF.DOC.Chemo.Ext.UomD(id))
 	.d output9
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output9
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryUomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUomExecute ]
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

/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).Save("903||1")
ClassMethod GetUomDesc(id)
{
	Q $g(^CF.DOC.Chemo.Ext.UomD(id))
}

/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).InitUomData()
ClassMethod InitUomData()
{
	s ^CF.DOC.Chemo.Ext.UomD(1)="mg/m2"
	
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-06-27
/// DESC: 获取终身剂量
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).GetLifeDose("176||1")
ClassMethod GetLifeDose(InArcim)
{
	Q:'$d(^CF.DOC.Chemo.LifeDoseI("Arcim",InArcim)) 0
	s id=$o(^CF.DOC.Chemo.LifeDoseI("Arcim",InArcim,""))
	Q:id="" 0
	s LifeDose=$p(^CF.DOC.Chemo.LifeDoseD(id),"^",2)
	Q:LifeDose="" 0	//未配置数值不做判断
	
	
	Q LifeDose
}

}
