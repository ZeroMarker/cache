Import SQLUser

/// 程序名DHCRisStudyNoSetDo 检查号自动产生规则
Class web.DHCRisStudyNoSetDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 360;

//查找设备组

Query FinEQGroup(Desc As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod FinEQGroupExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o(^RBC("GRP",RowId)) q:RowId=""  d
	.s GetDesc=$p(^RBC("GRP",RowId),"^",2) 
	.i GetDesc[Desc d
	..Do OutRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FinEQGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinEQGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FinEQGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinEQGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//查找所有检查号生成规则

Query FindStudyNoSet() As %Query(ROWSPEC = "TRowid:%String,TLocDr:%String,TLocName:%String,TEQGroupDR:%String,TEQGroup:%String,TPrefix:%String,TMaxNumber:%String")
{
}

ClassMethod FindStudyNoSetExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	//if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o( ^DHCPACRegInfoCR("CreateRule",0,RowId)) q:RowId=""  d
	.s EQGroupDesc="",EQGroupDr="",LocName="",LocDr=""
	.s Info=^DHCPACRegInfoCR("CreateRule",0,RowId)
	.s LocDr=$p(Info,"^",3)
	.i LocDr'="" s LocName=$p($g(^CTLOC(LocDr)),"^",2)
	.s EQGroupDr=$p(Info,"^",1)
	.i $g(EQGroupDr)'="" s EQGroupDesc=$p(^RBC("GRP",EQGroupDr),"^",2) 
	.s Prefix=$p(Info,"^",2)
	.s MaxNumber=$p(Info,"^",4)
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(RowId,LocDr,LocName,EQGroupDr,EQGroupDesc,Prefix,MaxNumber)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStudyNoSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStudyNoSetExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindStudyNoSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStudyNoSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//插入

ClassMethod InsertStudyNoSet(Info)
{
	s LocDr=$p(Info,"^",1)
	s EQGroupDr=$p(Info,"^",2)
	s Prefix=$p(Info,"^",3)
	s MaxNumber=$p(Info,"^",4)
	&sql(insert into  DHCRB_StudyNo_CreateRule (RSC_EQGroup_DR,RSC_Loc_DR,RSC_Prefix,RSC_MaxNumber)
	values (:EQGroupDr,:LocDr,:Prefix,:MaxNumber ))
	q SQLCODE
}

//更新

ClassMethod UpdateStudyNoSet(Info)
{
	s LocDr=$p(Info,"^",1)
	s EQGroupDr=$p(Info,"^",2)
	s Prefix=$p(Info,"^",3)
	s MaxNumber=$p(Info,"^",4)
	s rowid=$p(Info,"^",5)
	&sql(update  DHCRB_StudyNo_CreateRule (RSC_EQGroup_DR,RSC_Loc_DR,RSC_Prefix,RSC_MaxNumber)
	values (:EQGroupDr,:LocDr,:Prefix,:MaxNumber ) where RSC_Rowid=:rowid)
	q SQLCODE
}

//设置检查好的产生方式 

ClassMethod SetCreateType(IsAuto)
{
	s ^test111=IsAuto
	s rowid=""
	s rowid=$o(^DHCPACRegInfoCT("CreateType",0,rowid),-1)
	i (rowid="") d   
	  .&sql(insert into DHCRB_StudyNo_Createtype (RBSCT_Type) values(:IsAuto))
	else  d
	  .&sql(update DHCRB_StudyNo_Createtype set RBSCT_Type=:IsAuto)
	q SQLCODE
}

ClassMethod GetCreateType()
{
	s rowid=0 ,type=""
	s rowid =$o(^DHCPACRegInfoCT("CreateType",0,rowid))
	i (rowid'=""& rowid'=0) d
	.s type=$p(^DHCPACRegInfoCT("CreateType",0,rowid),"^",1)
	q type
}

ClassMethod DeleteStudyNoSet(rowid)
{
	&sql(delete from DHCRB_StudyNo_CreateRule where RSC_Rowid=:rowid)
	q SQLCODE
}

}
