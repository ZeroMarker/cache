Class DHCWL.CheckFunData.CodeTypeItemQuery Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CodeTypeItemQuery","CodeTypeItemQuery","23")
Query CodeTypeItemQuery(typeId As %Text, searcheCondsearcheCond As %String, searcheValue As %String) As %Query(ROWSPEC = "ID:%String,objCode:%String,objDesc:%String") [ SqlProc ]
{
}

ClassMethod CodeTypeItemQueryExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	s mtypeId=$list(^DHCWL.CheckFun.CheckSetD(typeId),5)
	s count=0
	s count=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(mtypeId)
 	f num=0:1:count-1  d  //3368
	.s itemList=$g(^TEMPDHCWLCode($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.i ItemDesc["-" s ItemDesc=$p(ItemDesc,"-",2)
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CodeTypeItemQuery","KpiItemQuery")
Query KpiItemQuery(searcheCondsearcheCond As %String, searcheValue As %String) As %Query(ROWSPEC = "ID:%String,kpiCode:%String,kpiDesc:%String") [ SqlProc ]
{
}

ClassMethod KpiItemQueryExecute(ByRef qHandle As %Binary, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s count=0
 	s id=0 f  s id=$o(^DHCWL.CheckFun.CheckKPID(id))  q:id=""  d
 	.s flag=$list(^DHCWL.CheckFun.CheckKPID(id),4)
 	.q:flag'="Y"
 	.s code=$list(^DHCWL.CheckFun.CheckKPID(id),2)
 	.s desc=$list(^DHCWL.CheckFun.CheckKPID(id),3)
 	.s codes=$zconvert(code,"U")
 	.s descs=$zconvert(desc,"U")
 	.s searcheValues=$zconvert(searcheValue,"U")
	.i (searcheCond="Code")&(searcheValue'="") q:codes'[searcheValues
	.i (searcheCond="Name")&(searcheValue'="") q:descs'[searcheValues
	.s ^CacheTemp(repid,ind)=$lb(id,code,desc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod KpiItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KpiItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod KpiItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KpiItemQueryExecute ]
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

/// Creater:  ans
/// CreatDate:2015-04-29
/// Name:     按照考核方案获取考核对象
/// Table:    
/// InPut:    typeId:考核方案id,searcheCondsearcheCond:查询方式,searcheValue:查询输入内容
/// OutPut:   ID:考核对象id,ItemCode:考核对象code,考核对象描述
/// Exe:      do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).test3()
/// d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CodeTypeItemQuery","ObjItemQuery","40")
/// interface:d ##class(%ResultSet).RunQuery("DHCWL.Interface.MkpiData","QryDimValuesByDimType","Hospital:HosDesc^HosCode")
Query ObjItemQuery(typeId As %Text, searcheCondsearcheCond As %String, searcheValue As %String) As %Query(ROWSPEC = "ID:%String,objCode:%String,objDesc:%String") [ SqlProc ]
{
}

ClassMethod ObjItemQueryExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	d ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(typeId,"")
	s ID=0 f  s ID=$o(^TEMPDHCWL("objId",ID)) q:ID=""  d
	.s ItemDesc=$g(^TEMPDHCWL("objId",ID))
	.s ItemCode=""
	.i ItemCode[$c(13,10) s ItemCode=$tr(ItemCode,$c(13,10),"")
	.i ItemDesc[$c(13,10) s ItemDesc=$tr(ItemDesc,$c(13,10),"")
	.i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	k ^TEMPDHCWL("objId")
	Quit $$$OK
}

ClassMethod ObjItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ObjItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod ObjItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ObjItemQueryExecute ]
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

/// Creater:  ans
/// CreatDate:2015-05-27
/// Name:     按照考核方案存储考核对象
/// Table:    
/// InPut:    typeId:考核方案id,
/// OutPut:   
/// Exe:      do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem("48","LocDesc^LocCode")
/// 
/// interface:d ##class(%ResultSet).RunQuery("DHCWL.Interface.MkpiData","QryDimValuesByDimType","CTLOC:LocDesc")
ClassMethod GetObjItem(typeId As %String, typeDim As %String = "") As %String
{
	k ^TEMPDHCWL("objId")
	s objTypes=$list(^DHCWL.CheckFun.CheckSetD(typeId),5)
	s objDims=$list(^DHCWL.CheckFun.CheckSetD(typeId),8)
	s objDim=""
	s objType=$list(^DHCWL.MKPI.MKPIDimTypeD(objTypes),2)
	i objDims'="" s objDim=$List(^DHCWL.MKPI.DimPropertyD(objDims),3)
	i typeDim'="" s objDim=$g(typeDim)
	i objDim="" s obj=objType
	e  s obj=objType_":"_objDim
	s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
	s sc=rs.Execute(obj)
	while rs.Next(.sc){
			s ID=$g(rs.Data("dimIDV"))
			s ItemDesc=$g(rs.Data("dimProV"))
			s ^TEMPDHCWL("objId",ID)=ItemDesc
		}
}

/// Creater:  ans
/// CreatDate:2015-06-30
/// Name:     获取考核方案下的考核指标
/// Table:    DHCWL_CheckFun.DHCWLSetKpiRe
/// InPut:    typeId:考核方案id,searcheCondsearcheCond:查询方式,searcheValue:查询输入内容
/// OutPut:   ID:考核指标id,ItemCode:考核指标code,考核指标描述
/// Exe:      do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).test3()
/// Others:   d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CodeTypeItemQuery","RelKpiItemQuery","41","Code","Dr")
/// 
Query RelKpiItemQuery(typeId As %Text, searcheCondsearcheCond As %String, searcheValue As %String) As %Query(ROWSPEC = "ID:%String,kpiCode:%String,kpiDesc:%String") [ SqlProc ]
{
}

ClassMethod RelKpiItemQueryExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	s relId=0 f  s relId=$o(^DHCWL.CheckFun.SetKpiReI("Set",typeId,relId)) q:relId=""  d
	.s kpiId=$list(^DHCWL.CheckFun.SetKpiReD(relId),3)
	.s kpiDesc=$list(^DHCWL.CheckFun.CheckKPID(kpiId),3)
	.s kpiCode=$list(^DHCWL.CheckFun.CheckKPID(kpiId),2)
	.s kpiCodes=$zconvert(kpiCode,"U")
	.s searcheValues=$zconvert(searcheValue,"U")
	.i (searcheCond="Code")&(searcheValue'="") q:kpiCodes'[searcheValues
	.i (searcheCond="Name")&(searcheValue'="") q:kpiDesc'[searcheValue
	.s ^CacheTemp(repid,ind)=$lb(kpiId,kpiCode,kpiDesc)
	.s ind=ind+1
	k ^TEMPDHCWLDJJ("objId")


	Quit $$$OK
}

ClassMethod RelKpiItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RelKpiItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod RelKpiItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RelKpiItemQueryExecute ]
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

/// Creater:  ans
/// CreatDate:2015-07-24
/// Name:     获取日期区间
/// Table:    DHCWL_MKPI.DHCWLKPIMonths  DHCWL_MKPI.DHCWLSection
/// InPut:    typeId:考核方案id,searcheCondsearcheCond:查询方式,searcheValue:查询输入内容
/// OutPut:   ID:日期id,eDate:日期
/// Exe:      do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).test4()
/// Others:   d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CodeTypeItemQuery","EDateQuery","41","Name","2012")
/// 				^DHCWL.MKPI.SectionI("SecName"  ^DHCWL.MKPI.MonthsI("SectionFlag"
/// 
Query EDateQuery(typeId As %Text, searcheCondsearcheCond As %String, searcheValue As %String) As %Query(ROWSPEC = "ID:%String,eDate:%String") [ SqlProc ]
{
}

ClassMethod EDateQueryExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	s secType=$list(^DHCWL.CheckFun.CheckSetD(typeId),4)
	s secId="" f  s secId=$o(^DHCWL.MKPI.SectionI("SecName",secType,secId)) q:secId=""  d
	.s monId="" f  s monId=$o(^DHCWL.MKPI.MonthsI("SectionFlag",secId,monId)) q:monId=""  d
	..s monDesc=$list(^DHCWL.MKPI.MonthsD(monId),2)
	..i (searcheCond="Code")&(searcheValue'="") q:monDesc'[searcheValue 
	..i (searcheCond="Name")&(searcheValue'="") q:monDesc'[searcheValue 
	..s ^CacheTemp(repid,ind)=$lb(monId,monDesc)
	..s ind=ind+1


	Quit $$$OK
}

ClassMethod EDateQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EDateQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod EDateQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EDateQueryExecute ]
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

}
