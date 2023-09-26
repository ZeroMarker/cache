/// 创建者：牛才才
/// 创建日期：2012-08-09
/// 描述：查询得到已写入临时Global中的字典项，从AStartRow开始，查询ARowCount个数据，与按页查询区分
Class EPRservice.DAL.Query.DAGetDicInTurn Extends %RegisteredObject [ ProcedureBlock ]
{

Query GetDicInTurn(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetDicInTurnExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
	s qHandle="1" 
	s SQLCODE=0 
	s %counter=0
	s ID=""
	S %ResultID=""
	if ($D(^CacheTempStdQuery(ASessionId)))
	{
		if ($G(^CacheTempStdQuery(ASessionId))="True") 
		{
			Set StartPageID= AStartRow
	   		Set LastPageId = AStartRow+ARowCount
	   		Set PageNumCounter = 0 
	    	set PageKey= $O(^CacheTempStdQuery(ASessionId,""))
		 	While (PageKey '="")
		 	{
		   		s PageNumCounter = PageNumCounter + 1
		   		if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
		   		{ 
		    		Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
		   		}
		   		
		   		set PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
			}
		 	
		 	s qHandle=%ResultID
	     	
	     	Quit $$$OK
		}
	}
}

ClassMethod GetDicInTurnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
	 s SQLCODE=0 
	 s $ET="QUIT" 
	 s %counter=%counter+1
	 if $o(%ResultID(""),-1) < %counter 
	 {
		s Row = ""
		s AtEnd=1
	 }
	 else 
	 {
		set Row=%ResultID(%counter)
	 }

	 Quit $$$OK
}

ClassMethod GetDicInTurnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
	 s qHandle="" 
	 Quit $$$OK
}

Storage Default
{
<Data name="DAGetDicInTurnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.D71B.DAGetDicInTurnD</DataLocation>
<DefaultData>DAGetDicInTurnDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice.D71B.DAGetDicInTurnD</IdLocation>
<IndexLocation>^EPRservice.D71B.DAGetDicInTurnI</IndexLocation>
<StreamLocation>^EPRservice.D71B.DAGetDicInTurnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
