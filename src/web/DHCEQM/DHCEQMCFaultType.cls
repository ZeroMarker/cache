Class web.DHCEQM.DHCEQMCFaultType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by sjh SJH0036 2020-09-27
ClassMethod SaveData(val, isDel As %Library.String = "")
{
	n PLIST,RowID
    s RowID=$p(val,"^",1)
	//s RowID=""
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s Code=$p(val,"^",2)
	s Desc=$p(val,"^",3)
	s PLIST(5)="N"
	i (+isDel=2)
	{
		
	  &SQL(select FT_RowID into :tmpRowID from SQLUSER.DHC_EQMCFaultType where FT_Code=:Code and FT_Desc=:Desc and FT_InvalidFlag<>'Y')
	  if (tmpRowID'="")&(tmpRowID'=RowID) q -3001
	  
	  if RowID=""
	  {
	    &SQL(insert into SQLUSER.DHC_EQMCFaultType values:PLIST())
	    q SQLCODE
	  }
	  else 
	  {
	     &SQL(update SQLUSER.DHC_EQMCFaultType values:PLIST() where FT_RowID=:RowID)
	     q SQLCODE
	  }
	}
	i (+isDel=1)
	{
		i (RowID '="")
	       {
		       &SQL(update SQLUSER.DHC_EQMCFaultType set FT_InvalidFlag='Y' where FT_RowID=:RowID)
		       q SQLCODE
	      }
	}
}

/// modified by czf 406181 增加TRow并输出
Query FaultType(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod FaultTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	s TRow=1
	d BuildDataGetFaultType	
	Quit $$$OK
BuildDataGetFaultType
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultType
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",4) //无符号标志
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetFaultType
	quit
OutputRowGetFaultType
   	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetFaultType
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod FaultTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FaultTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FaultTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FaultTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetFaultTypeByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCFaultType",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",4) //
	q resultex
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT FT_Desc,
	   FT_RowID,
	   FT_Code
FROM sqluser.DHC_EQMCFaultType
where FT_InvalidFlag = 'N' and FT_Desc like nvl(:para,'')||'%'
}

}
