Class web.DHCEQCMaintItemCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetMaintItemCat(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String")
{
}

ClassMethod GetMaintItemCatExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCMaintItemCat",rowid)) quit:rowid=""  d
	.d ResetVariablesGetMaintItemCat
	.s TRowID=rowid
	.s TType=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",rowid)),"^",1)
	.s TType=$Case(TType,"":"","1":"保养","2":"检查","3":"维修")
	.s TCode=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",rowid)),"^",2)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",rowid)),"^",3)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",rowid)),"^",4)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",rowid)),"^",5)
	.q:TInvalidFlag="Y"
	.d OutputRowGetMaintItemCat
	Quit $$$OK
OutputRowGetMaintItemCat
	s Data=$lb(TRowID,TType,TCode,TDesc,TRemark,TInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintItemCat
	s (TRowID,TType,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod GetMaintItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintItemCatExecute ]
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

ClassMethod GetMaintItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintItemCatExecute ]
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
		s PLIST(6)="Y"
		&SQL(Update sqluser.DHC_EQCMaintItemCat Values :PLIST() where MIC_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=1
	s PLIST(3)=$p(val,"^",3)
	s Code=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s Desc=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	
	s tmpid=""
	&SQL(select MIC_RowID into :tmpid from sqluser.DHC_EQCMaintItemCat where MIC_Code=:Code and MIC_Desc=:Desc and MIC_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCMaintItemCat Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCMaintItemCat Values :PLIST() where MIC_RowID = :rowid)
	}
	b
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneMaintItemCat(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMaintItemCat",rowid)
	s resultex=rowid   //0
		s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(result,"^",1) //Type
	
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(result,"^",2) //Code
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p(result,"^",3) //描述Desc
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p(result,"^",4) //备注
	s resultex=resultex_"^"	//5
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^",5),"bool") //InvalideFlag
    q resultex
}

}
