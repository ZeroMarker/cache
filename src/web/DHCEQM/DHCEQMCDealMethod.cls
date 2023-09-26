Class web.DHCEQM.DHCEQMCDealMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	//s RowID=""
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"
	i (+isDel=2)
	{
		//start by csj 20190601 避免重复
		s tmpid=""
		&SQL(select DM_RowID into :tmpid from sqluser.DHC_EQMCDealMethod where DM_Code=:PLIST(2) or DM_Desc=:PLIST(3) and DM_InvalidFlag!='Y')
		if ((tmpid'="")&&(tmpid'=RowID)) q -3003	;重复记录
		//end by csj 20190601 避免重复
		if RowID=""
		{
		&SQL(insert into SQLUSER.DHC_EQMCDealMethod values:PLIST())
		q SQLCODE
		}
		else 
		{
		 &SQL(update SQLUSER.DHC_EQMCDealMethod values:PLIST() where DM_RowID=:RowID)
		 q SQLCODE
		}
	}
	i (+isDel=1)
	{
		i (RowID '="")
	       {
		       &SQL(update SQLUSER.DHC_EQMCDealMethod set DM_InvalidFlag='Y' where DM_RowID=:RowID)
		       q SQLCODE
	      }
	}
}

Query DealMethod(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod DealMethodExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	s TRow=0
	//s TJob=$j
	
	d BuildDataGetDealMethod
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCDealMethod.DealMethod",TJob,index-1)
	
	Quit $$$OK
BuildDataGetDealMethod
	f  s rowid=$o(^DHCEQCCode("DHCEQMCDealMethod",rowid))  quit:rowid=""  d
	.d ResetVariablesGetDealMethod
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",3) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",4) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetDealMethod
	quit
OutputRowGetDealMethod
	s TRow=TRow+1
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDealMethod
	s (LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod DealMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DealMethodExecute ]
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

ClassMethod DealMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DealMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCDealMethod",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",4) //
	q resultex
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DM_Desc,
	   DM_RowID,
	   DM_Code
FROM sqluser.DHC_EQMCDealMethod
where DM_InvalidFlag = 'N' and DM_Desc like nvl(:para,'')||'%'
}

/// 20150112  Mozy0149
/// w ##Class(web.DHCEQCDealMethod).UpdDealMethod("01^AAA")
ClassMethod UpdDealMethod(data)
{
	n dmrowid,OperMethod,code,desc
	Set dmrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503003")
	if (OperMethod=0)||(desc="") Quit ""
	&SQL(Select DM_RowID Into :dmrowid from SQLUSER.DHC_EQMCDealMethod Where DM_InvalidFlag='N' and DM_Desc=:desc)
	if dmrowid=""
	{
		if code=""
		{
			Set dmrowid=$Order(^DHCEQCCode("DHCEQMCDealMethod",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",dmrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCDealMethod(DM_Code, DM_Desc, DM_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set dmrowid=$Get(%ROWID)
	}
	Quit dmrowid
}

}
