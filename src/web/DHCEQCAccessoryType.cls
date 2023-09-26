Class web.DHCEQCAccessoryType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modify BY:GBX GBX0018 2014-7-25  配件类型维护
Query AccessryType(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod AccessryTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=0
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetAccessoryType
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",4)   //263170 Add by BRB 2016-09-27 
	.q:TInvalidFlag="Y"   //263170 Add by BRB 2016-09-27  
	.d OutputRowGetAccessoryType
	Quit $$$OK

ResetVariablesGetAccessoryType
	s (TRowID,TCode,TDesc,TRemark)=""
	quit
OutputRowGetAccessoryType
	s TRow=TRow+1
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod AccessryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessryTypeExecute ]
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

ClassMethod AccessryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// isDel： 删除标记
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCAccessoryType Values :PLIST() where AT_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	s tmpid=""
	// MZY0021	1304172		2020-05-06
	&SQL(select AT_RowID into :tmpid from sqluser.DHC_EQCAccessoryType where AT_Code=:Code and AT_Desc=:Desc and AT_InvalidFlag<>'Y')
	if ((tmpid="")||(tmpid=rowid))
	{
		i (rowid="")
		{
			&SQL(Insert Into sqluser.DHC_EQCAccessoryType Values :PLIST())
		} 
		else
		{
			&SQL(Update sqluser.DHC_EQCAccessoryType Values :PLIST() where AT_RowID = :rowid)
		}
	}
	if ((tmpid'="")&&(tmpid'=rowid)) s SQLCODE=-9000	// Mozy003008	1266885		2020-04-09 
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCAccessoryType",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(result,"^",1) //code
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(result,"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p(result,"^",3) //备注
	q resultex
}

}
