Import SQLUser

Class web.DHCRisCodeTableAdd Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询申请单样式表
Query QueryApplicationShape() As %Query(ROWSPEC = "TRowid:%String,TComponentID:%String,TComponentName:%String,TPrintTempName:%String,THtmlTempleContent:%String,THospitalDesc:%String,THospitalID:%String")
{
}

ClassMethod QueryApplicationShapeExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryApplicationShape")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid="" f  s Rowid=$o(^DHCRBApp("Shape",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBApp("Shape",Rowid))
 .q:(ResInfo="")
 .s ComponentID=$p(ResInfo,"^",1)
 .s ComponentName=$p(ResInfo,"^",2)
 .s PrintTempName=$p(ResInfo,"^",3)
 .s HtmlTempleContent=""
 .s:$d(^DHCRBApp("Shape",Rowid,"html")) HtmlTempleContent=$g(^DHCRBApp("Shape",Rowid,"html"))
 .s (hospitalDesc,hospitalID)=""
 .s hospitalID=$p(ResInfo,"^",4)
 .i hospitalID'="" d
 ..s hospitalDesc=$p($g(^CT("HOSP",hospitalID)),"^",2)
 .Do OutAppShape 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutAppShape
 set Data=$lb(Rowid,ComponentID,ComponentName,PrintTempName,HtmlTempleContent,hospitalDesc,hospitalID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryApplicationShapeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryApplicationShapeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryApplicationShapeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryApplicationShapeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 设置申请单样式表信息
ClassMethod SetApplicationShape(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableAdd).SetApplicationShape(^tmpzxy,"U")
	s Rowid=$P(AllInfo,"^",1)
	s ComponentID=$p(AllInfo,"^",2)
    s ComponentName=$p(AllInfo,"^",3)
    s PrintTempName=$p(AllInfo,"^",4)
    s HtmlTempleContent=$p(AllInfo,"^",5)
    s HosID=$p(AllInfo,"^",6)
    s SQLCODE=0
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ApplicationShape(DAS_ComponentID,DAS_ComponentName,DAS_PrintTempName,DAS_HospitalID) 
	      values(:ComponentID,:ComponentName,:PrintTempName,:HosID))
	.s Rowid=$p(%ROWID,$c(1))
	.s ^DHCRBApp("Shape",Rowid,"html")=HtmlTempleContent
	i OperateCode="U" d
	.s ^DHCRBApp("Shape",Rowid,"html")=HtmlTempleContent
	.&sql(UpDate DHCRBC_ApplicationShape(DAS_ComponentID,DAS_ComponentName,DAS_PrintTempName,DAS_HospitalID) 
	       values(:ComponentID,:ComponentName,:PrintTempName,:HosID)where DAS_Rowid=:Rowid )
	       
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ApplicationShape where DAS_Rowid = :Rowid)
    q SQLCODE
}

/// 根据选中申请单Rowid获取申请单Html模板内容
ClassMethod GetAppHtmlbyRowid(Rowid As %String) As %String
{
	s HtmlTempleContent=""
	i (Rowid'="")
	{	
      s:$d(^DHCRBApp("Shape",Rowid,"html")) HtmlTempleContent=^DHCRBApp("Shape",Rowid,"html")
		
	}
	
	q HtmlTempleContent
}

/// /查询医嘱项目与申请单样式设置
Query QueryItmMastAppSet(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,ItmMast:%String,AppShape:%String,AppShapeDR:%String,ComponentName:%String,ItmMastDR:%String")
{
}

ClassMethod QueryItmMastAppSetExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryItmMastAppSet")
 Set repid=$I(^CacheTemp)
 s ind=1
 s GetArcItemDR=$p($g(Info),"^",1)
 
 s Rowid="" f  s Rowid=$o(^DHCRBCApp("ItmMast",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBCApp("ItmMast",Rowid))
 .q:(ResInfo="")
 .s ItmMastDR=$p($g(ResInfo),"^",1)
 .q:(GetArcItemDR'="")&(GetArcItemDR'=ItmMastDR)
 .i ItmMastDR'="" d
 ..s Subscript=$p($g(ItmMastDR),"||",1)
 ..s Version=$p($g(ItmMastDR),"||",2)
 ..q:(Subscript="")!(Version="")
 ..s ItmMast=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
 .s AppShapeDR=$p(ResInfo,"^",2)
 .i AppShapeDR'="" d
 ..s AppShape=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",1)
 ..s ComponentName=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",2)
 .Do ItmMastAppSet 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
ItmMastAppSet
 set Data=$lb(Rowid,ItmMast,AppShape,$g(AppShapeDR),$g(ComponentName),$g(ItmMastDR))
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryItmMastAppSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmMastAppSetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItmMastAppSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmMastAppSetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetItmMastAppSet(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTable).SetApplicationShape(AllInfo,OperateCode)
	s ^DHCRis("SetRis")=AllInfo_"^"_OperateCode
	s Rowid=$P(AllInfo,"^",1) 
	s ItmMast=$p(AllInfo,"^",2)
    s AppShape=$p(AllInfo,"^",3)
    s SQLCODE=0
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ItmMastAppSet(DIMAS_ArcItem_DR,DIMAS_AppShape_DR) 
	      values(:ItmMast,:AppShape))
	//B
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ItmMastAppSet(DIMAS_ArcItem_DR,DIMAS_AppShape_DR) 
	       values(:ItmMast,:AppShape)
	      where DIMAS_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItmMastAppSet where DIMAS_Rowid = :Rowid)
    q SQLCODE
}

// sunyi Modfiy 2011-07-20

/// /查询医嘱子类与申请单样式设置
Query QueryItemCatAppSet() As %Query(ROWSPEC = "Rowid:%String,ItemCat:%String,AppShape:%String,AppShapeDR:%String,ComponentName:%String,ItemCatDR:%String")
{
}

ClassMethod QueryItemCatAppSetExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryItemCatAppSet")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid="" f  s Rowid=$o(^DHCRBCApp("ItmCat",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBCApp("ItmCat",Rowid))
 .q:(ResInfo="")
 .s ItemCatDR=$p(ResInfo,"^",1)
 .s:ItemCatDR'="" ItemCat=$p($g(^ARC("IC",ItemCatDR)),"^",2)
 .s AppShapeDR=$p(ResInfo,"^",2)
 .i AppShapeDR'="" d
 ..s AppShape=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",1)
 ..s ComponentName=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",2)
 .Do ItemCatAppSet
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
ItemCatAppSet
 set Data=$lb(Rowid,ItemCat,AppShape,$g(AppShapeDR),$g(ComponentName),$g(ItemCatDR))
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryItemCatAppSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemCatAppSetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItemCatAppSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemCatAppSetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetItemCatAppSet(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTable).SetApplicationShape(AllInfo,OperateCode)
	s Rowid=$P(AllInfo,"^",1) 
	s ItemCat=$p(AllInfo,"^",2)
    s AppShape=$p(AllInfo,"^",3)
    s SQLCODE=0
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ItemCatAppSet(DICAS_ItemCat_DR,DICAS_AppShape_DR) 
	      values(:ItemCat,:AppShape))
	//B
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ItemCatAppSet(DICAS_ItemCat_DR,DICAS_AppShape_DR)  
	       values(:ItemCat,:AppShape)
	      where DICAS_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItemCatAppSet where DICAS_Rowid = :Rowid)
    q SQLCODE
}

/// 查询医嘱大类与申请单样式设置
Query QueryOrdCatAppSet() As %Query(ROWSPEC = "Rowid:%String,OrdCat:%String,AppShape:%String,AppShapeDR:%String,ComponentName:%String,OrdCatDR:%String")
{
}

ClassMethod QueryOrdCatAppSetExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryOrdCatAppSet")
 Set repid=$I(^CacheTemp)
 s ind=1
 s Rowid="" f  s Rowid=$O(^DHCRBCApp("OrdCat",Rowid)) q:(Rowid="")  d
 .s ResInfo=^DHCRBCApp("OrdCat",Rowid)
 .s OrdCatDR=$p(ResInfo,"^",1)
 .s:OrdCatDR'="" OrdCat=$p(^OEC("ORCAT",OrdCatDR),"^",2)
 .//s OrdCat=##class(web.DHCRisCodeTableAdd).GetPYFromHZ(OrdCat)
 .s AppShapeDR=$p(ResInfo,"^",2)
 .i AppShapeDR'="" d
 ..s AppShape=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",1)
 ..s ComponentName=$P($g(^DHCRBApp("Shape",AppShapeDR)),"^",2)
 .Do OrdCatAppSet
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OrdCatAppSet
 set Data=$lb(Rowid,OrdCat,$g(AppShape),$g(AppShapeDR),$g(ComponentName),$g(OrdCatDR))
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryOrdCatAppSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdCatAppSetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryOrdCatAppSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdCatAppSetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetOrdCatAppSet(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableAdd).SetApplicationShape(AllInfo,OperateCode)
	s Rowid=$P(AllInfo,"^",1) 
	s OrdCat=$p(AllInfo,"^",2)
    s AppShape=$p(AllInfo,"^",3)
    
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_OrdCatAppSet(DOCAS_OrdCategory_DR,DOCAS_AppShape_DR) 
	      values(:OrdCat,:AppShape))
	//B
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_OrdCatAppSet(DOCAS_OrdCategory_DR,DOCAS_AppShape_DR)   
	       values(:OrdCat,:AppShape)
	      where DOCAS_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_OrdCatAppSet where DOCAS_Rowid = :Rowid)
    q SQLCODE
}

/// 查询名称：QueryOrderCategory
/// 功能：查询医嘱大类
/// 参数：
/// 返回：大类列表 
/// 作者：龚平
/// 日期：2011-08-17
Query QueryOrderCategory() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryOrderCategoryExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryOrderCategory") 
 //^OEC("ORCAT",{ORCAT_RowId})=ORCAT_Code^ORCAT_Desc
 s ind=1
 Set repid=$I(^CacheTemp)
 s OrdCatDr=31  //此参数需要通过另外一途径来取得，因为各个医院都不一样
 s Rowid=0 f  s Rowid=$O(^OEC("ORCAT",Rowid)) q:(Rowid="")  d
 .s Desc=$p(^OEC("ORCAT",Rowid),"^",2)
 .Do OutOrderCategory
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutOrderCategory
 set Data=$lb(Rowid,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryOrderCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderCategoryExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryOrderCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderCategoryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryARCItemCat
/// 功能：查询医嘱子类
/// 参数：大类ROWID
/// 返回：子类列表 
/// 作者：sunyi
/// 日期：2011-08-17
Query QueryARCItemCat(OrdCatDr As %String) As %Query(ROWSPEC = "Rowid:%String,OrdCatDr:%String")
{
}

ClassMethod QueryARCItemCatExecute(ByRef qHandle As %Binary, OrdCatDr As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryARCItemCat") 
 //^ARC("IC",0,"OrdCat",{ARCIC_OrdCat_DR},{ARCIC_RowId}) 取子类
 s ind=1 
 Set repid=$I(^CacheTemp)
 //s OrdCatDr=31  //此参数需要通过另外一途径来取得，因为各个医院都不一样
 if OrdCatDr'="" d
 .s Rowid="" f  s Rowid=$O(^ARC("IC",0,"OrdCat",OrdCatDr,Rowid)) q:(Rowid="")  d
 ..s ItmCat=$p(^ARC("IC",Rowid),"^",2)
 ..Do OutItmCat
 e  d
 .f  s OrdCatDr=$O(^ARC("IC",0,"OrdCat",OrdCatDr)) q:(OrdCatDr="")  d
 ..s Rowid="" f  s Rowid=$O(^ARC("IC",0,"OrdCat",OrdCatDr,Rowid)) q:(Rowid="")  d
 ...s ItmCat=$p(^ARC("IC",Rowid),"^",2)
 ...Do OutItmCat
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItmCat
 set Data=$lb(Rowid,ItmCat)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryARCItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryARCItemMastByCat
/// 功能：查询医嘱项目名称
/// 参数：子类ROWID,医嘱名称
/// 返回：医嘱列表类列表 
/// 作者：sunyi
/// 日期：2011-10-17
Query QueryARCItemMastByCat(OrdSubCatId As %String) As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String")
{
}

ClassMethod QueryARCItemMastByCatExecute(ByRef qHandle As %Binary, OrdSubCatId As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryARCItemMastByCat","211") 
 //^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version} 取指定子类下的医嘱项
 s ind=1 
 Set repid=$I(^CacheTemp)
 i OrdSubCatId'="" d
 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip)) q:(Subscrip="")  d
 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip,Version)) q:(Version="")  d
 ...s ItemRowid=Subscrip_"||"_Version
 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
 ...;if $p(^ARCIM(Subscrip,Version,7),"^",6)="S" 
 ...Do OutItmMast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItmMast
 set Data=$lb(ItemRowid,ItemDesc)

 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCItemMastByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemMastByCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryARCItemMastByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemMastByCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询申请单样式表
Query QueryAppShape() As %Query(ROWSPEC = "TRowid:%String,TComponentID:%String,TComponentName:%String")
{
}

ClassMethod QueryAppShapeExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryAppShape")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid="" f  s Rowid=$o(^DHCRBApp("Shape",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBApp("Shape",Rowid))
 .q:(ResInfo="")
 .s ComponentID=$p(ResInfo,"^",1)
 .s ComponentName=$p(ResInfo,"^",2)
 .s PrintTempName=$p(ResInfo,"^",3)
 .s HtmlTempleContent=""
 .s:$d(^DHCRBApp("Shape",Rowid,"html")) HtmlTempleContent=^DHCRBApp("Shape",Rowid,"html")
 .Do OutAppShape1 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutAppShape1
 set Data=$lb(Rowid,ComponentID,ComponentName)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryAppShapeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppShapeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppShapeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppShapeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 申请单样式字段查询
/// sunyi 2011-10-18
Query QueryApplicationField(Info As %String) As %Query(ROWSPEC = "TRowid:%String,TDesc:%String,TType:%String,TContent:%String,TOption:%String,TRequire:%String,TWidth:%String,THeight:%String")
{
}

ClassMethod QueryApplicationFieldExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryApplicationField","^")
 Set repid=$I(^CacheTemp)
 s ind=1
 //^DHCRBApp("Field",{DAF_Rowid})
 
 s GetDesc=$p($g(Info),"^",1)
 s GetType=$p($g(Info),"^",2)
 
 s Rowid="" f  s Rowid=$o(^DHCRBApp("Field",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBApp("Field",Rowid))
 .q:(ResInfo="")
 .s Desc=$p(ResInfo,"^",1)
 .q:(GetDesc'="")&(GetDesc'=Desc)
 .s Type=$p(ResInfo,"^",2)
 .q:(GetType'="")&(GetType'=Type)
 .S Content=$p(ResInfo,"^",3)
 .s Option=$p(ResInfo,"^",4)
 .s Require=$p(ResInfo,"^",5)
 .s Width=$p(ResInfo,"^",6)
 .s Height=$p(ResInfo,"^",7)
 .Do ApplicationField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
ApplicationField
 set Data=$lb(Rowid,Desc,Type,Content,Option,Require,Width,Height)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryApplicationFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryApplicationFieldExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryApplicationFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryApplicationFieldExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 申请样式单字段设置
ClassMethod SetApplicationField(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableAdd).SetApplicationField(AllInfo,OperateCode)
	s Rowid=$P(AllInfo,"^",1)
	s Desc=$p(AllInfo,"^",2)
    s Type=$p(AllInfo,"^",3)
    s Content=$p(AllInfo,"^",4)
    s Option=$p(AllInfo,"^",5)
    s Require=$p(AllInfo,"^",6)
    s Width=$p(AllInfo,"^",7)
    s Height=$p(AllInfo,"^",8)
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ApplicationField(DAF_Desc,DAF_Type,DAF_Content,
	             DAF_Option,DAF_Require,DAF_Width,DAF_Height) 
	      values(:Desc,:Type,:Content,:Option,:Require,:Width,:Height))
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ApplicationField(DAF_Desc,DAF_Type,DAF_Content,
	             DAF_Option,DAF_Require,DAF_Width,DAF_Height)
	       values(:Desc,:Type,:Content,:Option,:Require,:Width,:Height)
	      where DAF_Rowid=:Rowid )
	      
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ApplicationField where DAF_Rowid = :Rowid)
    q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryFieldType")

Query QueryFieldType() As %Query(ROWSPEC = "TypeDesc:%String")
{
}

ClassMethod QueryFieldTypeExecute(ByRef qHandle As %Binary) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s FieldType="ListBox^CheckBox^TextBox^Query"
 s len=$L(FieldType,"^")
 f s=1:1:len d
 .s TypeDesc=$p(FieldType,"^",s)
 .Do OutFieldType 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutFieldType
 set Data=$lb(TypeDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryFieldTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFieldTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryFieldTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFieldTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询申请单字段内容设置
/// sunyi 2011-11-28
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryAppFieldContent")
Query QueryAppFieldContent(Info As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,FieldName:%String,Value:%String,Format:%String,FieldDR:%String")
{
}

ClassMethod QueryAppFieldContentExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s GetCode=$p($g(Info),"^",1)
 s GetFieldDR=$p($g(Info),"^",2)
 
 s Rowid="" f  s Rowid=$o(^DHCRBApp("FieldContent",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBApp("FieldContent",Rowid))
 .q:(ResInfo="")
 .s FieldDR=$p(ResInfo,"^",1)
 .q:(FieldDR="")
 .q:(GetFieldDR'="")&(GetFieldDR'=FieldDR)
 .s FieldName=$p($g(^DHCRBApp("Field",FieldDR)),"^",1)
 .s Value=$p(ResInfo,"^",2)
 .S Format=$p(ResInfo,"^",3)
 .s Code=$p(ResInfo,"^",4)
 .q:(GetCode'="")&(GetCode'=Code)
 .Do AppFieldContent
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
AppFieldContent
 set Data=$lb(Rowid,Code,FieldName,Value,Format,FieldDR)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryAppFieldContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppFieldContentExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppFieldContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppFieldContentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 申请单字段内容设置
ClassMethod SetAppFieldContent(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableAdd).SetAppFieldContent(AllInfo,OperateCode)
	s Rowid=$P(AllInfo,"^",1)
	s Code=$p(AllInfo,"^",2)
    s FieldDR=$p(AllInfo,"^",3)
    s Value=$p(AllInfo,"^",4)
    s Format=$p(AllInfo,"^",5)
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_AppField_Content(DAFC_Code,DAFC_Field_DR,DAFC_Value,
	             DAFC_Format) 
	      values(:Code,:FieldDR,:Value,:Format))
	//B
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_AppField_Content(DAFC_Code,DAFC_Field_DR,DAFC_Value,
	             DAFC_Format) 
	       values(:Code,:FieldDR,:Value,:Format)
	      where DAFC_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_AppField_Content where DAFC_Rowid = :Rowid)
    q SQLCODE
}

/// 添加医嘱项目字段(协和需求)
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryAppShapeField")
Query QueryAppShapeField(Info As %String) As %Query(ROWSPEC = "Rowid:%String,ApplicationShape:%String,ApplicationField:%String,AppIndex:%String,ArcItemMast:%String,ArcItmRowid:%String,AppFieldDR:%String,AppShapeID:%String")
{
}

ClassMethod QueryAppShapeFieldExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 s (ArcSubRowid,ArcverRowid,GetApplicationShape,GetArcItmRowid)=""
 s GetAppShapeDR=$p($g(Info),"^",1)
 s GetArcItmRowid=$p($g(Info),"^",2)
 s GetFieldDR=$p($g(Info),"^",3)

 //^DHCRBCAppSF("ShapeField",0,{DHCRBC_ApplicationShape.DAS_Rowid},{DASF_ChildSub})          
 s ParRef="" f  s ParRef=$o(^DHCRBCAppSF("ShapeField",0,ParRef),-1) q:(ParRef="")  d
 .s ChildSub="" f  s ChildSub=$O(^DHCRBCAppSF("ShapeField",0,ParRef,ChildSub)) q:(ChildSub="")  d
 ..s ResInfo=$g(^DHCRBCAppSF("ShapeField",0,ParRef,ChildSub))
 ..q:(ResInfo="")
 ..s Rowid=ParRef_"||"_ChildSub
 ..s ApplicationShape=$p(^DHCRBApp("Shape",ParRef),"^",1)
 ..q:(GetAppShapeDR'="")&(GetAppShapeDR'=ParRef)
 ..s ApplicationFieldDR=$p(ResInfo,"^",1)
 ..q:(ApplicationFieldDR="")
 ..q:(GetFieldDR'="")&(GetFieldDR'=ApplicationFieldDR)
 ..;q:(GetApplicationShape'=ApplicationShape)&(GetApplicationShape'="")
 ..s ArcItmRowid=$p($g(ResInfo),"^",2)
 ..s ArcItemMast=""
 ..q:(GetArcItmRowid'=ArcItmRowid)&(GetArcItmRowid'="")
 ..i ArcItmRowid'="" d
 ...s ArcSubRowid=$p(ArcItmRowid,"||",1)
 ...s ArcverRowid=$p(ArcItmRowid,"||",2)
 ...s ArcItemMast=$p($g(^ARCIM(ArcSubRowid,ArcverRowid,1)),"^",2)
 ..s AppIndex=$p(ResInfo,"^",5)
 ..s:ApplicationFieldDR'="" ApplicationField=$p($g(^DHCRBApp("Field",ApplicationFieldDR)),"^",1)
 ..Do ApplicationShapeField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
ApplicationShapeField
 set Data=$lb(Rowid,ApplicationShape,ApplicationField,$g(AppIndex),$g(ArcItemMast),$g(ArcItmRowid),$g(ApplicationFieldDR),ParRef)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryAppShapeFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppShapeFieldExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppShapeFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppShapeFieldExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// sunyi 2011-08-02

/// 添加医嘱项目ID
ClassMethod SetApplicationShapeField(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableAdd).SetApplicationShapeField(AllInfo,OperateCode)
	s Rowid=$P(AllInfo,"^",1)
	s ParRef=$p(AllInfo,"^",2)
    //s ChildSub=$p(AllInfo,"||",2)
    s ApplicationFieldDR=$p(AllInfo,"^",3)
    s Index=$p(AllInfo,"^",4)
    s ArcItmRowid=$p(AllInfo,"^",5)
    
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ApplicationShape_Field(DASF_ParRef,DASF_ApplicationField_DR,DASF_Index,DASF_ItemMast_DR) 
	      values(:ParRef,:ApplicationFieldDR,:Index,:ArcItmRowid))

	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ApplicationShape_Field(DASF_ParRef,DASF_ApplicationField_DR,DASF_Index,DASF_ItemMast_DR) 
	       values(:ParRef,:ApplicationFieldDR,:Index,:ArcItmRowid)
	      where DASF_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ApplicationShape_Field where DASF_Rowid = :Rowid)
    q SQLCODE
}

/// 申请单样式字段查询(用于放大镜)
/// sunyi 2011-10-18
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryAppAllField","")
Query QueryAppAllField(Desc As %String) As %Query(ROWSPEC = "TRowid:%String,TDesc:%String,TType:%String")
{
}

ClassMethod QueryAppAllFieldExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 //^DHCRBApp("Field",{DAF_Rowid})
 
 s Rowid="" f  s Rowid=$o(^DHCRBApp("Field",Rowid),-1) q:(Rowid="")  d
 .s ResInfo=$g(^DHCRBApp("Field",Rowid))
 .q:(ResInfo="")
 .s GetDesc=$p(ResInfo,"^",1)
 .q:(Desc'="")&(GetDesc'[Desc)
 .s Type=$p(ResInfo,"^",2)
 .Do OutALL
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutALL
 set Data=$lb(Rowid,GetDesc,Type)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryAppAllFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppAllFieldExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppAllFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppAllFieldExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 按医嘱别名查找
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryOrdItemCS","cs","")
/// 按医嘱别名查找
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryOrdItemCS","cs","")
Query QueryOrdItemCS(ArcItemMast As %String, SubCatId As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String,SubCategoryDesc:%String,Price:%String")
{
}

ClassMethod QueryOrdItemCSExecute(ByRef qHandle As %Binary, ArcItemMast As %String, SubCatId As %String) As %Status
{
	s rARCIMDesc="",rItemRowID="",rSubCategoryDesc="",rPrice=""
	Set repid=$I(^CacheTemp)
	s index=1
	
	s ArcItemMast=$g(ArcItemMast)
	s ArcItemMast=$ZCONVERT(ArcItemMast,"U")
	s i=0
	s id=0 f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	.s text=$p($g(^ARC("ALIAS",id)),"^",6)
	.s text=$ZCONVERT(text,"U")
	.q:($l(text)=0)
	.q:(($e((text),1,$l(ArcItemMast)))'[ArcItemMast)
	.s tarid=$p(^ARC("ALIAS",id),"^",1)
	.q:tarid=""
	.s id1=$p(tarid,"||",1)
	.s id2=$p(tarid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s rItemRowID=id1_"||"_id2
	.q:($d(existItem(rItemRowID)))
	.s rARCIMDesc=$p(^ARCIM(id1,id2,1),"^",2)
	.s yzcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s lei=""
	.s leiname=""
	.s daleicode=""
	.s daleiname=""
	.s uomcode=""
	.s uomdesc=""
	.s uomcode=$p(^ARCIM(id1,id2,8),"^",14)
	.i uomcode'="" s uomdesc=$p(^CT("UOM",uomcode),"^",2)
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.q:(lei="")
	.i lei'="" s rSubCategory=$p(^ARC("IC",lei),"^",2)
	.s ItmCatDR=$p(^ARCIM($p(rItemRowID,"||",1),$p(rItemRowID,"||",2),1),"^",10)
	.;s subCatDesc=$p(^ARC("IC",ItmCatDR),"^",2) ; 医嘱子类
	.q:((SubCatId'="")&&(SubCatId'=ItmCatDR))
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" d
	..s rCategory=$p(^OEC("ORCAT",daleicode),"^",2)
	..;b //rCategory
	..;w !,"daleicode="_daleicode
	..;w !,"rCategory="_rCategory 
	..i rCategory["检查" Do OutOrdItemCS
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOrdItemCS
	set Data=$lb(rARCIMDesc,rItemRowID, rSubCategory,rPrice)
	s existItem(rItemRowID)=""
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod QueryOrdItemCSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
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

ClassMethod QueryOrdItemCSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 检查部位关联医嘱信息设置
/// sunyi 2011-07-29 
ClassMethod SetOeItemBoadySet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P(AllInfo,"^",1) 
	s ArcItemID=$p(AllInfo,"^",2)
    s BodyPartID=$p(AllInfo,"^",3)
    s ExclusionFlag=$p(AllInfo,"^",4)
    
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_Orditem_BodyPart(DOB_ItmMast_DR,DOB_BodyPart_DR,DOB_ExclusionFlag) 
	      values(:ArcItemID,:BodyPartID,:ExclusionFlag))
	      
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_Orditem_BodyPart(DOB_ItmMast_DR,DOB_BodyPart_DR,DOB_ExclusionFlag) 
	       values(:ArcItemID,:BodyPartID,:ExclusionFlag)
	      where DOB_Rowid=:Rowid )
	            
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_Orditem_BodyPart where DOB_Rowid = :Rowid)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryOeItemBodyInfo")
Query QueryOeItemBodyInfo(Info As %String) As %Query(ROWSPEC = "Rowid:%String,OrdCat:%String,ItemCat:%String,ItemMast:%String,BodyPart:%String,OrdCatRowid:%String,ItmCatRowid:%String,ARCItmID:%String,ExclusionFlag:%String,BodyPartID:%String")
{
}

ClassMethod QueryOeItemBodyInfoExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
 Set repid=$I(^CacheTemp)
 s ind=1
 s (OrdCat,ItemCat,ItemMast,BodyPart,ARCItmID,BodyPartID,ArcSubRowid,ArcverRowid,ExclusionFlag)=""
 s (ItmCatRowid,OrdCatRowid)=""
 s GetOCRowid=$p($g(Info),"^",1)
 s GetICRowid=$p($g(Info),"^",2)
 s GetARCRowid=$p($g(Info),"^",3)
 s GetBodyPartID=$p($g(Info),"^",4)
 
 
 s Rowid="" f  s Rowid=$o(^DHCRBC("ItemToBodyPart",Rowid),-1) q:(Rowid="")  d
 .s ARCItmID=$p($g(^DHCRBC("ItemToBodyPart",Rowid)),"^",1)
 .s BodyPartID=$p($g(^DHCRBC("ItemToBodyPart",Rowid)),"^",2)
 .s ExclusionFlag=$p($g(^DHCRBC("ItemToBodyPart",Rowid)),"^",4)
 .q:(GetBodyPartID'="")&(GetBodyPartID'=BodyPartID)
 .s BodyPart=""
 .i (BodyPartID'="") s BodyPart=$p(^MRC("BODP",BodyPartID),"^",2)
 .q:(ARCItmID="")
 .q:(GetARCRowid'="")&(GetARCRowid'=ARCItmID)
 .s ArcSubRowid=$p(ARCItmID,"||",1)
 .s ArcverRowid=$p(ARCItmID,"||",2)
 .s ItemMast=$p($g(^ARCIM(ArcSubRowid,ArcverRowid,1)),"^",2)
 .s ItmCatRowid=$p($g(^ARCIM(ArcSubRowid,ArcverRowid,1)),"^",10)
 .q:(GetICRowid'="")&(GetICRowid'=ItmCatRowid)
 .i ItmCatRowid'="" s ItemCat=$p($g(^ARC("IC",ItmCatRowid)),"^",2)
 .s OrdCatRowid=$p($g(^ARC("IC",ItmCatRowid)),"^",8)
 .q:(GetOCRowid'="")&(GetOCRowid'=OrdCatRowid)
 .i OrdCatRowid'="" s OrdCat=$p($g(^OEC("ORCAT",OrdCatRowid)),"^",2)
 .Do OutItemBodyParts 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItemBodyParts
 set Data=$lb(Rowid,OrdCat,ItemCat,ItemMast,BodyPart,OrdCatRowid,ItmCatRowid,ARCItmID,ExclusionFlag,BodyPartID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryOeItemBodyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOeItemBodyInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 { 
   // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else      
 {
     Set Row=^CacheTemp(repid,ind)
 }
 
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryOeItemBodyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOeItemBodyInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryBodyPart")
Query QueryBodyPart() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryBodyPartExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s bodyrowid=0 f  s bodyrowid=$o(^MRC("BODP",bodyrowid)) q:(bodyrowid="")  d
	.s bodyInfo=^MRC("BODP",bodyrowid)
	.;s bodycode=$p(bodyInfo,"^",1)
	.s bodydesc=$p(bodyInfo,"^",2)
	.Do OutBodyPart 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutBodyPart
	set Data=$lb(bodyrowid,bodydesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBodyPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBodyPartExecute ]
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

ClassMethod QueryBodyPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBodyPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 检查部位关联体位设置
/// sunyi 2011-11-30
/// do ##class(web.DHCRisCodeTableAdd).SetBoadyPostureSet("^1^中","I")
ClassMethod SetBoadyPostureSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P(AllInfo,"^",1) 
	s BodyPartID=$p(AllInfo,"^",2)
    s PostureDesc=$p(AllInfo,"^",3)
    
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_BodyPart_Posture(DBP_BodyPart_DR,DBP_Desc) 
	      values(:BodyPartID,:PostureDesc))
	      
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_BodyPart_Posture(DBP_BodyPart_DR,DBP_Desc) 
	       values(:BodyPartID,:PostureDesc)
	      where DBP_Rowid=:Rowid )
	            
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_BodyPart_Posture where DBP_Rowid=:Rowid)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryBoadyPosture")
Query QueryBoadyPosture(Info As %String) As %Query(ROWSPEC = "Rowid:%String,BodyPart:%String,Posture:%String,BodyPartDR:%String")
{
}

ClassMethod QueryBoadyPostureExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetBodyPartID=$p($g(Info),"^",1)
	
    s Rowid="" f  s Rowid=$o(^DHCRBC("PosturetoBodyPart",Rowid),-1) q:(Rowid="")  d
    .s bodyrowid=$p($g(^DHCRBC("PosturetoBodyPart",Rowid)),"^",1)
    .q:(bodyrowid="")
    .q:(GetBodyPartID'="")&(GetBodyPartID'=bodyrowid)
    .s Posture=$p($g(^DHCRBC("PosturetoBodyPart",Rowid)),"^",2)
    .s bodyInfo=^MRC("BODP",bodyrowid)
    .s bodydesc=""
    .s bodydesc=$p(bodyInfo,"^",2)
	.Do OutPosture 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPosture
	set Data=$lb(Rowid,bodydesc,Posture,bodyrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBoadyPostureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBoadyPostureExecute ]
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

ClassMethod QueryBoadyPostureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBoadyPostureExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 临床调阅报告参数设置查询
/// sunyi 2011-12-06
Query QueryClinicSet(Info As %String) As %Query(ROWSPEC = "TRowid:%String,TLocName:%String,TReportFullFile:%String,TRegYesNo:%String,TRRegParam:%String,TRStudyNOYesNo:%String,TRStudyParam:%String,TReportDelim:%String,TImageFullFile:%String,TIRegYesNo:%String,TIRegParam:%String,TIStudyNOYesNo:%String,TIStudyNOParam:%String,TImageDelim:%String,TROtherYesNo:%String,TROtherParam:%String,TIOtherYesNo:%String,TIOherParam:%String,TROeitemYesNo:%String,TROeitemParam:%String,TIOeitemYesNo:%String,TIOeitemParam:%String,TLocDR:%String,TIsOpenList:%String")
{
}

ClassMethod QueryClinicSetExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryClinicSet")
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s (LocName,ReportFullFile,RegYesNo,RRegParam,RStudyNOYesNo,RStudyParam,ReportDelim)=""
	s (ImageFullFile,IRegYesNo,IRegParam,IStudyNOYesNo,IStudyNOParam,ImageDelim)=""
	s (ROtherYesNo,ROtherParam,IOtherYesNo,IOtherParam)=""
	s (ROeitemYesNo,ROeitemParam,IOeitemYesNo,IOeitemParam,LocID)=""
	
	s GetLocID=$p($g(Info),"^",1)
	
	s Rowid=""
	f  s Rowid=$o(^DHCRBC("ClinicSet",Rowid)) q:(Rowid="")  d
	.s LocDR=$P(^DHCRBC("ClinicSet",Rowid),"^",1)
	.q:(GetLocID'="")&(GetLocID'=LocDR)
	.s LocID=LocDR
	.s:LocDR'="" LocDR=$p($g(^CTLOC(LocDR)),"^",2)
	.s ReportFullFile=$P(^DHCRBC("ClinicSet",Rowid),"^",2)
	.s RegYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",3)
	.s RRegParam=$P(^DHCRBC("ClinicSet",Rowid),"^",4)
	.s RStudyNOYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",5)
	.s RStudyParam=$P(^DHCRBC("ClinicSet",Rowid),"^",6)
	.s ReportDelim=$P(^DHCRBC("ClinicSet",Rowid),"^",7)
	.s ImageFullFile=$P(^DHCRBC("ClinicSet",Rowid),"^",8)
	.s IRegYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",9)
	.s IRegParam=$P(^DHCRBC("ClinicSet",Rowid),"^",10)
	.s IStudyNOYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",11)
	.s IStudyNOParam=$P(^DHCRBC("ClinicSet",Rowid),"^",12)
	.s ImageDelim=$P(^DHCRBC("ClinicSet",Rowid),"^",13)
	.s ROtherYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",14)
	.s ROtherParam=$P(^DHCRBC("ClinicSet",Rowid),"^",15)
	.s IOtherYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",16)
	.s IOtherParam=$P(^DHCRBC("ClinicSet",Rowid),"^",17)
	.s ROeitemYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",18)
	.s ROeitemParam=$P(^DHCRBC("ClinicSet",Rowid),"^",19)
	.s IOeitemYesNo=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",20)
	.s IOeitemParam=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",21)
	.s IsOpenList=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",22)
	.Do ExportClinicSet
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportClinicSet
	set Data=$lb(Rowid,LocDR,ReportFullFile,RegYesNo,
	RRegParam,RStudyNOYesNo,RStudyParam,ReportDelim,ImageFullFile,
	IRegYesNo,IRegParam,IStudyNOYesNo,IStudyNOParam,ImageDelim,
	ROtherYesNo,ROtherParam,IOtherYesNo,IOtherParam,ROeitemYesNo,ROeitemParam,IOeitemYesNo,IOeitemParam,LocID,$g(IsOpenList))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryClinicSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryClinicSetExecute ]
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

ClassMethod QueryClinicSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllReportShapeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(web.DHCRisCodeTableAdd).SetDHCRBCClinicSet()

ClassMethod SetDHCRBCClinicSet(AllInfo As %String, OperateCode As %String) As %String
{
	s ^DHCRisTemp("SetDHCRBCClinicSet")=AllInfo_"**"_OperateCode	
	s Rowid = $P(AllInfo,"^",1)
	s LocDR = $P(AllInfo,"^",2) 
	s ReportFullFile = $P(AllInfo,"^",3)
	s RegYesNo = $P(AllInfo,"^",4)
	s RRegParam = $P(AllInfo,"^",5) 
	s RStudyNOYesNo = $P(AllInfo,"^",6)
	s RStudyParam = $P(AllInfo,"^",7)
	s ReportDelim = $P(AllInfo,"^",8) 
	s ImageFullFile = $P(AllInfo,"^",9)
	s IRegYesNo = $P(AllInfo,"^",10)
	s IRegParam = $P(AllInfo,"^",11) 
	s IStudyNOYesNo = $P(AllInfo,"^",12)
	s IStudyNOParam = $P(AllInfo,"^",13)
	s ImageDelim = $P(AllInfo,"^",14)
	s ROtherYesNo = $P($g(AllInfo),"^",15)
	s ROtherParam = $P($g(AllInfo),"^",16)
	s IOtherYerNo = $P($g(AllInfo),"^",17)
	s IOtherParam  = $P($g(AllInfo),"^",18)
	//Add By QZG 081120
	s ROeitemYesNo = $P($g(AllInfo),"^",20)
	s ROeitemParam = $P($g(AllInfo),"^",19)
	s IOeitemYesNo = $P($g(AllInfo),"^",22)
	s IOeitemParam = $P($g(AllInfo),"^",21)
	s isOpenList=$P($g(AllInfo),"^",23)
	b //
	
	if (LocDR'="")
	{
		s getClinicSetRowid=$o(^DHCRBCi("LocClinicSet",LocDR,""))
	}
	
	s ExistedCount=0
	i OperateCode="I" d
	.i $g(getClinicSetRowid)'="" d
	..s SQLCODE="200"
	.e  d
	..&sql(Insert into DHCRBC_ClinicSet
	     (DPCS_Loc_DR,DPCS_ReportFullFile,DPCS_RhasReg,DPCS_RRegParam,DPCS_RhasStudyNo,
	     DPCS_RStuyParam,DPCS_RDelim,DPCS_ImageFullFile,DPCS_IhasReg,DPCS_IRegParam,
	     DPCS_IhasStudyNo,DPCS_IStudyNoParam,DPCS_IDelim,
	     DPCS_RhasOther,DPCS_ROtherParam,DPCS_IhasOther,DPCS_IOtherParam,
	     DPCS_RhasOeord,DPCS_ROeordParam,DPCS_IhasOeord,DPCS_IOeordParam,DPCS_IsOpenList) 
	     values(:LocDR,:ReportFullFile,:RegYesNo,:RRegParam,:RStudyNOYesNo,:RStudyParam,
	     :ReportDelim,:ImageFullFile,:IRegYesNo,:IRegParam,:IStudyNOYesNo,:IStudyNOParam,:ImageDelim,
	     :ROtherYesNo,:ROtherParam,:IOtherYerNo,:IOtherParam,
	     :ROeitemYesNo,:ROeitemParam,:IOeitemYesNo,:IOeitemParam,:isOpenList))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ClinicSet(DPCS_Loc_DR,DPCS_ReportFullFile,DPCS_RhasReg,DPCS_RRegParam,DPCS_RhasStudyNo,
	     DPCS_RStuyParam,DPCS_RDelim,DPCS_ImageFullFile,DPCS_IhasReg,DPCS_IRegParam,
	     DPCS_IhasStudyNo,DPCS_IStudyNoParam,DPCS_IDelim,
	     DPCS_RhasOther,DPCS_ROtherParam,DPCS_IhasOther,DPCS_IOtherParam,
	     DPCS_RhasOeord,DPCS_ROeordParam,DPCS_IhasOeord,DPCS_IOeordParam,DPCS_IsOpenList)
	      values(:LocDR,:ReportFullFile,:RegYesNo,:RRegParam,:RStudyNOYesNo,:RStudyParam,
	     :ReportDelim,:ImageFullFile,:IRegYesNo,:IRegParam,:IStudyNOYesNo,:IStudyNOParam,:ImageDelim,
	     :ROtherYesNo,:ROtherParam,:IOtherYerNo,:IOtherParam,:ROeitemYesNo,:ROeitemParam,:IOeitemYesNo,:IOeitemParam,:isOpenList)
	      where DPCS_Rowid=:Rowid )
	.b //SQLCODE
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ClinicSet where DPCS_Rowid = :Rowid)
	
    q SQLCODE
}

Query GetRBCServer() As %Query(ROWSPEC = "name:%String,ip:%String,port:%String,type:%String,user:%String,pwd:%String,rowid:%String")
{
}

ClassMethod GetRBCServerExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 s resrowid=0 f  s resrowid=$O(^DHCRBCServer("Server",resrowid)) q:(resrowid="")  d
 .s ResInfo=^DHCRBCServer("Server",resrowid)
 .s name=$p(ResInfo,"^",1)
 .s ip=$p(ResInfo,"^",2)
 .s port=$p(ResInfo,"^",3)
 .s type=$p(ResInfo,"^",4)
 .i type=1 s type="一级在线"
 .i type=2 s type="二级在线"
 .i type=3 s type="Ris在线"
 .s user=$p(ResInfo,"^",5)
 .s pwd=$p(ResInfo,"^",6)
 .s mapid=$p(ResInfo,"^",7)
 .i mapid '="" d
 ..s mapname=$p($g(^DHCRBCServer("Server",mapid)),"^",1)
 .else  d 
 ..s mapname=""
 .s rowid=resrowid
 .Do OutResource 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutResource
 set Data=$lb(name,ip,port,type,user,pwd,rowid,mapid,mapname)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
quit
}

ClassMethod GetRBCServerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRBCServerExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetRBCServerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRBCServerExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InsertRBCServer(Info As %String) As %String
{
 //d ##class(web.DHCRisCodeTable).InsertRBCServer(^asjc1)
 s name=$p(Info,"^",1)
 s ip=$p(Info,"^",2)
 s port=$p(Info,"^",3)
 s type=$p(Info,"^",4)
 s user=$p(Info,"^",5)
 s pwd=$p(Info,"^",6)
 s newRowID=""
 &sql(insert into  dhcrbc_server(DCS_Name,DCS_IP,DCS_Port,DCS_Type,DCS_User,DCS_Pwd) values (:name,:ip,:port,:type,:user,:pwd ))
 &sql(select max(DCS_RowID) into :newRowID from dhcrbc_server)
 q SQLCODE
}

ClassMethod UpdateRBCServer(Info As %String, newRowID As %String) As %Integer
{
 s name=$p(Info,"^",1)
 s ip=$p(Info,"^",2)
 s port=$p(Info,"^",3)
 s type=$p(Info,"^",4)
 s user=$p(Info,"^",5)
 s pwd=$p(Info,"^",6)
 s rowid=newRowID
 s ^TMP1=Info
 s ^TMP2=newRowID
 
 &sql(update  dhcrbc_server(DCS_Name,DCS_IP,DCS_Port,DCS_Type,DCS_Pwd,DCS_User)
 values (:name,:ip,:port,:type,:pwd,:user ) where DCS_RowID=:rowid)
 q SQLCODE
}

ClassMethod DeleteRBCServer(rowid) As %String
{
 s MediumUsedCoun=0,LocParamUsedCount=0
 &sql(select count(*) into :MediumUsedCoun from DHCRBC_Medium where DRM_Server_DR=:rowid)
 &sql(select count(*) into :LocParamUsedCount from DHCRBC_LocParam where DLP_Server_DR=:rowid)
 if (MediumUsedCoun=0)&(LocParamUsedCount=0) d
 .&sql(delete from dhcrbc_server where DCS_RowID=:rowid)
 e  q -999
 q SQLCODE
}

ClassMethod InsertRBCMedium(Info As %String) As %String
{
 s serverdr=""
 s serverdr=$p(Info,"^",1)
 ;i server'=""  d  &sql(select DCS_RowID into :serverdr from  dhcrbc_server where DCS_Name=:server )
 s name=$p(Info,"^",2)
 s size=$p(Info,"^",3)
 s full=$p(Info,"^",4)
 s offline=$p(Info,"^",5)
 s backup=$p(Info,"^",6)
 s remainsize=size
 s newRowID=""
 &sql(insert into  DHCRBC_Medium(DRM_Server_DR,DRM_Name,DRM_Size,DRM_Full,DRM_Offline,DRM_Backup,DRM_RemainSize)
 values (:serverdr,:name,:size,:full,:offline,:backup,:remainsize ))
 &sql(select max(DRM_RowID) into :newRowID from DHCRBC_Medium)
 q SQLCODE
}

ClassMethod UpdateRBCMedium(Info As %String, newRowID As %String) As %Integer
{
 s serverdr=""
 s serverdr=$p(Info,"^",1)
 ;i server'=""  d  &sql(select DCS_RowID into :serverdr from  dhcrbc_server where DCS_Name=:server )
 s name=$p(Info,"^",2)
 s size=$p(Info,"^",3)
 s full=$p(Info,"^",4)
 s offline=$p(Info,"^",5)
 s backup=$p(Info,"^",6)
 s rowid=newRowID
 s UsedSpace=$p(^DHCRBCServer("Medium",rowid),"^",3)-$p(^DHCRBCServer("Medium",rowid),"^",7)
 i size<UsedSpace s size=$p(^DHCRBCServer("Medium",rowid),"^",3)
 s Remainsize=size-UsedSpace
 &sql(update  DHCRBC_Medium(DRM_Server_DR,DRM_Name,DRM_Size,DRM_Full,DRM_Offline,DRM_Backup,DRM_RemainSize)
 values (:serverdr,:name,:size,:full,:offline,:backup,:Remainsize ) where DRM_RowID=:rowid)
 q SQLCODE
}

ClassMethod DeleteRBCMedium(rowid As %String) As %String
{
 s StudyImagesUsedCount=0,ReportFilesUsedCount=0,ReportShapeUsedCount=0
 &sql(select count(*) into :StudyImagesUsedCount from DHCRB_StudyImages where DRSI_Medium_DR=:rowid)
 &sql(select count(*) into :ReportFilesUsedCount from DHCRB_Report_Files where DRPF_Medium_DR=:rowid)
 &sql(select count(*) into :ReportShapeUsedCount from DHCRBC_ReportShape where DRS_Medium_DR=:rowid)
 i (StudyImagesUsedCount=0) & (ReportFilesUsedCount=0) & (ReportShapeUsedCount=0) d
 .&sql(delete from DHCRBC_Medium where DRM_RowID=:rowid)
 e  q -999
 q SQLCODE
}

Query GetRBCMedium() As %Query(ROWSPEC = "name:%String,size:%String,server:%String,full:%String,offline:%String,backup:%String,rowid:%String,RemainSize:%String,ServerId:%String")
{
}

ClassMethod GetRBCMediumExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s resrowid=0 f  s resrowid=$O(^DHCRBCServer("Medium",resrowid)) q:(resrowid="")  d
 .s ResInfo=^DHCRBCServer("Medium",resrowid)
 .s serverdr=$p(ResInfo,"^",1)
 .i serverdr'="" d  s server=$p(^DHCRBCServer("Server",serverdr),"^",1)
 .s name=$p(ResInfo,"^",2)
 .s size=$p(ResInfo,"^",3)
 .s full=$p(ResInfo,"^",4)
 .s offline=$p(ResInfo,"^",5)
 .s backup=$p(ResInfo,"^",6)
 .s rowid=resrowid
 .s RemainSize=$p(ResInfo,"^",7)
 .set Data=$lb(name,size,server,full,offline,backup,rowid,RemainSize,serverdr)
 .Set ^CacheTemp(repid,ind)=Data
 .Set ind=ind+1
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod GetRBCMediumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRBCMediumExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetRBCMediumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRBCMediumExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query QueryStorageType() As %Query(ROWSPEC = "Num:%String,Desc:%String")
{
}

ClassMethod QueryStorageTypeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 set Data=$lb("1","一级在线")
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 set Data=$lb("2","二级在线")
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod QueryStorageTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStorageTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryStorageTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStorageTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 获取服务组信息
ClassMethod GetTypeInfo() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableAdd:QueryStorageType")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetServerList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableAdd:GetRBCServer")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(7)_$C(1)_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(7)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

Query QueryReportLocOfShape(RptShapeRowID As %String) As %Query(ROWSPEC = "TRowid:%String,TLocDR:%String,TLocName:%String")
{
}

ClassMethod QueryReportLocOfShapeExecute(ByRef qHandle As %Binary, RptShapeRowID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisReport","QueryReportLocOfShape")
	Set repid=$I(^CacheTemp)
	s ind=1
	s (LocDR,LocName,ReportShapeDR)=""
	s Rowid=0 
	f  s Rowid=$o(^DHCRBC("Loc-Shape",Rowid)) q:(Rowid="")  d
	.s LocDR=$P($g(^DHCRBC("Loc-Shape",Rowid)),"^",1)
	.s ReportShapeDR=$P($g(^DHCRBC("Loc-Shape",Rowid)),"^",2)
	.s LocName=""
	.i (RptShapeRowID=ReportShapeDR)&(LocDR'="") d
	..s LocName=$p($g(^CTLOC(LocDR)),"^",2)
	..Do ExportShapeLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportShapeLoc
	set Data=$lb(Rowid,LocDR,LocName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportLocOfShapeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllReportShapeExecute ]
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

ClassMethod QueryReportLocOfShapeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllReportShapeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据报告样式查询对应的科室 
ClassMethod GetLocByShapeId(ShapeId As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableAdd:QueryReportLocOfShape")
	s ret=""
	do rset.Execute(ShapeId)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(2)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(2)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// 函数： SetDHCRBCReportShape
/// 功能： 设置报告样式
ClassMethod SetDHCRBCReportShape(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid = $P(AllInfo,"^",1)
	s Desc = $P(AllInfo,"^",2)
	s TemplateFile = $P(AllInfo,"^",3)
	s TableFile = $P(AllInfo,"^",4)
	s HeadHeight = $P(AllInfo,"^",5)
	s FootHeight = $P(AllInfo,"^",6)
	s LeftWidth = $P(AllInfo,"^",7)
	s RightWidth = $P(AllInfo,"^",8)
	s ImageWidth = $P(AllInfo,"^",9)
	s ImageHeight = $P(AllInfo,"^",10)
	s MediumDR = $P(AllInfo,"^",11)
	//MediumDR通过以下途径重新取值
	s MediumDR=$p(##class(web.DHCRisCodeTableAdd).GetSysMedium(),"^",7)
	s SeeHeight = $P(AllInfo,"^",12)
	s SeeWidth = $P(AllInfo,"^",13)
	s ResultHeight = $P(AllInfo,"^",14)
	s ResultWidth = $P(AllInfo,"^",15)
	s ReportDocHeight = $P(AllInfo,"^",16)
	s ReportDocWidth = $P(AllInfo,"^",17)
	s ImageTimes = $P(AllInfo,"^",18)
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_ReportShape(DRS_Rowid,DRS_TemplateFile,DRS_TableFile,DRS_HeadHeight,
	      DRS_FootHeight,DRS_LeftWidth,DRS_RightWidth,DRS_ImageWidth,DRS_ImageHeight,DRS_Medium_DR,
	      DRS_SeeHeight,DRS_SeeWidth,DRS_ResultHeight,DRS_ResultWidth,DRS_ReportDocHeight,DRS_ReportDocWidth,
	      DRS_ImageTimes,DRS_Desc) 
	      values(:Rowid,:TemplateFile,:TableFile,:HeadHeight,:FootHeight,:LeftWidth,:RightWidth,:ImageWidth,
	      :ImageHeight,:MediumDR,:SeeHeight,:SeeWidth,:ResultHeight,:ResultWidth,:ReportDocHeight,:ReportDocWidth,:ImageTimes,:Desc))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ReportShape(DRS_TemplateFile,DRS_TableFile,DRS_HeadHeight,
	      DRS_FootHeight,DRS_LeftWidth,DRS_RightWidth,DRS_ImageWidth,DRS_ImageHeight,DRS_Medium_DR,
	      DRS_SeeHeight,DRS_SeeWidth,DRS_ResultHeight,DRS_ResultWidth,DRS_ReportDocHeight,DRS_ReportDocWidth,
	      DRS_ImageTimes,DRS_Desc) 
	      values(:TemplateFile,:TableFile,:HeadHeight,:FootHeight,:LeftWidth,:RightWidth,:ImageWidth,
	      :ImageHeight,:MediumDR,:SeeHeight,:SeeWidth,:ResultHeight,:ResultWidth,:ReportDocHeight,:ReportDocWidth,:ImageTimes,:Desc)
	      where DRS_Rowid=:Rowid )
	s LocationRShapeUsed=0,ItmMastRShape=0,ItemCatRShape=0
	i OperateCode="D" d
	.&sql(select count(*) into :LocationRShapeUsed from DHCRBC_LocationRShape where DOS_ReportShape_DR=:Rowid)
	.&sql(select count(*) into :ItmMastRShape from  DHCRBC_ItmMastRShape where DIS_ReportShape_DR=:Rowid)
	.&sql(select count(*) into :ItemCatRShape from DHCRBC_ItemCatRShape where DCS_ReportShape_DR=:Rowid)
	.//&sql(Delete from DHCRBC_LocationRShape where DOS_ReportShape_DR=:Rowid )
	.if (LocationRShapeUsed=0) & (ItmMastRShape=0) & (ItemCatRShape=0) d
	..&sql(Delete from DHCRBC_ReportShape where DRS_Rowid = :Rowid)
	i (OperateCode="D") & ((LocationRShapeUsed'=0)!(ItmMastRShape'=0)!ItemCatRShape'=0) q -999
    q SQLCODE
}

/// 函数： SetDHCRBCLocationRShape
/// 功能： 设置科室对应的报告样式
ClassMethod SetDHCRBCLocationRShape(AllInfo As %String, OperateCode As %String) As %String
{

	s Rowid = $P(AllInfo,"^",1)
	s LocDR = $P(AllInfo,"^",2)
	s ReportShapeDR = $P(AllInfo,"^",3)
    //s LocDesc=$ZCONVERT($tr(LocDR,"-",""),"U")	
	//s LocDR=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),""))
	s ExistedCount=0
	i OperateCode="I" d
	.&sql(Select count(*) into :ExistedCount from DHCRBC_LocationRShape where DOS_Loc_DR=:LocDR and DOS_ReportShape_DR=:ReportShapeDR )
	.i ExistedCount=0 d
	..&sql(Insert into DHCRBC_LocationRShape(DOS_Rowid,DOS_Loc_DR,DOS_ReportShape_DR) 
	      values(:Rowid,:LocDR,:ReportShapeDR))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_LocationRShape(DOS_Loc_DR,DOS_ReportShape_DR) 
	      values(:LocDR,:ReportShapeDR)
	      where DOS_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_LocationRShape where DOS_Rowid = :Rowid)
    q SQLCODE
}

/// 查询所有的报告样式
Query QueryAllReportShape() As %Query(ROWSPEC = "TRowid:%String,TDesc:%String,TTemplateFile:%String,TTableFile:%String,THeadHeight:%String,TFootHeight:%String,TLeftWidth:%String,TRightWidth:%String,TImageWidth:%String,TImageHeight:%String,TMediumDR:%String,TSeeHeight:%String,TSeeWidth:%String,TResultHeight:%String,TResultWidth:%String,TReportDocHeight:%String,TReportDocWidth:%String,TImageTimes:%String")
{
}

ClassMethod QueryAllReportShapeExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisReport","QueryAllReportShape")
	Set repid=$I(^CacheTemp)
	s ind=1
	s (Desc,TemplateFile,TableFile,HeadHeight,FootHeight,LeftWidth,RightWidth,ImageWidth)=""
	s (ImageHeight,MediumDR,SeeHeight,SeeWidth,ResultHeight,ResultWidth,ReportDocHeight)=""
	s (ReportDocWidth,ImageTimes)=""
	s Rowid=0 
	f  s Rowid=$o(^DHCRBC("ReportShape",Rowid)) q:(Rowid="")  d
	.s Desc = $P(^DHCRBC("ReportShape",Rowid),"^",17)
	.s TemplateFile = $P(^DHCRBC("ReportShape",Rowid),"^",1)
	.s TableFile = $P(^DHCRBC("ReportShape",Rowid),"^",2)
	.s HeadHeight = $P(^DHCRBC("ReportShape",Rowid),"^",3)
	.s FootHeight = $P(^DHCRBC("ReportShape",Rowid),"^",4)
	.s LeftWidth = $P(^DHCRBC("ReportShape",Rowid),"^",5)
	.s RightWidth = $P(^DHCRBC("ReportShape",Rowid),"^",6)
	.s ImageWidth = $P(^DHCRBC("ReportShape",Rowid),"^",7)
	.s ImageHeight = $P(^DHCRBC("ReportShape",Rowid),"^",8)
	.s MediumDR = $P(^DHCRBC("ReportShape",Rowid),"^",9)
	.s SeeHeight = $P(^DHCRBC("ReportShape",Rowid),"^",10)
	.s SeeWidth = $P(^DHCRBC("ReportShape",Rowid),"^",11)
	.s ResultHeight = $P(^DHCRBC("ReportShape",Rowid),"^",12)
	.s ResultWidth = $P(^DHCRBC("ReportShape",Rowid),"^",13)
	.s ReportDocHeight = $P(^DHCRBC("ReportShape",Rowid),"^",14)
	.s ReportDocWidth = $P(^DHCRBC("ReportShape",Rowid),"^",15)
	.s ImageTimes = $P(^DHCRBC("ReportShape",Rowid),"^",16)
	.Do ExportAll
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportAll
	set Data=$lb(Rowid,Desc,TemplateFile,TableFile,HeadHeight,FootHeight,
	LeftWidth,RightWidth,ImageWidth,ImageHeight,MediumDR,SeeHeight,
	SeeWidth,ResultHeight,ResultWidth,ReportDocHeight,ReportDocWidth,ImageTimes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAllReportShapeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllReportShapeExecute ]
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

ClassMethod QueryAllReportShapeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllReportShapeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询所有的执行科室
ClassMethod GetExeLocInfo(Desc As %String = "") As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryExeLoc")
	s ret=""
	do rset.Execute(Desc)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetSysMedium() As %String
{
	s MediumDR=""
	s RemainSize=""
	s ServerInfo=""
	s Info=""
	&sql(SELECT  DRM_RowId,DRM_RemainSize INTO :MediumDR,:RemainSize FROM DHCRBC_Medium  WHERE DRM_Name='DHC_SYSTEM' AND DRM_Full='N' )
	i MediumDR'="" d
	. s ServerInfo=..GetServerInfo(MediumDR)
	. s Info= ServerInfo_"^"_MediumDR_"^"_RemainSize
	q Info
}

ClassMethod GetServerInfo(MediumDR As %String) As %String
{
	i MediumDR="" q ""
	s Info=""	

    s GetServerDR=$p(^DHCRBCServer("Medium",MediumDR),"^",1)
    i GetServerDR'="" d 
    .s GetName=$p(^DHCRBCServer("Server",GetServerDR),"^",1)
	.s GetIP=$p(^DHCRBCServer("Server",GetServerDR),"^",2)
	.s GetPort=$p(^DHCRBCServer("Server",GetServerDR),"^",3)
	.s GetType=$p(^DHCRBCServer("Server",GetServerDR),"^",4)
	.s GetUser=$p(^DHCRBCServer("Server",GetServerDR),"^",5)
	.s GetPwd=$p(^DHCRBCServer("Server",GetServerDR),"^",6)
	.s Info=GetName_"^"_GetIP_"^"_GetPort_"^"_GetType_"^"_GetUser_"^"_GetPwd
	q Info
}

// 查询科室参数

Query QueryDHCRBCLocParam() As %Query(ROWSPEC = "Rowid:%String,SystemSDate:%String,SystemEDate:%String,PrintAutoVerify:%String,PrintAutoIssue:%String,VerifyAutoIssue:%String,VerifyNeedsPWD:%String,LocDR:%String,ServerDR:%String,AutoDowndload:%String,PrintBookedTemlate:%String,PrintRegTemplate:%String,PrintRegListTemplate:%String,SendDate:%String,ExamineAfterFree:%String,LocID:%String,ServerID:%String,SendToRIS4:%String,StudyInfoToRIS4:%String,BookUseTypeDesc:%String,BookUseTypeDR:%String,UseAutoBook:%String")
{
}

ClassMethod QueryDHCRBCLocParamExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryDHCRBCLocParam")
	//DLP_RowID--DLP_BRSystemSDate--DLP_BRSystemEDate--DLP_PrintAutoVerify
	//--DLP_PrintAutoIssue--DLP_VerifyAutoIssue
	//DLP_VerifyNeedsPWD--DLP_Loc_DR--DLP_Server_DR--DLP_AutoDowndload
	//^DHCRBC("LocParam",{DLP_RowID}) 
	Set repid=$I(^CacheTemp)
	s ind=1 
	s (Rowid,SystemSDate,SystemEDate,PrintAutoVerify,PrintAutoIssue)=""
	s (VerifyAutoIssue,VerifyNeedsPWD,LocDR,ServerDR,AutoDowndload,ExamineAfterFree,LocID,ServerID)=""  //add--yzd--090302:ExamineAfterFree
	s (SendToRIS4,StudyInfoToRIS4,BookUseTypeDR,BookUseTypeDesc,UseAutoBook)=""
	s Rowid=""
	f  s Rowid=$o(^DHCRBC("LocParam",Rowid)) q:(Rowid="")  d
	.s SystemSDate=$P(^DHCRBC("LocParam",Rowid),"^",1)
	.s SystemEDate=$p(^DHCRBC("LocParam",Rowid),"^",2)
	.s PrintAutoVerify=$P(^DHCRBC("LocParam",Rowid),"^",5)
	.s PrintAutoIssue=$P(^DHCRBC("LocParam",Rowid),"^",4)
	.s VerifyAutoIssue=$P(^DHCRBC("LocParam",Rowid),"^",7)
	.s VerifyNeedsPWD=$P(^DHCRBC("LocParam",Rowid),"^",6)
	.s LocDR=$P(^DHCRBC("LocParam",Rowid),"^",3)
	.s LocID=LocDR
	.s:LocDR'="" LocDR=$P(^CTLOC(LocDR),"^",2)
	.s ServerDR=$P(^DHCRBC("LocParam",Rowid),"^",8)
	.s ServerID=ServerDR
	.s:ServerDR'="" ServerDR=$P(^DHCRBCServer("Server",ServerDR),"^",1)
	.s AutoDowndload=$P(^DHCRBC("LocParam",Rowid),"^",9)
	.s PrintBookedTemlate=$P(^DHCRBC("LocParam",Rowid),"^",10)
	.s PrintRegTemplate=$P(^DHCRBC("LocParam",Rowid),"^",11)
	.s PrintRegListTemplate=$P(^DHCRBC("LocParam",Rowid),"^",12)
	.s SendDate=$P(^DHCRBC("LocParam",Rowid),"^",13)
	.s ExamineAfterFree=$P(^DHCRBC("LocParam",Rowid),"^",14)    //add--yzd--090302
	.s SendToRIS4=$P($g(^DHCRBC("LocParam",Rowid)),"^",21)
	.s StudyInfoToRIS4=$P($g(^DHCRBC("LocParam",Rowid)),"^",22)
	.s BookUseTypeDR=$P($g(^DHCRBC("LocParam",Rowid)),"^",23)
	.i BookUseTypeDR'="" s BookUseTypeDesc=..GetBKUseTypebyDR(BookUseTypeDR)
	.s UseAutoBook=$P($g(^DHCRBC("LocParam",Rowid)),"^",24)
	.Do ExportLocParam
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportLocParam
	set Data=$lb(Rowid,SystemSDate,SystemEDate,PrintAutoVerify,
	PrintAutoIssue,VerifyAutoIssue,VerifyNeedsPWD,LocDR,ServerDR,
	AutoDowndload,PrintBookedTemlate,PrintRegTemplate,PrintRegListTemplate,SendDate,ExamineAfterFree,LocID,ServerID,SendToRIS4,StudyInfoToRIS4,BookUseTypeDesc,BookUseTypeDR,UseAutoBook)  //add--yzd--090302:ExamineAfterFree
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDHCRBCLocParamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCLocParamExecute ]
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

ClassMethod QueryDHCRBCLocParamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCLocParamExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 设置科室参数
ClassMethod SetDHCRBCLocParam(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisSystemParam).SetDHCRBCLocParam("","I")
	s ^tts=AllInfo
	s Rowid = $P(AllInfo,"^",1)
	s SystemSDate = $P(AllInfo,"^",2) 
	s SystemEDate = $P(AllInfo,"^",3)
	s PrintAutoVerify = $P(AllInfo,"^",4)
	s PrintAutoIssue = $P(AllInfo,"^",5) 
	S VerifyAutoIssue=$P(AllInfo,"^",6) 
	s VerifyNeedsPWD = $P(AllInfo,"^",7)
	s LocDR = $P(AllInfo,"^",8)
	s ServerDR = $P(AllInfo,"^",9) 
	s AutoDowndload = $P(AllInfo,"^",10)
	s PrintBookedTemlate=$P(AllInfo,"^",11)
	s PrintRegTemplate=$P(AllInfo,"^",12)
	s PrintRegListTemplate=$P(AllInfo,"^",13)
	s SendDate=$P(AllInfo,"^",14)
	s ExamineAfterFree=$P(AllInfo,"^",15)                //add--yzd--090302:新增“允许检查后缴费”标识
	s SendToRIS4=$p($g(AllInfo),"^",16)
	s StudyInfoToRIS4=$p($g(AllInfo),"^",17)
	s BookUseType=$p($g(AllInfo),"^",18)
	s UseAutoBooked=$p($g(AllInfo),"^",19)
	
	if (LocDR'="")
	{
		s getLocParamRowid=$o(^DHCRBC("Loc",LocDR,""))
	}
	//DLP_RowID--DLP_BRSystemSDate--DLP_BRSystemEDate--DLP_PrintAutoVerify
	//--DLP_PrintAutoIssue--DLP_VerifyAutoIssue
	//DLP_VerifyNeedsPWD--DLP_Loc_DR--DLP_Server_DR--DLP_AutoDowndload
	i OperateCode="I" d
	.i $g(getLocParamRowid)'="" d
	..s SQLCODE="200"
	.e  d
	..&sql(Insert into DHCRBC_LocParam
	     (DLP_BRSystemSDate,DLP_BRSystemEDate,DLP_PrintAutoVerify,
	     DLP_PrintAutoIssue,DLP_VerifyAutoIssue,DLP_VerifyNeedsPWD,
	     DLP_Loc_DR,DLP_Server_DR,DLP_AutoDowndload,DLP_PrintBookedTemplate,
	     DLP_PrintRegTemplate,DLP_PrintRegListTemplate,DLP_SendDate,DLP_ChargeSign,
	     DLP_SendToRIS4,DLP_StudyInfoToRIS4,DLP_BookUseType,DLP_UseAutoBooked)  
	      values(:SystemSDate,:SystemEDate,:PrintAutoVerify,:PrintAutoIssue,
	     :VerifyAutoIssue,:VerifyNeedsPWD,:LocDR,:ServerDR,:AutoDowndload,
	     :PrintBookedTemlate,:PrintRegTemplate,:PrintRegListTemplate,:SendDate,:ExamineAfterFree,:SendToRIS4,:StudyInfoToRIS4,:BookUseType,:UseAutoBooked)) //add--yzd--090302:DLP_ChargeSign以及:ExamineAfterFree
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_LocParam(DLP_BRSystemSDate,DLP_BRSystemEDate,DLP_PrintAutoVerify,
	     DLP_PrintAutoIssue,DLP_VerifyAutoIssue,DLP_VerifyNeedsPWD,
	     DLP_Loc_DR,DLP_Server_DR,DLP_AutoDowndload,DLP_PrintBookedTemplate,
	     DLP_PrintRegTemplate,DLP_PrintRegListTemplate,DLP_SendDate,DLP_ChargeSign,
	     DLP_SendToRIS4,DLP_StudyInfoToRIS4,DLP_BookUseType,DLP_UseAutoBooked) 
	      values(:SystemSDate,:SystemEDate,:PrintAutoVerify,:PrintAutoIssue,
	     :VerifyAutoIssue,:VerifyNeedsPWD,:LocDR,:ServerDR,:AutoDowndload,
	     :PrintBookedTemlate,:PrintRegTemplate,:PrintRegListTemplate,:SendDate,:ExamineAfterFree,:SendToRIS4,:StudyInfoToRIS4,:BookUseType,:UseAutoBooked)
	      where DLP_RowID=:Rowid )                                            //add--yzd--090302:DLP_ChargeSign以及:ExamineAfterFree
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_LocParam where DLP_RowID = :Rowid)
    q SQLCODE
}

/// 查询系统参数设置信息
ClassMethod GetSystemParam() As %String
{
	
	s ItemMoreReport="N"
	s MoreItemReport="N"
	s SendApptoLoc="Y"
	s SendInPtoLoc="Y"
	s SendOutPtoLoc="Y"
	s SendEmPtoLoc="N"
	s SayAppCfl="Y"
	s DSPAppointmentInterval="30"
	s QueryonlyExam="N"
	s AllowOpRegNotPaid="Y"
	s AllowIpRegNotPaid="Y"
	s AllowHPRegNotPaid="N"
	s AllowEMRegNotPaid="Y"
	s SendHPtoLoc="Y"
	s DHCRisVersion="BJ_JST"
	s FileVersion = "315"
	s FilePath = ""
	s rowid=0
	s rowid=$o(^DHCRBC("SystemParam",rowid))
	i rowid'="" d 
	.s ItemMoreReport=$p(^DHCRBC("SystemParam",rowid),"^",1)
	.s MoreItemReport=$p(^DHCRBC("SystemParam",rowid),"^",2)
	.s SendApptoLoc=$p(^DHCRBC("SystemParam",rowid),"^",3)
	.s SendEmPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",4)
	.s SendInPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",5)
	.s SendOutPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",6)
	.s SayAppCfl=$p(^DHCRBC("SystemParam",rowid),"^",7)	
	.s DSPAppointmentInterval=$p(^DHCRBC("SystemParam",rowid),"^",8)	
	.s QueryonlyExam=$p(^DHCRBC("SystemParam",rowid),"^",9)
	.s SendHPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",10)
	.s AllowOpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",11)
	.s AllowIpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",12)
	.s AllowHPRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",13)
	.s AllowEMRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",14)
	.s DHCRisVersion=$p(^DHCRBC("SystemParam",rowid),"^",15)
	.s FileVersion=$p(^DHCRBC("SystemParam",rowid),"^",16)
	.s FilePath = $p(^DHCRBC("SystemParam",rowid),"^",17)
	.s UseHisKnowledge=$p(^DHCRBC("SystemParam",rowid),"^",19)
	s Type=$g(^DHCRisAppSelectType)
	s Info=ItemMoreReport_"^"_MoreItemReport_"^"_SendApptoLoc_"^"_SendInPtoLoc_"^"_SendOutPtoLoc_"^"_SendEmPtoLoc_"^"_SayAppCfl_"^"_DSPAppointmentInterval_"^"_QueryonlyExam_"^"_SendHPtoLoc_"^"_AllowOpRegNotPaid_"^"_	AllowIpRegNotPaid_"^"_AllowHPRegNotPaid_"^"_AllowEMRegNotPaid_"^"_DHCRisVersion_"^"_FileVersion_"^"_FilePath_"^"_Type_"^"_UseHisKnowledge
	q Info
}

/// 设置系统参数设置信息
ClassMethod SetDHCRBCSystemParam(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisSystemParam).SetDHCRBCSystemParam("","I")
	s Rowid = $P(AllInfo,"^",1)
	s MoreItem = $P(AllInfo,"^",2) 
	s MoreReport = $P(AllInfo,"^",3)
	s SendOutPItoLoc = $P(AllInfo,"^",4)
	s SendEmergItoLoc = $P(AllInfo,"^",5) 
	s SendInPItoLoc = $P(AllInfo,"^",6)
	s SendApptoLoc = $P(AllInfo,"^",7)
	s SendHPtoLoc = $P(AllInfo,"^",8) 
	s AppointmentConflict = $P(AllInfo,"^",9)
	s AppointmentInterval = $P(AllInfo,"^",10)
	s OnlyQueryExamItm = $P(AllInfo,"^",11) 
	//s Version = $P(AllInfo,"^",12)
	s AllowOPRegNotPaid = $P(AllInfo,"^",12)
	s AllowIPRegNotPaid = $P(AllInfo,"^",13) 
	s AllowHPRegNotPaid=$P(AllInfo,"^",14) 
	s AllowEMRegNotPaid = $P(AllInfo,"^",15) 
	s Version=$P(AllInfo,"^",16) 
	s FileVersion=$P(AllInfo,"^",17) 
	s FilePath=$P(AllInfo,"^",18) 
	s ^DHCRisAppSelectType=$P(AllInfo,"^",19)
	s UseHisKnowledge=$P(AllInfo,"^",20)
	//DSP_Version--------没有此字段
    s countrow=0
	&sql(Select count(*) into :countrow from DHCRBC_SystemParam)
	i countrow=0 s OperateCode="I"
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_SystemParam
	     (DSP_MoreItem_Report,DSP_Item_MoreReport,DSP_SendOutPItoLoc,
	     DSP_SendEmergItoLoc,DSP_SendInPItoLoc,DSP_SendApptoLoc,DSP_SendHPtoLoc,DSP_AppointmentConflict,
	     DSP_AppointmentInterval,DSP_OnlyQueryExamItm,DSP_AllowOPRegNotPaid,DSP_AllowIPRegNotPaid,
	     DSP_AllowHPRegNotPaid,DSP_AllowEMRegNotPaid,DSP_Version,DSP_FileVersion,DSP_FilePath,DSP_UseHisKnowledge) 
	     values(:MoreItem,:MoreReport,:SendOutPItoLoc,:SendEmergItoLoc,:SendInPItoLoc,
	     :SendApptoLoc,:SendHPtoLoc,:AppointmentConflict,:AppointmentInterval,
	     :OnlyQueryExamItm,:AllowOPRegNotPaid,:AllowIPRegNotPaid,:AllowHPRegNotPaid,
	     :AllowEMRegNotPaid,:Version,:FileVersion,:FilePath,:UseHisKnowledge))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_SystemParam(
	     DSP_MoreItem_Report,DSP_Item_MoreReport,DSP_SendOutPItoLoc,
	     DSP_SendEmergItoLoc,DSP_SendInPItoLoc,DSP_SendApptoLoc,DSP_SendHPtoLoc,DSP_AppointmentConflict,
	     DSP_AppointmentInterval,DSP_OnlyQueryExamItm,DSP_AllowOPRegNotPaid,DSP_AllowIPRegNotPaid,
	     DSP_AllowHPRegNotPaid,DSP_AllowEMRegNotPaid,DSP_Version,DSP_FileVersion,DSP_FilePath,DSP_UseHisKnowledge) 
	      values(:MoreItem,:MoreReport,:SendOutPItoLoc,:SendEmergItoLoc,:SendInPItoLoc,
	     :SendApptoLoc,:SendHPtoLoc,:AppointmentConflict,:AppointmentInterval,
	     :OnlyQueryExamItm,:AllowOPRegNotPaid,:AllowIPRegNotPaid,:AllowHPRegNotPaid,:AllowEMRegNotPaid,:Version,:FileVersion,:FilePath,:UseHisKnowledge))
	     // where DSP_RowID=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_SystemParam ) //where DSP_RowID = :Rowid)
    q SQLCODE
}

/// 根据医嘱项目Rowid找到子类的申请单样式
/// 入参:医嘱项目ID  返回值:申请单样式ID
/// do ##class(web.DHCRisCodeTableAdd).GetCatAppShape("9472||1")
ClassMethod GetCatAppShape(ArcimRowid As %String) As %String
{
	q:(ArcimRowid="")
	q:'$d(^ARCIM($p(ArcimRowid,"||",1),$p(ArcimRowid,"||",2),1))
	
	s (ItmCatDR,ShapeRowid,ResInfo,Rowid,AppShape)=""
	s ItmCatDR=$p(^ARCIM($p(ArcimRowid,"||",1),$p(ArcimRowid,"||",2),1),"^",10)
	
	i (ItmCatDR'="")
	{
		s Rowid=$o(^DHCRBCAppi("ItmCat",ItmCatDR,Rowid))
		i (Rowid'="")
		{
			s ResInfo=$g(^DHCRBCApp("ItmCat",Rowid))
		}
		q:(ResInfo="")
		s ShapeRowid=$p(ResInfo,"^",2)
		i (ShapeRowid'="")
		{
			s AppShape=$P($g(^DHCRBApp("Shape",ShapeRowid)),"^",1)
		}
		 
	}
	
	q AppShape
}

/// w ##class(web.DHCRisCodeTableAdd).GetItmCatDR("20017||3892")
ClassMethod GetItmCatDR(orditmrowid As %String) As %String
{
	s (arcimid,OrderRowid,itemsub,ItmCatDR)=""
	q:(orditmrowid="")
	s OrderRowid=$p(orditmrowid,"||",1)
	s itemsub=$p(orditmrowid,"||",2)
	
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)) ""
    
    s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
    
    q ItmCatDR
}

/// 获取体位
/// w ##class(web.DHCRisCodeTableAdd).GetBodyPosition()
ClassMethod GetBodyPosition() As %String
{
	s Posture="",ret="",bodyrowid=""	
    s Rowid="" f  s Rowid=$o(^DHCRBC("PosturetoBodyPart",Rowid),-1) q:(Rowid="")  d
    .s bodyrowid=$p($g(^DHCRBC("PosturetoBodyPart",Rowid)),"^",1)
    .s Posture=$p($g(^DHCRBC("PosturetoBodyPart",Rowid)),"^",2)
    .i bodyrowid="" d
    ..i ret="" d
    ...s ret=Posture
    ..e  d
    ...s ret=ret_"^"_Posture
    q ret
}

/// 检查预约使用方式分类
ClassMethod GetBKUseTypeInfo() As %String
{
	s ret=""
	s ret="1"_$C(1)_"最大数"_"^"_"2"_$C(1)_"检查项目时间"
	q ret
}

ClassMethod GetBKUseTypebyDR(Rowid) As %String
{
	s Desc="最大数"
	i Rowid="2" s Desc="检查项目时间"
	q Desc
}

/// 根据科室ID 查询预约使用方式分类
/// w ##class(web.DHCRisCodeTableAdd).GetBKUseFlagbyLoc("83")
ClassMethod GetBKUseFlagbyLoc(LocDR As %String) As %String
{
	q:(LocDR="") ""
	
	s Rowid="",BookUseTypeDR=""
	s Rowid=$o(^DHCRBC("Loc",LocDR,Rowid)) 
	q:(Rowid="") "1"
	
	s BookUseTypeDR=$P($g(^DHCRBC("LocParam",Rowid)),"^",23)
	i BookUseTypeDR="" s BookUseTypeDR="1"
	q BookUseTypeDR
}

/// 查询名称：QueryARCCodeByCat
/// 功能：查询医嘱项目名称
/// 参数：子类ROWID,医嘱名称
/// 返回：医嘱列表类列表 
/// 作者：sunyi
/// 日期：2011-10-17
Query QueryARCCodeByCat(OrdSubCatId As %String, OrdName As %String = "") As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String")
{
}

ClassMethod QueryARCCodeByCatExecute(ByRef qHandle As %Binary, OrdSubCatId As %String, OrdName As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryARCCodeByCat","211") 
 //^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version} 取指定子类下的医嘱项
 s ^tts("sy")=OrdSubCatId_"^"_OrdName
 s ind=1 
 Set repid=$I(^CacheTemp)
 i (OrdName="")
 {
	 i OrdSubCatId'="" d
	 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip)) q:(Subscrip="")  d
	 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip,Version)) q:(Version="")  d
	 ...s ItemRowid=Subscrip_"||"_Version
	 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2) 
	 ...Do OutItmMastC
 }
 else
 {
	    k ^DHCRISQUERYITEMCS
	    s rARCIMDesc="",rItemRowID="",rSubCategoryDesc="",rPrice=""
		s OrdName=$g(OrdName)
		s OrdName=$ZCONVERT(OrdName,"U")
		s i=0
		s id=0 f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
		.s text=$p(^ARC("ALIAS",id),"^",6)
		.s text=$ZCONVERT(text,"U")
		.q:($l(text)=0)
		.q:(($e((text),1,$l(OrdName)))'[OrdName)
		.s tarid=$p(^ARC("ALIAS",id),"^",1)
		.q:tarid=""
		.s id1=$p(tarid,"||",1)
		.s id2=$p(tarid,"||",2)
		.q:$d(^ARCIM(id1,id2,1))=0
		.s rItemRowID=id1_"||"_id2
		.q:(rItemRowID="")
		.q:$d(^DHCRISQUERYITEMCS(rItemRowID))
		.s ^DHCRISQUERYITEMCS(rItemRowID)=""
		.s rARCIMDesc=$p(^ARCIM(id1,id2,1),"^",2)
		.s yzcode=$p(^ARCIM(id1,id2,1),"^",1)
		.s ItemRowid="",ItemDesc=""
		.s ItemRowid=rItemRowID
		.s ItemDesc=rARCIMDesc
		.s lei=""
		.s leiname=""
		.s daleicode=""
		.s daleiname=""
		.s uomcode=""
		.s uomdesc=""
		.s uomcode=$p(^ARCIM(id1,id2,8),"^",14)
		.i uomcode'="" s uomdesc=$p(^CT("UOM",uomcode),"^",2)
		.s lei=$p(^ARCIM(id1,id2,1),"^",10)
		.i lei'="" s rSubCategory=$p(^ARC("IC",lei),"^",2)
		.s daleicode=$p(^ARC("IC",lei),"^",8)
		.i daleicode'="" d
		..s rCategory=$p(^OEC("ORCAT",daleicode),"^",2)
		..i rCategory["检查" Do OutItmMastC
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItmMastC
 set Data=$lb(ItemRowid,ItemDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCCodeByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCCodeByCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryARCCodeByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCCodeByCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询申请单样式表
Query QueryHospital() As %Query(ROWSPEC = "TRowid:%String,THospitalDesc:%String")
{
}

ClassMethod QueryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableAdd","QueryHospital")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid=0 f  s Rowid=$o(^CT("HOSP",Rowid)) q:(Rowid="")  d
 .s hospitalDesc=$p(^CT("HOSP",Rowid),"^",2)
 .Do OutHospital
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutHospital
 set Data=$lb(Rowid,hospitalDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
