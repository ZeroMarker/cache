Class EPRservice.LISData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*
/// 取LIS检验项目子类
Query SelectLISItemCategory() As %SQLQuery(ROWSPEC = "RowID:%Integer, Code:%String, Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_LISData_SelectLISItemCategory, SqlProc ]
{
	SELECT ARCIC_RowId, ARCIC_Code, ARCIC_Desc FROM SQLUSER.ARC_ItemCat
	WHERE ARCIC_OrderType='L'
}

/// 取LIS检验项目
ClassMethod SelectLISItemByCateIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemByCateIDExecute ]
{
	// Clean up ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)

	s qHandle=""
	Quit $$$OK
}

ClassMethod SelectLISItemByCateIDExecute(ByRef qHandle As %Binary, aCategoryID As %String) As %Status
{
	s qHandle=""
	q:($d(aCategoryID)=0)||(aCategoryID="") $$$OK
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s subscript=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,""))
	while subscript'=""
	{
		s version=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript,""))
		while version'=""
		{
			s code=$p($G(^ARCIM(subscript,version,1)),"^",1)
			s desc=$P($G(^ARCIM(subscript,version,1)),"^",2)
			s rowid=subscript_"||"_version
			do SetOutputRow
			s version=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript,version))
		}
		s subscript=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript))
	}
	 
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetOutputRow
	set row=$lb(rowid,code,desc)   //按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=row
	Set ind=ind+1
	Quit
}

ClassMethod SelectLISItemByCateIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemByCateIDExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" 
	{			
		// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else 
	{				
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SelectLISItemByCateID(aCategoryID As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String")
{
}


Query SelectLISItemIndicators(aItemID As %String) As %SQLQuery(ROWSPEC = "RowID:%Integer, Code:%String, Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_LISData_SelectLISItemIndicators, SqlProc]
{
}
///   取LIS检验项目的指标项
*/
/// 	Desc:		根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",查询一段时间内的检验医嘱(返回已经执行的检验套列表)
/// 	Creator:	HouJian
/// 	CreateTime:	2009-05-27
/// 	Input:		EpisodeID：%String		病人就诊号
/// 				Begdate：%Date			开始日期
/// 				EndDate：%Date			结束日期
/// Output:		OEOrdItemID:%String		医嘱套Rowid	
/// 				OEOrdItemDesc:%String	医嘱套描述
/// 				LabEpisodeNo:%String	标本号
Query GetLISItemListByDate(EpisodeID As %String, Begdate As %String, EndDate As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OEOrdItemDesc:%String,LabEpisodeNo:%String")
{
}

ClassMethod GetLISItemListByDateExecute(ByRef qHandle As %Binary, EpisodeID As %String, Begdate As %String, EndDate As %String) As %Status
{
	s qHandle=""
	q:($d(aCategoryID)=0)||(aCategoryID="") $$$OK
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s subscript=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,""))
	while subscript'=""
	{
		s version=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript,""))
		while version'=""
		{
			s code=$p($G(^ARCIM(subscript,version,1)),"^",1)
			s desc=$P($G(^ARCIM(subscript,version,1)),"^",2)
			s rowid=subscript_"||"_version
			do SetOutputRow
			s version=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript,version))
		}
		s subscript=$O(^ARCIM(0,"ARCIC_DR",aCategoryID,subscript))
	}
	 
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetOutputRow
	set row=$lb(rowid,code,desc)   //按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=row
	Set ind=ind+1
	Quit
}

ClassMethod GetLISItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLISItemListByDateExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" 
	{			
		// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else 
	{				
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLISItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLISItemListByDateExecute ]
{
	// Clean up ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)

	s qHandle=""
	Quit $$$OK
}

}
