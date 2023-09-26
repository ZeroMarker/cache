/// /author: wanghc
/// date: 2011-09-23
/// desc: 写query的时候不用去写四个方法了,用类代码生成来实现编译时生成Excute,fetch,Close
/// Modified by wuqk 2014-7-7
/// 临时global采用进程global ^||CacheTemp
Class DtPortal.Query Extends %Query
{

ClassMethod Close(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
		$$$GENERATE(" Set repid=$LIST(qHandle,2)")
 		$$$GENERATE(" Kill ^||CacheTemp(repid)")
 		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

ClassMethod Execute(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, ProcedureBlock = 1, ServerOnly = 1 ]
{
		s %code=0
		#; don't generate any code if it not for a query
		i %mode="method" QUIT $$$OK
		#; %mode is "propertymethod" for a valid query. We don't have any way currently to detect a misuse of a query class
		if '$$$comMemberDefined(%class,$$$cCLASSquery,%property) QUIT $$$OK
		#; Reset the formal list to the query declaration:
		#; write inputArgs
		$$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
		$$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
		$$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
		s sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) q:$$$ISERR(sc) sc

		#; Initialize qHandle...
		$$$GENERATE(" Set repid=$I(^||CacheTemp)")
		$$$GENERATE(" If $g(ind)="""" Set ind=1")
		#; copy code to Excute
		$$$comMemberKeyGetLvar(query,%class,$$$cCLASSquery,%property,$$$cQUERYsqlquery)
		s qline=0
		f i=1:1:$l(query,$$$NL) s line=$p(query,$$$NL,i) i line'="" s qline=qline+1,qline(qline)=line
		f i=1:1:qline-1 $$$GENERATE($Char(9,9)_qline(i))
		i qline {
			$$$GENERATE($Char(9,9)_qline(qline))
		}
		$$$GENERATE(" Set qHandle=$lb(0,repid,0)")
		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

ClassMethod Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
		$$$GENERATE(" Set AtEnd=$LIST(qHandle,1)")
		$$$GENERATE(" Set repid=$LIST(qHandle,2)")
		$$$GENERATE(" Set ind=$LIST(qHandle,3)")
		$$$GENERATE(" Set ind=$o(^||CacheTemp(repid,ind))")
		$$$GENERATE(" If ind="""" { // if there are no more rows, finish fetching")
		$$$GENERATE(" Set AtEnd=1")
		$$$GENERATE(" Set Row=""""")
		$$$GENERATE(" }Else{ // fetch row")
		$$$GENERATE(" Set Row=^||CacheTemp(repid,ind)")
		$$$GENERATE(" }")
		$$$GENERATE(" s qHandle=$lb(AtEnd,repid,ind)")
		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

}
