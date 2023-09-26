Class web.DHCEQ.Risk.CTGrade Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by CZF0134 2021-02-23 增加出参
Query GetRiskGrade(Code As %String = "", Desc As %String = "", MinValue As %String = "", MaxValue As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TMinValue:%String,TMaxValue:%String,TRemark:%String,TCycleNum:%String,TCycleUnitDR:%String,TCycleUnit:%String,TCycle:%String")
{
}

ClassMethod GetRiskGradeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", MinValue As %String = "", MaxValue As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskGrade",rowid)) quit:rowid=""  d
	.d ResetVariablesGetRiskGrade
	.q:$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",6)="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode ,"U")'=Code)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",2)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'=Desc)
	.s TMinValue=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",3)
	.q:(MinValue'="")&&(TMinValue'=MinValue)
	.s TMaxValue=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",4)
	.q:(MaxValue'="")&&(TMaxValue'=MaxValue)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",5)
	.s TRowID=rowid
	.s TCycleNum=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",7)
	.s TCycleUnitDR=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",8)
	.i TCycleUnitDR'="" s TCycleUnit=$p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycle=TCycleNum_TCycleUnit
	.d OutputRowGetRiskGrade
	Quit $$$OK
OutputRowGetRiskGrade
	s Data=$lb(TRowID,TCode,TDesc,TMinValue,TMaxValue,TRemark,TCycleNum,TCycleUnitDR,TCycleUnit,TCycle)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskGrade
	s (TRowID,TCode,TDesc,TMinValue,TMaxValue,TRemark,TCycleNum,TCycleUnitDR,TCycleUnit,TCycle)=""
	quit
}

ClassMethod GetRiskGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskGradeExecute ]
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

ClassMethod GetRiskGradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskGradeExecute ]
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
		s PLIST(7)="Y"
		&SQL(Update sqluser.DHC_EQCRiskGrade Values :PLIST() where RG_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)="N"
	s PLIST(8)=$p(val,"^",7)
	s PLIST(9)=$p(val,"^",8)

	s tmpid=""
	&SQL(select RG_RowID into :tmpid from sqluser.DHC_EQCRiskGrade where RG_Code=:Code and RG_Desc=:Desc and RG_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCRiskGrade Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCRiskGrade Values :PLIST() where RG_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneRiskGrade(rowid As %Library.String = "")
{
	new result
	s (result)=""
	s result= ^DHCEQCCode("DHCEQCRiskGrade",rowid)
	s resultex=result_"^"	;CycleUnit		//CZF0134 2021-02-23
	i $p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",8)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",8))),"^",2)
	q resultex
}

}
