Class web.DHCREAGUserRole Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, user As %String, depart As %String) As %Status
{
	s code=$g(code)
	s ^TMP($zn,"para")=code
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTUserDepartmentD(20,"Items",4)=<<$LB("","A1")>>
	//lab.DHCCTUserRoleI("MasterIndex",UserDR, ModuleDR,6)=
	s code="" f  s code=$o(^lab.DHCCTSYSModuleD(code)) q:code=""  d
	.s str=$g(^lab.DHCCTSYSModuleD(code))
	.s id=""
	.i '$l(depart) s id=$o(^lab.DHCCTUserRoleI("MasterIndex",user, code,""))
	.i $l(depart) d
	..s ParRef=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,""))
	..i '$l(ParRef) q
	..s id=$o(^lab.DHCCTUserDepartRoleI("MasterIndex",code,ParRef,""))
	.s UseFlag="Y"
	.i '$l(id) s UseFlag="N"
	.s name=$li(str,3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(code,name,UseFlag)
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
/// CreatDate：    20100720
/// Description:： 用户访问权限查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(user As %String, depart As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String")
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
ClassMethod SaveUserRole(UserId As %String, Depart As %String, RoleList As %String) As %String
{
	n (UserId,Depart,RoleList)
	s UserId=$g(UserId),Depart=$g(Depart),RoleList=$g(RoleList)
	s ^TMP($zn,"para")=UserId_","_Depart_","_RoleList
	s SQLCODE=0
	if '$l(RoleList),$l(Depart) d
	.s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserId,Depart,""))
	.i '$l(id) q
	.&sql(delete from lab.DHCCTUserDepartRole where ParRef=:id) 
	if '$l(RoleList),'$l(Depart) &sql(delete from lab.DHCCTUserRole where UserDR=:UserId) q SQLCODE
	if SQLCODE="100" s SQLCODE="0"
	if '$l(RoleList) q SQLCODE
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	if $l(Depart) d
	.s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserId,Depart,""))
	.i '$l(id) q
	.&sql(delete from lab.DHCCTUserDepartRole where ParRef=:id)
	e  d
	.&sql(delete from lab.DHCCTUserRole where UserDR=:UserId)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 Quit $$Rollback("Delete:"_SQLCODE)
	//
	s SQLCODE=0
	i $l(Depart) d
	.s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserId,Depart,""))
	.i '$l(id) q
	.f i=1:1:$l(RoleList,",") d  q:SQLCODE
	..s RoleCode=$p(RoleList,",",i)
	..i '$l(RoleCode) q
	..&sql(insert into lab.DHCCTUserDepartRole(ParRef,ModuleDR) values(:id,:RoleCode))
	e  d
	.f i=1:1:$l(RoleList,",") d  q:SQLCODE
	..s RoleCode=$p(RoleList,",",i)
	..i '$l(RoleCode) q
	..&sql(insert into lab.DHCCTUserRole(UserDR,ModuleDR) values(:UserId,:RoleCode))
	If SQLCODE'=0 Quit $$Rollback("Add:"_SQLCODE)
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

/// Creator：      huhm
/// CreatDate：    20100721
/// Description:： 得到用户权限
/// Table：        DHCCTUserDepartment
/// Input：        用户,科室
/// Output：       
/// Return：       0:成功,非0:失败
/// Others
ClassMethod GetUserRole(user As %String, depart As %String) As %String
{
	s user=$g(user),depart=$g(depart)
	k ^TMP($zn,$j)
	s num=0
	s id="" f  s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",user,depart,id)) q:id=""  d
	.//b
	.s subid="" f  s subid=$o(^lab.DHCCTUserDepartmentD(id,"Items",subid)) q:subid=""  d
	..s module=$li(^(subid),2)
	..//b
	..s ^TMP($zn,$j,"module",module)=""
	..s ^TMP($zn,$j,"role",$e(module,1))=""
	..s num=num+1
	i num=0 d
	.s id="" f  s id=$o(^lab.DHCCTUserRoleI("MasterIndex",user,id)) q:id=""  d
	..s ^TMP($zn,$j,"module",id)=""
	..s ^TMP($zn,$j,"role",$e(module,1))=""
	..s num=num+1
	s (mdlStr,rolStr)=""
	s id="" f  s id=$o(^TMP($zn,$j,"module",id)) q:id=""  d
	.s mdlStr=mdlStr_id_$c(2)
	s mdlStr=$p(mdlStr,$c(2),1,$l(mdlStr,$c(2))-1)
	s id="" f  s id=$o(^TMP($zn,$j,"role",id)) q:id=""  d
	.s rolStr=rolStr_^(id)_$c(2)
	s rolStr=$p(mdlStr,$c(2),1,$l(rolStr,$c(2))-1)
	s RetStr=mdlStr_"^"_rolStr
	i '$l(mdlStr) s RetStr=""
	k ^TMP($zn,$j)
	Quit mdlStr
}

/// Creator：      huhm
/// CreatDate：    20100908
/// Description:： 检查用户是否已分配权限
/// Table：        DHCCTUserDepartRole
/// Input：        
/// Output：       
/// Return：       0:成功,非0:失败
/// Others
ClassMethod CheckUserRole(user As %String) As %String
{
	&sql(select * from lab.DHCCTUserDepartRole where ParRef->UserDR=:user)
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100908
/// Description:： 复制用户权限
/// Table：        DHCCTUserDepartRole
/// Input：        
/// Output：       
/// Return：       0:成功,非0:失败
/// Others
ClassMethod CopyUserRole(UserFrom As %String, UserTo As %String) As %String
{
	n (UserFrom,UserTo)
	s UserFrom=$g(UserFrom),UserTo=$g(UserTo)
	s ^TMP($zn,"CopyRole","para")=UserFrom_","_UserTo
	SET $ZTRAP="ErrorHdl",$ECODE=""   //捕获错误开始
	TSTART
	//^lab.DHCCTUserDepartmentI("MasterIndex","trak","D02",12)=
	&sql(select * from lab.DHCCTUserDepartment where UserDR=:UserTo)
	i SQLCODE=100 s RetValue=0
	i 'SQLCODE d
	.&sql(delete from lab.DHCCTUserDepartment where UserDR=:UserTo)
	.s RetValue=SQLCODE
	i RetValue TROLLBACK  q "删除权限失败。"_SQLCODE
	s dep="" f  s dep=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserFrom,dep)) q:(dep="")!(RetValue)  d
	.s id="" f  s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserFrom,dep,id)) q:(id="")!(RetValue)  d
	..s DefFlag=$li(^lab.DHCCTUserDepartmentD(id),4)
	..//科室
	..&sql(insert into lab.DHCCTUserDepartment(UserDR,DepartmentDR,IsDefault) values(:UserTo,:dep,:DefFlag))
	..i SQLCODE q
	..s ToId=$o(^lab.DHCCTUserDepartmentI("MasterIndex",UserTo,dep,""))
	..i '$l(ToId) q
	..//科室权限
	..s subid="" f  s subid=$o(^lab.DHCCTUserDepartmentD(id,"Items",subid)) q:(subid="")!(RetValue)  d
	...s module=$li(^lab.DHCCTUserDepartmentD(id,"Items",subid),2)
	...i '$l(module) s RetValue=SQLCODE q
	...&sql(insert into lab.DHCCTUserDepartRole(ParRef,ModuleDR) values(:ToId,:module))
	...i SQLCODE s RetValue=SQLCODE
	i RetValue TROLLBACK  q "复制失败:"_RetValue
	TCOMMIT
	Quit RetValue
 //错误处理
ErrorHdl
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  TROLLBACK
  q RetMsg
}

}
