Import SQLUser

/// 配液分类维护  Creator: LiangQiang 2010-03-26
Class web.DHCSTPIVAORDTYPE Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetPIVAOrdTypeExecute(ByRef qHandle As %Binary) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s potyid="0"
    f  s potyid=$o(^PIVATY(potyid)) q:potyid=""  d
    .s catdr=$p(^PIVATY(potyid),"^",2)
    .s subcatdr=$p(^PIVATY(potyid),"^",1)
    .s cat=""
    .s:catdr'="" cat=$p(^PHCC(catdr),"^",2)
    .s subcat=""
    .s:subcatdr'="" subcat=$p(^PHCC(+subcatdr,"SC",$p(subcatdr,"||",2)),"^",2)
    .q:(cat="")&(subcat="")
    .s phcrowid=catdr
    .s:subcat'="" phcrowid=subcatdr
    .d OutRowOrdType
	Quit $$$OK
OutRowOrdType
	set Data=$lb(cat,subcat,phcrowid,potyid)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPIVAOrdTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPIVAOrdTypeExecute ]
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

Query GetPIVAOrdType() As %Query(ROWSPEC = "Tcat:%String,Tsubcat:%String,Tphcrowid:%String,Trowid:%String")
{
}

ClassMethod GetPIVAOrdTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPIVAOrdTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:更新配液类型表
/// Table:PIVA_OrdType
ClassMethod UpdatePIVAOrdType(phccat, phsubcat, rowid) As %String
{
	 n (phccat,phsubcat,rowid)
	 &sql(update PIVA_OrdType set POTY_SubCat_Dr=:phsubcat, POTY_PhcCat_Dr=:phccat where POTY_Rowid=:rowid)
	 q SQLCODE
}

/// Description:插入配液类型表
/// Table:PIVA_OrdType
ClassMethod InsertPIVAOrdType(phccat, phsubcat) As %String
{
	 s PLIST(2)=phsubcat
	 s PLIST(3)=phccat
	 s typerowid=$o(^PIVATY(0,"PHCCAT",phccat,""))
	 q:typerowid'="" -1
	 s rowid=""
	 &sql(select POTY_Rowid into :rowid from PIVA_OrdType where POTY_SubCat_Dr=:phsubcat and POTY_PhcCat_Dr=:phccat)
	 if rowid="" d
	 .&sql(insert into   PIVA_OrdType values PLIST())
	 q SQLCODE
}

/// Description:插入配液类型表
/// Table:PIVA_OrdType
ClassMethod DeletePIVAOrdType(rowid) As %String
{
     n (rowid)
	 &sql(Delete from  PIVA_OrdType where POTY_Rowid=:rowid)
	 q SQLCODE
}

Storage Default
{
<Data name="DHCSTPIVAORDTYPEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPIVAORDTYPED</DataLocation>
<DefaultData>DHCSTPIVAORDTYPEDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCSTPIVAORDTYPED</IdLocation>
<IndexLocation>^web.DHCSTPIVAORDTYPEI</IndexLocation>
<StreamLocation>^web.DHCSTPIVAORDTYPES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
