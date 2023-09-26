/// Creator: wang ying
/// CreatDate: 2015-10-10
/// Description: 部分公用Query类文件
Class dhc.qm.report.ucomm Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2015-10-10
/// Description:科室组Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.ucomm","getDeptGroup")
Query getDeptGroup() As %Query(ROWSPEC = "groupDr:%Integer,groupCode:%String,groupName:%String") [ SqlProc ]
{
}

ClassMethod getDeptGroupExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,year,type,period,dept)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .if AdmType="I" s Type="住院科室"
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s CtCode=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .s LocFlag=$p(^CTLOC(CTLOCID),"^",14)
    .q:desc["停用"
    .s Depdr=$p(^CTLOC(CTLOCID),"^",19)
    .i Depdr'="" d
    ..s DepartCode=$P(^RBC("DEP",Depdr),"^",1) 
    ..s Department=$P(^RBC("DEP",Depdr),"^",2)  //科室组
    ..;s tmp=Depdr_"^"_DepartCode_"^"_Department
    ..s ^TMPDHCCJXPADEPT($j,Depdr)=DepartCode_"^"_Department
    
   
    s count=0
    s deptDr=0
    f  s deptDr=$o(^TMPDHCCJXPADEPT($j,deptDr)) q:deptDr=""  d
    .s deptCode=$p($g(^TMPDHCCJXPADEPT($j,deptDr)),"^",1)
    .s deptName=$p($g(^TMPDHCCJXPADEPT($j,deptDr)),"^",2)
    .;s tmp=deptDr_"^"_deptCode_"^"_deptName
    .d outputRow
   
 	k ^TMPDHCCJXPADEPT($j)
 
  	q $$$OK
outputRow
    s Data=$lb(deptDr,deptCode,deptName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getDeptGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDeptGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getDeptGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDeptGroupExecute ]
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

Storage Default
{
<StreamLocation>^dhc.qm.report.ucommS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
