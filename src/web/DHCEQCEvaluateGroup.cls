Class web.DHCEQCEvaluateGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Created By GBX 2015-03-18 15:05:02  GBX0035
/// Desc:评价组查询DHC_EQCEvaluateGroup
Query EvaluateGroup(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String:编码,TDesc:%String:描述,TRemark:%String:备注,TInvalidFlag:%String:无效标志,TRow:%String:序号")
{
}

ClassMethod EvaluateGroupExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCEvaluateGroup",rowid)) quit:rowid=""  d
	.d ResetVariablesGetEvaluateGroup
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",rowid)),"^",1)
	.q:(Code'="")&(Code'=TCode)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",rowid)),"^",2)
	.q:(Desc'="")&(Desc'=TDesc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.d OutputRowGetEvaluateGroup
	Quit $$$OK
OutputRowGetEvaluateGroup
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEvaluateGroup
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod EvaluateGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateGroupExecute ]
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

ClassMethod EvaluateGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Created By GBX 2015-03-18 15:05:02  GBX0035
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s SQLCODE=0
	TStart
	i (+isDel=1)
	{
		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCEvaluateGroup Values :PLIST() where EG_RowID = :rowid) 
		if SQLCODE 
		{ 
			TRollBack
			q SQLCODE
		}
		TCommit
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	;s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	s PLIST(5)="N"
	s tmpid=""
	&SQL(select EG_RowID into :tmpid from sqluser.DHC_EQCEvaluateGroup where EG_Code=:Code and EG_Desc=:Desc and EG_InvalidFlag!='Y')
	if ((tmpid="")||(tmpid=rowid))
	{
		i (rowid="")
		{
			&SQL(Insert Into sqluser.DHC_EQCEvaluateGroup Values :PLIST())
		} 
		else
		{
			&SQL(Update sqluser.DHC_EQCEvaluateGroup Values :PLIST() where EG_RowID = :rowid)
		}
	}
	if SQLCODE 
	{ 
		TRollBack
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	TCommit
	q ID
}

/// Created By GBX 2015-03-18 15:05:02  GBX0035
/// w ##Class(web.DHCEQCEquipType).GetDocByID(rowid)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQCCode("DHCEQCEvaluateGroup",rowid))
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
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^",4),"bool") //InvalideFlag
	q resultex
}

/// Add By DJ 2015-08-28 DJ0159
/// 描述:跟进编码获取ID或者名称
ClassMethod GetIDOrDescByCode(vCode, vFlag)
{
	s (ID,Desc)=""
	&SQL(Select EG_RowID,EG_Desc Into :ID,:Desc From SQLUSER.DHC_EQCEvaluateGroup Where EG_Code=:vCode and EG_InvalidFlag='N')
	i vFlag=1 q ID
	i vFlag=2 q Desc
	q ""
}

}
