Class web.DHCEQBenefitItemInfo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitItemInfo","GetBenefitItemInfo","2")
Query GetBenefitItemInfo(UseConUseContextDRextID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TMinScore:%String,TMaxScore:%String,TRemark:%String,TInvalidFlag:%String,TBFIRowID:%String,TBFIScore:%String,TBFIResume:%String,TBFIRemark:%String")
{
}

ClassMethod GetBenefitItemInfoExecute(ByRef qHandle As %Binary, UseContextDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCBenefitItem",rowid))  quit:rowid=""  d
    .s (TRowID,TCode,TDesc,TMinScore,TMaxScore,TRemark,TInvalidFlag)=""
    .s TRowID=rowid
    .k result
    .s result=^DHCEQCCode("DHCEQCBenefitItem",rowid)
    .s TCode=$p(result,"^",1)      //代码描述 
    .s TDesc=$p(result,"^",2)      //描述
    .s TMinScore=$p(result,"^",3)  //最小分值
    .s TMaxScore=$p(result,"^",4)  //最大分值
    .s TRemark=$p(result,"^",5)    //备注
    .s Flag=0
    .s TInvalidFlag=$p(result,"^",6)  //无效标志
    .s TBFIIID=0
    .f  s TBFIIID=$o(^DHCEQBenefitItemInfo(0,"BenefitItemInfo",UseContextDR,TRowID,TBFIIID))  quit:TBFIIID=""  d
   	..s (TBFIScore,TBFIResume,TBFIRemark,TBFIRowID)=""
   	..s TBFIRowID=TBFIIID
    ..s TBFIScore=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",3)  //分数
    ..s TBFIResume=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",4) //简述
    ..s TBFIRemark=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",5) //备注
    ..s Flag=1
	..d OutputRowBenefitItemInfo
	.s (TBFIScore,TBFIResume,TBFIRemark,TBFIRowID)=""
	.i Flag=0  d OutputRowBenefitItemInfo
	quit $$$OK
OutputRowBenefitItemInfo
	s Data=$lb(TRowID,TCode,TDesc,TMinScore,TMaxScore,TRemark,TInvalidFlag,TBFIRowID,TBFIScore,TBFIResume,TBFIRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitItemInfoExecute ]
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

ClassMethod GetBenefitItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitItemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveData(val)
{
    Set $ZT="ERROR" 
	TSTART 
    s length=$l(val,"&")
	f i=1:1:length  d
	.s BenefitItemInfo=$p(val,"&",i)
	.s SQLCODE=..Save(BenefitItemInfo)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
    q SQLCODE
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// w ##Class(web.DHCEQBenefitItemInfo).Save("7^43^5^20^^")
ClassMethod Save(val As %Library.String = "")
{
	new SQLCODE,rowid,UseContextID,totalScore
	s SQLCODE=0
	k PLIST
	s rowid=$p(val,"^",1)
	s PLIST(2)=$P(val,"^",2)
	s PLIST(3)=$P(val,"^",3)
	s PLIST(4)=$P(val,"^",4) 
	s PLIST(5)=$P(val,"^",5)
	s PLIST(6)=$P(val,"^",6)
	i (rowid="")  //新增按钮操作
	{
		&SQL(Insert Into SQLUSER.DHC_EQBenefitItemInfo Values :PLIST())
	}
	else  //更新按钮操作
	{
		&SQL(Update SQLUSER.DHC_EQBenefitItemInfo Values :PLIST() where BII_RowID = :rowid) 	 
		i SQLCODE=100 s SQLCODE=0
	}
	i SQLCODE'=0 q SQLCODE
	s totalScore=0
	&SQL(select sum(BII_Score) into:totalScore from SQLUSER.DHC_EQBenefitItemInfo  where BII_UseContextDR = :PLIST(2))
	&SQL(Update SQLUSER.DHC_EQUseContext set UC_TotalScore=:totalScore where UC_RowID = :PLIST(2)) 	
	i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

Storage Default
{
<Data name="DHCEQBenefitItemInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQBenefitItemInfoD</DataLocation>
<DefaultData>DHCEQBenefitItemInfoDefaultData</DefaultData>
<IdLocation>^web.DHCEQBenefitItemInfoD</IdLocation>
<IndexLocation>^web.DHCEQBenefitItemInfoI</IndexLocation>
<StreamLocation>^web.DHCEQBenefitItemInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
