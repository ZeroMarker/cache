Import SQLUser

Class web.INSUDivBillCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 101;

ClassMethod GetMinusItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMinusItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetMinusItemsExecute(ByRef qHandle As %Binary, Jpid As %String, billno As %String, MinusCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;Jpid, billno, MinusCat
	q:Jpid="" $$$OK
	q:billno="" $$$OK
	q:MinusCat="" $$$OK	
	k ^CACHETEMP("INSUMINUS",billno)
	s ^CACHETEMP("INSUMINUS",billno)=0
	;s ^CACHETEMP("ZYJF",Jpid,i)
	s Index=""
	f  s Index=$o(^CACHETEMP("ZYJF",Jpid,Index)) q:Index=""  d
	.s ss=$g(^CACHETEMP("ZYJF",Jpid,Index))
	.s dlbm=$p(ss,"^",11)
	.s MinusFlag=..CheckMinus(MinusCat,dlbm)
	.i MinusFlag="Y" d    ;属于负类
	..s TarDesc=$p(ss,"^",4)
	..s Qty=$p(ss,"^",5)
	..s Price=$p(ss,"^",6)
	..s TotalAmount=$p(ss,"^",7)
	..s fp=##class(web.INSUFPCtl).QueryByCode(dlbm)
	..d Build	
	.///s FIndex=$g(^CACHETEMP("INSUMINUS",billno))+1
	.s ^CACHETEMP("INSUMINUS",billno,Index)=ss
	.s ^CACHETEMP("INSUMINUS",billno)=Index
	Set qHandle=$lb(0,repid,0)	
	k ^CACHETEMP("ZYJF",Jpid)
	k ^CACHETEMP("INSUPB",Jpid)
	Quit $$$OK
Build      
	set Data=$lb(Index,TarDesc,Qty,Price,TotalAmount,fp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetMinusItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMinusItemsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetMinusItems(Jpid As %String, billno As %String, MinusCat As %String) As %Query(ROWSPEC = "Index:%String,TarDesc:%String,Qty:%String,Price:%String,TotalAmount:%String,fp:%String")
{
}

/// 检查是否属于负医嘱项的相同发票类别
/// 
ClassMethod CheckMinus(MinusCat As %String, InsuCat As %String)
{
	n (MinusCat,InsuCat)
	s Flag=""
	s CatCount=$l(MinusCat,"^")
	f i=2:1:CatCount d
	.s:InsuCat=$p(MinusCat,"^",i) Flag="Y"
	q Flag
}

/// 删除bill的负医嘱处理
ClassMethod Kill(Bill As %String)
{
	k ^CACHETEMP("INSUMINUS",Bill)
	q
}

/// 冲销负医嘱
ClassMethod ConUpdate(itmjs As %Library.String = "", itmjsex As %Library.String = "", Jpid As %String, billno As %String, TempRow As %String)
{
	n (Jpid,billno,TempRow)
	///Jpid As %String, billno As %String, TempRow	
	q:(Jpid="")!(billno="")!(TempRow="") 1
	///q:$d(^CACHETEMP("ZYJF",Jpid))=0 2
	s Amount=0,TotalAmount=0
	s TmpIndex="",MinusIndex="",TempS=""
	s flag=""
	s RowCount=$l(TempRow,"^")
	f i=2:1:RowCount q:flag="N"  d
	.s Index=$p(TempRow,"^",i)
	.s:$d(^CACHETEMP("INSUMINUS",billno,Index))=0 flag="N"
	.q:flag="N"
	.s s=$g(^CACHETEMP("INSUMINUS",billno,Index))
	.s Amount=$p(s,"^",7)
	.s:Amount>0 TmpIndex=Index,TempS=s
	.s:Amount<0 MinusIndex=Index
	.s TotalAmount=TotalAmount+Amount
	q:TmpIndex="" 3
	q:MinusIndex="" 4
	q:+TotalAmount<0 5
	s $p(TempS,"^",5)=1
	s $p(TempS,"^",6)=TotalAmount
	s $p(TempS,"^",7)=TotalAmount	
	s ^CACHETEMP("INSUMINUS",billno,Index)=TempS
	f i=2:1:RowCount d
	.s Index=$p(TempRow,"^",i)
	.i Index'=TmpIndex d
	..k ^CACHETEMP("INSUMINUS",billno,Index)
	..s ^CACHETEMP("INSUMINUS",billno)=+$g(^CACHETEMP("INSUMINUS",billno))-1
	s ^CACHETEMP("INSUMINUS",billno)=+$g(^CACHETEMP("INSUMINUS",billno))_"^Y"
	
	;s FIndex=$g(^CACHETEMP("INSUMINUS",billno))+1
	;s ^CACHETEMP("INSUMINUS",billno,FIndex)=TempS
	;s ^CACHETEMP("INSUMINUS",billno)=FIndex
	;s ^CACHETEMP("INSUMINUS",billno,"Y")="Y"
	;f i=2:1:RowCount d
	;.s Index=$p(TempRow,"^",i)
	;.k ^CACHETEMP("ZYJF",Jpid,Index)
	q 0
}

}
