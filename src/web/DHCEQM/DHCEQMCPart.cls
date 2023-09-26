Class web.DHCEQM.DHCEQMCPart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by sjh SJH0036 2020-09-27
ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
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
	  &SQL(select P_RowID into :tmpRowID from SQLUSER.DHC_EQMCPart where P_Code=:Code and P_Desc=:Desc and P_InvalidFlag<>'Y')
	  if (tmpRowID'="")&(tmpRowID'=RowID) q -3001
	  	
	  if RowID=""
	  {
	    &SQL(insert into SQLUSER.DHC_EQMCPart values:PLIST())
	    q SQLCODE
	  }
	  else 
	  {
	     &SQL(update SQLUSER.DHC_EQMCPart values:PLIST() where P_RowID=:RowID)
	     q SQLCODE
	  }
	}
	i (+isDel=1)
	{
		i (RowID '="")
	       {
		       &SQL(update SQLUSER.DHC_EQMCPart set P_InvalidFlag='Y' where P_RowID=:RowID)
		       q SQLCODE
	      }
	}
}

/// modified by czf 406181 增加TRow并输出
Query Part(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod PartExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
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
	//s TJob=$j
	
	d BuildDataGetPart
	
	Quit $$$OK
BuildDataGetPart
	f  s rowid=$o(^DHCEQCCode("DHCEQMCPart",rowid))  quit:rowid=""  d
	.d ResetVariablesGetPart
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",3) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",4) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetPart
	quit
OutputRowGetPart
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetPart
	s (LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod PartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PartExecute ]
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

ClassMethod PartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCPart",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCPart",rowid)),"^",4) //
	q resultex
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
SELECT P_Desc,
	   P_RowID,
	   P_Code
FROM sqluser.DHC_EQMCPart
where P_InvalidFlag = 'N' and P_Desc like nvl(:para,'')||'%'
}

Storage Default
{
<Data name="DHCEQMCPartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQM.DHCEQMCPartD</DataLocation>
<DefaultData>DHCEQMCPartDefaultData</DefaultData>
<IdLocation>^web.DHCEQM.DHCEQMCPartD</IdLocation>
<IndexLocation>^web.DHCEQM.DHCEQMCPartI</IndexLocation>
<StreamLocation>^web.DHCEQM.DHCEQMCPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
