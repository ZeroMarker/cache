Class web.DHCQCUser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 78;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCQCUser","GetAll","302911","","SZSNSQSKRMYY","","LABDATA","DHC-APP")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, HospCode As %String, DeptCode As %String, sLabNameSpace As %String, sMedNameSpace As %String) As %Status
{
	s code=$g(code),name=$g(name),visible=$g(visible)
	//i ..RefreshUser()
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set uSeq=0
	If DeptCode'="" Do
	.Set UserId="" For  Set UserId=$Order(^[sLabNameSpace]TTAB("UA",UserId)) Quit:UserId=""  Do
	..//医院过滤
	..If $Length(HospCode),'$Data(^[sLabNameSpace]TTAB("UA",UserId,3,HospCode)) Quit
	..Set CtDepCode="" For  Set CtDepCode=$Order(^[sLabNameSpace]TTAB("UA",UserId,4,CtDepCode)) Quit:CtDepCode=""  Do
	...Set UserName=""
	...If $Length(DeptCode),DeptCode'=CtDepCode Quit
	...//If UserId="demo" Quit
	...If UserId="trak" Quit
	...Set CurHosFlag=0
	...If $Piece(^[sLabNameSpace]SSU("SSUSR",1,UserId),"^",7)="N" Quit
	...If $Length(UserId) Set UserName=$Piece(^[sLabNameSpace]SSU("SSUSR",1,UserId),"^",2)
	...If $Length(UserName)>10 Quit
	...If $Length(name),UserName'[name Quit
	...Set uSeq=uSeq+1
	...If $Length(code),code'=UserId Quit
	...d OutputRow		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(UserId,UserName,uSeq)
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
 	If ind="" {				
 	    // if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{				
 	    // fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20110429
/// Description:： 用户查询,按照logon里面的进行设置
/// Table：        SS_USER
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：       先把名字空间写死,以后在改
Query GetAll(code As %String, name As %String, HospCode As %String, DeptCode As %String, sLabNameSpace As %String, sMedNameSpace As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Sequence:%String") [ SqlProc ]
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, depart As %String) As %Status
{
	s depart=$g(depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTUserI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTUserI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTUserD(id))
	..s uVis=$li(str,6)
	..i uVis'="Y" q
	..s uCode=$li(str,2)
	..s uName=$li(str,3)
	..//^lab.DHCCTUserDepartmentI("MasterIndex","demo","D01",7)=
	..i $l(depart),'$d(^lab.DHCCTUserDepartmentI("MasterIndex",uCode,depart)) q
	..d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(uCode,uName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataExecute ]
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
/// CreatDate：    20100429
/// Description:： 用户快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(depart As %String) As %Query(ROWSPEC = "code:%String,name:%String") [ SqlProc ]
{
}

/// Creator：      huhm
/// CreatDate：    20100721
/// Description:： 用户密码验证
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// d ##class(web.DHCQCUser).CheckUser("demo","demo")
ClassMethod CheckUser(user As %String, password As %String) As %String
{
	s user=$g(user),password=$g(password)
	s pwd=$$ENCR(password)
	If '$Data(^["LABDATA"]SSU("SSUSR",1,user)) Quit ""
	Set UsrPwd=$Piece($Get(^["LABDATA"]SSU("SSUSR",1,user)),"^",3)
	If UsrPwd'=pwd Quit ""
	Set UsrName=$Piece($Get(^["LABDATA"]SSU("SSUSR",1,user)),"^",2)
	Quit UsrName

ENCR(x) n (x)
 s const=37,out=""
 f piece=1:1:$l(x) s char=$e(x,piece) d
 . i char="D" s char=$c(2)
 . i char="p" s char=$c(3)
 . i char="d" s char=$c(4)
 . i char="t" s char=$c(5)
 . s num=$a(char)
 . s num=(num-piece+const)#255
 . i num>127 s num=(num+128)#255
 . i num<32 s num=(num+40)#255
 . i $c(num)="^" s num=num+1
 . s $e(out,piece)=$c(num#255)
 ;
 ; Pad out the length
 s len=$l(out)
 f piece=(len+1):1:12 d
 . s char=$e(out,(piece-len))
 . s num=$a(char)
 . s num=(num*2.345*const*(const-7))#255
 . i num>127 s num=(num+128)#255
 . i num<32 s num=(num+40)#255
 . i $c(num)="^" s num=num+1
 . s $e(out,piece)=$c(num#255)
 ;         
 q out
}

/// Creator：      DaiYi
/// CreatDate：    20121015
/// Description:： 用户登录医院代码信息查询,还是根据以前的医院代码维护
/// Table：        CT_CentreCode
/// Input：        UserCode:用户代码
/// Output：       HospCode:医院代码，HospName:医院名称
/// Return：       
/// Others：       无
/// d ##class(web.DHCQCUser).QueryHospitals("demo")
ClassMethod QueryHospitals(UserCode As %String) As %String
{
	Set Ret=""
	Set UserCode=$Get(UserCode)
	If $Data(^TTAB("UA",UserCode)) Do
	.If $Data(^TTAB("UA",UserCode,3)) Do
	.Set HospCode=""
	.For  Set HospCode=$Order(^TTAB("UA",UserCode,3,HospCode)) Quit:HospCode=""  Do
	..Set HospName=$Piece($Get(^TTAB("CC",HospCode)),"\",1)
	..Set Ret=Ret_HospCode_"|"_HospName_"^"
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121015
/// Description:： 取的用户姓名
/// Table：        ss_user
/// Input：        UserId:用户代码
/// Output：       UserName:姓名
/// Return：       
/// Others：       无
/// d ##class(web.DHCQCUser).QueryUserName("demo")
ClassMethod QueryUserName(UserId As %String) As %String
{
	Set UserId=$Get(UserId)
	Set Ret=""
	If UserId="" Quit ""
	If $Data(^["LABDATA"]SSU("SSUSR",1,UserId)) Do
	.Set Ret=$Piece($Get(^["LABDATA"]SSU("SSUSR",1,UserId)),"^",2)
	Else  Do
	.Set Ret=""
	Quit Ret
}

Storage Default
{
<Data name="DHCQCUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCUserD</DataLocation>
<DefaultData>DHCQCUserDefaultData</DefaultData>
<IdLocation>^web.DHCQCUserD</IdLocation>
<IndexLocation>^web.DHCQCUserI</IndexLocation>
<StreamLocation>^web.DHCQCUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
