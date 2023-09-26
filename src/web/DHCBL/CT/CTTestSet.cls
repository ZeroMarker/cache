Class web.DHCBL.CT.CTTestSet Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-1-19
/// Description：查询检验项目内容
/// Table：lab.CTTestSet
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTTestSet","GetList","")
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
				s RowId=$o(^dbo.BTTestSetD(RowId)) q:RowId=""
				s Code=$listget($g(^dbo.BTTestSetD(RowId)),2)
				s Desc=$listget($g(^dbo.BTTestSetD(RowId)),3)
				s Active=$listget($g(^dbo.BTTestSetD(RowId)),18)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i (Active="1")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}	
			}
		}
		else{
			s Subscript=0         
				for{
					s Subscript=$o(^ARCIM(Subscript)) q:Subscript=""
					s Version=0
					for  
					{	
						s Version=$o(^ARCIM(Subscript,Version)) q:Version="" 
						s RowId = Subscript_"||"_Version
						s Code=$p($g(^ARCIM(Subscript,Version,1)),"^",1) 
						s Desc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)  
						s ARCIMItemCatDR=$p($g(^ARCIM(Subscript,Version,1)),"^",10) 
						s:ARCIMItemCatDR'="" ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
						s:ARCIMItemCatDR="" ARCICOrderType=""
						s enableflag=##class(web.DHCBL.CT.Arcim).GetARCIMEnable(RowId)
						
						s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
						i (ARCICOrderType="L")&(enableflag="Y")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))
						{
							d OutputRow
						}	
					}
				}
			/*
			for
			{	
				s RowId=$o(^TTAB("TS",RowId)) q:RowId=""
				s Code=RowId
				s Desc=$p($g(^TTAB("TS",RowId)),"\",1)
				
				i ($ZCONVERT(Desc,"U")[desc)
				{
					d OutputRow
				}
			}*/	
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
