Include Nur.DateFormat

/// 护理计划状态码表
Class web.DHCNurPlanStatus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(Parr As %String) As %String
{
	s id=$p(Parr,"^")
	s Code=$P(Parr,"^",2)
	s Desc=$P(Parr,"^",3)
	s FromDat=$P(Parr,"^",4)
	i FromDat["-" s FromDat=$$$zdh(FromDat,3)  //年-月-日
	i FromDat["/" s FromDat=$$$zdh(FromDat,1)  // 月/日/年
	s ToDat=$P(Parr,"^",5)
	i ToDat["-" s ToDat=$$$zdh(ToDat,3)
	i ToDat["/" s ToDat=$$$zdh(ToDat,1)
	
	q:(ToDat'="")&&(FromDat>ToDat) "截止日期应该大于开始日期!"
	i id="" s a=##class(User.DHCNurPlanStatus).%New()
	e  s a=##class(User.DHCNurPlanStatus).%OpenId(id)
	
    s a.SCode=Code
    s a.SDesc=Desc
    s a.SDateFrom=FromDat
    s a.SDateTo=ToDat
    
    d a.%Save()
    q a.%Id()
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanStatus).%DeleteId(id)
	q 0
}

ClassMethod FindStatusListExecute(ByRef qHandle As %Binary, Scode As %String = "", Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^pstmp=Scode_"^"_Sdesc
 	s id=""  f  s id=$o(^DHCNurPlan("Status",id)) q:id=""  d
 	.s adata=^DHCNurPlan("Status",id)
    .s code=$listget(adata,2)
    .q:(Scode'="")&(code'[Scode)
    .s desc=$listget(adata,3)
    .q:(Sdesc'="")&(desc'[Sdesc)
    .s fromdate=$listget(adata,4)
    .i fromdate'="" s fromdate=$$$zd(fromdate,3)
    .s todate=$listget(adata,5)
    .i todate'="" s todate=$$$zd(todate,3)
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,code,desc,fromdate,todate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusListExecute ]
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

ClassMethod FindStatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindStatusList(Scode As %String, Sdesc As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,fromdate:%String,todate:%String")
{
}

// w ##class(web.DHCNurPlanStatus).GetStatuslist()

ClassMethod GetStatuslist() As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanStatus:FindStatusList")
	d rs.Execute()
	while(rs.Next()){
		s TypId=rs.GetDataByName("id")
		s Typcode=rs.GetDataByName("code")
		s Typdesc=rs.GetDataByName("desc")
		s Typfromdate=rs.GetDataByName("fromdate")
		s Typtodate=rs.GetDataByName("todate")
		i Typfromdate'="" s Typfromdate=$$$zdh(Typfromdate,3)
		i Typtodate'="" s Typtodate=$$$zdh(Typtodate,3)
		
		continue:(Typfromdate>+$h)
		continue:(Typtodate'="")&&(Typtodate<+$h)
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(Typcode,"ID")
		d retChildJson.SetAt(Typdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

}
