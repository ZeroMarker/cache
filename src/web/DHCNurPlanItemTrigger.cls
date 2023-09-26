Class web.DHCNurPlanItemTrigger Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemTrigger")=Parr
	s ItemMastID=$P(Parr,"^")
	s id=$p(Parr,"^",2)
	s Factor=$P(Parr,"^",3)
	s Arcim=$P(Parr,"^",4)
	s Event=$P(Parr,"^",5)
	s Diag=$P(Parr,"^",6)
	s EmrCode=$P(Parr,"^",7)
	s ElementCode=$P(Parr,"^",8)
	s ConTyp=$P(Parr,"^",9)
	s ConTyp=$s(ConTyp="＝":"=",ConTyp="＞":">",ConTyp="＞＝":">=",ConTyp="＜":"<",ConTyp="＜＝":"<=",ConTyp="E":"E",1:"")
	
	s ConValue=$P(Parr,"^",10)
	s Function=$P(Parr,"^",11)
	s FuncPara=$P(Parr,"^",12)
	s FuncTyp=$P(Parr,"^",13)
	s FuncNote=$P(Parr,"^",14)
	s Freq=$P(Parr,"^",15)
	s CusFreq=$P(Parr,"^",16)
	s User=$P(Parr,"^",17)
	
	i id="" s a=##class(User.DHCNurPlanItemTrigger).%New()
	e  s a=##class(User.DHCNurPlanItemTrigger).%OpenId(id)
	
	i id="" s a.ITParRef=##class(User.DHCNurPlanItemMast).%OpenId(ItemMastID)

    s a.ITTriggerFactor=Factor
    s a.ITArcimID=Arcim
    s a.ITEventID=Event
    s a.ITDiagID=Diag
    s a.ITEmrCode=EmrCode
    s a.ITElementCode=ElementCode
    s a.ITConTyp=ConTyp
    s a.ITConValue=ConValue
    s a.ITFunction=Function
    s a.ITParameter=FuncPara
    s a.ITFuncType=FuncTyp
    s a.ITNote=FuncNote
    s a.ITFreq=Freq
    s a.ITCustomFreq=CusFreq
    
    s a.ITUpdateDate=$p($h,",")
    s a.ITUpdateTime=$p($h,",",2)
    s a.ITUpdateUser=User
    
    
    d a.%Save()
    q a.%Id()
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanItemTrigger).%DeleteId(id)
	s a=..DeleteRecTriggerData(id)
	q 0
}

ClassMethod DeleteRecTriggerData(id As %String) As %String
{
	q:id="" 0
	s par="" f  s par=$O(^DHCNurPlani("RecTrigger",0,"ItemTrigger"," "_id,par)) q:par=""  d
	.s sub="" f  s sub=$O(^DHCNurPlani("RecTrigger",0,"ItemTrigger"," "_id,par,sub)) q:sub=""  d
	..s a=##class(User.DHCNurPlanRecTriggerSub).%DeleteId(par_"||"_sub)
	q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCNurPlanItemTrigger","FindItemTrigger",17)

ClassMethod FindItemTriggerExecute(ByRef qHandle As %Binary, ItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (ItemID="") s qHandle=$lb(0,repid,0) q $$$OK
 	
 	s id=""  f  s id=$o(^DHCNurPlan("Item",ItemID,"ItemTrigger",id)) q:id=""  d
 	.s adata=^DHCNurPlan("Item",ItemID,"ItemTrigger",id)
 	.s rw=ItemID_"||"_id
    .s arcimId=$listget(adata,2)
    .s arcimDesc=""
    .i arcimId'="" d
    ..s arcimMainId=$p(arcimId,"||"),arcimSubId=$p(arcimId,"||",2)
    ..s arcimDesc=$p(^ARCIM(arcimMainId,arcimSubId,1),"^",2)
    ..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",arcimId,""))
    ..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
    ..s arcimDesc=AlisDesc_"-"_arcimDesc
    .s eventId=$listget(adata,3)
    .i eventId'="" s eventdesc=$listget(^DHCNurPlan("Event",eventId),3)
    .s diagId=$listget(adata,4)
    .i diagId'="" s diagdesc=$P(^MRC("ID",diagId),"^",2)
    .s factorId=$listget(adata,5)
    .i factorId'="" s factordesc=$listget(^DHCNurPlan("Factors",factorId),3)
    .s emrcode=$listget(adata,6)
    .s elementcode=$listget(adata,7)
    .s contyp=$listget(adata,8)
    .s contyp=$s(contyp="=":"＝",contyp=">":"＞",contyp=">=":"＞＝",contyp="<":"＜",contyp="<=":"＜＝",contyp="E":"E",1:"")
    .s convalue=$listget(adata,9)
    .s func=$listget(adata,10)
    .s funcpara=$listget(adata,11)
    .s functyp=$listget(adata,16)
    .s funcnote=$listget(adata,12)
    .s freqid=$listget(adata,17)
    .s freq=""
    .i freqid'="" s freq=$P(^PHCFR(freqid),"^",3)
    .s cusfreq=$listget(adata,18)
    
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rw,$g(factordesc),$g(arcimDesc),$g(eventdesc),$g(diagdesc),emrcode,elementcode,contyp,convalue,func,funcpara,functyp,funcnote,freq,cusfreq,factorId,arcimId,eventId,diagId,freqid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemTriggerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemTriggerExecute ]
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

ClassMethod FindItemTriggerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemTriggerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindItemTrigger(ItemID As %String) As %Query(ROWSPEC = "id:%String,factordesc:%String,arcimDesc:%String,eventdesc:%String,diagdesc:%String,emrcode:%String,elementcode:%String,contyp:%String,convalue:%String,func:%String,funcpara:%String,functyp:%String,funcnote:%String,freq:%String,cusfreq:%String,factorId:%String,arcimId:%String,eventId:%String,diagId:%String,freqid:%String")
{
}

ClassMethod ifHave(Parr As %String) As %String
{
	s ^pstmp("DHCNurPlanItemTrigger")=Parr
	s ItemMastID=$P(Parr,"^")
	s id=$p(Parr,"^",2)
	s Factor=$P(Parr,"^",3)
	s Arcim=$P(Parr,"^",4)
	s Event=$P(Parr,"^",5)
	s Diag=$P(Parr,"^",6)
	s EmrCode=$P(Parr,"^",7)
	s ElementCode=$P(Parr,"^",8)
	s ConTyp=$P(Parr,"^",9)
	s ConTyp=$s(ConTyp="＝":"=",ConTyp="＞":">",ConTyp="＞＝":">=",ConTyp="＜":"<",ConTyp="＜＝":"<=",ConTyp="E":"E",1:"")
	
	s ConValue=$P(Parr,"^",10)
	s Function=$P(Parr,"^",11)
	s FuncPara=$P(Parr,"^",12)
	s FuncTyp=$P(Parr,"^",13)
	s FuncNote=$P(Parr,"^",14)
	s Freq=$P(Parr,"^",15)
	s CusFreq=$P(Parr,"^",16)
	s User=$P(Parr,"^",17)
	s bj00=0
	s Sub=""
	f  s Sub=$o(^DHCNurPlan("Item",ItemMastID,"ItemTrigger",Sub)) q:Sub=""  d
	.s a=##class(User.DHCNurPlanItemTrigger).%OpenId(ItemMastID_"||"_Sub)
	.s bj=1
    .s:a.ITTriggerFactor'=Factor bj=0
    .s:a.ITArcimID'=Arcim bj=0
    .s:a.ITEventID'=Event bj=0
    .s:a.ITDiagID'=Diag bj=0
    .s:a.ITEmrCode'=EmrCode bj=0
    .s:a.ITElementCode'=ElementCode bj=0
    .s:a.ITConTyp'=ConTyp bj=0
    .s:a.ITConValue'=ConValue bj=0
    .s:a.ITFunction'=Function bj=0
    .s:a.ITParameter'=FuncPara bj=0
    .s:a.ITFuncType'=FuncTyp bj=0
    .s:a.ITFreq'=Freq bj=0
    .s:a.ITCustomFreq'=CusFreq bj=0
    .i bj=1  s bj00=1
    
    q bj00
}

}
