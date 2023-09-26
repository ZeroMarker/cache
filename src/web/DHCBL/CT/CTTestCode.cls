Class web.DHCBL.CT.CTTestCode Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-24
/// Description：查询检验项目内容
/// Table：User.CTTestCode
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTTestCode","GetList","","")
Query GetList(desc) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowId=0
		if ($d(^DHCLISBSVersion(1))){
			for
			{	
				s RowId=$o(^dbo.BTTestCodeD(RowId)) q:RowId=""
				s Code=$listget($g(^dbo.BTTestCodeD(RowId)),2)
				s Desc=$listget($g(^dbo.BTTestCodeD(RowId)),3)
				s Active=$listget($g(^dbo.BTTestCodeD(RowId)),25)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i (Active="1")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}	
			}
		}
		else{
			for
			{	
				s RowId=$o(^TTAB("TC",RowId)) q:RowId=""
				s Code=RowId
				s Desc=$p($g(^TTAB("TC",RowId)),"\",1)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i ($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)
				{
					d OutputRow
				}	
			}
		}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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
