Import SQLUser

/// 创建时间		：2006.06.07
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_OrdSetsEx
/// 索引			: ^DHCPEOSE（OSE_RowId）
/// 主要功能		：医嘱套功能扩展表
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.DHCPEOrdSetsEx Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Query SearchOrdSetsEx(aOrdSets As %Library.String = "", aBreak As %Library.String = "", aPrint As %Library.String = "") As %Query(ROWSPEC = "OSE_RowId:%String, OSE_OrdSets_DR:%String, OSE_OrdSets_DR_Name:%String, OSE_Break:%String,OSE_Print:%String,OSE_OEItem:%String,OSE_BarPrint:%String,TSpecialItem:%String,TSex:%String,IFOLD:%String,TarItem:%String,TarItemId:%String")
{
}

ClassMethod SearchOrdSetsExExecute(ByRef qHandle As %Binary, aOrdSets As %Library.String = "", aBreak As %Library.String = "", aPrint As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	i "on"=aBreak s aBreak="Y" 
	i "on"=aPrint s aPrint="Y"
	f  s id=$O(^DHCPEOSE(id)) Q:(""=id)  d
	.s CurData=$G(^DHCPEOSE(id))
	.
	.//医嘱套		OSE_OrdSets_DR	1
	.s OSEOrdSetsDR=$p(CurData,"^",1)
	.s OSEOrdSetsDRName=$p($G(^ARCOS(OSEOrdSetsDR)),"^",2)
	.Q:(""'=aOrdSets)&('(OSEOrdSetsDRName[aOrdSets))
	.s EffDateTo=$p($g(^ARCOS(OSEOrdSetsDR)),"^",16)
	.i EffDateTo'=""	q:(EffDateTo<+$h)

	.//可否拆分	OSE_Break	2
	.s OSEBreak=$p(CurData,"^",2)
	.Q:(""'=aBreak)&(OSEBreak'=aBreak)
	
    .s OSEPrint=$g(^DHCPEDataEx("OrdSetsEx",OSEOrdSetsDR))
    .Q:(""'=aPrint)&(OSEPrint'=aPrint)
    .s IFOLD=$g(^DHCPEDataEx("OrdSetsEx","IFOLD",OSEOrdSetsDR))
    .s OEItemName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OSEOrdSetsDR))
	.s BarPrintName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OSEOrdSetsDR))
	.s TSpecialItem=$G(^DHCPEDataEx("OrdSetsEx","SpecialItem",OSEOrdSetsDR))
	.s:TSpecialItem'="" TSpecialItem= $P($G(^PAC("SUBT",TSpecialItem)),"^",2)
	.s TSex=""
	.s TSex=$g(^DHCPEDataEx("DHCPEBaseData","Sex",OSEOrdSetsDR))
	.s TarItemId=$g(^DHCPEDataEx("DHCPEBaseData","taritem",OSEOrdSetsDR))
	.if TarItemId'="" s TarItem=$P(^DHCTARI(TarItemId),"^",2)
	.e  s TarItem=""
	.i TSex'="" s TSex=$P(^CT("SEX",TSex),"^",2)
    .set Data=$lb(	$g(id), OSEOrdSetsDR, OSEOrdSetsDRName, OSEBreak,OSEPrint,OEItemName,BarPrintName,TSpecialItem,TSex,IFOLD,TarItem,TarItemId)
    .
    .d OutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchOrdSetsExFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOrdSetsExExecute ]
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

ClassMethod SearchOrdSetsExClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOrdSetsExExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// //////////////////////////////////////////////////////////////

/// 更新 增加/修改
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

 	//
	s RowId=$p(InString,"^",1)
	
 	//OSE_OrdSets_DR 医嘱套 2
	s OrdSetsDR=$p(InString,"^",2)
	
 	//OSE_Break 可否拆分 3
	s Break=$p(InString,"^",3)
	s PrintOrdSets=$p(InString,"^",4)
	s OEItemName=$p(InString,"^",5)
	
 	//OSE_Break 可否拆分 3
	s BarPrintName=$p(InString,"^",6)
	//费用类型
	s SpecialItem=$p(InString,"^",7)
	//性别
	s Sex=$p(InString,"^",8)
	s ifold=$p($g(InString),"^",9)
	s taritem=$p($g(InString),"^",10)
	
    s ret=..ISave(RowId, OrdSetsDR, Break,PrintOrdSets,OEItemName,BarPrintName,SpecialItem,ifold)
	i ret=0 s ^DHCPEDataEx("DHCPEBaseData","Sex",OrdSetsDR)=Sex
	i ret=0 s ^DHCPEDataEx("DHCPEBaseData","taritem",OrdSetsDR)=taritem
	q ret
}

/// 获取团体信息
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s id=$g(InString)
	i ("-1"=id)  d
	.s id=""
	.s id=$O(^DHCPEOSE(id),-1)
	i (""'=id)  d
	.s CurData=$G(^DHCPEOSE(id))
	.
	.//医嘱套		OSE_OrdSets_DR	1
	.s OSEOrdSetsDR=$p(CurData,"^",1)
	.s OSEOrdSetsDRName=$p($G(^ARCOS(OSEOrdSetsDR)),"^",2)
	.
	.//可否拆分	OSE_Break	2
	.s OSEBreak=$p(CurData,"^",2)
	.s OSPrint=$g(^DHCPEDataEx("OrdSetsEx",OSEOrdSetsDR))
    .s OEItemName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OSEOrdSetsDR))
	.s BarPrintName=$g(^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OSEOrdSetsDR))
	.s SpecialItem=$G(^DHCPEDataEx("OrdSetsEx","SpecialItem",OSEOrdSetsDR))
	.s Sex=$G(^DHCPEDataEx("DHCPEBaseData","Sex",OSEOrdSetsDR))
	.s IFOLD=$g(^DHCPEDataEx("OrdSetsEx","IFOLD",OSEOrdSetsDR))
	.s TarItemId=$g(^DHCPEDataEx("DHCPEBaseData","taritem",OSEOrdSetsDR))
	.if TarItemId'="" s TarItem=$P(^DHCTARI(TarItemId),"^",2)
	.s Data=$g(id)_"^"_OSEOrdSetsDR_"^"_OSEOrdSetsDRName_"^"_OSEBreak_"^"_OEItemName_"^"_BarPrintName_"^"_OSPrint_"^"_SpecialItem_"^"_Sex_"^"_IFOLD_"^"_TarItemId_"^"_$G(TarItem)
	e  d
	.s Data=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^^^^"
	s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	&javascript<#(retval)#>
	q Data
}

/// 医嘱套 列表
Query ARCOrdSetsList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "名称:%String, 代码:%String, 编码:%String")
{
	select ARCOS_Desc, ARCOS_Code, ARCOS_RowId  
	from sqluser.ARC_OrdSets
	where ARCOS_Desc %STARTSWITH :Desc or ARCOS_Code %STARTSWITH :Desc
}

Query OrdSetsExList(aOrdSets As %Library.String = "", aBreak As %Library.String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT o.OSE_RowId, o.OSE_OrdSets_DR, o.OSE_Break
			,a.ARCOS_Desc as OSE_OrdSets_DR_Name
	FROM DHC_PE_OrdSetsEx as o
	inner join ARC_OrdSets as a on ((a.ARCOS_Code=o.OSE_OrdSets_DR) and (a.ARCOS_Desc %STARTSWITH :aOrdSets))
	where o.OSE_Break %STARTSWITH :aBreak
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	s OrdSetsDR=$p($g(^DHCPEOSE(Rowid)),"^",1)
	&sql(delete from DHC_PE_OrdSetsEx where OSE_RowId=:Rowid)
	if (SQLCODE=0)
	
	{ k ^DHCPEDataEx("OrdSetsEx",OrdSetsDR)
	  k ^DHCPEDataEx("OrdSetsEx","IFOLD",OrdSetsDR)
	  k ^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OrdSetsDR)
	  k ^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OrdSetsDR)
		k ^DHCPEDataEx("OrdSetsEx","SpecialItem",OrdSetsDR)
		}
	q SQLCODE
}

/// 保存数据
ClassMethod ISave(RowId As %String, OrdSetsDR As %String, Break As %String, PrintOrdSets As %String, OEItemName As %String, BarPrintName As %String, SpecialItem As %String = "N", ifold As %String)
{
   //s ^zl("ISave")=PrintOrdSets_"^"_OEItemName_"^"_BarPrintName
	i ""=RowId d
	.s ReturnFlag=..Insert(RowId, OrdSetsDR, Break,PrintOrdSets,OEItemName,BarPrintName,SpecialItem,ifold)
	e  d
	.s ReturnFlag=..Update(RowId, OrdSetsDR, Break,PrintOrdSets,OEItemName,BarPrintName,SpecialItem,ifold)
	q ReturnFlag
}

/// 更新
ClassMethod Update(RowId As %String, OrdSetsDR As %String, Break As %String, PrintOrdSets As %String, OEItemName As %String, BarPrintName As %String, SpecialItem As %String = "N", ifold As %String)
{
	&sql(update DHC_PE_OrdSetsEx
	    set	OSE_Break = :Break
	     where OSE_RowId = :RowId
	     )
	if (SQLCODE=0)
	{
		s ^DHCPEDataEx("OrdSetsEx","SpecialItem",OrdSetsDR)=SpecialItem
		s ^DHCPEDataEx("OrdSetsEx",OrdSetsDR)=PrintOrdSets
		s ^DHCPEDataEx("OrdSetsEx","IFOLD",OrdSetsDR)=ifold
		if PrintOrdSets'="Y" {
			s ^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OrdSetsDR)=""
			s ^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OrdSetsDR)=""
		}else { 
			s ^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OrdSetsDR)=OEItemName
			s ^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OrdSetsDR)=BarPrintName
		}
	}
	q SQLCODE
}

/// 插入
ClassMethod Insert(RowId As %String, OrdSetsDR As %String, Break As %String, PrintOrdSets As %String, OEItemName As %String, BarPrintName As %String, SpecialItem As %String = "", ifold As %String)
{
	&sql(insert into DHC_PE_OrdSetsEx(OSE_OrdSets_DR, OSE_Break)
	     values (:OrdSetsDR, :Break)
	     )
	if (SQLCODE=0)
	{
		s ^DHCPEDataEx("OrdSetsEx","SpecialItem",OrdSetsDR)=SpecialItem
		s ^DHCPEDataEx("OrdSetsEx",OrdSetsDR)=PrintOrdSets
		s ^DHCPEDataEx("OrdSetsEx","IFOLD",OrdSetsDR)=ifold
		s ^DHCPEDataEx("OrdSetsEx","OrdSetsOEItemAbbre",OrdSetsDR)=OEItemName
		s ^DHCPEDataEx("OrdSetsEx","OrdSetsBarAbbre",OrdSetsDR)=BarPrintName
	}
	q SQLCODE
}

Query ARCOrdSetsListNew(Desc As %Library.String = "") As %Query(ROWSPEC = "ARCOSDesc:%String:名称, ARCOSCode:%String:描述,ID:%String:ID")
{
}

ClassMethod ARCOrdSetsListNewExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
    s id=""
    f  s id=$o(^ARCOS(id)) q:id=""  d
    .s ARCOSCode=$p($g(^ARCOS(id)),"^",1)
    .s ARCOSDesc=$p($g(^ARCOS(id)),"^",2)
	.s EffDateTo=$p($g(^ARCOS(id)),"^",16)
	.i EffDateTo'=""	q:(EffDateTo<+$h)
    .Q:(Desc'="")&&(ARCOSDesc'[Desc)
    .S OrdSubCatDR=$p($g(^ARCOS(id)),"^",9)
    .S ARCICDesc=""
	.S:OrdSubCatDR'="" ARCICDesc=$p($g(^ARC("IC",OrdSubCatDR)),"^",2)
	.q:ARCICDesc'["体检医嘱套"
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ORDSET",id)
	.q:LocFlag=1

    .d ARCOrdSetsListNewyOut
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ARCOrdSetsListNewyOut      
	set Data=$lb(ARCOSDesc,ARCOSCode,$g(id))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ARCOrdSetsListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ARCOrdSetsListNewExecute ]
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

ClassMethod ARCOrdSetsListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ARCOrdSetsListNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
