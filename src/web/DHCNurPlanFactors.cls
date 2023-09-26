Include Nur.DateFormat

/// 护理计划关联因素
Class web.DHCNurPlanFactors Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(Parr As %String) As %String
{
	s id=$p(Parr,"^")
	s Code=$P(Parr,"^",2)
	s Desc=$P(Parr,"^",3)
	s LinkFunction=$P(Parr,"^",4)
	s LinkPara=$P(Parr,"^",5)
	s FuncTyp=$P(Parr,"^",6)
	s Note=$P(Parr,"^",7)
	
	s FromDat=$P(Parr,"^",8)
	i FromDat["-" s FromDat=$$$zdh(FromDat,3)  //年-月-日
	i FromDat["/" s FromDat=$$$zdh(FromDat,1)  // 月/日/年
	s ToDat=$P(Parr,"^",9)
	i ToDat["-" s ToDat=$$$zdh(ToDat,3)
	i ToDat["/" s ToDat=$$$zdh(ToDat,1)
	
	s Typ=$P(Parr,"^",10)
	s EmrCode=$P(Parr,"^",11)
	
	q:(ToDat'="")&&(FromDat>ToDat) "截止日期应该大于开始日期!"
	i id="" s a=##class(User.DHCNurPlanFactors).%New()
	e  s a=##class(User.DHCNurPlanFactors).%OpenId(id)
	
    s a.FCode=Code
    s a.FDesc=Desc
    s a.FFunction=LinkFunction
    s a.FParameter=LinkPara
    s a.FFuncType=FuncTyp
    s a.FNote=Note
    s a.FDateFrom=FromDat
    s a.FDateTo=ToDat
    s a.FTyp=Typ
    s a.FEmrCode=EmrCode
    
    d a.%Save()
    q a.%Id()
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanFactors).%DeleteId(id)
	q 0
}

ClassMethod FindFactorsListExecute(ByRef qHandle As %Binary, Scode As %String = "", Sdesc As %String = "", Stype As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^pstmp=Scode_"^"_Sdesc
 	s id=""  f  s id=$o(^DHCNurPlan("Factors",id)) q:id=""  d
 	.s adata=^DHCNurPlan("Factors",id)
    .s code=$listget(adata,2)
    .q:(Scode'="")&(code'[Scode)
    .s desc=$listget(adata,3)
    .q:(Sdesc'="")&(desc'[Sdesc)
    .s typ=$listget(adata,4)
    .q:(Stype'="")&(typ'=Stype)
    .s note=$listget(adata,5)
    .s emrcode=$listget(adata,6)
    .s linkfunc=$listget(adata,7)
    .s linkpara=$listget(adata,8)
    .s functyp=$listget(adata,9)
    .s fromdate=$listget(adata,10)
    .i fromdate'="" s fromdate=$$$zd(fromdate,3)
    .s todate=$listget(adata,11)
    .i todate'="" s todate=$$$zd(todate,3)
   
    
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,code,desc,typ,note,emrcode,linkfunc,linkpara,functyp,fromdate,todate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFactorsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFactorsListExecute ]
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

ClassMethod FindFactorsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFactorsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindFactorsList(Scode As %String, Sdesc As %String, Stype As %String = "") As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,typ:%String,note:%String,emrcode:%String,linkfunc:%String,linkpara:%String,functyp:%String,fromdate:%String,todate:%String")
{
}

ClassMethod GetFactorsList(factortyp As %String = "") As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanFactors:FindFactorsList")
	d rs.Execute("","",factortyp)
	while(rs.Next()){
		s CatId=rs.GetDataByName("id")
		s Catcode=rs.GetDataByName("code")
		s Catdesc=rs.GetDataByName("desc")
		s Catfromdate=rs.GetDataByName("fromdate")
		s Cattodate=rs.GetDataByName("todate")
		i Catfromdate'="" s Catfromdate=$$$zdh(Catfromdate,3)
		i Cattodate'="" s Cattodate=$$$zdh(Cattodate,3)
		
		continue:(Catfromdate>+$h)
		continue:(Cattodate'="")&&(Cattodate<+$h)
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(CatId,"ID")
		d retChildJson.SetAt(Catdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

}
