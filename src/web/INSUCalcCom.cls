Import SQLUser

Class web.INSUCalcCom Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetpathCom(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s ret=##class(web.DHCJFTITMP).getpath()
	q ret
}

ClassMethod GetSysDateCom(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s ret=##class(web.INSUBase).GetSysDate()
	q ret
}

ClassMethod AbortHisDivCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Str As %Library.String, SFlag As %Library.String, SInv As %String)
{
	;s ret=##class(INSUHisDivideCtl).AbortHisDiv(Str,SFlag,SInv)
	q ret
}

ClassMethod HisDivideCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm As %Library.String, Bill As %Library.String, INSUType As %Library.String, inQFX As %Library.String, patType As %Library.String, gwyType As %Library.String)
{
	s ret=##class(web.INSUHisDivideSvr).HisDivide(Adm,Bill,INSUType,inQFX,patType,gwyType)
	q ret
}

ClassMethod GetDivInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Str As %Library.String)
{
	s ret=##class(web.INSUDivideCtl).GetDivInfo(Str)
	q ret
}

ClassMethod GetHisDivInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Str As %Library.String)
{
	s ret=##class(web.INSUHisDivideCtl).GetHisDivInfo(Str)
	q ret
}

ClassMethod GetInfoByAdmCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Str As %Library.String)
{
	s ret=##class(web.INSUHisDivideSvr).GetInfoByAdm(Str)
	q ret
}

ClassMethod CheckStatusCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm As %Library.String, Bill As %Library.String)
{
	s ret=##class(web.INSUDivideSgSvr).CheckStatus(Adm,Bill)
	q ret
}

ClassMethod QueryPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPatTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=""
	f  s id=$o(^DHCINSUPatTypeD(id)) q:id=""  d
	.s xx=$g(^DHCINSUPatTypeD(id))
	.s code=$List(xx,2)
    .s demo=$List(xx,3)
    .s desc=$List(xx,4)
    .s enab=$List(xx,5)
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	set Data=$lb(code,demo,desc,enab,$g(id))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatTypeExecute ]
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

Query QueryPatType() As %Query(ROWSPEC = "代码:%String,名称:%String,标志:%String,备注:%String")
{
}

Storage Default
{
<Data name="INSUCalcComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.INSUCalcComD</DataLocation>
<DefaultData>INSUCalcComDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.INSUCalcComD</IdLocation>
<IndexLocation>^web.INSUCalcComI</IndexLocation>
<StreamLocation>^web.INSUCalcComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
