Import SQLUser

Class web.DHCWMRFPTempQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 35;

ClassMethod BuildData(repid, ind, s)
{
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod QueryFPIDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPIDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPIDicExecute(ByRef qHandle As %Binary, Tp As %String, Fg As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:Tp="" $$$OK
	
	;^DHCWMRFPIDIC(0,"Type",{DataType},{RowId})
	s id=0
	f  s id=$o(^DHCWMRFPIDIC(0,"Type",Tp,id)) q:id=""  d
	.s s=$g(^DHCWMRFPIDIC(id))
	.q:(Fg'="")&&(Fg'=$p(s,"^",6))
	.s s=id_"^"_$p(s,"^",1)
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPIDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPIDicExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFPTempQry","QueryFPIDic",Tp,Fg)
Query QueryFPIDic(Tp As %String, Fg As %String) As %Query(ROWSPEC = "lsId:%String,lsDesc:%String")
{
}

ClassMethod QueryFPIDicByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPIDicByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPIDicByDescExecute(ByRef qHandle As %Binary, Desc As %String, Fg As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^DHCWMRFPIDIC(0,"Desc",{Description},{RowId})
	s ^liulan("Desc")=Desc_"^"_Fg
	s tmpDesc=""
	s:Desc'="" tmpDesc=$o(^DHCWMRFPIDIC(0,"Desc",Desc),-1)
	f  s tmpDesc=$o(^DHCWMRFPIDIC(0,"Desc",tmpDesc)) q:(tmpDesc="")||(tmpDesc'[Desc)  d
	.s id=0
	.f  s id=$o(^DHCWMRFPIDIC(0,"Desc",tmpDesc,id)) q:id=""  d
	..s s=$g(^DHCWMRFPIDIC(id))
	..q:(Fg'="")&&(Fg'=$p(s,"^",6))
	..q:($p(s,"^",6)'="Y")
	..s s=id_"^"_$p(s,"^",1)
	..d ..BuildData(repid,ind,s)
	..s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPIDicByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPIDicByDescExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFPTempQry","QueryFPIDicByDesc","","")
Query QueryFPIDicByDesc(Desc As %String, Fg As %String) As %Query(ROWSPEC = "lsId:%String,lsDesc:%String")
{
}

ClassMethod QueryFPIDAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPIDAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPIDAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s id=0
	f  s id=$o(^DHCWMRFPIDIC(id)) q:id=""  d
	.s s=$g(^DHCWMRFPIDIC(id))
	.s DicId=+$p(s,"^",2)
	.s tmpDic=$g(^DHCWMRDIC(DicId))
	.s:DicId'=0 $p(s,"^",2)=DicId_"/"_$p(tmpDic,"^",3)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPIDAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPIDAllExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFPTempQry","QueryFPIDAll")
Query QueryFPIDAll() As %Query(ROWSPEC = "Rowid:%String,Description:%String,DataType:%String,DefaultVal:%String,DicName:%String,Resume:%String,Active:%String")
{
}

ClassMethod QueryFPTAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPTAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPTAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s id=0
	f  s id=$o(^DHCWMRFPT(id)) q:id=""  d
	.s s=$g(^DHCWMRFPT(id))
	.s DicId=+$p(s,"^",3)
	.s tmpDic=$g(^DHCWMRDIC(DicId))
	.s:DicId'=0 $p(s,"^",3)=DicId_"/"_$p(tmpDic,"^",3)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPTAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPTAllExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFPTempQry","QueryFPTAll")
Query QueryFPTAll() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,MrType:%String,Active:%String,Resume:%String")
{
}

ClassMethod QueryFPTDAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFPTDAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryFPTDAllExecute(ByRef qHandle As %Binary, TempId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:TempId="" $$$OK
	
	;^DHCWMRFPTD(0,"TempId",{TempId},{RowId})
	s id=0
	f  s id=$o(^DHCWMRFPTD(0,"TempId",TempId,id)) q:id=""  d
	.s s=$g(^DHCWMRFPTD(id))
	.s tmpTempId=+$p(s,"^",1)
	.s tmpTemp=$g(^DHCWMRFPT(tmpTempId))
	.s:tmpTempId'=0 $p(s,"^",1)=tmpTempId_"/"_$p(tmpTemp,"^",2)
	.s tmpItemId=+$p(s,"^",2)
	.s tmpItem=$g(^DHCWMRFPIDIC(tmpItemId))
	.s:tmpItemId'=0 $p(s,"^",2)=tmpItemId_"/"_$p(tmpItem,"^",1)
	.s s=id_"^"_s
	.d ..BuildData(repid,ind,s)
	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryFPTDAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFPTDAllExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRFPTempQry","QueryFPTDtlAll")
Query QueryFPTDAll(TempId As %String) As %Query(ROWSPEC = "Rowid:%String,Temp:%String,Item:%String,Pos:%String,DefaultVal:%String,ToolTip:%String,Resume:%String")
{
}

/// 通过MrTypeDr取当前有效模板项目
/// w ##Class(web.DHCWMRFPTempQry).GetTempItem(MrType)
ClassMethod GetTempItem(MrType)
{
	n (MrType)
	s ret=""
	
	;^DHCWMRFPT(0,"MrTypeDr",{MRTypeDr},{RowId})
	q:'$d(^DHCWMRFPT(0,"MrTypeDr",+MrType)) ret
	s TempId=""
	f  s TempId=$o(^DHCWMRFPT(0,"MrTypeDr",+MrType,TempId),-1) q:(TempId="")||($g(IsActive)="Y")  d
	.q:'$d(^DHCWMRFPT(TempId))
	.s tmpTemp=$g(^DHCWMRFPT(TempId))
	.s IsActive=$p(tmpTemp,"^",4)
	.q:IsActive'="Y"
	.
	.;^DHCWMRFPTD(0,"TempId",{TempId},{RowId})
	.s ItemId=0
	.f  s ItemId=$o(^DHCWMRFPTD(0,"TempId",TempId,ItemId)) q:ItemId=""  d
	..q:'$d(^DHCWMRFPTD(ItemId))
	..s tmpItem=$g(^DHCWMRFPTD(ItemId))
	..s TMP=ItemId_"^"_tmpItem
	..;w TMP,!
	..s ret=ret_$c(1)_TMP
	s ret=$e(ret,2,$l(ret))
	q ret
}

/// Add By LiYang 2009-08-24
/// 获取所有附加项目列表
ClassMethod GetAllTempItem() As %String
{
	s ret=""
	s id=0 f  s id=$o(^DHCWMRFPIDIC(id)) q:id=""  d
	.s s=$g(^DHCWMRFPIDIC(id))
	.s s=id_"^"_s
	.;s DicId=+$p(s,"^",2)
	.;s tmpDic=$g(^DHCWMRDIC(DicId))
	.;s:DicId'=0 $p(s,"^",2)=DicId_"/"_$p(tmpDic,"^",3)
	.;s s=id_"^"_s
	.s:ret'="" ret=ret_$c(1)
	.s ret=ret_s
	q ret
}

}
