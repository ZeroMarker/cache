Include webimport

IncludeGenerator webimport

Class web.DHCSTDRUGREFUSE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query DrugRefuse(StartDate As %String, EndDate As %String, PhaLocRowid As %String, WardRowid As %String, RegNo As %String, Name As %String, INCIDesc As %String, IncludeStopedItem As %String, DocLoc = "") As %Query(ROWSPEC = "TDate:%String,TTime:%String,TUser:%String,TRegNo:%String,TPaName:%String,TWard:%String,TBed:%String,TCode:%String,TDesc:%String,TQty:%String,TUom:%String,TOrdStatus:%String,TOrdStatusCode:%String,Toedis:%String,TGeneric:%String,TBarcode:%String,TForm:%String,TManf:%String,TPrice:%String,TAmt:%String,TPrescno:%String,TRefuseReason:%String,TSttDate:%String,TSttTime:%String,TEncryptLevel:%String,TPatLevel:%String,Toeori:%String,TDateDosing:%String,TTimeDosing:%String,TPriDesc:%String,TRecLocDesc:%String,TRecLocId:%String")
{
}

ClassMethod DrugRefuseExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PhaLocRowid As %String, WardRowid As %String, RegNo As %String, Name As %String, INCIDesc As %String, IncludeStopedItem As %String, DocLoc = "") As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 d resetvariable
 
 f dd=StartDate:1:EndDate d
 . s stdf=0 
 . f  s stdf=$o(^STDF("DATE",dd,stdf)) q:stdf=""  d
 . . s loc=$p(^STDF(stdf),"^",2) 
 . . q:(PhaLocRowid'="")&&(loc'=PhaLocRowid)
 . . s HospID=""
 . . i loc'="" d
 . . . s HospID=$p($g(^CTLOC(loc)),"^",22)
 . . s dat=$p(^STDF(stdf),"^",4)
 . . i dat'="" s dat=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dat)
 . . s tim=$p(^STDF(stdf),"^",5)
 . . i tim'="" s tim=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tim)
 . . s user=$p(^STDF(stdf),"^",6)
 . . s user=##class(PHA.COM.Data.Base).UserName(user)
 . . s oedis=$p(^STDF(stdf),"^",1)
 . . s dodis=$p(^STDF(stdf),"^",8)
 . . s ord=+$p(^DHCOEDISQTY(dodis),"^",1)
 . . s adm=$p(^OEORD(ord),"^",1)
 . . s admType=$p(^PAADM(adm),"^",2)
 . . s data=$$getoeori(dodis,HospID,loc)
 . . ;b ;1
 . . q:data="" ;zhwh 2005-11-23 add
 . . s regno=$p(data,"^",1)
 . . s panme=$p(data,"^",2)
 . . q:(RegNo'="")&(RegNo'=regno) ;zdm,2007-8-6
 . . q:(Name'="")&(panme'[Name)
 . . s warddesc=$p(data,"^",3)
 . . s EncryptLevelInfo=""
 . . s EncryptLevel=""
 . . s PatLevel="" 
 . . s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 . . i EncryptFlag=1 d
 . . .s papmidr=$p(data,"^",16)
 . . .s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 . . .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 . . .s PatLevel=$p(EncryptLevelInfo,"^",2)
 . . 
 . . i WardRowid'="" q:'$d(^PAWARD(WardRowid))
 . . s tmpwarddesc=""
 . . s tmpwarddesc=##class(PHA.COM.Data.Base).WardDesc(WardRowid)
 . . q:(admType'="E")&&(WardRowid'="")&&(warddesc'=$g(tmpwarddesc))
 . . q:(admType'="E")&&(DocLoc'="")&&(DocLoc'=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(oedis),"^",1))
 . . q:(admType="E")&&(DocLoc'="")&&(DocLoc'=##class(web.DHCSTCOMMONSRV).GetEMLoc(adm))
 . . s bedcode=$p(data,"^",4)
 . . s incicode=$p(data,"^",5)
 . . s incidesc=$p(data,"^",6)
 . . i INCIDesc'="" q:incidesc'=INCIDesc   //仅某品种的药品医嘱  09-01-04
 . . s qty=$p(data,"^",7)
 . . s uomdesc=$p(data,"^",8)
 . . s ordstatus=$p(data,"^",9)
 . . s ordstatuscode=$p(data,"^",10)
 . . s TTimeDosing=$p(^DHCOEDISQTY(dodis),"^",20)   ///分发日期
 . . i TTimeDosing'="" S TTimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TTimeDosing)
 . . s TDateDosing=$p(^DHCOEDISQTY(dodis),"^",21)   ///分发时间
 . . i TDateDosing'="" S TDateDosing=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TDateDosing)
 . . 
 . . S pridesc=$p(##class(PHA.COM.Order).OeoriPriority(oedis), "^", 3)
 . . //缺省不包含<停止>医嘱  09-01-04
 . . ;i IncludeStopedItem'="on" q:ordstatuscode="D" 
 . . 
 . . ;2007-8-6,zdm,增加通用名,剂型,规格,厂家,单价,药品金额，处方号
 . . s inci=$p(data,"^",11)
 . . s TGeneric=$lg(##class(PHA.COM.Drug).GetGeneric(inci),3) //##class(web.DHCSTCOMMONSRV).getGeneric(inci)
 . . s TForm=$lg(##class(PHA.COM.Drug).GetForm(inci),3)
 . . s TBarcode=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
 . . s TManf=$lg(##class(PHA.COM.Drug).GetManf(inci),3)
 . . s TManf=$p(TManf,"-",2)
 . . s TPrice=$p(data,"^",12)
 . . s TAmt=$fn(qty*TPrice,"",2)
 . . s TPrice=$fn(TPrice,"",4)
 . . s TPrescno=$p(data,"^",13)
 . . s reasondr=$p(^STDF(stdf),"^",7)     ;2007-8-14,zdm
 . . s TReason=##class(PHA.COM.Data.Base).STRefuseReasonDesc(reasondr)
 . . 
 . . s TDate=dat
 . . s TTime=tim
 . . s TUser=user
 . . s TRegNo=regno
 . . s TPaName=panme
 . . s TWard=warddesc
 . . i TWard["-" s TWard=$p(TWard,"-",2,$l(TWard,"-"))
 . . s TBed=bedcode
 . . s TCode=incicode
 . . s TDesc=incidesc
 . . s TQty=$fn(qty,"N")
 . . s TUom=uomdesc
 . . s TOrdStatus=ordstatus
 . . s TOrdStatusCode=ordstatuscode
 . . s Toeori=oedis
 . . s TSttDate=$p(data,"^",14)
 . . s TSttTime=$p(data,"^",15)
 . . s TPriDesc=pridesc
 . . s TRecLocId=loc
 . . s TRecLocDesc=##class(PHA.COM.Data.Base).LocDesc(TRecLocId)
 . . i TRecLocDesc["-" s TRecLocDesc=$p(TRecLocDesc,"-",2,$l(TRecLocDesc,"-"))
 . . d outputrow
 .
 . 
 Quit $$$OK
  
outputrow
 set Data=$lb(TDate,TTime,TUser,TRegNo,TPaName,TWard,TBed,TCode,TDesc,TQty,TUom,TOrdStatus,TOrdStatusCode,dodis,TGeneric,TBarcode,TForm,TManf,TPrice,TAmt,TPrescno,$g(TReason),$g(TSttDate),$g(TSttTime),EncryptLevel,PatLevel,Toeori,TDateDosing,TTimeDosing,TPriDesc,TRecLocDesc,TRecLocId)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q
resetvariable
 s (TDate,TTime,TUser,TRegNo,TPaName,TWard,TBed,TCode,TDesc,TQty,TUom,TOrdStatus,TOrdStatusCode,Toedis,TGeneric,TBarcode,TForm,TManf,TPrice,TAmt,TPrescno,TReason,TSttDate,TSttTime,EncryptLevel,PatLevel,Toeori,TDateDosing,TTimeDosing,TPriDesc,TRecLocDesc,TRecLocId)=""
 q
getoeori(dodis,HospID,loc)
 n (dodis,HospID,loc)
 q:dodis="" ""
 s oedis=$p(^DHCOEDISQTY(dodis),"^",1)
 s ord=$P(oedis,"||",1)  q:ord="" ""
 s itm=$P(oedis,"||",2)  q:itm="" ""
 q:'$d(^OEORD(ord,"I",itm)) ""  ;zhwh 07-09-29
 s ordexerowid=$p(^DHCOEDISQTY(dodis),"^",3)
 s sub=$p(ordexerowid,"||",3)
 s orestatusdr=$p(^OEORD(ord,"I",itm,"X",sub,"BILL"),"^",1)  ;医嘱状态
 s ordstatuscode=##class(PHA.COM.Data.Base).OrdStatusCode(orestatusdr)
 s ordstatus=##class(PHA.COM.Data.Base).OrdStatusDesc(orestatusdr)
 s qty=$p(^DHCOEDISQTY(dodis),"^",11)
 s inci=##class(web.DHCSTKUTIL).OrdItmInci(ord_"||"_itm)
 q:inci="" ""
 s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
 s queId=+$o(^PAQUE1(0,"PrescNo",prescno,""))
 //草药按照医嘱项显示
 i $d(^PAQUE1(queId,"DHC")) d
 .s arcimDr=$p($g(^OEORD(ord,"I",itm,1)),"^",2) 
 .q:arcimDr="" 
 .s arcimCode=##class(PHA.COM.Data.Base).ArcimCode(arcimDr)
 .s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcimDr)
 .s Phcdf=##class(PHA.COM.Drug).GetPhcdfByArcim(arcimDr)
 .s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
 .s incicode=arcimCode,incidesc=arcimDesc,uom=phcUomId
 e  d
 .s incicode=##class(PHA.COM.Data.Base).InciCode(inci)
 .s incidesc=##class(PHA.COM.Data.Base).InciDesc(inci)
 .s uom=$p(^INCI(inci,1),"^",10)
 s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uom)
 ;zdm,2007-8-6,单价，处方号
 s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9) 
 s exStr="^"_dodis
 s price=##Class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr) 
 s adm=$p(^OEORD(ord),"^",1)
 s papmi=$P(^PAADM(adm),"^",1)
 &sql(select papmi_no,papmi_name into :regno,:panme from pa_patmas where papmi_rowid=:papmi)
 ;s ward=$P(^PAADM(adm),"^",70)
 s warddesc="",bedcode=""
 s useradddept=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
 s doclocflag=##class(web.DHCSTPCHCOLLSDOCLOC).CheckDocLoc(loc,useradddept)
 s warddesc=""
 s bedcode=""
 s admwardloc=$p(^DHCOEDISQTY(dodis),"^",22),admwardid=""
 i admwardloc'="" d
 .s admwardid=$o(^PAWARD(0,"WARD_LocationDR",admwardloc,""))
 .s bedcode=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm,$s($p(^PAADM(adm),"^",2)'="E":admwardloc,1:"")),"^",2)
 s warddesc=$s(doclocflag'=0:##class(PHA.COM.Data.Base).LocDesc(useradddept),admwardid>0:##class(PHA.COM.Data.Base).WardDesc(admwardid),1:"")
 i $p(^PAADM(adm),"^",2)="E" d
 .s emLoc=##class(web.DHCSTCOMMONSRV).GetEMLoc(adm)
 .s warddesc=##class(PHA.COM.Data.Base).LocDesc(emLoc)
 //增加医嘱开始日期,医嘱开始时间
 s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
 i sttdate'="" s sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate)
 s stttime=$p(^OEORD(ord,"I",itm,1),"^",10)
 i stttime'="" s stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime)
 // 
 s data=regno
 s data=data_"^"_panme
 s data=data_"^"_warddesc
 s data=data_"^"_bedcode
 s data=data_"^"_incicode
 s data=data_"^"_incidesc
 s data=data_"^"_qty
 s data=data_"^"_uomdesc
 s data=data_"^"_ordstatus
 s data=data_"^"_ordstatuscode
 s data=data_"^"_$g(inci)   ;zdm,2007-8-6
 s data=data_"^"_price
 s data=data_"^"_prescno
 s data=data_"^"_sttdate  //09-01-06
 s data=data_"^"_stttime //09-01-06
 s data=data_"^"_papmi
 q data
}

ClassMethod DrugRefuseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DrugRefuseExecute ]
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

ClassMethod DrugRefuseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DrugRefuseExecute ]
{
 Quit $$$OK
}

ClassMethod DeleteRefuse(itmjs As %Library.String = "", itmjsex As %Library.String = "", dodis As %String, userloc As %String = "") As %String
{
 n (itmjs,itmjsex,dodis,userloc)
 q:dodis="" -1
 s OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3)     ;OE_OrdExec表指针 ..
 q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0 -2  ;不可取消拒绝
 s stdfid=$o(^STDF("DODIS",dodis,""),-1)
 q:stdfid="" -2
 s userId=$p(^STDF(stdfid),"^",6)
 s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 s adm=$p(^OEORD(+oeori),"^",1)
 s locid=$p(^STDF(stdfid),"^",2)
 q:(userloc'="")&&(userloc'=locid) -3
 s hospid=$p(^CTLOC(locid),"^",22)
 //s sendportalflag=##class(web.DHCSTCOMMPARA).GetSendPortalFlag(hospid)
 //i sendportalflag=1 d
 //.s ret=##class(web.DHCSTInterfaceFromElse).SaveRefuseForPortal(oeori,"1",adm) //取消拒绝发送数据值portal,yunhaibao20160311
 s sendRet=##class(web.DHCSTInterfaceMessage).SendIPRefuseDisp(dodis,"Cancel",userId)
 &sql(delete from dhc_stdrugrefuse where STDF_DODIS_DR=:dodis)
 s mDspD(dodis) = ""
 d ##class(PHA.IP.COM.Face).UpdateSystemStatus4Dsp(.mDspD, "PHACRCOL", userId)
 q 0
}

Query RefReason() As %SQLQuery(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
 select  rf_rowid,rf_code,rf_desc From dhc_strefusereason
}

ClassMethod UpdateRefReason(rowid As %String, code As %String, desc As %String) As %String
{
 s icode=$$ALPHAUP^SSUTIL4(code)
 s idesc=$$ALPHAUP^SSUTIL4(desc)
 q:icode="" -99
 q:idesc="" -99
 s valFlag=0
 i rowid="" d
 .i $d(^DHCRFREASON(0,"Code",icode)) s valFlag=-1 q
 .i $d(^DHCRFREASON(0,"Desc",idesc)) s valFlag=-2 q
 .&sql(insert into dhc_strefusereason(rf_code,rf_desc) values (:code,:desc) )
 .;&sql(insert into BLC_ReasonForRefund(RFR_Code,RFR_Desc) values (:code,:desc) )
 e  d
 .//i $o(^DHCRFREASON(0,"Code",icode,""))=rowid s valFlag=-1 q
 .//i $o(^DHCRFREASON(0,"Desc",idesc,""))=rowid s valFlag=-2 q
 .s ret=..CheckRefReason(rowid,icode,idesc)
 .s valFlag=ret 
 .q:ret'=0 
 .&sql(update dhc_strefusereason set rf_code=:code,rf_desc=:desc where rf_rowid=:rowid)
 .;&sql(update BLC_ReasonForRefund set RFR_Code=:code,RFR_Desc=:desc where RFR_RowId=:rowid)
 q:valFlag'=0 valFlag
 q:SQLCODE -100
 q %ROWID
}

ClassMethod CheckRefReason(rowid, icode, idesc) As %String
{
  s ret=0
  s orowid=""
  f  s orowid=$o(^DHCRFREASON(0,"Code",icode,orowid)) q:(orowid="")||(ret'=0)  d
  .q:orowid=rowid
  .s ret=-1
  q:ret'=0 ret
  s orowid=""
  f  s orowid=$o(^DHCRFREASON(0,"Desc",idesc,orowid)) q:(orowid="")||(ret'=0)  d
  .q:orowid=rowid
  .s ret=-2  
  q ret
}

ClassMethod DeleteRefReason(rowid As %String) As %String
{
    q:rowid="" 0
    &sql(delete from dhc_strefusereason where rf_rowid=:rowid)
    q:SQLCODE -1
    q 0
}

Query DispRefReason() As %SQLQuery(ROWSPEC = "TReasonDesc:%String,TRowid:%String")
{
 select rf_desc, rf_rowid From dhc_strefusereason
}

ClassMethod Dodis(oeori) As %String
{
 //未发的医嘱批次
 n (oeori)
 q:oeori="" ""
 s ret="",result=""
 f  s ret=$o(^DHCOEDISQTY(0,"OEORI",oeori,ret))  q:ret=""  d
 . q:$p(^DHCOEDISQTY(ret),"^",7)'="TC"  //状态不是"TC"的不考虑
 . i result="" s result=ret
 . e  s result=result_"^"_ret
 q result
}

ClassMethod DodisQty(dodisStr) As %String
{
 //根据dodis串，汇总应发药数量
 n (dodisStr)
 s totalQty=0
 s cnt=$l(dodisStr,"^")
 f i=1:1:cnt d
 . s dodis=$p(dodisStr,"^",i)
 . q:dodis=""
 . q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC" 
 . s qty=$p(^DHCOEDISQTY(dodis),"^",11) 
 . s totalQty=totalQty+qty
 q totalQty
}

Query DrugRefuse2(EpisodeID As %String) As %Query(ROWSPEC = "TDate:%String,TTime:%String,TUser:%String,TRegNo:%String,TPaName:%String,TWard:%String,TBed:%String,TCode:%String,TDesc:%String,TQty:%String,TUom:%String,TOrdStatus:%String,TOrdStatusCode:%String,Toedis:%String,TGeneric:%String,TBarcode:%String,TForm:%String,TManf:%String,TPrice:%String,TAmt:%String,TPrescno:%String,TRefuseReason:%String")
{
}

ClassMethod DrugRefuse2Execute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 //by lq 床位图显示要查的患者拒发药品
 q:EpisodeID="" $$$OK
 s (TDate,TTime,TUser,TRegNo,TPaName,TWard,TBed,TCode,TDesc,TQty,TUom,TOrdStatus,TOrdStatusCode,Toedis)=""
 s StartDate=$p(^PAADM(EpisodeID),"^",6)
 s papmiId=+^PAADM(EpisodeID)
 s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
 s panme=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
 s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
 i curWardId'="" s warddesc=##class(PHA.COM.Data.Base).WardDesc(curWardId)
 i bedSub'="" s bedcode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
 e  s bedcode=""
 s EndDate=+$h
 f dd=StartDate:1:EndDate d
 . s stdf="" 
 . f  s stdf=$o(^STDF("DATE",dd,stdf)) q:stdf=""  d
 . . s oedis=$p(^STDF(stdf),"^",1)
 . .     s ord=$P(oedis,"||",1) q:ord="" 
 . . s itm=$P(oedis,"||",2) q:itm="" 
 . . q:'$d(^OEORD(ord,"I",itm))
 . . q:$p(^OEORD(ord),"^",1)'=EpisodeID
 . . s loc=$p(^STDF(stdf),"^",2) 
 . . s HospID=""
 . . i loc'="" d
 . . s HospID=$p($g(^CTLOC(loc)),"^",22)
 . . s dodis=##class(web.DHCSTKUTIL).GetDODIS(ord_"||"_itm)
 . . s qty=$g(qty)
 . . i dodis'="" s qty=$p( ^DHCOEDISQTY(dodis),"^",11)
 . . s inci=##class(web.DHCSTKUTIL).OrdItmInci(ord_"||"_itm)
 . . q:inci="" 
 . . s incicode=##class(PHA.COM.Data.Base).InciCode(inci)
 . . s incidesc=##class(PHA.COM.Data.Base).InciDesc(inci)
 . . s uom=$p(^INCI(inci,1),"^",10)
 . . s incicode=$g(incicode),incidesc=$g(incidesc),uom=$g(uom)
 . . s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uom)
 . . s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
 . . s TGeneric=$lg(##class(PHA.COM.Drug).GetGeneric(inci),3)
 . . s TForm=$lg(##class(PHA.COM.Drug).GetForm(inci),3)
 . . s TBarcode=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
 . . s TManf=$lg(##class(PHA.COM.Drug).GetManf(inci),3)
 . . s TManf=$p(TManf,"-",2)
 . . //s TPrice=##class(web.DHCSTPCHCOLLS).getprice(inci,sttdate)
 . . s exStr="^"_dodis
 . . s TPrice=##Class(web.DHCSTPRICE).GetSp(inci,sttdate,"",HospID,"",exStr)
 . . s TAmt=$fn(qty*TPrice,"",2)
 . . s TPrice=$fn(TPrice,"",4)
 . . s TPrescno=$p(^OEORD(ord,"I",itm,1),"^",14)
 . . s reasondr=$p(^STDF(stdf),"^",7)     ;2007-8-14,zdm
 . . s TReason=##class(PHA.COM.Data.Base).STRefuseReasonDesc(reasondr)
 . . s TDate=$zd($p(^STDF(stdf),"^",4),3)
 . . s TTime=$zt($p(^STDF(stdf),"^",5))
 . . s TUser=##class(PHA.COM.Data.Base).UserName(+$p(^STDF(stdf),"^",6))
 . . s TRegNo=regno
 . . s TPaName=panme
 . . s TWard=warddesc
 . . s TBed=bedcode
 . . s TCode=incicode
 . . s TDesc=incidesc
 . . s TQty=qty
 . . s TUom=uomdesc
 . . s OrdStatusDR=$p(^OEORD(ord,"I",itm,1),"^",13)
 . . s TOrdStatus=##class(PHA.COM.Data.Base).OrdStatusDesc(OrdStatusDR)
 . . s TOrdStatusCode=##class(PHA.COM.Data.Base).OrdStatusCode(OrdStatusDR)
 . . s Toedis=oedis
 . . d outputrow2
 Quit $$$OK
  
outputrow2
 set Data=$lb(TDate,TTime,TUser,TRegNo,TPaName,TWard,TBed,TCode,TDesc,TQty,TUom,TOrdStatus,TOrdStatusCode,Toedis,TGeneric,TBarcode,TForm,TManf,TPrice,TAmt,TPrescno,$g(TReason))
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q
}

ClassMethod DrugRefuse2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DrugRefuse2Execute ]
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

ClassMethod DrugRefuse2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DrugRefuse2Execute ]
{
 Quit $$$OK
}

ClassMethod GetComID(componentName As %String) As %String
{
    ///取出组件ID,2009-01-04
    ///componentName ：组件名称
    n (componentName)
    &sql(select ID into :comID from websys.component where name=:componentName)
    q:SQLCODE ""
    q $g(comID)
}

ClassMethod LocType(locid As %String) As %String
{
    n (locid)
    q:locid="" ""
    s type=$P($G(^CTLOC(locid)),"^",13)
    q type
}

/// 获取配液拒绝的日期和时间
/// Creator:Liang Qiang
/// Creator:2009-10-12
ClassMethod GetOeOpDate(oeori As %String) As %String
{
    N (oeori)
    S retstr=""
    S grpno=""
    F  s grpno=$O(^PIVA(0,"OEGRP",oeori,grpno)) Q:grpno=""  D
    .S pog=$O(^PIVA(0,"OEGRP",oeori,grpno,""))
    .S poper=$P(^PIVA(pog),"^",8)
    .Q:$P(poper,"^")="N"
    .S podate=$P(^PIVA(pog),"^",13)
    .i podate'="" s podate=$zd(podate,3)
    .S potime=$P(^PIVA(pog),"^",14)
    .i potime'="" s potime=$zt(potime)
    .s retstr=podate_"^"_potime
    Q retstr
}

/// creator:yunhaibao
/// createdate:20160622
/// description:拒发药默认显示的病区
/// others:如果护士登录则默认显示护士所在病区,如果为医生登录则显示为患者当前病区
/// w ##class(web.DHCSTDRUGREFUSE).GetDefaultWard(10,274)
ClassMethod GetDefaultWard(loc, adm)
{
  n (loc,adm)
  q:loc="" ""
  s warddesc="",wardid=""
  i $p(^CTLOC(loc),"^",13)="W" d
  .q:'$d(^PAWARD(0,"WARD_LocationDR",loc)) 
  .s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  .s warddesc=$p(^PAWARD(wardid),"^",2)
  e  d
  .q:adm=""
  .s admwarddr=$p(^PAADM(adm),"^",70)
  .q:admwarddr=""
  .s wardid=admwarddr
  .s warddesc=##class(PHA.COM.Data.Base).WardDesc(wardid)
  q warddesc_"^"_wardid
}

/// 据发药设置默认登录药房
ClassMethod GetDefaultLoc(loc)
{
    s ret="^"
    s loctype=$p($g(^CTLOC(loc)),"^",13)
    q:loctype'="D" ret
    s locdesc=##class(PHA.COM.Data.Base).LocDesc(loc)
    s ret=loc_"^"_locdesc
    q ret
}

}
