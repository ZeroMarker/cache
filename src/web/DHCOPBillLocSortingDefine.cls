Import SQLUser

/// Creator:Lid
/// CreatDate:2012-07-12
/// Desc:科室分类定义业务
Class web.DHCOPBillLocSortingDefine Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Query FindLocSorting(LocSorting As %String = "", PYM As %String = "") As %Query(ROWSPEC = "TLocSortingDR,TLocSortiingDesc,TLocSortingCode,TAddUser,TAddDate,TUpdateUser,TUpdateDate")
{
}

ClassMethod FindLocSortingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocSortingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindLocSortingExecute(ByRef qHandle As %Binary, LocSorting As %String = "", PYM As %String = "") As %Status
{
 	;d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDC","HDDCDetail",3,2)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;if ($G(HosDisDR)="") Set qHandle=$lb(0,repid,0) quit $$$OK
	Set LocSorting=$$ALPHAUP^SSUTIL4(LocSorting)
	Set PYM=$$ALPHAUP^SSUTIL4(PYM)
  	;
  	Set LocSortingDR="0"
  	For  Set LocSortingDR=$o(^DHCLocSorting(LocSortingDR)) Quit:LocSortingDR=""  Do
  	.Set (AddUserName,AddDateDisplay,UpdateUserName,UpdateDateDisplay)=""
  	.Set s=$g(^DHCLocSorting(LocSortingDR))
	.Set LocSortingCode=$p(s,"^",1)
	.Set LocSortingDesc=$p(s,"^",2)
	.Quit:(LocSorting'="")&(LocSortingDesc'[LocSorting)
	.Quit:(PYM'="")&(LocSortingCode'[PYM)
	.Set AddUser=$p(s,"^",3)
	.Set:AddUser'="" AddUserName=$p($g(^SSU("SSUSR",AddUser)),"^",2)
	.Set AddDate=$p(s,"^",4)
	.Set:AddDate'="" AddDateDisplay=##class(websys.Conversions).DateLogicalToHtml(AddDate)
	.Set AddTime=$p(s,"^",5)
	.Set:AddTime'="" AddTimeDisplay=##class(websys.Conversions).TimeLogicalToHtml(AddTime,1)
	.Set UpdateUser=$p(s,"^",6)
	.Set:UpdateUser'="" UpdateUserName=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
	.Set UpdateDate=$p(s,"^",7)
	.Set:UpdateDate'="" UpdateDateDisplay=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	.Set UpdateTime=$p(s,"^",8)
	.Set:UpdateTime'="" UpdateTimeDisplay=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime,1)
	.Do OutputRow1
	;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(LocSortingDR,LocSortingDesc,LocSortingCode,$g(AddUserName),$g(AddDateDisplay),$g(UpdateUserName),$g(UpdateDateDisplay))
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindLocSortingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocSortingExecute ]
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

ClassMethod InsertLocSorting(LocSorting, Code, Guser, OrderType)
{
	;w ##class(web.DHCOPBillLocSortingDefine).InsertLocSorting("急诊科","JZK",3881)
	New (LocSorting,Code,Guser,OrderType)
	Set AddDate=+$h,AddTime=$p($h,",",2)
	Set rtn=0
	Set Code=$$ALPHAUP^SSUTIL4(Code)
	Set LocSorting=$$ALPHAUP^SSUTIL4(LocSorting)
	Quit:$d(^DHCLocSorting(0,"Code",Code)) -1001	//编码不能重复
	Quit:$d(^DHCLocSorting(0,"Desc",LocSorting)) -1002	//科室分类名称不能重复
	;
	TSTART
	;
	&sql(insert into DHC_LocSorting(DLS_Desc,DLS_Code,DLS_AddUser_DR,DLS_AddDate,DLS_AddTime,DLS_OrderType)values(:LocSorting,:Code,:Guser,:AddDate,:AddTime,:OrderType))
	Set rtn=SQLCODE
	Set DLSRowID=%ROWID
	;
	If +rtn=0 Do
	.b ;插入采血地点表,默认采血地为空
	.Set err=##class(web.DHCOPBillHDDC).AddHDDCDetail(DLSRowID,"")
	.Set rtn=$p(err,"^",1)
	.Set HDDCRowID=$p(err,"^",2)
	;
	If +rtn=0 Do
	.q:OrderType'="L"	;只有检验在建立分类时插入医嘱项明细，其他分类需要手工添加。
	.;插入特殊项目项目采血地点表,默认采血地为空
	.;所有的检验医嘱都需插入
	.;^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version})
	.Set ItmCatDR=""
	.For  Set ItmCatDR=$o(^ARCIM(0,"ARCIC_DR",ItmCatDR)) Quit:((ItmCatDR="")!(+rtn'=0))  Do
	..Set OrderType=$p(^ARC("IC",ItmCatDR),"^",7) ;ARCIC_OrderType
	..Quit:OrderType'="L"  ;过滤非检验医嘱项
	..Set Subscript=""
	..For  Set Subscript=$o(^ARCIM(0,"ARCIC_DR",ItmCatDR,Subscript)) Quit:((Subscript="")!(+rtn'=0))  Do
	...Set Version=""
	...For  Set Version=$o(^ARCIM(0,"ARCIC_DR",ItmCatDR,Subscript,Version)) Quit:((Version="")!(+rtn'=0))  Do
	....Set EffDateTo=$p(^ARCIM(Subscript,Version,7),"^",1) ;ARCIM_EffDateTo 
	....Quit:EffDateTo'="" ;过滤已停止使用的医嘱项
	....Set ArcimRowid=Subscript_"||"_Version
	....Set err=##class(web.DHCOPBillHDDCArcim).AddHDDCArcim(HDDCRowID, ArcimRowid, "", Guser)
	....Set rtn=$p(err,"^",1)
	....Set HDDCSRowID=$p(err,"^",2)
	;
	b ;11
	If +rtn=0 Do
	.TCOMMIT
	Else  Do
	.Trollback
	;
	Quit rtn
}

ClassMethod DeleteLocSorting(LocSortingDR)
{
	New (LocSortingDR)
	Quit:$d(^DHCLocSortingLinkLoc(0,"DLS",LocSortingDR)) "-1003" ;如果分类已经关联了科室，则不能删除.
	&sql(delete from DHC_LocSorting where DLS_Rowid=:LocSortingDR)
	Quit SQLCODE
}

ClassMethod UpdateLocSorting(LocSortingDR, LocSorting, Code, Guser, OrderType)
{
	New (LocSortingDR,LocSorting,Code,Guser,OrderType)
	Set rtn=0
	Set Code=$$ALPHAUP^SSUTIL4(Code)
	Set LocSorting=$$ALPHAUP^SSUTIL4(LocSorting)
	Set myLocSortingCode=$p(^DHCLocSorting(LocSortingDR),"^",1)
	Quit:Code'=myLocSortingCode -1004	//编码不能修改
	Quit:$d(^DHCLocSorting(0,"Desc",LocSorting)) -1002	//科室分类名称不能重复	
	;
	Set Date=+$h,Time=$p($h,",",2)
	&sql(update DHC_LocSorting set DLS_Desc=:LocSorting,DLS_UpdateUser_DR=:Guser,DLS_UpdateDate=:Date,DLS_UpdateTime=:Time,DLS_OrderType=:OrderType  where DLS_RowID=:LocSortingDR)	
	Quit SQLCODE
}

Query OrderType() As %Query(ROWSPEC = "TOrderTypeValue,TOrderTypeDesc")
{
}

ClassMethod OrderTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OrderTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	;d ##class(%ResultSet).RunQuery("web.DHCOPBillLocSortingDefine","OrderType")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;
	;Set OrderTypeDesc="",OrderTypeValue=""
	;Do OutputRow2
	Set OrderTypeStr="药品^R!检验^L!检查^S!治疗^N"
	For i=1:1:$L(OrderTypeStr,"!") Do
	.Set OrderTypeDesc=$p($p(OrderTypeStr,"!",i),"^",1)
	.Set OrderTypeValue=$p($p(OrderTypeStr,"!",i),"^",2)
	.Quit:(OrderTypeValue="R")!(OrderTypeValue="S")
	.Do OutputRow2
	;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(OrderTypeValue,OrderTypeDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod OrderTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderTypeExecute ]
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

}
