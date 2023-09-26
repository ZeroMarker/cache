Include Nur.DateFormat

/// 护理计划项目明细
Class web.DHCNurPlanItemDetail Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod AddData(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemDetail")=Parr
	s id=$p(Parr,"^")
	s ItemMastID=$P(Parr,"^",2)
	q:(ItemMastID="") "请选择归属的项目!"
	
	s Code=$P(Parr,"^",3)
	s Desc=$P(Parr,"^",4)
	s Note=$P(Parr,"^",5)
	s KeyWord=$P(Parr,"^",6)
	s FromDat=$P(Parr,"^",7)
	i FromDat["-" s FromDat=$$$zdh(FromDat,3)  //年-月-日
	i FromDat["/" s FromDat=$$$zdh(FromDat,1)  // 月/日/年
	s ToDat=$P(Parr,"^",8)
	i ToDat["-" s ToDat=$$$zdh(ToDat,3)
	i ToDat["/" s ToDat=$$$zdh(ToDat,1)
	
	q:(ToDat'="")&&(FromDat>ToDat) "截止日期应该大于开始日期!"
	s Freq=$P(Parr,"^",9)
	s CusFreq=$P(Parr,"^",10)
	
	i id="" s a=##class(User.DHCNurPlanItemDetail).%New()
	e  s a=##class(User.DHCNurPlanItemDetail).%OpenId(id)
	
	i id="" s a.IDParRef=##class(User.DHCNurPlanItemMast).%OpenId(ItemMastID)

    s a.IDCode=Code
    s a.IDDesc=Desc
    s a.IDNote=Note
    s a.IDKeyWord=KeyWord
    s a.IDFreq=Freq
    s a.IDCustomFreq=CusFreq
    s a.IDDateFrom=FromDat
    s a.IDDateTo=ToDat
    
    d a.%Save()
    q a.%Id()
}

// w ##class(web.DHCNurPlanItemDetail).UpdateData("2||13^2^1^2^4^3^2015-01-02^2015-01-03")

ClassMethod UpdateData(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemDetail")=Parr
	s id=$p(Parr,"^")
	q:(id="") "请选择一条记录!"
	s ItemMastID=$P(Parr,"^",2)
	q:(ItemMastID="") "请选择归属的项目!"
	
	s Code=$P(Parr,"^",3)
	s Desc=$P(Parr,"^",4)
	s Note=$P(Parr,"^",5)
	s KeyWord=$P(Parr,"^",6)
	
	s FromDat=$P(Parr,"^",7)
	i FromDat["-" s FromDat=$$$zdh(FromDat,3)  //年-月-日
	i FromDat["/" s FromDat=$$$zdh(FromDat,1)  // 月/日/年
	s ToDat=$P(Parr,"^",8)
	i ToDat["-" s ToDat=$$$zdh(ToDat,3)
	i ToDat["/" s ToDat=$$$zdh(ToDat,1)
	
	q:(ToDat'="")&&(FromDat>ToDat) "截止日期应该大于开始日期!"
	
	s Freq=$P(Parr,"^",9)
	s CusFreq=$P(Parr,"^",10)
	
	s mastid=$p(id,"||")

    if (mastid=ItemMastID)
    {
	     
	     s a=##class(User.DHCNurPlanItemDetail).%OpenId(id)
	     s a.IDCode=Code
         s a.IDDesc=Desc
         s a.IDNote=Note
         s a.IDKeyWord=KeyWord
         s a.IDFreq=Freq
         s a.IDCustomFreq=CusFreq
         s a.IDDateFrom=FromDat
         s a.IDDateTo=ToDat
           
         d a.%Save()
         q a.%Id()
    }
    else
    {
	    
	    s c=##class(User.DHCNurPlanItemDetail).%DeleteId(id)
	    
	    s obj=##class(User.DHCNurPlanItemDetail).%New()
	    s obj.IDParRef=##class(User.DHCNurPlanItemMast).%OpenId(ItemMastID)
        s obj.IDCode=Code
        s obj.IDDesc=Desc
        s obj.IDNote=Note
        s obj.IDKeyWord=KeyWord
        s obj.IDFreq=Freq
        s obj.IDCustomFreq=CusFreq
        s obj.IDDateFrom=FromDat
        s obj.IDDateTo=ToDat
        
        d obj.%Save()
        q obj.%Id()
    }
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanItemDetail).%DeleteId(id)
	q 0
}

ClassMethod FindItemDetailExecute(ByRef qHandle As %Binary, Scode As %String = "", Sdesc As %String = "", ItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (ItemID'="")
 	{
 	  s id=""  f  s id=$o(^DHCNurPlan("Item",ItemID,"ItemDetail",id)) q:id=""  d
 	  .s adata=^DHCNurPlan("Item",ItemID,"ItemDetail",id)
 	  .s rw=ItemID_"||"_id
 	  .s mastdesc=$listget(^DHCNurPlan("Item",ItemID),3)
      .s code=$listget(adata,2)
      .q:(Scode'="")&(code'[Scode)
      .s desc=$listget(adata,3)
      .q:(Sdesc'="")&(desc'[Sdesc)
    
      .s keyword=$listget(adata,4)
      .s note=$listget(adata,5)
      .s fromdat=$listget(adata,6)
      .i fromdat'="" s fromdat=$$$zd(fromdat,3)
      .s todat=$listget(adata,7)
      .i todat'="" s todat=$$$zd(todat,3)
      .s freqid=$listget(adata,8)
      .s freq=""
      .i freqid'="" s freq=$P(^PHCFR(freqid),"^",3)
      .s cusfreq=$listget(adata,9)
 	  .Do OutputRow
 	}
 	else{
	  f  s ItemID=$o(^DHCNurPlan("Item",ItemID)) q:ItemID=""  d	
 	  .s id=""  f  s id=$o(^DHCNurPlan("Item",ItemID,"ItemDetail",id)) q:id=""  d
 	  ..s adata=^DHCNurPlan("Item",ItemID,"ItemDetail",id)
 	  ..s mastid=ItemID
 	  ..s rw=ItemID_"||"_id
      ..s mastdesc=$listget(^DHCNurPlan("Item",ItemID),3)
      ..s code=$listget(adata,2)
      ..q:(Scode'="")&(code'[Scode)
      ..s desc=$listget(adata,3)
      ..q:(Sdesc'="")&(desc'[Sdesc)
      ..s keyword=$listget(adata,4)
      ..s note=$listget(adata,5)
      ..s fromdat=$listget(adata,6)
      ..i fromdat'="" s fromdat=$$$zd(fromdat,3)
      ..s todat=$listget(adata,7)
      ..i todat'="" s todat=$$$zd(todat,3)
      ..s freqid=$listget(adata,8)
      ..s freq=""
      ..i freqid'="" s freq=$P(^PHCFR(freqid),"^",3)
      ..s cusfreq=$listget(adata,9)
 	  ..Do OutputRow
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rw,code,desc,mastdesc,note,keyword,fromdat,todat,mastid,freq,cusfreq,freqid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemDetailExecute ]
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

ClassMethod FindItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindItemDetail(Scode As %String, Sdesc As %String, ItemID As %String = "") As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,mastdesc:%String,note:%String,keyword:%String,fromdat:%String,todat:%String,mastid:%String,freq:%String,cusfreq:%String,freqid:%String")
{
}

}
