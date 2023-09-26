Class web.DHCICUCProperty Extends %RegisteredObject
{

// 查询

Query FindICUCProperty() As %Query(ROWSPEC = "tICUCPRowID:%String,tICUCPCode:%String,tICUCPDesc:%String,tICUCPDefaultValue:%String") [ SqlProc ]
{
}

ClassMethod FindICUCPropertyExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s tICUCPRowID=0
    f  s tICUCPRowID=$o(^DHCICUC("Property",tICUCPRowID)) q:tICUCPRowID=""  d
    .s tICUCPCode=$li(^DHCICUC("Property",tICUCPRowID),1)
    .s tICUCPDesc=$li(^DHCICUC("Property",tICUCPRowID),2)
    .s tICUCPDefaultValue=""
    .i $ld(^DHCICUC("Property",tICUCPRowID),3) s tICUCPDefaultValue=$li(^DHCICUC("Property",tICUCPRowID),3)
 	.Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(tICUCPRowID,tICUCPCode,tICUCPDesc,tICUCPDefaultValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCPropertyExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepProperty(ICUCPCode As %String) As %String
{
	s tICUCPRowID=0
	s flag="N"
	f  s tICUCPRowID=$o(^DHCICUC("Property",tICUCPRowID)) q:tICUCPRowID=""  d
	.s tICUCPCode=$li(^DHCICUC("Property",tICUCPRowID),1)
	.i (tICUCPCode=ICUCPCode) s flag="Y"
	q flag
}

// 增加

ClassMethod InsertProperty(ICUCPCode As %String, ICUCPDesc As %String, ICUCPDefaultValue As %String) As %String
{
	s flag=..RepProperty(ICUCPCode)
	q:flag="Y" "代码重复"
	s ICUCProperty=##Class(User.DHCICUCProperty).%New()
	s ICUCProperty.ICUCPCode=ICUCPCode
	s ICUCProperty.ICUCPDesc=ICUCPDesc
	s ICUCProperty.ICUCPDefaultValue=ICUCPDefaultValue
	q:ICUCProperty.ICUCPCode="" "代码不能为空！"
	s savestatus=ICUCProperty.%Save()
	q:(+savestatus=0) "数据新增失败!"
	s proId=ICUCProperty.%Id()
	d ICUCProperty.%Close()
	q 0
}

// 更新

ClassMethod UpdateProperty(ICUCPRowID As %String, ICUCPCode As %String, ICUCPDesc As %String, ICUCPDefaultValue As %String) As %String
{
	i ##Class(User.DHCICUCProperty).%ExistsId(ICUCPRowID) 
	s ICUCProperty=##Class(User.DHCICUCProperty).%OpenId(ICUCPRowID)
	s ICUCProperty.ICUCPCode=ICUCPCode
	s ICUCProperty.ICUCPDesc=ICUCPDesc
	s ICUCProperty.ICUCPDefaultValue=ICUCPDefaultValue
	s savestatus=ICUCProperty.%Save()
	q:(+savestatus=0) "数据更新失败!"
	s proId=ICUCProperty.%Id()
	d ICUCProperty.%Close()
	q 0
}

// 删除

ClassMethod DeleteProperty(ICUCPRowID As %String) As %String
{
	i ##Class(User.DHCICUCProperty).%ExistsId(ICUCPRowID)
	s savestatus= ##Class(User.DHCICUCProperty).%DeleteId(ICUCPRowID)
	q 0
}

}
