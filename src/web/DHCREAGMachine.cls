Class web.DHCREAGMachine Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

/// Creator：      huhm
/// CreatDate：    20100819
/// Description:： 保存仪器信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0
/// Others：
ClassMethod SaveMachine(code As %String, name As %String, depart As %String, visible As %String, sequence As %String) As %String
{
	&sql(update lab.DHCCTMachine set Name=:name,DepartmentDR=:depart,Visible=:visible,Sequence=:sequence where ID=:code)
	Quit SQLCODE
}

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, visible As %String, depart As %String) As %Status
{
	s code=$g(code),name=$g(name),visible=$g(visible)
	s ^TMP($zn,"para")=code_","_name_","_visible
	i '$l(visible) s visible="Y"
	i ..RefreshMachine()
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTMachineD("ABCG")=<<$LB("","大便常规","大便常规","","Y","999")>>
	s code=$g(code),name=$g(name),visible=$g(visible)
	s seq="" f  s seq=$o(^lab.DHCCTMachineI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTMachineI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTMachineD(id))
	..s uCode=id
	..s code1=" "_code
	..s code2=" "_uCode
	..i $l(code),code2'[code1 q
	..s uName=$li(str,2)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1  q
	..s SysName=$li(str,3)
	..s DepDr=$li(str,4)
	..i $l(depart),depart'=DepDr q
	..s DepName=""
	..i $l(DepDr),$d(^lab.DHCCTDepartmentD(DepDr)) s DepName=$li(^lab.DHCCTDepartmentD(DepDr),3)
	..s uVis=$li(str,5)
	..//i $e(visible)'=$e(uVis) q
	..i $l(visible),visible="No",uVis'="Y" q
	..s uSeq=$li(str,6)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,SysName,DepName,uSeq,uVis,DepDr)
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
/// CreatDate：    20100525
/// Description:： 仪器查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, visible As %String, depart As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,SysName:%String,DepName:%String,Sequence:%String,Visible:%String,DepDr:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100525
/// Description:： 刷新仪器
/// Table：       
/// Input：        
/// Output：       
/// Return：       0
/// Others：
ClassMethod RefreshMachine() As %String
{
	k ^TMP($zn,$j)
	s code="" f  s code=$o(^TMIF(code)) q:code=""  d
	.s str=$g(^TMIF(code))
	.i '$l(str) q
	.//s MachineId=$p(str,"^",1)
	.s Name=$p(str,"\",1)
	.s port=$p(str,"\",2)
	.s ip=$g(^TMIF(code,"TCP"))
	.s Active="Y"
	.i '$l(port),'$l(ip) s Active="N"
	.i '$d(^lab.DHCCTMachineD(code)) d
	..&sql(insert into lab.DHCCTMachine(Code,Name,SysName,Visible,Sequence) values(:code,:Name,:Name,:Active,'999'))
	.e  d
	..&sql(update lab.DHCCTMachine set Visible=:Active where ID=:code)
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
	s seq="" f  s seq=$o(^lab.DHCCTMachineI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTMachineI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTMachineD(id))
	..s uVis=$li(str,5)
	..i uVis'="Y" q
	..s DepId=$li(str,4)
	..i DepId'=depart q
	..s uCode=id
	..s uName=$li(str,2)
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
/// CreatDate：    20100525
/// Description:： 仪器快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(depart As %String) As %Query(ROWSPEC = "code:%String,name:%String")
{
}

}
