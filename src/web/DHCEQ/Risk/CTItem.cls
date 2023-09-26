Class web.DHCEQ.Risk.CTItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetRiskItem(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String")
{
}

ClassMethod GetRiskItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskItem",rowid)) quit:rowid=""  d
	.d ResetVariablesGetRiskItem
	.q:$p($g(^DHCEQCCode("DHCEQCRiskItem",rowid)),"^",4)="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCRiskItem",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode ,"U")'=Code)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCRiskItem",rowid)),"^",2)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'=Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCRiskItem",rowid)),"^",3)
	.s TRowID=rowid
	.d OutputRowGetRiskItem
	Quit $$$OK
OutputRowGetRiskItem
	s Data=$lb(TRowID,TCode,TDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskItem
	s (TRowID,TCode,TDesc,TRemark)=""
	quit
}

ClassMethod GetRiskItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskItemExecute ]
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

ClassMethod GetRiskItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCRiskItem Values :PLIST() where RI_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"


	s tmpid=""
	&SQL(select RI_RowID into :tmpid from sqluser.DHC_EQCRiskItem where RI_Code=:Code and RI_Desc=:Desc and RI_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCRiskItem Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCRiskItem Values :PLIST() where RI_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneRiskItem(rowid As %Library.String = "")
{
	new result
	s (result)=""
	s result= ^DHCEQCCode("DHCEQCRiskItem",rowid)
	q result
}

Query GetRiskItemValue(RiskItem As %String = "", Weight As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TWeight:%String,TDesc:%String,TRemark:%String")
{
}

ClassMethod GetRiskItemValueExecute(ByRef qHandle As %Binary, RiskItem As %String = "", Weight As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskItemValue",rowid)) quit:rowid=""  d
	.d ResetVariablesGetRiskItemValue
	.q:$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",5)="Y"
	.s TRiskItem=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",1)
	.q:(RiskItem'="")&&(TRiskItem'=RiskItem)
	.s TWeight=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",2)
	.q:(Weight'="")&&(TWeight'=Weight)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",3)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'=Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",4)
	.s TRowID=rowid
	.d OutputRowGetRiskItemValue
	Quit $$$OK
OutputRowGetRiskItemValue
	s Data=$lb(TRowID,TWeight,TDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskItemValue
	s (TRowID,TWeight,TDesc,TRemark,TRiskItem)=""
	quit
}

ClassMethod GetRiskItemValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskItemValueExecute ]
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

ClassMethod GetRiskItemValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskItemValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SaveRiskItemValue(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(6)="Y"
		&SQL(Update sqluser.DHC_EQCRiskItemValue Values :PLIST() where RIV_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s RiskItem=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s Desc=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)="N"


	s tmpid=""
	&SQL(select RIV_RowID into :tmpid from sqluser.DHC_EQCRiskItemValue where RIV_RiskItemDR=:RiskItem and RIV_Desc=:Desc and RIV_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCRiskItemValue Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCRiskItemValue Values :PLIST() where RIV_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneRiskItemValue(rowid As %Library.String = "")
{
	new result
	s (result)=""
	s result= ^DHCEQCCode("DHCEQCRiskItemValue",rowid)
	q result
}

}
