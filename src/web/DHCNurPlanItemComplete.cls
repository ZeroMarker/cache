Class web.DHCNurPlanItemComplete Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemComplete")=Parr
	s ItemMastID=$P(Parr,"^")
	s id=$p(Parr,"^",2)
	s Factor=$P(Parr,"^",3)
	s Arcim=$P(Parr,"^",4)

	s EmrCode=$P(Parr,"^",5)
	s ElementCode=$P(Parr,"^",6)
	s ConTyp=$P(Parr,"^",7)
	s ConTyp=$s(ConTyp="＝":"=",ConTyp="＞":">",ConTyp="＞＝":">=",ConTyp="＜":"<",ConTyp="＜＝":"<=",ConTyp="E":"E",1:"")
	
	s ConValue=$P(Parr,"^",8)
	s Function=$P(Parr,"^",9)
	s FuncPara=$P(Parr,"^",10)
	s FuncTyp=$P(Parr,"^",11)
	s FuncNote=$P(Parr,"^",12)

	s User=$P(Parr,"^",13)
	
	i id="" s a=##class(User.DHCNurPlanItemComplete).%New()
	e  s a=##class(User.DHCNurPlanItemComplete).%OpenId(id)
	
	i id="" s a.ICParRef=##class(User.DHCNurPlanItemMast).%OpenId(ItemMastID)

    s a.ICCompleteFactor=Factor
    s a.ICArcimID=Arcim
  
    s a.ICEmrCode=EmrCode
    s a.ICElementCode=ElementCode
    s a.ICConTyp=ConTyp
    s a.ICConValue=ConValue
    s a.ICFunction=Function
    s a.ICParameter=FuncPara
    s a.ICFuncType=FuncTyp
    s a.ICNote=FuncNote
   
    
    s a.ICUpdateDate=$p($h,",")
    s a.ICUpdateTime=$p($h,",",2)
    s a.ICUpdateUser=User
    
    
    d a.%Save()
    q a.%Id()
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanItemComplete).%DeleteId(id)
	q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCNurPlanItemTrigger","FindItemTrigger",17)

ClassMethod FindItemCompleteExecute(ByRef qHandle As %Binary, ItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (ItemID="") s qHandle=$lb(0,repid,0) q $$$OK
 	
 	s id=""  f  s id=$o(^DHCNurPlan("Item",ItemID,"ItemComplete",id)) q:id=""  d
 	.s adata=^DHCNurPlan("Item",ItemID,"ItemComplete",id)
 	.s rw=ItemID_"||"_id
 	.s factorId=$listget(adata,6)
    .i factorId'="" s factordesc=$listget(^DHCNurPlan("Factors",factorId),3)
    .s arcimId=$listget(adata,2)
    .s arcimDesc=""
    .i arcimId'="" d
    ..s arcimMainId=$p(arcimId,"||"),arcimSubId=$p(arcimId,"||",2)
    ..s arcimDesc=$p(^ARCIM(arcimMainId,arcimSubId,1),"^",2)
    ..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",arcimId,""))
    ..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
    ..s arcimDesc=AlisDesc_"-"_arcimDesc
   
   
    .s emrcode=$listget(adata,7)
    .s elementcode=$listget(adata,8)
    .s contyp=$listget(adata,9)
    .s contyp=$s(contyp="=":"＝",contyp=">":"＞",contyp=">=":"＞＝",contyp="<":"＜",contyp="<=":"＜＝",contyp="E":"E",1:"")
    .s convalue=$listget(adata,10)
    .s func=$listget(adata,11)
    .s funcpara=$listget(adata,12)
    .s functyp=$listget(adata,14)
    .s funcnote=$listget(adata,13)
  
    
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rw,$g(factordesc),$g(arcimDesc),emrcode,elementcode,contyp,convalue,func,funcpara,functyp,funcnote,factorId,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemCompleteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemCompleteExecute ]
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

ClassMethod FindItemCompleteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemCompleteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindItemComplete(ItemID As %String) As %Query(ROWSPEC = "id:%String,factordesc:%String,arcimDesc:%String,emrcode:%String,elementcode:%String,contyp:%String,convalue:%String,func:%String,funcpara:%String,functyp:%String,funcnote:%String,factorId:%String,arcimId:%String")
{
}

ClassMethod ifHave(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemComplete")=Parr
	s ItemMastID=$P(Parr,"^")
	s id=$p(Parr,"^",2)
	s Factor=$P(Parr,"^",3)
	s Arcim=$P(Parr,"^",4)

	s EmrCode=$P(Parr,"^",5)
	s ElementCode=$P(Parr,"^",6)
	s ConTyp=$P(Parr,"^",7)
	s ConTyp=$s(ConTyp="＝":"=",ConTyp="＞":">",ConTyp="＞＝":">=",ConTyp="＜":"<",ConTyp="＜＝":"<=",ConTyp="E":"E",1:"")
	
	s ConValue=$P(Parr,"^",8)
	s Function=$P(Parr,"^",9)
	s FuncPara=$P(Parr,"^",10)
	s FuncTyp=$P(Parr,"^",11)
	s FuncNote=$P(Parr,"^",12)

	s User=$P(Parr,"^",13)
	
	s bj00=0
	s Sub=""
	f  s Sub=$o(^DHCNurPlan("Item",ItemMastID,"ItemComplete",Sub)) q:Sub=""  d
	.s a=##class(User.DHCNurPlanItemComplete).%OpenId(ItemMastID_"||"_Sub)
	.s bj=1
    .s:a.ICCompleteFactor'=Factor bj=0
    .s:a.ICArcimID'=Arcim bj=0
    .s:a.ICEmrCode'=EmrCode bj=0
    .s:a.ICElementCode'=ElementCode bj=0
    .s:a.ICConTyp'=ConTyp bj=0
    .s:a.ICConValue'=ConValue bj=0
    .s:a.ICFunction'=Function bj=0
    .s:a.ICParameter'=FuncPara bj=0
    .s:a.ICFuncType'=FuncTyp bj=0
    .s:a.ICNote'=FuncNote bj=0
    .i bj=1  s bj00=1
    
    q bj00
}

}
