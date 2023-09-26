Include webimport

IncludeGenerator webimport

/// 药房基数药品生成补给单与补打
/// 适用dthealth V7.0 和之前的版本
/// 适用门诊药房、住院药房
/// Creator:LiangQiang
Class web.DHCSTPHSUPPLY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DispListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	//实现；
	//PamStr="登记号^长嘱标志^临嘱标志    lq 
	q:$g(displocrowid)="" $$$OK
	q:$g(StartDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	
	s tmp=$$GetColl(StartDate,EndDate,displocrowid,wardrowid,Userid,dispcatvalue,StartTime,EndTime,DoctorLocRowid,DispNo,PamStr)
	s cnt=$p(tmp,"^",1)
	s pid=$p(tmp,"^",2)
	s i=1
	//w !,"共有"_pid_"张发药单"
	f i=1:1:cnt   d
	. s dispm=^TMP("dhcpha",pid,"DISPMQ",i)
	. q:dispm=""
	. d OutputRow1
	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s coll=$p(dispm,"&",1)
	s collward=$p(dispm,"&",2)
	i $f(collward,"-") s collward=$p(collward,"-",2)
	s colltype=$p(dispm,"&",3)
	s colldatescope=$p(dispm,"&",4)
	s collstatus=$p(dispm,"&",5)
	s collcount=$p(dispm,"&",6)
	s collpdate=$p(dispm,"&",7)
	s collptime=$p(dispm,"&",8)
	s collcdate=$p(dispm,"&",9)
	s collctime=$p(dispm,"&",10)
	s colluser=$p(dispm,"&",11)
	s collcuser=$p(dispm,"&",12)
	s colldispno=$p(dispm,"&",13)
	s collsendautoflag=$p(dispm,"&",14)
	
	s Data=$lb(coll,collward,colltype,colldatescope,collstatus,collpdate,collptime,collcdate,collctime,colluser,collcuser,colldispno,collsendautoflag,pid)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetColl(datef,datet,pha,ward,user,type,StartTime,EndTime,DoctorLocRowid,dispno,pamstr)
	q:datef="" ""
	q:datet="" ""
	q:pha="" ""
 	i $g(StartTime)="" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical("00:00:00")
 	i $g(EndTime)="" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical("23:59:59")
 	;
	s ward=$g(ward),user=$g(user),type=$g(type)  
	s num=0
    s dispflag=$p(pamstr,"^",1)
    ;
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()  ;
	f date=datef:1:datet d
	.s coll="" f  s coll=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,coll)) q:coll=""  d            ;
	..s collward=$p(^DHCPHAC(coll),"^",4)
	..s colluser=$p(^DHCPHAC(coll),"^",5)
	..s colltype=$p(^DHCPHAC(coll),"^",12)
	..s colldate=$p(^DHCPHAC(coll),"^",2)
	..s colltime=$p(^DHCPHAC(coll),"^",3)
	..i colldate=datef q:(colltime<StartTime)
	..i colldate=datet q:(colltime>EndTime)
	..s stkflag=$p(^DHCPHAC(coll),"^",20) 
	..q:stkflag'=1
	..
	..s tmpdocloc=##class(web.DHCSTPCHCOLLS).DocLoc(coll) ;20070404
	..q:(##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(pha,tmpdocloc)=1)
	..i ward'="" q:collward'=ward
	..
	..q:(dispflag=1)&(..IfDisped(coll)=1)
	..q:(dispflag=0)&(..IfDisped(coll)=0)
	..i type'="" q:colltype'=type
	..s user1="" //2007-10-26
	..i user'="" s user1=$o(^SSU("SSUSR",0,"SSUSR_Initials",user,user1)) //2007-10-26 根据科室与人员对应表找人员userid
	..i user1'="" q:colluser'=user1 //2007-10-26
	..;i user'="" q:colluser'=user //2007-10-26注释以前从安全组找人员
	..
	..i collward'="" s collward=$p(^PAWARD(collward),"^",2)       
	..i colluser'="" s colluser=$p(^SSU("SSUSR",colluser),"^",2)
	..i colltype'="" s colltype=##class(web.DHCSTPCHCOLLS).DispCatDesc(colltype)
	..i collward="" d
	...&sql(select ctloc_desc into :tmpdoclocdesc from ct_loc where ctloc_rowid=:tmpdocloc)
	...s collward=$g(tmpdoclocdesc)
	..s collpdate=$p(^DHCPHAC(coll),"^",7) i collpdate'="" s collpdate=$ZD(collpdate,3)
	..s collptime=$p(^DHCPHAC(coll),"^",8) i collptime'="" s collptime=$ZT(collptime)
	..s collcdate=$p(^DHCPHAC(coll),"^",2) i collcdate'="" s collcdate=$ZD(collcdate,3)
	..s collctime=$p(^DHCPHAC(coll),"^",3) i collctime'="" s collctime=$ZT(collctime)
	..s collcount=$p(^DHCPHAC(coll),"^",9)
	..s collcuser=$p(^DHCPHAC(coll),"^",13) i collcuser'="" s collcuser=$p(^SSU("SSUSR",collcuser),"^",2)
	..s collstatus=$p(^DHCPHAC(coll),"^",6)
	..s colldatef=$ZD($p(^DHCPHAC(coll),"^",10))
	..s colldatet=$ZD($p(^DHCPHAC(coll),"^",11))
	..s colldispno=$p(^DHCPHAC(coll),"^",14)
	..s collsendautoflag=$p(^DHCPHAC(coll),"^",15)
	..q:(dispno'="")&(colldispno'=dispno)
	..s collprintflag=$p(^DHCPHAC(coll),"^",16)
	..s num=num+1
	..
	..s ^TMP("dhcpha",pid,"DISPMQ",num)=coll_"&"_collward_"&"_colltype_"&"_colldatef_"-"_colldatet_"&"_collstatus_"&"_collcount_"&"_collpdate_"&"_collptime_"&"_collcdate_"&"_collctime_"&"_colluser_"&"_collcuser_"&"_$g(colldispno)_"&"_collsendautoflag_"&"_collprintflag
	
	q num_"^"_pid

ResetVariables1
	q
}

Query DispList(StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Query(ROWSPEC = "Tcoll:%String,TWard:%String,TDispCat:%String,TDateScope:%String,TStatus:%String,TPrintDate:%String,TPrintTime:%String,TCollectDate:%String,TCollectTime:%String,TOperUser:%String,TCollectUser:%String,TDispNo:%String,TSendAutoFlag:%String,Tpid:%String")
{
}

ClassMethod DispListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DispTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispTotalExecute(ByRef qHandle As %Binary, pid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:pid="" $$$OK
	d ResetVariablesGetDispTotal
	
	s amttotal=0
    s num=$o(^TMP("dhcpha",pid,"DISPMQ",""),-1)
    q:num'>0 $$$OK
    s h=0
    k ^TMP("dhcpha",pid,"DSYDISPTOTAL")
    f i=1:1:num d
    .s str=^TMP("dhcpha",pid,"DISPMQ",i)
    .s coll=$p(str,"&",1)
	.s cnt=..GetDispTotal(coll,pid)
	.i cnt>0 s h=h+1
	.
	q:h=0 $$$OK

	s inci="" 
	f  s inci=$o(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci)) q:inci=""  d
	.s dispinfo=^TMP("dhcpha",pid,"DSYDISPTOTAL",inci)
	.d OutputRowsDisp
	d outputtotalDispTotal
	
	Quit $$$OK
	
OutputRowsDisp
    s Tincicode=$p(dispinfo,"^",4)
    s Tincidesc=$p(dispinfo,"^",5)
	s Tqty=$p(dispinfo,"^",2)
	s Tinciamt=$p(dispinfo,"^",3)
	s Tgenedesc=$p(dispinfo,"^",6)
	i $f(Tgenedesc,"-") s Tgenedesc=$p(Tgenedesc,"-",2)
	s Tphcform=$p(dispinfo,"^",7)
	s Tspec=$p(dispinfo,"^",8)
	s Tmanf=$p(dispinfo,"^",9)
	i $f(Tmanf,"-") s Tmanf=$p(Tmanf,"-",2)
	s Tuom=$p(dispinfo,"^",10)
	s Tprice=$p(dispinfo,"^",11)
	s amttotal=amttotal+Tinciamt
	
	s Tinciamt=$fn(Tinciamt,"",2)
	s amttotal=$fn(amttotal,"",2)
 
	s Data=$lb(Tincicode,Tincidesc,Tqty,Tinciamt,Tgenedesc,Tphcform,Tspec,Tmanf,Tuom,Tprice)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

outputtotalDispTotal
	s Data=$lb("","总计","",amttotal)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
	
ResetVariablesGetDispTotal
	s (Tqty,Tinciamt,Tincicode,Tincidesc,Tgenedesc,Tphcform,Tspec,Tmanf,Tuom,Tprice)=""
	q
}

ClassMethod DispTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DispTotal(pid As %String) As %Query(ROWSPEC = "Tincicode:%String,Tincidesc:%String,Tqty:%String,Tinciamt:%String,Tgenedesc:%String,Tphcform:%String,Tspec:%String,Tmanf:%String,Tuom:%String,Tprice:%String")
{
}

/// 发药单药品汇总
ClassMethod GetDispTotal(phacdr, pid) As %String
{
	 n (phacdr,pid)
	
	 s regno="",longord="",shortord=""
	 i '$d(^DHCPHAC(phacdr)) q 0
	 s i=0
	 s phaci="" 
	 f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	 .s phcirowid=phacdr_"||"_phaci
	 .q:$d(^DHCINTR(0,"TypePointer","P",phcirowid))  ///不能重复减库
	 .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
	 .s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
	 .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
	 .q:oedis=""
	 .s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)
	 .s price=$p(^DHCPHAC(phacdr,"I",phaci),"^",9)    
	 .s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
	 .s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
	 .s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
	 .s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
	 .s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
	 .s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
	 .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家
	 .s CTUOMDR=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
	 .s UOMDesc=$p(^CT("UOM",CTUOMDR),"^",2) 						//单位
	 .s diagnose=""
	 .i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
	 .s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
	 .s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
	 .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
	 .s chl=$p(oedis,"||",2) 
	 .s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
	 .s doctorloc=$p(^CTLOC(doctorlocdr),"^",2) 
	 .i '$d(^OEORD(ord,"I",chl)) q 
	 .s DocTor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)  
	 .s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
	 .&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
	 .i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)  
	 .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
	 .s patnameid=$p(^PAADM(adm),"^",1)    ;PA_PatMas PAPMI_RowId
	 .s patid=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
	 .s patno=$p(^PAPER(patnameid,"PAT",1),"^",1) 
	 .q:(regno'="")&(regno'=patno)                  //过滤登记号条件
	 .s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1) 
	 .q:priority="OUT"
	 .s sexid =$p( ^PAPER(patnameid,"ALL"),"^",7)   
	 .s sex =$p(^CT("SEX",sexid),"^",2 )            //性别
	 .s PADob=$p( ^PAPER(patnameid,"ALL"),"^",6)
	 .s Paold=""
	 .i PADob'="" s Paold=$fn((+$h-PADob)/365,"",0) //年龄
	 .s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;//2007-10-26 皮试结果
	 .s code="In Patient"                                  
	 .&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
	 .s admdate=$zd(admdate,3) 
	 .s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
	 .s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	 .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
	 .s j=deploc_"||"_bed_"||"_arcim        
	 .s incicode=$p(^INCI(inci,1),"^",1)
	 .s incidesc=$p(^INCI(inci,1),"^",2)
	 .s inciamt=price*qty
	 .s i=i+1
	 .s info=inci_"^"_qty_"^"_inciamt_"^"_incicode_"^"_incidesc_"^"_genedesc_"^"_phcform_"^"_Specifaction_"^"_manf_"^"_UOMDesc_"^"_price
	 .i '$d(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci)) d
	 ..s ^TMP("dhcpha",pid,"DSYDISPTOTAL",inci)=info
	 .e  d
	 ..s $p(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci),"^",2)=$p(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci),"^",2)+qty
	 ..s $p(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci),"^",3)=$p(^TMP("dhcpha",pid,"DSYDISPTOTAL",inci),"^",3)+inciamt
	 q i
}

ClassMethod KillDISPMQ(pid) As %String
{
  n (pid)
  k ^TMP("dhcpha",pid)
  k ^TMP("dhcpha","SUPP","ITM",pid)
  q
}

/// 集中处理N个发药单药品库存
ClassMethod SAVEDATA(pid, user = "") As %String
{
	n (pid,user)
	i $g(user)="" s user=1
	s num=$o(^TMP("dhcpha",pid,"DISPMQ",""),-1)
    q:+num'>0 0
    s success=0
    s phacStr=""
    s ret=0
    s supp=""
    
    f i=1:1:num d
    .s str=^TMP("dhcpha",pid,"DISPMQ",i)
    .s phacdr=$p(str,"&",1)
    .s recloc=$p(^DHCPHAC(phacdr),"^",1)
    .s warddr=$p(^DHCPHAC(phacdr),"^",4)
    .&sql(UPDATE DHC_PHACollected SET DHC_PHACollectUser=:user WHERE DHC_PHACollect_RowID=:phacdr)   //yunhaibao,输液确认发药后更改发药人
    .s success=0
    .s phaci=""
	.f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	..s phcirowid=phacdr_"||"_phaci
	..s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
	..s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
	..s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
	..s confqty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)
	..s price=$p(^DHCPHAC(phacdr,"I",phaci),"^",9)    
	..s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
	..s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
	..
	..q:$d(^DHCINTR(0,"TypePointer","P",phcirowid))  ///不能重复减库
	..s pidnum=##class(web.DHCSTPCHCOLLS).GetInclbCounter(recloc,inci)
    ..i pidnum<0 d Unlock
    ..i $d(^DHCINTR(0,"TypePointer","P",phcirowid)) d Unlock
    ..q:$d(^DHCINTR(0,"TypePointer","P",phcirowid))
    ..s cnt=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,confqty,recloc,pidnum)
    ..
    ..i cnt'>0 d Unlock
    ..q:cnt'>0
    ..tstart
    ..s h=0,ret=0
    ..s tmparr=""  //一条产生的子表Rowid串
    ..s newclb=""
    ..f  s newclb=$o(^TMPGETINCLB(pidnum,newclb)) q:(newclb="")||(ret'=0)  d
    ...s h=h+1
    ...s inclb=newclb
    ...s qty=$p(^TMPGETINCLB(pidnum,newclb),"^",1)
    ...i h=1 d
    ....s amt=price*qty
    ....&sql(update DHC_PHACollectItm set  PHACI_Qty=:qty, PHACI_INCI_DR =:inclb,PHACI_SpAmt=:amt where PHACI_RowID=:phcirowid )
    ....i SQLCODE'=0 s ret=-1
    ....q:ret'=0
    ....s err=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phcirowid)  ;处理该笔发药记录的台帐库存
    ....i err<0 s ret=err
    ...i ret'=0 tro
    ...i ret'=0 d Unlock
    ...q:ret'=0
    ...;b //01
    ...;s err=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phcirowid)  ;处理该笔发药记录的台帐库存
    ...;i err<0 s ret=err
    ...;i ret'=0 tro
    ...;i ret'=0 d Unlock
    ...;q:ret'=0
    ...i h>1 s newphaci=..InsNewPhaci(phcirowid,inclb,qty)
    ...s err=+$g(newphaci)
    ...i err<0 s ret=err
    ...;b //02
    ...i ret'=0 tro
    ...i ret'=0 d Unlock
    ...q:ret'=0
    ...i h=1 d
    ....s tmparr=phcirowid
    ...e  d
    ....q:$g(newphaci)=""
    ....s tmparr=tmparr_"^"_$g(newphaci)
    ..q:ret'=0
    ..tcommit
    ..d Unlock
    ..
    ..s arrcnt=$l(tmparr,"^")
    ..f xx=1:1:arrcnt d
    ...s phcirowid=$p(tmparr,"^",xx)
    ...s:supp="" supp=..SavePHSUPPLY(pid,user) //更新补给记录
    ...s:supp'="" suppi=..SavePHSUPPLYITM(supp,phcirowid)
    ...s ^TMP("dhcpha","DHCSTPCHCOLLPRN","SAVEDATA",pid,phacdr,inci,phcirowid)=""
    ...s ret=..GetPhaDispTotal(pid,phcirowid)
    ...
    ...
    ..
    ..s success=1
    .i success=1 d
    ..i phacStr="" d
    ...s phacStr=phacdr
    ..e  d
    ...s phacStr=phacStr_"A"_phacdr
    
    q:phacStr'="" phacStr
    q ""
    
Unlock
   i $g(pidnum)'="" d
   .k ^TMPGETINCLB(pidnum)   
   l -^DHCINCIL(recloc,inci) 
   q
}

/// 生成药品补给记录
ClassMethod SavePHSUPPLY(pid, user) As %String
{
	n (pid,user)
	s suppno=..GetSupplyNo(pid)
	s str=^TMP("dhcpha",pid,"DISPMQ",1)
    s phacdr=$p(str,"&",1)
    s recloc=$p(^DHCPHAC(phacdr),"^",1)
    s wardctlocdr=""
    s warddr=$p(^DHCPHAC(phacdr),"^",4)
    s:warddr'="" wardctlocdr=$p(^PAWARD(warddr),"^",5)
    s phaci=$o(^DHCPHAC(phacdr,"I",""))
    s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
    s doclocdr=$p(^OEORD(+oedis,"I",$p(oedis,"||",2),7),"^",2)
    s prescno=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)
    s PLIST(2)=recloc 
    s PLIST(3)=+$h  
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=suppno
    s PLIST(6)=wardctlocdr
    s PLIST(7)=doclocdr
    s PLIST(8)=user
    s type="P"
    i prescno["O" s type="F"
    i prescno["E" s type="F"
    i prescno["I" s type="P"
    s PLIST(9)=$g(type)
    &sql(INSERT INTO DHC_PHSUPPLY VALUES PLIST())
    q:SQLCODE'=0 -1
    s supp=+%ROWID
    q supp
}

ClassMethod SavePHSUPPLYITM(supp, pointer) As %String
{
	n (supp,pointer)
	
	s PLIST(0)=supp 
    s PLIST(3)=+$o(^DHCPHSUPPI(supp,"I",""),-1)+1 
    s PLIST(2)=pointer
    s PLIST(4)="P"
    &sql(INSERT INTO DHC_PHSUPPLYITM VALUES PLIST())
    q:SQLCODE'=0 -1
    q 0
}

/// 获取补给单号
ClassMethod GetSupplyNo(pid) As %String
{
	n (pid)
	s prefix="S"
	s curdate=$zd(+$h,8)
    l +^DHCPHSUPP:5
    i '$d(^DHCPHSUPPNO("SUPPLYNO",+$h)) d
    .k ^DHCPHSUPPNO("SUPPLYNO")  //清除掉以往的global
    .s stream=1
    .s ^DHCPHSUPPNO("SUPPLYNO",+$h)=2
    e  d
    .s stream=^DHCPHSUPPNO("SUPPLYNO",+$h)
    .s ^DHCPHSUPPNO("SUPPLYNO",+$h)=^DHCPHSUPPNO("SUPPLYNO",+$h)+1
    l -^DHCPHSUPP
    s inno=prefix_curdate_"_"_$tr($j(stream,3)," ","0")
    s suppno=inno
	q suppno
}

/// 组织打印汇总数据
ClassMethod GetPhaDispTotal(pid, phcirowid) As %String
{
	n (pid,phcirowid)
    s ^TMP("dsytotal",pid,"phcirowid",phcirowid)=""
    q 0
}

/// 插入新批次
ClassMethod InsNewPhaci(phcirowid, inclb, qty) As %String
{
	
	n (phcirowid,inclb,qty)
	s phac=+phcirowid
	s sub=$p(phcirowid,"||",2)
	&sql(select * into :PLIST() from  DHC_PHACollectItm where PHACI_RowID=:phcirowid)
    q:SQLCODE'=0 -1
    s PLIST(4)=inclb 
    s PLIST(5)=+qty  
    s PLIST(7)=+$o( ^DHCPHAC(phac,"I",""),-1)+1
    s PLIST(17)=PLIST(11)*qty
    &sql(INSERT INTO DHC_PHACollectItm VALUES PLIST())
    q:SQLCODE'=0 -1
    s phcirowid=%ROWID
    s ret=##class(web.DHCSTPCHCOLLS2).DhcStkTab(phcirowid)
    q:ret<0 -2
	q phcirowid
}

/// 判断是否已经完全减库
/// 1 未发   0 已发
ClassMethod IfDisped(phac) As %String
{
   
    n (phac)
    s flag=0
    s phaci=""
	f  s phaci=$o(^DHCPHAC(phac,"I",phaci)) q:(phaci="")||(flag=1)  d
	.s phcirowid=phac_"||"_phaci 
	.q:$d(^DHCINTR(0,"TypePointer","P",phcirowid)) 
	.s flag=1
	q flag
}

/// 减库后再执行冲减
ClassMethod ExeRetAfterDisp(pid, phacStr) As %String
{
	n (pid,phacStr,%session)
	;s cnt=$l(phacStr,"A")
	;f i=1:1:cnt d
	;.s phac=$p(phacStr,"A",i)
	;.s phaward=$p(^DHCPHAC(phac),"^",4)
	;.i '$d(^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)) d
	;..s ^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)=phac
	;.e  d
	;..s ^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)=^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)_"A"_phac
	;.
	;s phaward=""
	;f  s phaward=$o(^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)) q:phaward=""  d 
	;.s phacStr=^TMP("dhcpha",pid,"ExeRetAfterDispWard",phaward)
    ;.s err=##class(web.DHCSTPCHCOLLS).ExeRetAfterDisp(pid,phacStr)
    ;k ^TMP("dhcpha",pid,"ExeRetAfterDispWard")
    s err=##class(web.DHCSTPCHCOLLS).ExeRetAfterDisp(pid,phacStr,1)
    q 0
}

/// 获取打印串
ClassMethod GetPrtPhacStr(pid) As %String
{
	n (pid)
	s num=$o(^TMP("dhcpha",pid,"DISPMQ",""),-1)
	q:num'>0 ""
	s phacStr=""
	f i=1:1:num d
    .s str=^TMP("dhcpha",pid,"DISPMQ",i)
    .s phac=$p(str,"&",1)
    .i phacStr="" d
    ..s phacStr=phac
    .e  d
    ..s phacStr=phacStr_"A"_phac
    q phacStr
}

ClassMethod DispDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispDetailExecute(ByRef qHandle As %Binary, coll As %String, PamStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	q:coll="" $$$OK
	//实现；
	d ResetVariables4
	s amttotal=0

	s cnt=$$GETDATA(coll,PamStr)
	f i=1:1:cnt d
	. s detail=^TMP("dhcpha",pid,"DISPDQ",i)
	. 
	. d OutputRow4
	. 
	d outputtotal
	
	k ^TMP("dhcpha",pid,"DISPDQ")
	Quit $$$OK
OutputRow4
	s TInsuType=$p(detail,"&",1)
	s TAdmLoc=$p(detail,"&",2)
	s TBedNo=$p(detail,"&",3)
	s TPaName=$p(detail,"&",4)
	s TRegNo=$p(detail,"&",5)
	
	s TOrdItemDesc=$p(detail,"&",6)
	s TQty=$p(detail,"&",7)
	s TSalePrice=$p(detail,"&",8)
	s TStatus=$p(detail,"&",9)
	s TDispCat=$p(detail,"&",10)
	s TDoseQty=$p(detail,"&",11)
	s TFreq=$p(detail,"&",12)
	s TInstruction=$p(detail,"&",13)
	s TDuration=$p(detail,"&",14)
	s TPrescno=$p(detail,"&",15)
	s TBatchNo=$p(detail,"&",16)
	;--------add by lq------------
	
	s Tsex=$p(detail,"&",21)
	s Tdoctor=$p(detail,"&",22)
	s Tgenedesc=$p(detail,"&",23)
	s Tphcform=$p(detail,"&",24)
	s Tbarcode=$p(detail,"&",25)
	s Tmanf=$p(detail,"&",26)
	s Tmanf=$p(Tmanf,"-",2)
	s Tuomdesc=$p(detail,"&",27)
	s Tstotal=$p(detail,"&",28)
	s Tdiag=$p(detail,"&",29)
	s Told=$p(detail,"&",30)
	s Taction=$p(detail,"&",31)
	;-----------------------------
	s amttotal=amttotal+Tstotal
 	s amttotal=$fn(amttotal,"",2)
	s Data=$lb(TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo,Tsex,Tdoctor,Tgenedesc,Tphcform,Tbarcode,Tmanf,Tstotal,Tdiag,Told,Taction)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

outputtotal
	;2007-8-7,zdm
	s Data=$lb("","总计","","","","","","","","","","","","","","","","","","","","",amttotal,"","")
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
	
ResetVariables4
	s (TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo,Tsex,Tdoctor,Tgenedesc,Tphcform,Tbarcode,Tmanf,Tuomdesc,Tstotal,Tdiag,Told,Taction)=""
	q
	
GETDATA(phacdr,pamstr) 
 s pid=##class(web.DHCSTPCHCOLLS).NewPid()
 s regno="",longord="",shortord=""
 s dispflag=$p(pamstr,"^",1)

 k ^TMP("dhcpha",pid,"D2")
 k ^TMP("dhcpha",pid,"DISPDQ")
 i '$d(^DHCPHAC(phacdr)) q -1
 s phactype=$p(^DHCPHAC(phacdr),"^",12)
 s phacdatefrom=$p(^DHCPHAC(phacdr),"^",10)
 s phacdateto=$p(^DHCPHAC(phacdr),"^",11)
 s phacward=$p(^DHCPHAC(phacdr),"^",4)
 s phacloc=$p(^DHCPHAC(phacdr),"^",1)
 s phacuser=$p(^DHCPHAC(phacdr),"^",5)
 s phacstat=$p(^DHCPHAC(phacdr),"^",6)
 s phacusername=$g(phacusername)
 i phacuser'="" s phacusername=$p(^SSU("SSUSR",+phacuser),"^",2)
 ;
 s i=0 
 s Stotal1=0  
 s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
 .;q:(dispflag=1)&(..IfDisped(phacdr)=1)
 .;q:(dispflag=0)&(..IfDisped(phacdr)=0)
 .s phcirowid=phacdr_"||"_phaci
 .q:$d(^DHCINTR(0,"TypePointer","P",phcirowid))  ///不能重复减库
 .s i=i+1
 .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
 .s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
 .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
 .s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
 .s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
 .s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
 .;-------------add by lq ---------------------
 .s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
 .s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
 .s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
 .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家
 .s CTUOMDR=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
 .s UOMDesc=$p(^CT("UOM",CTUOMDR),"^",2) 						//单位
 .s diagnose=""
 .i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
 .;-----------------------------------------------
 .s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
 .s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
 .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 .s chl=$p(oedis,"||",2) 
 .s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
 .s doctorloc=$p(^CTLOC(doctorlocdr),"^",2) 
 .i '$d(^OEORD(ord,"I",chl)) q 
 .s DocTor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)
 .;s ordmemo=$$GetOrdItmRemark^DHCSTIPOUT(oedis)  
 .s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
 .&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
 .i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)  
 .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
 .s patnameid=$p(^PAADM(adm),"^",1)    ;PA_PatMas PAPMI_RowId
 .s patid=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
 .s patno=$p(^PAPER(patnameid,"PAT",1),"^",1) 
 .q:(regno'="")&(regno'=patno)                  //过滤登记号条件
 .s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1) 
 .i longord="1" q:priority'="S"              //过滤仅显示长嘱条件
 .i shortord="1" q:(priority="S")!(priority="OUT") //过滤仅显示临嘱条件
 .s sexid =$p( ^PAPER(patnameid,"ALL"),"^",7)   
 .s sex =$p(^CT("SEX",sexid),"^",2 )            //性别
 .s PADob=$p( ^PAPER(patnameid,"ALL"),"^",6)
 .s Paold=""
 .i PADob'="" s Paold=$fn((+$h-PADob)/365,"",0) //年龄
 .s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;//2007-10-26 皮试结果
 .s code="In Patient"                                  
 .&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
 .s admdate=$zd(admdate,3) 
 .s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
 .s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
 .s j=deploc_"||"_bed_"||"_arcim         ;i phactype="PJ" 
 .i phactype'="PJ" s j=arcim_"||"_deploc_"||"_bed        
 .s ^TMP("dhcpha",pid,"D2","ARCIM",j,i)=arcim                                        ;arcim(j,i)                 ;医嘱名称
 .s ^TMP("dhcpha",pid,"D2","PATNAME",j,i)=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)               ;病人姓名   
 .s ^TMP("dhcpha",pid,"D2","PATMRN",j,i)=$p(^PAPER(patnameid,"PAT",1),"^",1)         ;patmrn(j,i)                ;病人登记号     
 .s ^TMP("dhcpha",pid,"D2","PRESC",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)         ;presc(j,i)                 ;医嘱处方号      
 .s ^TMP("dhcpha",pid,"D2","BED",j,i)=bed                                            ;bed(j,i)                   ;病人床号       
 .s ^TMP("dhcpha",pid,"D2","PRICE",j,i)=$fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4)         ;price(j,i)       ;医嘱价格       
 .s ^TMP("dhcpha",pid,"D2","QTY",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)           ;qty(j,i)                   ;医嘱数量
 .;<---------------add by lq-----------------
 .s Stotal=$fn($fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4) *$p(^DHCPHAC(phacdr,"I",phaci),"^",6),"",2)
 .s Stotal1=Stotal1+Stotal
 .s ^TMP("dhcpha",pid,"D2","Stotal",j,i)= Stotal //医嘱总价
 .s ^TMP("dhcpha",pid,"D2","Sex",j,i)=sex   //性别
 .s ^TMP("dhcpha",pid,"D2","Doctor",j,i)=DocTor_" "_doctorloc //医师
 .s ^TMP("dhcpha",pid,"D2","Genedesc",j,i)=genedesc //通用名
 .s ^TMP("dhcpha",pid,"D2","PhcForm",j,i)=phcform //剂型
 .s ^TMP("dhcpha",pid,"D2","BarCode",j,i)=Specifaction //规格
 .s ^TMP("dhcpha",pid,"D2","Manf",j,i)=manf //厂家
 .s ^TMP("dhcpha",pid,"D2","UOMDesc",j,i)=UOMDesc //单位
 .s ^TMP("dhcpha",pid,"D2","Diag",j,i)=diagnose //诊断
 .s ^TMP("dhcpha",pid,"D2","Old",j,i)=Paold //年龄
 .s ^TMP("dhcpha",pid,"D2","Getaction",j,i)=getaction //皮试备注
 .;----------------------------------->
 .s ^TMP("dhcpha",pid,"D2","PAKUOM",j,i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;pakuom(j,i)              ;药品基本库存单位       
 .s ^TMP("dhcpha",pid,"D2","YBTYPE",j,i)=##class(web.DHCSTPCHCOLLS).GetYBType(+adm)
 .i $p(^OEORD(ord,"I",chl,2),"^",6)="" s ^TMP("dhcpha",pid,"D2","DURA",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","DURA",j,i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)   ;dur(j,i)         ;用药疗程
 .i $p(^OEORD(ord,"I",chl,2),"^",7)="" s ^TMP("dhcpha",pid,"D2","INST",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)   ;inst(j,i)        ;用法
 .i $f(^TMP("dhcpha",pid,"D2","INST",j,i),"-")  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^TMP("dhcpha",pid,"D2","INST",j,i),"-",2)      
 .i $p(^OEORD(ord,"I",chl,2),"^",4)="" s ^TMP("dhcpha",pid,"D2","FREQ",j,i)="*"           ;freq(j,i)
 .e  s ^TMP("dhcpha",pid,"D2","FREQ",j,i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",1)                       ;用药频率 
 .s ^TMP("dhcpha",pid,"D2","DOSAGE",j,i)=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3)                                ;用药剂量
 .i $p(^OEORD(ord,"I",chl,2),"^",3)="" s ^TMP("dhcpha",pid,"D2","UOM",j,i)="*"
 .e  s ^TMP("dhcpha",pid,"D2","UOM",j,i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)   ;uom(j,i)         ;剂量单位           
 .s ^TMP("dhcpha",pid,"D2","BATNO",j,i)=$p(^INCI(inci,"IB",incib),"^",1)                       ;incibno(j,i)      ;药物批号
 .s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)                    ;oeflag(j,i)    ;医嘱核实、未核实、停止状态
 .i $p(^OEORD(ord,"I",chl,1),"^",8)="" s ^TMP("dhcpha",pid,"D2","TYPE",j,i)="*"            ;ordtype(j,i)
 .e  s ^TMP("dhcpha",pid,"D2","TYPE",j,i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)                       ;医嘱优先级
 .s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^CTLOC(deploc),"^",2)                                  ;deploc(j,i)   ;病人所在科室
 .i $f(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-")  s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-",2)
 .s ^TMP("dhcpha",pid,"D2","DOTOR",j,i)=doctor        
 .s ^TMP("dhcpha",pid,"D2","ADMDATE",j,i)=admdate
 .s ^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)=phacusername
 .s ^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)=ordmemo
 .i (^TMP("dhcpha",pid,"D2","OEFLAG",j,i)'="D")&(^TMP("dhcpha",pid,"D2","TYPE",j,i)'="NORM") d
 ..i $d(HUIZONGPJ(arcimid)) s $p(HUIZONGPJ(arcimid),"&",2)=$p(HUIZONGPJ(arcimid),"&",2)+^TMP("dhcpha",pid,"D2","QTY",j,i) 
 ..i '$d(HUIZONGPJ(arcimid)) d
 ...s $p(HUIZONGPJ(arcimid),"&",1)=arcim 
 ...s $p(HUIZONGPJ(arcimid),"&",2)=^TMP("dhcpha",pid,"D2","QTY",j,i) 
 ...s $p(HUIZONGPJ(arcimid),"&",3)=$p(^INCI(inci,1),"^",10)
 ...s $p(HUIZONGPJ(arcimid),"&",4)=^TMP("dhcpha",pid,"D2","PRICE",j,i)
 s num=0
 s j="" f  s j=$o(^TMP("dhcpha",pid,"D2","ARCIM",j))  q:j=""  d
 .s i="" f  s i=$o(^TMP("dhcpha",pid,"D2","ARCIM",j,i)) q:i=""  d
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="V" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="*"
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="D" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="停止"
 ..s info0=^TMP("dhcpha",pid,"D2","DEPLOC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BED",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATMRN",j,i)
 ..s info1=^TMP("dhcpha",pid,"D2","ARCIM",j,i)_"&"_^TMP("dhcpha",pid,"D2","QTY",j,i)_" "_^TMP("dhcpha",pid,"D2","PAKUOM",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRICE",j,i)
 ..s info2=^TMP("dhcpha",pid,"D2","OEFLAG",j,i)_"&"_^TMP("dhcpha",pid,"D2","TYPE",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOSAGE",j,i)_^TMP("dhcpha",pid,"D2","UOM",j,i)
 ..s info3=^TMP("dhcpha",pid,"D2","FREQ",j,i)_"&"_^TMP("dhcpha",pid,"D2","INST",j,i)_"&"_^TMP("dhcpha",pid,"D2","DURA",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRESC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BATNO",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOTOR",j,i)_"&"_^TMP("dhcpha",pid,"D2","ADMDATE",j,i)_"&"_^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)
 ..;<-----------------add by lq ------------------------
 ..s info4=^TMP("dhcpha",pid,"D2","Sex",j,i)_"&"_^TMP("dhcpha",pid,"D2","Doctor",j,i)_"&"_^TMP("dhcpha",pid,"D2","Genedesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","PhcForm",j,i)_"&"_^TMP("dhcpha",pid,"D2","BarCode",j,i)_"&"_^TMP("dhcpha",pid,"D2","Manf",j,i)_"&"_^TMP("dhcpha",pid,"D2","UOMDesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","Stotal",j,i)_"&"_^TMP("dhcpha",pid,"D2","Diag",j,i)_"&"_^TMP("dhcpha",pid,"D2","Old",j,i)_"&"_^TMP("dhcpha",pid,"D2","Getaction",j,i) //2007-10-26
 ..;---------------------------------->
 ..s Med=info0_"&"_info1_"&"_info2_"&"_info3_"&"_info4 
 ..s memo=""
 ..s memonum=^OEORD(ord,"I",chl,"DEP",0)               ;get memo
 ..f k=2:1:memonum  d
 ...s memo=memo_^OEORD(ord,"I",chl,"DEP",k)
 ..s num=num+1
 ..s ^TMP("dhcpha",pid,"DISPDQ",num)=^TMP("dhcpha",pid,"D2","YBTYPE",j,i)_"&"_Med_"&"_memo
 ..;
 .;
 k ^TMP("dhcpha",pid,"D2")
 q num
}

ClassMethod DispDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DispDetail(coll As %String, PamStr) As %Query(ROWSPEC = "TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TOrdItemDesc:%String,TQty:%String,TSalePrice:%String,TStatus:%String,TDispCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescno:%String,TBatchNo:%String ,TSex:%String ,TDoctor:%String,TGenedesc:%String,TPhcForm:%String,TBarcode:%String,TManf:%String,TStotal:%String,TDiag:%String,TOld:%String,Taction:%String")
{
}

ClassMethod SupplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SupplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SupplyListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；     
	q:$g(displocrowid)="" $$$OK
	q:$g(StartDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s tmp=$$GetSupply(StartDate,EndDate,displocrowid,wardrowid,StartTime,EndTime,DoctorLocRowid,DispNo,PamStr)
	s cnt=$p(tmp,"^",1)
	s pid=$p(tmp,"^",2)
	s i=1
	f i=1:1:cnt   d
	. s dispm=^TMP("dhcpha",pid,"DISPMQ",i)
	. q:dispm=""   
	. d OutputRowSupply
	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputRowSupply
	s supp=$p(dispm,"&",1)
	s suppdate=$p(dispm,"&",2)
	s supptime=$p(dispm,"&",3)
	s username=$p(dispm,"&",4)
	s suppno=$p(dispm,"&",5)
    s ward=$p(dispm,"&",6)
    s docloc=$p(dispm,"&",7)
	
	s Data=$lb(supp,suppdate,supptime,username,suppno,ward,docloc,pid)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetSupply(datef,datet,pha,wardrowid,StartTime,EndTime,DoctorLocRowid,dispno,pamstr)
	q:datef="" ""
	q:datet="" ""
	q:pha="" ""
 	i $g(StartTime)="" s StartTime=$zth("00:00:00",3)       ;0
 	i $g(EndTime)="" s EndTime=$zth("23:59:59",3)       ;86399
 	;
	s wardrowid=$g(wardrowid),user=$g(user),type=$g(type)  
	s num=0
    s outflag=$p(pamstr,"^",1)
    s inflag=$p(pamstr,"^",2)
    
    i outflag=1 s indexcode="DOCLOC"
    i inflag=1 s indexcode="WARDLOC"
    
    ;
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()  ;
	s typestr="P^F"
	f date=datef:1:datet d
	.s typecnt=$l(typestr,"^")
	.f h=1:1:typecnt d
	..s type=$p(typestr,"^",h)
	..s locdr=""
	..f  s locdr=$o(^DHCPHSUPPI(0,indexcode,pha,date,type,locdr)) q:locdr=""  d
    ...i inflag="1" s warddr=$o(^PAWARD(0,"WARD_LocationDR",locdr,""))
    ...q:(wardrowid'=$g(warddr))&(wardrowid'="")&(inflag="1")
    ...i outflag="1" q:(locdr'=DoctorLocRowid)&(DoctorLocRowid'="")
	...s supp=""
	...f  s supp=$o(^DHCPHSUPPI(0,indexcode,pha,date,type,locdr,supp)) q:supp=""  d
	....s doclocdr=$p(^DHCPHSUPP(supp),"^",6)
	....i inflag="1" q:(doclocdr'=DoctorLocRowid)&(DoctorLocRowid'="")
	....s suppno=$p(^DHCPHSUPP(supp),"^",4)
	....q:(dispno'=suppno)&(dispno'="")
	....s suppdate=$p(^DHCPHSUPP(supp),"^",2)
	....s:suppdate'="" suppdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(suppdate)
	....s supptime=$p(^DHCPHSUPP(supp),"^",3)
	....
	....q:(StartTime'="")&(date=datef)&(StartTime>supptime)
	....q:(EndTime'="")&(date=datet)&(EndTime<supptime)
	....
	....s:supptime'="" supptime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(supptime)
	....//EndTime
	....s ssuer=$p(^DHCPHSUPP(supp),"^",7)
	....s username=$p(^SSU("SSUSR",ssuer),"^",2)
	....s warddr=$o(^PAWARD(0,"WARD_LocationDR",locdr,"")) 
	....s ward=""
	....s:warddr'="" ward=$p(^PAWARD(warddr),"^",2)
	....i (ward'="")&($f(ward,"-")) s ward=$p(ward,"-",2)
	....s docloc="" 
	....s doclocdr=$p(^DHCPHSUPP(supp),"^",6)
	....i doclocdr'="" s docloc=$p(^CTLOC(doclocdr),"^",2) 
	....i (docloc'="")&($f(docloc,"-")) s docloc=$p(docloc,"-",2) 
	....s num=num+1
	....
	....s ^TMP("dhcpha",pid,"DISPMQ",num)=supp_"&"_suppdate_"&"_supptime_"&"_username_"&"_suppno_"&"_ward_"&"_docloc
	
	q num_"^"_pid
}

Query SupplyList(StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, DispNo As %String, PamStr As %String) As %Query(ROWSPEC = "Tsupp:%String,Tsuppdate:%String,Tsupptime:%String,Tusername:%String,Tsuppno:%String,Tward:%String,Tdocloc:%String,Tpid:%String")
{
}

ClassMethod SupplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SupplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SupplyDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SupplyDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SupplyDetailExecute(ByRef qHandle As %Binary, coll As %String, pid) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	q:coll="" $$$OK
	//实现；
    
	s amttotal=0

	s cnt=$$GETDATASupply(coll,pid)
	f i=1:1:cnt d
	. s detail=^TMP("dhcpha",pid,"DISPDQ",i)
	. 
	. d OutputRowSupplyDetail
	. 
	d OutputRowSupplyTotal
	
	k ^TMP("dhcpha",pid,"DISPDQ")
	Quit $$$OK
OutputRowSupplyDetail
	s TInsuType=$p(detail,"&",1)
	s TAdmLoc=$p(detail,"&",2)
	s TBedNo=$p(detail,"&",3)
	s TPaName=$p(detail,"&",4)
	s TRegNo=$p(detail,"&",5)
	s TOrdItemDesc=$p(detail,"&",6)
	s TQty=$p(detail,"&",7)
	s TSalePrice=$p(detail,"&",8)
	s TStatus=$p(detail,"&",9)
	s TDispCat=$p(detail,"&",10)
	s TDoseQty=$p(detail,"&",11)
	s TFreq=$p(detail,"&",12)
	s TInstruction=$p(detail,"&",13)
	s TDuration=$p(detail,"&",14)
	s TPrescno=$p(detail,"&",15)
	s TBatchNo=$p(detail,"&",16)
	s Tsex=$p(detail,"&",21)
	s Tdoctor=$p(detail,"&",22)
	s Tgenedesc=$p(detail,"&",23)
	s Tphcform=$p(detail,"&",24)
	s Tbarcode=$p(detail,"&",25)
	s Tmanf=$p(detail,"&",26)
	s Tmanf=$p(Tmanf,"-",2)
	s Tuomdesc=$p(detail,"&",27)
	s Tstotal=$p(detail,"&",28)
	s Tdiag=$p(detail,"&",29)
	s Told=$p(detail,"&",30)
	s Taction=$p(detail,"&",31)
	s amttotal=amttotal+Tstotal
 	s amttotal=$fn(amttotal,"",2)
	s Data=$lb(TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo,Tsex,Tdoctor,Tgenedesc,Tphcform,Tbarcode,Tmanf,Tstotal,Tdiag,Told,Taction)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

OutputRowSupplyTotal
	;2007-8-7,zdm
	s Data=$lb("","总计","","","","","","","","","","","","","","","","","","","","",amttotal,"","")
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
	
	
GETDATASupply(coll,pid) 
 //s pid=##class(web.DHCSTPCHCOLLS).NewPid()
 
 k ^TMP("dhcpha",pid,"D2")
 k ^TMP("dhcpha",pid,"DISPDQ")
 
 s type=$p(^DHCPHSUPP(coll),"^",8)
 i type="P" d
 .s incitm=""
 .f  s incitm=$o(^DHCPHAC(0,"SUPP", coll, incitm)) q:incitm=""  d
 ..s spha=""
 ..f  s spha=$o(^DHCPHAC(0,"SUPP", coll, incitm,spha)) q:spha=""  d
 ...s schl=""
 ...f  s schl=$o(^DHCPHAC(0,"SUPP", coll, incitm,spha,schl)) q:schl=""  d
 ....s pharowid=spha_"||"_schl
 ....s Stotal1=0
 ....s phacdr=$p(pharowid,"||",1)
 ....s phaci=$p(pharowid,"||",2)
 ....s phactype=$p(^DHCPHAC(phacdr),"^",12)
 ....s phacdatefrom=$p(^DHCPHAC(phacdr),"^",10)
 ....s phacdateto=$p(^DHCPHAC(phacdr),"^",11)
 ....s phacward=$p(^DHCPHAC(phacdr),"^",4)
 ....s phacloc=$p(^DHCPHAC(phacdr),"^",1)
 ....s phacuser=$p(^DHCPHAC(phacdr),"^",5)
 ....s phacstat=$p(^DHCPHAC(phacdr),"^",6)
 ....s phacusername=$g(phacusername)
 ....i phacuser'="" s phacusername=$p(^SSU("SSUSR",+phacuser),"^",2)
 ....s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
 ....s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
 ....s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
 ....s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
 ....s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
 ....s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
 ....s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
 ....s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
 ....s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
 ....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家
 ....s CTUOMDR=$p(^INCI(inci,1),"^",10) 							// 指向 CT_UOM 
 ....s UOMDesc=$p(^CT("UOM",CTUOMDR),"^",2) 						//单位
 ....s diagnose=""
 ....i adm'="" s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
 ....s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
 ....s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
 ....s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 ....s chl=$p(oedis,"||",2) 
 ....s doctorlocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
 ....s doctorloc=$p(^CTLOC(doctorlocdr),"^",2) 
 ....i '$d(^OEORD(ord,"I",chl)) q 
 ....s DocTor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)
 ....s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
 ....&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
 ....i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)  
 ....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
 ....s patnameid=$p(^PAADM(adm),"^",1)    ;PA_PatMas PAPMI_RowId
 ....s patid=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
 ....s patno=$p(^PAPER(patnameid,"PAT",1),"^",1)
 ....s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1) 
 ....s sexid =$p( ^PAPER(patnameid,"ALL"),"^",7)   
 ....s sex =$p(^CT("SEX",sexid),"^",2 )            //性别
 ....s PADob=$p( ^PAPER(patnameid,"ALL"),"^",6)
 ....s Paold=""
 ....i PADob'="" s Paold=$fn((+$h-PADob)/365,"",0) //年龄
 ....s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;//2007-10-26 皮试结果
 ....s code="In Patient"                                  
 ....&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
 ....s admdate=$zd(admdate,3) 
 ....s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
 ....s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 ....s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
 ....s j=deploc_"||"_bed_"||"_arcim               
 ....s ^TMP("dhcpha",pid,"D2","ARCIM",j,i)=arcim                                        ;arcim(j,i)                 ;医嘱名称
 ....s ^TMP("dhcpha",pid,"D2","PATNAME",j,i)=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)               ;病人姓名   
 ....s ^TMP("dhcpha",pid,"D2","PATMRN",j,i)=$p(^PAPER(patnameid,"PAT",1),"^",1)         ;patmrn(j,i)                ;病人登记号     
 ....s ^TMP("dhcpha",pid,"D2","PRESC",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)         ;presc(j,i)                 ;医嘱处方号      
 ....s ^TMP("dhcpha",pid,"D2","BED",j,i)=bed                                            ;bed(j,i)                   ;病人床号       
 ....s ^TMP("dhcpha",pid,"D2","PRICE",j,i)=$fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4)         ;price(j,i)       ;医嘱价格       
 ....s ^TMP("dhcpha",pid,"D2","QTY",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)           ;qty(j,i)                   ;医嘱数量
 ....s Stotal=$fn($fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4) *$p(^DHCPHAC(phacdr,"I",phaci),"^",6),"",2)
 ....s Stotal1=Stotal1+Stotal
 ....s ^TMP("dhcpha",pid,"D2","Stotal",j,i)= Stotal //医嘱总价
 ....s ^TMP("dhcpha",pid,"D2","Sex",j,i)=sex   //性别
 ....s ^TMP("dhcpha",pid,"D2","Doctor",j,i)=DocTor_" "_doctorloc //医师
 ....s ^TMP("dhcpha",pid,"D2","Genedesc",j,i)=genedesc //通用名
 ....s ^TMP("dhcpha",pid,"D2","PhcForm",j,i)=phcform //剂型
 ....s ^TMP("dhcpha",pid,"D2","BarCode",j,i)=Specifaction //规格
 ....s ^TMP("dhcpha",pid,"D2","Manf",j,i)=manf //厂家
 ....s ^TMP("dhcpha",pid,"D2","UOMDesc",j,i)=UOMDesc //单位
 ....s ^TMP("dhcpha",pid,"D2","Diag",j,i)=diagnose //诊断
 ....s ^TMP("dhcpha",pid,"D2","Old",j,i)=Paold //年龄
 ....s ^TMP("dhcpha",pid,"D2","Getaction",j,i)=getaction //皮试备注
 ....s ^TMP("dhcpha",pid,"D2","PAKUOM",j,i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;pakuom(j,i)              ;药品基本库存单位       
 ....s ^TMP("dhcpha",pid,"D2","YBTYPE",j,i)=##class(web.DHCSTPCHCOLLS).GetYBType(+adm)
 ....i $p(^OEORD(ord,"I",chl,2),"^",6)="" s ^TMP("dhcpha",pid,"D2","DURA",j,i)="*"
 ....e  s ^TMP("dhcpha",pid,"D2","DURA",j,i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)   ;dur(j,i)         ;用药疗程
 ....i $p(^OEORD(ord,"I",chl,2),"^",7)="" s ^TMP("dhcpha",pid,"D2","INST",j,i)="*"
 ....e  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)   ;inst(j,i)        ;用法
 ....i $f(^TMP("dhcpha",pid,"D2","INST",j,i),"-")  s ^TMP("dhcpha",pid,"D2","INST",j,i)=$p(^TMP("dhcpha",pid,"D2","INST",j,i),"-",2)      
 ....i $p(^OEORD(ord,"I",chl,2),"^",4)="" s ^TMP("dhcpha",pid,"D2","FREQ",j,i)="*"           ;freq(j,i)
 ....e  s ^TMP("dhcpha",pid,"D2","FREQ",j,i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",1)                       ;用药频率 
 ....s ^TMP("dhcpha",pid,"D2","DOSAGE",j,i)=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3)                                ;用药剂量
 ....i $p(^OEORD(ord,"I",chl,2),"^",3)="" s ^TMP("dhcpha",pid,"D2","UOM",j,i)="*"
 ....e  s ^TMP("dhcpha",pid,"D2","UOM",j,i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)   ;uom(j,i)         ;剂量单位           
 ....s ^TMP("dhcpha",pid,"D2","BATNO",j,i)=$p(^INCI(inci,"IB",incib),"^",1)                       ;incibno(j,i)      ;药物批号
 ....s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)                    ;oeflag(j,i)    ;医嘱核实、未核实、停止状态
 ....i $p(^OEORD(ord,"I",chl,1),"^",8)="" s ^TMP("dhcpha",pid,"D2","TYPE",j,i)="*"            ;ordtype(j,i)
 ....e  s ^TMP("dhcpha",pid,"D2","TYPE",j,i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)                       ;医嘱优先级
 ....s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^CTLOC(deploc),"^",2)                                  ;deploc(j,i)   ;病人所在科室
 ....i $f(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-")  s ^TMP("dhcpha",pid,"D2","DEPLOC",j,i)=$p(^TMP("dhcpha",pid,"D2","DEPLOC",j,i),"-",2)
 ....s ^TMP("dhcpha",pid,"D2","DOTOR",j,i)=doctor        
 ....s ^TMP("dhcpha",pid,"D2","ADMDATE",j,i)=admdate
 ....s ^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)=phacusername
 ....s ^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)=ordmemo
 ...
 ..
 .
 s num=0
 s j="" f  s j=$o(^TMP("dhcpha",pid,"D2","ARCIM",j))  q:j=""  d
 .s i="" f  s i=$o(^TMP("dhcpha",pid,"D2","ARCIM",j,i)) q:i=""  d
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="V" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="*"
 ..i ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="D" s ^TMP("dhcpha",pid,"D2","OEFLAG",j,i)="停止"
 ..s info0=^TMP("dhcpha",pid,"D2","YBTYPE",j,i)_"&"_^TMP("dhcpha",pid,"D2","DEPLOC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BED",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","PATMRN",j,i)
 ..s info1=^TMP("dhcpha",pid,"D2","ARCIM",j,i)_"&"_^TMP("dhcpha",pid,"D2","QTY",j,i)_" "_^TMP("dhcpha",pid,"D2","PAKUOM",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRICE",j,i)
 ..s info2=^TMP("dhcpha",pid,"D2","OEFLAG",j,i)_"&"_^TMP("dhcpha",pid,"D2","TYPE",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOSAGE",j,i)_^TMP("dhcpha",pid,"D2","UOM",j,i)
 ..s info3=^TMP("dhcpha",pid,"D2","FREQ",j,i)_"&"_^TMP("dhcpha",pid,"D2","INST",j,i)_"&"_^TMP("dhcpha",pid,"D2","DURA",j,i)_"&"_^TMP("dhcpha",pid,"D2","PRESC",j,i)_"&"_^TMP("dhcpha",pid,"D2","BATNO",j,i)_"&"_^TMP("dhcpha",pid,"D2","DOTOR",j,i)_"&"_^TMP("dhcpha",pid,"D2","ADMDATE",j,i)_"&"_^TMP("dhcpha",pid,"D2","PHACUSERNAME",j,i)_"&"_^TMP("dhcpha",pid,"D2","ORDMEMO",j,i)
 ..s info4=^TMP("dhcpha",pid,"D2","Sex",j,i)_"&"_^TMP("dhcpha",pid,"D2","Doctor",j,i)_"&"_^TMP("dhcpha",pid,"D2","Genedesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","PhcForm",j,i)_"&"_^TMP("dhcpha",pid,"D2","BarCode",j,i)_"&"_^TMP("dhcpha",pid,"D2","Manf",j,i)_"&"_^TMP("dhcpha",pid,"D2","UOMDesc",j,i)_"&"_^TMP("dhcpha",pid,"D2","Stotal",j,i)_"&"_^TMP("dhcpha",pid,"D2","Diag",j,i)_"&"_^TMP("dhcpha",pid,"D2","Old",j,i)_"&"_^TMP("dhcpha",pid,"D2","Getaction",j,i) //2007-10-26
 ..
 ..s Med=info0_"&"_info1_"&"_info2_"&"_info3_"&"_info4 
 ..s num=num+1
 ..s ^TMP("dhcpha",pid,"DISPDQ",num)=Med 
 ..;
 .;
 k ^TMP("dhcpha",pid,"D2")
 q num
 
GETPDATA
 i type="P" d

   
 q

GETFDATA
 q
}

ClassMethod SupplyDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SupplyDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SupplyDetail(coll As %String, pid) As %Query(ROWSPEC = "TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TOrdItemDesc:%String,TQty:%String,TSalePrice:%String,TStatus:%String,TDispCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescno:%String,TBatchNo:%String ,TSex:%String ,TDoctor:%String,TGenedesc:%String,TPhcForm:%String,TBarcode:%String,TManf:%String,TStotal:%String,TDiag:%String,TOld:%String,Taction:%String")
{
}

ClassMethod SupplyTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SupplyTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SupplyTotalExecute(ByRef qHandle As %Binary, pid As %String, supp) As %Status
{
	n (qHandle,pid,supp)
	k SupplyTotalData
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:pid="" $$$OK
	q:supp="" $$$OK
	k ^TMP("dhcpha","SUPP","ITM",pid)
	s supplength=$l(supp,"^")
	s supply=supp
	s prescsum=""
	f suppplace=1:1:supplength d   //yunhaibao20121019,为汇总添加循环
	.s supp=$p(supply,"^",suppplace)
    .d ShowTotal
    q:'$d(SupplyTotalData) $$$OK
	s inci="" 
	f  s inci=$o(SupplyTotalData(inci)) q:inci=""  d
	.s suppinfo=SupplyTotalData(inci)
	.s qty=$p(suppinfo,"^",1)
	.s qty=##class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s Data=$lb(incicode,incidesc,qty,spec)
	.s ^CacheTemp(repid,ind)=Data	
	.s ind=ind+1
	k SupplyTotalData    
	Quit $$$OK
	
ShowTotal
    s type=$p(^DHCPHSUPP(supp),"^",8)
    s chl=""
    f  s chl=$o(^DHCPHSUPPI(supp,"I",chl)) q:chl=""  d
    .s pointer=$p(^DHCPHSUPPI(supp,"I",chl),"^",1)
    .i type="F" d
    ..s pha=$p(pointer,"||",1)
    ..s sub=$p(pointer,"||",2)
    ..q:'$d(^DHCPHDI(pha,"PHDI",sub))
    ..s sublb=0 
    ..f  s sublb=$o(^DHCPHDI(pha,"PHDI",sub,"INCLB",sublb)) q:sublb=""  d
    ...s phacItmLbData=^DHCPHDI(pha,"PHDI",sub,"INCLB",sublb)
    ...s qty=$p(phacItmLbData,"^",1)
    ...s inclb=$p(phacItmLbData,"^",3)
    ...s inci=+inclb
    ...s resqty=0
    ...i '$d(SupplyTotalData(inci)) d
    ....s SupplyTotalData(inci)=qty
    ...e  s SupplyTotalData(inci)=qty+SupplyTotalData(inci)
	q
}

ClassMethod SupplyTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SupplyTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SupplyTotal(pid As %String, supp) As %Query(ROWSPEC = "Tincicode:%String,Tincidesc:%String,Tqty:%String,Tspec:%String")
{
}

ClassMethod GetSupplyDataToPrt(pid) As %String
{
   n (pid)
   s h=0
   s inci=""
   f  s inci=$o(^TMP("dhcpha","SUPP","ITM",pid,inci)) q:inci=""  d
   .s h=h+1
   .s info=^TMP("dhcpha","SUPP","ITM",pid,inci)
   .s qty=$p(info,"^",3)
   .s qty=##class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
   .s $p(info,"^",3)=qty
   .s ^TMP("dhcpha","SUPP","PRTITM",pid,h)=info
   
   d killtmp
   q h
killtmp
   k ^TMP("dhcpha","SUPP","ITM",pid)
   q
}

ClassMethod ListSupplyData(pid, h) As %String
{
   n (pid,h)
   s str=^TMP("dhcpha","SUPP","PRTITM",pid,h)
   k ^TMP("dhcpha","SUPP","PRTITM",pid,h)
   q str
}

ClassMethod GetSupplyFlag(pointer) As %String
{
	n (pointer)
	q:$d(^DHCINTR(0,"TypePointer","P",pointer)) 1
	q:$d(^DHCPHSUPPI(0,"POINTER",pointer)) 1
	q 0
}

ClassMethod GetPHOutSupplyNo() As %String
{
	s prefix="S"
	s curdate=$zd(+$h,8)
    l +^DHCPHSUPP:5
    i '$d(^DHCPHSUPPNO("OUTSUPPLYNO",+$h)) d
    .k ^DHCPHSUPPNO("OUTSUPPLYNO")  //清除掉以往的global
    .s stream=1
    .s ^DHCPHSUPPNO("OUTSUPPLYNO",+$h)=2
    e  d
    .s stream=^DHCPHSUPPNO("OUTSUPPLYNO",+$h)
    .s ^DHCPHSUPPNO("OUTSUPPLYNO",+$h)=^DHCPHSUPPNO("OUTSUPPLYNO",+$h)+1
    l -^DHCPHSUPP
    s inno=prefix_curdate_"_"_$tr($j(stream,3)," ","0")
    s suppno=inno
	q suppno
}

ClassMethod SavePHOutSUPPLY(prescno, user, phlocdr) As %String
{
	s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
	q:ord="" -2
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	q:itm="" -3
	s suppno=..GetPHOutSupplyNo()
	s doclocdr=$p(^OEORD(ord,"I",itm,1),"^",3)
	s Basedoclocdr=##Class(web.DHCOutPhCommon).GetBaseOrdUseLocByPresc(prescno)
	i Basedoclocdr'="" s doclocdr=Basedoclocdr
 
	s adm=$p(^OEORD(ord),"^",1)
    s currwarddr=$p(^PAADM(adm),"^",70)
	i currwarddr'="" d
	.s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	.s wardlocdr=ctlocdr
	 
    s PLIST(2)=phlocdr 
    s PLIST(3)=+$h  
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=suppno
    s PLIST(6)=$g(wardlocdr)
    s PLIST(7)=doclocdr
    s PLIST(8)=user
    s type="F"
    s PLIST(9)=type
    &sql(INSERT INTO DHC_PHSUPPLY VALUES PLIST())
    q:SQLCODE'=0 -1
    s supp=+%ROWID
    q supp
}

ClassMethod SavePHOutSUPPLYITM(supp, pointer) As %String
{
	n (supp,pointer)
	
	s PLIST(0)=supp 
    s PLIST(3)=+$o(^DHCPHSUPPI(supp,"I",""),-1)+1 
    s PLIST(2)=pointer
    s PLIST(4)="F"
    &sql(INSERT INTO DHC_PHSUPPLYITM VALUES PLIST())
    q:SQLCODE'=0 -1
    q 0
}

}
