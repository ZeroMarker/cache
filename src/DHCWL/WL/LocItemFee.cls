Class DHCWL.WL.LocItemFee Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//检查项目月报=@CTLOCID

//d ##class(%ResultSet).RunQuery("DHCWL.WL.LocItemFee","GetJcXmYb","2008-7-01","2008-7-31","I","27")	

ClassMethod GetJcXmYbExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, type As %String, recdep As %String) As %Status
{
	;n (SDate,EDate,recdep)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    i recdep="" s recdep=0
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
   	q:recdep="" $$$OK
  	//s ^yx(1)=type_"^"_recdep
    k ^temp($j),^temp1($j)
    ;s luserid="" f  s luserid=$O(^SSU("SSUSR",0,"Group",350,luserid)) q:luserid=""  d
    ;.s usercode=$p(^SSU("SSUSR",luserid),"^",1)
    ;.s ^temp1($j,usercode)=usercode
    
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f OrdDate=SDate:1:EDate d
	.s WLRowid=0,Counts=0,Fee=0
	.f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
	..s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4)
	..q:$F(","_type_",",","_PAADMType_",")=0 
	..s WLResLoc=$p(^DHCWorkLoad(WLRowid),"^",3)  ;病人科室
	..;q:((WLResLoc="1542") || (WLResLoc="1543") || (WLResLoc="53") || (WLResLoc="572")) 
	..s RecLoc=$p(^DHCWorkLoad(WLRowid),"^",1)  ;接收科室
	..q:($F(","_recdep_",",","_RecLoc_",")=0)&(recdep'="0") 
    ..s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ..s Counts=$p(^DHCWorkLoad(WLRowid),"^",15)             ;医嘱次数   
    ..s taritemdr=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	..s TarCate=$p(^DHCTARI(taritemdr),"^",4)       ;收费子分类
    ..s resDocId=$p($g(^DHCWorkLoad(WLRowid)),"^",19)
	..;s resDocStr=$$GetDocNameAndCode^DHCWLToWangHai(resDocId)
	..;s resDocCode=$p(resDocStr,"^",2)
	..;q:$d(^temp1($j,resDocCode))
	..s ^temp($j,RecLoc,TarCate,taritemdr,"Fee")=$g(^temp($j,RecLoc,TarCate,taritemdr,"Fee"))+Fee
	..s ^temp($j,RecLoc,TarCate,taritemdr,"Qty")=$g(^temp($j,RecLoc,TarCate,taritemdr,"Qty"))+Counts

	s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s cat=0 f  s cat=$o(^temp($j,loc,cat)) q:cat=""  d
    ..s itm=0 f  s itm=$o(^temp($j,loc,cat,itm)) q:itm=""  d
    ...s income=$g(^temp($j,loc,cat,itm,"Fee")) 
    ...s qty=$g(^temp($j,loc,cat,itm,"Qty")) 
    ...d OutputRow1
    k ^temp($j),^temp1($j)
 	q $$$OK	
OutputRow1
    i $d(^CTLOC(loc)) d
    .s DepName1=$P($G(^CTLOC(loc)),"^",2)  
    .i DepName1 [ "-" s DepName=$p(DepName1,"-",2)
    .e  s DepName=DepName1
    
    i $d(^DHCTarC("SC",cat)) s catDesc=$p(^DHCTarC("SC",cat),"^",2)  
    i $d(^DHCTARI(itm)) s itmdesc=$p(^DHCTARI(itm),"^",2) 
   
    s Data=$lb(loc,DepName,cat,catDesc,itm,itmdesc,$fn(income,"",2),$fn(qty,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetJcXmYbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJcXmYbExecute ]
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

ClassMethod GetJcXmYbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJcXmYbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetJcXmYb(SDate As %String, EDate As %String, type As %String, recdep As %String) As %Query(ROWSPEC = "loc:%Integer,DepName:%String,cat:%Integer,catDesc:%String,itm:%Integer,itmdesc:%String,income:%Float,qty:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("DHCWL.WL.LocItemFee","GetDep","3901")	

ClassMethod GetDepExecute(ByRef qHandle As %Binary, useId As %String) As %Status
{
	n (qHandle,useId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    q:useId="" $$$OK
   
    s outdata=$$GetUserLoginLoc^DHCWLGetCurrentPatFee(useId,.data)
    ;s outdata=$$GetUserLoginLoc^RunQianQueryDHCWL(useId,.data)
    s num=""
    f num=0:1:outdata-1 d
    .s loc=$p(data(num),"^",1)
    .s desc=$p(data(num),"^",2) q:desc["药"
    .d OutputRow2
 	q $$$OK	

OutputRow2
  
    s Data=$lb(loc,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepExecute ]
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

ClassMethod GetDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDep(useId As %String) As %Query(ROWSPEC = "loc:%Integer,desc:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("DHCWL.WL.LocItemFee","GetAllDep")

ClassMethod GetAllDepExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    //q:type="" $$$OK
   
    //s outdata=$$GetUserLoginLoc^DHCWLGetCurrentPatFee(useId,.data)
    ;s outdata=$$GetUserLoginLoc^RunQianQueryDHCWL(useId,.data)
    //s locid="0"
    //s desc="全部"
    //d OutputRow4
    s desc="" f  s desc=$o(^CTLOC(0,"Desc",desc)) q:desc=""  d
    .s locid=0 f  s locid=$o(^CTLOC(0,"Desc",desc,locid)) q:locid=""  d
    ..q:desc["药"
    ..d OutputRow4
 	q $$$OK	

OutputRow4
  
    s Data=$lb(locid,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAllDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepExecute ]
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

ClassMethod GetAllDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAllDep() As %Query(ROWSPEC = "loc:%Integer,desc:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="LocItemFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.WL.LocItemFeeD</DataLocation>
<DefaultData>LocItemFeeDefaultData</DefaultData>
<IdLocation>^DHCWL.WL.LocItemFeeD</IdLocation>
<IndexLocation>^DHCWL.WL.LocItemFeeI</IndexLocation>
<StreamLocation>^DHCWL.WL.LocItemFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
