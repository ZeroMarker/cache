/// 名称:标准版检验-微生物耐药机制
/// 描述:
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2023-3-7
Class web.DHCBL.CT.BTMCResistanceItem Extends %RegisteredObject
{

/// Creator：zrf		
/// CreatDate: 2023-3-7
/// Description：查询 微生物耐药机制 下拉框
/// Table:dbo.BTMC_ResistanceItem
/// Input:id, code, cname
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BTMCResistanceItem","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, cname As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTMCResistanceItemD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTMCResistanceItemD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTMCResistanceItem")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:cname'="" cname=$ZCONVERT(cname,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTMCResistanceItemD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTMCResistanceItemD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTMCResistanceItemD(RowID)),3)		//名称
			s Sequence= $lg($g(^dbo.BTMCResistanceItemD(RowID)),7)    // 序号
			s Active= $lg($g(^dbo.BTMCResistanceItemD(RowID)),8)      // 激活
			continue:Active=0			//过滤未激活状态数据
			if (cname'="")           
			{
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(cname) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if ((CName[cname)||(PINYINCODE[cname)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTMCResistanceItem",Sequence,RowID)=RowID
				;d OutputRowCmb
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTMCResistanceItem",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTMCResistanceItem",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTMCResistanceItemD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTMCResistanceItemD(RowID)),3)		//名称
				d OutputRowCmb
			}
		} 
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowID,Code,CName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

}
