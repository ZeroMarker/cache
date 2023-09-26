Class web.DHCOPReturnReason Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// d ##class(web.DHCOPReturnReason).AddData("0011","退号1","18/08/2016","")
/// 增加数据
ClassMethod AddData(code, desc, DateFrom, DateTo)
{
	//n (code,desc,DateFrom,DateTo)
	//s ^tempscl("data")=code_","_desc_","_DateFrom_","_DateTo
	//s $ZT="ErrorAddData"
	s code=$tr(code," ")
    s desc=$tr(desc," ")
    &sql(select COUNT(Reason_Desc) into :num From SQLUser.DHC_OPReturnReason where Reason_Desc=:desc)
    q:num>0 "["_desc_"]描述重复!"
    s DateFrom=$tr(DateFrom," ")
    s DateTo=$tr(DateTo," ")
    s:DateFrom'="" DateFrom=..%ZDH(DateFrom) //$zdh(DateFrom,4)
    s:DateTo'="" DateTo=..%ZDH(DateTo) //$zdh(DateTo,4)
    s code=$ZCVT(code,"U")
	&SQL( insert into SQLUser.DHC_OPReturnReason (Reason_Code,Reason_Desc,Reason_DateFrom,Reason_DateTo) 
	values (:code,:desc,:DateFrom,:DateTo))
	q SQLCODE
 //ErrorAddData
	//q -1
}

/// 删除数据
ClassMethod DeleteData(RowID As %String)
{
   &SQL(delete  FROM  SQLUser.DHC_OPReturnReason where RTRowId=:RowID )
   q SQLCODE
}

/// 更新数据
ClassMethod UpdateData(RowID As %String, code As %String, desc As %String, DateFrom As %String, DateTo As %String)
{
   //n (RowID,code,desc,DateFrom,DateTo)
   //s $zt="ErrorUpdateData1"
   s code=$tr(code," ")
   s desc=$tr(desc," ")
   &sql(select COUNT(Reason_Desc) into :num From SQLUser.DHC_OPReturnReason where RTRowId<>:RowID and Reason_Desc=:desc)
   q:num>0 "["_desc_"]描述重复!"
   s DateFrom=$tr(DateFrom," ")
   s DateTo=$tr(DateTo," ")
   s code=$ZCVT(code,"U")
   s:DateFrom'="" DateFrom=..%ZDH(DateFrom) //$zdh(DateFrom,4)
   S:DateTo'="" DateTo=..%ZDH(DateTo) //$zdh(DateTo,4)
   &SQL( update SQLUser.DHC_OPReturnReason (Reason_Code,Reason_Desc,Reason_DateFrom,Reason_DateTo) 
   values (:code,:desc,:DateFrom,:DateTo) where RTRowId=:RowID )
   q SQLCODE
 //ErrorUpdateData1
	//q "-1"
}

Query FindOPReturnReasonInfo(Code As %String, Desc As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod FindOPReturnReasonInfoExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Code=$tr(Code," ")
	s Desc=$tr(Desc," ")
	s CodeIn=$ZCVT(Code,"U")
	s LenCode=$L(CodeIn)
	s DescIn=$ZCVT(Desc,"U")
	s LenDescIn=$L(DescIn)
	s RTRowID=0
	f  s RTRowID=$o(^ReturnReason(RTRowID))  q:RTRowID=""  d
	.s Code=$p(^ReturnReason(RTRowID),"^",1)
	.s Desc=$p(^ReturnReason(RTRowID),"^",2)
	.s DateFrom=$p(^ReturnReason(RTRowID),"^",3)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom) //$zd(DateFrom,4)
	.s DateTo=$p(^ReturnReason(RTRowID),"^",4)
	.s:DateTo'="" DateTo=..%ZD(DateTo) //$zd(DateTo,4)
	.s CodeSub=$E(Code,1,LenCode)
	.s DescSub=$E(Desc,1,LenDescIn)
	.Q:(CodeIn'="")&&($ZCVT(CodeSub,"U")'=CodeIn)
	.Q:(DescIn'="")&&(DescIn'=$ZCVT(DescSub,"U"))
	.Do OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
  set Data=$lb(RTRowID,Code,Desc,DateFrom,DateTo)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod FindOPReturnReasonInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPReturnReasonInfoExecute ]
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

ClassMethod FindOPReturnReasonInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPReturnReasonInfoExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod FindReason()
{
	s RTRowID=0
	s str=""
	f  s RTRowID=$o(^ReturnReason(RTRowID))  q:RTRowID=""  d
	.s Code=$p(^ReturnReason(RTRowID),"^",1)
	.s Desc=$p(^ReturnReason(RTRowID),"^",2)
	.s DateFrom=$p(^ReturnReason(RTRowID),"^",3)
	.Q:(DateFrom>+$H)&&(DateFrom'="")
	.s DateTo=$p(^ReturnReason(RTRowID),"^",4)
	.Q:(DateTo<+$H)&&(DateTo'="")
	.s Desc=Desc_"!"_RTRowID
	.i str="" s str=Desc
	.e  s str=str_"^"_Desc
	Q str
}

}
