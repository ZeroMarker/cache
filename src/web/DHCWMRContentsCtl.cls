Import SQLUser

Class web.DHCWMRContentsCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 53;

/// ***************************************
/// 病案卷目录大类
/// ***************************************
/// Update目录大类
ClassMethod UpdateContents(Condition)
{
	n (Condition)
	
	s ret=-1
    q:Condition="" ret
    s RowId=$p(Condition,"^",1)
    s Code=$p(Condition,"^",2)
    s Desc=$p(Condition,"^",3)
    i RowId'="" d
    .&sql(select * into :PLIST() from DHC_WMR_Contents where Rowid=:RowId)
    .s:SQLCODE ret=-2
    q:ret=-2 ret
    
    s:Code'="" PLIST(2)=Code
    s:Desc'="" PLIST(3)=Desc
    i RowId="" d
    .&sql(Insert into DHC_WMR_Contents values :PLIST())
    e  d
    .&sql(Update DHC_WMR_Contents values :PLIST() where Rowid=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Get目录大类
ClassMethod GetContentsByRowId(ContentsRowId)
{
	n (ContentsRowId)
	
	s ret=""
	q:ContentsRowId="" ret
	q:'$d(^DHCWMRCNT(ContentsRowId)) ret
	s ret=ContentsRowId_"^"_$g(^DHCWMRCNT(ContentsRowId))
	q ret
}

/// BuildData目录大类
ClassMethod BuildDataContents(repid, ind, ContentsRowId)
{
	//n (repid, ind, ContentsRowId)
	set ContentsInfo=$g(^DHCWMRCNT(ContentsRowId))
	set Code=$p(ContentsInfo,"^",1)
	set Desc=$p(ContentsInfo,"^",2)
	
	set $li(Data,1)=ContentsRowId     //ContentsRowId
	set $li(Data,2)=Desc              //Desc
	set $li(Data,3)=Code              //Code
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryContentsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContentsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryContentsExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ContentsRowId=0
	f  s ContentsRowId=$o(^DHCWMRCNT(ContentsRowId)) q:ContentsRowId=""  d
	.q:'$d(^DHCWMRCNT(ContentsRowId))
	.d ..BuildDataContents(repid, ind,ContentsRowId)
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryContentsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContentsExecute ]
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

/// Query目录大类
Query QueryContents() As %Query(ROWSPEC = "ContentsRowId:%String,Desc:%String,Code:%String")
{
}

/// ***************************************
/// 病案卷目录子类
/// ***************************************
/// Update目录子类
ClassMethod UpdateContSub(Condition)
{
	n (Condition)
    
    s ret=-1
    q:Condition="" ret
    s RefId=$p(Condition,"^",1)
    q:RefId="" ret
    s SubId=$p(Condition,"^",2)
    s Code=$p(Condition,"^",3)
    s Desc=$p(Condition,"^",4)
    s IsRequest=$p(Condition,"^",5)
    s:IsRequest'="" IsRequest=$s(IsRequest["Y":"Y",1:"N")
    q:((SubId="")&&(IsRequest="")) ret
    i SubId'="" d
    .&sql(select * into :PLIST() from DHC_WMR_ContSub where ParRef=:RefId and ChildSub=:SubId)
    .s:SQLCODE ret=-2
    q:ret=-2 ret
    
    s PLIST(0)=RefId
    s:Code'="" PLIST(3)=Code
    s:Desc'="" PLIST(4)=Desc
    S:IsRequest'="" PLIST(5)=IsRequest
    i SubId="" d
    .&sql(Insert into DHC_WMR_ContSub values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ContSub values :PLIST() where ParRef=:RefId and ChildSub=:SubId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Get目录子类
ClassMethod GetContSubByRowId(ContSubRowId)
{
	n (ContSubRowId)
	
	s ret=""
	s RefId=$p(ContSubRowId,"||",1)
	s SubId=$p(ContSubRowId,"||",2)
	q:((RefId="")||(SubId="")) ret
	q:'$d(^DHCWMRCNT(RefId,"S",SubId)) ret
	s ret=ContSubRowId_"^"_$g(^DHCWMRCNT(RefId,"S",SubId))
	q ret
}

/// BuildData目录子类
ClassMethod BuildDataContSub(repid, ind, ContSubRowId)
{
	//n (repid, ind, ContSubRowId)
	set RefId=$p(ContSubRowId,"||",1)
	set SubId=$p(ContSubRowId,"||",2)
	set ContSubInfo=$g(^DHCWMRCNT(RefId,"S",SubId))
	set Code=$p(ContSubInfo,"^",1)
	set Desc=$p(ContSubInfo,"^",2)
	set IsRequest=$p(ContSubInfo,"^",3)
	
	set $li(Data,1)=ContSubRowId     //ContSubRowId
	set $li(Data,2)=Desc             //Desc
	set $li(Data,3)=Code             //Code
	set $li(Data,4)=IsRequest        //IsRequest
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryContSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryContSubExecute(ByRef qHandle As %Binary, ContentsRowId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:ContentsRowId="" $$$OK
	s SubId=0
	f  s SubId=$o(^DHCWMRCNT(ContentsRowId,"S",SubId)) q:SubId=""  d
	.s ContSubRowId=ContentsRowId_"||"_SubId
	.d ..BuildDataContSub(repid, ind,ContSubRowId)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryContSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContSubExecute ]
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

/// Query目录子类(参数:目录大类RowId)
Query QueryContSub(ContentsRowId As %String) As %Query(ROWSPEC = "ContSubRowId:%String,Desc:%String,Code:%String,IsRequest:%String")
{
}

/// ***************************************
/// 病案卷目录子类对应医嘱项目表
/// ***************************************
/// Update目录子类对应医嘱项目表
ClassMethod UpdateContSubArcim(Condition)
{
	n (Condition)
    
    s ret=-1
    q:Condition="" ret
    s RefId=$p(Condition,"^",1)
    q:RefId="" ret
    s SubId=$p(Condition,"^",2)
    s ArcimId=$p(Condition,"^",3)
    i SubId'="" d
    .&sql(select * into :PLIST() from DHC_WMR_ContSubArcim where ParRef=:RefId and ChildSub=:SubId)
    .s:SQLCODE ret=-2
    q:ret=-2 ret
    
    s PLIST(0)=RefId
    s:ArcimId'="" PLIST(3)=ArcimId
    
    i SubId="" d
    .&sql(select * into :PLIST() from DHC_WMR_ContSubArcim where ParRef=:RefId and Arcim_Dr=:ArcimId)
    .s:SQLCODE=0 ret=-3
    q:ret=-3 ret
    
    i SubId="" d
    .&sql(Insert into DHC_WMR_ContSubArcim values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ContSubArcim values :PLIST() where ParRef=:RefId and ChildSub=:SubId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Get目录子类对应医嘱项目表
ClassMethod GetContSubArcimByRowId(ContSubArcimRowId)
{
	n (ContSubArcimRowId)
	
	s ret=""
	s RefId=$p(ContSubArcimRowId,"||",1)
	s SubId=$p(ContSubArcimRowId,"||",2)
	s ChildId=$p(ContSubArcimRowId,"||",3)
	q:((RefId="")||(SubId="")||(ChildId="")) ret
	q:'$d(^DHCWMRCNT(RefId,"S",SubId,"A",ChildId)) ret
	s ContSubArcimInfo=$g(^DHCWMRCNT(RefId,"S",SubId,"A",ChildId))
	s ArcimId=$p(ContSubArcimInfo,"^",1)
	s ARCRefId=$p(ArcimId,"||",1)
	s ARCSubId=$p(ArcimId,"||",2)
	s ArcimInfo=""
	s:((ARCRefId'="")&&(ARCSubId'="")) ArcimInfo=$g(^ARCIM(ARCRefId,ARCSubId,1))
	s ArcimCode=$p(ArcimInfo,"^",1)
	s ArcimDesc=$p(ArcimInfo,"^",2)
	s ItemCatId=$p(ArcimInfo,"^",10)
	s ItemCatInfo=""
	s:(ItemCatId'="") ItemCatInfo=$g(^ARC("IC",ItemCatId))
	s ItemCatCode=$p(ItemCatInfo,"^",1)
	s ItemCatDesc=$p(ItemCatInfo,"^",2)
	
	s ArcimInfo=ArcimId_"/"_ArcimCode_"/"_ArcimDesc_"/"_ItemCatId_"/"_ItemCatCode_"/"_ItemCatDesc
	s $p(ContSubArcimInfo,"^",1)=ArcimInfo
	s ret=ContSubArcimRowId_"^"_ContSubArcimInfo
	q ret
}

/// BuildData目录子类对应医嘱项目表
ClassMethod BuildDataContSubArcim(repid, ind, ContSubArcimRowId)
{
	//n (repid, ind, ContSubArcimRowId)
	
	set RefId=$p(ContSubArcimRowId,"||",1)
	set SubId=$p(ContSubArcimRowId,"||",2)
	set ChildId=$p(ContSubArcimRowId,"||",3)
	set ContSubArcimInfo=$g(^DHCWMRCNT(RefId,"S",SubId,"A",ChildId))
	
	set ArcimId=$p(ContSubArcimInfo,"^",1)
	set ARCRefId=$p(ArcimId,"||",1)
	set ARCSubId=$p(ArcimId,"||",2)
	set ArcimInfo=""
	set:((RefId'="")&&(SubId'="")) ArcimInfo=$g(^ARCIM(ARCRefId,ARCSubId,1))
	set ArcimCode=$p(ArcimInfo,"^",1)
	set ArcimDesc=$p(ArcimInfo,"^",2)
	set ItemCatId=$p(ArcimInfo,"^",10)
	set ItemCatInfo=""
	set:(ItemCatId'="") ItemCatInfo=$g(^ARC("IC",ItemCatId))
	set ItemCatCode=$p(ItemCatInfo,"^",1)
	set ItemCatDesc=$p(ItemCatInfo,"^",2)
	
	set $li(Data,1)=ContSubArcimRowId  //ContSubArcimRowId
	set $li(Data,2)=ArcimId            //ArcimId
	set $li(Data,3)=ArcimCode          //ArcimCode
	set $li(Data,4)=ArcimDesc          //ArcimDesc
	set $li(Data,5)=ItemCatId          //ItemCatId
	set $li(Data,6)=ItemCatCode        //ItemCatCode
	set $li(Data,7)=ItemCatDesc        //ItemCatDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryContSubArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContSubArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryContSubArcimExecute(ByRef qHandle As %Binary, ContSubRowId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RefId=$p(ContSubRowId,"||",1)
	s SubId=$p(ContSubRowId,"||",2)
	q:((RefId="")||(SubId="")) $$$OK
	s ChildId=0
	f  s ChildId=$o(^DHCWMRCNT(RefId,"S",SubId,"A",ChildId)) q:ChildId=""  d
	.s ContSubArcimRowId=ContSubRowId_"||"_ChildId
	.d ..BuildDataContSubArcim(repid, ind,ContSubArcimRowId)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryContSubArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContSubArcimExecute ]
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

/// Query目录子类对应医嘱项目表
Query QueryContSubArcim(ContSubRowId As %String) As %Query(ROWSPEC = "ContSubArcimRowId:%String,ArcimId:%String,ArcimCode:%String,ArcimDesc:%String,ItemCatId:%String,ItemCatCode:%String,ItemCatDesc:%String")
{
}

/// ***************************************
/// 病案卷目录子类对应医嘱子类表
/// ***************************************
/// Update目录子类对应医嘱子类表
ClassMethod UpdateContSubItemCat(Condition)
{
	n (Condition)
    
    s ret=-1
    q:Condition="" ret
    s RefId=$p(Condition,"^",1)
    q:RefId="" ret
    s SubId=$p(Condition,"^",2)
    s ItemCatId=$p(Condition,"^",3)
    i SubId'="" d
    .&sql(select * into :PLIST() from DHC_WMR_ContSubItemCat where ParRef=:RefId and ChildSub=:SubId)
    .s:SQLCODE ret=-2
    q:ret=-2 ret
    
    i SubId="" d
    .&sql(select * into :PLIST() from DHC_WMR_ContSubItemCat where ParRef=:RefId and ItemCat_Dr=:ItemCatId)
    .s:SQLCODE=0 ret=-3
    q:ret=-3 ret
    
    s PLIST(0)=RefId
    s:ItemCatId'="" PLIST(3)=ItemCatId
    i SubId="" d
    .&sql(Insert into DHC_WMR_ContSubItemCat values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ContSubItemCat values :PLIST() where ParRef=:RefId and ChildSub=:SubId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Get目录子类对应医嘱子类表
ClassMethod GetContSubItemCatByRowId(ContSubItemCatRowId)
{
	n (ContSubItemCatRowId)
	
	s ret=""
	s RefId=$p(ContSubItemCatRowId,"||",1)
	s SubId=$p(ContSubItemCatRowId,"||",2)
	s ChildId=$p(ContSubItemCatRowId,"||",3)
	q:((RefId="")||(SubId="")||(ChildId="")) ret
	q:'$d(^DHCWMRCNT(RefId,"S",SubId,"I",ChildId)) ret
	s ContSubItemCatInfo=$g(^DHCWMRCNT(RefId,"S",SubId,"I",ChildId))
	s ItemCatId=$p(ContSubItemCatInfo,"^",1)
	s ItemCatInfo=""
	s:(ItemCatId'="") ItemCatInfo=$g(^ARC("IC",ItemCatId))
	s ItemCatCode=$p(ItemCatInfo,"^",1)
	s ItemCatDesc=$p(ItemCatInfo,"^",2)
	s ItemCatInfo=ItemCatId_"/"_ItemCatCode_"/"_ItemCatDesc
	s $p(ContSubItemCatInfo,"^",1)=ItemCatInfo
	s ret=ContSubItemCatRowId_"^"_ContSubItemCatInfo
	q ret
}

/// BuildData目录子类对应医嘱子类表
ClassMethod BuildDataContSubItemCat(repid, ind, ContSubItemCatRowId)
{
	//n (repid, ind, ContSubItemCatRowId)
	
	set RefId=$p(ContSubItemCatRowId,"||",1)
	set SubId=$p(ContSubItemCatRowId,"||",2)
	set ChildId=$p(ContSubItemCatRowId,"||",3)
	set ContSubItemCatInfo=$g(^DHCWMRCNT(RefId,"S",SubId,"I",ChildId))
	
	set ItemCatId=$p(ContSubItemCatInfo,"^",1)
	set ItemCatInfo=""
	set:(ItemCatId'="") ItemCatInfo=$g(^ARC("IC",ItemCatId))
	set ItemCatCode=$p(ItemCatInfo,"^",1)
	set ItemCatDesc=$p(ItemCatInfo,"^",2)
	
	set $li(Data,1)=ContSubItemCatRowId    //ContSubItemCatRowId
	set $li(Data,2)=ItemCatDesc            //ItemCatDesc
	set $li(Data,3)=ItemCatId              //ItemCatId
	set $li(Data,4)=ItemCatCode            //ItemCatCode
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryContSubItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContSubItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryContSubItemCatExecute(ByRef qHandle As %Binary, ContSubRowId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RefId=$p(ContSubRowId,"||",1)
	s SubId=$p(ContSubRowId,"||",2)
	q:((RefId="")||(SubId="")) $$$OK
	s ChildId=0
	f  s ChildId=$o(^DHCWMRCNT(RefId,"S",SubId,"I",ChildId)) q:ChildId=""  d
	.s ContSubItemCatRowId=ContSubRowId_"||"_ChildId
	.d ..BuildDataContSubItemCat(repid, ind,ContSubItemCatRowId)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryContSubItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContSubItemCatExecute ]
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

/// Query目录子类对应医嘱子类表
Query QueryContSubItemCat(ContSubRowId As %String) As %Query(ROWSPEC = "ContSubItemCatRowId:%String,ItemCatDesc:%String,ItemCatId:%String,ItemCatCode:%String")
{
}

/// BuildData医嘱项目
ClassMethod BuildDataArcim(repid, ind, Subscript)
{
	//n (repid, ind, Subscript)
	
    s ArcimCode=$p($g(^ARCIM(Subscript,"1",1)),"^",1)
    s ArcimDesc=$p($g(^ARCIM(Subscript,"1",1)),"^",2)
    s ArcimCatId=$p($g(^ARCIM(Subscript,"1",1)),"^",10)
    s ArcimCatDesc=""
    s:ArcimCatId'="" ArcimCatDesc=$p($g(^ARC("IC",ArcimCatId)),"^",2)
    s BillSubId=$p($g(^ARCIM(Subscript,"1",1)),"^",9)
    s BillSubDesc=""
    s:BillSubId'="" BillSubDesc=$p($g(^ARCBG(+BillSubId,"SG",$p(BillSubId,"||",2))),"^",2)
    s UomId=$p($g(^ARCIM(Subscript,"1",8)),"^",14)
    s UomDesc=""
    s:UomId'="" UomDesc=$p($g(^CT("UOM",UomId)),"^",2)
    
    set $li(Data,1)=Subscript_"||1"      //ArcimRowId
    set $li(Data,2)=ArcimDesc            //ArcimDesc
    set $li(Data,3)=ArcimCode            //ArcimCode
    set $li(Data,4)=ArcimCatId           //ItemCatId
    set $li(Data,5)=ArcimCatDesc         //ItemCatDesc
    set $li(Data,6)=BillSubId            //BillSubId
 	set $li(Data,7)=BillSubDesc          //BillSubDesc
 	set $li(Data,8)=UomId                //UomId
 	set $li(Data,9)=UomDesc              //UomDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcimByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryArcimByAliasExecute(ByRef qHandle As %Binary, Alias As %String, OrderType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:Alias="" $$$OK
    s Alias=$$ALPHAUP^SSUTIL4(Alias)
    i $d(^ARC("ALIAS",0,"Desc",Alias)) d xxxx(Alias,OrderType)
    s Alias0=Alias
    f  s Alias0=$o(^ARC("ALIAS",0,"Desc",Alias0)) q:(Alias0'[Alias)!(Alias0="")  d
    .d xxxx(Alias0,OrderType)
    Quit $$$OK
    
xxxx(alias0,OrderType)
    //n (alias0,OrderType)
    s Desc=""
    f  s Desc=$o(^ARC("ALIAS",0,"Desc",alias0,Desc)) q:Desc=""  d
    .s AliasId="0"
    .f  s AliasId=$o(^ARC("ALIAS",0,"Desc",alias0,Desc,AliasId)) q:AliasId=""  d
    ..s temp=$g(^ARC("ALIAS",AliasId))
    ..s Subscript=$p($p(temp,"^",1),"||",1)
    ..q:'$d(Subscript)!(Subscript="")
    ..s ItmCat=$p($g(^ARCIM(Subscript,"1",1)),"^",10)
    ..s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    ..q:(Type'=OrderType)&(OrderType'="")
    ..d ..BuildDataArcim(repid, ind,Subscript)
    ..s ind=ind+1
    q
}

ClassMethod QueryArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryArcimByAliasExecute ]
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

/// Query医嘱项目
Query QueryArcimByAlias(Alias As %String, OeordType As %String) As %Query(ROWSPEC = "ArcimRowId:%String,ArcimDesc:%String,ArcimCode:%String,ItemCatId:%String,ItemCatDesc:%String,BillSubId:%String,BillSubDesc:%String,UomId:%String,UomDesc:%String")
{
}

/// BuildData医嘱子类
ClassMethod BuildDataItemCat(repid, ind, ItemCatRowId)
{
	//n (repid, ind, ItemCatRowId)
	
	s ItemCatCode=$p(^ARC("IC",ItemCatRowId),"^",1)
	s ItemCatDesc=$p(^ARC("IC",ItemCatRowId),"^",2)
	s OeordType=$p(^ARC("IC",ItemCatRowId),"^",7)
    
    set $li(Data,1)=ItemCatRowId   //ItemCatRowId
    set $li(Data,2)=ItemCatDesc    //ItemCatDesc
    set $li(Data,3)=ItemCatCode    //ItemCatCode
    set $li(Data,4)=OeordType      //OeordType
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryItemCatAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemCatAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryItemCatAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ItemCatId=0
	f  s ItemCatId=$o(^ARC("IC",ItemCatId)) q:ItemCatId=""  d
	.q:'$d(^ARC("IC",ItemCatId))
	.d ..BuildDataItemCat(repid, ind,ItemCatId)
	.s ind=ind+1
    Quit $$$OK
}

ClassMethod QueryItemCatAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemCatAllExecute ]
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

/// Query医嘱子类
Query QueryItemCatAll() As %Query(ROWSPEC = "ItemCatRowId:%String,ItemCatDesc:%String,ItemCatCode:%String,OeordType:%String")
{
}

ClassMethod DeleteContInfo(Condition)
{
	n (Condition)
	
	s RowId=$p(Condition,"^",1)
	s Flag=+$p(Condition,"^",2)
	q:((RowId="")||(Flag<1)||(Flag>4)) -10
	s ret=-1
	s ret=..DeleteContInfoM(RowId,Flag)
	q ret
}

ClassMethod DeleteContInfoM(RowId, Flag)
{
    ;RowId:目录大类/目录子类/对应医嘱项/对应医嘱子类的ID
    ;Flag:区分标记  1/2/3/4  与目录大类/目录子类/对应医嘱项/对应医嘱子类对应
    n (RowId,Flag)
    
    s ret=-1
    q:((RowId="")||(Flag="")) ret
    TStart
    i Flag=1 d
    .s RowId=+RowId
    .s ret=-1
    .q:RowId=0
    .&sql(delete from DHC_WMR_Contents where Rowid=:RowId)
    .i SQLCODE TRollback
    .s SubId=0
    .f  s SubId=$o(^DHCWMRCNT(RowId,"S",SubId)) q:SubId=""  d
    ..&sql(delete from DHC_WMR_ContSub where ParRef=:RowId and ChildSub=:SubId)
    ..i SQLCODE TRollback
    ..s ContSubRowId=RowId_"||"_SubId
    ..s ChildId=0
    ..f  s ChildId=$o(^DHCWMRCNT(RowId,"S",SubId,"A",ChildId)) q:ChildId=""  d
    ...&sql(delete from DHC_WMR_ContSubArcim where ParRef=:ContSubRowId and ChildSub=:ChildId)
    ...i SQLCODE TRollback
    ..s ChildId=0
    ..f  s ChildId=$o(^DHCWMRCNT(RowId,"S",SubId,"I",ChildId)) q:ChildId=""  d
    ...&sql(delete from DHC_WMR_ContSubItemCat where ParRef=:ContSubRowId and ChildSub=:ChildId)
    ...i SQLCODE TRollback
    .s ret=1
    TCommit
    q:Flag=1 ret
    
    TStart
    i Flag=2 d
    .s RefId=+$p(RowId,"||",1)
    .s SubId=+$p(RowId,"||",2)
    .s ret=-2
    .q:((RefId=0)||(SubId=0))
    .&sql(delete from DHC_WMR_ContSub where ParRef=:RefId and ChildSub=:SubId)
    .i SQLCODE TRollback
    .s ContSubRowId=RowId
    .s ChildId=0
    .f  s ChildId=$o(^DHCWMRCNT(RefId,"S",SubId,"A",ChildId)) q:ChildId=""  d
    ..&sql(delete from DHC_WMR_ContSubArcim where ParRef=:ContSubRowId and ChildSub=:ChildId)
    ..i SQLCODE TRollback
    .s ChildId=0
    .f  s ChildId=$o(^DHCWMRCNT(RefId,"S",SubId,"I",ChildId)) q:ChildId=""  d
    ..&sql(delete from DHC_WMR_ContSubItemCat where ParRef=:ContSubRowId and ChildSub=:ChildId)
    ..i SQLCODE TRollback
    .s ret=2
    TCommit
    q:Flag=2 ret
    
    TStart
    i Flag=3 d
    .s RefId=+$p(RowId,"||",1)
    .s SubId=+$p(RowId,"||",2)
    .s ChildId=+$p(RowId,"||",3)
    .s ret=-3
    .q:((RefId=0)||(SubId=0)||(ChildId=0))
    .s ContSubRowId=RefId_"||"_SubId
    .&sql(delete from DHC_WMR_ContSubArcim where ParRef=:ContSubRowId and ChildSub=:ChildId)
    .i SQLCODE TRollback
    .s ret=3
    TCommit
    q:Flag=3 ret
    
    TStart
    i Flag=4 d
    .s RefId=+$p(RowId,"||",1)
    .s SubId=+$p(RowId,"||",2)
    .s ChildId=+$p(RowId,"||",3)
    .s ret=-4
    .q:((RefId=0)||(SubId=0)||(ChildId=0))
    .s ContSubRowId=RefId_"||"_SubId
    .&sql(delete from DHC_WMR_ContSubItemCat where ParRef=:ContSubRowId and ChildSub=:ChildId)
    .i SQLCODE TRollback
    .s ret=4
    TCommit
    q:Flag=4 ret
    q 10
}

}
