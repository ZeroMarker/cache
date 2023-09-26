Class web.DHCREAGUser Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 66;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, visible As %String) As %Status
{
	s code=$g(code),name=$g(name),visible=$g(visible)
	s ^TMP($zn,"para")=code_","_name_","_visible
	i ..RefreshUser()
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTGroupTypeI("SeqIndex",1,1)=
	s code=$g(code),name=$g(name),visible=$g(visible)
	s seq="" f  s seq=$o(^lab.DHCCTUserI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTUserI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTUserD(id))
	..s uCode=$li(str,2)
	..s code1=" "_code
	..s code2=" "_uCode
	..i $l(code),code2'[code1 q
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1  q
	..s uVis=$li(str,6)
	..i $e(visible)'=$e(uVis) q
	..s uSeq=$li(str,5)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,uSeq)
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
/// CreatDate：    20100429
/// Description:： 用户查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Sequence:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100429
/// Description:： 刷新用户
/// Table：       
/// Input：        
/// Output：       
/// Return：       0
/// Others：
ClassMethod RefreshUser() As %String
{
	k ^TMP($zn,$j)
	s ns=$zu(5)
	zn "labdata"
	s code="" f  s code=$o(^SSU("SSUSR",1,code)) q:code=""  d
	.s str=^(code)
	.s UserId=$p(str,"^",1)
	.s Name=$p(str,"^",2)
	.s Pwd=$p(str,"^",3)
	.s Active=$p(str,"^",7)
	.i '$l(Active) s Active="N"
	.s ^TMP($zn,$j,UserId)=Name_"^"_Pwd_"^"_Active
	zn ns
	s id="" f  s id=$o(^TMP($zn,$j,id)) q:id=""  d
	.s str=^(id)
	.s Name=$p(str,"^",1)
	.s Pwd=$p(str,"^",2)
	.s Active=$p(str,"^",3)
	.i $d(^lab.DHCCTUserD(id)) d
	..&sql(update lab.DHCCTUser set Name=:Name,Password=:Pwd,Visible=:Active where ID=:id)
	.e  d
	..&sql(insert into lab.DHCCTUser(Code,Name,Password,Sequence,Visible) values(:id,:Name,:Pwd,'999',:Active))
	k ^TMP($zn,$j)
	Quit "0"
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
Query GetData(depart As %String) As %Query(ROWSPEC = "code:%String,name:%String")
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
ClassMethod CheckUser(user As %String, password As %String) As %String
{
	s user=$g(user),password=$g(password)
	s pwd=$$ENCR(password)
	i '$d(^lab.DHCCTUserD(user)) q ""
	s UsrPwd=$li(^lab.DHCCTUserD(user),4)
	i UsrPwd'=pwd q ""
	s UsrName=$li(^lab.DHCCTUserD(user),3)
	q UsrName

ENCR(x) n (x)
 ;
 s const=37,out=""
 ;
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

}
