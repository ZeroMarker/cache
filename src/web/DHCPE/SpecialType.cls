/// 体检特殊客户类型管理
Class web.DHCPE.SpecialType Extends %RegisteredObject
{

/// Creator： xy
/// CreatDate： 2020-07-27
/// Description: 新增、更新特殊客户类型
/// Input: 
/// Return： 
/// dubug: w ##class(web.DHCPE.SpecialType).SaveSPType()
ClassMethod SaveSPType(ID, SaveInfo)
{
	
	S Code=$P(SaveInfo,"^",1)
	S Desc=$P(SaveInfo,"^",2)
	s SPCode="",SPDesc=""

	if (ID="") d
	.s Obj=##class(User.DHCPESpecialType).%New()
	e  d
	.s Obj=##class(User.DHCPESpecialType).%OpenId(ID)
	.s SPCode=$LG(^User.DHCPESpecialTypeD(ID),2)
	.S SPDesc=$LG(^User.DHCPESpecialTypeD(ID),3)
	q:(SPCode'=Code)&($d(^User.DHCPESpecialTypeI("SPTCodeIndex"," "_Code))) "0^代码重复!"
	q:(SPDesc'=Desc)&($d(^User.DHCPESpecialTypeI("SPTDescIndex"," "_Desc))) "0^描述重复!"

	s Obj.SPTCode=$P(SaveInfo,"^",1)
	s Obj.SPTDesc=$P(SaveInfo,"^",2)
	s Obj.SPTActiveFlag=$P(SaveInfo,"^",3)
	s sc=Obj.%Save()
	d Obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q Obj.%Id()
	}
}

/// Description: 查询体检特殊客户类型
/// debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SpecialType","SearchSPType")
Query SearchSPType() As %Query(ROWSPEC = "Code:%String,Desc:%String,ActiveFlag:%String,ID:%String")
{
}

ClassMethod SearchSPTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	S ID=""
	f  s ID=$O(^User.DHCPESpecialTypeD(ID))  Q:ID=""  d
	.s Code=$LG(^User.DHCPESpecialTypeD(ID),2)
	.s Desc=$LG(^User.DHCPESpecialTypeD(ID),3)
	.S ActiveFlag=$LG(^User.DHCPESpecialTypeD(ID),4)
	.S Active="否"
	.i ActiveFlag="Y" S Active="是"

    .d FindBuildSPType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	q
FindBuildSPType  
	set Data=$lb(Code,Desc,Active,ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSPTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSPTypeExecute ]
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

ClassMethod SearchSPTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSPTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 体检特殊客户类型下拉列表显示
/// dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.SpecialType","FindSPType")
Query FindSPType() As websys.Query(ROWSPEC = "id:%String,Desc:%String")
{
}

ClassMethod FindSPTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
     
     s id=0
     f  s id=$O(^User.DHCPESpecialTypeD(id)) q:id=""  d
	.s ActiveFlag=$LG(^User.DHCPESpecialTypeD(id),4)
	.q:ActiveFlag'="Y"
	.S Desc=$LG(^User.DHCPESpecialTypeD(id),3)
	.S Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPESpecialType",Desc,"SPTDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(id,Desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator： xy
/// CreatDate： 2020-07-28
/// Description: 根据登记后获取体检特殊客户类型编码
/// Input: 
/// Return： 
/// dubug: w ##class(web.DHCPE.SpecialType).GetSpecialType("0000000001")
ClassMethod GetSpecialType(RegNo As %Library.String = "")
{
	q:RegNo="" ""
	q:'$d(^DHCPECBSpecial("PIBI",RegNo)) ""
	s SpecialTypeDR=$g(^DHCPECBSpecial("PIBI",RegNo)) //特殊客户类型
	s Code=""
	i SpecialTypeDR'="" d
	.s Code=$LG(^User.DHCPESpecialTypeD(SpecialTypeDR),2)
	q Code
}

}
