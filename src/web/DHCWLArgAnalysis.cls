Import SQLUser

Class web.DHCWLArgAnalysis Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      duh
/// CreatDate：    2016年9月2日 15:51:57
/// Description:： 获取所有药学子分类 
/// Table：      phc_subcat
/// Input：       
/// Output：    subCatId:id，subCatDesc:描述
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgAnalysis","GetPHCSubCat") 
Query GetPHCSubCat() As %Query(ROWSPEC = "subCatId:%String,subCatDesc:%String") [ SqlProc ]
{
}

ClassMethod GetPHCSubCatExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s cat = 0 f  s cat = $o(^PHCC(cat)) q:cat=""  d
    .s subId = 0 f  s subId = $o(^PHCC(cat,"SC",subId)) q:subId=""  d
    ..s subCatId = cat_"||"_subId
    ..s subCatDesc = $p(^PHCC(cat,"SC",subId),"^",2)
    ..d outputRow1
	Quit $$$OK
	
outputRow1
 s row=$listbuild(subCatId,subCatDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetPHCSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPHCSubCatExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPHCSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPHCSubCatExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator：      duh
/// CreatDate：    2016年9月2日 16:03:52
/// Description:： 获取所有相关执行科室临床科室等业务科室
/// Table：      CT_LOC
/// Input：       
/// Output：    subCatId:id，subCatDesc:描述
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgAnalysis","GetCTLoc") 
Query GetCTLoc() As %Query(ROWSPEC = "locId:%String,locDesc:%String") [ SqlProc ]
{
}

ClassMethod GetCTLocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s locId = 0 f  s locId = $o(^CTLOC(locId)) q:locId=""  d
    .s rbc = $P(^CTLOC(locId),"^",19)   //科室资源表
    .q:((rbc'=1)&&(rbc'=2)&&(rbc'=3)&&(rbc'=4))
 	.s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(locId)
    .d outputRow2
	Quit $$$OK
	
outputRow2
 s row=$listbuild(locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator：      duh
/// CreatDate：    2016年9月2日 16:48:25
/// Description:： 获取医嘱项目,放大镜使用可通过入参过滤,使用这个查表时需要导入Import SQLUser在开头
/// Table：      arcitmmast
/// Input：       
/// Output：    ARCIM_RowId:id,ARCIM_Desc:描述
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgAnalysis","GetOrCate") 
Query GetOrCate(desc As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT ARCIM_RowId, ARCIM_Desc FROM ARC_ItmMast WHERE ARCIM_Desc like "%"_:desc_"%"
}

///  Creator：      duh
///  CreatDate：    2016年10月21日 15:51:44
///  Description:： 获取收费项目
///  Table：      dhc_taritem
///  Input：       
///  Output：    
///  Return：      
///  Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgAnalysis","GetTarItem") 
Query GetTarItem() As %Query(ROWSPEC = "tarId:%String,tarDesc:%String")
{
}

ClassMethod GetTarItemExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s tarId = 0  f  s tarId = $o(^DHCTARI(tarId)) q:tarId=""  d
    .q:tarId=7592
    .s tarDesc = $p(^DHCTARI(tarId),"^",2)
    .d outputRow3
	Quit $$$OK
	
outputRow3
 s row=$listbuild(tarId,tarDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetTarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarItemExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarItemExecute ]
{
	n (qHandle,Row,AtEnd)
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

///  Creator：      duh
///  CreatDate：    2017年2月28日 10:25:13
///  Description:： 通过ssuer code 获取医生姓名
///  Table：     ss_user
///  Input：       
///  Output：    
///  Return：      
///  Others：d ##class(%ResultSet).RunQuery("web.DHCWLArgAnalysis","GetDocName","0003") 
Query GetDocName(ssCode As %String) As %Query(ROWSPEC = "ssName:%String") [ SqlProc ]
{
}

ClassMethod GetDocNameExecute(ByRef qHandle As %Binary, ssCode As %String) As %Status
{
	n (qHandle,ssCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s ssId =$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(ssCode,"u"),""))
    s ssName = $p(^SSU("SSUSR",ssId),"^",2)
    d outputRow4
	Quit $$$OK
	
outputRow4
 s row=$listbuild(ssName)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetDocNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocNameExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocNameExecute ]
{
	n (qHandle,Row,AtEnd)
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
