/// desc: 写query的时候不用去写四个方法了,用类代码生成来实现编译时生成Excute,fetch,Close
Class web.CSSDHUI.Query Extends %Query [ Not ProcedureBlock ]
{

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
	$$$GENERATE(" Set repid=$I(^CacheTemp)")
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
	$$$GENERATE(" Set ind=$o(^CacheTemp(repid,ind))")
	$$$GENERATE(" If ind="""" {")
	$$$GENERATE("  Set AtEnd=1")
	$$$GENERATE("  Set Row=""""")
	$$$GENERATE(" }Else{")
	$$$GENERATE("  Set Row=^CacheTemp(repid,ind)")    ///格式化数据
	$$$GENERATE("  For i=1:1:$LISTLENGTH(Row) Do")
	$$$GENERATE("  .Set Temp=$LISTGET(Row,i)")
	;$$$GENERATE("  .Set Temp=$$FormatColValue^DHCSTMHUICOMMON(Temp)")
	$$$GENERATE("  .Set Temp=##class(web.CSSDHUI.Query).FormatColValue(Temp)")		;这里不可以用.. 引用时会理解为具体业务类中的引用
	$$$GENERATE("  .Set $LIST(Row,i)=Temp")
	$$$GENERATE(" }")
	$$$GENERATE(" s qHandle=$lb(AtEnd,repid,ind)")
	$$$GENERATE(" QUIT $$$OK")
	QUIT $$$OK
}

ClassMethod Close(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
	$$$GENERATE(" Set repid=$LIST(qHandle,2)")
	$$$GENERATE(" Kill ^CacheTemp(repid)")
	$$$GENERATE(" QUIT $$$OK")
	QUIT $$$OK
}

ClassMethod FormatColValue(val) [ ProcedureBlock = 1 ]
{
	i ($ISVALIDNUM(val)&&(+val=val)) d
	.s tmpVal=$s(val<0:-val,1:val)
	.s:($e(tmpVal,1)=".") val=$tr($fn(val,","),"")		;数字格式处理 .5-->0.5, -.5-->-0.5
	
	q val
}

}
