/// 医嘱频次维护
Class web.DHCDocFreqSortEdit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      李相宗
/// CreatDate:    2011.11.28
/// Description:  得到医嘱频次相关信息
/// Table:        PHC_Freg
Query FindFrgInfo(SexName As %String) As %Query(ROWSPEC = "NO:%String,PHCFRRowId:%String,PHCFRCode:%String,PHCFRDesc1:%String,PHCFRMarkNO:%String,PHCFRADMType:%String,TType:%String")
{
}

ClassMethod FindFrgInfoExecute(ByRef qHandle As %Binary, SexName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s NO=0
 	s PHCFRRowId=0 f  s PHCFRRowId=$O(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""  d
 	.s PHCFRCode=$p(^PHCFR(PHCFRRowId),"^",1)  //频次Code
 	.s PHCFRDesc1=$p(^PHCFR(PHCFRRowId),"^",3)	//频次描述
 	.s PHCFRMarkNO=$p($G(^PHCFR(PHCFRRowId,"DHC")),"^",4) //频次序列
 	.s PHCFRADMType=$p($G(^PHCFR(PHCFRRowId,"DHC")),"^",3)	//就诊类型
 	.s TType=PHCFRADMType
 	.if PHCFRADMType'="" s ^Tempzong1=PHCFRADMType
 	.s NO=NO+1  
	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NO,PHCFRRowId,PHCFRCode,PHCFRDesc1,PHCFRMarkNO,PHCFRADMType,TType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFrgInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFrgInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFrgInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFrgInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:      李相宗
/// CreatDate:    2011.11.28
/// Description:  更新 PHC_Freg
/// d ##class(web.DHCDocFreqSortEdit).RunQuery("FindAdmType","")
ClassMethod UpdatePHCFRR(PHCFRRowId As %String, TPHCFRMarkNO As %String, TPHCFRADMType As %String) As %String
{
	
	
	s Str=1
	q:PHCFRRowId="" Str
 	s $P(^PHCFR(PHCFRRowId,"DHC"),"^",4)=TPHCFRMarkNO //频次序列
 	s $P(^PHCFR(PHCFRRowId,"DHC"),"^",3)=TPHCFRADMType	//就诊类型
 	s Str=0
 	q Str
}

/// Creator:      李相宗
/// CreatDate:    2011.11.28
/// Description:  匹配原有序列 PHC_Freg
/// d ##class(web.DHCDocFreqSortEdit).RunQuery("FindAdmType","")
ClassMethod MarchTPHCFRMarkNO(ChosePHCFRRowIdRowId As %String, InputTPHCFRMarkNO As %String) As %String
{
	
	s Str=0,NO=0
	q:InputTPHCFRMarkNO="" Str
	s PHCFRRowId=0 f  s PHCFRRowId=$O(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""  d
	.s NO=NO+1
	.q:ChosePHCFRRowIdRowId=PHCFRRowId
 	.s PHCFRMarkNO=$p($G(^PHCFR(PHCFRRowId,"DHC")),"^",4) //频次序列
 	.q:PHCFRMarkNO'=InputTPHCFRMarkNO
 	.s Str=NO_"^"_PHCFRRowId_"^"_PHCFRMarkNO
 	q Str
}

}
