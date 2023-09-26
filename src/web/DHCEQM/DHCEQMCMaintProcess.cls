Class web.DHCEQM.DHCEQMCMaintProcess Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"
	i (+isDel=1)
	{
		&SQL(update SQLUSER.DHC_EQMCMaintProcess set MP_InvalidFlag='Y' where MP_RowID=:RowID) 
	}
	else
	{
		s Code=$p(val,"^",2)
		s Desc=$p(val,"^",3)
		s SQLCODE=0
		s tmpRowID=""
		&SQL(select MP_RowID into:tmpRowID from SQLUSER.DHC_EQMCMaintProcess where MP_Code=:Code and MP_Desc=:Desc and MP_InvalidFlag!='Y')
		if ((tmpRowID'="")&(tmpRowID'=RowID)) q -3001
	  	if RowID=""
	  	{
	    	&SQL(insert into SQLUSER.DHC_EQMCMaintProcess values:PLIST())
	  	}
	  	else 
	  	{
	     	&SQL(update SQLUSER.DHC_EQMCMaintProcess values:PLIST() where MP_RowID=:RowID)
	  	}
	}
	if SQLCODE q SQLCODE
	s ID=$g(%ROWID)
	q ID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCMaintProcess","MaintProcess")
Query MaintProcess(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String")
{
}

ClassMethod MaintProcessExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	
	d BuildDataGetMaintProcess
	
	Quit $$$OK
BuildDataGetMaintProcess
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintProcess",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintProcess
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",4) //无符号标志
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetMaintProcess
	quit
OutputRowGetMaintProcess
   	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintProcess
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod MaintProcessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintProcessExecute ]
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

ClassMethod MaintProcessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintProcessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetMaintProcessByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCMaintProcess",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintProcess",rowid)),"^",4) //
	q resultex
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCMaintProcess","LookUp")
Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
	SELECT MP_Desc,
		   MP_RowID,
		   MP_Code
	FROM sqluser.DHC_EQMCMaintProcess
	where MP_InvalidFlag = 'N' and MP_Desc like nvl(:para,'')||'%'
}

}
