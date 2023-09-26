Import SQLUser

Class web.DHCPADelivery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取婴儿APGAR评分
/// 入参:婴儿分娩表ID
/// 返回值:成功(1min^5min^10min^自定义),失败(空或其他)
ClassMethod GetApgarScore(ID) As %String
{
	s (Apgar1,Apgar2,Apgar3,Apgar4)=""
	q:ID="" ""
	s PREGRowId=+ID,DELChildsub=$P(ID,"||",2),BABYChildsub=$P(ID,"||",3)
	Q:(PREGRowId="")||(DELChildsub="")||(BABYChildsub="") ""
	s apgarid="",flag1=0,flag2=0,flag3=0,flag4=0
	f  s apgarid=$O(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBAS",apgarid),-1) q:(apgarid="")||(apgarid="0")  d
	.s info=$g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBAS",apgarid))
	.q:info=""
	.s apgarNo=$p(info,"^",1)
	.s score1=+$p(info,"^",2)
	.s score2=+$p(info,"^",3)
	.s score3=+$p(info,"^",4)
	.s score4=+$p(info,"^",5)
	.s score5=+$p(info,"^",6)
	.s total=score1+score2+score3+score4+score5
	.i apgarNo=1,flag1=0 s Apgar1=total,flag1=1
	.i apgarNo=2,flag2=0 s Apgar2=total,flag2=1
	.i apgarNo=3,flag3=0 s Apgar3=total,flag3=1
	.i apgarNo=4,flag4=0 s Apgar4=total,flag4=1
	q Apgar1_"^"_Apgar2_"^"_Apgar3_"^"_Apgar4
}

ClassMethod SetGravida(papmi, Gravida, Para, DELID, Delstr, DelDrugItem, Indicators) As %String
{
	//##class(web.DHCPADelivery).SetGravida("129","1","1","","^^^^44^55^66^88^77^^^^出血,感染^1^176^内缝2/0可吸收缝合线,外缝^^","",""
	set ^TEMP("DHCPADelivery","SetGravida")=$lb(papmi, Gravida, Para, DELID, Delstr, DelDrugItem, Indicators)
	s err=0
	s papmi=+papmi
	q:papmi=0 100
	s Stage2FundalHeight=$p(Delstr,"^",1)
	s Stage3FundalHeight=$p(Delstr,"^",2)
	s CollBloodLoss=$p(Delstr,"^",3)
	s EstiBloodLoss=$p(Delstr,"^",4)
	s Del1HourPulse=$p(Delstr,"^",5)
	s Del1HourBPDiastolic=$p(Delstr,"^",6)
	s Del1HourBPSystolic=$p(Delstr,"^",7)
	s Del1HourFundus=$p(Delstr,"^",8)
	s Del1HourBloodLoss=$p(Delstr,"^",9)
	s DelCervix=$p(Delstr,"^",10)
	s DelNote=$p(Delstr,"^",11)
	s DELDiagnose=$p(Delstr,"^",12)
	s PuerperiumAttention=$p(Delstr,"^",13)
	s AnaDrugID=$p(Delstr,"^",14)
	s AnaMethodID=$p(Delstr,"^",15)
    s DELSuture=$p(Delstr,"^",16)
    s IndictDesc=$p(Delstr,"^",17)
    s DelOP=$p(Delstr,"^",18)
  
	&sql(update DHC_PA_PatMas set PAPMI_Gravida=:Gravida,PAPMI_Para=:Para where PAPMI_RowId=:papmi)
 
    s err=SQLCODE
    q:(SQLCODE'=0) SQLCODE
    q:DELID="" ""
     &sql(update DHC_PA_PregDelivery 
               set DEL_Stage2FundalHeight=:Stage2FundalHeight,DEL_Stage3FundalHeight=:Stage3FundalHeight,DEL_CollBloodLoss=:CollBloodLoss,DEL_EstiBloodLoss=:EstiBloodLoss,DEL_Del1HourPulse=:Del1HourPulse,
                   DEL_Del1HourBPDiastolic=:Del1HourBPDiastolic,DEL_Del1HourBPSystolic=:Del1HourBPSystolic,DEL_Del1HourFundus=:Del1HourFundus,DEL_Del1HourBloodLoss=:Del1HourBloodLoss, DEL_Cervix=:DelCervix,DEL_Note=:DelNote,DEL_Diagnose=:DELDiagnose,DEL_PuerperiumAttention=:PuerperiumAttention,DEL_SutureAncommonOrd_Dr=:AnaDrugID,DEL_AnaestMethod=:AnaMethodID,DEL_Suture=:DELSuture
                where DEL_RowId=:DELID)
    
    s pregDr=$p(DELID,"||",1)
    s delSub=$p(DELID,"||",2)     
   
    s:DelOP'="" $p(^PAPRG(pregDr,"DEL",4,delSub),"^",20)=DelOP
    &sql(delete from DHC_PA_PregDelDrug where DelDrug_Preg_Dr=:pregDr and DelDrug_Del_Sub=:delSub) 
    i DelDrugItem'="" d
    .s num=$l(DelDrugItem,"^")
    .f i=1:1:num d
    ..k PLIST
    ..s DrugID=$p(DelDrugItem,"^",i)
	..q:DrugID=""
   	..s PLIST(2)=pregDr
   	..s PLIST(3)=delSub
   	..s PLIST(5)=DrugID
   	..&sql(INSERT INTO sqluser.DHC_PA_PregDelDrug Values PLIST())      
    &sql(delete from DHC_PA_PregDelIndicator where Indict_Preg_Dr=:pregDr and Indict_Del_Sub=:delSub) 
    i Indicators'="" d
	.s num=$l(Indicators,"^")
    .f i=1:1:num d
    ..k PLIST
    ..s IndictID=$p(Indicators,"^",i)
	..q:IndictID=""
   	..s PLIST(2)=pregDr
   	..s PLIST(3)=delSub
   	..s PLIST(5)=IndictID
   	..&sql(INSERT INTO sqluser.DHC_PA_PregDelIndicator Values PLIST())      
	i IndictDesc'=""  d
	.k PLIST
	.s PLIST(2)=pregDr
   	.s PLIST(3)=delSub
   	.s PLIST(6)=IndictDesc
   	.&sql(INSERT INTO sqluser.DHC_PA_PregDelIndicator Values PLIST())      
	q err
}

ClassMethod setDdefaultApg(babyID) As %String
{

 q:babyID="" ""
 s pregRowid=$p(babyID,"||",1)
 s delsub=$p(babyID,"||",2)
 s babysub=$p(babyID,"||",3)
 s BABYOutcome=$p($g(^PAPRG(pregRowid,"DEL",delsub,"BABY",babysub)),"^",23)
 s BABYOutcome=+BABYOutcome
 s OutcomeCode=""
 i BABYOutcome'=0 s OutcomeCode=$p($g(^PAC("OPREG",BABYOutcome)),"^",1)
 q:OutcomeCode="D" ""
 s apg1m=$p($g(^PAPRG(pregRowid,"DEL",delsub,"BABY",babysub)),"^",6)
 i apg1m="" d
 .k PLIST
 .s PLIST(0)=babyID
 .s PLIST(3)=1
 .s PLIST(4)=2
 .s PLIST(5)=2
 .s PLIST(6)=2
 .s PLIST(7)=2
 .s PLIST(8)=2
 .&sql(insert into PA_PrDelBabyApgarScore values PLIST() )
 .&sql(update PA_PregDelBaby set BABY_ApgarScore1min_DR=10 Where BABY_RowID=:babyID) 
 s apg5m=$p($g(^PAPRG(pregRowid,"DEL",delsub,"BABY",babysub)),"^",8)
 i apg5m="" d
 .k PLIST
 .s PLIST(0)=babyID
 .s PLIST(3)=2
 .s PLIST(4)=2
 .s PLIST(5)=2
 .s PLIST(6)=2
 .s PLIST(7)=2
 .s PLIST(8)=2
 .&sql(insert into PA_PrDelBabyApgarScore values PLIST() )
 .&sql(update PA_PregDelBaby set BABY_ApgarScore5min_DR=10 Where BABY_RowID=:babyID) 
 s ApgarTime3=$p($g(^PAPRG(pregRowid,"DEL",delsub,"BABY",babysub)),"^",9)
 s Score3Dr=$p($g(^PAPRG(pregRowid,"DEL",delsub,"BABY",babysub)),"^",12)
 i (ApgarTime3="")&(Score3Dr="") d
 .k PLIST
 .s PLIST(0)=babyID
 .s PLIST(3)=3
 .s PLIST(4)=2
 .s PLIST(5)=2
 .s PLIST(6)=2
 .s PLIST(7)=2
 .s PLIST(8)=2
 .&sql(insert into PA_PrDelBabyApgarScore values PLIST() )
 .&sql(update PA_PregDelBaby set BABY_ApgarTime3=10,BABY_ApgarScore3_DR=10 Where BABY_RowID=:babyID)
 q 0
}

ClassMethod GetGravida3435(papmi, DELID) As %String
{
    ;^PAC("DLMTH",{DLMTH_RowId})
    s DLMTHRowId=0
    f  s DLMTHRowId=$o(^PAC("DLMTH",DLMTHRowId)) q:DLMTHRowId=""  d
}

Query GetOPType(type As %String = "") As %Query(ROWSPEC = "OPTypeDes:%String,rowid:%String")
{
}

ClassMethod GetOPTypeExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 
  	s type=$$UPPER^SSUTIL4(type)
    f  s rowid=$o(^PAC("DLMTH",rowid)) q:rowid=""  d
	.s OPTypeDes=$p($g(^PAC("DLMTH",rowid)),"^",2)
	.s OPTypeCode=$p($g(^PAC("DLMTH",rowid)),"^",1)
	.;q:(OPTypeDes'[type)
	.i (type'="")&($p(OPTypeCode,type,1)'="")&($p(OPTypeDes,type,1)'="") q
 	.Do OutputRow3	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(OPTypeDes,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOPTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPTypeExecute ]
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

ClassMethod GetOPTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetGravida(papmi, DELID) As %String
{
	set ^Temp("GetGravida")=papmi_","_DELID
	s rtl="^"
	s papmi=+papmi
    q:papmi=0 rtl
	s Gravida=$p($g(^PAPER(papmi,"DHC")),"^",3)
	s Para=$p($g(^PAPER(papmi,"DHC")),"^",4)
	s rtl=Gravida_"^"_Para
	q:($g(DELID)="") rtl
	s DelPregID=$p(DELID,"||",1)
	s EelChildsub=$p(DELID,"||",2)
	s AllItem=$g(^PAPRG(DelPregID,"DEL",EelChildsub,"DHC"))
	s Stage2HtID=$p($g(AllItem),"^",1)
	i Stage2HtID'="" s Stage2HtDesc=$p($g(^DHCProcC("FundalHeight",Stage2HtID)),"^",2)
	e  s Stage2HtDesc=""
	s Stage3HtID=$p($g(AllItem),"^",2)
	i Stage3HtID'="" s Stage3HtDesc=$p($g(^DHCProcC("FundalHeight",Stage3HtID)),"^",2)
	e  s Stage3HtDesc=""
	s CollBloodLoss=$p(AllItem,"^",3)
	s EstiBloodLoss=$p(AllItem,"^",4)
	s Del1HourPulse=$p(AllItem,"^",5)
	s Del1HourBPDiastolic=$p(AllItem,"^",6)
	s Del1HourBPSystolic=$p(AllItem,"^",7)
	s FundusID=$p($g(AllItem),"^",8)
	i FundusID'="" s FundusDesc=$p($g(^DHCProcC("FundalHeight",FundusID)),"^",2)
	e  s FundusDesc=""
    s:FundusDesc="" FundusDesc=FundusID
	s Del1HourBloodLoss=$p(AllItem,"^",9)
	s DelCervix=$p(AllItem,"^",13)
	s DelNote=$p(AllItem,"^",14)
	s DELDiagnose=$p(AllItem,"^",16)
	s PuerperiumAttention=$p(AllItem,"^",15)
	s anaDrugID=$p(AllItem,"^",19)
	i anaDrugID'="" s anaDrugDesc=$p($g(^DHCProcC("ANADRUG",anaDrugID)),"^",2) 
	e  s anaDrugDesc=""
	s anaMethodID=$p(AllItem,"^",18)
	i anaMethodID'="" s anaMethodDesc=$p(^ORC("ANMET",anaMethodID),"^",2)
	e  s anaMethodDesc=""
	s DELSuture=$p(AllItem,"^",17)
	;s DELBloodLoss=$p($g(^PAPRG(DelPregID,"DEL",EelChildsub)),"^",4)
	i (CollBloodLoss'="")&(EstiBloodLoss'="") d
	.s DELBloodLoss=CollBloodLoss+EstiBloodLoss
	e  s DELBloodLoss=""
	//手术
	
	s OPRowids=$p($g(^PAPRG(DelPregID,"DEL",4,EelChildsub)),"^",20)
	s OPLength=$l(OPRowids,"||")
	
	s OptypeStr=""
	f start = 1:1:OPLength  {
		s OProwid=$p(OPRowids,"||",start)
		
		s:(OProwid'="") OPTypeDes=$p($g(^ORC("OPER",OProwid)),"^",2)
		s:(OProwid'="") OptypeStr=OptypeStr_"||"_OProwid_"$"_OPTypeDes
		if (OProwid=""){
			s (OPTypeDes,OPTypeDes)=""
		}
		
	}
    s rtl=rtl_"^"_$g(Stage2HtDesc)_" "_$g(Stage2HtID)_"^"_$g(Stage3HtDesc)_" "_$g(Stage3HtID)_"^"_$g(CollBloodLoss)_"^"_$g(EstiBloodLoss)_"^"_$g(DELBloodLoss)_"^"_Del1HourPulse_"^"_Del1HourBPDiastolic_"^"_Del1HourBPSystolic_"^"_FundusDesc_" "_FundusID_"^"_Del1HourBloodLoss_"^"_DelCervix_"^"_DelNote_"^"_DELDiagnose_"^"_PuerperiumAttention_"^"_anaDrugDesc_" "_anaDrugID_"^"_anaMethodDesc_" "_anaMethodID_"^"_DELSuture
    s rtl=rtl_"^"_OptypeStr
	q rtl
}

Query GetIndict(type As %String = "") As %Query(ROWSPEC = "IndictDes:%String,rowid:%String")
{
}

ClassMethod GetIndictExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	f  s rowid=$o(^DHCProcC("Indicator",rowid)) q:rowid=""  d
	.s IndictDes=$p(^DHCProcC("Indicator",rowid),"^",2)
	.;s IndictCode=$p(^DHCProcC("Indicator",rowid),"^",1)
	.;q:(OPTypeDes'[type)
 	.Do OutputRow33	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow33
	set Data=$lb(IndictDes,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetIndictFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIndictExecute ]
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

ClassMethod GetIndictClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIndictExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDelDrugList(DELId As %String)
{
 q:DELId="" ""
 s rtl=""
 s pregDr=$p(DELId,"||",1)
 s delSub=$p(DELId,"||",2)
 s DelDrugchild=0
 f  s DelDrugchild=$o(^PAPRG(pregDr,"DEL",delSub,"DELDRUG",DelDrugchild)) q:DelDrugchild=""  d
 .s drugDr=$p($g(^PAPRG(pregDr,"DEL",delSub,"DELDRUG",DelDrugchild)),"^",1)
 .s drugDr=+drugDr
 .s drugdesc=$p($g(^DHCProcC("DRUG",drugDr)),"^",2)
 .s rtl=rtl_"^"_$g(drugDr)_"$"_$g(drugdesc)
 q rtl
}

ClassMethod GetIndictList(DELId As %String)
{
 q:DELId="" ""
 s rtl=""
 s Indicttext=""
 s pregDr=$p(DELId,"||",1)
 s delSub=$p(DELId,"||",2)
 s Indictchild=0
 f  s Indictchild=$o(^PAPRG(pregDr,"DEL",delSub,"INDICT",Indictchild)) q:Indictchild=""  d
 .s IndictID=$p($g(^PAPRG(pregDr,"DEL",delSub,"INDICT",Indictchild)),"^",1)
 .s IndictID=+IndictID
 .i IndictID'=0 d
 ..s Indictesc=$p($g(^DHCProcC("Indicator",IndictID)),"^",2)
 ..s rtl=rtl_"^"_$g(IndictID)_"$"_$g(Indictesc)
 .e  d
 ..s Indicttext=$p($g(^PAPRG(pregDr,"DEL",delSub,"INDICT",Indictchild)),"^",2)
 s rtl=Indicttext_"&"_rtl
 q rtl
}

ClassMethod GetCTPCPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTPCPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCTPCPExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s sub=0 f  s sub=$o(^CTPCP(sub)) q:(sub="")  d
    .;s desc=$p(^CTPCP(sub,1),"^",2)
    .;q:((desc'[code)&(code'=""))
    .s desc=$p(^CTPCP(sub,1),"^",2)
	 .s usercaption=$p($g(^CTPCP(sub,3)),"^",12)  
	 .s tmpusername=usercaption_desc           
	 .q:(tmpusername'[code)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCTPCPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTPCPExecute ]
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

Query GetCTPCP(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod SetDHCBABYDel(delID, DHCBABYDelDoc, DHCBABYDelMidwife) As %String
{
	s err=0
	s delID=delID
	s PregId=+delID
	s delChild=$p(delID,"||",2)
	s childNum=0
	s BABYChildsub=""
	s BABYChildsub=$o(^PAPRG(PregId,"DEL",delChild,"BABY",BABYChildsub)) q:BABYChildsub="" d
    .q:BABYChildsub=""
    .s childNum=childNum+2
    i childNum=0 s childNum=2
	s BABYID=delID_"||"_childNum
	s DHCBABYID=""
	s DHCBABYID=$o(^DHCPAPRG(0,"DHCBABY",BABYID,DHCBABYID))
	;&sql(insert into DHC_PA_PregDelBaby (DHCBABY_DeliveryDoctor_DR,DHCBABY_DeliveryMidwife_DR, DHCBABY_BABY_DR) Values(:DHCBABYDelDoc,:DHCBABYDelMidwife,:BABYID))
	
	;s err=SQLCODE
    q err
}

Query GetLookUpDrug() As %Query(ROWSPEC = "rowid:%String,DrugDes:%String")
{
}

ClassMethod GetLookUpDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLookUpDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLookUpDrugExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	f  s rowid=$o(^DHCProcC("DRUG",rowid)) q:rowid=""  d
	.s DrugDes=$p(^DHCProcC("DRUG",rowid),"^",2)
 	.Do OutputRow3	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(rowid,DrugDes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLookUpDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLookUpDrugExecute ]
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

Query AnaestAgent() As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

ClassMethod AnaestAgentExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s rowid=0
 f  s rowid=$o(^ORC("ANMET",rowid)) q:rowid=""  d
 .s ID=rowid  //$p(^ORC("ANMET",rowid),"^",1)
 .s Des=$p(^ORC("ANMET",rowid),"^",2)
 .Do OutputRow7	 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutputRow7
 set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod AnaestAgentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnaestAgentExecute ]
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

ClassMethod AnaestAgentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnaestAgentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GetAnaDrug() As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

ClassMethod GetAnaDrugExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s rowid=0
 f  s rowid=$o(^DHCProcC("ANADRUG",rowid)) q:rowid=""  d
 .s ID=rowid  
 .s Des=$p($g(^DHCProcC("ANADRUG",rowid)),"^",2)
 .Do OutputRow6	 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutputRow6
 set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAnaDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnaDrugExecute ]
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

ClassMethod GetAnaDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnaDrugExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GetFundus() As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

ClassMethod GetFundusExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s rowid=0
 f  s rowid=$o(^DHCProcC("FundalHeight",rowid)) q:rowid=""  d
 .s ID=rowid  
 .s Des=$p($g(^DHCProcC("FundalHeight",rowid)),"^",2)
 .Do OutputRow6	 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutputRow6
 set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetFundusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFundusExecute ]
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

ClassMethod GetFundusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFundusExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GetANAOPType(type As %String) As %Query(ROWSPEC = "OPTypeDes:%String,rowid:%String")
{
}

ClassMethod GetANAOPTypeExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	//^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
    if (type'="")
    {
	s type=$$ALPHAUP^SSUTIL4(type) //$ZCONVERT(type,"U")  ypz 070313
	s flag="N"
	s OpDes=$O(^ORC("OPER",0,"ALIAS",type),-1)  //ypz 070313 open
	//s OpDes=type //ypz 070313 rem
    if type'="" d
    	.f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
    		..i $p(OpDes,type)'="" s flag="Y" q
    		..s operId=""
    		..f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
    			...s rowid0=operId
    			...s OPTypeDes=$p(^ORC("OPER",operId),"^",2)
    			...s i=i+1
    			...Do OutputRow45
    }
    if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
  	s type=$$UPPER^SSUTIL4(type)
	f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
	.s OPTypeDes=$p(^ORC("OPER",rowid),"^",2)
	.q:OPTypeDes'[type
	.s rowid0=rowid
 	.Do OutputRow45	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow45
	set Data=$lb(OPTypeDes,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetANAOPTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANAOPTypeExecute ]
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

ClassMethod GetANAOPTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANAOPTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CtCpt(ctcptdes As %String, adm As %String) As %Query(ROWSPEC = "username,rowid")
{
}

ClassMethod CtCptExecute(ByRef qHandle As %Binary, ctcptdes As %String, adm As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ctloc=$p($g(^PAADM(adm)),"^",4)
 If $g(ind)="" Set ind=1
	 s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",ctloc,rw))  q:rw=""  d
	 .s rowid=$P(^RB("RES",rw),"^",2)
	 .q:rowid=""
	 .s username=$p(^CTPCP(rowid,1),"^",2)
	 .s usercaption=$p($g(^CTPCP(rowid,3)),"^",12)  //ljw20090212
	 .q:(usercaption'[ctcptdes)&(ctcptdes'="")   //ljw20090212
	 .s ucn=$e($g(usercaption),1)  //ljw20090212
	 .s cct=$e($g(ctcptdes),1)  //ljw20090212
	 .q:(ucn'=cct)&(ctcptdes'="")  //ljw20090212
     .Do Outputcpt	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Outputcpt
	set Data=$lb(username,rowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod CtCptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CtCptExecute ]
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

ClassMethod CtCptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CtCptExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 分娩删除,床位上删除婴儿信息
ClassMethod DeletePregDelivery(DELId As %String)
{
	//w ##class(web.DHCPADelivery).DeletePregDelivery("6||7")
	s err=0
	q:DELId="" 0
	s PregId=+DELId
	s delChild=$p(DELId,"||",2)
	q:(PregId="")!(delChild="") 0
	s MotherAdmId=$p($g(^PAPRG(PregId,"DEL",delChild)),"^",1)
	q:MotherAdmId="" 0
	s MotherWardId=$p($g(^PAADM(MotherAdmId)),"^",70)
	q:MotherWardId="" 0
		
	s babyAdmId=0
	f  s babyAdmId=$o(^PAADMi("Mother",MotherAdmId,babyAdmId)) q:(babyAdmId="")!(err'=0)  d
	.s babyWARDRowId=MotherWardId
	.s babyBEDSub=0
	.f  s babyBEDSub=$O(^PAWARDA(0,"ADM",babyAdmId,babyWARDRowId,babyBEDSub)) q:(babyBEDSub="")!(err'=0)  d
	..s babyADMSub=$O(^PAWARDA(0,"ADM",babyAdmId,babyWARDRowId,babyBEDSub,""))
	..q:babyADMSub=""
	..s babyBedAdmId=babyWARDRowId_"||"_babyBEDSub_"||"_babyADMSub
	..&sql(delete from PAC_BedAdm where ADM_RowId=:babyBedAdmId)
	..i SQLCODE'=0 s err="删除婴儿床位信息出错!" q
	..s $p(^PAWARD(babyWARDRowId,"BED",babyBEDSub),"^",4)="N"
	..s babyVisitStat=$p($g(^PAADM(babyAdmId)),"^",20)
    ..q:babyVisitStat'="A"
	..&sql(update PA_Adm set PAADM_VisitStatus='C' where PAADM_RowID=:babyAdmId)
	..i SQLCODE'=0 s err="删除婴儿就诊信息出错!" q
	q err
}

/// 获取分娩记录ID
/// ##class(web.DHCPADelivery).getDelID()
ClassMethod getDelID(EpisodeID)
{
	s ret=""
	&sql(SELECT DEL_RowId into:ret FROM PA_PregDelivery WHERE DEL_Adm_DR=:EpisodeID)
	i SQLCODE'=0 s ret="未找到分娩记录"
	q ret
}

}
