Class web.DHCREAGUserDepartment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 140;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, user As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentI("MasterIndex","demo","D01",6)=
	//^lab.DHCCTDepartmentI("SequenceIndex",1,"D01")=
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s dep="" f  s dep=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,dep)) q:dep=""  d
	..s name=$li(^lab.DHCCTDepartmentD(dep),3)
	..s UseFlag="Y"
	..s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,dep,""))
	..i '$l(id) s UseFlag="N"
	..s IsDefault=""
	..i $l(id) s IsDefault=$li(^lab.DHCCTUserDepartmentD(id),4)
	..i '$l(IsDefault) s IsDefault="N"
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(dep,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100608
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(user As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100608
/// Description:： 保存用户科室
/// Table：        DHCCTUserDepartment
/// Input：        用户,科室列表
/// Output：       
/// Return：       0:成功,非0:失败
/// Others：
ClassMethod SaveUserDepart(UserId As %String, DepartList As %String, DefDepart As %String) As %String
{
	n (UserId,DepartList,DefDepart)
	s UserId=$g(UserId),DepartList=$g(DepartList),DefDepart=$g(DefDepart)
	i '$l(DepartList) d  q 0
	.&sql(delete from lab.DHCCTUserDepartment where UserDR=:UserId)
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	//&sql(delete from lab.DHCCTUserDepartment where UserDR=:UserId)
	//i SQLCODE=100 s SQLCODE=0
	s SQLCODE=0
	s depart="" f  s depart=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserId,depart)) q:(depart="")!(SQLCODE'=0)  d
	.s dep=depart_","
	.i DepartList'[dep &sql(delete from lab.DHCCTUserDepartment where UserDR=:UserId and DepartmentDR=:depart)
	i SQLCODE'=0 Quit $$Rollback("delete:"_SQLCODE)
	f i=1:1:$l(DepartList,",") d  q:SQLCODE
	.s DepCode=$p(DepartList,",",i)
	.i '$l(DepCode) q
	.i $d(^lab.DHCCTUserDepartmentI("MasterIndex",UserId,DepCode)) q
	.&sql(insert into lab.DHCCTUserDepartment(UserDR,DepartmentDR,IsDefault) values(:UserId,:DepCode,'N'))
	If SQLCODE'=0 Quit $$Rollback("insert:"_SQLCODE)
	if $l(DefDepart)>0 d
	.&sql(update lab.DHCCTUserDepartment set IsDefault='Y' where UserDR=:UserId and DepartmentDR=:DefDepart)
	If SQLCODE'=0 Quit $$Rollback("update:"_SQLCODE)
	TCOMMIT
	Quit 0
Rollback(para)
  s para=$g(para)
  TROLLBACK
  q "1"_$c(2)_para
  //错误处理
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$Rollback(RetMsg)
}

ClassMethod GetAccDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccDepartExecute(ByRef qHandle As %Binary, user As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentI("MasterIndex","demo","D01",6)=
	//^lab.DHCCTDepartmentI("SequenceIndex",1,"D01")=
	s seq="" f  s seq=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq)) q:seq=""  d
	.s dep="" f  s dep=$o(^lab.DHCCTDepartmentI("SequenceIndex",seq,dep)) q:dep=""  d
	..s name=$li(^lab.DHCCTDepartmentD(dep),3)
	..s UseFlag="Y"
	..s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,dep,""))
	..i '$l(id) q
	..s UseFlag="N"
	..s IsDefault=""
	..i $l(id) s IsDefault=$li(^lab.DHCCTUserDepartmentD(id),4)
	..i '$l(IsDefault) s IsDefault="N"
	..d OutputDep			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDep
	set Data=$lb(dep,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAccDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccDepartExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100608
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAccDepart(user As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100908
/// Description:： 保存默认科室
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SaveDefaultDepart(user As %String, depart As %String) As %String
{
	n (user,depart)
	s user=$g(user),depart=$g(depart)
	i '$l(user) q "用户为空"
	i '$l(depart) q "科室为空"
	TSTART
	&sql(update lab.DHCCTUserDepartment set IsDefault='N' where UserDR=:user)
	i SQLCODE TROLLBACK  q SQLCODE
	&sql(update lab.DHCCTUserDepartment set IsDefault='Y' where UserDR=:user and DepartmentDR=:depart)
	i SQLCODE TROLLBACK  q SQLCODE
	TCOMMIT
	Quit 0
}

}
