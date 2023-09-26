Import sqluser

Class web.INSUPatContrastCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 117;

/// 人员类型对照
ClassMethod QueryContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContrastExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryContrastExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	;*******************************************************
	;INSUDicData表存储人员类型对照时,其字段
	;INDID_DicType----"PatTypeToEmType"
	;INDID_DicCode----存放市保人员类型编码
	;INDID_DicDesc----存放应急人员类型编码
	;INDID_DicBill1----存放自理比例
	;INDID_DicBill2----存放统筹比例
	;Add By zmgzt
	;*******************************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	s ConDr="0"
	f  s ConDr=$o(^DHCINDID("0","IType","PatTypeNBA",ConDr))  q:ConDr=""  d
    .s mCurrRow=$g(^DHCINDID(ConDr))           
	.s InsuPatCode=$p(mCurrRow,"^",2)		 		//市保人员类型编码
	.s InsuPatDes=$p(mCurrRow,"^",3)
	.s Conid="0",EmPatCode="",EmPatDes="",zlbl="",tcbl=""
	.f  s Conid=$o(^DHCINDID("0","ITypeCode","PatTypeToEmType",InsuPatCode,Conid))  q:Conid=""  d
	..if Conid'="" d
	...s mCurrRowCon=$g(^DHCINDID(Conid))
	...s InsuPatCode=$p(mCurrRowCon,"^",2)
	...s EmPatCode=$p(mCurrRowCon,"^",3)                //应急人员类型编码
	...s InsuPatDes=$$GetPatDes("PatTypeNBA",InsuPatCode)               //市保人员类型名称
	...s EmPatDes=$$GetPatDes("PatTypeNBAEM",EmPatCode)                 //应急人员类型名称
	...s zlbl=$p(mCurrRowCon,"^",4)                     //自理比例
	...s tcbl=$p(mCurrRowCon,"^",5)                     //统筹比例
	..d BuildPatCon
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildPatCon 
	set Data=$lb(InsuPatCode,EmPatCode,InsuPatDes,EmPatDes,zlbl,tcbl,Conid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
GetPatDes(dictype,code) 	
    s id="0"
    f  s id=$o(^DHCINDID("0","ITypeCode",dictype,code,id)) q:id=""  d
    .s mRow=$g(^DHCINDID(id))
    .s Desc=$p(mRow,"^",3) 
    q Desc
}

ClassMethod QueryContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContrastExecute ]
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

Query QueryContrast(Desc As %String) As %Query(ROWSPEC = "InsuPatCode:%String,EmPatCode:%String,InsuPatDes:%String,EmPatDes:%String,zlbl:%String,tcbl:%String,Conid:%String")
{
}

/// 医保科室
ClassMethod QueryINSUDptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINSUDptExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryINSUDptExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1	
	s rowid="0"
	f  s rowid=$o(^DHCINDID("0","IType","PatTypeNBAEM",rowid)) q:rowid=""  d   //医保科室在INSUDicData中的类型是"INSUDPT"  
	.s s=$g(^DHCINDID(rowid))
	.s code=$p(s,"^",2)
	.s desc=$p(s,"^",3)
	.d BuildINSUDpt
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildINSUDpt
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data 	
 	Set ind=ind+1
 	q
}

ClassMethod QueryINSUDptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINSUDptExecute ]
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

Query QueryINSUDpt(Type As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

}
