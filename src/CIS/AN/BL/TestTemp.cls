/// 临时测试类
Class CIS.AN.BL.TestTemp Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.TestTemp","FindStockTestData")
Query FindStockTestData() As %Query(ROWSPEC = "SeqNo,Col1,Col2,Col3,Col4,Col5,Col6,Col7,Col8,Col9,Col10") [ SqlProc ]
{
}

ClassMethod FindStockTestDataExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	set col1="测试数据",col2="测试数据",col3="测试数据",col4="测试数据",col5="测试数据"
	set col6="测试数据",col7="测试数据",col8="测试数据",col9="测试数据",col10="测试数据"
	for i=1:1:1000
	{
		set seqNo=i
		do OutputRow	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(seqNo,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10)
	s ind=ind+1
	q
}

ClassMethod FindStockTestDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStockTestDataExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindStockTestDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStockTestDataExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
