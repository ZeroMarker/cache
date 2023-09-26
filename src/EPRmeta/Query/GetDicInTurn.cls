/// 创建者：牛才才
/// 创建日期：2012-08-09
/// 描述：查询得到已写入临时Global中的字典项，从AStartRow开始，查询ARowCount个数据，与按页查询区分
Class EPRmeta.Query.GetDicInTurn Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Query GetDicInTurn(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetDicInTurnExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""
 s ^AA("baaa")=ASessionId
 //S ^CacheTempStdQuery($J)="True"	 
 if ($D(^CacheTempStdQuery(ASessionId)))
 {
	
	if ($G(^CacheTempStdQuery(ASessionId))="True") 
	{
   Set StartPageID= AStartRow
   s ^AA("BBB")=StartPageID
   Set LastPageId = AStartRow+ARowCount
   Set PageNumCounter = 0 
   s ^AA("ccc")=LastPageId
	 set PageKey= $O(^CacheTempStdQuery(ASessionId,""))
	 s ^AA("iii")=PageKey
	 While (PageKey '="")
	 {
	   s PageNumCounter = PageNumCounter + 1
	   if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	   { 
	    s ^AA("qqq")=PageNumCounter _"@@@"_PageKey
	    Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
	   }
		
	   set PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
		 }
	 	 ;s ^gjbtest("ASessionId",ASessionId)=""
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
 if $o(%ResultID(""),-1)<%counter 
 {
	s Row = ""
	s AtEnd=1
 }
 else 
 {
	set Row=%ResultID(%counter)
	;s ^gjbtest(%counter)=Row
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
<Data name="GetDicInTurnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.Query.GetDicInTurnD</DataLocation>
<DefaultData>GetDicInTurnDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.Query.GetDicInTurnD</IdLocation>
<IndexLocation>^EPRmeta.Query.GetDicInTurnI</IndexLocation>
<StreamLocation>^EPRmeta.Query.GetDicInTurnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
