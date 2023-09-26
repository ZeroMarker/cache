/// Modified By ZX 2013-09-25  
/// 描述:维修对象故障的严重程度
Class web.DHCEQM.DHCEQMCSeverityLevel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by sjh SJH0036 2020-09-27
ClassMethod SaveData(val, isDel As %Library.String = "")
{
	n PLIST,RowID
    s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s Code=$p(val,"^",2)
	s Desc=$p(val,"^",3)
	s Level=$p(val,"^",4)
	s PLIST(6)="N"
	i (+isDel=2)
	{
		
	  &SQL(select SL_RowID into :tmpRowID from SQLUSER.DHC_EQMCSeverityLevel where (SL_Code=:Code and SL_Desc=:Desc and SL_Level=:Level) and SL_InvalidFlag<>'Y')
	  if (tmpRowID'="")&(tmpRowID'=RowID) q -3001
	  
	  if RowID=""
	  {
	    &SQL(insert into SQLUSER.DHC_EQMCSeverityLevel values:PLIST())
	    q SQLCODE
	  }
	  else 
	  {
	     &SQL(update SQLUSER.DHC_EQMCSeverityLevel values:PLIST() where SL_RowID=:RowID)
	     q SQLCODE
	  }
	}
	i (+isDel=1)
	  {
	    i (RowID '="")
	    {
	       &SQL(update SQLUSER.DHC_EQMCSeverityLevel set SL_InvalidFlag='Y' where SL_RowID=:RowID)
		   q SQLCODE
	    }
	}
}

/// modified by czf 406181 增加TRow并输出
Query SeverityLevel(Code As %String = "", Desc As %String = "", Remark As %String = "", Level As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TLevel:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod SeverityLevelExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", Level As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
 	s Level=$ZCONVERT(Level ,"U")

	s index=1
	s rowid=0
	s TRow=1
	//s TJob=$j
	
	d BuildDataGetSeverityLevel
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCSeverityLevel.SeverityLevel",TJob,index-1)
	
	Quit $$$OK
BuildDataGetSeverityLevel
	f  s rowid=$o(^DHCEQCCode("DHCEQMCSeverityLevel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetSeverityLevel
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",2) //描述
	.s TLevel=$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",3) //级别
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",4) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",5) //无符号标志
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(TLevel,"U")'[Level)&(Level'="")
	.d OutputRowGetSeverityLevel
	quit
OutputRowGetSeverityLevel
   	s Data=$lb(TRowID,TCode,TDesc,TLevel,TRemark,TInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetSeverityLevel
	s (TRowID,TCode,TDesc,TLevel,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod SeverityLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SeverityLevelExecute ]
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

ClassMethod SeverityLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SeverityLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCSeverityLevel",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",4) //
	s resultex=resultex_"^"	
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCSeverityLevel",rowid)),"^",5)
	q resultex
}

}
